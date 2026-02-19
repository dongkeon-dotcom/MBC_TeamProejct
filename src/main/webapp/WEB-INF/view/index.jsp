<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:import url="/WEB-INF/view/include/top.jsp" />

<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>
<link href="${path}/resources/css/main.css" rel="stylesheet">

<section class="main-recommend-section">
    <c:if test="${not empty recommendedProducts}">
        <div class="slider-container">
            <div class="recommended-slick">
                <c:forEach var="p" items="${recommendedProducts}">
                    <div class="slick-item">
                        <div class="visual-card">
                            <a href="${path}/userproduct/userproductdetail.do?productIdx=${p.productIdx}">
                                <c:choose>
                                    <c:when test="${not empty p.productMainImg}">
                                        <img src="${path}/resources/images/ProductMainImg/${p.productMainImg}" class="bg-img">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-image-full">이미지 준비중</div>
                                    </c:otherwise>
                                </c:choose>

                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <div class="custom-counter">
                <span class="current">1</span> / <span class="total">0</span>
            </div>
        </div>
    </c:if>
</section>

<section class="container mt-5 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="section-title">SALE ITEMS</h2>
    </div>

    <div class="row product-grid">
        <c:if test="${empty saleProducts}">
            <p class="text-center w-100 py-5">세일 상품 데이터가 없습니다.</p>
        </c:if>

        <c:forEach var="p" items="${saleProducts}">
            <div class="col-md-3 col-6 mb-4 product-card-item" data-category="${p.category}">
                <div class="card h-100 border-0">
                    <div class="img-zoom-wrapper">
                        <a href="${path}/userproduct/userproductdetail.do?productIdx=${p.productIdx}">
                            <c:choose>
                                <c:when test="${not empty p.productMainImg}">
                                    <img src="${path}/resources/images/ProductMainImg/${p.productMainImg}" class="card-img-top" alt="${p.productName}">
                                </c:when>
                                <c:otherwise>
                                    <div class="no-image">이미지 준비중</div>
                                </c:otherwise>
                            </c:choose>
                        </a>
                       
                    </div>

                    <div class="card-body px-0 text-center">
                        <h5 class="item-name">${p.productName}</h5>
                        <div class="item-price-box">
                            <c:choose>
                                <c:when test="${not empty p.discountRate and p.discountRate > 0}">
                                    <p class="product-price">
                                        <span class="original-price" style="text-decoration: line-through; color: #bbb; font-size: 0.9em;">
                                            <fmt:formatNumber value="${p.price}" pattern="#,###"/>원
                                        </span>
                                        
                                        <span class="discounted-price" style="font-weight: bold; color: #e74c3c;">
                                            <%-- 할인가 계산 후 소수점 제거 --%>
                                            <fmt:parseNumber var="discountPrice" value="${p.price * (100 - p.discountRate) / 100}" integerOnly="true" />
                                            <fmt:formatNumber value="${p.discountedPrice}" pattern="#,###"/>원
                                        </span>
                                        <span class="product-discount" style="color: #3498db; font-weight: bold;">${p.discountRate}%</span>
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="product-price">
                                        <fmt:formatNumber value="${p.price}" pattern="#,###"/>원
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                       <div class="product-rating">
                            <span style="color: #f1c40f;">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <%-- avgRating이 null이면 0처리 --%>
                                        <c:when test="${i <= (p.avgRating != null ? p.avgRating : 0)}">★</c:when>
                                        <c:otherwise>☆</c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </span>
                            <span class="rating-text" style="font-size: 0.9em; color: #ff9800;">
                                (${not empty p.reviewCount ? p.reviewCount : 0})
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>

<script>
$(document).ready(function(){
    var $slick = $('.recommended-slick');

    // 슬라이더 초기화 및 숫자 업데이트
    $slick.on('init reInit afterChange', function (event, slick, currentSlide) {
        var i = (currentSlide ? currentSlide : 0) + 1;
        $('.custom-counter .current').text(i);
        $('.custom-counter .total').text(slick.slideCount);
    });

    $slick.slick({
        infinite: true,
        slidesToShow: 3,
        centerMode: true,
        centerPadding: '120px', // 좌우 이미지 걸침 정도
        autoplay: true,
        arrows: true,
        draggable: true,
        swipeToSlide: true,
        responsive: [
            { breakpoint: 1200, settings: { slidesToShow: 2, centerPadding: '60px' } },
            { breakpoint: 768, settings: { slidesToShow: 1, centerPadding: '40px' } }
        ]
    });

    // 필터 기능
    $('.filter-btn').click(function(){
        $('.filter-btn').removeClass('active');
        $(this).addClass('active');
        var cat = $(this).data('category');
        
        $('.product-card-item').each(function(){
            if(cat === 'ALL' || $(this).data('category') === cat) $(this).fadeIn();
            else $(this).hide();
        });
    });
});
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />