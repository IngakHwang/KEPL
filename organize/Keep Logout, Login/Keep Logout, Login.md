---
title: '로그아웃, 로그인 유지 기능'
created: '2021-12-22T02:14:22.614Z'
modified: '2021-12-22T02:15:21.220Z'
---

# 로그아웃, 로그인 유지 기능

로그인 유지 기능을 구현하기 위해서는 Cookie를 사용한다. 사용자가 로그인한 후 Cookie를 생성하고 브라우저에게 전송하며, 다시 서버에 접속할 때 Cookie가 전달되어야한다.

### 1-1.loginInterceptor
loginInterceptor에 있는 postHandle 메소드를 통해 HttpSession에 UserVO객체를 저장한다. 이 부분 중간에 Cookie를 생성하고 HttpServletresponse에 담아 전송하도록 한다.
```java
@Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
    	logger.info("postHandle ");
        HttpSession httpSession = request.getSession();
        ModelMap modelMap = modelAndView.getModelMap();
        Object userVO =  modelMap.get("user");
        if (userVO != null) {
            logger.info("new login success");
            httpSession.setAttribute(LOGIN, userVO);
            //response.sendRedirect("/");
            
            if (request.getParameter("useCookie") != null) {
                logger.info("remember me...");
                // 쿠키 생성
                Cookie loginCookie = new Cookie("loginCookie", httpSession.getId());
                loginCookie.setPath("/");
                loginCookie.setMaxAge(60*60*24*7);
                // 전송
                response.addCookie(loginCookie);
            }

            Object destination = httpSession.getAttribute("destination");
            response.sendRedirect(destination != null ? (String) destination : "/home");
        }

    }
```
### 1-2.로그인 유지를 위한 DB설정
자동로그인은 Session과 Cookie를 이용해 처리한다. 로그인 유지기능이 사용되는 경우는

> 1. HttpSession에 login이란 이름으로 보관된 객체가 없지만 loginCookie가 존재하고, 
> 2. 이 경우 Interceptor에서 설정한 7일의 기간 사이에 접속한 적이 있다는 걸 확인한 뒤,
> 3. 과거의 로그인 시점에 기록된 정보를 이용해 다시 HttpSession에 login이라는 이름으로 UserVO객체를 보관해주어야 한다.


이런 개념을 바탕으로 User가 loginCookie를 가지고 있다면, 그 값이 과거 로그인한 시점의 SessionId라는 것을 알 수 있으며, loginCookie값을 사용해 DB에서 UserVO의 정보를 읽어온 뒤 이를 HttpSession에 보관하도록 한다.

User테이블에 이와 관련한 컬럼은 session_key, session_limit 이다.

UserDAO 인터페이스에 Sessionkey와 sessionLimit를 업데이트하는 메소드와 loginCookie에 기록된 값으로 사용자의 정보를 조회하는 메서드를 추가하고, userDAOImpl에서 구현한다.

UserDAO
```java
// 로그인 유지 처리
    void keepLogin(String userId, String sessionId, Date sessionLimit) throws Exception;

    // 세션키 검증
    UserVO checkUserWithSessionKey(String value) throws Exception;
```

UserDAOImpl
```java
// 로그인 유지 처리
    @Override
    public void keepLogin(String userId, String sessionId, Date sessionLimit) throws Exception {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("userId", userId);
        paramMap.put("sessionId", sessionId);
        paramMap.put("sessionLimit", sessionLimit);

        sqlSession.update(NAMESPACE + ".keepLogin", paramMap);
    }

    // 세션키 검증
    @Override
    public UserVO checkUserWithSessionKey(String value) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".checkUserWithSessionKey", value);
    }
```

userMapper.xml
```java
 <update id="keepLogin">
        UPDATE tb_user
        SET session_key = #{sessionId}
            , session_limit = #{sessionLimit}
        WHERE user_id = #{userId}
    </update>

    <select id="checkUserWithSessionKey" resultMap="userVOResultMap">
        SELECT
            *
        FROM tb_user
        WHERE session_key = #{value}
    </select>
```

### 1-4.Service 계층 작성
UserService 인터페이스에 로그인 유지 메소드와 loginCookie로 회원정보를 조회하는 메소드를 추가하고 UserServiceImpl 클래스에서 구현한다.

UserService
```java
void keepLogin(String userId, String sessionId, Date sessionLimit) throws Exception;

    UserVO checkLoginBefore(String value) throws Exception;
```
UserServiceImpl
```java
 @Override
    public void keepLogin(String userId, String sessionId, Date sessionLimit) throws Exception {
        userDAO.keepLogin(userId, sessionId, sessionLimit);
    }

    @Override
    public UserVO checkLoginBefore(String value) throws Exception {
        return userDAO.checkUserWithSessionKey(value);
    }
```

