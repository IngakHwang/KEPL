package mc.sn.KEPL.service;

import java.util.Date;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import mc.sn.KEPL.DAO.UserDAO;
import mc.sn.KEPL.VO.LoginDTO;
import mc.sn.KEPL.VO.UserVO;



@Service
public class UserServiceImpl implements UserService {

    private final UserDAO userDAO;

    
    @Inject
    public UserServiceImpl(UserDAO userDAO) {
        this.userDAO = userDAO;
    }
    @Override
    public UserVO login(LoginDTO loginDTO) throws Exception {
    	userDAO.updateLoginDate(loginDTO.getUserId());
        return userDAO.login(loginDTO);
    }

    @Override
    public void keepLogin(String userId, String sessionId, Date sessionLimit) throws Exception {
        userDAO.keepLogin(userId, sessionId, sessionLimit);
    }

    @Override
    public UserVO checkLoginBefore(String value) throws Exception {
        return userDAO.checkUserWithSessionKey(value);
    }

    @Override
    public void register(UserVO userVO) throws Exception {
        userDAO.register(userVO);
    }

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

}