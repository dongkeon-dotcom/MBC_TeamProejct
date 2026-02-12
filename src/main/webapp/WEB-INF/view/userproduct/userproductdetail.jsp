<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- ✅ 소수점 제거 및 콤마 표시를 위한 태그 라이브러리 추가 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:import url="/WEB-INF/view/include/top.jsp" />

<html>
<head>
<title>${product.productName}상세보기</title>
<link rel="stylesheet"
	href="${path}/resources/css/userproduct/userproductdetail.css">

<script>
//✅ 구매/장바구니 전송 전 검증 함수
function validateForm() {
    const rows = document.querySelectorAll("#optionTable tbody tr");
    if (rows.length === 0) {
        alert("상품 옵션을 최소 하나 이상 선택해주세요.");
        return false; // 전송 중단
    }
    return true; // 전송 승인
}


// 헬퍼 함수: hidden input 생성 (구매/장바구니 폼 전송용)
function createHidden(name, value, optionIdx) {
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = name;
    input.value = value;
    if (optionIdx) input.dataset.optionIdx = optionIdx;
    return input;
}

function addOptionAuto() {
    const optionSelect = document.getElementById("option");
    const selected = optionSelect.options[optionSelect.selectedIndex];
    
    // ✅ 방어 로직: "옵션을 선택해주세요"가 선택되었거나 값이 없으면 중단
    if (!selected.value || selected.value === "옵션을 선택해주세요") {
        return;
    }

    const color = selected.dataset.color;
    const size = selected.dataset.size;
    const optionIdx = selected.value;
    const basePrice = parseInt(document.getElementById("basePrice").value);
    const discountRate = parseInt(document.getElementById("discountRate").value);
    
    // ✅ 소수점 발생 방지 (Math.floor로 절삭)
    const discountedPrice = discountRate > 0 ? Math.floor(basePrice * (100 - discountRate) / 100) : basePrice;

    // 이미 같은 옵션이 추가되어 있으면 수량만 증가
    const rows = document.querySelectorAll("#optionTable tbody tr");
    for (let row of rows) {
        if (row.dataset.optionIdx === optionIdx) {
            const qtyInput = row.querySelector("input[type='number']");
            qtyInput.value = parseInt(qtyInput.value) + 1;
            updateRowTotal(row);
            return;
        }
    }

    // 새 행 추가
    const table = document.getElementById("optionTable").querySelector("tbody");
    const row = document.createElement("tr");
    row.dataset.optionIdx = optionIdx;
    row.dataset.price = discountedPrice;
    row.innerHTML = `
        <td>\${color} / \${size}</td>
        <td><input type="number" value="1" min="1" onchange="updateRowTotal(this.closest('tr'))"></td>
        <td class="price-cell">\${discountedPrice.toLocaleString()}원</td>
        <td><button type="button" class="btn-delete" onclick="removeRow(this)">삭제</button></td>
    `;
    table.appendChild(row);

    // Form에 hidden 필드 추가 (구매/장바구니 양쪽 모두)
    [document.getElementById("buyForm"), document.getElementById("cartForm")].forEach(form => {
        form.appendChild(createHidden("optionIdxList", optionIdx));
        form.appendChild(createHidden("quantityList", 1, optionIdx));
    });

    updateTotal();
    
    // ✅ 선택 후 다시 "옵션을 선택해주세요"로 리셋
    optionSelect.selectedIndex = 0;
}

function updateRowTotal(row) {
    const qtyInput = row.querySelector("input[type='number']");
    if (qtyInput.value < 1) qtyInput.value = 1;

    const qty = parseInt(qtyInput.value);
    const price = parseInt(row.dataset.price);
    const totalPrice = price * qty;
    
    // ✅ 개별 행 가격 콤마 적용
    row.querySelector(".price-cell").innerText = totalPrice.toLocaleString() + "원";

    // hidden 필드(quantityList) 값 업데이트
    const optionIdx = row.dataset.optionIdx;
    document.querySelectorAll(`input[name='quantityList'][data-option-idx='\${optionIdx}']`).forEach(input => {
        input.value = qty;
    });

    updateTotal();
}

function removeRow(btn) {
    const row = btn.closest("tr");
    const optionIdx = row.dataset.optionIdx;

    // 연결된 hidden 필드 제거
    document.querySelectorAll(`input[data-option-idx='\${optionIdx}'], input[name='optionIdxList'][value='\${optionIdx}']`).forEach(el => el.remove());

    row.remove();
    updateTotal();
}

// ✅ 총 결제 금액 업데이트 함수 (콤마 적용)
function updateTotal() {
    let total = 0;
    const rows = document.querySelectorAll("#optionTable tbody tr");
    rows.forEach(row => {
        const qty = parseInt(row.querySelector("input[type='number']").value);
        const price = parseInt(row.dataset.price);
        total += (qty * price);
    });
    document.getElementById("totalAmount").innerText = total.toLocaleString() + "원";
}


