<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />


<link rel="stylesheet" href="${path}/resources/css/userproduct/userproductlist.css">
<section>
	
<!-- 검색 결과 안내 -->
<c:if test="${not empty searchKeyword}">
    <div class="search-result-info text-center mb-3">
        <c:choose>
            <c:when test="${resultCount > 0}">
                <strong>"${searchKeyword}"</strong> 검색 결과: 
                <span>${resultCount}개</span>
            </c:when>
            <c:otherwise>
                <strong>"${searchKeyword}"</strong>에 대한 검색 결과가 없습니다.
            </c:otherwise>
        </c:choose>
    </div>
</c:if>
<br>
	
    <!-- 상품 리스트 -->
    <div class="product-grid">
        <c:forEach var="p" items="${userProductList}">
            <div class="product-card">
                <!-- 이미지 -->
                <a href="${path}/userproduct/userproductdetail.do?productIdx=${p.productIdx}">
                    <c:choose>
                        <c:when test="${not empty p.productMainImg}">
                            <img src="${path}/resources/images/ProductMainImg/${p.productMainImg}" alt="${p.productName}">
                        </c:when>
                        <c:otherwise>
                            <div class="no-image">이미지 준비중</div>
                        </c:otherwise>
                    </c:choose>
                </a>

                <!-- 상품 정보 -->
                <div class="product-info">
                    <p class="product-name">${p.productName}</p>

                    <!-- 가격/할인 표시 -->
                    <c:choose>
                        <c:when test="${not empty p.discountRate and p.discountRate > 0}">
                            <p class="product-price">
                                <span class="original-price">${p.price}원</span>
                                <span class="discounted-price">
                                    ${p.price - (p.price * p.discountRate / 100)}원
                                </span>
                                <span class="product-discount">${p.discountRate}%</span>
                            </p>
                        </c:when>
                        <c:otherwise>
                            <p class="product-price">${p.price}원</p>
                        </c:otherwise>
                    </c:choose>

                    <!-- 리뷰/별점 -->
                    <div class="product-rating">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= (p.avgRating != null ? p.avgRating : 0)}">★</c:when>
                                <c:otherwise>☆</c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <span class="rating-text">
                            <c:choose>
                                <c:when test="${not empty p.reviewCount and p.reviewCount > 0}">
                                    ( ${p.reviewCount} )
                                </c:when>
                                <c:otherwise>
                                    ( 0 )
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

<br><br><br>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />
