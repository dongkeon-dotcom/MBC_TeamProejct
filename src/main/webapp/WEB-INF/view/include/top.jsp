<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<c:set var="path" scope="request" value="${pageContext.request.contextPath }"/>    

<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
<!-- 우선영 매뉴 관리테스트중!!!  -->
<a href="${path}/customerMyPage/mypage.do"> 마이페이</a>
	<a href="${path}/memberLogin/login.do"> 로그인</a>
<!-- /우선영 매뉴 관리테스트중!!!  -->
&emsp;&emsp;&emsp;

<!-- null 과 공배 모두 체크 -->
<c:if test="${empty id}">
	<a href="${path}/memberLogin/login.do"> 로그인</a>
</c:if>
<c:if test="${not empty id}">
	<a href="${path}/member/logout.do"> ${id}로그아웃</a>
</c:if>



</nav>
=======
>>>>>>> 1a229ecbc0482a73e203950239b320e66b37877a
>>>>>>> 5d163e62497f8b095fa357a87cf0043faae199ed
<title>의류 쇼핑몰</title>
<link href="${path}/resources/css/top.css" rel="stylesheet">
</head>
<body>

    <!-- ===== 상단바 ===== -->
    <header class="top-header">
        <!-- 좌측 로고 -->
        <div class="logo">
            <h1><a href="${path}/index.do">로고자리</a></h1>
        </div>

        <!-- 중앙 메뉴 -->
        <nav class="main-nav">
            <ul class="menu">
                <li><a href="${path}/userproduct/userproductlist.do">상품상세보기(고객용)</a></li>
                <li><a href="${path}/userproduct/userproductdetail.do">상품리스트(고객용)</a></li>
           
                
                <li><a href="${path}/product/form.do">상품등록(관리자)</a></li>
                <li><a href="${path}/product/list.do">상품목폭(관리자) </a></li>
                <li><a href="${path}/product/productAddForm.do">상품등록등록(관리자) </a></li>
                
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
            <form class="search-form" action="/search" method="post">
                <input type="text" name="keyword" placeholder="검색어 입력">
                <button type="submit">검색</button>
            </form>
            <div class="user-menu">
                <c:if test="${empty sessionScope.username}">
                    <a href="${path}/member/login.do">로그인</a>
                </c:if>
                <c:if test="${not empty sessionScope.username}">
                    <a href="${path}/logout.do">${sessionScope.name}(ROLE:${sessionScope.role}) 로그아웃</a>
                </c:if>
                <a href="${path}/member/mypage.do">마이페이지</a>
                <a href="/cart">장바구니</a>
            </div>
        </div>
    </header>

    

 

    <script>
    document.addEventListener("DOMContentLoaded", function() {
      const menuItems = document.querySelectorAll(".has-submenu > a");
      menuItems.forEach(item => {
        item.addEventListener("click", function(e) {
          e.preventDefault();
          const submenu = this.nextElementSibling;
          document.querySelectorAll(".submenu").forEach(sm => {
            if (sm !== submenu) sm.classList.remove("show");
          });
          submenu.classList.toggle("show");
        });
      });
    });
    </script>
</body>
</html>


<c:import url="/WEB-INF/view/include/bottom.jsp" />
