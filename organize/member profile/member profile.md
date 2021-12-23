---
title: 회원 프로필 설정
created: '2021-12-22T02:37:18.153Z'
modified: '2021-12-22T02:37:20.555Z'
---

# 회원 프로필 설정

### 1. 회원정보 Persistence 계층 작성
회원정보 수정 처리 내용을 위해 UserDAO인터페이스에 추상메소드 추가, UserDAOImpl클래스에 메소드들을 오버라이딩하여 구현

UserDAO
```java
// 회원정보 수정처리
    public void updateUser(UserVO userVO) throws Exception;

    // 회원 비밀번호
    public UserVO getUser(String uid) throws Exception;

    // 회원비밀번호 수정처리
    public void updatePw(UserVO userVO) throws Exception;

    // 회원 프로필 사진 수정
    public void updateUimage(String uid, String uimage) throws Exception;
```
UserDAOImpl
```java
// 회원 비밀번호
    @Override
    public UserVO getUser(String userId) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".getUser", userId);
    }

    // 회원정보 수정처리
    @Override
    public void updateUser(UserVO userVO) throws Exception {
        sqlSession.update(NAMESPACE + ".updateUser", userVO);
    }

    // 회원비밀번호 수정처리
    @Override
    public void updatePw(UserVO userVO) throws Exception {
        sqlSession.update(NAMESPACE + ".updatePw", userVO);
    }

    // 회원 프로필 사진 수정
    @Override
    public void updateUimage(String userId, String userImg) throws Exception {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("userId", userId);
        paramMap.put("userImg", userImg);
        sqlSession.update(NAMESPACE + ".updateUimage", paramMap);
    }
```
UserMapper.xml
```xml
 <!--회원 정보 수정-->
    <update id="updateUser">
        UPDATE tb_user
        SET
            user_name = #{userName}
            , user_email =  #{userEmail}
        WHERE user_id = #{userId}
    </update>

    <!--회원 비밀번호-->
    <select id="getUser" resultMap="userVOResultMap">
        SELECT *
        FROM tb_user
        WHERE user_id = #{userId}
    </select>

    <!--회원비밀번호 수정-->
    <update id="updatePw">
        UPDATE tb_user
        SET
            user_pw = #{userPw}
        WHERE user_id = #{userId}
    </update>

    <!--회원 프로필 이미지 변경-->
    <update id="updateUimage" >
        UPDATE tb_user
        SET
            user_img = #{userImg}
        WHERE user_id = #{userId}
    </update>
```

### 2. Service 계층
UserService
```java
// 회원정보 수정처리
    public void modifyUser(UserVO userVO) throws Exception;

    // 회원 정보
    public UserVO getUser(String uid) throws Exception;

    // 회원비밀번호 수정처리
    public void modifyPw(UserVO userVO) throws Exception;

    // 회원 프로필 사진 수정
    public void modifyUimage(String uid, String uimage) throws Exception;
```

UserServiceImpl
```java
// 회원 비밀번호
    @Override
    public UserVO getUser(String userId) throws Exception {
        return userDAO.getUser(userId);
    }

    // 회원정보 수정처리
    @Override
    public void modifyUser(UserVO userVO) throws Exception {
        userDAO.updateUser(userVO);
    }

    // 회원비밀번호 수정처리
    @Override
    public void modifyPw(UserVO userVO) throws Exception {
        userDAO.updatePw(userVO);
    }

    // 회원 프로필 사진 수정
    @Override
    public void modifyUimage(String userId, String userImg) throws Exception {
        userDAO.updateUimage(userId, userImg);
    }
```

### 3. UserInfoController
회원정보 처리만을 매핑하는 컨트롤러를 따로 만들어 사용한다.

uimagePath
회원 이미지 변경시에도 파일 업로드와 같이 서버에 파일을 전송하고 출력해주어야하기 때문에 파일업로드 당싱 첨부파일 저장 경로를 설정해주었던 것처럼 회원 이미지를 저장하기위한 경로를 설정해주어야한다.

UserInfoController
```java
@Controller
@RequestMapping("/user")
public class UserInfoController {
	
	private static final Logger logger = LoggerFactory.getLogger(UserInfoController.class);
	
	@Inject
    private UserService userService;

    @Inject
    private ArticleService articleService;

    @Inject
    private ReplyService replyService;

	
	@Resource(name = "uimagePath")
    private String uimagePath;
	
	// 회원 프로필 이미지 수정처리
    @RequestMapping(value = "/modify/image", method = RequestMethod.POST)
    public String userImgModify(String userId,
                                MultipartFile file,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) throws Exception {
        if (file == null) {
            redirectAttributes.addFlashAttribute("msg", "FAIL");
            return "redirect:/user/profile";
        }
        String uploadFile = UploadFileUtils.uploadFile(uimagePath, file.getOriginalFilename(), file.getBytes());
        System.out.println("업로드 파일 : "+uploadFile);
        String front = uploadFile.substring(0, 12);
        String end = uploadFile.substring(14);
        String userImg = front + end;
        userService.modifyUimage(userId, userImg);
        Object userObj = session.getAttribute("login");
        UserVO userVO = (UserVO) userObj;
        userVO.setUserImg(userImg);
        session.setAttribute("login", userVO);
        redirectAttributes.addFlashAttribute("msg", "SUCCESS");
        return "redirect:/user/profile";
    }

    // 회원정보 수정처리
    @RequestMapping(value = "/modify/info", method = RequestMethod.POST)
    public String userInfoModify(UserVO userVO, HttpSession session,
                                 RedirectAttributes redirectAttributes) throws Exception {
    	logger.info(userVO.toString());
        UserVO oldUserInfo = userService.getUser(userVO.getUserId());
        logger.info(oldUserInfo.toString());
        logger.info("1");
        if (!BCrypt.checkpw(userVO.getUserPw(), oldUserInfo.getUserPw())) {
            redirectAttributes.addFlashAttribute("msg", "FAILURE");
            logger.info("2");
            return "redirect:/user/profile";
        }
        logger.info("3");
        userService.modifyUser(userVO);
        userVO.setUserJoinDate(oldUserInfo.getUserJoinDate());
        userVO.setUserLoginDate(oldUserInfo.getUserLoginDate());
        userVO.setUserImg(oldUserInfo.getUserImg());
        session.setAttribute("login", userVO);
        redirectAttributes.addFlashAttribute("msg", "SUCCESS");
        return "redirect:/user/profile";
    }

    // 회원 비밀번호 수정처리
    @RequestMapping(value = "/modify/pw", method = RequestMethod.POST)
    public String userPwModify(@RequestParam("userId") String userId,
                               @RequestParam("oldPw") String oldPw,
                               @RequestParam("newPw") String newPw,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) throws Exception {
        UserVO userInfo = userService.getUser(userId);
        if (!BCrypt.checkpw(oldPw, userInfo.getUserPw())) {
            redirectAttributes.addFlashAttribute("msg", "FAILURE");
            return "redirect:/user/profile";
        }
        String newHashPw = BCrypt.hashpw(newPw, BCrypt.gensalt());
        userInfo.setUserPw(newHashPw);
        userService.modifyPw(userInfo);
        session.setAttribute("login", userInfo);
        redirectAttributes.addFlashAttribute("msg", "SUCCESS");
        return "redirect:/user/profile";
    }

 // 회원 정보 페이지
    @RequestMapping(value = "/profile", method = RequestMethod.GET)
    public String profile(HttpSession session, Model model) throws Exception {

        Object userObj = session.getAttribute("login");
        UserVO userVO = (UserVO) userObj;
        String userId = userVO.getUserId();
        List<ArticleVO> userBoardList = articleService.userBoardList(userId);
        List<ReplyVO> userReplies = replyService.userReplies(userId);

        model.addAttribute("userBoardList", userBoardList);
        model.addAttribute("userReplies", userReplies);

        return "user/profile";
    }
}
```
root-context.xml
```xml
<!--프로필 이미지 파일 저장 경로 설정-->
    <bean id="uimagePath" class="java.lang.String">
        <constructor-arg value="C:\\Users\\USER\\eclipse-workspace\\KEPL\\src\\main\\webapp\\resources\\dist\\img\\profile">
        </constructor-arg>
    </bean>
```

### 4. 회원게시물 정보
회원정보 페이지에서는 로그인한 회원이 작성한 글의 목록을 확인가능하고, 회원이 작성한 댓글 또한 확인할 수 있어야 한다.
회원이 작성한 게시글 목록을 가져오기 위해 게시글의 Persistance 계층과 Service 계층, 컨트롤러에 아래 내용을 추가한다.

ArticleDAO
```java
// 회원이 작성한 게시글 목록
    List<ArticleVO> userBoardList(String userId) throws Exception;
    
    void updateWriterImg(ArticleVO articleVO) throws Exception;
```
ArticleDAOImpl
```java
// 회원이 작성한 게시글 목록
    @Override
    public List<ArticleVO> userBoardList(String userId) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".userBoardList", userId);
    }

// 회원 프로필 사진 수정
    @Override
    public void updateWriterImg(ArticleVO articleVO) throws Exception {
        sqlSession.update(NAMESPACE + ".updateWriterImg", articleVO);
    }
```

AtricleService
```java
	List<ArticleVO> userBoardList(String uid) throws Exception;

```
ArticleServieImpl
```java
// 회원이 작성한 게시글 목록
    @Override
    public List<ArticleVO> userBoardList(String uid) throws Exception {
        return articleDAO.userBoardList(uid);
    }
```

### 5. 회원 댓글 정보
ReplyDAO
```java
// 회원이 작성한 댓글 목록 
List<ReplyVO> userReplies(String userId) throws Exception;
```
ReplyDAOImpl
```java
// 회원이 작성한 댓글 목록 
@Override public List<ReplyVO> userReplies(String userId) throws Exception { return sqlSession.selectList(NAMESPACE + ".userReplies", userId); }
```

### 6. 로그인 일자 갱신
다시 로그인하면 로그인 일자가 갱신된다.

UserDAO
```java
// UserDAO
// 로그인 일자 갱신 
public void updateLoginDate(String userId) throws Exception;
```
UserDAOImpl
```java
// UserDAOImpl 
// 로그인 일자 갱신 
@Override public void updateLoginDate(String userId) throws Exception { sqlSession.update(NAMESPACE + ".updateLoginDate", userId); }
```
userMapper.xml
```xml
<!--로그인 일자 갱신--> 
<update id="updateLoginDate"> UPDATE tb_user SET user_login_date = NOW() WHERE user_id = #{userId} </update>
```
userServiceImpl
```java
// UserServiceImpl 
@Override public UserVO login(LoginDTO loginDTO) throws Exception { userDAO.updateLoginDate(loginDTO.getUserId()); // 추가 
return userDAO.login(loginDTO); }
```


