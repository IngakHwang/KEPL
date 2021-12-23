# Thumnail 기능 및 메인 화면 기능 추가 



## 기본사항

기존 articleMapper의 게시물 목록 불러오는 쿼리문에 
파일 정보 테이블(tb_article_file)을 left join, fullname column 추가
list.jsp 기능 추가

HomeController에 model.addAttribute 추가
articleMapper에 maxBlnoMovie(Drama, Kpop), recentMovie(Drama, Kpop) 추가
home.jsp 기능 추가

DAO, DAOImpl, Serive, ServiceImpl 요소 추가

메인화면 기능 추가
각 카테고리 별 최신, 최다 좋아요 게시물
이미지 슬라이더
영역 클릭



## 기본 list Thumnail



### articleMapper.xml

 ```xml
 <select id="listAll" resultType="ArticleVO">
         <![CDATA[
         SELECT
             ta.article_no,
             title,
             content,
             writer,
             regdate,
             viewcnt, 
             file_cnt,
             fullname
         from tb_article as ta
 			left join tb_article_file as taf on ta.article_no = taf.article_no
         WHERE ta.article_no > 0
         ORDER BY ta.article_no DESC, regdate DESC
         LIMIT 0,10
         ]]>
     </select>
 ```



게시물 번호에 맞는 게시물 정보(tb_article)와 썸네일 이름(fullname column)를 동시에 불러오기 위해
파일 정보 테이블(tb_article_file)을 left join 시킴



### list.jsp

```jsp
<c:forEach items="${articles}" var="article">
    ....
    <div class="thum">
        <c:if test="${empty article.fullname}">
            <span><img src="/dist/img/profile/NoThumbnail.png" alt="thumnail" class="listthum"></span>
        </c:if>
        <c:if test="${not empty article.fullname}">
            <span><img src="/file/display?fileName=${article.fullname}" alt="thumnail" class="listthum"></span>
    </div>
    ....
    </c:forEach>
```


만약 fullname이 공백일 경우 **<c:if test="${empty article.fullname}">** 기본 썸네일 사진으로 대체함
제대로 fullname에 값이 있을 경우 **<c:if test="${not empty article.fullname}">** 썸네일 크기의 사진이 출력됨



## Main Thumnail



### HomeController.java



```java
private final ArticleService articleService; 

@Inject
public HomeController(ArticleService articleService) { 
    this.articleService = articleService;
} 

public String home(@ModelAttribute("searchCriteria") SearchCriteria searchCriteria,
....) throws Exception{
    ....
    ageMaker pageMaker = new PageMaker();
    	pageMaker.setCriteria(searchCriteria);

    	model.addAttribute("articles_m", articleService.maxBlnoMovie(searchCriteria));
    	model.addAttribute("articles_d", articleService.maxBlnoDrama(searchCriteria));
    	model.addAttribute("articles_k", articleService.maxBlnoKpop(searchCriteria));
    	
    	model.addAttribute("r_articles_m", articleService.recentMovie(searchCriteria));
    	model.addAttribute("r_articles_d", articleService.recentDrama(searchCriteria));
    	model.addAttribute("r_articles_k", articleService.recentKpop(searchCriteria));
    	model.addAttribute("pageMaker", pageMaker);
```

HomeController에서 maxBlno,recent쿼리문을 위한 model.addAttribute를 사용



### ArticleMapper.xml

```xml
<select id="maxBlnoMovie" resultMap="ArticleResultMap">
    <![CDATA[
       SELECT
            ta.article_no,
            title,
            regdate,
            hashtag,
            fullname,
            likes_cnt
            ]]>
    <include refid="join" />
    <![CDATA[
        WHERE ta.article_no > 0 and category='movie'
        ORDER BY likes_cnt DESC LIMIT 1
    ]]>
    </select>
```

좋아요 가장 많은 게시물 또는 최신 게시물의 정보(번호, 제목, 작성자, 썸네일 이름, 좋아요 수)
조회 후 ORDER BY likes_cnt  DESC로 제일 큰 값의 좋아요를 가진 또는 최신 게시물 추출 후 메인에 보여줌



## 메인 화면 기능 추가 



### 이미지 슬라이더

```jsp
<div id="carouselExampleIndicators" class="carousel slide jumbotron p-0 text-white objectfit" data-ride="carousel">
  <ol class="carousel-indicators">
    <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
    <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
  </ol>
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img class="d-block w-100" src="/dist/img/slider/dokkaebi.png" alt="First slide">
    </div>
    <div class="carousel-item">
      <img class="d-block w-100" src="/dist/img/slider/ssammyway.png" alt="Second slide">
    </div>
  </div>
  <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>
```



이 프로젝트는 부트스트랩을 활용하였으므로 이미지 슬라이더 carousel기능이 사용 가능하므로
코드 추가 후 이미지 소스 추가



### 영역 클릭

글자나 사진을 클릭해야하는 방식은 이용자가 불편할뿐만 아니라
모든 태그에 하이퍼링크를 달아서 코드 또한 지저분해짐

```jsp
<영역태그 style="cursor: pointer;" onclick="location.href='      경로      ';">
```

원하는 영역을 선택 후 이와같은 코드를 넣어주면 그 영역 전체에 하이퍼링크가 걸림

(list.jsp에도 적용됨)



### 메인 화면 썸네일 화질 개선

상위 목록의 list Thumnail의 경우 다수의 게시물을 불러오기 때문에
원본 이미지대신 썸네일 크기 100x100으로 줄인 이미지를 사용하는데

메인화면의 사진크기를  4배 더 키워서 화질의 문제가 생겼음



#### articleMapper.xml

```xml
<select id="maxBlnoMovie" resultMap="ArticleResultMap">
<![CDATA[
   SELECT
        ta.article_no,
        title,
        regdate,
        hashtag,
        replace(fullname,'s_','') fullname,
        likes_cnt
        ]]>
<include refid="join" />
<![CDATA[
    WHERE ta.article_no > 0 and category='movie'
    ORDER BY likes_cnt DESC LIMIT 1
]]>
</select>
```

이미지 파일 업로드시 **원본 파일**과 용량과 크기를 줄인 **썸네일 파일** 두가지가 올라감

썸네일 파일 이름은 **s_원본파일**

**s_**가 붙으므로

메인화면의 썸네일 파일 이름을 원본 파일로 수정하도록 쿼리문 수정
**fullname** --> **replace(fullname,'s_','') fullname**



#### head.jsp

```jsp
<style>
.homethum	{
		  width: 300px;
		  height: 250px;
		  
		  object-fit: cover;
 	 }
    .
    .
    .
</style>
```



이미지의 크기가 제각각이므로

스타일 클래스로 전부 크기를 통일시킨 후	(300X250)

object-fit: cover;을 통해 크기맞춤으로 좀 더 자연스럽게 이미지 출력 