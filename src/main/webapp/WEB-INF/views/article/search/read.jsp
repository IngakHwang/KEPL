<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	//줄바꿈
	pageContext.setAttribute("br", "<br/>");
	pageContext.setAttribute("cn", "\n");
%>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>
<%@ include file = "../../include/head.jsp" %>

<style>
	#like{
		text-align:center;
	}
	.like {display:inline-block;zoom:1;.display:inline;}
</style>
<script type="text/javascript" src="${path}/resources/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=lyjg8pre32"></script>

<body class="hold-transition sidebar-mini font-weight-bold">
<div class="wrapper">

  <!-- Navbar -->
  <%@ include file = "../../include/new_mainheader.jsp" %>
  <!-- /.navbar -->

  <!-- Content Wrapper. Contains page content -->
  <div class="container content">
	    <div class="content-header">
	      <div class="container-fluid">
	        <div class="row mb-2">
	          <div class="col-sm-6">
	            <h1 class=categoryfont>게시판 읽기</h1>
	          </div><!-- /.col -->
	  
	        </div><!-- /.row -->
	      </div><!-- /.container-fluid -->
	    </div>
   

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">
					<div class="col-lg-12">
						<div class="card">
							<div class="card ">
								<div class="card-header with-border">
									<h3 class="readtitlefont">${article.title}</h3>
								</div>
								<div class="card-header with-border">
									<h3 class="card-title">${article.category}	
								&nbsp;&nbsp;|&nbsp;&nbsp;<fmt:formatDate value="${article.regDate}"
														pattern="yyyy-MM-dd" /></h3>
								</div>
								<div class="card-header with-border">
									
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
								
								<div class="card-body" style="height: 700px">${fn:replace(article.content,cn,br)}
								</div>

							</div>
							<div class="box-footer uploadFiles">
								<ul class="mailbox-attachments clearfix uploadedList"></ul>
							</div>

	 						<div class="box-footer location">
								<h2 class="card-title"> <b>위치 : </b> <a href="https://map.naver.com/v5/search/${article.addr}" target="_blank">${article.addr}</a></h2> 
								<input type="hidden" id="addr" name="addr" value="${article.addr}">
								<div class="container-md map">
									<br>
									<div id="map" style="width:100%;height:500px;"></div>
								</div>
								<br>
							</div>

							<div class="card-footer">
								<div class="user-block">
									<img class="img-circle img-bordered-sm"
										src="${path}/dist/img/profile/${article.writerImg}" alt="user image"> 										
										<span class="username"> <a href="#">${article.writer}</a>
									</span> <span class="description"><fmt:formatDate
											pattern="yyyy-MM-dd" value="${article.regDate}" /></span>
								</div>
							</div>
							<div class="card-footer">
								<form role="form" method="post">
									<input type="hidden" name="article_no" value="${article.article_no}">
							        <input type="hidden" name="page" value="${searchCriteria.page}">
							        <input type="hidden" name="perPageNum" value="${searchCriteria.perPageNum}">
							        <input type="hidden" name="searchType" value="${searchCriteria.searchType}">
							        <input type="hidden" name="keyword" value="${searchCriteria.keyword}">
								</form>
								<button type="submit" class="btn btn-primary listBtn">
										<i class="fa fa-list"></i> 목록
									</button>
								<c:if test="${login.userId == article.writer}">
								<div class="float-right">
									
									<button type="submit" class="btn btn-warning modBtn">
										<i class="fa fa-edit"></i> 수정
									</button>
									<button type="submit" class="btn btn-danger delBtn">
										<i class="fa fa-trash"></i> 삭제
									</button>
								</div>
								</c:if>
							</div>
						</div>
						<div id="like">
							<div></div>
							<div class="like" >
								<button type="button" class="btn btn-danger btn-lg "  id="likeBtn">
									<i class="fa fa-thumbs-o-up fa-heart boardLike">  <span></span></i>   
								</button>
								<br></br>
							</div>
							<div></div>
			            </div>
						
						<div class="card">
							<div class="card-body">
							<c:if test="${not empty login}">
								<form class="form-horizontal">
									<div class="row">
										<div class="form-group col-sm-8">
											<input class="form-control input-sm" id="newReplyText"
												type="text" placeholder="댓글 입력...">
										</div>
										<div class="form-group col-sm-2" hidden>

											<input class="form-control input-sm" id="newReplyWriter"
												type="text" value="${login.userId}" readonly>
										</div>
										<div class="form-group col-sm-2">
											<button type="button"
												class="btn btn-primary btn-sm btn-block replyAddBtn">
												<i class="fa fa-save"></i> 저장
											</button>
										</div>
									</div>
								</form>
							</c:if>
							<c:if test="${empty login}">
					            <a href="${path}/user/login" class="btn btn-default btn-block" role="button">
					                <i class="fa fa-edit"></i> 로그인 한 사용자만 댓글 등록이 가능합니다.
					            </a>
					        </c:if>
							</div>
						</div>
						<div class="card card-primary card-outline">
							<%--댓글 유무 / 댓글 갯수 / 댓글 펼치기, 접기--%>
							<div class="card-header">
								<a href="" class="link-black text-lg"><i
									class="fas fa-comments margin-r-5 replyCount"></i></a>
								<div class="card-tools">
									<button type="button" class="btn btn-box-tool"
										data-widget="collapse">
										<i class="fa fa-plus"></i>
									</button>
								</div>
							</div>
							<%--댓글 목록--%>
							<div class="card-body repliesDiv"></div>
							<%--댓글 페이징--%>
							<div class="card-footer">
								<nav aria-label="Contacts Page Navigation">
									<ul class="pagination pagination-sm no-margin justify-content-center m-0">

									</ul>
								</nav>
							</div>
						</div>
					</div>
					<%--댓글 수정 modal 영역--%>
					<div class="modal fade" id="modModal">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
									<h4 class="modal-title">댓글수정</h4>
								</div>
								<div class="modal-body" data-rno>
									<input type="hidden" class="reply_no" />
									<%--<input type="text" id="replytext" class="form-control"/>--%>
									<textarea class="form-control" id="reply_text" rows="3"
										style="resize: none"></textarea>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-default float-left"
										data-dismiss="modal">닫기</button>
									<button type="button" class="btn btn-primary modalModBtn">수정</button>
								</div>
							</div>
						</div>
					</div>

					<%--댓글 삭제 modal 영역--%>
					<div class="modal fade" id="delModal">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
									<h4 class="modal-title">댓글 삭제</h4>
									<input type="hidden" class="rno" />
								</div>
								<div class="modal-body" data-rno>
									<p>댓글을 삭제하시겠습니까?</p>
									<input type="hidden" class="rno" />
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-default float-left"
										data-dismiss="modal">아니요.</button>
									<button type="button" class="btn btn-primary modalDelBtn">네.
										삭제합니다.</button>
								</div>
							</div>
						</div>
					</div>
				</div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </div>
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
//전역변수
var article_no = "${ArticleVO.article_no}"; // 현재 게시글 번호
       var userId = "${login.userId}";


