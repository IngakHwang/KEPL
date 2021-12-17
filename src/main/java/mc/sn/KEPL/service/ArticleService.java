package mc.sn.KEPL.service;

import java.util.List;

import mc.sn.KEPL.VO.ArticleVO;
import mc.sn.KEPL.VO.FileVO;
import mc.sn.KEPL.commons.paging.Criteria;
import mc.sn.KEPL.commons.paging.SearchCriteria;


public interface ArticleService {

    void create(ArticleVO articleVO) throws Exception;

    ArticleVO read(Integer article_no) throws Exception;

    void update(ArticleVO articleVO) throws Exception;

    void delete(Integer article_no) throws Exception;


	int countArticles(Criteria criteria) throws Exception ;
	
	List<ArticleVO> listSearch(SearchCriteria searchCriteria) throws Exception;

	int countSearchedArticles(SearchCriteria searchCriteria) throws Exception;
	
	List<ArticleVO> userBoardList(String uid) throws Exception;
	
	String geocode(String words);
	
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