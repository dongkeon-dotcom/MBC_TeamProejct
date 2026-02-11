<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<html>
<head>
<title>결제 페이지</title>
<link rel="stylesheet" href="${path}/resources/css/order/checkout.css">
</head>

<body>
<div class="checkout-container">
    <h2 class="checkout-title">결제 페이지</h2>

    <!-- 배송지 정보 -->
    <div class="checkout-box checkout-shipping">
        <h4>배송지 정보</h4>
        <p><strong>${delivery.deliveryName}</strong> (기본 배송지)</p>
        <p>${delivery.address} ${delivery.extraAddress}</p>
        <p>${delivery.zipcode}</p>
        <p>${delivery.receiver} / ${delivery.deliveryPhone}</p>

        <label>배송 요청사항</label>
        <select name="deliveryRequest">
            <option value="">배송 요청사항을 선택해주세요</option>
            <option value="문 앞에 놔주세요">문 앞에 놔주세요</option>
            <option value="경비실에 맡겨주세요">경비실에 맡겨주세요</option>
            <option value="택배함에 넣어주세요">택배함에 넣어주세요</option>
            <option value="배송 전에 연락 주세요">배송 전에 연락 주세요</option>
            <option value="직접입력">직접입력</option>
        </select>
    </div>

  
    <!-- 주문 상품 정보 -->
<div class="checkout-box checkout-items">
    <h4>주문상품</h4>
    <div class="checkout-item">
        <p class="item-name"><strong>${product.productName}</strong></p>
        <p>옵션: ${selectedOption.color} / ${selectedOption.size}</p>
        <p>수량: ${quantity}개</p>
        <p>가격: ${product.price}원</p>
        <c:if test="${product.discountRate > 0}">
            <p>할인가: ${product.price * (100 - product.discountRate) / 100}원</p>
        </c:if>
    </div>
</div>

    <!-- 결제 요약 -->
    <div class="checkout-box checkout-summary">
        <h3>결제 요약</h3>
        <p>배송비: 0원</p>
        <p>최종 결제 금액: ${totalPrice}원</p>
    </div>

    <!-- 결제 버튼 -->
    <form action="${pageContext.request.contextPath}/order/complete.do" method="post">
        <!-- Hidden 필드들 -->
        <input type="hidden" name="productIdx" value="${product.productIdx}">
        <input type="hidden" name="optionIdx" value="${selectedOption.optionIdx}">
        <input type="hidden" name="quantity" value="${quantity}">
        <input type="hidden" name="totalPrice" value="${totalPrice}">
        <input type="hidden" name="receiver" value="${delivery.receiver}">
        <input type="hidden" name="deliveryPhone" value="${delivery.deliveryPhone}">
        <input type="hidden" name="address" value="${delivery.address}">
        <input type="hidden" name="extraAddress" value="${delivery.extraAddress}">
        <input type="hidden" name="zipcode" value="${delivery.zipcode}">

        <button type="submit" class="checkout-btn">${totalPrice}원 결제 하기</button>
    </form>
</div>



</body>
</html>

<c:import url="/WEB-INF/view/include/bottom.jsp" />
