<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:import url="/WEB-INF/view/include/top.jsp" />

<!DOCTYPE html>
<html>
<head>
    <title>장바구니 - Gemini Shop</title>
    <link rel="stylesheet" href="${path}/resources/css/cart/cartlist.css">
    <style>
        /* 품절 및 디자인 보정 */
        .sold-out-row { background-color: #fcfcfc !important; color: #bbb !important; }
        .gray-img { filter: grayscale(100%); opacity: 0.4; }
        .sold-out-badge {
            color: #ff4d4f; font-weight: bold; font-size: 11px;
            border: 1px solid #ff4d4f; padding: 2px 5px;
            border-radius: 3px; margin-left: 8px; vertical-align: middle;
        }
        .product-img { width: 80px; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid #eee; }
        .no-img-box { 
            width: 80px; height: 80px; background: #f0f0f0; color: #999; 
            display: flex; align-items: center; justify-content: center; 
            font-size: 11px; text-align: center; border-radius: 4px;
        }
        .qty-input { width: 45px; padding: 5px; text-align: center; border: 1px solid #ddd; border-radius: 4px; }
        .btn-update { padding: 5px 8px; font-size: 12px; background: #f4f4f4; border: 1px solid #ccc; cursor: pointer; border-radius: 4px; }
        .btn-delete { padding: 5px 8px; font-size: 12px; background: #fff; color: #e60023; border: 1px solid #e60023; cursor: pointer; border-radius: 4px; }
        .total-section { margin-top: 30px; padding: 20px; background: #f9f9f9; text-align: right; border-top: 2px solid #333; }
        .total-amount { font-size: 24px; font-weight: 800; color: #e60023; }
        .btn-main-order { margin-top: 20px; padding: 18px 60px; background: #333; color: #fff; border: none; font-size: 18px; font-weight: bold; cursor: pointer; border-radius: 6px; }
    </style>
</head>

<body>
<div class="cart-container" style="max-width: 1100px; margin: 50px auto; padding: 0 20px;">
    <div class="cart-title" style="font-size: 28px; font-weight: bold; margin-bottom: 30px; text-align: center;">장바구니</div>

    <table class="cart-table" style="width: 100%; border-collapse: collapse;">
        <thead>
            <tr style="border-bottom: 2px solid #333; background: #fbfbfb;">
                <th width="5%"><input type="checkbox" id="selectAll" onclick="toggleSelectAll()" checked></th>
                <th width="12%">이미지</th>
                <th width="38%">상품정보</th>
                <th width="12%">수량</th>
                <th width="18%">판매가</th>
                <th width="15%">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty cartList}">
                    <c:forEach var="item" items="${cartList}">
                        <tr class="${item.stock <= 0 ? 'sold-out-row' : ''}" style="border-bottom: 1px solid #eee; text-align: center;">
                            <td style="padding: 15px 0;">
                                <c:choose>
                                    <c:when test="${item.stock > 0}">
                                        <input type="checkbox" class="chk" name="cartItem" value="${item.cartIdx}" 
                                               data-price="${item.price * item.quantity}" onclick="updateTotalPrice()" checked>
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
                                            <%-- ✅ 경로 수정: ProductMainImg 사용 --%>
                                            <img src="${path}/resources/images/ProductMainImg/${item.productMainImg}" 
                                                 class="product-img ${item.stock <= 0 ? 'gray-img' : ''}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-img-box">이미지 준비중</div>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </td>
                            <td style="text-align: left; padding-left: 20px;">
                                <div style="margin-bottom: 5px;">
                                    <a href="${path}/userproduct/userproductdetail.do?productIdx=${item.productIdx}" 
                                       style="text-decoration: none; color: ${item.stock <= 0 ? '#bbb' : '#333'}; font-weight: bold;">
                                        ${item.productName}
                                    </a>
                                    <c:if test="${item.stock <= 0}">
                                        <span class="sold-out-badge">품절</span>
                                    </c:if>
                                </div>
                                <div style="font-size: 13px; color: ${item.stock <= 0 ? '#ddd' : '#888'};">
                                    [옵션: ${item.color} / ${item.size}]
                                </div>
                            </td>
                            <td>
                                <form action="${path}/cart/update.do" method="post" style="display: flex; justify-content: center; gap: 5px; align-items: center;">
                                    <input type="hidden" name="cartIdx" value="${item.cartIdx}">
                                    <input type="number" name="quantity" value="${item.quantity}" min="1" class="qty-input" 
                                           ${item.stock <= 0 ? 'disabled' : ''}>
                                    <c:if test="${item.stock > 0}">
                                        <button type="submit" class="btn-update">변경</button>
                                    </c:if>
                                </form>
                            </td>
                            <td style="font-weight: bold;">
                                <fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###"/>원
                            </td>
                            <td>
                                <form action="${path}/cart/delete.do" method="post" onsubmit="return confirm('장바구니에서 삭제하시겠습니까?');">
                                    <input type="hidden" name="cartIdx" value="${item.cartIdx}">
                                    <button type="submit" class="btn-delete">삭제</button>
                                </form>
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

    <c:if test="${not empty cartList}">
        <div class="total-section">
            <span style="font-size: 16px; color: #666; margin-right: 15px;">선택 상품 합계</span>
            <span id="totalPriceDisplay" class="total-amount">0</span><span class="total-amount">원</span>
        </div>

        <div style="text-align: center; margin-top: 40px; margin-bottom: 100px;">
            <button type="button" class="btn-main-order" onclick="goToCheckout()">선택 상품 주문하기</button>
        </div>
    </c:if>
</div>

<script>
// 1. 체크된 상품들만 합산하여 화면에 표시
function updateTotalPrice() {
    const checkboxes = document.querySelectorAll('.chk:checked:not(:disabled)');
    let total = 0;
    checkboxes.forEach(cb => {
        total += parseInt(cb.getAttribute('data-price'));
    });
    
    const display = document.getElementById('totalPriceDisplay');
    if (display) {
        display.innerText = total.toLocaleString();
    }

    // 전체 선택 체크박스 상태 업데이트
    const allEnabled = document.querySelectorAll('.chk:not(:disabled)');
    const allChecked = document.querySelectorAll('.chk:checked:not(:disabled)');
    document.getElementById('selectAll').checked = (allEnabled.length > 0 && allEnabled.length === allChecked.length);
}

// 2. 전체 선택/해제 (품절 상품 제외)
function toggleSelectAll() {
    const isChecked = document.getElementById('selectAll').checked;
    document.querySelectorAll('.chk:not(:disabled)').forEach(cb => {
        cb.checked = isChecked;
    });
    updateTotalPrice();
}

// 3. 주문 페이지로 데이터 전송
function goToCheckout() {
    const checkedItems = document.querySelectorAll('.chk:checked:not(:disabled)');
    
    if (checkedItems.length === 0) {
        alert('주문하실 상품을 선택해주세요. (품절 상품은 제외됩니다.)');
        return;
    }

    // 동적 폼 생성 및 전송
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

// 초기 로드 시 실행
window.onload = function() {
    updateTotalPrice();
};
</script>
</body>
</html>

<c:import url="/WEB-INF/view/include/bottom.jsp" />