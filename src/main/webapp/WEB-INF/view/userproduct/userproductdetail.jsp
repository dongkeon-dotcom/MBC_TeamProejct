<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="/WEB-INF/view/include/top.jsp" />

<html>
<head>
    <title>${product.productName} 상세보기</title>
    <link rel="stylesheet" href="${path}/resources/css/userproduct/userproductdetail.css">
    <style>
    

    </style>
    <script>
        function openTab(tabName) {
            const tabs = document.querySelectorAll(".tab-content");
            const buttons = document.querySelectorAll(".tab-buttons button");
            tabs.forEach(tab => {
                tab.classList.remove("active");
            });
            buttons.forEach(btn => btn.classList.remove("active"));

            const selectedTab = document.getElementById(tabName);
            const selectedBtn = document.getElementById(tabName + "-btn");

            selectedTab.classList.add("active");
            selectedBtn.classList.add("active");
        }
        window.onload = function() {
            openTab("info"); // 기본으로 '정보' 탭 열기
        }
    </script>
</head>
<body>
    <div class="product-detail" align="center">
        <!-- 상품 이미지 -->
        <div class="product-image">
            <c:if test="${not empty product.pMainImgPath}">
                <img src="${path}/resources/images/${product.pMainImgPath}" alt="${product.productName}">
            </c:if>
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
            <h2>${product.productName}</h2>
            <p class="product-price">${product.productPrice}원</p>
            <p class="product-discount">${product.productDiscountPer}% 할인</p>
            <p class="product-desc">${product.productDesc}</p>

            <!-- 옵션 선택 + 장바구니 버튼 -->
            <form action="${path}/cart/add.do" method="post">
                <input type="hidden" name="productIdx" value="${product.productIdx}">
                <label for="option">옵션 선택</label>
                <select name="optionIdx" id="option" required>
                    <c:forEach var="opt" items="${optionList}">
                        <option value="${opt.optionIdx}">
                            ${opt.optionColor} / ${opt.optionSize}
                        </option>
                    </c:forEach>
                </select>
                <label for="quantity">수량</label>
                <input type="number" name="quantity" id="quantity" value="1" min="1">
                <button type="submit">장바구니 담기</button>
            </form>
        </div>

        <!-- 사이즈 탭 -->
        <div id="size" class="tab-content">
            <h3>사이즈 정보</h3>
            <c:if test="${not empty product.sizeImgPath}">
                <img src="${path}/resources/images/${product.sizeImgPath}" alt="사이즈 정보">
            </c:if>
        </div>

        <!-- 리뷰 탭 -->
        <div id="review" class="tab-content">
            <h3>리뷰 (${fn:length(reviewList)})</h3>
            <c:forEach var="r" items="${reviewList}">
                <div class="review">
                    <p class="review-user"><strong>${r.userName}</strong></p>
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
