<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<html>
<head>
<title>상품 리스트</title>
<link rel="stylesheet" href="${path}/resources/css/userproduct/userproductlist.css">
</head>
<body>

	
	
<br>
<div class="category-filter" align="center">
    <a href="${path}/userproductlist.do">전체</a> |
    <a href="${path}/userproductlist.do?category=아우터">아우터</a> |
    <a href="${path}/userproductlist.do?category=상의">상의</a> |
    <a href="${path}/userproductlist.do?category=바지">바지</a> |
    <a href="${path}/userproductlist.do?category=치마">치마</a> |
    <a href="${path}/userproductlist.do?category=원피스">원피스</a>
</div>
<br>



	<div class="product-grid">
		<c:forEach var="p" items="${li}">
			<div class="product-card">
				<!-- 이미지 클릭 시 상세페이지 이동 -->
				<a href="${path}/userproduct/userproductdetail.do?productIdx=${p.productIdx}">
					<c:choose>
						<c:when test="${not empty p.productMainImg}">
							<img src="${path}/resources/images/${p.productMainImg}"
								alt="${p.productName}">
						</c:when>
						<c:otherwise>
							<div class="no-image">이미지 준비중</div>
						</c:otherwise>
					</c:choose>
				</a>

				<!-- 상품 정보 -->
				<div class="product-info">
					<p class="product-name">${p.productName}</p>
					<p class="product-price">${p.price}원</p>
					<c:if test="${not empty p.discountRate}">
						<p class="product-discount">${p.discountRate}%할인</p>
					</c:if>
					<div class="product-rating">
						<c:forEach begin="1" end="5" var="i">
							<c:choose>
								<c:when test="${i <= p.avgRating}">★</c:when>
								<c:otherwise>☆</c:otherwise>
							</c:choose>
						</c:forEach>
						<span>(${p.reviewCount} 리뷰)</span>
					</div>
				</div>
				
			</div>
		</c:forEach>
	</div>

</body>
</html>

<c:import url="/WEB-INF/view/include/bottom.jsp" />
