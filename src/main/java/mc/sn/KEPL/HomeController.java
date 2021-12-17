package mc.sn.KEPL;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import mc.sn.KEPL.commons.paging.PageMaker;
import mc.sn.KEPL.commons.paging.SearchCriteria;
import mc.sn.KEPL.service.ArticleService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
    private final ArticleService articleService;
	
    @Inject
    public HomeController(ArticleService articleService) {
        this.articleService = articleService;
    }
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/home", method = RequestMethod.GET)
	public String home(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria,
					Locale locale, Model model) throws Exception{
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		PageMaker pageMaker = new PageMaker();
    	pageMaker.setCriteria(searchCriteria);

    	model.addAttribute("articles_m", articleService.maxBlnoMovie(searchCriteria));
    	model.addAttribute("articles_d", articleService.maxBlnoDrama(searchCriteria));
    	model.addAttribute("articles_k", articleService.maxBlnoKpop(searchCriteria));
    	
    	model.addAttribute("r_articles_m", articleService.recentMovie(searchCriteria));
    	model.addAttribute("r_articles_d", articleService.recentDrama(searchCriteria));
    	model.addAttribute("r_articles_k", articleService.recentKpop(searchCriteria));
    	model.addAttribute("pageMaker", pageMaker);
		
		return "home";
	}
	
}
