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
<script type="text/javascript">
	$(document).ready(function(){
		var i=0;
		
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
							action="${path}/article/search/write">
							<div class="card">
								<div class="card-body">
									<div class="form-group">
										<label for="title">제목</label> <input class="form-control"
											id="title" name="title" placeholder="제목을 입력해주세요">
									</div>
									<div class="form-group">
										<label for="title">카테고리</label>
										<select class="form-control" aria-label="Default select example" name="category" id="choose">
												<option value="">카테고리를 선택해 주세요</option>
												<option value="movie">영화</option>
												<option value="drama">드라마</option>
												<option value="k-pop">K-POP</option>
										</select>
									</div>
									<div class="form-group">
										<label for="title">해쉬태그(#) <button type="button" class="btn btn-outline-warning btn-sm">초기화</button></label> 
										<div class="input-group">
											<input class="form-control input-sm col-md-2" type="text" id="hashtag" placeholder="해쉬태그 항목을 입력해주세요">
											<button class="btn btn-primary col-md-1" type="button" id="btn_hash">추가</button>
											<div class="col-md-6" id="hashtagValue">
												
												<input type="hidden" id="tagValue" name="hashtags" value="">
											</div>
										</div>
									</div>
									<div class="form-group">
										<label for="content">내용</label>
										<textarea class="form-control" id="content" name="content"
											rows="30" placeholder="내용을 입력해주세요" style="resize: none;"></textarea>
									</div>
									
									<div class="form-group">
										<label for="writer">작성자</label> <input class="form-control"
											id="writer" name="writer" value="${login.userId}" readonly>
									</div>
									<%--첨부파일 영역 추가--%>
									<div class="form-group">
		                                <div class="fileDrop">
		                                    <br/>
		                                    <br/>
		                                    <br/>
		                                    <br/>
		                                    <p class="text-center"><i class="fa fa-paperclip"></i> 첨부파일을 드래그해주세요.</p>
		                                </div>
	                            	</div>
	                            	
									<%--첨부파일 영역 추가--%>
									<div class="box-footer">
		                            	<ul class="mailbox-attachments clearfix uploadedList"></ul>
		                        	</div>
		                        	<div class="form-group">
										<label for="content"><a href="https://map.naver.com/" target="_blank">위치 </a></label>
										<div class="input-group">
											<input class="form-control input-sm col-md-10" type="text" name="addr" id="addr" size="30" placeholder="주소를 입력해주세요">
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
									<button type="button" class="btn btn-primary">
										<i class="fa fa-list"></i> 목록
									</button>
									<div class="float-right">
										<button type="reset" class="btn btn-warning">
											<i class="fa fa-reply"></i> 초기화
										</button>
										<button type="submit" class="btn btn-success">
											<i class="fa fa-save"></i> 저장
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
 
<script type="text/javascript" src="${path}../../resources/dist/js/upload.js"></script>
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
<script>
    /*====================================================게시판 첨부파일 업로드 관련======================================*/
    $(document).ready(function () {
        var fileDropDiv = $(".fileDrop");
        var templatePhotoAttach = Handlebars.compile($("#templatePhotoAttach").html());
        var templateFileAttach = Handlebars.compile($("#templateFileAttach").html());
        // 전체 페이지 파일 끌어 놓기 기본 이벤트 방지 : 지정된 영역외에 파일 드래그 드랍시 페이지 이동방지
        $(".content-wrapper").on("dragenter dragover drop", function (event) {
            event.preventDefault();
        });
        // 파일 끌어 놓기 기본 이벤트 방지
        fileDropDiv.on("dragenter dragover", function (event) {
            event.preventDefault();
        });
        // 파일 드랍 이벤트 : 파일 전송 처리, 파일 화면 출력
        fileDropDiv.on("drop", function (event) {
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
                    if (data.substr(12, 2) == "s_") {
                    	console.log("This is Image");
                        var html = templatePhotoAttach(fileInfo);
                    // 이미지 파일이 아닐 경우
                    } else {
                        html = templateFileAttach(fileInfo);
                    }
                    $(".uploadedList").append(html);
                }
            });
        });
        // 글 저장 버튼 클릭 이벤트 : 파일명 DB 저장 처리
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
        // 파일 삭제 버튼 클릭 이벤트 : 파일삭제, 파일명 DB 삭제 처리
        $(document).on("click", ".delBtn", function (event) {
            event.preventDefault();
            var that = $(this);
            $.ajax({
                url: "/file/delete",
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
        });
    });
</script>

<script>
$(document).ready(function() {
	
	var arr = new Array();
	
	$("#btn_hash").on("click", function () {
	    	
	   var test = $('#hashtag').val();
	    
	   if(arr.includes(test) == false){
		   arr.push(test);
		   
		   var html = '<span class="badge rounded-pill bg-light tags"> #';
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
		$("#tagValue").val(arr);
		
	});
	
});
</script>

</body>
</html>
