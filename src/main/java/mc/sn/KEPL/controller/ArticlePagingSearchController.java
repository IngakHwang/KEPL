package mc.sn.KEPL.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.request;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import mc.sn.KEPL.VO.ArticleVO;
import mc.sn.KEPL.commons.paging.PageMaker;
import mc.sn.KEPL.commons.paging.SearchCriteria;
import mc.sn.KEPL.service.ArticleService;



@Controller
@RequestMapping("/article/search")
public class ArticlePagingSearchController {

    private static final Logger logger = LoggerFactory.getLogger(ArticlePagingSearchController.class);

    private final ArticleService articleService;
	
    @Inject
    public ArticlePagingSearchController(ArticleService articleService) {
        this.articleService = articleService;
    }
    
    @RequestMapping(value = "/write", method = RequestMethod.GET)
    public String writeGET() {

        logger.info("search writeGET() called...");

        return "article/search/write";
    }

    @RequestMapping(value = "/write", method = RequestMethod.POST)
    public String writePOST(ArticleVO articleVO,
                            RedirectAttributes redirectAttributes,
                            @RequestParam("hashtags") String[] hashtags) throws Exception {

        logger.info("search writePOST() called...");
       
        String hashtag = Arrays.toString(hashtags);
           
        hashtag = hashtag.replace("[", "");
        hashtag = hashtag.replace("]", "");
        
        if(hashtag.equals("")) {
        	articleVO.setHashtag(null);
        } else {
        	articleVO.setHashtag(hashtag);
        }
        
        System.out.println(articleVO.toString());
        articleService.create(articleVO);
        redirectAttributes.addFlashAttribute("msg", "regSuccess");

        return "redirect:/article/search/list";
    }
    
    
    
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria, Model model) 
						throws Exception {

        logger.info("search list() called ...");
        
        PageMaker pageMaker = new PageMaker();
        pageMaker.setCriteria(searchCriteria);
        pageMaker.setTotalCount(articleService.countSearchedArticles(searchCriteria));
        
		model.addAttribute("articles", articleService.listSearch(searchCriteria));
			
		
        model.addAttribute("pageMaker", pageMaker);

        
        return "article/search/list";
    }
    
    @RequestMapping(value = "/list/viewcnt", method = RequestMethod.GET)
    public String listViewcnt(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria, Model model) 
						throws Exception {

        logger.info("search list() called ...");
        
        PageMaker pageMaker = new PageMaker();
        pageMaker.setCriteria(searchCriteria);
        pageMaker.setTotalCount(articleService.countSearchedArticles(searchCriteria));
        
        model.addAttribute("articles", articleService.listSearchbyviewcnt(searchCriteria));

        model.addAttribute("pageMaker", pageMaker);

        
        return "article/search/list";
    }
    
 // ?????? ?????????
    @RequestMapping(value = "/read", method = RequestMethod.GET)
    public String read(@RequestParam("article_no") int article_no,
                       @ModelAttribute("searchCriteria") SearchCriteria searchCriteria,
                       Model model) throws Exception {

        logger.info("search read() called ...");
        model.addAttribute("article", articleService.read(article_no));

        return "article/search/read";
    }
    
 // ?????? ?????????
    @RequestMapping(value = "/modify", method = RequestMethod.GET)
    public String modifyGET(@RequestParam("article_no") int article_no,
                            @ModelAttribute("searchCriteria") SearchCriteria searchCriteria,
                            Model model) throws Exception {

        logger.info("search modifyGet() called ...");
        logger.info(searchCriteria.toString());
        model.addAttribute("article", articleService.read(article_no));

        return "article/search/modify";
    }
    
 // ?????? ??????
    @RequestMapping(value = "/modify", method = RequestMethod.POST)
    public String modifyPOST(ArticleVO articleVO,
                             SearchCriteria searchCriteria,
                             RedirectAttributes redirectAttributes,
                             @RequestParam("hashtags") String[] hashtags) throws Exception {

        logger.info("search modifyPOST() called ...");
        
        String hashtag = Arrays.toString(hashtags);
        
        hashtag = hashtag.replace("[", "");
        hashtag = hashtag.replace("]", "");
        
        if(hashtag.equals("")) {
        	articleVO.setHashtag(null);
        } else {
        	articleVO.setHashtag(hashtag);
        }
        
        System.out.println(articleVO.toString());
        articleService.update(articleVO);
        redirectAttributes.addAttribute("page", searchCriteria.getPage());
        redirectAttributes.addAttribute("perPageNum", searchCriteria.getPerPageNum());
        redirectAttributes.addAttribute("searchType", searchCriteria.getSearchType());
        redirectAttributes.addAttribute("keyword", searchCriteria.getKeyword());
        redirectAttributes.addFlashAttribute("msg", "modSuccess");

        return "redirect:/article/search/list";
    }
    
 // ?????? ??????
    @RequestMapping(value = "/remove", method = RequestMethod.POST)
    public String remove(@RequestParam("article_no") int article_no,
                         SearchCriteria searchCriteria,
                         RedirectAttributes redirectAttributes) throws Exception {

        logger.info("search remove() called ...");
        articleService.delete(article_no);
        redirectAttributes.addAttribute("page", searchCriteria.getPage());
        redirectAttributes.addAttribute("perPageNum", searchCriteria.getPerPageNum());
        redirectAttributes.addAttribute("searchType", searchCriteria.getSearchType());
        redirectAttributes.addAttribute("keyword", searchCriteria.getKeyword());
        redirectAttributes.addFlashAttribute("msg", "delSuccess");

        return "redirect:/article/search/list";
    }
    
	@ResponseBody
	@RequestMapping(value="/map1", method=RequestMethod.GET, produces = "application/text; charset=UTF-8")
	public void getGeo(HttpServletRequest req, HttpServletResponse res) throws IOException {
		req.setCharacterEncoding("utf-8");
		String addr = req.getParameter("addr");
		
		System.out.println("addr : "+addr);
		
		res.setContentType("text/text; charset=utf-8");
		String result = articleService.geocode(addr);
		
		//System.out.println("controller "+result);
		
		res.getWriter().print(result);
	}
	
	 @RequestMapping(value = "/list/movie", method = RequestMethod.GET)
	 public String listMovie(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria, Model model)
	    		throws Exception {
	    	
	    	logger.info("search list movie() called ...");
	    	
	    	PageMaker pageMaker = new PageMaker();
	    	pageMaker.setCriteria(searchCriteria);
	    	pageMaker.setTotalCount(articleService.countSearchMovie(searchCriteria));
	    	
			model.addAttribute("articles", articleService.listSearchMovie(searchCriteria));
	   
	    	model.addAttribute("pageMaker", pageMaker);
	    	
	    	return "article/search/list_movie";
	 }
	 
	 @RequestMapping(value = "/list/movie/viewcnt", method = RequestMethod.GET)
	 public String listMovieViewcnt(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria, Model model)
	    		throws Exception {
	    	
	    	logger.info("search list movie() called ...");
	    	
	    	PageMaker pageMaker = new PageMaker();
	    	pageMaker.setCriteria(searchCriteria);
	    	pageMaker.setTotalCount(articleService.countSearchMovie(searchCriteria));
	    	
			model.addAttribute("articles", articleService.listSearchMoviebyviewcnt(searchCriteria));

	    	model.addAttribute("pageMaker", pageMaker);
	    	
	    	return "article/search/list_movie";
	 }
	 @RequestMapping(value = "/list/drama", method = RequestMethod.GET)
	    public String listDrama(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria, Model model,
	    						@RequestParam(value = "howAsc", required=false, defaultValue="") String howAsc) 
	    				throws Exception {
	    	
	    	logger.info("search list drama() called ...");
	    	
	    	PageMaker pageMaker = new PageMaker();
	    	pageMaker.setCriteria(searchCriteria);
	    	pageMaker.setTotalCount(articleService.countSearchDrama(searchCriteria));
	    	
			model.addAttribute("articles", articleService.listSearchDrama(searchCriteria));

	    	model.addAttribute("pageMaker", pageMaker);
	    	
	    	return "article/search/list_drama";
	    }
	 
	 @RequestMapping(value = "/list/drama/viewcnt", method = RequestMethod.GET)
	    public String listDramaViewcnt(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria, Model model) 
	    				throws Exception {
	    	
	    	logger.info("search list drama() called ...");
	    	
	    	PageMaker pageMaker = new PageMaker();
	    	pageMaker.setCriteria(searchCriteria);
	    	pageMaker.setTotalCount(articleService.countSearchDrama(searchCriteria));

			model.addAttribute("articles", articleService.listSearchDramabyviewcnt(searchCriteria));

	    	model.addAttribute("pageMaker", pageMaker);
	    	
	    	return "article/search/list_drama";
	    }
	    @RequestMapping(value = "/list/kpop", method = RequestMethod.GET)
	    public String listKpop(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria, Model model) 
	    						throws Exception {
	    	
	    	logger.info("search list k-pop() called ...");
	    	
	    	PageMaker pageMaker = new PageMaker();
	    	pageMaker.setCriteria(searchCriteria);
	    	pageMaker.setTotalCount(articleService.countSearchKpop(searchCriteria));

			model.addAttribute("articles", articleService.listSearchKpop(searchCriteria));

	    	model.addAttribute("pageMaker", pageMaker);
	    	
	    	return "article/search/list_kpop";
	    }
	    
	    @RequestMapping(value = "/list/kpop/viewcnt", method = RequestMethod.GET)
	    public String listKpopViewcnt(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria, Model model) 
	    						throws Exception {
	    	
	    	logger.info("search list k-pop() called ...");
	    	
	    	PageMaker pageMaker = new PageMaker();
	    	pageMaker.setCriteria(searchCriteria);
	    	pageMaker.setTotalCount(articleService.countSearchKpop(searchCriteria));
	    	
			model.addAttribute("articles", articleService.listSearchKpopbyviewcnt(searchCriteria));

	    	model.addAttribute("pageMaker", pageMaker);
	    	
	    	return "article/search/list_kpop";
	    }
	    
	    @RequestMapping(value = "/list/best", method = RequestMethod.GET)
	    public String listBest(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria, Model model) 
								throws Exception {
	    	
	    	logger.info("search list best() called ...");
	    	
	    	PageMaker pageMaker = new PageMaker();
	    	pageMaker.setCriteria(searchCriteria);
	    	pageMaker.setTotalCount(articleService.countSearchBest(searchCriteria));
	    	
	    	model.addAttribute("articles", articleService.listSearchBest(searchCriteria));

	    	model.addAttribute("pageMaker", pageMaker);
	    	
	    	return "article/search/list_best";
	    }
	    
	    @RequestMapping(value = "/list/best/viewcnt", method = RequestMethod.GET)
	    public String listBest(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria, Model model,
								@RequestParam(value = "howAsc", required=false, defaultValue="") String howAsc) 
								throws Exception {
	    	
	    	logger.info("search list best() called ...");
	    	
	    	PageMaker pageMaker = new PageMaker();
	    	pageMaker.setCriteria(searchCriteria);
	    	pageMaker.setTotalCount(articleService.countSearchBest(searchCriteria));
	    	
			model.addAttribute("articles", articleService.listSearchBestbyviewcnt(searchCriteria));

	    	model.addAttribute("pageMaker", pageMaker);
	    	
	    	return "article/search/list_best";
	    }
}