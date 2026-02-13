<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<link href="${path}/resources/css/user/mypage.css" rel="stylesheet">


<section class="mypage-wrapper">
    <div class="welcome-box">
        <h1>마이페이지</h1>
        <div class="user-name">
            <strong><span>${user.userName}</span></strong>님 환영합니다!
        </div>
    </div>

    <div class="menu-container">
        <a href="${path}/user/memberEdit.do" class="menu-item">
            <div class="circle-btn">👤</div>
            <div class="menu-text">정보 수정</div>
        </a>

        <a href="${path}/user/orderList.do" class="menu-item">
            <div class="circle-btn">📦</div>
            <div class="menu-text">주문 내역</div>
        </a>

        <a href="${path}/delivery/addressList.do" class="menu-item">
            <div class="circle-btn">📍</div>
            <div class="menu-text">주소 관리</div>
        </a>

        <a href="${path}/cart/cartlist.do" class="menu-item">
            <div class="circle-btn">🛒</div>
            <div class="menu-text">장바구니</div>
        </a>
    </div>
</section>

<br><br>

<script>
    // 필요한 스크립트가 있다면 여기에 작성하세요.
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />