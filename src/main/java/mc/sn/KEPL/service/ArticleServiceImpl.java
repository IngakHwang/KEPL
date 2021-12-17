package mc.sn.KEPL.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import mc.sn.KEPL.DAO.ArticleDAO;
import mc.sn.KEPL.DAO.UploadDAO;
import mc.sn.KEPL.VO.ArticleVO;
import mc.sn.KEPL.VO.FileVO;
import mc.sn.KEPL.commons.paging.Criteria;
import mc.sn.KEPL.commons.paging.SearchCriteria;


@Service
public class ArticleServiceImpl implements ArticleService {

    private final ArticleDAO articleDAO;
    
    private static final Logger logger = LoggerFactory.getLogger(ArticleServiceImpl.class);
    
    private UploadDAO uploadDAO;

    @Inject
    public ArticleServiceImpl(ArticleDAO articleDAO, UploadDAO uploadDAO) {
        this.articleDAO = articleDAO;
        this.uploadDAO = uploadDAO;
    }
    
    @Transactional
    @Override
    public void create(ArticleVO articleVO) throws Exception {
        String[] files = articleVO.getFiles();  
        
        
        
        if (files == null) {
        	
        	articleDAO.create(articleVO);
        	articleDAO.updateWriterImg(articleVO);
        	logger.info("Create - "+articleVO.toString());
            return;
        }
        articleVO.setFileCnt(files.length);
        
        articleDAO.create(articleVO);
        articleDAO.updateWriterImg(articleVO);
        logger.info("Create - "+articleVO.toString());
        Integer article_no = articleVO.getArticle_no();
        for (String fileName : files) {
        	logger.info("File exist. . .");
            uploadDAO.addAttach(fileName, article_no);
        }

    }
    
    @Transactional(isolation = Isolation.READ_COMMITTED)
    @Override
    public ArticleVO read(Integer article_no) throws Exception {
    	articleDAO.updateViewcnt(article_no);
        return articleDAO.read(article_no);
    }
    
    @Transactional
    @Override
    public void update(ArticleVO articleVO) throws Exception {
    	
        
        int article_no = articleVO.getArticle_no();
        uploadDAO.deleteAllAttach(article_no);

        String[] files = articleVO.getFiles();
        if (files == null) {
        	articleVO.setFileCnt(0);
            articleDAO.update(articleVO);
            return;
        }

        articleVO.setFileCnt(files.length);
        articleDAO.update(articleVO);
        for (String fileName : files) {
            uploadDAO.replaceAttach(fileName, article_no);
        }
    }

    @Transactional
    @Override
    public void delete(Integer article_no) throws Exception {
    	uploadDAO.deleteAllAttach(article_no);
        articleDAO.delete(article_no);
    }
    
    @Override
    public int countArticles(Criteria criteria) throws Exception {
        return articleDAO.countArticles(criteria);
    }
   
    @Override
    public List<ArticleVO> listSearch(SearchCriteria searchCriteria) throws Exception {
        return articleDAO.listSearch(searchCriteria);
    }

    @Override
    public int countSearchedArticles(SearchCriteria searchCriteria) throws Exception {
        return articleDAO.countSearchedArticles(searchCriteria);
    }
    
 // 회원이 작성한 게시글 목록
    @Override
    public List<ArticleVO> userBoardList(String uid) throws Exception {
        return articleDAO.userBoardList(uid);
    }
 
	public String geocode(String words) {
		// TODO Auto-generated method stub
		 StringBuffer res = null;
		 String clientId = "lyjg8pre32";
	     String clientSecret = "fdUBU1j5br9M0FdorEakQ0rCXD7fQsKmUjBhOJUL"; 
	     try {
	         String text = URLEncoder.encode(words, "UTF-8");
	         String apiURL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=" + text;
	         URL url = new URL(apiURL);
	         HttpURLConnection con = (HttpURLConnection)url.openConnection();
	         con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
	         con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
	         con.setDoOutput(true);

	         int responseCode = con.getResponseCode();
	         BufferedReader br;
	         if(responseCode==200) { 
	             br = new BufferedReader(new InputStreamReader(con.getInputStream(),"utf8"));
	         } else {
	             br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
	         }
	         String inputLine;
	         res = new StringBuffer();
	         while ((inputLine = br.readLine()) != null) {
	             res.append(inputLine);
	         }
	         br.close();
	         System.out.println("service "+res.toString());
	     } catch (Exception e) {
	         System.out.println(e);
	     }
		
	
		return res.toString();
	}
	
	@Override
	public List<ArticleVO> listSearchMovie(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.listSearchMovie(searchCriteria);
	}
	@Override
	public List<ArticleVO> listSearchDrama(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.listSearchDrama(searchCriteria);
	}
	@Override
	public List<ArticleVO> listSearchKpop(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.listSearchKpop(searchCriteria);
	}
	
    @Override
    public int countSearchMovie(SearchCriteria searchCriteria) throws Exception {
        return articleDAO.countSearchMovie(searchCriteria);
    }
    @Override
    public int countSearchDrama(SearchCriteria searchCriteria) throws Exception {
    	return articleDAO.countSearchDrama(searchCriteria);
    }
    @Override
    public int countSearchKpop(SearchCriteria searchCriteria) throws Exception {
    	return articleDAO.countSearchKpop(searchCriteria);
    }
    
	@Override
	public List<ArticleVO> maxBlnoMovie(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.maxBlnoMovie(searchCriteria);
	}
	@Override
	public List<ArticleVO> maxBlnoDrama(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.maxBlnoDrama(searchCriteria);
	}
	@Override
	public List<ArticleVO> maxBlnoKpop(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.maxBlnoKpop(searchCriteria);
	}
	@Override
	public List<ArticleVO> recentMovie(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.recentMovie(searchCriteria);
	}
	@Override
	public List<ArticleVO> recentDrama(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.recentDrama(searchCriteria);
	}
	@Override
	public List<ArticleVO> recentKpop(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.recentKpop(searchCriteria);
	}
	
    @Override
    public int countSearchBest(SearchCriteria searchCriteria) throws Exception {
    	return articleDAO.countSearchBest(searchCriteria);
    }
    
	@Override
	public List<ArticleVO> listSearchBest(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.listSearchBest(searchCriteria);
	}
	
	@Override
	public List<ArticleVO> listSearchMoviebyviewcnt(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.listSearchMoviebyviewcnt(searchCriteria);
	}
	@Override
	public List<ArticleVO> listSearchDramabyviewcnt(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.listSearchDramabyviewcnt(searchCriteria);
	}
	@Override
	public List<ArticleVO> listSearchKpopbyviewcnt(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.listSearchKpopbyviewcnt(searchCriteria);
	}
	
	@Override
	public List<ArticleVO> listSearchbyviewcnt(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.listSearchbyviewcnt(searchCriteria);
	}
	@Override
	public List<ArticleVO> listSearchBestbyviewcnt(SearchCriteria searchCriteria) throws Exception {
		return articleDAO.listSearchBestbyviewcnt(searchCriteria);
	}
}