function openTab(tabId, btn) {
    // 모든 콘텐츠 숨기기
    document.querySelectorAll(".tab-content").forEach(tab => {
        tab.classList.remove("active");
    });

    // 모든 버튼 비활성화
    document.querySelectorAll(".tab-container [role='tab']").forEach(tabBtn => {
        tabBtn.classList.remove("active");
        tabBtn.setAttribute("aria-selected", "false");
    });

    // 선택된 탭 활성화
    document.getElementById(tabId).classList.add("active");
    btn.classList.add("active");
    btn.setAttribute("aria-selected", "true");
}



</script>
</head>

<body>
	<div class="product-detail">
		<div class="product-image">
			<c:choose>
				<c:when test="${not empty product.productMainImg}">
					<img
						src="${path}/resources/images/ProductMainImg/${product.productMainImg}"
						alt="${product.productName}">
				</c:when>
				<c:otherwise>
					<div class="no-image">이미지 준비중</div>
				</c:otherwise>
			</c:choose>
		</div>

		<div class="product-info">
			<h2>${product.productName}</h2>
			<c:if test="${product.discountRate > 0}">
				<p>
					<span class="original-price"> <s><fmt:formatNumber
								value="${product.price}" pattern="#,###" />원</s>
					</span> <span class="discounted-price"> <%-- ✅ 소수점 절삭 및 콤마 적용 --%>
						<fmt:parseNumber var="discountedPrice"
							value="${product.price * (100 - product.discountRate) / 100}"
							integerOnly="true" /> <fmt:formatNumber
							value="${discountedPrice}" pattern="#,###" />원
					</span> <span class="product-discount">(${product.discountRate}%
						할인)</span>
				</p>
			</c:if>
			<c:if test="${product.discountRate == 0}">
				<p class="product-price">
					<fmt:formatNumber value="${product.price}" pattern="#,###" />
					원
				</p>
			</c:if>

			<input type="hidden" id="basePrice" value="${product.price}">
			<input type="hidden" id="discountRate"
				value="${product.discountRate}">

			<div class="option-select">
				<label for="option">옵션 선택</label> <select id="option"
					onchange="addOptionAuto()">
					<option value="">옵션을 선택해주세요</option>
					<c:forEach var="opt" items="${optionList}">
						<option value="${opt.optionIdx}" data-color="${opt.color}"
							data-size="${opt.size}">${opt.color} / ${opt.size}</option>
					</c:forEach>
				</select>
			</div>

			<div class="selected-options">
				<h3>선택된 상품</h3>
				<table id="optionTable">
					<thead>
						<tr>
							<th>옵션</th>
							<th>수량</th>
							<th>가격</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>

				<div class="total-box">
					총 결제 금액: <span id="totalAmount">0원</span>
				</div>
			</div>

			<div class="button-row">
				>
				<form id="buyForm" action="${path}/order/payment.do" method="post"
					onsubmit="return validateForm()">
					<input type="hidden" name="productIdx"
						value="${product.productIdx}">
					<button type="submit" class="btn-buy">구매하기</button>
				</form>


				<form id="cartForm" action="${path}/cart/add.do" method="post"
					onsubmit="return validateForm()">
					<input type="hidden" name="productIdx"
						value="${product.productIdx}">
					<button type="submit" class="btn-cart">장바구니 담기</button>
				</form>
			</div>
		</div>
	</div>




	<!-- 탭 영역 -->
	<div class="tab-container" role="tablist">
		<button role="tab" aria-selected="true" aria-controls="info"
			id="tab-info" onclick="openTab('info', this)">정보</button>
		<button role="tab" aria-selected="false" aria-controls="size"
			id="tab-size" onclick="openTab('size', this)">사이즈</button>
		<button role="tab" aria-selected="false" aria-controls="review"
			id="tab-review" onclick="openTab('review', this)">리뷰</button>
	</div>

	<div id="info" class="tab-content active" role="tabpanel"
		aria-labelledby="tab-info">
		<p class="product-desc">${product.productDesc}</p>
	</div>

	<div id="size" class="tab-content" role="tabpanel"
		aria-labelledby="tab-size">
		<h3>사이즈 정보</h3>
		<c:if test="${not empty product.productSizeImg}">
			<img src="${path}/resources/images/${product.productSizeImg}"
				alt="사이즈 정보">
		</c:if>
	</div>

	<div id="review" class="tab-content" role="tabpanel"
		aria-labelledby="tab-review">
		<h3>리뷰 (${fn:length(reviewList)})</h3>
		<c:if test="${empty reviewList}">
			<p>등록된 리뷰가 없습니다.</p>
		</c:if>
		<c:forEach var="r" items="${reviewList}">
			<div class="review">
				<p class="review-user">
					<strong>${r.userName}</strong>
				</p>
				<p class="review-content">${r.reviewDesc}</p>
				<p class="review-rating">
					<c:forEach begin="1" end="5" var="i">
						<c:choose>
							<c:when test="${i <= r.reviewRating}">★</c:when>
							<c:otherwise>☆</c:otherwise>
						</c:choose>
					</c:forEach>
				</p>
			</div>
		</c:forEach>
	</div>


</body>
</html>
<c:import url="/WEB-INF/view/include/bottom.jsp" />