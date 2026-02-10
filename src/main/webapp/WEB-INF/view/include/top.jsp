<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="path" scope="request" value="${pageContext.request.contextPath }"/>    
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<title>의류 쇼핑몰</title>
<link href="${path}/resources/css/top.css" rel="stylesheet">
</head>
<body>


        <!-- 중앙 메뉴 -->
        <nav class="main-nav">
            <ul class="menu">
                <li><a href="${path}/userproduct/userproductlist.do"> 리스트</a></li>
                
           
                <li class="has-submenu"><a href="#">관리자</a>
                	<ul class="submenu">
                		<li><a href="${path}/product/productAddForm.do">상품등록(관리자_동건)</a></li>
                		<li><a href="${path}/product/adminProductList.do">상품목록(관리자_동건) </a></li>
                		<li><a href="${path}/admin/salesChart.do">매출통계 </a></li>
                		<li><a href="${path}/admin/userManagement.do">회원관리(관리자_동건) </a></li>
                		<li><a href="${path}/admin/orderManagement.do">주문관리(관리자_동건) </a></li>
                	</ul>                
                <li class="has-submenu"><a href="#">아우터</a>
                    <ul class="submenu">
                        <li><a href="${path}/product/list.do">자켓</a></li>
                        <li><a href="${path}/product/list.do">코트</a></li>
                        <li><a href="${path}/product/list.do">패딩/점퍼</a></li>
                        <li><a href="${path}/product/list.do">가디건</a></li>
                        <li><a href="${path}/product/list.do">베스트</a></li>
                        <li><a href="${path}/product/list.do">레더/무스탕</a></li>
                    </ul>
                </li>
                <li class="has-submenu"><a href="#">상의</a>
                    <ul class="submenu">
                        <li><a href="${path}/product/list.do">티셔츠</a></li>
                        <li><a href="${path}/product/list.do">셔츠/블라우스</a></li>
                        <li><a href="${path}/product/list.do">니트</a></li>
                        <li><a href="${path}/product/list.do">맨투맨/후드</a></li>
                        <li><a href="${path}/product/list.do">슬리브리스</a></li>
                    </ul>
                </li>
                <li class="has-submenu"><a href="#">바지</a>
                    <ul class="submenu">
                        <li><a href="${path}/product/list.do">데님</a></li>
                        <li><a href="${path}/product/list.do">슬랙스</a></li>
                        <li><a href="${path}/product/list.do">코튼 팬츠</a></li>
                        <li><a href="${path}/product/list.do">조거/트레이닝</a></li>
                        <li><a href="${path}/product/list.do">쇼츠</a></li>
                    </ul>
                </li>
                <li class="has-submenu"><a href="#">치마</a>
                    <ul class="submenu">
                        <li><a href="${path}/product/list.do">미니스커트</a></li>
                        <li><a href="${path}/product/list.do">롱스커트</a></li>
                        <li><a href="${path}/product/list.do">H라인 스커트</a></li>
                        <li><a href="${path}/product/list.do">플리츠/A라인</a></li>
                        <li><a href="${path}/product/list.do">데님 스커트</a></li>
                    </ul>
                </li>
                <li class="has-submenu"><a href="#">원피스</a>
                    <ul class="submenu">
                        <li><a href="${path}/product/list.do">미니 원피스</a></li>
                        <li><a href="${path}/product/list.do">롱 원피스</a></li>
                        <li><a href="${path}/product/list.do">셔츠 원피스</a></li>
                        <li><a href="${path}/product/list.do">니트 원피스</a></li>
                        <li><a href="${path}/product/list.do">점프슈트</a></li>
                    </ul>
                </li>
            </ul>
        </nav>

        <!-- 우측 검색창 + 유저 메뉴 -->
<div class="right-area">
    <form class="search-form" action="${path}/search" method="post">
        <input type="text" name="keyword" placeholder="검색어 입력">
        <button type="submit">검색</button>
    </form>
    
    <div class="user-menu">
     <%-- 1. 로그아웃 상태일 때 (익명 사용자) --%>
        <sec:authorize access="isAnonymous()">
            <a href="${path}/user/login.do">로그인</a>
            <a href="${path}/user/member.do">회원가입</a>
            <%-- 로그인 안했을 때 마이페이지/장바구니는 로그인 페이지로 유도하는 것이 보통입니다 --%>
            <a href="${path}/user/login.do">마이페이지</a>
            <a href="${path}/user/login.do">장바구니</a>
        </sec:authorize>

        <%-- 2. 로그인 상태일 때 --%>
        <sec:authorize access="isAuthenticated()">
            <span style="margin-right: 15px;">
                <strong><sec:authentication property="principal.username"/></strong>님 
                <small style="color: gray;">(권한: <sec:authentication property="principal.authorities"/>)</small>
            </span>
            
            <a href="${path}/user/mypage.do">마이페이지</a>
            <a href="${path}/cart">장바구니</a>
            
            <%-- 로그아웃을 POST 방식으로 안전하게 처리하는 방법 --%>
            <form action="${path}/user/logout.do" method="post" style="display:inline; margin-left:10px;">
                <%-- CSRF가 활성화 되어있다면 아래 토큰이 반드시 필요합니다 (disable 하셨으면 생략 가능) --%>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" style="background:none; border:none; color:inherit; cursor:pointer; font:inherit; padding:0; text-decoration:underline;">
                    로그아웃
                </button>
            </form>
        </sec:authorize>


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