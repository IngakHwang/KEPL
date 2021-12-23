# 게시물 조회 및 트랜잭션 처리 

## 트랜잭션 처리 

### 설정

#### pom.xml

```xml
<dependency> <groupId>org.springframework</groupId> <artifactId>spring-tx</artifactId> <version>${org.springframework-version}</version> </dependency>
```

라이브러리 추가

#### root-context.xml

```xml
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager"> <property name="dataSource" ref="dataSource"/> </bean> <tx:annotation-driven/>
```



### 댓글 트랜잭션 처리



#### 게시글 테이블 및 ArticleVO 수정

##### 테이블 추가

```sql
ALTER TABLE tb_article ADD COLUMN reply_cnt int DEFAULT 0;
```

##### ArticleVO.java 요소 추가

```java
private int replyCnt;
...
public int getReplyCnt() { 
		return replyCnt; 
} 
public void setReplyCnt(int replyCnt) { 
		this.replyCnt = replyCnt; 
}
...
@Override 
public String toString() { return "ArticleVO [
...
    ", replyCnt="+ replyCnt + "]" ; }
```

##### articleMapper.xml

게시글 목록 출력시 댓글 수 값이 필요하므로 listsearch에 추가
댓글 갯수 생신 쿼리문 추가

```xml
<select id="listSearch" resultMap="ArticleResultMap"> 
    <![CDATA[ 
SELECT 
article_no, 
title, 
content, 
writer, 
regdate, 
viewcnt, 
reply_cnt 
FROM tb_article 
WHERE article_no > 0 
	]]> 
    <include refid="search"/> 
    <![CDATA[ 
ORDER BY article_no DESC, reg_date DESC 
LIMIT #{pageStart}, #{perPageNum} 
]]> 
</select>

<update id="updateReplyCnt"> 
    UPDATE tb_article SET 
    reply_cnt = reply_cnt + #{amount} 
    WHERE article_no = #{article_no} 
</update>
```

#### Persistence 계층 수정

##### ArticleDAO, Impl.java 인터페이스 수정

```java
void updateReplyCnt(Integer article_no, int amount) throws Exception;
```

```java
@Override 
public void updateReplyCnt(Integer article_no, int amount
                          ) throws Exception { Map<String, Object> 
        paramMap = new HashMap<String, Object>(); 
        paramMap.put("article_no", article_no); 
        paramMap.put("amount", amount); 
                                              
		sqlSession.update(NAMESPACE + ".updateReplyCnt",paramMap); 
}
```

##### ReplyDAO, Impl.java 인터페이스 수정

```java
int getArticleNo(Integer reply_no) throws Exception;
```

```java
@Override 
public int getArticleNo(Integer reply_no) throws Exception {
    return sqlSession.selectOne(NAMESPACE + ".getArticleNo", reply_no); 
}
```

##### replyMapper.xml 수정

```xml
<select id="getArticleNo" resultType="int"> 
    SELECT 
    article_no FROM tb_reply 
    WHERE reply_no = #{reply_no} 
</select>
```



#### Service  계층 수정

새로운 메소드 추가 필요없이 댓글등록 및 삭제 처리 메소드 수정 및 트랜잭션 처리함

##### ReplyServiceImpl.java 수정

```java
private final ReplyDAO replyDAO; 
private final ArticleDAO articleDAO; 

@Inject 
public ReplyServiceImpl(ReplyDAO replyDAO, ArticleDAO articleDAO) { 
    this.replyDAO = replyDAO; 
    this.articleDAO = articleDAO; 
} 

// 댓글 등록
@Transactional // 트랜잭션 처리 
@Override public void addReply(ReplyVO replyVO) throws Exception { 
    replyDAO.create(replyVO); // 댓글 등록 
    articleDAO.updateReplyCnt(replyVO.getArticle_no(), 1); // 댓글 갯수 증가 
} 

// 댓글 삭제 
@Transactional // 트랜잭션 처리 
@Override public void removeReply(Integer reply_no) throws Exception { 
    int article_no = replyDAO.getArticleNo(reply_no); // 댓글의 게시물 번호 조회 
    replyDAO.delete(reply_no); // 댓글 삭제 
    articleDAO.updateReplyCnt(article_no, -1); // 댓글 갯수 감소 
}
```

#### list.jsp 수정

댓글 수는 게시글 옆에 출력 되도록 하기 위해서 게시물 제목 출력부분을 수정

```jsp
<td> 
    <a href="${path}/article/paging/search/read${pageMaker.makeSearch(pageMaker.criteria.page)}&article_no=
             ${article.article_no}"> ${article.title} 
    </a> 
    <span class="badge bg-teal"><i class="fas fa-comment"></i> + ${article.replyCnt}</span> 
</td>
```

