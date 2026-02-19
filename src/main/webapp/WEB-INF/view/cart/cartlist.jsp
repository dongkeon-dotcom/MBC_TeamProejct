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
                                        <input type="number" id="qty_${item.cartIdx}" value="${item.quantity}" 
                                               min="1" class="qty-input" ${item.stock <= 0 ? 'disabled' : ''}>
                                        <button type="button" class="btn-update" onclick="updateQty(${item.cartIdx})">변경</button>
                                    </div>
                                </td>
                                <td class="price-cell">
                                    <%-- 역산 로직 제거: DB에서 가져온 originPrice(정가)를 직접 사용 --%>
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
                    <span class="total-value">무료배송</span>
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
 * 1. 실시간 총 금액 계산
 * 파싱이나 역산 없이 data 속성에 저장된 순수 숫자만 사용하여 계산함
 */
function updateTotalPrice() {
    const checkboxes = document.querySelectorAll('.chk:checked:not(:disabled)');
    let totalBase = 0;   // 총 정가 합계
    let totalFinal = 0;  // 총 할인가 합계

    checkboxes.forEach(cb => {
        const unitPrice = parseInt(cb.dataset.price);     // 할인가 단가
        const unitOrigin = parseInt(cb.dataset.origin);   // 정가 단가
        const quantity = parseInt(cb.dataset.quantity);

        totalBase += (unitOrigin * quantity);
        totalFinal += (unitPrice * quantity);
    });

    document.getElementById('basePriceDisplay').innerText = totalBase.toLocaleString();
    document.getElementById('discountDisplay').innerText = (totalBase - totalFinal).toLocaleString();
    document.getElementById('totalPriceDisplay').innerText = totalFinal.toLocaleString();
    
    // 전체 선택 체크박스 상태 업데이트
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
    const qty = document.getElementById('qty_' + cartIdx).value;
    if (qty < 1) {
        alert("최소 수량은 1개입니다.");
        return;
    }
    
    // 유틸리티 함수(sendPost)를 사용하여 폼 전송
    sendPost('${path}/cart/update.do', {
        cartIdx: cartIdx,
        quantity: qty
    });
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

// 페이지 로드 시 초기 합계 계산
window.onload = function() {
    updateTotalPrice();
};
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />