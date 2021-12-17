package mc.sn.KEPL.DAO;

import java.util.List;

import mc.sn.KEPL.VO.ArticleVO;
import mc.sn.KEPL.VO.FileVO;
import mc.sn.KEPL.commons.paging.Criteria;
import mc.sn.KEPL.commons.paging.SearchCriteria;


public interface ArticleDAO {

    void create(ArticleVO articleVO) throws Exception;

    ArticleVO read(Integer article_no) throws Exception;

    void update(ArticleVO articleVO) throws Exception;

    void delete(Integer article_no) throws Exception;

    List<ArticleVO> listPaging(int page) throws Exception;
       
    List<ArticleVO> listSearch(SearchCriteria searchCriteria) throws Exception;

    int countSearchedArticles(SearchCriteria searchCriteria) throws Exception;
    
    int countArticles(Criteria criteria) throws Exception;
    
    void updateReplycnt(Integer article_no, int amount) throws Exception;
    
    void updateViewcnt(Integer article_no) throws Exception;
    
    void updateLikescnt(int article_no, int amount) throws Exception;
    
 // 회원이 작성한 게시글 목록
    List<ArticleVO> userBoardList(String userId) throws Exception;
    
    void updateWriterImg(ArticleVO articleVO) throws Exception;
    
    List<ArticleVO> listSearchMovie(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> listSearchDrama(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> listSearchKpop(SearchCriteria searchCriteria) throws Exception;
    
    int countSearchMovie(SearchCriteria searchCriteria) throws Exception;
    
    int countSearchDrama(SearchCriteria searchCriteria) throws Exception;
    
    int countSearchKpop(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> maxBlnoMovie(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> maxBlnoDrama(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> maxBlnoKpop(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> recentMovie(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> recentDrama(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> recentKpop(SearchCriteria searchCriteria) throws Exception;
    
    int countSearchBest(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> listSearchBest(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> listSearchMoviebyviewcnt(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> listSearchDramabyviewcnt(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> listSearchKpopbyviewcnt(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> listSearchbyviewcnt(SearchCriteria searchCriteria) throws Exception;
    
    List<ArticleVO> listSearchBestbyviewcnt(SearchCriteria searchCriteria) throws Exception;

}