### 1-5. UserLoginController
UserLoginController의 loginPost 매핑 메소드
```java
// 로그인 처리
    @RequestMapping(value = "/loginPost", method = RequestMethod.POST)
    public void loginPOST(LoginDTO loginDTO, HttpSession httpSession, Model model) throws Exception {

        UserVO userVO = userService.login(loginDTO);

        if (userVO == null || !BCrypt.checkpw(loginDTO.getUserPw(), userVO.getUserPw())) {
            return;
        }
        logger.info("Before model add login Post");
        
        userService.login(loginDTO);
        model.addAttribute("user", userVO);
        logger.info("login Post"+userVO.toString());
        
        //로그인 유지를 선택할 경우
        if (loginDTO.isUseCookie()) {
            int amount = 60 * 60 * 24 * 7;  // 7일
            Date sessionLimit = new Date(System.currentTimeMillis() + (1000 * amount)); // 로그인 유지기간 설정
            userService.keepLogin(userVO.getUserId(), httpSession.getId(), sessionLimit);
        }
    }
```
### 1-6. 로그인 유지를 위한 Interceptor 
interceptor를 통해 사용자가 접속할 경우 로그인이 유지되도록 한다.

RememberMeInterceptor
```java
public class RememberMeInterceptor extends HandlerInterceptorAdapter {

    private static final Logger logger = LoggerFactory.getLogger(RememberMeInterceptor.class);

    @Inject
    private UserService userService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HttpSession httpSession = request.getSession();
        Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
        if (loginCookie != null) {
            UserVO userVO = userService.checkLoginBefore(loginCookie.getValue());
            if (userVO != null)
                httpSession.setAttribute("login", userVO);
        }

        return true;
    }
}
```

servlet-context.xml에 위 클래스를 interceptor로 스프링이 인식할 수 있도록 설정을 추가한다.
```xml
	<beans:bean id="rememberMeInterceptor" class="mc.sn.KEPL.interceptor.RememberMeInterceptor"/>

 <interceptor>
            <mapping path="/**/"/>
            <beans:ref bean="rememberMeInterceptor"/>
        </interceptor>
```
이렇게 하면 로그인 유지를 체크해서 로그인한 뒤, 브라우저를 종료하고 다시 접속해도 로그인이 유지된다.

### 2. 로그아웃 기능
로그아웃 처리는 UserLoginController에서 login과 같이 저장된 정보를 삭제하고 invalidate()를 해주는 작업과 쿠키의 유효시간을 만료시키는 작업을 하면 된다.

UserLoginController
```java
// 로그아웃 처리
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest request,
                         HttpServletResponse response,
                         HttpSession httpSession) throws Exception {

        Object object = httpSession.getAttribute("login");
        if (object != null) {
            UserVO userVO = (UserVO) object;
            httpSession.removeAttribute("login");
            httpSession.invalidate();
            Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
            if (loginCookie != null) {
                loginCookie.setPath("/");
                loginCookie.setMaxAge(0);
                response.addCookie(loginCookie);
                userService.keepLogin(userVO.getUserId(), "none", new Date());
            }
        }

        return "/user/logout";
    }
```

logout.jsp
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<script>
    alert("로그아웃 되었습니다.");
    self.location = "/home";
</script>
</body>
</html>
```
로그아웃 알림 메세지와 메인 페이지로 이동하는 코드를 작성한다.

### 3. 로그인 상태에서의 로그인 페이지, 회원가입 페이지 접근 제한
로그인 상태에서는 더이상 로그인을 할 필요가 없고, 회원가입 역시 필요가 없기 때문에 로그인 했을 경우 회원가입과 로그인에 제한을 해준다.
LoginAfterInterceptor를 생성하고 preHandle메소드를 작성한다.
loginAfterInterceptor
```java
public class LoginAfterInterceptor extends HandlerInterceptorAdapter {

    private static final Logger logger = LoggerFactory.getLogger(LoginAfterInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        // 로그인 처리후 로그인페이지 or 회원가입 페이지로 이동할 경우
        HttpSession session = request.getSession();
        if (session.getAttribute("login") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }
}
```
위 클래스를 Interceptor로 인식할 수 있도록 servlet-context.xml에 설정해준다.
```xml
	<beans:bean id="loginAfterInterceptor" class="mc.sn.KEPL.interceptor.LoginAfterInterceptor"/>

 <interceptor>
            <mapping path="/user/login"/>
            <mapping path="/user/register"/>
            <beans:ref bean="loginAfterInterceptor"/>
        </interceptor>
```
