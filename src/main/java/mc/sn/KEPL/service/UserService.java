package mc.sn.KEPL.service;

import java.util.Date;

import mc.sn.KEPL.VO.LoginDTO;
import mc.sn.KEPL.VO.UserVO;


public interface UserService {

    UserVO login(LoginDTO loginDTO) throws Exception;

    void keepLogin(String userId, String sessionId, Date sessionLimit) throws Exception;

    UserVO checkLoginBefore(String value) throws Exception;

    void register(UserVO userVO) throws Exception;

    // 회원정보 수정처리
    public void modifyUser(UserVO userVO) throws Exception;

    // 회원 정보
    public UserVO getUser(String uid) throws Exception;

    // 회원비밀번호 수정처리
    public void modifyPw(UserVO userVO) throws Exception;

    // 회원 프로필 사진 수정
    public void modifyUimage(String uid, String uimage) throws Exception;


    //868085821717-eu3i9094vv721l8jfl1bi4id4jsitaue.apps.googleusercontent.com
    //MRxEM1tPJWuJJiY3DNZs_xnh
}