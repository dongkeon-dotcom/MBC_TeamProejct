<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:import url="/WEB-INF/view/include/top.jsp" />


<html>
<head>
<title>${product.productName}상세보기</title>
<link rel="stylesheet"
	href="${path}/resources/css/userproduct/userproductdetail.css">


<script src="${path}/resources/js/productOption.js"> </script>
<script>

        function openTab(tabName) {
            const tabs = document.querySelectorAll(".tab-content");
            const buttons = document.querySelectorAll(".tab-buttons button");
            tabs.forEach(tab => tab.classList.remove("active"));
            buttons.forEach(btn => btn.classList.remove("active"));
            document.getElementById(tabName).classList.add("active");
            document.getElementById(tabName + "-btn").classList.add("active");
        }
        window.onload = function() { openTab("info"); }
        
		
        
		function submitForm(actionUrl) {
		    const form = document.getElementById("productForm");
		    form.action = actionUrl;
		}
		
	
	    // 장바구니 버튼 클릭 시 현재 선택값을 숨은 form에 복사
	    document.querySelector('.btn-cart').addEventListener('click', function() {
	        document.getElementById('cartOption').value = document.getElementById('option').value;
	        document.getElementById('cartQuantity').value = document.getElementById('quantity').value;
	    });
	
</script>
</head>


<body>
	<div class="product-detail">

		<!-- 상품 이미지 -->
		<div class="product-image">
			<c:choose>
				<c:when test="${not empty product.productMainImg}">
					<img src="${path}/resources/images/${product.productMainImg}" alt="${product.productName}">
				</c:when>
				<c:otherwise>
					<div class="no-image">이미지 준비중</div>
				</c:otherwise>
			</c:choose>
		</div>


		<!-- 상품 설명 -->
		<div class="product-info">
			<h2>${product.productName}</h2>
			<p class="product-price">${product.price}원</p>
			<c:if test="${product.discountRate > 0}">
				<p class="product-discount">${product.discountRate}%할인</p>
			</c:if>


			<!-- 구매 버튼: 결제 페이지 및 장바구니 이동
			<form id="productForm" method="post">
				<input type="hidden" name="productIdx" value="${product.productIdx}">
				<label for="option">옵션 선택</label> <select name="optionIdx"
					id="option" required>
					<c:forEach var="opt" items="${optionList}">
						<option value="${opt.optionIdx}">${opt.color}/
							${opt.size}</option>
					</c:forEach>
				</select> <label for="quantity">수량</label> <input type="number"
					name="quantity" id="quantity" value="1" min="1"><br>


				<button type="submit" onclick="submitForm('${path}/order/payment.do')">구매</button> 
				<button type="submit" onclick="submitForm('${path}/cart/add.do')">장바구니 담기</button>
			</form>
			  -->

			<form action="${path}/order/payment.do" method="post">
				<input type="hidden" name="productIdx" value="${product.productIdx}">

				<label for="option">옵션 선택</label> 
				<select name="optionIdx" id="option" required>
					<c:forEach var="opt" items="${optionList}"> 
					<option value="${opt.optionIdx}">${opt.color}/${opt.size}</option>
					</c:forEach> </select> 
					
				<label for="quantity">수량</label> 
				<input type="number" name="quantity" id="quantity" value="1" min="1">

				<!-- 버튼을 수량 밑에 나란히 배치 -->
				<div class="button-row">
					<button type="submit" class="btn-buy">구매</button>
					<!-- 장바구니 버튼은 같은 줄에 -->
					<button type="button" class="btn-cart"
						onclick="document.getElementById('cartForm').submit();">장바구니
						담기</button>
				</div>
			</form>

			<!-- 장바구니 전송용 별도 form -->
			<form id="cartForm" action="${path}/cart/add.do" method="post"
				style="display: none;">
				<input type="hidden" name="productIdx" value="${product.productIdx}">
				<input type="hidden" name="optionIdx" id="cartOption"> <input
					type="hidden" name="quantity" id="cartQuantity">
			</form>



		</div>
	</div>

	<!-- 탭 네비게이션 -->
	<div class="tab-container">
		<div class="tab-buttons">
			<button id="info-btn" onclick="openTab('info')">정보</button>
			<button id="size-btn" onclick="openTab('size')">사이즈</button>
			<button id="review-btn" onclick="openTab('review')">리뷰</button>
		</div>



		<!-- 정보 탭 -->
		<div id="info" class="tab-content">
			<p class="product-desc">${product.productDesc}</p>



		</div>




		<!-- 사이즈 탭 -->
		<div id="size" class="tab-content">
			<h3>사이즈 정보</h3>
			<c:if test="${not empty product.productSizeImg}">
				<img src="${path}/resources/images/${product.productSizeImg}"
					alt="사이즈 정보">

			</c:if>
		</div>


		<!-- 리뷰 탭 -->
		<div id="review" class="tab-content">
			<h3>리뷰 (${fn:length(reviewList)})</h3>

			<c:if test="${empty reviewList}">
				<p>등록된 리뷰가 없습니다.</p>
			</c:if>

			<c:forEach var="r" items="${reviewList}">
				<div class="review">
					<p class="review-user">
						<strong>${r.userName}</strong>
					</p>
					<p class="review-content">${r.reviewDesc}</p>
					<p class="review-rating">
						<c:forEach begin="1" end="5" var="i">
							<c:choose>
								<c:when test="${i <= r.reviewRating}">★</c:when>
								<c:otherwise>☆</c:otherwise>
							</c:choose>
						</c:forEach>
					</p>
				</div>
			</c:forEach>
		</div>
	</div>
</body>
</html>



<c:import url="/WEB-INF/view/include/bottom.jsp" />
