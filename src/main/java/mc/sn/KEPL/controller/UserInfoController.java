package mc.sn.KEPL.controller;



import java.util.List;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import mc.sn.KEPL.VO.ArticleVO;
import mc.sn.KEPL.VO.ReplyVO;
import mc.sn.KEPL.VO.UserVO;
import mc.sn.KEPL.service.ArticleService;
import mc.sn.KEPL.service.ReplyService;
import mc.sn.KEPL.service.UserService;
import mc.sn.KEPL.util.UploadFileUtils;
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