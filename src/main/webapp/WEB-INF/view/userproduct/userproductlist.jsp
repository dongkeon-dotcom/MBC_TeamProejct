<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<link href="${path}/resources/css/userproductlist.css" rel="stylesheet">

<section>
	<h2 align="center">상품 목록</h2>
	<div class="product-grid">
		<c:forEach var="p" items="${li}">
			<div class="product-card">
				<a href="${pageContext.request.contextPath}/userproduct/detail.do?productIdx=${p.productIdx}">
				<img src="${pageContext.request.contextPath}${p.pMainImgPath}" alt="${p.productName}"> </a>
				<div class="product-info">
					<div class="product-name">${p.productName}</div>
					<div class="product-price">${p.productPrice}원</div>
					<c:if test="${p.productDiscountPer > 0}">
						<div class="product-discount">${p.productDiscountPer}%할인</div>
					</c:if>
					<div class="product-rating">
						<c:forEach begin="1" end="5" var="i">
							<c:if test="${i <= p.avgRating}">★</c:if>
							<c:if test="${i > p.avgRating}">☆</c:if>
						</c:forEach>
						<span style="color: #555;">(${p.reviewCount} 리뷰)</span>
					</div>
				</div>
			</div>
		</c:forEach>
	</div>
</section>




<c:import url="/WEB-INF/view/include/bottom.jsp" />
