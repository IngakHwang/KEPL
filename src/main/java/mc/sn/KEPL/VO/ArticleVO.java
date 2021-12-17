package mc.sn.KEPL.VO;

import java.util.Date;

import java.util.Arrays;

public class ArticleVO {

    private Integer article_no;

    private String title;

    private String content;

    private String writer;

    private Date regDate;

    private int viewCnt;
    
    private int replyCnt;
    
    private String[] files;
    
    private int fileCnt;
    
    private String writerImg;
    
    private UserVO userVO;
    
	private String addr;
	
	private String hashtag;
	
	private String fullname;
	
	private String category;
	
	private int likesCnt;

	public Integer getArticle_no() {
		return article_no;
	}

	public void setArticle_no(Integer article_no) {
		this.article_no = article_no;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}
		
	public String[] getFiles() {
		return files;
	}

	public Date getRegDate() {
		return regDate;
	}

	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}

	public int getViewCnt() {
		return viewCnt;
	}

	public void setViewCnt(int viewCnt) {
		this.viewCnt = viewCnt;
	}

	public int getReplyCnt() {
		return replyCnt;
	}

	public void setReplyCnt(int replyCnt) {
		this.replyCnt = replyCnt;
	}

	public int getFileCnt() {
		return fileCnt;
	}

	public void setFileCnt(int fileCnt) {
		this.fileCnt = fileCnt;
	}
	
	public void setFiles(String[] files) {
		this.files = files;
	}
	
	public UserVO getUserVO() {
		return userVO;
	}

	public void setUserVO(UserVO userVO) {
		this.userVO = userVO;
	}
	
	public String getWriterImg() {
		
		return writerImg;
	}

	public void setWriterImg(String writerImg, UserVO userVO) {
		writerImg = userVO.getUserImg();
		this.writerImg = writerImg;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getHashtag() {
		return hashtag;
	}

	public void setHashtag(String hashtag) {
		this.hashtag = hashtag;
	}

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public int getLikesCnt() {
		return likesCnt;
	}

	public void setLikesCnt(int likesCnt) {
		this.likesCnt = likesCnt;
	}

	@Override
	public String toString() {
		return "ArticleVO [article_no=" + article_no + ", title=" + title + ", content=" + content + ", writer="
				+ writer + ", regDate=" + regDate + ", viewCnt=" + viewCnt + ", replyCnt=" + replyCnt + ", files="
				+ Arrays.toString(files) + ", fileCnt=" + fileCnt + ", writerImg=" + writerImg + ", userVO=" + userVO
				+ ", addr=" + addr + ", hashtag=" + hashtag + ", fullname=" + fullname + ", category=" + category
				+ ", likesCnt=" + likesCnt + "]";
	}


	

}