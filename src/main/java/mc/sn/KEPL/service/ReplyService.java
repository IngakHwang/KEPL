package mc.sn.KEPL.service;

import java.util.List;

import mc.sn.KEPL.VO.ReplyVO;
import mc.sn.KEPL.commons.paging.Criteria;


public interface ReplyService {

	List<ReplyVO> list(Integer article_no) throws Exception;

    void create(ReplyVO replyVO) throws Exception;

    void update(ReplyVO replyVO) throws Exception;

    void delete(Integer reply_no) throws Exception;
	
	// 회원이 작성한 댓글 목록
    List<ReplyVO> userReplies(String userId) throws Exception;
    
    List<ReplyVO> getRepliesPaging(Integer article_no, Criteria criteria) throws Exception;

    int countReplies(Integer article_no) throws Exception;
}