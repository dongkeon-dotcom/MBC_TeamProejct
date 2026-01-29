<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<link href="${path}/resources/member/mypage.css" rel="stylesheet">

   
<br>
<section class="mypage-section">
    <h1>마이페이지</h1>
    <ul class="mypage-menu">
        <li><a href="${path}/member/edit.do">회원정보 수정</a></li>
        <li><a href="${path}/member/addresses.do">배송지 관리</a></li>
        <li><a href="${path}/order/list.do">주문 내역 조회</a></li>
        <li><a href="${path}/cart/list.do">장바구니 바로가기</a></li>
        <li><a href="${path}/review/myReview.do">내 리뷰 관리</a></li>
    </ul>








<br>
<script >

    
</script>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />