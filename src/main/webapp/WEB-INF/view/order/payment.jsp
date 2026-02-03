<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />


<html>
<head>
<title>결제 페이지</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 30px;
}

.container {
	max-width: 600px;
	margin: auto;
	border: 1px solid #ddd;
	padding: 20px;
	border-radius: 8px;
}

h2 {
	text-align: center;
}

.product-info, .option-info, .summary {
	margin-bottom: 20px;
}

.label {
	font-weight: bold;
}

.btn {
	background-color: #4CAF50;
	color: white;
	padding: 10px 20px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

.btn:hover {
	background-color: #45a049;
}
</style>
</head>
<body>
	<div class="container">
		<h2>결제 페이지</h2>

		<!-- 상품 정보 -->
		<div class="shipping-info">
			<h3>배송지 정보</h3>
			<p>${delivery.deliveryName}(기본 배송지)</p>
			<p>${delivery.address}${delivery.extraAddress}</p>
			<p>${delivery.zipcode}</p>
			<p>${delivery.receiver}/ ${delivery.deliveryPhone}</p>

			<label>배송 요청사항</label> <select name="deliveryRequest">
				<option value="">배송 요청사항을 선택해주세요</option>
				<option value="문 앞에 놔주세요">문 앞에 놔주세요</option>
				<option value="경비실에 맡겨주세요">경비실에 맡겨주세요</option>
				<option value="택배함에 넣어주세요">택배함에 넣어주세요</option>
				<option value="배송 전에 연락 주세요">배송 전에 연락 주세요</option>
				<option value="직접입력">직접입력</option>
			</select>
		</div>



		<div class="order-items">
			<h3>주문상품</h3>
			<p>${product.productName}</p>
			<p>옵션: ${selectedOption.color} / ${selectedOption.size}</p>
			<p>수량: ${quantity}개</p>
			<p>가격: ${product.price}원</p>
		</div>



		<div class="summary">
			<p>배송비: 0원</p>
			<p>최종 결제 금액: ${totalPrice}원</p>
		</div>


		<!-- 결제 완료 버튼 -->
		<form action="${pageContext.request.contextPath}/order/complete.do" method="post">
		    <!-- 상품 정보 -->
		    <input type="hidden" name="productIdx" value="${product.productIdx}">
		    <input type="hidden" name="optionIdx" value="${selectedOption.optionIdx}">
		    <input type="hidden" name="quantity" value="${quantity}">
		    <input type="hidden" name="totalPrice" value="${totalPrice}">
		
		    <!-- 배송지 정보 (추후 DeliveryVO 연동 가능) -->
		    <input type="hidden" name="recevier" value="홍길동">
		    <input type="hidden" name="deliveryPhone" value="010-1234-5678">
		    <input type="hidden" name="address" value="서울시 강남구">
		    <input type="hidden" name="extraAddress" value="101호">
		    <input type="hidden" name="zipcode" value="12345">
		
		    <!-- 결제 버튼 -->
		    <button type="submit" class="btn">${totalPrice}원 결제 하기</button>
		</form>

		
	</div>
</body>
</html>


<script>
    
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />