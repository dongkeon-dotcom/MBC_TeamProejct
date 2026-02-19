<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:import url="/WEB-INF/view/include/top.jsp" />

<link rel="stylesheet" href="${path}/resources/css/cart/cartlist.css">

<div class="cart-wrapper">
    <div class="cart-container">
        <h2 class="cart-title">장바구니</h2>

        <table class="cart-table">
            <thead>
                <tr>
                    <th><input type="checkbox" id="selectAll" onclick="toggleSelectAll()" checked></th>
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
                            <tr class="${item.stock <= 0 ? 'sold-out-row' : ''}">
                                <td>
                                    <c:choose>
                                        <c:when test="${item.stock > 0}">
                                            <input type="checkbox" class="chk" name="cartItem" 
                                                   value="${item.cartIdx}"
                                                   data-price="${item.price}" 
                                                   data-origin="${item.originPrice != 0 ? item.originPrice : item.price}"
                                                   data-quantity="${item.quantity}"
                                                   onclick="updateTotalPrice()" checked>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="checkbox" class="chk" disabled>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${path}/userproduct/userproductdetail.do?productIdx=${item.productIdx}">
                                        <c:choose>
                                            <c:when test="${not empty item.productMainImg}">
                                                <img src="${path}/resources/images/ProductMainImg/${item.productMainImg}" 
                                                     class="product-img ${item.stock <= 0 ? 'gray-img' : ''}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-img-box">이미지 준비중</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </a>
                                </td>
                                <td class="product-info-td">
                                    <a href="${path}/userproduct/userproductdetail.do?productIdx=${item.productIdx}" class="product-link">
                                        ${item.productName}
                                    </a>
                                    <c:if test="${item.stock <= 0}">
                                        <span class="sold-out-badge">품절</span>
                                    </c:if>
                                    <div class="option-text">[옵션: ${item.color} / ${item.size}]</div>
                                </td>
                                <td>
                                    <div class="qty-wrapper">
                                        <input type="number" id="qty_${item.cartIdx}" 
                                               value="${item.quantity}" 
                                               min="1" 
                                               max="${item.stock}" 
                                               data-stock="${item.stock}" 
                                               class="qty-input" 
                                               ${item.stock <= 0 ? 'disabled' : ''}>
                                        <button type="button" class="btn-update" onclick="updateQty(${item.cartIdx})">변경</button>
                                    </div>
                                    <div class="stock-info" style="font-size: 11px; color: #888; margin-top: 4px;">
                                        (남은재고: ${item.stock}개)
                                    </div>
                                </td>
                                <td class="price-cell">
                                    <c:if test="${item.originPrice > item.price}">
                                        <span class="original-price"><fmt:formatNumber value="${item.originPrice * item.quantity}" pattern="#,###"/>원</span>
                                    </c:if>
                                    <span class="final-price"><fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###"/>원</span>
                                </td>
                                <td>
                                    <button type="button" class="btn-delete" onclick="deleteCartItem(${item.cartIdx})">삭제</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" style="padding: 100px 0; color: #999; text-align: center;">장바구니에 담긴 상품이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="cart-footer">
            <div class="total-section">
                <div class="total-row">
                    <span class="total-label">상품 금액</span>
                    <span class="total-value"><span id="basePriceDisplay">0</span>원</span>
                </div>
                <div class="total-row">
                    <span class="total-label">할인 금액</span>
                    <span class="total-value discount">- <span id="discountDisplay">0</span>원</span>
                </div>
                <div class="total-row">
                    <span class="total-label">배송비</span>
                    <span class="total-value" id="deliveryFeeDisplay">무료배송</span>
                </div>
                <hr class="total-divider">
                <div class="total-row final">
                    <span class="total-label">총 구매 금액</span>
                    <span class="total-value main-total"><span id="totalPriceDisplay">0</span>원</span>
                </div>
                <button type="button" class="btn-main-order" onclick="goToCheckout()">선택 상품 주문하기</button>
            </div>
        </div>
    </div>
</div>

<script>
/**
 * 1. 실시간 총 금액 및 배송비 계산
 */
