---
title: '회원가입, 로그인 기능'
created: '2021-12-21T00:48:17.030Z'
modified: '2021-12-21T08:17:25.889Z'
---

# 회원가입, 로그인 기능
## HttpSession 객체 이용한 로그인 구현
### 회원가입 기능

1. User 테이블 생성
회원가입 기능을 위한 User 테이블 tb_user를 생성한다
```java
CREATE TABLE `tb_user` (
  `user_id` varchar(50) NOT NULL,
  `user_pw` varchar(100) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_point` int NOT NULL DEFAULT '0',
  `session_key` varchar(50) NOT NULL DEFAULT 'none',
  `session_limit` timestamp NULL DEFAULT NULL,
  `user_img` varchar(100) NOT NULL DEFAULT 'user/default-user.png',
  `user_join_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_login_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_signature` varchar(200) NOT NULL DEFAULT 'hello...',
  PRIMARY KEY (`user_id`)
)
```
2. UserVO 생성
```java
public class UserVO {

    private String userId;
    private String userPw;
    private String userName;
    private String userEmail;
    private Date userJoinDate;
    private Date userLoginDate;
    private String userSignature;
    private String userImg;
    private int userPoint;
    
    //getter, setter, toString 추가
    }
```

3. Persistence 구현
DAO폴더에 UserDAO 인터페이스와 UserDAOImpl 클래스 생성
UserDAO인터페이스에 추상메소드 정의하고 UserDAOImpl클래스에서 구현

```java
public interface UserDAO { // 회원가입 처리 void register(UserVO userVO) throws Exception; }

```

```java
package mc.sn.KEPL.DAO;
import javax.inject.Inject;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class UserDAOImpl implements UserDAO {

    private static final String NAMESPACE = "mc.sn.KEPL.mappers.user.UserMapper";

    private final SqlSession sqlSession;
    
    @Inject public UserDAOImpl(SqlSession sqlSession) { this.sqlSession = sqlSession; } 
    // 회원가입처리
    @Override public void register(UserVO userVO) throws Exception { sqlSession.insert(NAMESPACE + ".register", userVO); } 
    }


```
src/main/resources/mappers/user/ 경로에 userMapper.xml 생성하고, 회원가입을 위한 SQL문을 작성한다.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="mc.sn.KEPL.mappers.user.UserMapper">
  
  <insert id="register">
        INSERT INTO tb_user (
            user_id
            , user_pw
            , user_name
            , user_email
        ) VALUES (
            #{userId}
            , #{userPw}
            , #{userName}
            , #{userEmail}
        )
    </insert>
</mapper>
```

4. Service 계층 구현
src/main/java/service 경로에 UserService 인터페이스와 UserServiceImpl 클래스 생성한다.
Service 인터페이스에 회원가입을 위한 추상메소드를 정의하고, UserServiceImpl 클래스에서 구현한다.

UserService
```java
public interface UserService {
	void register(UserVO userVO) throws Exception;
  }
```

UserServiceImpl
```java
package mc.sn.KEPL.service;

import java.util.Date;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    private final UserDAO userDAO;
    @Inject
    public UserServiceImpl(UserDAO userDAO) {
        this.userDAO = userDAO;
    }
    
    @Override
    public void register(UserVO userVO) throws Exception {
        userDAO.register(userVO);
    }
    
}
  
```
5. UserController
src/main/java/controller 경로에 UserRegisterController를 생성하고 회원가입 페이지, 가입처리 컨트롤러를 만든다.

```java
package mc.sn.KEPL.controller;

import javax.inject.Inject;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import mc.sn.KEPL.VO.UserVO;
import mc.sn.KEPL.service.UserService;

@Controller
@RequestMapping("/user")
public class UserRegisterController {

    private final UserService userService;

    @Inject
    public UserRegisterController(UserService userService) {
        this.userService = userService;
    }

    // 회원가입 페이지
    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String registerGET() throws Exception {
        return "/user/register";
    }

    // 회원가입 처리 매핑 메소드
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String registerPOST(UserVO userVO, RedirectAttributes redirectAttributes) throws Exception {

        String hashedPw = BCrypt.hashpw(userVO.getUserPw(), BCrypt.gensalt());
        userVO.setUserPw(hashedPw);
        userService.register(userVO);
        redirectAttributes.addFlashAttribute("msg", "REGISTERED");

        return "redirect:/user/login";
    }
```

regiserPost()는 회원가입 처리 매핑 메소드이다.
파라미터로 넘어온 회원의 객체정보(UserVO) 중에서 비밀번호(userPw)를 암호화하는 작업을 수행한다. 
이렇게 하면 DB에 암호화해서 보관할 수 있어 보안에 안전하다.
BCrypt.hashpw()는
첫번째 파라미터 - 암호화할 비밀번호
두번째 파라미터 - BCrypt.gensalt()를 받고 암호화한 비밀번호를 반환해준다.
이렇게 암호화된 비밀번호를 다시 회원객체에 저장, 서비스의 회원가입 메서드를 호출한다.

BCrypt를 사용하기 위해서 pom.xml에 라이브러리를 추가한다.
```xml
<!--비밀번호 암호화 --> <!-- https://mvnrepository.com/artifact/org.mindrot/jbcrypt --> <dependency> <groupId>org.mindrot</groupId> <artifactId>jbcrypt</artifactId> <version>0.4</version> </dependency>
```

6. register.jsp와 login.jsp 생성 (KEPL 프로젝트 참고)

7. 로그인 처리를 위한 LoginDTO 클래스 생성한다. 로그인 화면으로부터 전달되는 회원의 데이터를 수집하기 위함이다.
```java
package mc.sn.KEPL.VO;

public class LoginDTO {

    private String userId;
    private String userPw;
    private boolean useCookie;
    
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}
	public boolean isUseCookie() {
		return useCookie;
	}
	public void setUseCookie(boolean useCookie) {
		this.useCookie = useCookie;
	}
    
	@Override
    public String toString() {
        return "LoginDTO{" +
                "userId='" + userId + '\'' +
                ", userPw='" + userPw + '\'' +
                ", useCookie=" + useCookie +
                '}';
    }

}
```

8. 회원가입 처리, 로그인 처리를 위한 계층 구현
UserDAO 인터페이스, UserDAOImpl 클래스에 회원가입, 로그인 처리를 위한 메소드를 정의 구현한다.

UserDAO
```java
public interface UserDAO { // 회원가입 처리 void register(UserVO userVO) throws Exception; // 로그인 처리 UserVO login(LoginDTO loginDTO) throws Exception; }
```

UserDAOImpl
```java
//회원가입처리
@Override
    public void register(UserVO userVO) throws Exception {
        sqlSession.insert(NAMESPACE + ".register", userVO);
    }
 // 로그인 처리
    @Override
    public UserVO login(LoginDTO loginDTO) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".login", loginDTO);
    }
```
userMapper.xml에 login sql문 작성한다.
```xml
<select id="login" resultMap="userVOResultMap">
        SELECT
          *
        FROM tb_user
        WHERE user_id = #{userId}
    </select>
```

9. Service 계층 구현

UserService
```java
public interface UserService { // 회원 가입 처리 void register(UserVO userVO) throws Exception; // 로그인 처리 UserVO login(LoginDTO loginDTO) throws Exception; }
```

UserServiceImpl
```java
//로그인 처리
@Override
    public UserVO login(LoginDTO loginDTO) throws Exception {
    	userDAO.updateLoginDate(loginDTO.getUserId());
        return userDAO.login(loginDTO);
    }
```

10. UserController
컨트롤러에 로그인 컨트롤러를 따로 만든다. UserLoginController 생성한다.
```java
package mc.sn.KEPL.controller;

import java.util.Date;

import javax.inject.Inject;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.util.WebUtils;

import mc.sn.KEPL.VO.LoginDTO;
import mc.sn.KEPL.VO.UserVO;
import mc.sn.KEPL.service.UserService;

@Controller
@RequestMapping("/user")
public class UserLoginController {

    private final UserService userService;
 
    private static final Logger logger = LoggerFactory.getLogger(UserLoginController.class);
    
    @Inject
    public UserLoginController(UserService userService) {
        this.userService = userService;
    }

    // 로그인 페이지
    @RequestMapping(value = "/login", method =  RequestMethod.GET)
    public String loginGET(@ModelAttribute("loginDTO") LoginDTO loginDTO) {
 
    	return "/user/login";
    }

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
        
        if (loginDTO.isUseCookie()) {
            int amount = 60 * 60 * 24 * 7;  // 7일
            Date sessionLimit = new Date(System.currentTimeMillis() + (1000 * amount)); // 로그인 유지기간 설정
            userService.keepLogin(userVO.getUserId(), httpSession.getId(), sessionLimit);
        }
    }
}
```

11. 로그인 Interceptor 클래스 작성, 설정
HttpSession과 관련한 작업을 인터셉터에서 설정해준다.

```java
public class LoginInterceptor extends HandlerInterceptorAdapter {

    private static final String LOGIN = "login";
    private static final Logger logger = LoggerFactory.getLogger(LoginInterceptor.class);

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

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HttpSession httpSession = request.getSession();
        // 기존의 로그인 정보 제거
        if (httpSession.getAttribute(LOGIN) != null) {
            logger.info("clear login data before");
            httpSession.removeAttribute(LOGIN);
        }

        return true;
    }
}
```

postHandle()메서드는 httpSession에 컨트롤러에서 저장한 user를 저장하고 /로 리다이렉트한다.
preHandle()메서드는 기존의 로그인 정보가 있을 경우 초기화하는 역할을 수행한다. 
인터셉터로 인식시키기 위해 아래와 같이 servlet-context에 추가한다.
```xml
	<beans:bean id="loginInterceptor" class="mc.sn.KEPL.interceptor.LoginInterceptor"/>
<interceptors>
        <interceptor>
            <mapping path="/user/loginPost"/>
            <beans:ref bean="loginInterceptor"/>
        </interceptor>
</interceptors>
```

12. 로그인 결과 화면 - 만약 회원정보가 없거나 비밀번호가 불일치하면 loginPost.jsp로 이동하여 로그인페이지로 다시 이동하게 처리
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <script>
        alert("아이디와 비밀번호를 확인해주세요.");
        self.location = "/user/login";
    </script>
</body>
</html>
```
13. 로그인 권한 위한 AuthInterceptor 클래스 작성
로그인이 되어있지 않다면 글쓰기를 사용할 수 없게 한다.
```java
public class AuthInterceptor extends HandlerInterceptorAdapter { 

	private static final Logger logger = LoggerFactory.getLogger(AuthInterceptor.class); 
	@Override 
   	 public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception { 
   	 HttpSession httpSession = request.getSession(); 
	if (httpSession.getAttribute("login") == null) { 
	logger.info("current user is not logged"); 
	response.sendRedirect("/mypage/user/login"); 
    return false;
	} 
	return true; 
	} 
}
```
prehandle()메소드는 현재 사용자의 로그인 여부를 확인하고 컨트롤러를 호출할 것인지 결정한다. 로그인하지 않은 사용자라면 로그인 페이지로 리다이렉트하게 처리한다.
servlet-context
```xml
	<beans:bean id="authInterceptor" class="mc.sn.KEPL.interceptor.AuthInterceptor"/>
<interceptor>
            <mapping path="/article/search/write"/>
            <mapping path="/article/search/modify"/>
            <mapping path="/article/search/remove"/>
            <mapping path="/user/info"/>
            <beans:ref bean="authInterceptor"/>
        </interceptor>
```
사용자가 비로그인 상태에서 글쓰기를 시도할 경우 로그인 페이지로 이동한다. 사용자가 원하던 페이지를 보관하고, 로그인 성공 후 해당 페이지로 이동시켜주는 메소드를 생성한다.
AuthInterceptor
```java
public class AuthInterceptor extends HandlerInterceptorAdapter {

    private static final Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);

    // 페이지 요청 정보 저장
    private void saveDestination(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String query = request.getQueryString();
        if (query == null || query.equals("null")) {
            query = "";
        } else {
            query = "?" + query;
        }

        if (request.getMethod().equals("GET")) {
            logger.info("destination : " + (uri + query));
            request.getSession().setAttribute("destination", uri + query);
        }
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HttpSession httpSession = request.getSession();

        if (httpSession.getAttribute("login") == null) {
            logger.info("current user is not logged");
            saveDestination(request);
            response.sendRedirect("/user/login");
            return false;
        }

        return true;
    }
}
```
위에서 saveDestination 메소드는 말 그대로 목적지의 페이지 정보를 저장해두는 함수이다.


