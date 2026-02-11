<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/WEB-INF/view/include/top.jsp" />

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${path}/resources/css/main.css" rel="stylesheet">

<section class="container mt-4">

	<h2 class="text-center mb-4">추천 상품</h2>
	<c:if test="${empty recommendedProducts}">
		<p class="text-center">추천 상품 데이터가 없습니다.</p>
	</c:if>

	<c:if test="${not empty recommendedProducts}">
		<div id="recommendedCarousel" class="carousel slide"
			data-bs-ride="carousel" data-bs-interval="4000">

			<!-- 인디케이터 -->
			<div class="carousel-indicators">
				<c:forEach var="p" items="${recommendedProducts}" varStatus="status">
					<button type="button" data-bs-target="#recommendedCarousel"
						data-bs-slide-to="${status.index}"
						class="${status.index == 0 ? 'active' : ''}"
						aria-current="${status.index == 0 ? 'true' : 'false'}"></button>
				</c:forEach>
			</div>

			<!-- 슬라이드 아이템 -->
			<div class="carousel-inner">
				<c:forEach var="p" items="${recommendedProducts}" varStatus="status">
					<div class="carousel-item ${status.index == 0 ? 'active' : ''}">
						<a
							href="${path}/userproduct/userproductdetail.do?productIdx=${p.productIdx}"
							class="carousel-link"> <c:choose>
								<c:when test="${not empty p.productMainImg}">
									<img
										src="${path}/resources/images/ProductMainImg/${p.productMainImg}"
										class="product-img" alt="${p.productName}">
								</c:when>
								<c:otherwise>
									<div class="no-image">이미지 준비중</div>
								</c:otherwise>
							</c:choose>


						</a>
						<div class="carousel-caption d-none d-md-block">
							<h5>${p.productName}</h5>
						</div>
					</div>
				</c:forEach>
			</div>

			<!-- 컨트롤 버튼 -->
			<button class="carousel-control-prev" type="button"
				data-bs-target="#recommendedCarousel" data-bs-slide="prev">
				<span class="carousel-control-prev-icon"></span>
			</button>
			<button class="carousel-control-next" type="button"
				data-bs-target="#recommendedCarousel" data-bs-slide="next">
				<span class="carousel-control-next-icon"></span>
			</button>
		</div>
	</c:if>


	<br> <br>

	<!-- 세일 상품 카테고리 버튼 -->
	<div class="text-center mb-3">
		<div class="btn-group" role="group">
			<button type="button"
				class="btn btn-outline-dark category-btn active" data-category="ALL">#ALL</button>
			<button type="button" class="btn btn-outline-dark category-btn"
				data-category="OUTER">#OUTER</button>
			<button type="button" class="btn btn-outline-dark category-btn"
				data-category="TOP">#TOP</button>
			<button type="button" class="btn btn-outline-dark category-btn"
				data-category="BOTTOM">#BOTTOM</button>
			<button type="button" class="btn btn-outline-dark category-btn"
				data-category="DRESS">#DRESS</button>
			<button type="button" class="btn btn-outline-dark category-btn"
				data-category="ETC">#ETC</button>
		</div>
	</div>

	<!-- 세일 상품 카드 -->
	<div class="row">
    <c:if test="${empty saleProducts}">
        <p class="text-center">세일 상품 데이터가 없습니다.</p>
    </c:if>

    <c:forEach var="p" items="${saleProducts}">
        <div class="col-md-3 mb-4 product-card" data-category="${p.category}">
            <div class="card h-100 shadow-sm">
                <!-- 이미지 -->
                <a href="${path}/userproduct/userproductdetail.do?productIdx=${p.productIdx}">
                    <c:choose>
                        <c:when test="${not empty p.productMainImg}">
                            <img src="${path}/resources/images/ProductMainImg/${p.productMainImg}" 
                                 class="product-img" alt="${p.productName}">
                        </c:when>
                        <c:otherwise>
                            <div class="no-image">이미지 준비중</div>
                        </c:otherwise>
                    </c:choose>
                </a>

                <!-- 상품 정보 -->
                <div class="card-body text-center">
                    <h5 class="card-title">${p.productName}</h5>

                    <!-- 가격/할인 표시 -->
					<c:choose>
					    <c:when test="${p.discountRate > 0}">
					        <p class="card-text product-price">
					            <span class="original-price">
					                ${(p.price * 100) / (100 - p.discountRate)}원
					            </span><br>
					            <span class="discounted-price">${p.price}원</span>
					            <span> ${p.discountRate}% </span>
					        </p>
					    </c:when>
					    <c:otherwise>
					        <p class="card-text product-price">${p.price}원</p>
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
                                   ${p.reviewCount}
                                </c:when>
                                <c:otherwise>
                                    ( 0 )
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>


</section>

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
/* 세일 상품 필터링 */
document.querySelectorAll('.category-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    const category = btn.getAttribute('data-category');
    document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    document.querySelectorAll('.product-card').forEach(card => {
      if (category === 'ALL' || card.getAttribute('data-category') === category) {
        card.style.display = "";
      } else {
        card.style.display = "none";
      }
    });
  });
});
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />
