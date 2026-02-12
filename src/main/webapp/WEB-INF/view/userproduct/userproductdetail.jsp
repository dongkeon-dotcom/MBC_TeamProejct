<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:import url="/WEB-INF/view/include/top.jsp" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${product.productName} - 상세보기</title>
<link rel="stylesheet" href="${path}/resources/css/userproduct/userproductdetail.css">


<body align="center">
    <div class="product-detail-wrapper">
        <div class="product-image">
            <c:choose>
                <%-- SQL에서 AS productMainImg로 수정했으므로 그대로 사용 --%>
                <c:when test="${not empty product.productMainImg}">
                    <img src="${path}/resources/images/ProductMainImg/${product.productMainImg}" 
                         alt="${product.productName}">
                </c:when>
                <c:otherwise>
                    <%-- 이미지가 없을 때 보여줄 기본 이미지나 텍스트 --%>
                    <div class="no-image">
                        <img src="${path}/resources/images/no-image.png" alt="이미지 준비중">
                        <p>이미지 준비중</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="product-info">
            <p class="category-path">
                <c:out value="${product.category}" /> &gt; <c:out value="${product.subCategory}" />
            </p>
            
            <h2 class="product-title">${product.productName}</h2>

            <div class="price-container">
                <c:choose>
                    <c:when test="${product.discountRate > 0}">
                        <div class="price-box">
                            <span class="original-price">
                                <fmt:formatNumber value="${product.price}" pattern="#,###"/>원
                            </span>
                            <span class="discount-rate">${product.discountRate}% OFF</span>
                            <div class="discounted-price">
                                <%-- 할인가 계산 로직 --%>
                                <fmt:parseNumber var="dPrice" value="${product.price * (100 - product.discountRate) / 100}" integerOnly="true" />
                                <fmt:formatNumber value="${dPrice}" pattern="#,###"/>원
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="normal-price">
                            <fmt:formatNumber value="${product.price}" pattern="#,###"/>원
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <input type="hidden" id="basePrice" value="${product.price}">
            <input type="hidden" id="discountRate" value="${product.discountRate}">

            <hr class="divider">

            <div class="option-select-box">
                <label for="option">옵션 선택</label>
                <select id="option" onchange="addOptionAuto()">
                    <option value="">-- 색상 / 사이즈 선택 --</option>
                    <c:forEach var="opt" items="${optionList}">
                        <option value="${opt.optionIdx}" 
                                data-color="${opt.color}" 
                                data-size="${opt.size}">
                            ${opt.color} / ${opt.size} <!-- (재고: ${opt.stock}) -->
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="selected-options-container">
                <table id="optionTable">
                    <thead>
                        <tr>
                            <th>선택 옵션</th>
                            <th>수량</th>
                            <th>가격</th>
                            <th>삭제</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- 스크립트(addOptionAuto)가 여기에 <tr>을 추가합니다 --%>
                    </tbody>
                </table>
                
                <div class="total-amount-box">
                    <span>총 합계 금액</span>
                    <span id="totalAmount">0원</span>
                </div>
            </div>

            <div class="action-buttons">
                <form id="buyForm" action="${path}/order/payment.do" method="post" onsubmit="return validateForm()">
                    <input type="hidden" name="productIdx" value="${product.productIdx}">
                    <%-- 옵션 데이터는 JS에서 hidden input으로 자동 추가됨 --%>
                    <button type="submit" class="btn-buy-now">바로 구매하기</button>
                </form>

                <form id="cartForm" action="${path}/cart/add.do" method="post" onsubmit="return validateForm()">
                    <input type="hidden" name="productIdx" value="${product.productIdx}">
                    <button type="submit" class="btn-add-cart">장바구니 담기</button>
                </form>
            </div>
        </div>
    </div>

<!-- /////////////////////////////////////////////////////////////////// -->
    <div class="tab-menu" role="tablist">
        <button class="tab-btn active" onclick="openTab('info', this)">상품정보</button>
        <button class="tab-btn" onclick="openTab('size', this)">사이즈 가이드</button>
        <button class="tab-btn" onclick="openTab('review', this)">리뷰 (${fn:length(reviewList)})</button>
    </div>
<!-- /////////////////////////////////////////////////////////////////// -->
    <div id="info" class="tab-content active">
        <div class="description-text">
            ${product.productDesc}
        </div>
    </div>
<!-- /////////////////////////////////////////////////////////////////// -->
    <div id="size" class="tab-content">
        <c:choose>
            <c:when test="${not empty product.productSizeImg}">
                <img src="${path}/resources/images/ProductSizeImg/${product.productSizeImg}" alt="사이즈 정보">
            </c:when>
            <c:otherwise>
                <p class="empty-msg">등록된 사이즈 정보 이미지가 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>
<!-- /////////////////////////////////////////////////////////////////// -->
    <div id="review" class="tab-content">
        <c:forEach var="r" items="${reviewList}">
            <div class="review-item">
                <div class="review-header">
                    <span class="review-author">${r.userName}</span> 
                    <span class="review-stars">
                        <c:forEach begin="1" end="${r.reviewRating}">★</c:forEach>
                        <c:forEach begin="${r.reviewRating + 1}" end="5">☆</c:forEach>
                    </span>
                </div>
                <p class="review-body">${r.reviewDesc}</p>
            </div>
        </c:forEach>
        <c:if test="${empty reviewList}">
            <p class="empty-msg">첫 리뷰를 작성해주세요!</p>
        </c:if>
    </div>
</body>

</head>
<script>
// 1. 옵션 추가 및 수량 관리 스크립트 (기존 로직 유지 및 보완)
function validateForm() {
    const rows = document.querySelectorAll("#optionTable tbody tr");
    if (rows.length === 0) {
        alert("상품 옵션을 최소 하나 이상 선택해주세요.");
        return false;
    }
    return true;
}

function createHidden(name, value, optionIdx) {
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = name;
    input.value = value;
    if (optionIdx) input.setAttribute("data-option-idx", optionIdx);
    return input;
}

function addOptionAuto() {
    const optionSelect = document.getElementById("option");
    const selected = optionSelect.options[optionSelect.selectedIndex];
    
    if (!selected.value || selected.value === "") return;

    const color = selected.dataset.color;
    const size = selected.dataset.size;
    const optionIdx = selected.value;
    const basePrice = parseInt(document.getElementById("basePrice").value);
    const discountRate = parseInt(document.getElementById("discountRate").value);
    
    // 할인가 계산 (소수점 절삭)
    const discountedPrice = discountRate > 0 ? Math.floor(basePrice * (100 - discountRate) / 100) : basePrice;

    // 중복 체크
    const rows = document.querySelectorAll("#optionTable tbody tr");
    for (let row of rows) {
        if (row.dataset.optionIdx === optionIdx) {
            const qtyInput = row.querySelector("input[type='number']");
            qtyInput.value = parseInt(qtyInput.value) + 1;
            updateRowTotal(row);
            optionSelect.selectedIndex = 0;
            return;
        }
    }

    // 행 추가
    const table = document.getElementById("optionTable").querySelector("tbody");
    const row = document.createElement("tr");
    row.dataset.optionIdx = optionIdx;
    row.dataset.price = discountedPrice;
    row.innerHTML = `
        <td>\${color} / \${size}</td>
        <td><input type="number" value="1" min="1" onchange="updateRowTotal(this.closest('tr'))" style="width:50px;"></td>
        <td class="price-cell">\${discountedPrice.toLocaleString()}원</td>
        <td><button type="button" class="btn-delete" onclick="removeRow(this)">×</button></td>
    `;
    table.appendChild(row);

    // Form에 hidden 필드 동기화
    [document.getElementById("buyForm"), document.getElementById("cartForm")].forEach(form => {
        form.appendChild(createHidden("optionIdxList", optionIdx));
        form.appendChild(createHidden("quantityList", 1, optionIdx));
    });

    updateTotal();
    optionSelect.selectedIndex = 0;
}

function updateRowTotal(row) {
    const qtyInput = row.querySelector("input[type='number']");
    if (qtyInput.value < 1) qtyInput.value = 1;

    const qty = parseInt(qtyInput.value);
    const price = parseInt(row.dataset.price);
    const totalPrice = price * qty;
    
    row.querySelector(".price-cell").innerText = totalPrice.toLocaleString() + "원";

    const optionIdx = row.dataset.optionIdx;
    document.querySelectorAll(`input[data-option-idx='\${optionIdx}']`).forEach(input => {
        if(input.name === "quantityList") input.value = qty;
    });

    updateTotal();
}

function removeRow(btn) {
    const row = btn.closest("tr");
    const optionIdx = row.dataset.optionIdx;
    document.querySelectorAll(`input[data-option-idx='\${optionIdx}']`).forEach(el => el.remove());
    // optionIdxList hidden 필드도 삭제
    document.querySelectorAll(`input[name='optionIdxList'][value='\${optionIdx}']`).forEach(el => el.remove());
    row.remove();
    updateTotal();
}

function updateTotal() {
    let total = 0;
    document.querySelectorAll("#optionTable tbody tr").forEach(row => {
        const qty = parseInt(row.querySelector("input[type='number']").value);
        const price = parseInt(row.dataset.price);
        total += (qty * price);
    });
    document.getElementById("totalAmount").innerText = total.toLocaleString() + "원";
}

// 탭 전환
function openTab(tabId, btn) {
    document.querySelectorAll(".tab-content").forEach(tab => tab.classList.remove("active"));
    document.querySelectorAll(".tab-container button").forEach(tabBtn => {
        tabBtn.classList.remove("active");
        tabBtn.setAttribute("aria-selected", "false");
    });
    document.getElementById(tabId).classList.add("active");
    btn.classList.add("active");
    btn.setAttribute("aria-selected", "true");
}
</script>

</html>
<c:import url="/WEB-INF/view/include/bottom.jsp" />