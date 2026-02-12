<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
<c:set var="path" scope="request" value="${pageContext.request.contextPath }" />

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>의류 쇼핑몰</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
						<sec:authorize access="hasRole('ROLE_ADMIN')">
							<li class="has-submenu me-3"><a href="#">관리자</a>
								<ul class="submenu">
									<li><a href="${path}/product/productAddForm.do">상품등록</a></li>
									<li><a href="${path}/product/adminProductList.do">상품목록</a></li>
									<li><a href="${path}/admin/salesChart.do">매출통계</a></li>
									<li><a href="${path}/admin/userManagement.do">회원관리</a></li>
									<li><a href="${path}/admin/orderManagement.do">주문관리</a></li>
								</ul>
							</li>
						</sec:authorize>

					<li class="has-submenu"><a href="${path}/userproduct/userproductlist.do?category=아우터">아우터</a>
					    <ul class="submenu">
					        <li><a href="${path}/userproduct/userproductlist.do?category=아우터&subCategory=자켓">자켓</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=아우터&subCategory=코트">코트</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=아우터&subCategory=패딩/점퍼">패딩/점퍼</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=아우터&subCategory=가디건">가디건</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=아우터&subCategory=베스트">베스트</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=아우터&subCategory=레더/무스탕">레더/무스탕</a></li>
					    </ul>
					</li>
					
					<li class="has-submenu"><a href="${path}/userproduct/userproductlist.do?category=상의">상의</a>
					    <ul class="submenu">
					        <li><a href="${path}/userproduct/userproductlist.do?category=상의&subCategory=티셔츠">티셔츠</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=상의&subCategory=셔츠/블라우스">셔츠/블라우스</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=상의&subCategory=니트">니트</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=상의&subCategory=맨투맨/후드">맨투맨/후드</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=상의&subCategory=슬리브리스">슬리브리스</a></li>
					    </ul>
					</li>
					
					<li class="has-submenu"><a href="${path}/userproduct/userproductlist.do?category=바지">바지</a>
					    <ul class="submenu">
					        <li><a href="${path}/userproduct/userproductlist.do?category=바지&subCategory=데님">데님</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=바지&subCategory=슬랙스">슬랙스</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=바지&subCategory=코튼 팬츠">코튼 팬츠</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=바지&subCategory=조거/트레이닝">조거/트레이닝</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=바지&subCategory=쇼츠">쇼츠</a></li>
					    </ul>
					</li>
					
					<li class="has-submenu"><a href="${path}/userproduct/userproductlist.do?category=치마">치마</a>
					    <ul class="submenu">
					        <li><a href="${path}/userproduct/userproductlist.do?category=치마&subCategory=미니스커트">미니스커트</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=치마&subCategory=롱스커트">롱스커트</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=치마&subCategory=H라인 스커트">H라인 스커트</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=치마&subCategory=플리츠/A라인">플리츠/A라인</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=치마&subCategory=데님 스커트">데님 스커트</a></li>
					    </ul>
					</li>
					
					<li class="has-submenu"><a href="${path}/userproduct/userproductlist.do?category=원피스">원피스</a>
					    <ul class="submenu">
					        <li><a href="${path}/userproduct/userproductlist.do?category=원피스&subCategory=미니 원피스">미니 원피스</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=원피스&subCategory=롱 원피스">롱 원피스</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=원피스&subCategory=셔츠 원피스">셔츠 원피스</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=원피스&subCategory=니트 원피스">니트 원피스</a></li>
					        <li><a href="${path}/userproduct/userproductlist.do?category=원피스&subCategory=점프수트">점프수트</a></li>
					    </ul>
					</li>

				</ul>
			</nav>
			

			<div class="right-area d-flex align-items-center">
						<form class="search-form me-3" action="${path}/userproduct/search.do" method="get">
		    <input type="text" name="keyword" placeholder="검색어 입력">
						</form>


         <div class="user-menu">
                <%-- 로그아웃 상태일 때 --%>
                <sec:authorize access="isAnonymous()">
                    <a href="${path}/user/login.do" class="me-2">로그인</a>
                    <a href="${path}/user/member.do" class="me-2">회원가입</a>
                    <a href="${path}/user/login.do" class="me-2">마이페이지</a>
                    <a href="${path}/user/login.do">장바구니</a>
                </sec:authorize>

               <%-- 로그인 상태일 때 --%>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="principal" />
    <span class="me-3">
        <strong>
            <c:choose>
                <%-- 소셜 로그인인지 확인하는 안전한 방법: principal 클래스명 확인 --%>
                <c:when test="${fn:contains(principal, 'DefaultOAuth2User') or fn:contains(principal, 'OAuth2User')}">
                    <c:choose>
                        <%-- 네이버 --%>
                        <c:when test="${not empty principal.attributes.response}">
                            ${principal.attributes.response.name}
                        </c:when>
                        <%-- 카카오 --%>
                        <c:when test="${not empty principal.attributes.kakao_account}">
                            ${principal.attributes.kakao_account.profile.nickname}
                        </c:when>
                        <%-- 구글 --%>
                        <c:when test="${not empty principal.attributes.name}">
                            ${principal.attributes.name}
                        </c:when>
                        <c:otherwise>소셜회원</c:otherwise>
                    </c:choose>
                </c:when>

                <%-- 일반 로그인 유저 (attributes 속성이 없는 일반 User 객체) --%>
                <c:otherwise>
                    <%-- 일반 로그인은 principal.username 또는 직접 커스텀한 필드(userName) 사용 --%>
                    ${principal.username} 
                </c:otherwise>
            </c:choose>
        </strong>님 환영합니다.
    </span>

                    <a href="${path}/user/mypage.do" class="me-2">마이페이지</a>
                    <a href="${path}/cart" class="me-2">장바구니</a>

   <%-- 로그아웃 버튼을 단순 링크로 변경 (가장 추천) --%>
<a href="${path}/user/logout.do" class="me-2" style="color:blue; text-decoration:underline;">
    로그아웃
</a>
              
                </sec:authorize>
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