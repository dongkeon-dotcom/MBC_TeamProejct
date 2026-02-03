<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<html>
<head>
    <title>결제 완료</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; }
        .container { max-width: 600px; margin: auto; border: 1px solid #ddd; padding: 20px; border-radius: 8px; }
        h2 { text-align: center; }
        .summary { margin-top: 20px; }
        .btn { background-color: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; }
        .btn:hover { background-color: #45a049; }
    </style>
</head>
<body>
<div class="container">
    <h2>결제 확인</h2>

    <!-- 주문상품 정보 -->
    <div class="order-items">
        <p>상품명: ${product.productName}</p>
        <p>옵션: ${selectedOption.color} / ${selectedOption.size}</p>
        <p>수량: ${quantity}개</p>
        <p>가격: ${product.price}원</p>
    </div>

    <!-- 배송지 정보 -->
    <div class="shipping-info">
        <p>배송지 정보 </p>
    </div>

    <!-- 결제 완료 버튼 -->
    <form action="${pageContext.request.contextPath}/order/complete.do" method="post">
        <input type="hidden" name="productIdx" value="${product.productIdx}">
        <input type="hidden" name="optionIdx" value="${selectedOption.optionIdx}">
        <input type="hidden" name="quantity" value="${quantity}">
        <input type="hidden" name="totalPrice" value="${totalPrice}">
        <button type="submit" class="btn">결제 완료</button>
    </form>
</div>
</body>
</html>


<script>
    
</script>

<br>
<c:import url="/WEB-INF/view/include/bottom.jsp" />