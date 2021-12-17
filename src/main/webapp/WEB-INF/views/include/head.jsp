<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="x-ua-compatible" content="ie=edge">

  <title>KEPL</title>

<Style>
  	.homethum	{
		  width: 300px;
		  height: 250px;
		  
		  object-fit: cover;
 	 }
 	 
 	 .listthum	{
		  width: 150px;
		  height: 150px;
		  
		  object-fit: cover;
 	 }
 	 .categoryfont	{
 		font-size: 60px;
 	 	font-weight: 600;
 	 }
 	 
 	 .titlefont	{
 	 	font-size: 24px;
 	 	font-weight: 600;

 	 }
 	 
 	 .listfont	{
 	 	font-size: 19px;
 	 	font-weight: 600;

 	 }
 	 .listcategoryfont	{
 	 	font-size: 26px;
 	 	font-weight: 600;

 	 }
 	 
 	 td	{
 	 	font-size: 19px;
 	 	font-weight: 600;

 	 }
 	 
 	 .readtitlefont	{
 	 	font-size: 24px;
 	 }
 </Style>

  <!-- Font Awesome Icons -->
  <link rel="stylesheet" href="${path}/plugins/fontawesome-free/css/all.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="${path}/dist/css/adminlte.min.css">
  <!-- Google Font: Source Sans Pro -->
  <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
  <%--lightbox--%>
   <link rel="stylesheet" href="${path}/plugins/ekko-lightbox/ekko-lightbox.css">
   <%-- <link rel="stylesheet" href="${path}/resources/dist/css/e-commerce.css"> --%>
</head>