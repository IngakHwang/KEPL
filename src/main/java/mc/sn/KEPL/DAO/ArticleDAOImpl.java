package mc.sn.KEPL.DAO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import mc.sn.KEPL.VO.ArticleVO;
import mc.sn.KEPL.VO.FileVO;
import mc.sn.KEPL.commons.paging.Criteria;
import mc.sn.KEPL.commons.paging.SearchCriteria;



@Repository
public class ArticleDAOImpl implements ArticleDAO {

    private static final String NAMESPACE = "mc.sn.KEPL.mappers.article.ArticleMapper";

    private final SqlSession sqlSession;

    @Inject
    public ArticleDAOImpl(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public void create(ArticleVO articleVO) throws Exception {
        sqlSession.insert(NAMESPACE + ".create", articleVO);
    }
    
 // 회원 프로필 사진 수정
    @Override
    public void updateWriterImg(ArticleVO articleVO) throws Exception {
        sqlSession.update(NAMESPACE + ".updateWriterImg", articleVO);
    }

    @Override
    public ArticleVO read(Integer article_no) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".read", article_no);
    }

    @Override
    public void update(ArticleVO articleVO) throws Exception {
        sqlSession.update(NAMESPACE + ".update", articleVO);
    }

    @Override
    public void delete(Integer article_no) throws Exception {
        sqlSession.delete(NAMESPACE + ".delete", article_no);
    }
    
    @Override
    public List<ArticleVO> listPaging(int page) throws Exception {

        if (page <= 0) {
            page = 1;
        }

        page = (page - 1) * 10;

        return sqlSession.selectList(NAMESPACE + ".listPaging", page);
    }
    
    @Override
    public List<ArticleVO> listSearch(SearchCriteria searchCriteria) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".listSearch", searchCriteria);
    }
    
    @Override
    public int countArticles(Criteria criteria) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".countArticles", criteria);
    }
    
    @Override
    public int countSearchedArticles(SearchCriteria searchCriteria) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".countSearchedArticles", searchCriteria);
    }
    
    @Override
    public void updateReplycnt(Integer article_no, int amount) throws Exception {
	
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("article_no", article_no);
        paramMap.put("amount", amount);

        sqlSession.update(NAMESPACE + ".updateReplycnt",paramMap);
    }
    
    @Override
    public void updateViewcnt(Integer article_no) throws Exception {
        sqlSession.update(NAMESPACE + ".updateViewcnt", article_no);   
    }
    
    @Override
    public void updateLikescnt(int article_no, int amount) throws Exception {
		
		 Map<String, Object> map = new HashMap<String, Object>();
		 map.put("article_no", article_no);
		 map.put("amount", amount);
		 
		 sqlSession.update(NAMESPACE + ".updateLikescnt",map); 
    }
    
 // 회원이 작성한 게시글 목록
    @Override
    public List<ArticleVO> userBoardList(String userId) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".userBoardList", userId);
    }
    
    @Override
    public List<ArticleVO> listSearchMovie(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".listSearchMovie", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> listSearchDrama(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".listSearchDrama", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> listSearchKpop(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".listSearchKpop", searchCriteria);
    }
    
    @Override
    public int countSearchMovie(SearchCriteria searchCriteria) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".countSearchMovie", searchCriteria);
    }
    @Override
    public int countSearchDrama(SearchCriteria searchCriteria) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".countSearchDrama", searchCriteria);
    }
    @Override
    public int countSearchKpop(SearchCriteria searchCriteria) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".countSearchKpop", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> maxBlnoMovie(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".maxBlnoMovie", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> maxBlnoDrama(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".maxBlnoDrama", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> maxBlnoKpop(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".maxBlnoKpop", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> recentMovie(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".recentMovie", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> recentDrama(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".recentDrama", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> recentKpop(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".recentKpop", searchCriteria);
    }
    
    @Override
    public int countSearchBest(SearchCriteria searchCriteria) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".countSearchBest", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> listSearchBest(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".listSearchBest", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> listSearchMoviebyviewcnt(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".listSearchMoviebyviewcnt", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> listSearchDramabyviewcnt(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".listSearchDramabyviewcnt", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> listSearchKpopbyviewcnt(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".listSearchKpopbyviewcnt", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> listSearchbyviewcnt(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".listSearchbyviewcnt", searchCriteria);
    }
    
    @Override
    public List<ArticleVO> listSearchBestbyviewcnt(SearchCriteria searchCriteria) throws Exception {
    	return sqlSession.selectList(NAMESPACE + ".listSearchBestbyviewcnt", searchCriteria);
    }
}