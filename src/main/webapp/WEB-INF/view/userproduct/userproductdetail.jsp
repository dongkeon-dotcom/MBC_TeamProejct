<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="/WEB-INF/view/include/top.jsp" />

<html>
<head>
    <title>${product.productName} 상세보기</title>
    <link rel="stylesheet" href="${path}/resources/css/userproduct/userproductdetail.css">
</head>
<body>
    <div class="product-detail" align="center">
        <!-- 상품 이미지 -->
        <div class="product-image">
            <c:if test="${not empty product.pMainImgPath}">
                <img src="${path}/resources/images/${product.pMainImgPath}" alt="${product.productName}">
            </c:if>
        </div>

        <!-- 상품 정보 -->
        <div class="product-info">
            <h2 class="product-name">${product.productName}</h2>
            <p class="product-price">${product.productPrice}원</p>
            <p class="product-discount">${product.productDiscountPer}% 할인</p>

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
    </div>

    <!-- 리뷰 영역 -->
    <div class="product-reviews">
        <h3>리뷰 (${fn:length(reviewList)})</h3>
        <c:forEach var="r" items="${reviewList}">
            <div class="review">
                <p class="review-user"><strong>${r.userName}</strong></p>
                <p class="review-content">${r.content}</p>
                <p class="review-rating">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= r.rating}">★</c:when>
                            <c:otherwise>☆</c:otherwise>
                        </c:choose>
                    </c:forEach>
                </p>
            </div>
        </c:forEach>
    </div>
</body>
</html>

<c:import url="/WEB-INF/view/include/bottom.jsp" />
