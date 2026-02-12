<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<!DOCTYPE html>
<html>
<head>
    <title>장바구니</title>
    <link rel="stylesheet" href="${path}/resources/css/cart/cartlist.css">
</head>

<body>
<div class="cart-container">
    <div class="cart-title">장바구니</div>

    <table class="cart-table">
        <thead>
            <tr>
                <th width="5%"><input type="checkbox" id="selectAll" onclick="toggleSelectAll()" checked></th>
                <th width="15%">이미지</th>
                <th width="35%">상품정보</th>
                <th width="10%">수량</th>
                <th width="15%">판매가</th>
                <th width="10%">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty cartList}">
                    <c:forEach var="item" items="${cartList}">
                        <tr>
                            <td>
                                <input type="checkbox" class="chk" name="cartItem" value="${item.cartIdx}" 
                                       data-price="${item.price * item.quantity}" onclick="updateTotalPrice()" checked>
                            </td>
                            <td>
                                <a href="${path}/userproduct/userproductdetail.do?productIdx=${item.productIdx}">
                                    <c:choose>
                                        <c:when test="${not empty item.productMainImg}">
                                            <img src="${path}/resources/upload/${item.productMainImg}" class="product-img" 
                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                            <div class="no-img-box" style="display:none;">이미지<br>준비중</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-img-box">이미지<br>준비중</div>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </td>
                            <td style="text-align: left; padding-left: 20px;">
                                <a href="${path}/userproduct/userproductdetail.do?productIdx=${item.productIdx}" class="product-link">
                                    ${item.productName}
                                </a>
                                <div class="option-text">[옵션: ${item.color} / ${item.size}]</div>
                            </td>
                            <td>
                                <form action="${path}/cart/update.do" method="post" style="margin:0;">
                                    <input type="hidden" name="cartIdx" value="${item.cartIdx}">
                                    <input type="number" name="quantity" value="${item.quantity}" min="1" class="qty-input">
                                    <button type="submit" class="btn-update">변경</button>
                                </form>
                            </td>
                            <td style="font-weight: bold;">
                                <fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###"/>원
                            </td>
                            <td>
                                <form action="${path}/cart/delete.do" method="post" onsubmit="return confirm('삭제하시겠습니까?');">
                                    <input type="hidden" name="cartIdx" value="${item.cartIdx}">
                                    <button type="submit" class="btn-delete">삭제</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="6" style="padding: 100px 0; color: #999;">장바구니가 비어있습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <c:if test="${not empty cartList}">
        <div class="total-section">
            <span style="font-size: 18px;">선택 상품 합계 :</span>
            <span id="totalPriceDisplay" class="total-amount">0</span><span class="total-amount">원</span>
        </div>

        <div style="text-align: center;">
            <button type="button" class="btn-main-order" onclick="goToCheckout()">선택 상품 주문하기</button>
        </div>
    </c:if>
</div>

<script>
function updateTotalPrice() {
    const checkboxes = document.querySelectorAll('.chk:checked');
    let total = 0;
    checkboxes.forEach(cb => {
        total += parseInt(cb.getAttribute('data-price'));
    });
    document.getElementById('totalPriceDisplay').innerText = total.toLocaleString();
}

function toggleSelectAll() {
    const isChecked = document.getElementById('selectAll').checked;
    document.querySelectorAll('.chk').forEach(cb => cb.checked = isChecked);
    updateTotalPrice();
}

window.onload = updateTotalPrice;

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
</body>
</html>
<c:import url="/WEB-INF/view/include/bottom.jsp" />