<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<c:set var="path" scope="request" value="${pageContext.request.contextPath }"/>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${path}/resources/css/top.css" rel="stylesheet">
<style type="text/css">

</style>
</head>
<body>
<header>
<h1> 마주스토리 쇼핑몰관리 관리자 ver 1.0 </h1>
</header>
<nav>
&emsp;&emsp;&emsp;<a href=${path}/index.do>홈으로 </a>
&emsp;<a href=${path}/board/list.do>목록보기</a>
&emsp;<a href=${path}/map.do>카카오지도</a>

&emsp;<a href=${path}/json/json.do>Restful(JSON)</a>
&emsp;<a href=${path}/xml/xml.do>Restful(XML)</a>

&emsp;<a href=${path}/shop/shop.do>쇼핑몰</a>

&emsp;<a href=${path}/test/board.do>테스트 등록하기</a>
&emsp;<a href=${path}/test/list.do>테스트 목록보기</a>

<a href="${path}/customerMyPage/mypage.do"> 마이페이</a>

&emsp;&emsp;&emsp;

<!-- null 과 공배 모두 체크 -->
<c:if test="${empty id}">
	<a href="${path}/memberLogin/login.do"> 로그인</a>
</c:if>
<c:if test="${not empty id}">
	<a href="${path}/member/logout.do"> ${id}로그아웃</a>
</c:if>



</nav>