/*================================================게시글 추천 관련==================================*/
var article_no = "${article.article_no}";
var boardLike = $(".boardLike");
//게시글 추천수
var totalCountBoardLike = function () {
   $.getJSON("/like/count/" + article_no, function (result) {
      console.log(result.likeTotalCount);
      boardLike.find("span").html(result.likeTotalCount);
   });
};
totalCountBoardLike();
//게시글 추천여부 확인

var checkBoardLike = function () {
   boardLike.find("i").attr("class", "fa fa-thumbs-o-up fa-heart");
   $.getJSON("/like/check/" + article_no + "/" + userId, function (result) {
   	console.log(result.checkBoardLike);
       var likeCheck = result.checkBoardLike;
       
       if (likeCheck == false) {
           boardLike.find("i").attr("class", "fa fa-thumbs-o-up fa-heart");
           if (confirm("추천하시겠습니까?")) {
               $.ajax({
                   type: "post",
                   url: "/like/create/" + article_no + "/" + userId,
                   headers: {
                       "Content-Type" : "application/json",
                       "X-HTTP-Method-Override" : "POST"
                   },
                   dataType: "text",
                   success: function (result) {
                       console.log("result : " + result);
                       if (result == "BOARD LIKE CREATED") {
                           alert("게시글이 추천되었습니다.");                            
                           totalCountBoardLike();
                       }
                   }
               });
           
           }
           return;
       }
       
       else if (likeCheck == true){
       if(confirm("추천을 취소하시겠습니까?")) {
           $.ajax({
               type: "delete",
               url: "/like/remove/" + article_no + "/" + userId,
               headers: {
                   "Content-Type" : "application/json",
                   "X-HTTP-Method-Override" : "DELETE"
               },
               dataType: "text",
               success: function (result) {
                   console.log("result : " + result);
                   if (result == "BOARD LIKE REMOVED") {
                       alert("게시글 추천이 취소되었습니다.");                        
                       totalCountBoardLike();
                   }
           	   }
          	 });
			
       }
       
       }
       
   });
};



