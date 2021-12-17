<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>

<%@ include file = "../../include/head.jsp" %>
<body class="hold-transition sidebar-mini">
<div class="wrapper">

  <!-- Navbar -->
  <%@ include file = "../../include/new_mainheader.jsp" %>
  <!-- /.navbar -->



  <!-- Content Wrapper. Contains page content -->

    <!-- Content Header (Page header) -->
 
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="container content">
	    <div class="content-header">
	      <div class="container-fluid">
	        <div class="row mb-2">
	          <div class="col-sm-6">
	            <h1 class=categoryfont>드라마 게시판</h1>
	          </div><!-- /.col -->
	  
	        </div><!-- /.row -->
	      </div><!-- /.container-fluid -->
	    </div>
      <div class="container-fluid">
					<div class="col-lg-12">
						<div class="card">
							<div class="card-header">
								<form action="${path}/article/search/list/drama" method="get">
									<select class="form-control" name="howAsc" id="howAsc" onchange='selectAsc(this.options[this.selectedIndex].value);'>
										<option value="">:::::: 정렬기준 선택 ::::::</option>
										<option value="viewcnt">조회순으로 보기</option>
										<option value="recently">최신순으로 보기</option>
									</select>
									<input type="hidden" value='$howAsc' name=howAsc>
								</form>
							</div>
							<div class="card-body table-responsive p-0">
								<table class="table table-hover">
									<thead>
										<tr class=listfont>
											<th style="width: 30px">#</th>
											<th style="width: 150px">사진</th>
											<th>제목</th>
											<th style="width: 100px">작성자</th>
											<th style="width: 150px">작성시간</th>
											<th style="width: 100px">조회</th>
										</tr>
									</thead>
									
									<tbody>
										<c:forEach items="${articles}" var="article">
											<tr class="col-md-6" style="cursor: pointer;" onclick="location.href='${path}/article/search/read${pageMaker.makeSearch(pageMaker.criteria.page)}&article_no=${article.article_no}';">
												<td>${article.article_no}</td>
												<td>
												<div class="thum">
													<c:if test="${empty article.fullname}">
	                                                		   	<span><img src="/dist/img/profile/NoThumbnail.png" alt="thumnail" class="listthum"></span>
	                                               	</c:if>
													<c:if test="${not empty article.fullname}">
                                               			     <span><img src="/file/display?fileName=${article.fullname}" alt="thumnail" class="listthum"></span>
                                               		</c:if>
                                               		</div>
                                               	</td>
												<td>
												<div class=titlefont>${article.title}</div>
													<span class="badge bg-aqua"><i class="fas fa-paperclip"></i> ${article.fileCnt}</span>
													<br>
														<c:set var="hashtags" value="${fn:split(article.hashtag,', ')}"/>
														<c:set var="leng" value="${fn:length(hashtags)}"/>
														
														<c:if test="${leng>=1 and hashtags[0] ne ''}">
															<c:forEach var="i" begin="0" end="${leng-1}" step="1">
																<span class="badge rounded-pill bg-light"># ${hashtags[i]}</span>
															</c:forEach>
														</c:if>
													<br>
													<i class="badge badge-danger"><i class="boardLike"><i class="fa">♥+${article.likesCnt}</i></i></i>
													<span class="badge bg-teal"><i class="fas fa-comment"></i> + ${article.replyCnt}</span>
												</td>
												<td>${article.writer}</td>
												<td><fmt:formatDate value="${article.regDate}"
														pattern="yyyy-MM-dd" /></td>
												<td><span class="badge bg-success">${article.viewCnt}</span></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
							<div class="card-footer">
								<nav aria-label="Contacts Page Navigation">
									<ul class="pagination justify-content-center m-0">
										<c:if test="${pageMaker.prev}">
											<li class="page-item"><a class="page-link"
												href="${path}/article/search/list/drama${pageMaker.makeSearch(pageMaker.startPage - 1)}">이전</a></li>
										</c:if>
										<c:forEach begin="${pageMaker.startPage}"
											end="${pageMaker.endPage}" var="idx">
											<li class="page-item"
												<c:out value="${pageMaker.criteria.page == idx ? 'class=active' : ''}"/>>
												<a class="page-link" href="${path}/article/search/list/drama${pageMaker.makeSearch(idx)}">${idx}</a>
											</li>
										</c:forEach>
										<c:if test="${pageMaker.next && pageMaker.endPage > 0}">
											<li class="page-item"><a class="page-link"
												href="${path}/article/search/list/drama${pageMaker.makeSearch(pageMaker.endPage + 1)}">다음</a></li>
										</c:if>
									</ul>
								</nav>
							</div>
							<div class="card-footer">
								<div class="row">
									<div class="form-group col-sm-2">
										<select class="form-control" name="searchType" id="searchType">
											<option value="n"
												<c:out value="${searchCriteria.searchType == null ? 'selected' : ''}"/>>::::::
												선택 ::::::</option>
											<option value="t"
												<c:out value="${searchCriteria.searchType eq 't' ? 'selected' : ''}"/>>제목</option>
											<option value="c"
												<c:out value="${searchCriteria.searchType eq 'c' ? 'selected' : ''}"/>>내용</option>
											<option value="w"
												<c:out value="${searchCriteria.searchType eq 'w' ? 'selected' : ''}"/>>작성자</option>
											<option value="h"
												<c:out value="${searchCriteria.searchType eq 'h' ? 'selected' : ''}"/>>해쉬태그</option>
											<option value="tc"
												<c:out value="${searchCriteria.searchType eq 'tc' ? 'selected' : ''}"/>>제목+내용</option>
											<option value="cw"
												<c:out value="${searchCriteria.searchType eq 'cw' ? 'selected' : ''}"/>>내용+작성자</option>
											<option value="tcw"
												<c:out value="${searchCriteria.searchType eq 'tcw' ? 'selected' : ''}"/>>제목+내용+작성자</option>
										</select>
									</div>
									<div class="form-group col-sm-10">
										<div class="input-group">
											<input type="text" class="form-control" name="keyword"
												id="keywordInput" value="${searchCriteria.keyword}"
												placeholder="검색어"> <span class="input-group-append">
												<button type="button" class="btn btn-primary btn-flat"
													id="searchBtn">
													<i class="fa fa-search"></i> 검색
												</button>
											</span>
										</div>
									</div>
								</div>
								<div class="float-right">
									<button type="button" class="btn btn-success btn-flat"
										id="writeBtn">
										<i class="fa fa-pencil"></i> 글쓰기
									</button>
								</div>
							</div>
						</div>
					</div>
				</div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->

  <!-- /.content-wrapper -->

  <!-- Control Sidebar -->
  <aside class="control-sidebar control-sidebar-dark">
    <!-- Control sidebar content goes here -->
    <div class="p-3">
      <h5>Title</h5>
      <p>Sidebar content</p>
    </div>
  </aside>
  <!-- /.control-sidebar -->

  <!-- Main Footer -->
  <%@ include file = "../../include/main_footer.jsp" %>
</div>
<!-- ./wrapper -->

<!-- REQUIRED SCRIPTS -->
 <%@ include file = "../../include/plugin_js.jsp" %>
<script>
function selectAsc($howAsc) {
	location.replace("${path}/article/search/list/drama?howAsc=" + $howAsc);
}

$(document).ready(function () {

	
	var result = "${msg}";
	if (result == "regSuccess") {
	    alert("게시글 등록이 완료되었습니다.");
	} else if (result == "modSuccess") {
	    alert("게시글 수정이 완료되었습니다.");
	} else if (result == "delSuccess") {
	    alert("게시글 삭제가 완료되었습니다.");
	}
	
    $("#searchBtn").on("click", function (event) {
        self.location =
            "${path}/article/search/list/drama${pageMaker.makeQuery(1)}"
            + "&searchType=" + $("select option:selected").val()
            + "&keyword=" + encodeURIComponent($("#keywordInput").val());
    });
    
    $("#writeBtn").on("click", function (event) {
        self.location = "${path}/article/search/write";
    });
});
</script>
</body>
</html>