function updateTotalPrice() {
    const checkboxes = document.querySelectorAll('.chk:checked:not(:disabled)');
    let totalBase = 0;   // 총 정가 합계
    let totalFinal = 0;  // 총 할인가(실제 결제할 상품가) 합계

    checkboxes.forEach(cb => {
        const unitPrice = parseInt(cb.dataset.price);
        const unitOrigin = parseInt(cb.dataset.origin);
        const quantity = parseInt(cb.dataset.quantity);

        totalBase += (unitOrigin * quantity);
        totalFinal += (unitPrice * quantity);
    });

    // --- 배송비 계산 로직 ---
    let deliveryFee = 0;
    const deliveryDisplay = document.getElementById('deliveryFeeDisplay');
    
    // 선택한 상품이 있고, 실 결제금액이 50,000원 미만인 경우 3,000원 부과
    if (totalFinal > 0 && totalFinal < 50000) {
        deliveryFee = 3000;
    }

    const grandTotal = totalFinal + deliveryFee;

    // 화면 업데이트
    document.getElementById('basePriceDisplay').innerText = totalBase.toLocaleString();
    document.getElementById('discountDisplay').innerText = (totalBase - totalFinal).toLocaleString();
    
    if (deliveryDisplay) {
        if (totalFinal === 0) {
            deliveryDisplay.innerText = "0원";
            deliveryDisplay.style.color = "#333";
        } else if (deliveryFee === 0) {
            deliveryDisplay.innerText = "무료배송";
            deliveryDisplay.style.color = "#3498db"; // 무료일 때 강조색
        } else {
            deliveryDisplay.innerText = deliveryFee.toLocaleString() + "원";
            deliveryDisplay.style.color = "#333";
        }
    }

    document.getElementById('totalPriceDisplay').innerText = grandTotal.toLocaleString();
    
    // 전체 선택 상태 업데이트
    const allEnabled = document.querySelectorAll('.chk:not(:disabled)');
    const selectAllCb = document.getElementById('selectAll');
    if(selectAllCb) {
        selectAllCb.checked = (allEnabled.length > 0 && allEnabled.length === checkboxes.length);
    }
}

/**
 * 2. 전체 선택/해제
 */
function toggleSelectAll() {
    const isChecked = document.getElementById('selectAll').checked;
    document.querySelectorAll('.chk:not(:disabled)').forEach(cb => {
        cb.checked = isChecked;
    });
    updateTotalPrice();
}

/**
 * 3. 수량 변경 (POST 전송)
 */
 function updateQty(cartIdx) {
	    const qtyInput = document.getElementById('qty_' + cartIdx);
	    const qty = parseInt(qtyInput.value);
	    const stock = parseInt(qtyInput.dataset.stock);
	    
	    console.log("전송 데이터 확인:", cartIdx, qty); // 여기에 값이 잘 나오는지 확인!
	    
	    if (isNaN(qty) || qty < 1) {
	        alert("최소 수량은 1개입니다.");
	        qtyInput.value = 1;
	        return;
	    }
	    
	    if (qty > stock) {
	        alert("현재 남은 재고는 " + stock + "개입니다.");
	        qtyInput.value = stock;
	        return;
	    }
	    
	    if(confirm("수량을 " + qty + "개로 변경하시겠습니까?")) {
	        // [수정 포인트] 체크박스의 dataset에 현재 입력한 수량을 동기화
	        // 이렇게 해야 updateTotalPrice()가 정확한 금액을 계산합니다.
	        const checkbox = document.querySelector(`.chk[value="${cartIdx}"]`);
	        if(checkbox) {
	            checkbox.dataset.quantity = qty;
	        }

	        // 합계 금액 함수를 호출하여 화면상 금액을 먼저 변경
	        updateTotalPrice();

	        // 그 후 서버에 저장 (이 함수가 실행되면 결국 페이지는 새로고침됩니다)
	        sendPost('${path}/cart/update.do', {
	            cartIdx: cartIdx,
	            quantity: qty
	            
	            
	        });
	    }
	}

/**
 * 4. 개별 상품 삭제
 */
function deleteCartItem(cartIdx) {
    if (!confirm('장바구니에서 삭제하시겠습니까?')) return;
    
    sendPost('${path}/cart/delete.do', {
        cartIdx: cartIdx
    });
}

/**
 * 5. 주문하기 페이지 이동
 */
function goToCheckout() {
    const checkedItems = document.querySelectorAll('.chk:checked:not(:disabled)');
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

/**
 * [공통] 동적 Form 생성 및 전송 함수
 */
 function sendPost(url, params) {
	    const form = document.createElement('form');
	    form.method = 'POST';
	    form.action = url;
	    
	    // 1. CSRF 토큰 추가 (Security 환경 필수)
	    const csrfParam = "${_csrf.parameterName}";
	    const csrfToken = "${_csrf.token}";
	    
	    if (csrfParam && csrfToken) {
	        const input = document.createElement('input');
	        input.type = 'hidden';
	        input.name = csrfParam;
	        input.value = csrfToken;
	        form.appendChild(input);
	    }

	    // 2. 파라미터 추가 (cartIdx, quantity 등)
	    for (const key in params) {
	        if (params.hasOwnProperty(key)) {
	            const input = document.createElement('input');
	            input.type = 'hidden';
	            input.name = key;
	            input.value = params[key];
	            form.appendChild(input);
	        }
	    }
	    
	    document.body.appendChild(form);
	    form.submit();
	}


window.onload = function() {
    updateTotalPrice();
};
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />