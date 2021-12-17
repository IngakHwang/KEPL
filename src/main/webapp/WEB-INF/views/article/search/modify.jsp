

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>
<%@ include file = "../../include/head.jsp" %>
<script type="text/javascript" src="${path}/resources/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=lyjg8pre32"></script>

<style>
    .fileDrop {
        width: 100%;
        height: 200px;
        border: 2px dotted #0b58a2;
    }
</style>
<body class="hold-transition sidebar-mini">
<div class="wrapper">

  <!-- Navbar -->
  <%@ include file = "../../include/new_mainheader.jsp" %>
  <!-- /.navbar -->

  <!-- Content Wrapper. Contains page content -->
  <div class="container content">
    <!-- Content Header (Page header) -->
	    <div class="content-header">
	      <div class="container-fluid">
	        <div class="row mb-2">
	        </div><!-- /.row -->
	      </div><!-- /.container-fluid -->
	    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">
					<div class="col-lg-12">
						<form role="form" id="writeForm" method="post"
							action="${path}/article/search/modify">
							<div class="card ">
								<div class="card-header with-border">
									<h3 class="listcategoryfont">게시글 수정</h3>
								</div>
								<div class="card-body">
									<input type="hidden" name="article_no" value="${article.article_no}">
									<input type="hidden" name="page" value="${searchCriteria.page}">
								    <input type="hidden" name="perPageNum" value="${searchCriteria.perPageNum}">
								    <input type="hidden" name="searchType" value="${searchCriteria.searchType}">
								    <input type="hidden" name="keyword" value="${searchCriteria.keyword}">
									<div class="form-group">
										<label for="title">제목</label> <input class="form-control"
											id="title" name="title" placeholder="제목을 입력해주세요"
											value="${article.title}">
									</div>
									<div class="form-group">
										<label for="title">카테고리</label>
										<select class="form-control" aria-label="Default select example" name="category" id="choose">	
												<option value="">카테고리를 선택해 주세요</option>
												<option value="movie" <c:if test="${article.category eq 'movie'}">selected="selected"</c:if>>영화</option>
												<option value="drama" <c:if test="${article.category eq 'drama'}">selected="selected"</c:if>>드라마</option>
												<option value="k-pop" <c:if test="${article.category eq 'k-pop'}">selected="selected"</c:if>>K-POP</option>
										</select>
									</div>
									<div class="form-group">
										<label for="title">해쉬태그(#) <button type="button" class="btn btn-outline-warning btn-sm">초기화</button></label> 
										<div class="input-group">
											<input class="form-control input-sm col-md-2" type="text" id="hashtag" placeholder="해쉬태그 항목을 입력해주세요">
											<button class="btn btn-primary col-md-1" type="button" id="btn_hash">추가</button>
											<div class="col-md-6" id="hashtagValue">
												<c:set var="hashtags" value="${fn:split(article.hashtag,', ')}"/>
												<c:set var="leng" value="${fn:length(hashtags)}"/>
												
												<c:choose>
													<c:when test="${leng>=1 and hashtags[0] ne ''}">
														<c:forEach var="i" begin="0" end="${leng-1}" step="1">
															<span class="badge rounded-pill bg-light tags"># ${hashtags[i]}</span>
														</c:forEach>
													</c:when>
													<c:when test="${leng<=1}">
														
													</c:when>
												</c:choose>
												<input type="hidden" id="tagValue" name="hashtags" value="">
											</div>
										</div>
									</div>
									<div class="form-group">
										<label for="content">내용</label>
										<textarea class="form-control" id="content" name="content"
											rows="30" placeholder="내용을 입력해주세요" style="resize: none;">${article.content}</textarea>
									</div>
									<div class="form-group">
										<label for="writer">작성자</label> <input class="form-control"
											id="writer" name="writer" value="${article.writer}" readonly>
									</div>
									
									<div class="form-group">
										<div class="fileDrop">
											<br /> <br /> <br /> <br />
											<p class="text-center">
												<i class="fa fa-paperclip"></i> 첨부파일을 드래그해주세요.
											</p>
										</div>
									</div>

									<div class="box-footer">
		                           		<ul class="mailbox-attachments clearfix uploadedList"></ul>
		                        	</div>
		                        	
		                        <div class="form-group">
										<label for="content">위치 </label>
										<div class="input-group">
											<input class="form-control input-sm col-md-10" type="text" name="addr" id="addr" size="30" placeholder="주소를 입력해주세요" value="${article.addr}">
											<div class="col-md-1"></div>
											<button class="btn btn-primary col-md-1" type="button" name="send" id="sendMark">검색</button>
										</div>
										<div class="container-md map">
											<!-- <br>
											<div id="map" style="width:100%;height:500px;"></div> -->
										</div>
									</div>
								</div>
								
								<div class="card-footer">
									<div class="float-right">
										<button type="button" class="btn btn-warning cancelBtn">
											<i class="fa fa-trash"></i> 취소
										</button>
										<button type="submit" class="btn btn-success modBtn">
											<i class="fa fa-save"></i> 수정 저장
										</button>
									</div>
								</div>
							</div>
						</form>
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
$(document).ready(function () {
	var article_no = ${article.article_no}; // 현재 게시글 번호
    var templatePhotoAttach = Handlebars.compile($("#templatePhotoAttach").html()); // 이미지 Template
    var templateFileAttach = Handlebars.compile($("#templateFileAttach").html());   // 일반파일 Template
    /*================================================게시판 업로드 첨부파일 추가관련===================================*/
    // 전체 페이지 파일 끌어 놓기 기본 이벤트 방지 : 지정된 영역외에 파일 드래그 드랍시 페이지 이동방지
    $(".content-wrapper").on("dragenter dragover drop", function (event) {
        event.preventDefault();
    });
    // 파일 끌어 놓기 기본 이벤트 방지
    $(".fileDrop").on("dragenter dragover", function (event) {
        event.preventDefault();
    });
    // 파일 드랍 이벤트 : 파일 전송 처리
    $(".fileDrop").on("drop", function (event) {
        event.preventDefault();
        var files = event.originalEvent.dataTransfer.files;
        var file = files[0];
        var formData = new FormData();
        formData.append("file", file);
        $.ajax({
            url: "/file/upload",
            data: formData,
            dataType: "text",
            processData: false,
            contentType: false,
            type: "POST",
            success: function (data) {
                // 파일정보 가공
                var fileInfo = getFileInfo(data);
                // 이미지 파일일 경우
                if (fileInfo.fullName.substr(12, 2) == "s_") {
                    var html = templatePhotoAttach(fileInfo);
                    // 이미지 파일이 아닐경우
                } else {
                    html = templateFileAttach(fileInfo);
                }
                // 목록에 출력
                $(".uploadedList").append(html);
            }
        });
    });
    // 수정 처리시 파일 정보도 함께 처리
    $("#writeForm").submit(function (event) {
        event.preventDefault();
        var that = $(this);
        var str = "";
        $(".uploadedList .delBtn").each(function (index) {
            str += "<input type='hidden' name='files["+index+"]' value='"+$(this).attr("href")+"'>"
        });
        that.append(str);
        that.get(0).submit();
    });
    // 파일 삭제 버튼 클릭 이벤트
    $(document).on("click", ".delBtn", function (event) {
        event.preventDefault();
        if (confirm("삭제하시겠습니까? 삭제된 파일은 복구할 수 없습니다.")) {
            var that = $(this);
            $.ajax({
                url: "/file/delete/" + article_no,
                type: "post",
                data: {fileName:$(this).attr("href")},
                dataType: "text",
                success: function (result) {
                    if (result == "DELETED") {
                        alert("삭제되었습니다.");
                        that.parents("li").remove();
                    }
                }
            });
        }
    });
    /*================================================게시판 업로드 첨부파일 목록관련===================================*/
    $.getJSON("/file/list/" + article_no, function (list) {
        $(list).each(function () {
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
    
    var formObj = $("form[role='form']");
    console.log(formObj);

    

    $(".cancelBtn").on("click", function () {
        history.go(-1);
    });

    $(".listBtn").on("click", function () {
        self.location = "${path}/article/search/list?page=${searchCriteria.page}"
            + "&perPageNum=${searchCriteria.perPageNum}"
            + "&searchType=${searchCriteria.searchType}"
            + "&keyword=${searchCriteria.keyword}";
    });

});
</script>
<script type="text/javascript" src="../../resources/dist/js/upload.js"></script>
<script>
function viewMap(){
	$.ajax({
		type:"get",
		url:"map1",
		 contentType: "application/json",
         data :{"addr":$("#addr").val()},
         success:function (data,textStatus){
	    	  
	    	  resultText = JSON.parse(data);
	    	  
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
}
</script>
<script type="text/javascript">
	$(document).ready(function(){
		var i=0;
		var mapValue=$("#addr").val();
		
		if(typeof mapValue == "underfined" || mapValue == null || mapValue == "" ){
			
		} else{
			$(".map").append("<br>");
			$(".map").append('<div id="map" style="width:100%;height:500px;"></div>');
			i++;
			viewMap();
		}
		
		$('#sendMark').click(function(){
			//alert('sendMark')
				event.preventDefault();
				
				if(i==0){
					$(".map").append("<br>");
					$(".map").append('<div id="map" style="width:100%;height:500px;"></div>');
					i++;
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
			    	  //alert(lat1+", "+lang1);
			    	  $('#span_lat').text(lat1);
			    	  $('#span_lang').text(lang1);
			    	  //var result = resultText.meta[0].totalCount;
			    	  //alert(result);
			    	 // alert(text); // 3번
			    	 // $('#message').text(text);
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
	});
</script>
<script>
$(document).ready(function() {
	
	var arr = new Array();
	
	<c:set var="hashtags" value="${fn:split(article.hashtag,', ')}"/>
	<c:set var="leng" value="${fn:length(hashtags)}"/>
	<c:choose>
		<c:when test="${leng>1}">
			<c:forEach var="i" begin="0" end="${leng-1}" step="1">
				arr.push("${hashtags[i]}");
			</c:forEach>
		</c:when>
		<c:when test="${leng<=1}">
			
		</c:when>
	</c:choose>
	
	$("#tagValue").val(arr);	//기존 값 추가
	
	$("#btn_hash").on("click", function () {
	    	
	   var test = $('#hashtag').val();
	    
	   if(arr.includes(test) == false){
		   arr.push(test);
		   
		   var html = '<span class="badge rounded-pill bg-light tags"> # ';
		   html += test ;
		   html +="</span> &nbsp;";
		    $("#hashtagValue").append(html);
		    
		    $("#tagValue").val(arr);
	   } else{
		   alert("태그가 중복되었습니다.");
	   }
	   
	});
	
	$(".btn-outline-warning").on("click", function () {

		$('span').remove(".tags");
		//$('div').html().replace(/&nbsp;/gi,"");
		arr = [];
		$("#tagValue").val(arr)
				
	});
	
});
</script>

<%--첨부파일 하나의 영역--%>
<%--이미지--%>
<script id="templatePhotoAttach" type="text/x-handlebars-template">
    <li>
        <span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
        <div class="mailbox-attachment-info">
            <a href="{{getLink}}" class="mailbox-attachment-name" data-lightbox="uploadImages"><i class="fas fa-camera"></i> {{fileName}}</a>
            <a href="{{fullName}}" class="btn btn-default btn-xs float-right delBtn"><i class="far fa-trash-alt"></i></a>
        </div>
    </li>
</script>
<%--일반 파일--%>
<script id="templateFileAttach" type="text/x-handlebars-template">
    <li>
        <span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
        <div class="mailbox-attachment-info">
            <a href="{{getLink}}" class="mailbox-attachment-name"><i class="fas fa-paperclip"></i> {{fileName}}</a>
            <a href="{{fullName}}" class="btn btn-default btn-xs float-right delBtn"><i class="far fa-trash-alt"></i></a>
        </div>
    </li>
</script>
</body>
</html>

