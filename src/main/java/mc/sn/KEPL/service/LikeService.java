package mc.sn.KEPL.service;

import mc.sn.KEPL.VO.ArticleLikeVO;

public interface LikeService {
    // 게시글 추천 하기
    public void createBoardLike(ArticleLikeVO boardLikeVO) throws Exception;

    // 게시글 추천 취소
    public void removeBoardLike(ArticleLikeVO boardLikeVO) throws Exception;

    // 게시글 추천 갯수
    public int countBoardLikes(Integer article_no) throws Exception;

    // 게시글 추천 여부
    public boolean checkBoardLike(Integer article_no, String userId) throws Exception;
}
