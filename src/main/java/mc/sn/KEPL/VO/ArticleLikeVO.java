package mc.sn.KEPL.VO;

import java.util.Date;

public class ArticleLikeVO {

	    // 추천번호
	    private int blno;
	    // 게시글 번호
	    private int article_no;
	    // 추천회원 아이디
	    private String userId;
	    // 추천 일시
	    private Date likedate;
	    private ArticleVO articleVO;
	    private UserVO userVO;
	    
		public ArticleVO getArticleVO() {
			return articleVO;
		}
		public void setArticleVO(ArticleVO articleVO) {
			this.articleVO = articleVO;
		}
		public UserVO getUserVO() {
			return userVO;
		}
		public void setUserVO(UserVO userVO) {
			this.userVO = userVO;
		}
		public int getBlno() {
			return blno;
		}
		public void setBlno(int blno) {
			this.blno = blno;
		}
		public int getArticle_no() {
			return article_no;
		}
		public void setArticle_no(int article_no) {
			this.article_no = article_no;
		}
		public String getUser_id() {
			return userId;
		}
		public void setUser_id(String user_id) {
			this.userId = user_id;
		}
		public Date getLikedate() {
			return likedate;
		}
		public void setLikedate(Date likedate) {
			this.likedate = likedate;
		}
		@Override
		public String toString() {
			return "ArticleLikeVO [blno=" + blno + ", article_no=" + article_no + ", user_id=" + userId + ", likedate="
					+ likedate + ", articleVO=" + articleVO + ", userVO=" + userVO + "]";
		}
		

	 
	}