<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<link rel="stylesheet" href="${path}/resources/css/cart/cartlist.css">

<div class="cart-wrapper">
	<div class="cart-container">
		<div class="cart-title">장바구니</div>

		<table class="cart-table">
			<thead>
				<tr>
					<th><input type="checkbox" id="selectAll"
						onclick="toggleSelectAll()" checked></th>
					<th>이미지</th>
					<th>상품정보</th>
					<th>수량</th>
					<th>판매가</th>
					<th>관리</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${not empty cartList}">
						<c:forEach var="item" items="${cartList}">
							<c:set var="rate"
								value="${not empty item.discountRate ? item.discountRate : 0}" />
							<c:set var="baseUnit" value="${item.price}" />
							<c:set var="discountedUnit"
								value="${rate > 0 ? (item.price * (100 - rate) / 100) : item.price}" />

							<c:set var="baseTotal" value="${baseUnit * item.quantity}" />
							<c:set var="finalTotal" value="${discountedUnit * item.quantity}" />

							<tr>
								<td><input type="checkbox" class="chk" name="cartItem"
									value="${item.cartIdx}"
									data-base="<fmt:formatNumber value='${baseTotal}' pattern='#'/>"
									data-final="<fmt:formatNumber value='${finalTotal}' pattern='#'/>"
									onclick="updateTotalPrice()" checked></td>
								<td><a
									href="${path}/userproduct/userproductdetail.do?productIdx=${item.productIdx}">
										<c:choose>
											<c:when test="${not empty item.productMainImg}">
												<img src="${path}/resources/upload/${item.productMainImg}"
													class="product-img" alt="${item.productName}"
													onerror="this.onerror=null; this.src='${path}/resources/images/no_image.jpg';">
											</c:when>
											<c:otherwise>
												<img src="${path}/resources/images/no_image.jpg}"
													class="product-img" alt="이미지 없음">
											</c:otherwise>
										</c:choose>
								</a></td>
								<td class="product-info-td"><a
									href="${path}/userproduct/userproductdetail.do?productIdx=${item.productIdx}"
									class="product-link">${item.productName}</a>
									<div class="option-text">[옵션: ${item.color} /
										${item.size}]</div></td>
								<td class="qty-cell">
									<form action="${path}/cart/update.do" method="post"
										class="qty-form">
										<input type="hidden" name="cartIdx" value="${item.cartIdx}">
										<div class="qty-wrapper">
											<input type="number" name="quantity" value="${item.quantity}"
												min="1" class="qty-input">
											<button type="submit" class="btn-update">변경</button>
										</div>
									</form>
								</td>
								<td class="price-cell"><c:if test="${rate > 0}">
										<div class="original-price">
											<fmt:formatNumber value="${baseTotal}" pattern="#,###" />
											원
										</div>
									</c:if>
									<div class="final-price">
										<fmt:formatNumber value="${finalTotal}" pattern="#,###" />
										원
									</div></td>
								<td>
									<form action="${path}/cart/delete.do" method="post"
										onsubmit="return confirm('삭제하시겠습니까?');">
										<input type="hidden" name="cartIdx" value="${item.cartIdx}">
										<button type="submit" class="btn-delete">삭제</button>
									</form>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="6" class="empty-cart">장바구니가 비어있습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>

		<c:if test="${not empty cartList}">
			<div class="cart-footer">
				<div class="total-section">
					<div class="total-row">
						<span class="total-label">상품 금액</span> <span class="total-value"><span
							id="basePriceDisplay">0</span>원</span>
					</div>
					<div class="total-row">
						<span class="total-label">할인 금액</span> <span
							class="total-value discount">- <span id="discountDisplay">0</span>원
						</span>
					</div>
					<div class="total-row">
						<span class="total-label">배송비</span> <span class="total-value">무료배송</span>
					</div>

					<hr class="total-divider">
					<div class="total-row final">
						<span class="total-label">총 구매 금액</span> <span
							class="total-value main-total"><span
							id="totalPriceDisplay">0</span>원</span>
					</div>

					<hr class="total-divider-bottom">
					<div class="order-action-area">
						<button type="button" class="btn-main-order"
							onclick="goToCheckout()">선택 상품 주문하기</button>
					</div>
				</div>
			</div>
		</c:if>
	</div>
</div>

<script>
function updateTotalPrice() {
    const checkboxes = document.querySelectorAll('.chk:checked');
    let sumBase = 0;   
    let sumFinal = 0;  
    
    checkboxes.forEach(cb => {
        // dataset을 읽어올 때 문자열 내 공백을 제거하고 숫자로 변환
        const b = Number(cb.dataset.base.replace(/[^0-9.-]+/g,"")) || 0;
        const f = Number(cb.dataset.final.replace(/[^0-9.-]+/g,"")) || 0;
        sumBase += b;
        sumFinal += f;
    });

    const totalDiscount = sumBase - sumFinal;

    // 화면 업데이트 (존재 여부 확인 후)
    if(document.getElementById('basePriceDisplay')) 
        document.getElementById('basePriceDisplay').innerText = sumBase.toLocaleString();
    if(document.getElementById('discountDisplay')) 
        document.getElementById('discountDisplay').innerText = totalDiscount.toLocaleString();
    if(document.getElementById('totalPriceDisplay')) 
        document.getElementById('totalPriceDisplay').innerText = sumFinal.toLocaleString();
}

function toggleSelectAll() {
    const selectAll = document.getElementById('selectAll');
    const checkboxes = document.querySelectorAll('.chk');
    checkboxes.forEach(cb => cb.checked = selectAll.checked);
    updateTotalPrice();
}

// 페이지 로드 즉시 실행
document.addEventListener('DOMContentLoaded', updateTotalPrice);

function goToCheckout() {
    const checkedItems = document.querySelectorAll('.chk:checked');
    if (checkedItems.length === 0) {
        alert('주문하실 상품을 선택해주세요.');
        return;
    }
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${path}/order/payment.do';
    checkedItems.forEach(cb => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'cartIdxList';
        input.value = cb.value;
        form.appendChild(input);
    });
    document.body.appendChild(form);
    form.submit();
}
</script>
<c:import url="/WEB-INF/view/include/bottom.jsp" />