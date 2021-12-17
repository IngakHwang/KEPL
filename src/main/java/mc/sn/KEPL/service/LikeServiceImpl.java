package mc.sn.KEPL.service;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mc.sn.KEPL.DAO.ArticleDAO;
import mc.sn.KEPL.DAO.LikeDAO;
import mc.sn.KEPL.DAO.ReplyDAO;
import mc.sn.KEPL.VO.ArticleLikeVO;

@Service
public class LikeServiceImpl implements LikeService {
    
    private LikeDAO likeDAO;
    private ArticleDAO articleDAO;
    
    @Inject
    public LikeServiceImpl(LikeDAO likeDAO, ArticleDAO articleDAO) {
        this.likeDAO = likeDAO;
        this.articleDAO = articleDAO;
    }	
    
    @Transactional
    @Override
    public void createBoardLike(ArticleLikeVO boardLikeVO) throws Exception {
        likeDAO.createBoardLike(boardLikeVO);
        articleDAO.updateLikescnt(boardLikeVO.getArticle_no(),1);
    }

    @Transactional
    @Override
    public void removeBoardLike(ArticleLikeVO boardLikeVO) throws Exception {
        likeDAO.deleteBoardLike(boardLikeVO);
        articleDAO.updateLikescnt(boardLikeVO.getArticle_no(),-1);
    }

    @Override
    public int countBoardLikes(Integer article_no) throws Exception {
        return likeDAO.countBoardLikes(article_no);
    }

    @Override
    public boolean checkBoardLike(Integer article_no, String userId) throws Exception {          	
    	return likeDAO.checkBoardLike(article_no, userId);
    
    }


}