<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<%@ include file = "include/head.jsp" %>

<body>

<%@ include file = "include/new_mainheader.jsp" %>



<!-- main -->
<main role="main">
	<div class="container">
	<div id="carouselExampleIndicators" class="carousel slide jumbotron p-0 text-white objectfit" data-ride="carousel">
  <ol class="carousel-indicators">
    <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
    <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
  </ol>
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img class="d-block w-100" src="${path}/dist/img/slider/dokkaebi.png" alt="First slide">
    </div>
    <div class="carousel-item">
      <img class="d-block w-100" src="${path}/dist/img/slider/ssammyway.png" alt="Second slide">
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
     <div class="container">
	     <h3 class="pb-3 mb-4 font-weight-bold border-bottom"style="cursor: pointer;" onclick="location.href='${path}/article/search/list/movie';">
	            영화
	     </h3>
	     <div class="row mb-2">
	     <c:forEach items="${articles_m}" var="article">
	        <div class="col-md-6" style="cursor: pointer;" onclick="location.href='${path}/article/search/read${pageMaker.makeSearch(pageMaker.criteria.page)}&article_no=${article.article_no}';">
	          <div class="card flex-md-row mb-4 box-shadow h-md-250">
	            <div class="card-body d-flex flex-column align-items-start">
	              <strong class="d-inline-block mb-2 text-primary">좋아요 많은 게시물</strong>
	                   
	              <h3 class="mb-0 font-weight-bolder">
	                ${article.title}
	              </h3>
	              
	              <div class="mb-1 text-muted">
	              <fmt:formatDate value="${article.regDate}"
					pattern="yyyy-MM-dd" />
				  </div>
				  <i class="badge badge-danger"><i class="boardLike"><i class="fa">♥ +${article.likesCnt}</i></i></i>
	              <p class="card-text mb-auto">
	              <c:set var="hashtags" value="${fn:split(article.hashtag,', ')}"/>
									<c:set var="leng" value="${fn:length(hashtags)}"/>
									
									<c:choose>
										<c:when test="${leng>=1 and hashtags[0] ne ''}">
											<c:forEach var="i" begin="0" end="${leng-1}" step="1">
												<span class="badge rounded-pill bg-light"># ${hashtags[i]}</span>
											</c:forEach>
										</c:when>
										<c:when test="${leng<=1}">
											
										</c:when>
									</c:choose>
	            </div>
	            
	            	<c:if test="${empty article.fullname}">
	        		 	<span><img src="/dist/img/profile/NoThumbnail.png" alt="Attachment" class="homethum"></span>
	           		</c:if>
					<c:if test="${not empty article.fullname}">
                		<span><img src="/file/display?fileName=${article.fullname}" alt="Attachment" class="homethum"></span>
             	    </c:if>
	          </div>
	        </div>
	        </c:forEach>
	        <c:forEach items="${r_articles_m}" var="article">
	        <div class="col-md-6" style="cursor: pointer;" onclick="location.href='${path}/article/search/read${pageMaker.makeSearch(pageMaker.criteria.page)}&article_no=${article.article_no}';">
	          <div class="card flex-md-row mb-4 box-shadow h-md-250">
	            <div class="card-body d-flex flex-column align-items-start">
	              <strong class="d-inline-block mb-2 text-success font-weight-bold">최신게시물</strong>
	                   
	              <h3 class="mb-0 font-weight-bold">
	                ${article.title}
	              </h3>
	              
	              <div class="mb-1 text-muted">
	              <fmt:formatDate value="${article.regDate}"
					pattern="yyyy-MM-dd" />
				  </div>
				  <i class="badge badge-danger"><i class="boardLike"><i class="fa">♥ +${article.likesCnt}</i></i></i>
	              <p class="card-text mb-auto">
	              <c:set var="hashtags" value="${fn:split(article.hashtag,', ')}"/>
									<c:set var="leng" value="${fn:length(hashtags)}"/>
									
									<c:choose>
										<c:when test="${leng>=1 and hashtags[0] ne ''}">
											<c:forEach var="i" begin="0" end="${leng-1}" step="1">
												<span class="badge rounded-pill bg-light"># ${hashtags[i]}</span>
											</c:forEach>
										</c:when>
										<c:when test="${leng<=1}">
											
										</c:when>
									</c:choose>
	            </div>
	            
	            	<c:if test="${empty article.fullname}">
	        		 	<span><img src="/dist/img/profile/NoThumbnail.png" alt="Attachment" class="homethum"></span>
	           		</c:if>
					<c:if test="${not empty article.fullname}">
                		<span><img src="/file/display?fileName=${article.fullname}" alt="Attachment" class="homethum"></span>
             	    </c:if>
	          </div>
	        </div>
	        </c:forEach>
	      </div>
	     
	     <h3 class="pb-3 mb-4 font-weight-bold border-bottom"style="cursor: pointer;" onclick="location.href='${path}/article/search/list/drama';">
	            드라마
	     </h3>
	     <div class="row mb-2">
	     <c:forEach items="${articles_d}" var="article">
	        <div class="col-md-6" style="cursor: pointer;" onclick="location.href='${path}/article/search/read${pageMaker.makeSearch(pageMaker.criteria.page)}&article_no=${article.article_no}';">
	          <div class="card flex-md-row mb-4 box-shadow h-md-250">
	            <div class="card-body d-flex flex-column align-items-start">
	              <strong class="d-inline-block mb-2 text-primary font-weight-bold">좋아요 많은 게시물</strong>
	                   
	              <h3 class="mb-0 font-weight-bold">
	              ${article.title}
	              </h3>
	              <i class="badge badge-danger"><i class="boardLike"><i class="fa">♥ +${article.likesCnt}</i></i></i>
	              <div class="mb-1 text-muted">
	              <fmt:formatDate value="${article.regDate}"
					pattern="yyyy-MM-dd" />
				  </div>
				  
	              <p class="card-text mb-auto">
	              <c:set var="hashtags" value="${fn:split(article.hashtag,', ')}"/>
									<c:set var="leng" value="${fn:length(hashtags)}"/>
									
									<c:choose>
										<c:when test="${leng>=1 and hashtags[0] ne ''}">
											<c:forEach var="i" begin="0" end="${leng-1}" step="1">
												<span class="badge rounded-pill bg-light"># ${hashtags[i]}</span>
											</c:forEach>
										</c:when>
										<c:when test="${leng<=1}">
											
										</c:when>
									</c:choose>
	            </div>
	            
	            	<c:if test="${empty article.fullname}">
	        		 	<span><img src="/dist/img/profile/NoThumbnail.png" alt="Attachment" class="homethum"></span>
	           		</c:if>
					<c:if test="${not empty article.fullname}">
                		<span><img src="/file/display?fileName=${article.fullname}" alt="Attachment" class="homethum"></span>
             	    </c:if>
	          </div>
	        </div>
	        </c:forEach>
	        <c:forEach items="${r_articles_d}" var="article">
	        <div class="col-md-6" style="cursor: pointer;" onclick="location.href='${path}/article/search/read${pageMaker.makeSearch(pageMaker.criteria.page)}&article_no=${article.article_no}';">
	          <div class="card flex-md-row mb-4 box-shadow h-md-250">
	            <div class="card-body d-flex flex-column align-items-start">
	              <strong class="d-inline-block mb-2 text-success font-weight-bold">최신게시물</strong>
	                   
	              <h3 class="mb-0 font-weight-bold">
	                ${article.title}
	              </h3>
	              
	              <div class="mb-1 text-muted">
	              <fmt:formatDate value="${article.regDate}"
					pattern="yyyy-MM-dd" />
				  </div>
				  <i class="badge badge-danger"><i class="boardLike"><i class="fa">♥ +${article.likesCnt}</i></i></i>
	              <p class="card-text mb-auto">
	              <c:set var="hashtags" value="${fn:split(article.hashtag,', ')}"/>
									<c:set var="leng" value="${fn:length(hashtags)}"/>
									
									<c:choose>
										<c:when test="${leng>=1 and hashtags[0] ne ''}">
											<c:forEach var="i" begin="0" end="${leng-1}" step="1">
												<span class="badge rounded-pill bg-light"># ${hashtags[i]}</span>
											</c:forEach>
										</c:when>
										<c:when test="${leng<=1}">
											
										</c:when>
									</c:choose>
	            </div>
	            
	            	<c:if test="${empty article.fullname}">
	        		 	<span><img src="/dist/img/profile/NoThumbnail.png" alt="Attachment" class="homethum"></span>
	           		</c:if>
					<c:if test="${not empty article.fullname}">
                		<span><img src="/file/display?fileName=${article.fullname}" alt="Attachment" class="homethum"></span>
             	    </c:if>
	          </div>
	        </div>
	        </c:forEach>
	      </div>
	      
	      <h3 class="pb-3 mb-4 font-weight-bold border-bottom"style="cursor: pointer;" onclick="location.href='${path}/article/search/list/kpop';">
	            K-POP
	     </h3>
	     <div class="row mb-2">
	     <c:forEach items="${articles_k}" var="article">
	        <div class="col-md-6" style="cursor: pointer;" onclick="location.href='${path}/article/search/read${pageMaker.makeSearch(pageMaker.criteria.page)}&article_no=${article.article_no}';">
	          <div class="card flex-md-row mb-4 box-shadow h-md-250">
	            <div class="card-body d-flex flex-column align-items-start">
	              <strong class="d-inline-block mb-2 text-primary font-weight-bold">좋아요 많은 게시물</strong>
	                   
	              <h3 class="mb-0 font-weight-bold">
	              ${article.title}
	              </h3>
	              
	              <div class="mb-1 text-muted">
	              <fmt:formatDate value="${article.regDate}"
					pattern="yyyy-MM-dd" />
				  </div>
				  <i class="badge badge-danger"><i class="boardLike"><i class="fa">♥ +${article.likesCnt}</i></i></i>
	              <p class="card-text mb-auto">
	              <c:set var="hashtags" value="${fn:split(article.hashtag,', ')}"/>
									<c:set var="leng" value="${fn:length(hashtags)}"/>
									
									<c:choose>
										<c:when test="${leng>=1 and hashtags[0] ne ''}">
											<c:forEach var="i" begin="0" end="${leng-1}" step="1">
												<span class="badge rounded-pill bg-light"># ${hashtags[i]}</span>
											</c:forEach>
										</c:when>
										<c:when test="${leng<=1}">
											
										</c:when>
									</c:choose>
	            </div>
	            
	            	<c:if test="${empty article.fullname}">
	        		 	<span><img src="/dist/img/profile/NoThumbnail.png" alt="Attachment" class="homethum"></span>
	           		</c:if>
					<c:if test="${not empty article.fullname}">
                		<span><img src="/file/display?fileName=${article.fullname}" alt="Attachment" class="homethum"></span>
             	    </c:if>
	          </div>
	        </div>
	        </c:forEach>
	        <c:forEach items="${r_articles_k}" var="article">
	        <div class="col-md-6" style="cursor: pointer;" onclick="location.href='${path}/article/search/read${pageMaker.makeSearch(pageMaker.criteria.page)}&article_no=${article.article_no}';">
	          <div class="card flex-md-row mb-4 box-shadow h-md-250">
	            <div class="card-body d-flex flex-column align-items-start">
	              <strong class="d-inline-block mb-2 text-success font-weight-bold">최신게시물</strong>
	                   
	              <h3 class="mb-0 font-weight-bold">
	                ${article.title}
	              </h3>
	              
	              <div class="mb-1 text-muted">
	              <fmt:formatDate value="${article.regDate}"
					pattern="yyyy-MM-dd" />
				  </div>
				  <i class="badge badge-danger"><i class="boardLike"><i class="fa">♥ +${article.likesCnt}</i></i></i>
	              <p class="card-text mb-auto">
	              <c:set var="hashtags" value="${fn:split(article.hashtag,', ')}"/>
									<c:set var="leng" value="${fn:length(hashtags)}"/>
									
									<c:choose>
										<c:when test="${leng>=1 and hashtags[0] ne ''}">
											<c:forEach var="i" begin="0" end="${leng-1}" step="1">
												<span class="badge rounded-pill bg-light"># ${hashtags[i]}</span>
											</c:forEach>
										</c:when>
										<c:when test="${leng<=1}">
											
										</c:when>
									</c:choose>
	            </div>
	            
	            	<c:if test="${empty article.fullname}">
	        		 	<span><img src="/dist/img/profile/NoThumbnail.png" alt="Attachment" class="homethum"></span>
	           		</c:if>
					<c:if test="${not empty article.fullname}">
                		<span><img src="/file/display?fileName=${article.fullname}" alt="Attachment" class="homethum"></span>
             	    </c:if>
	          </div>
	        </div>
	        </c:forEach>
	      </div>
     
     
	</div>
	</div>
    </main>


<%@ include file = "include/main_footer.jsp" %>
<%@ include file = "include/plugin_js.jsp" %>
</body>
</html>