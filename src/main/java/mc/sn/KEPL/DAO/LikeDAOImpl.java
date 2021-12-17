package mc.sn.KEPL.DAO;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import mc.sn.KEPL.VO.ArticleLikeVO;

@Repository
public class LikeDAOImpl implements LikeDAO {

    @Inject
    private SqlSession sqlSession;

    private static final String NAMESPACE = "mc.sn.KEPL.mappers.like.LikeMapper";

    @Override
    public void createBoardLike(ArticleLikeVO boardLikeVO) throws Exception {
        sqlSession.insert(NAMESPACE + ".createBoardLike", boardLikeVO);
    }

    @Override
    public void deleteBoardLike(ArticleLikeVO boardLikeVO) throws Exception {
        sqlSession.delete(NAMESPACE + ".deleteBoardLike", boardLikeVO);
    }

    @Override
    public int countBoardLikes(Integer article_no) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".countBoardLikes", article_no);
    }

    @Override
    public boolean checkBoardLike(Integer article_no, String userId) throws Exception {

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("article_no", article_no);
        paramMap.put("userId", userId);

        return sqlSession.selectOne(NAMESPACE + ".checkBoardLike", paramMap);
    }

}