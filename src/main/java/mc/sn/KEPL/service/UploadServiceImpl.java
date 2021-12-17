package mc.sn.KEPL.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import mc.sn.KEPL.DAO.UploadDAO;

@Service
public class UploadServiceImpl implements UploadService {

    @Inject
    private UploadDAO uploadDAO;

    // 게시글 첨부파일 조회
    @Override
    public List<String> getAttach(Integer article_no) throws Exception {
        return uploadDAO.getAttach(article_no);
    }

    // 게시글 첨부파일 삭제
    @Override
    public void deleteAttach(String fullName) throws Exception {
        uploadDAO.deleteAttach(fullName);
    }

    // 특정 게시글의 첨부파일 갯수 갱신
    @Override
    public void updateAttachCnt(Integer article_no) throws Exception {
        uploadDAO.updateAttachCnt(article_no);
    }
}