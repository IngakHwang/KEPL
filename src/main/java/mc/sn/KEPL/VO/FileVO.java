package mc.sn.KEPL.VO;

public class FileVO {
	private String fullname;
	private Integer article_no;
	
	public String getFullname() {
		return fullname;
	}
	public void setFullname(String fullname) {
		this.fullname = fullname;
	}
	public Integer getArticle_no() {
		return article_no;
	}
	public void setArticle_no(Integer article_no) {
		this.article_no = article_no;
	}
	
	@Override
	public String toString() {
		return "FileVO [fullname=" + fullname + ", article_no=" + article_no + "]";
	}
	
	
}
