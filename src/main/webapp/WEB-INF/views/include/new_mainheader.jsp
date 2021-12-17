<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../include/head.jsp" %>
<nav>
<div class="container">
    <header class="d-flex flex-wrap align-items-center justify-content-between"> <!--mb-4  -->
    <a href="${path}/home" class="brand-link">
      <img src="${path}/dist/img/profile/kepllogo_home.png">
    </a>


     <ul class="nav col-12 col-md-auto mb-2 justify-content-center mb-md-0 listcategoryfont">
        <li><strong><a href="${path}/home" class="nav-link px-2">
        <img src="${path}/dist/img/icon/home.png"> &nbsp;홈</a></strong></li>
        <li><strong><a href="${path}/article/search/list" class="nav-link px-2">
        <img src="${path}/dist/img/icon/list.png"> &nbsp;종합</a></strong></li>
        <li><strong><a href="${path}/article/search/list/best" class="nav-link px-2">
        <img src="${path}/dist/img/icon/best.png"> &nbsp;베스트</a></strong></li>
        <li><strong><a href="${path}/article/search/list/movie" class="nav-link px-2">
        <img src="${path}/dist/img/icon/movie.png"> &nbsp;영화</a></strong></li>
        <li><strong><a href="${path}/article/search/list/drama" class="nav-link px-2">
        <img src="${path}/dist/img/icon/drama.png"> &nbsp;드라마</a></strong></li>
        <li><strong><a href="${path}/article/search/list/kpop" class="nav-link px-2">
        <img src="${path}/dist/img/icon/kpop.png">  &nbsp;K-POP</a></strong></li>
      </ul>
			     <ul class="navbar-nav listfont">
			                <c:if test="${not empty login}">
			                <li class="nav-item dropdown user user-menu">
			                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
			                        <img src="${path}/dist/img/profile/${login.userImg}" class="user-image" alt="User Image">
			                        <span class="hidden-xs">${login.userName}</span>
			                    </a>
			                    <ul class="dropdown-menu">
			                        <li class="user-header">
			                            <img src="${path}/dist/img/profile/${login.userImg}" class="img-circle" alt="User Image">
			                            <p>
			                                <small>
			                                    가입일자 : <fmt:formatDate value="${login.userJoinDate}" pattern="yyyy-MM-dd"/>
			                                </small>
			                                <small>
			                                    최근로그인일자 : <fmt:formatDate value="${login.userLoginDate}" pattern="yyyy-MM-dd"/>
			                                </small>
			                            </p>
			                        </li>
			                        <li class="user-footer">
			                            <div class="float-left">
			                                <a href="${path}/user/profile" class="btn btn-default btn-flat"><i
			                                        class="fa fa-info-circle"></i><b> 내 프로필</b></a>
			                            </div>
			                            <div class="float-right">
			                                <a href="${path}/user/logout" class="btn btn-default btn-flat"><i
			                                        class="glyphicon glyphicon-log-out"></i><b> 로그아웃</b></a>
			                            </div>
			                        </li>
			                    </ul>
			                </li>
			                </c:if>
			                <c:if test="${empty login}">
			                <li class="nav-item dropdown user user-menu">
			                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
			                        <img src="${path}/dist/img/profile/default-user.png" class="user-image" alt="User Image">
			                        <span class="hidden-xs">로그인</span>
			                    </a>
			                    <ul class="dropdown-menu">
			                        <li class="user-header">
			                            <img src="${path}/dist/img/profile/default-user.png" class="img-circle" alt="User Image">
			                            <p>
			                                <b>회원가입 또는 로그인해주세요</b>
			                                <small></small>
			                            </p>
			                        </li>
			                        <li class="user-footer">
			                            <div class="float-left">
			                                <a href="${path}/user/register" class="btn btn-default btn-flat"><i
			                                        class="fas fa-user-plus"></i><b> 회원가입</b></a>
			                            </div>
			                            <div class="float-right">
			                                <a href="${path}/user/login" class="btn btn-default btn-flat"><i
			                                        class="glyphicon glyphicon-log-in"></i><b> 로그인</b></a>
			                            </div>
			                        </li>
			                    </ul>
			                </li>
			                </c:if>
			            </ul>      
    </header>
    </div>
  </nav>