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

<!-- 
top.jsp에 들어가야할것들
로고(메인페이지로 이동), 세일, 추천, 아우터, 상의, 바지, 치마, 원피스, 검색, 마이페이지, 장바구니 / 관리자
아우터,상의,바지,치마,원피스 는 마우스 위로 올리면 하위 카테고리가 탑드롭 형식으로 쭈루룩
아우터: 자켓, 코트, 패딩/점퍼, 가디건, 베스트, 레더/무스탕
상의: 티셔츠, 셔츠/블라우스, 니트, 맨투맨/후드, 슬리브리스
바지: 데님, 슬랙스, 코튼팬츠, 조거/트레이닝, 쇼츠
치마: 미니스커트, 미디/롱스커트, H라인 스커트, 플리츠/A라인, 데님 스커트
원피스: 미니 원피스, 롱/맥시 원피스, 셔츠 원피스, 니트 원피스, 점프슈트

관리자: 상품등록, 관리자 상품리스트 관리, 매출통계
 -->

<nav>
&emsp;&emsp;&emsp;<a href=${path}/index.do>홈으로 </a>
&emsp;<a href=${path}/board/list.do>목록보기</a>
&emsp;<a href=${path}/map.do>카카오지도</a>

&emsp;<a href=${path}/json/json.do>Restful(JSON)</a>
&emsp;<a href=${path}/xml/xml.do>Restful(XML)</a>

&emsp;<a href=${path}/shop/shop.do>쇼핑몰</a>

&emsp;<a href=${path}/test/board.do>테스트 등록하기</a>
&emsp;<a href=${path}/test/list.do>테스트 목록보기</a>



&emsp;&emsp;&emsp;

<!-- null 과 공배 모두 체크 -->
<c:if test="${empty id}">
	<a href="${path}/member/login.do"> 로그인</a>
</c:if>
<c:if test="${not empty id}">
	<a href="${path}/member/logout.do"> ${id}로그아웃</a>
</c:if>



</nav>