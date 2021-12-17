<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>
<%@ page import="java.util.Date" %>
<%@ include file = "../include/head.jsp" %>
<body class="hold-transition sidebar-mini">
<div class="wrapper">

  <!-- Navbar -->
  <%@ include file = "../include/new_mainheader.jsp" %>
  <!-- /.navbar -->

  <!-- Main Sidebar Container -->


  <!-- Content Wrapper. Contains page content -->
  <div class="container content">
    <!-- Content Header (Page header) -->
	    <div class="content-header">
	      <div class="container-fluid">
	        <div class="row mb-2">
	          <div class="col-sm-6">
	            <h1 class="m-0 text-dark">내 정보</h1>
	          </div><!-- /.col -->
	  
	        </div><!-- /.row -->
	      </div><!-- /.container-fluid -->
	    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
    	<div class="container-fluid">
					<div class="row">
						<div class="col-md-5">
							<div class="card card-primary card-outline">
								<div class="card-body box-profile">
									<div class="text-center">
										<img class="profile-user-img img-fluid img-circle"
											src="${path}/dist/img/profile/${login.userImg}"
											alt="User profile picture">
									</div>
									
									<h3 class="profile-username text-center">${login.userName}</h3>
									
									<div class="text-center">
										<a href="#" class="btn btn-primary btn-xs" data-toggle="modal"
											data-target="#userPhotoModal"> <i class="fa fa-photo">
												프로필사진 수정</i>
										</a>
									</div>
									<ul class="list-group list-group-unbordered mb-5">
										<li class="list-group-item"><b>아이디</b> <a
											class="float-right">${login.userId}</a></li>
										<li class="list-group-item"><b>이메일</b> <a
											class="float-right">${login.userEmail}</a></li>
										<li class="list-group-item"><b>가입일자</b> <a
											class="float-right"> <fmt:formatDate
													value="${login.userJoinDate}" pattern="yyyy-MM-dd" />
										</a></li>
										<li class="list-group-item"><b>최근 로그인 일자</b> <a
											class="float-right"> <fmt:formatDate
													value="${login.userLoginDate}" pattern="yyyy-MM-dd" />

										</a></li>
									</ul>
								</div>
								<div class="card-footer text-center">
									<a href="#" class="btn btn-primary btn-xs" data-toggle="modal"
										data-target="#userInfoModal"> <i class="fa fa-info-circle">
											회원정보 수정</i>
									</a> <a href="#" class="btn btn-primary btn-xs" data-toggle="modal"
										data-target="#userPwModal"> <i
										class="fa fa-question-circle"> 비밀번호 수정</i>
									</a> <a href="#" class="btn btn-primary btn-xs" data-toggle="modal"
										data-target="#userOutModal"> <i class="fa fa-user-times">
											회원 탈퇴</i>
									</a>
								</div>
							</div>
						</div>

						<div class="col-md-7">
							<div class="card">
								<div class="nav-tabs-custom">
									<div class="card-header p-2">
										<ul class="nav nav-pills">
											<li class="nav-item">
												<a class="nav-link active" href="#myPosts" data-toggle="tab">
													<i class="fas fa-pencil-square-o"></i> 나의 게시물
												</a>
											</li>
											<li class="nav-item">
												<a class="nav-link" href="#myReplies" data-toggle="tab">
													<i class="fas fa-comment-o"></i> 나의 댓글
												</a>
											</li>										
										</ul>
									</div>
									<div class="card-body">
										<div class="tab-content">
											<div class="active tab-pane" id="myPosts">
												<table id="myPostsTable"
													class="table table-bordered table-striped">
													<thead>
														<tr>
															<th style="width: 10%">번호</th>
															<th style="width: 70%">제목</th>
															<th style="width: 20%">작성일자</th>
														</tr>
													</thead>
													<tbody>
														<c:forEach var="articleVO" varStatus="i"
															items="${userBoardList}">
															<tr>
																<td>${i.index + 1}</td>
																<td><a
																	href="${path}/article/search/read?article_no=${articleVO.article_no}">
																		<c:choose>
																			<c:when test="${fn:length(articleVO.title) > 30}">
																				<c:out value="${fn:substring(articleVO.title, 0, 29)}" />....
		                                                    </c:when>
																			<c:otherwise>
																				<c:out value="${articleVO.title}" />
																			</c:otherwise>
																		</c:choose>
																</a></td>
																<td><fmt:formatDate pattern="yyyy-MM-dd"
																		value="${articleVO.regDate}" /></td>
															</tr>
														</c:forEach>
													</tbody>
												</table>
											</div>
											<div class="tab-pane" id="myReplies">
												<table id="myRepliesTable"
													class="table table-bordered table-striped">
													<thead>
														<tr>
															<th style="width: 25%">번호</th>
															<th style="width: 25%">게시글 제목</th>
															<th style="width: 25%">내용</th>
															<th style="width: 25%">작성일자</th>
														</tr>
													</thead>
													<tbody>
														<c:forEach var="userReply" varStatus="i"
															items="${userReplies}">
															<tr>
																<td>${i.index + 1}</td>
																<td><a
																	href="${path}/article/search/read?article_no=${userReply.articleVO.article_no}">
																		<c:choose>
																			<c:when
																				test="${fn:length(userReply.articleVO.title) > 10}">
																				<c:out
																					value="${fn:substring(userReply.articleVO.title, 0, 9)}" />....
		                                                        </c:when>
																			<c:otherwise>
																				<c:out value="${userReply.articleVO.title}" />
																			</c:otherwise>
																		</c:choose>
																</a></td>
																<td><c:choose>
																		<c:when test="${fn:length(userReply.reply_text) > 10}">
																			<c:out
																				value="${fn:substring(userReply.reply_text, 0, 9)}" />....
		                                                    </c:when>
																		<c:otherwise>
																			<c:out value="${userReply.reply_text}" />
																		</c:otherwise>
																	</c:choose></td>
																<td><fmt:formatDate pattern="yyyy-MM-dd"
																		value="${userReply.reg_date}" /></td>
															</tr>
														</c:forEach>
													</tbody>
												</table>
											</div>
										</div>
									</div>
									
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
  <%@ include file = "../include/main_footer.jsp" %>
  <div class="modal fade" id="userPhotoModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">프로필 사진을 수정하시겠습니까?</h4>
                    </div>
                    <div class="modal-body" align="center">
                        <form action="${path}/user/modify/image" id="userImageForm" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="userId" value="${login.userId}">
                            <div class="fileinput fileinput-new" data-provides="fileinput">
                                
                                <div class="fileinput-preview fileinput-exists thumbnail" style="max-width: 300%; max-height: 300%;"></div>
                                <div>
                                <span class="btn btn-default btn-file">
                                    <span class="fileinput-new">이미지 선택</span>
                                    <span class="fileinput-exists">변경</span>
                                    <input type="file" name="file" id="file">
                                </span>
                                    <a href="#" class="btn btn-default fileinput-exists" data-dismiss="fileinput">삭제</a>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                        <button type="button" class="btn btn-primary imgModBtn">수정 저장</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="userInfoModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">회원정보를 수정하시겠습니까?</h4>
                    </div>
                    <div class="modal-body" data-rno>
                        <form action="${path}/user/modify/info" id="userInfoForm" method="post">
                            <div class="form-group has-feedback">
                                <label for="userId">아이디</label>
                                <input type="text" name="userId" id="userId" class="form-control" placeholder="아아디" value="${login.userId}" readonly>
                                <span class="glyphicon glyphicon-exclamation-sign form-control-feedback"></span>
                            </div>
                            <div class="form-group has-feedback">
                                <label for="userName">이름</label>
                                <input type="text" name="userName" id="userName" class="form-control" placeholder="이름" value="${login.userName}">
                                <span class="glyphicon glyphicon-user form-control-feedback"></span>
                            </div>
                            <div class="form-group has-feedback">
                                <label for="userEmail">이메일</label>
                                <input type="email" name="userEmail" id="userEmail" class="form-control" placeholder="이메일" value="${login.userEmail}">
                                <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
                            </div>
                            <div class="form-group has-feedback">
                                <label for="userPw">비밀번호</label>
                                <input type="password" name="userPw" id="userPw" class="form-control" placeholder="비밀번호">
                                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                        <button type="button" class="btn btn-primary infoModBtn">수정 저장</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="userPwModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">비밀번호를 수정하시겠습니까?</h4>
                    </div>
                    <div class="modal-body" data-rno>
                        <form action="${path}/user/modify/pw" id="userPwForm" method="post">
                            <div class="form-group has-feedback">
                                <label for="oldPw">현재 비밀번호</label>
                                <input type="hidden" name="userId" value="${login.userId}">
                                <input type="password" name="oldPw" id="oldPw" class="form-control" placeholder="비밀번호">
                                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                            </div>
                            <div class="form-group has-feedback">
                                <label for="newPw">새로운 비밀번호</label>
                                <input type="password" name="newPw" id="newPw" class="form-control" placeholder="비밀번호">
                                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                            </div>
                            <div class="form-group has-feedback">
                                <label for="userPw">새로운 비밀번호 확인</label>
                                <input type="password" id="newPwCheck" class="form-control" placeholder="비밀번호확인">
                                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                        <button type="button" class="btn btn-primary pwModBtn">수정 저장</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="userOutModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">회원을 탈퇴하시겠습니까?</h4>
                    </div>
                    <div class="modal-body" data-rno>
                        모든정보를 삭제합니다.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">아니요.</button>
                        <button type="button" class="btn btn-primary myInfoModModalBtn">예 탈퇴하겠습니다.</button>
                    </div>
                </div>
            </div>
        </div>
</div>
<!-- ./wrapper -->

<!-- REQUIRED SCRIPTS -->
 <%@ include file = "../include/plugin_js.jsp" %>
<script src="${path}/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="${path}/plugins/bs-custom-file-input/jasny-bootstrap.min.js"></script>
<script src="${path}/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
<script>
    $(document).ready(function () {
    	
        var msg = "${msg}";
        if (msg == "FAILURE") {
            alert("비밀번호가 일치하지 않습니다. 비밀번호를 확인해주세요");
        } else if (msg == "FAIL") {
            alert("이미지가 존재하지 않습니다.");
        } else if (msg == "SUCCESS") {
            alert("수정되었습니다.");
        }
        // 회원정보 수정
        $(".infoModBtn").on("click", function () {
            $("#userInfoForm").submit();
        });
        // 회원비밀번호 수정
        $(".pwModBtn").on("click", function () {
            $("#userPwForm").submit();
        });
        // 회원 프로필 이미지 수정
        $(".imgModBtn").on("click", function () {
            var file = $("#file").val();
            if (file == "") {
                alert("파일을 선택해주세요.");
                return;
            }
            $("#userImageForm").submit();
        });
        var param = {
            "language": {
                "lengthMenu": "_MENU_ 개씩 보기",
                "zeroRecords": "내용이 없습니다.",
                "info": "현재 _PAGE_ 페이지 / 전체 _PAGES_ 페이지",
                "infoEmpty": "내용이 없습니다.",
                "infoFiltered": "( _MAX_개의 전체 목록 중에서 검색된 결과)",
                "search": "검색:",
                "paging": {
                    "first": "처음",
                    "last": "마지막",
                    "next": "다음",
                    "previous": "이전"
                }
            }
        };
       
        $("#myPostsTable").DataTable(param);
        $("#myRepliesTable").DataTable(param);
    });
</script>
</body>
</html>
