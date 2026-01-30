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

	<!-- 카테고리 필터 -->
	<div class="category-filter">
		<form action="${path}/userproductlist.do" method="get">
			<select name="category" onchange="this.form.submit()">
				<option value="">전체</option>
				<option value="아우터"
					<c:if test="${selectedCategory eq '아우터'}">selected</c:if>>아우터</option>
				<option value="상의"
					<c:if test="${selectedCategory eq '상의'}">selected</c:if>>상의</option>
				<option value="바지"
					<c:if test="${selectedCategory eq '바지'}">selected</c:if>>바지</option>
				<option value="치마"
					<c:if test="${selectedCategory eq '치마'}">selected</c:if>>치마</option>
				<option value="원피스"
					<c:if test="${selectedCategory eq '원피스'}">selected</c:if>>원피스</option>
			</select>
		</form>
	</div>



	<div class="product-grid">
		<c:forEach var="p" items="${li}">
			<div class="product-card">
				<!-- 이미지 클릭 시 상세페이지 이동 -->
				<a href="${path}/userproductdetail.do?productIdx=${p.productIdx}">
					<c:choose>
						<c:when test="${not empty p.pMainImgPath}">
							<img src="${path}/resources/images/${p.pMainImgPath}"
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
					<p class="product-price">${p.productPrice}원</p>
					<c:if test="${not empty p.productDiscountPer}">
						<p class="product-discount">${p.productDiscountPer}%할인</p>
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
