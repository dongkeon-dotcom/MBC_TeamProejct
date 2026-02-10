<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="path" scope="request"
	value="${pageContext.request.contextPath }" />
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<title>의류 쇼핑몰</title>
<link href="${path}/resources/css/top.css" rel="stylesheet">
</head>
<body>


	<!-- ===== 상단바 ===== -->
	<header class="top-header">
		<div class="container">
			<!-- 좌측 로고 -->
			<div class="logo">
				<h1>
					<a href="${path}/index.do">로고</a>
				</h1>
			</div>

			<!-- 중앙 메뉴 -->
			<nav class="main-nav">
				<ul class="menu">
					<li><a href="${path}/product/productAddForm.do">상품등록(관리자_동건)</a></li>
					<li><a href="${path}/product/adminProductList.do">상품목록(관리자_동건)
					</a></li>
					<li><a href="${path}/admin/salesChart.do">매출통계 </a></li>
					<li><a href="${path}/admin/userManagement.do">회원관리(관리자_동건)
					</a></li>
					<li><a href="${path}/admin/orderManagement.do">주문관리(관리자_동건)
					</a></li>


					<li class="has-submenu"><a href="${path}/product/list.do?category=outer">아우터</a>
					    <ul class="submenu">
					        <li><a href="${path}/product/list.do?category=jacket">자켓</a></li>
					        <li><a href="${path}/product/list.do?category=coat">코트</a></li>
					        <li><a href="${path}/product/list.do?category=padding">패딩/점퍼</a></li>
					        <li><a href="${path}/product/list.do?category=cardigan">가디건</a></li>
					        <li><a href="${path}/product/list.do?category=vest">베스트</a></li>
					        <li><a href="${path}/product/list.do?category=leather">레더/무스탕</a></li>
					    </ul>
					</li>
					
					<li class="has-submenu"><a href="${path}/product/list.do?category=top">상의</a>
					    <ul class="submenu">
					        <li><a href="${path}/product/list.do?category=tshirt">티셔츠</a></li>
					        <li><a href="${path}/product/list.do?category=blouse">셔츠/블라우스</a></li>
					        <li><a href="${path}/product/list.do?category=knit">니트</a></li>
					        <li><a href="${path}/product/list.do?category=hood">맨투맨/후드</a></li>
					        <li><a href="${path}/product/list.do?category=sleeveless">슬리브리스</a></li>
					    </ul>
					</li>
					
					<li class="has-submenu"><a href="${path}/product/list.do?category=pants">바지</a>
					    <ul class="submenu">
					        <li><a href="${path}/product/list.do?category=denim">데님</a></li>
					        <li><a href="${path}/product/list.do?category=slacks">슬랙스</a></li>
					        <li><a href="${path}/product/list.do?category=cotton">코튼 팬츠</a></li>
					        <li><a href="${path}/product/list.do?category=jogger">조거/트레이닝</a></li>
					        <li><a href="${path}/product/list.do?category=shorts">쇼츠</a></li>
					    </ul>
					</li>
					
					<li class="has-submenu"><a href="${path}/product/list.do?category=skirt">치마</a>
					    <ul class="submenu">
					        <li><a href="${path}/product/list.do?category=mini">미니스커트</a></li>
					        <li><a href="${path}/product/list.do?category=long">롱스커트</a></li>
					        <li><a href="${path}/product/list.do?category=hline">H라인 스커트</a></li>
					        <li><a href="${path}/product/list.do?category=pleats">플리츠/A라인</a></li>
					        <li><a href="${path}/product/list.do?category=denimskirt">데님 스커트</a></li>
					    </ul>
					</li>
					
					<li class="has-submenu"><a href="${path}/product/list.do?category=dress">원피스</a>
					    <ul class="submenu">
					        <li><a href="${path}/product/list.do?category=minidress">미니 원피스</a></li>
					        <li><a href="${path}/product/list.do?category=longdress">롱 원피스</a></li>
					        <li><a href="${path}/product/list.do?category=shirtdress">셔츠 원피스</a></li>
					        <li><a href="${path}/product/list.do?category=knitdress">니트 원피스</a></li>
					        <li><a href="${path}/product/list.do?category=jumpsuit">점프슈트</a></li>
					    </ul>
					</li>

				</ul>
			</nav>

			<!-- 우측 검색창 + 유저 메뉴 -->
			<div class="right-area">
				<form class="search-form" action="${path}/search" method="post">
					<input type="text" name="keyword" placeholder="검색어 입력">
				</form>



				<div class="user-menu">
					<c:choose>
						<%-- 1. 로그아웃 상태일 때 --%>
						<c:when test="${empty sessionScope.loginMember}">
							<a href="${path}/user/login.do">로그인</a>
							<a href="${path}/user/member.do">회원가입</a>
							<a href="${path}/user/mypage.do">마이페이지</a>
							<a href="${path}/cart">장바구니</a>
						</c:when>

						<%-- 2. 로그인 상태일 때 --%>
						<c:otherwise>
							<span> <strong>${sessionScope.loginMember.userName}</strong>님
								(권한: ${sessionScope.loginMember.userRole}) <%--116line 추후 삭제필요  테스트확인을 위한 role확인--%>
							</span>
							<a href="${path}/user/mypage.do">마이페이지</a>
							<a href="${path}/cart">장바구니</a>
							<a href="${path}/user/logout.do" style="margin-left: 10px;">로그아웃</a>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</header>





	<script>
	document.addEventListener("DOMContentLoaded", function() {

		});

    document.addEventListener("DOMContentLoaded", function() {
      const header = document.querySelector(".top-header");
      if (header) {
        const headerHeight = header.offsetHeight; // 상단바 실제 높이 계산
        document.body.style.paddingTop = headerHeight + "px"; // body에 적용
      }
    });
    
    </script>