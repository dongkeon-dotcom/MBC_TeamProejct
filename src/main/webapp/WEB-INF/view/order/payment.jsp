<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<link rel="stylesheet" href="${path}/resources/css/order/checkout.css">

<div class="checkout-container">
    <h2 class="checkout-title">주문서</h2>

    <div class="checkout-box checkout-shipping">
        <h4>배송지 정보</h4>
        <c:choose>
            <c:when test="${not empty delivery}">
                <p><strong>${delivery.deliveryName}</strong> (기본 배송지)</p>
                <p>${delivery.address} ${delivery.extraAddress}</p>
                <p>${delivery.zipcode}</p>
                <p>${delivery.receiver} / ${delivery.deliveryPhone}</p>
            </c:when>
            <c:otherwise>
                <p style="color:red;">등록된 배송 정보가 없습니다.</p>
            </c:otherwise>
        </c:choose>
        
        <select name="deliveryRequest" id="deliveryRequest" style="width:100%; padding:10px; margin-top:10px;">
            <option value="">배송 요청사항을 선택해주세요</option>
            <option value="문 앞에 놔주세요">문 앞에 놔주세요</option>
            <option value="경비실에 맡겨주세요">경비실에 맡겨주세요</option>
        </select>
    </div>
<div class="test-container">
    <h3>트랜잭션 롤백 테스트</h3>
    <p>버튼을 누르면 동일한 PK 값이 두 번 삽입되어 에러가 발생해야 합니다.</p>
    
    <button type="button" onclick="runTransactionTest()">트랜잭션 테스트 실행</button>
</div>
    <div class="checkout-box checkout-items">
        <h4>주문상품</h4>
        <c:forEach var="item" items="${orderItems}">
            <div class="checkout-item">
                <p><strong>${item.productName}</strong></p>
                <p>옵션: ${item.color} / ${item.size} | 수량: ${item.quantity}개</p>
                <p>가격: <fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/>원</p>
            </div>
        </c:forEach>
    </div>

    <div class="checkout-box checkout-summary" style="text-align: right;">
        <h3>결제 요약</h3>
        <p style="font-size: 22px; color: #e60023; font-weight: bold;">
            최종 결제 금액: <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>원
        </p>
    </div>
    
    <div class="checkout-btn-wrapper">
        <form id="orderForm" action="${path}/order/complete.do" method="post">
            
            <c:forEach var="cIdx" items="${cartIdxList}">
                <input type="hidden" name="cartIdxList" value="${cIdx}">
            </c:forEach>

            <c:forEach var="item" items="${orderItems}">
                <input type="hidden" name="productIdx" value="${item.productIdx}">
                <input type="hidden" name="optionIdxList" value="${item.optionIdx}"> 
                <input type="hidden" name="quantityList" value="${item.quantity}">
            </c:forEach>

            <input type="hidden" name="totalPrice" value="${totalAmount}">
            <input type="hidden" name="receiver" value="${delivery.receiver}">
            <input type="hidden" name="deliveryPhone" value="${delivery.deliveryPhone}">
            <input type="hidden" name="address" value="${delivery.address}">
            <input type="hidden" name="extraAddress" value="${delivery.extraAddress}">
            <input type="hidden" name="zipcode" value="${delivery.zipcode}">
            
            <button type="button" class="checkout-btn" onclick="requestPayment()">
                <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>원 결제 하기
            </button>
        </form>
    </div>
</div>


<script src="https://cdn.portone.io/v2/browser-sdk.js"></script>

<script>
function runTransactionTest() {
    if(confirm("테스트를 실행하시겠습니까? (DB에 중복 데이터 삽입 시도)")) {
        // GET 방식으로 컨트롤러 호출
        location.href = "${path}/order/Test.do";
    }
}

async function requestPayment() {
    // 금액 확인 (서버 변수 totalAmount 사용)
    const totalAmount = parseInt("${totalAmount}"); 
    
    if (!totalAmount || totalAmount <= 0) {
        alert("결제할 금액이 없습니다.");
        return;
    }
    
    if(${empty delivery}){
    	if(confirm("배송 정보가 없습니다. 배송지 등록 페이지로 이동하시겠습니까?")){
    		location.href="${path}/delivery/addressList.do";
    	}
    	return;	
    }
    
    // 고객 정보 (loginUser 데이터가 확실히 넘어오는지 확인)
    const customerEmail = "${not empty loginUser.id ? loginUser.id : 'test@example.com'}";
    const customerName = "${not empty delivery.receiver ? delivery.receiver : '구매자'}";
    const customerPhone = "${not empty delivery.deliveryPhone ? delivery.deliveryPhone : '01000000000'}";
	
    try {
        const response = await PortOne.requestPayment({
            storeId: "store-2dadb46b-2543-4b52-8149-69728e9d9a99",        
            channelKey: "channel-key-cfb1a7b3-91d3-4c94-9e95-2c6a874fb953", 
            paymentId: "order_" + new Date().getTime(),
            orderName: "${orderItems[0].productName}" + ("${orderItems.size()}" > 1 ? " 외" : ""),
            totalAmount: totalAmount,
            currency: "CURRENCY_KRW",
            payMethod: "CARD",
            customer: {
                fullName: customerName,
                phoneNumber: customerPhone,
                emails: [customerEmail], // 이니시스 V2 필수
                email: customerEmail,    // 하위 호환
                address: {
                    addressLine1: "${delivery.address}",
                    addressLine2: "${delivery.extraAddress}"
                },
                zipcode: "${delivery.zipcode}"
            }
        });

        if (response.code != null) {
            return alert("결제 실패: " + response.message);
        }
        
        //if("뭔가 에러를 처리할 부분"){
        	//return alert(errorMsg);
        //}        
        

        alert("결제가 완료되었습니다.");
        document.getElementById('orderForm').submit();

    } catch (e) {
        console.error("에러 상세:", e);
        alert("결제창 호출 에러: " + e.message);
    }
}
    


</script>



  <c:import url="/WEB-INF/view/include/bottom.jsp" />