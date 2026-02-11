<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<html>
<head>
<title>${product.productName} 상세보기</title>
<link rel="stylesheet" href="${path}/resources/css/userproduct/userproductdetail.css">

<script>
function addOptionAuto() {
    const optionSelect = document.getElementById("option");
    const selected = optionSelect.options[optionSelect.selectedIndex];
    const color = selected.dataset.color;
    const size = selected.dataset.size;
    const optionIdx = selected.value;
    const basePrice = parseInt(document.getElementById("basePrice").value);
    const discountRate = parseInt(document.getElementById("discountRate").value);
    const discountedPrice = discountRate > 0 ? Math.floor(basePrice * (100 - discountRate) / 100) : basePrice;


    // 이미 같은 옵션이 추가되어 있으면 수량만 증가
    const rows = document.querySelectorAll("#optionTable tbody tr");
    for (let row of rows) {
        if (row.dataset.optionIdx === optionIdx) {
            const qtyInput = row.querySelector("input[type='number']");
            qtyInput.value = parseInt(qtyInput.value) + 1;
            updateRowTotal(row);   // ✅ 인자 제거
            //updateTotal();
            return;
        }
    }

    // 새 행 추가
    const table = document.getElementById("optionTable").querySelector("tbody");
    const row = document.createElement("tr");
    row.dataset.optionIdx = optionIdx;
    row.dataset.price = discountedPrice;
    row.innerHTML = `
        <td> \${color} / \${size} </td>
        <td><input type="number" value="1" min="1" onchange="updateRowTotal(this.closest('tr'))"></td>
        <td class="price-cell">\${discountedPrice}원</td>
        <td><button type="button" onclick="removeRow(this)">삭제</button></td>
    `;
    table.appendChild(row);

    // hidden 필드 추가
    const buyForm = document.getElementById("buyForm");
    //const buyQty = createHidden("quantityList", 1);
    //buyQty.dataset.optionIdx = optionIdx;
    //buyForm.appendChild(createHidden("optionIdxList", optionIdx));
    //buyForm.appendChild(buyQty);

    const cartForm = document.getElementById("cartForm");
    //const cartQty = createHidden("quantityList", 1);
    //cartQty.dataset.optionIdx = optionIdx;
    //cartForm.appendChild(createHidden("optionIdxList", optionIdx));
    //cartForm.appendChild(cartQty);

}

function updateRowTotal(row) {
    const qty = parseInt(row.querySelector("input[type='number']").value);
    const price = parseInt(row.dataset.price);
    const totalPrice = price * qty;
    row.querySelector(".price-cell").innerText = totalPrice + "원";

    // hidden 필드 값도 업데이트
    const optionIdx = row.dataset.optionIdx;
    document.querySelectorAll("input[name='quantityList']").forEach(input => {
        if (input.dataset.optionIdx === optionIdx) {
            input.value = qty;
        }
    });

}

function removeRow(btn) {
    const row = btn.closest("tr");
    const optionIdx = row.dataset.optionIdx;

    // ✅ hidden 필드도 제거
    document.querySelectorAll("input[name='quantityList']").forEach(input => {
        if (input.dataset.optionIdx === optionIdx) {
            input.remove();
        }
    });
    document.querySelectorAll("input[name='optionIdxList']").forEach(input => {
        if (input.value === optionIdx) {
            input.remove();
        }
    });

    row.remove();
}



</script>
</head>

<body>
<div class="product-detail">
    <!-- 상품 이미지 -->
    <div class="product-image">
        <c:choose>
            <c:when test="${not empty product.productMainImg}">
                <img src="${path}/resources/images/ProductMainImg/${product.productMainImg}" alt="${product.productName}">
            </c:when>
            <c:otherwise>
                <div class="no-image">이미지 준비중</div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 상품 설명 -->
    <div class="product-info">
        <h2>${product.productName}</h2>
        <c:if test="${product.discountRate > 0}">
            <p>
                <span class="original-price"><s>${product.price}원</s></span>
                <span class="discounted-price">
                    ${product.price * (100 - product.discountRate) / 100}원
                </span>
                <span class="product-discount">(${product.discountRate}% 할인)</span>
            </p>
        </c:if>
        <c:if test="${product.discountRate == 0}">
            <p class="product-price">${product.price}원</p>
        </c:if>

        <!-- 가격 계산용 hidden -->
        <input type="hidden" id="basePrice" value="${product.price}">
        <input type="hidden" id="discountRate" value="${product.discountRate}">

			<!-- 옵션 선택 (자동 추가) -->
			<div class="option-select">
				<label for="option">옵션 선택</label> <select id="option" onchange="addOptionAuto()">
					<c:forEach var="opt" items="${optionList}" >
							<option value="${opt.optionIdx}" 
							        data-color="${opt.color}" 
							        data-size="${opt.size}">
							    ${opt.color} / ${opt.size}
							</option>
							
					</c:forEach>
				</select>
			</div>

			<!-- 선택된 상품 테이블 -->
        <div class="selected-options">
            <h3>선택된 상품</h3>
            <table id="optionTable">
                <thead>
				    <tr>
				        <th>옵션</th>   <!-- 색상/사이즈 합쳐서 옵션으로 표시 -->
				        <th>수량</th>
				        <th>가격</th>
				        <th>삭제</th>
				    </tr>
				</thead>

                <tbody>
                    <!-- JS로 행 추가 -->
                </tbody>
            </table>

            <!-- 총 결제 금액 -->
            <div class="total-box">
                총 결제 금액: <span id="totalAmount">0원</span>
            </div>
        </div>

        <!-- 구매/장바구니 버튼 나란히 -->
        <div class="button-row">
            <form id="buyForm" action="${path}/order/payment.do" method="post">
                <input type="hidden" name="productIdx" value="${product.productIdx}">
                <button type="submit" class="btn-buy">구매하기</button>
            </form>

            <form id="cartForm" action="${path}/cart/add.do" method="post">
                <input type="hidden" name="productIdx" value="${product.productIdx}">
                <button type="submit" class="btn-cart">장바구니 담기</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>

<c:import url="/WEB-INF/view/include/bottom.jsp" />
