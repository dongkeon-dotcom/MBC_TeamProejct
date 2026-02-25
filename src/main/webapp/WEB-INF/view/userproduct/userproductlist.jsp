<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:import url="/WEB-INF/view/include/top.jsp" />
<br><br>

<link rel="stylesheet" href="${path}/resources/css/userproduct/userproductlist.css">
<section>

<!-- 검색 결과 안내 -->

<c:if test="${not empty searchKeyword}">
    <div class="search-result-info text-center mb-4">
        <c:choose>
            <c:when test="${totalCount > 0}">
                <strong>"${searchKeyword}"</strong> 검색 결과: 
                <span>${totalCount}개</span>
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

                    <%-- [기능] 가격 표시: 할인 여부와 상관없이 모든 금액에 절삭 로직 및 콤마 적용 --%>
                    <c:choose>
                        <%-- 1. 할인율이 있는 경우 --%>
                        <c:when test="${not empty p.discountRate and p.discountRate > 0}">
                            <p class="product-price">
                                <%-- 원가 표시 (취소선 및 콤마) --%>
                                <span class="original-price">
                                    <fmt:formatNumber value="${p.price}" pattern="#,###" />원
                                </span> 
                                <%-- 할인가 표시 (VO의 getDiscountedPrice 메서드로 10원 단위 절삭) --%>
                                <span class="discounted-price"> 
                                    <fmt:formatNumber value="${p.discountedPrice}" pattern="#,###" />원
                                </span> 
                                <span class="product-discount">${p.discountRate}%</span>
                            </p>
                        </c:when>
                        
                        <%-- 2. 할인이 없는 상품인 경우 --%>
                        <c:otherwise>
                            <p class="product-price">
                                <%-- 
                                    정가 상품도 p.discountedPrice를 호출하여 
                                    10원 단위 절삭(price / 10 * 10)을 동일하게 적용 
                                --%>
                                <fmt:formatNumber value="${p.discountedPrice}" pattern="#,###" />원
                            </p>
                        </c:otherwise>
                    </c:choose>



					<div class="product-rating">
					        <span class="rating-stars" style="color: #FFB800;">
					        <c:forEach begin="1" end="5" var="i">
					            <c:choose>
					                
					                <c:when test="${i <= (p.avgRating - (p.avgRating % 1))}">
					                    ★
					                </c:when>
					                <c:otherwise>
					                    ☆
					                </c:otherwise>
					            </c:choose>
					        </c:forEach>
					    </span>
					    
					    
					    <span class="rating-score">
					        <fmt:formatNumber value="${p.avgRating}" pattern="0.0" />
					    </span>
					
					    <span class="rating-count">
					        (${p.reviewCount != null ? p.reviewCount : 0})
					    </span>
					</div>
					
                </div>
            </div>
        </c:forEach>
    </div>

<br><br><br>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />
