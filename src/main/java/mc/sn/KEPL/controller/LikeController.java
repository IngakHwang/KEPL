package mc.sn.KEPL.controller;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import mc.sn.KEPL.VO.ArticleLikeVO;
import mc.sn.KEPL.service.LikeService;

@RestController
@RequestMapping("/like")
public class LikeController {

	private final LikeService likeService;
	
    @Inject
    public LikeController(LikeService likeService) {
    	this.likeService=likeService;
    }
   

    // 게시글 추천 하기
    @RequestMapping(value = "/create/{article_no}/{userId}", method = RequestMethod.POST)
    public ResponseEntity<String> createBoardLike(@PathVariable("article_no") Integer article_no,
                                                  @PathVariable("userId") String userId) {
        ResponseEntity<String> entity = null;
        try {
        	ArticleLikeVO boardLikeVO = new ArticleLikeVO();
            boardLikeVO.setArticle_no(article_no);
            boardLikeVO.setUser_id(userId);
            likeService.createBoardLike(boardLikeVO);
            entity = new ResponseEntity<>("BOARD LIKE CREATED", HttpStatus.OK);
        } catch (Exception e) {
            entity = new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
        return entity;
    }

    // 게시글 추천 취소
    @RequestMapping(value = "/remove/{article_no}/{userId}", method = RequestMethod.DELETE)
    public ResponseEntity<String> removeBoardLike(@PathVariable("article_no") Integer article_no,
                                                  @PathVariable("userId") String userId) {
        ResponseEntity<String> entity = null;
        try {
        	ArticleLikeVO boardLikeVO = new ArticleLikeVO();
            boardLikeVO.setArticle_no(article_no);
            boardLikeVO.setUser_id(userId);
            likeService.removeBoardLike(boardLikeVO);
            entity = new ResponseEntity<>("BOARD LIKE REMOVED", HttpStatus.OK);
        } catch (Exception e) {
            entity = new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
        return entity;
    }

    // 게시글 추천 갯수
    @RequestMapping(value = "/count/{article_no}", method = RequestMethod.GET)
    public ResponseEntity<Map<String, Object>> countBoardLikes(@PathVariable("article_no") Integer article_no) {
        ResponseEntity<Map<String, Object>> entity = null;
        try {
            int likeTotalCount = likeService.countBoardLikes(article_no);
            Map<String, Object> map = new HashMap<>();
            map.put("likeTotalCount", likeTotalCount);
            entity = new ResponseEntity<>(map, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        return entity;
    }

    // 게시글 추천 여부
    @RequestMapping(value = "/check/{article_no}/{userId}", method = RequestMethod.GET)
    public ResponseEntity<Map<String, Object>> checkBoardLike(@PathVariable("article_no") Integer article_no,
                                                              @PathVariable("userId") String userId) {
        ResponseEntity<Map<String, Object>> entity = null;
        try {
            boolean checkBoardLike = likeService.checkBoardLike(article_no, userId);
            Map<String, Object> map = new HashMap<>();
            map.put("checkBoardLike", checkBoardLike);
            entity = new ResponseEntity<>(map, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        
        return entity;
    }

}