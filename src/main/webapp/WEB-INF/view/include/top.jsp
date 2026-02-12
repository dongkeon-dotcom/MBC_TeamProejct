<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="path" scope="request" value="${pageContext.request.contextPath }"/>    

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>의류 쇼핑몰</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${path}/resources/css/top.css" rel="stylesheet">
</head>

<body>
<header class="top-header">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        
        <nav>
            <ul class="main-menu d-flex list-unstyled m-0">
                <sec:authorize access="hasRole('ROLE_ADMIN')">
                    <li class="has-submenu me-3"><a href="#">관리자</a>
                        <ul class="submenu">
                            <li><a href="${path}/admin/productAddForm.do">상품등록</a></li>
                            <li><a href="${path}/admin/adminProductList.do">상품목록</a></li>
                            <li><a href="${path}/admin/salesChart.do">매출통계</a></li>
                            <li><a href="${path}/admin/userManagement.do">회원관리</a></li>
                            <li><a href="${path}/admin/orderManagement.do">주문관리</a></li>
                        </ul>  
                    </li>
                </sec:authorize>

                <li class="has-submenu me-3"><a href="${path}/product/list.do?category=outer">아우터</a>
                    <ul class="submenu">
                        <li><a href="${path}/product/list.do?category=jacket">자켓</a></li>
                        <li><a href="${path}/product/list.do?category=coat">코트</a></li>
                        <li><a href="${path}/product/list.do?category=padding">패딩/점퍼</a></li>
                    </ul>
                </li>
                
                <li class="has-submenu me-3"><a href="${path}/product/list.do?category=top">상의</a>
                    <ul class="submenu">
                        <li><a href="${path}/product/list.do?category=tshirt">티셔츠</a></li>
                        <li><a href="${path}/product/list.do?category=knit">니트</a></li>
                    </ul>
                </li>

                <li class="has-submenu me-3"><a href="${path}/product/list.do?category=pants">바지</a>
                    <ul class="submenu">
                        <li><a href="${path}/product/list.do?category=denim">데님</a></li>
                        <li><a href="${path}/product/list.do?category=slacks">슬랙스</a></li>
                    </ul>
                </li>
                </ul>
        </nav>

        <div class="right-area d-flex align-items-center">
            <form class="search-form me-3" action="${path}/search" method="post">
                <input type="text" name="keyword" placeholder="검색어 입력">
                <button type="submit" class="btn btn-sm btn-outline-dark">검색</button>
            </form>

         <div class="user-menu">
                <%-- 로그아웃 상태일 때 --%>
                <sec:authorize access="isAnonymous()">
                    <a href="${path}/user/login.do" class="me-2">로그인</a>
                    <a href="${path}/user/member.do" class="me-2">회원가입</a>
                    <a href="${path}/user/login.do" class="me-2">마이페이지</a>
                    <a href="${path}/user/login.do">장바구니</a>
                </sec:authorize>

    <sec:authorize access="isAuthenticated()">
    <%-- 1. 현재 로그인된 객체 정보를 auth 객체에 담습니다. --%>
    <sec:authentication property="principal" var="auth" />

    <span class="me-3">
        <strong>
            <c:choose>
                <%-- 2. 소셜 로그인 여부 확인 (attributes가 있으면 소셜) --%>
                <c:when test="${not empty auth.attributes}">
                    <c:choose>
                        <%-- 네이버 --%>
                        <c:when test="${not empty auth.attributes.response}">
                            ${auth.attributes.response.name}
                        </c:when>
                        <%-- 카카오 --%>
                        <c:when test="${not empty auth.attributes.kakao_account}">
                            ${auth.attributes.kakao_account.profile.nickname}
                        </c:when>
                        <%-- 구글 --%>
                        <c:when test="${not empty auth.attributes.name}">
                            ${auth.attributes.name}
                        </c:when>
                        <c:otherwise>소셜회원</c:otherwise>
                    </c:choose>
                </c:when>

                <%-- 3. 일반 로그인 유저 (attributes가 없는 경우) --%>
                <c:otherwise>
                    <%-- 중요: principal.username 같은 하위 필드를 직접 적지 않습니다. --%>
                    <%-- 아래 태그는 시큐리티가 알아서 '아이디' 혹은 '대표이름'을 출력합니다. --%>
                    <sec:authentication property="name" />
                </c:otherwise>
            </c:choose>
        </strong>님 환영합니다.
    </span>
 <a href="${path}/user/login.do" class="me-2">마이페이지</a>
                    <a href="${path}/user/login.do">장바구니</a>
    <%-- 로그아웃 링크 --%>
    <a href="${path}/user/logout.do" style="color:blue; text-decoration:underline; cursor:pointer;">
        로그아웃
    </a>
</sec:authorize>
            </div>
        </div>
    </div>
</header>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // 헤더 높이만큼 바디 패딩 자동 조절
        const header = document.querySelector(".top-header");
        if (header) {
            const updatePadding = () => {
                document.body.style.paddingTop = header.offsetHeight + "px";
            };
            updatePadding();
            window.addEventListener("resize", updatePadding);
        }
    });
</script>