var isBoardLike = boardLike.find("i").hasClass("fa fa-thumbs-o-up fa-heart");
//게시글 추천하기 or 취소하기
$("#likeBtn").on("click", function () {
   if (userId == "") {
       alert("로그인 후에 추천할 수 있습니다.");
       location.href = "/user/login";
       return;
   }
   // 추천여부 확인
   var isBoardLike = boardLike.find("i").hasClass("fa fa-thumbs-o-up fa-heart");
   // 미추천일 경우
   checkBoardLike();
});
   
   
/*================================================댓글 추천 관련==================================*/

//댓글 추천수 갱신
var totalCountReplyLike = function (rno, replyLike) {
   console.log(rno);
   console.log(replyLike);
   $.getJSON("/like/count/" + bno + "/" + rno, function (result) {
       console.log(result.replyLikeTotalCount);
       replyLike.find("span").html("(" + result.replyLikeTotalCount + ")");
   });
};

$(document).ready(function () {

    var formObj = $("form[role='form']");
    console.log(formObj);

    $(".modBtn").on("click", function () {
        formObj.attr("action", "${path}/article/search/modify");
        formObj.attr("method", "get");
        formObj.submit();
    });

    $(".delBtn").on("click", function () {
        formObj.attr("action", "${path}/article/search/remove");
        formObj.submit();
    });

    $(".listBtn").on("click", function () {
        formObj.attr("action", "${path}/article/search/list");
        formObj.attr("method", "get");
        formObj.submit();
    });
    
    var article_no = "${article.article_no}";  // 현재 게시글 번호
    var replyPageNum = 1; // 댓글 페이지 번호 초기화

    // 댓글 내용 : 줄바꿈/공백처리
    Handlebars.registerHelper("escape", function (reply_text) {
        var text = Handlebars.Utils.escapeExpression(reply_text);
        text = text.replace(/(\r\n|\n|\r)/gm, "<br/>");
        text = text.replace(/( )/gm, "&nbsp;");
        return new Handlebars.SafeString(text);
    });
    
    Handlebars.registerHelper("eqReplyWriter", function (reply_writer, block) {
        var accum = "";
        if (reply_writer === "${login.userId}") {
            accum += block.fn();
        }
        return accum;
    });

    // 댓글 등록일자 : 날짜/시간 2자리로 맞추기
    Handlebars.registerHelper("prettifyDate", function (timeValue) {
        var dateObj = new Date(timeValue);
        var year = dateObj.getFullYear();
        var month = dateObj.getMonth() + 1;
        var date = dateObj.getDate();
        var hours = dateObj.getHours();
        var minutes = dateObj.getMinutes();
        // 2자리 숫자로 변환
        month < 10 ? month = '0' + month : month;
        date < 10 ? date = '0' + date : date;
        hours < 10 ? hours = '0' + hours : hours;
        minutes < 10 ? minutes = '0' + minutes : minutes;
        return year + "-" + month + "-" + date;
    });

    // 댓글 목록 함수 호출
    getReplies("${path}/replies/" + article_no + "/" + replyPageNum);

    // 댓글 목록 함수
    function getReplies(repliesUri) {
        $.getJSON(repliesUri, function (data) {
            printReplyCount(data.pageMaker.totalCount);
            printReplies(data.replies, $(".repliesDiv"), $("#replyTemplate"));
            printReplyPaging(data.pageMaker, $(".pagination"));
        });
    }

    // 댓글 갯수 출력 함수
    function printReplyCount(totalCount) {

        var replyCount = $(".replyCount");
        var collapsedBox = $(".collapsed-box");

        // 댓글이 없으면
        if (totalCount === 0) {
            replyCount.html(" 댓글이 없습니다. 의견을 남겨주세요");
            collapsedBox.find(".btn-box-tool").remove();
            return;
        }

        // 댓글이 존재하면
        replyCount.html(" 댓글목록 (" + totalCount + ")");
        collapsedBox.find(".box-tools").html(
            "<button type='button' class='btn btn-box-tool' data-widget='collapse'>"
            + "<i class='fa fa-plus'></i>"
            + "</button>"
        );

    }

    // 댓글 목록 출력 함수
    function printReplies(replyArr, targetArea, templateObj) {
        var replyTemplate = Handlebars.compile(templateObj.html());
        var html = replyTemplate(replyArr);
        $(".replyDiv").remove();
        targetArea.html(html);
    }

    // 댓글 페이징 출력 함수
    function printReplyPaging(pageMaker, targetArea) {
    	var str = "";

	    // 이전 버튼 활성화
	    if (pageMaker.prev) {
	        str += "<li class=\"page-item\"><a class=\"page-link\" href='"+(pageMaker.startPage-1)+"'>이전</a></li>";
	    }

	    // 페이지 번호
	    for (var i = pageMaker.startPage, len = pageMaker.endPage; i <= len; i++) {
	        var strCalss = pageMaker.criteria.page == i ? 'class=active' : '';
	        str += "<li class=\"page-item\" "+strCalss+"><a class=\"page-link\" href='"+i+"'>"+i+"</a></li>";
	    }

	    // 다음 버튼 활성화
	    if (pageMaker.next) {
	        str += "<li class=\"page-item\"><a class=\"page-link\" href='"+(pageMaker.endPage + 1)+"'>다음</a></li>";
	    }
        targetArea.html(str);
    }

    // 댓글 페이지 번호 클릭 이벤트
    $(".pagination").on("click", "li a", function (event) {
        event.preventDefault();
        replyPageNum = $(this).attr("href");
        getReplies("${path}/replies/" + article_no + "/" + replyPageNum);
    });
	
 	// 댓글 저장 버튼 클릭 이벤트
    $(".replyAddBtn").on("click", function () {

        // 입력 form 선택자
        var reply_writerObj = $("#newReplyWriter");
        var reply_textObj = $("#newReplyText");
        var reply_writer = reply_writerObj.val();
        var reply_text = reply_textObj.val();

        // 댓글 입력처리 수행
        $.ajax({
            type : "post",
            url : "${path}/replies/",
            headers : {
                "Content-Type" : "application/json",
                "X-HTTP-Method-Override" : "POST"
            },
            dataType : "text",
            data : JSON.stringify({
                article_no : article_no,
                reply_writer : reply_writer,
                reply_text : reply_text
            }),
            success: function (result) {
                console.log("result : " + result);
                if (result === "regSuccess") {
                    alert("댓글이 등록되었습니다.");
                    
                    getReplies("${path}/replies/" + article_no + "/" + replyPageNum); // 댓글 목록 호출
                    reply_textObj.val("");   // 댓글 입력창 공백처리
                   
                }
            }
        });
    });
 	
 	// 댓글 수정을 위해 modal창에 선택한 댓글의 값들을 세팅
    $(".repliesDiv").on("click", ".replyDiv", function (event) {
        var reply = $(this);
        $(".reply_no").val(reply.attr("data-reply_no"));
        $("#reply_text").val(reply.find(".oldReplyText").text());
    });

    // modal 창의 댓글 수정버튼 클릭 이벤트
    $(".modalModBtn").on("click", function () {
        var reply_no = $(".reply_no").val();
        var reply_text = $("#reply_text").val();
        $.ajax({
            type : "put",
            url : "${path}/replies/" + reply_no,
            headers : {
                "Content-Type" : "application/json",
                "X-HTTP-Method-Override" : "PUT"
            },
            dataType : "text",
            data: JSON.stringify({
            	reply_text : reply_text
            }),
            success: function (result) {
                console.log("result : " + result);
                if (result === "modSuccess") {
                    alert("댓글이 수정되었습니다.");
                    getReplies("${path}/replies/" + article_no + "/" + replyPageNum); // 댓글 목록 호출
                    $("#modModal").modal("hide"); // modal 창 닫기
                }
            }
        })
    });

    // modal 창의 댓글 삭제버튼 클릭 이벤트
    $(".modalDelBtn").on("click", function () {
        var reply_no = $(".reply_no").val();
        $.ajax({
            type: "delete",
            url: "${path}/replies/" + reply_no,
            headers: {
                "Content-Type" : "application/json",
                "X-HTTP-Method-Override" : "DELETE"
            },
            dataType: "text",
            success: function (result) {
                console.log("result : " + result);
                if (result === "delSuccess") {
                    alert("댓글이 삭제되었습니다.");
                    getReplies("${path}/replies/" + article_no + "/" + replyPageNum); // 댓글 목록 호출
                    $("#delModal").modal("hide"); // modal 창 닫기
                }
            }
        });
    });
    
    var templatePhotoAttach = Handlebars.compile($("#templatePhotoAttach").html()); // 이미지 template
    var templateFileAttach = Handlebars.compile($("#templateFileAttach").html());   // 일반파일 template
    $.getJSON("/file/list/" + article_no, function (list) {
        if (list.length == 0) {
            $(".uploadedList").html("첨부파일이 없습니다.");
        }
        $(list).each(function () {
            // 파일정보 가공
            var fileInfo = getFileInfo(this);
           	
            // 이미지 파일일 경우
            if (fileInfo.fullName.substr(12, 2) == "s_") {
                var html = templatePhotoAttach(fileInfo);
                // 이미지 파일이 아닐 경우
            } else {
                html = templateFileAttach(fileInfo);
            }
            $(".uploadedList").append(html);
        })
    });
});
</script>
<script id="replyTemplate" type="text/x-handlebars-template">
    {{#each.}}
    <div class="post replyDiv" data-reply_no={{reply_no}}>
        <div class="user-block">
            <img class="img-circle img-bordered-sm" src="../../dist/img/profile/{{userVO.userImg}}" alt="user image">
            <span class="username">
                <a href="#">{{reply_writer}}</a>
				{{#eqReplyWriter reply_writer}}
                <a href="#" class="float-right btn-box-tool replyDelBtn" data-toggle="modal" data-target="#delModal">
                    <i class="fa fa-times"> 삭제</i>
                </a>
                <a href="#" class="float-right btn-box-tool replyModBtn" data-toggle="modal" data-target="#modModal">
                    <i class="fa fa-edit"> 수정</i>
                </a>
 				{{/eqReplyWriter}}
            </span>
            <span class="description">{{prettifyDate reg_date}}</span>
        </div>
        <div class="oldReplyText">{{reply_text}}</div>
        <br/>
    </div>
    {{/each}}
</script>
<script type="text/javascript">
	$(document).ready(function(){
        var address = $("#addr").val();
        
        //주소값이 없으면 div 태그에 id=map 인 태그 삭제, location 클래스 태그 삭제
		if (!address) {
            $("div").remove("#map");
            $("div").remove(".location");
            return;
        } 
		
		$.ajax({
	         type:"get",
	         url:"map1",
	         contentType: "application/json",
	         data :{"addr":$("#addr").val()},
		     success:function (data,textStatus){
		    	  //alert(data); // 2번
		    	  resultText = JSON.parse(data);
		    	  //text = resultText.results[0].region.area1.name+","+resultText.results[1]
		    	  var lang1 = resultText.addresses[0].x;
		    	  var lat1 = resultText.addresses[0].y;
		    	  

		    	  var mapOptions = {
						    center: new naver.maps.LatLng(lat1, lang1),
						    zoom: 15
						};
				var map = new naver.maps.Map('map', mapOptions);
				var marker = new naver.maps.Marker({
				    position: new naver.maps.LatLng(lat1, lang1),
				    map: map
				}); 
		     },
		     error:function(data,textStatus){
		        alert("에러가 발생했습니다.");
		     },
		     complete:function(data,textStatus){
		    	 
		     }
		  });
		
		var mapOptions = {
		    center: new naver.maps.LatLng(lat, lang),
		    zoom: 15
		};
		var map = new naver.maps.Map('map', mapOptions);
		var marker = new naver.maps.Marker({
		    position: new naver.maps.LatLng(lat, lang),
		    map: map
		}); 
	});
</script>
<script type="text/javascript" src="../../resources/dist/js/upload.js"></script>

<%--첨부파일 하나의 영역--%>
<%--이미지--%>
<script id="templatePhotoAttach" type="text/x-handlebars-template">
    <li>
        <span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
        <div class="mailbox-attachment-info">
            <a href="{{getLink}}" class="mailbox-attachment-name" data-lightbox="uploadImages" target="_blank"><i class="fas fa-camera"></i> {{fileName}}</a>
        </div>
    </li>
</script>
<%--일반 파일--%>
<script id="templateFileAttach" type="text/x-handlebars-template">
    <li>
        <span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
        <div class="mailbox-attachment-info">
            <a href="{{getLink}}" class="mailbox-attachment-name"><i class="fas fa-paperclip"></i> {{fileName}}</a>
        </div>
    </li>
</script>
</body>
</html>