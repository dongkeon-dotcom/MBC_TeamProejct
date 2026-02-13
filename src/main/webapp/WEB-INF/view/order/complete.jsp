<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<style>
    .complete-wrapper { max-width: 800px; margin: 50px auto; padding: 40px; border: 1px solid #eee; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
    .success-icon { font-size: 50px; color: #4CAF50; text-align: center; margin-bottom: 20px; }
    .order-info-box { background: #f9f9f9; padding: 25px; border-radius: 12px; margin: 20px 0; }
    .info-row { display: flex; justify-content: space-between; margin-bottom: 10px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
    .info-label { color: #666; font-weight: bold; }
    .info-value { color: #333; }
    .btn-group { display: flex; gap: 15px; margin-top: 30px; }
    .btn-main { flex: 1; padding: 15px; border-radius: 8px; text-align: center; text-decoration: none; font-weight: bold; }
    .btn-home { background-color: #333; color: white; }
    .btn-order { background-color: #f07376; color: white; }
</style>

<div class="complete-wrapper">
    <div class="success-icon">✔</div>
    <h2 style="text-align: center; margin-bottom: 10px;">주문이 완료되었습니다!</h2>
    <p style="text-align: center; color: #888;">고객님의 주문이 정상적으로 접수되었습니다.</p>

    <div class="order-info-box">
        <h4 style="margin-bottom: 20px; border-left: 4px solid #f07376; padding-left: 10px;">결제 정보</h4>
        <div class="info-row">
            <span class="info-label">주문번호</span>
            <span class="info-value">ORD-${order.orderIdx}</span>
        </div>
        <div class="info-row">
            <span class="info-label">최종 결제금액</span>
            <span class="info-value" style="color: #e60023; font-size: 1.2em;">
                <fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/>원
            </span>
        </div>
    </div>

    <div class="order-info-box">
        <h4 style="margin-bottom: 20px; border-left: 4px solid #f07376; padding-left: 10px;">배송지 정보</h4>
        <div class="info-row">
            <span class="info-label">받는 분</span>
            <span class="info-value">${order.receiver}</span>
        </div>
        <div class="info-row">
            <span class="info-label">연락처</span>
            <span class="info-value">${order.deliveryPhone}</span>
        </div>
        <div class="info-row" style="border:none;">
            <span class="info-label">주소</span>
            <span class="info-value" style="text-align: right;">
                (${order.zipcode})<br>
                ${order.address}<br>
                ${order.extraAddress}
            </span>
        </div>
    </div>

    <div class="btn-group">
        <a href="${path}/index.do" class="btn-main btn-home">쇼핑 계속하기</a>
        <a href="${path}/user/orderList.do" class="btn-main btn-order">주문 내역 확인</a>
    </div>
</div>

<c:import url="/WEB-INF/view/include/bottom.jsp" />