<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:import url="/WEB-INF/view/include/top.jsp" />
<link rel="stylesheet" href="${path}/resources/css/userproduct/userproductdetail.css">
<body align="center">
    <div class="product-detail-wrapper">
       <div class="product-image">
    <div class="main-img-container" style="position: relative; overflow: hidden;">
        <%-- 좌우 화살표 버튼 --%>
        <button type="button" class="btn-prev" onclick="changeSlide(-1)" style="position: absolute; left: 10px; top: 50%; transform: translateY(-50%); z-index: 10;">〈</button>
        
        <c:choose>
            <c:when test="${not empty product.productMainImg}">
                <%-- id="currentMainImg" 추가 --%>
                <img id="currentMainImg" src="${path}/resources/images/ProductMainImg/${product.productMainImg}" 
                     alt="${product.productName}" style="max-width: 100%; height: auto; display: block;">
            </c:when>
            <c:otherwise>
                <img src="${path}/resources/images/no-image.png" alt="이미지 준비중">
            </c:otherwise>
        </c:choose>

        <button type="button" class="btn-next" onclick="changeSlide(1)" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); z-index: 10;">〉</button>
    </div>

    <%-- 썸네일 리스트 (클릭 시 메인 이미지 변경) --%>
    <div class="sub-images" style="margin-top: 20px; display: flex; gap: 5px; overflow-x: auto;">
        <%-- 메인 이미지도 첫 번째 썸네일로 추가 (클릭해서 돌아올 수 있게) --%>
        <img src="${path}/resources/images/ProductMainImg/${product.productMainImg}" 
             class="thumb active" onclick="setMainImg(this.src)" style="width: 80px; height: 80px; cursor: pointer; border: 2px solid #333;">
        
        <c:forEach var="img" items="${subImgList}">
            <img src="${path}/resources/images/ProductImg/${img.productImg}" 
                 class="thumb" onclick="setMainImg(this.src)" style="width: 80px; height: 80px; cursor: pointer; border: 1px solid #eee;">
        </c:forEach>
    </div>
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
                            ${opt.color} / ${opt.size}
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
                    <tbody></tbody>
                </table>
                <div class="total-amount-box">
                    <span>총 합계 금액</span>
                    <span id="totalAmount">0원</span>
                </div>
            </div>

            <div class="action-buttons">
                <form id="buyForm" action="${path}/order/payment.do" method="post" onsubmit="return validateForm()">
                    <input type="hidden" name="productIdx" value="${product.productIdx}">
                    <button type="submit" class="btn-buy-now">바로 구매하기</button>
                </form>
                <form id="cartForm" action="${path}/cart/add.do" method="post" onsubmit="return validateForm()">
                    <input type="hidden" name="productIdx" value="${product.productIdx}">
                    <button type="submit" class="btn-add-cart">장바구니 담기</button>
                </form>
            </div>
        </div>
    </div>

    <div class="tab-menu">
        <button class="tab-btn active" onclick="openTab('info', this)">상품정보</button>
        <button class="tab-btn" onclick="openTab('size', this)">사이즈 가이드</button>
        <button class="tab-btn" onclick="openTab('review', this)">리뷰 (${fn:length(reviewList)})</button>
    </div>

    <%-- 탭 1: 상세 설명 및 설명 이미지 --%>
    <div id="info" class="tab-content active">
        <div class="description-text">${product.productDesc}</div>
        <div class="desc-images">
            <c:forEach var="descImg" items="${descImgList}">
                <img src="${path}/resources/images/ProductDescImg/${descImg.productDescImg}" 
                     style="max-width: 100%; display: block; margin: 10px auto;">
            </c:forEach>
        </div>
    </div>

    <%-- 탭 2: 사이즈 정보 이미지 --%>
    <div id="size" class="tab-content">
        <c:choose>
            <c:when test="${not empty product.productSizeImg}">
                <img src="${path}/resources/images/ProductSizeImg/${product.productSizeImg}" alt="사이즈 정보" style="max-width: 100%;">
            </c:when>
            <c:otherwise>
                <p class="empty-msg">등록된 사이즈 정보 이미지가 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- 탭 3: 리뷰 --%>
    <div id="review" class="tab-content">
        <c:forEach var="r" items="${reviewList}">
            <div class="review-item">
                <div class="review-header">
                    <span class="review-author">${r.userName}</span> 
                    <span class="review-stars">
                        <c:forEach begin="1" end="${r.rating}">★</c:forEach>
                        <c:forEach begin="${r.rating + 1}" end="5">☆</c:forEach>
                    </span>
                </div>
                <p class="review-body">${r.review}</p>
            </div>
        </c:forEach>
        <c:if test="${empty reviewList}">
            <p class="empty-msg">첫 리뷰를 작성해주세요!</p>
        </c:if>
    </div>
</body>
<!-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
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


// 이미지 슬라이드 스크립트 



// 이미지 경로들을 배열로 수집
let images = [];
const mainImgElement = document.getElementById("currentMainImg");

// 페이지 로드 시 이미지 배열 초기화
window.onload = function() {
    const thumbs = document.querySelectorAll(".sub-images img");
    thumbs.forEach(img => images.push(img.src));
};

let currentIndex = 0;

// 1. 직접 클릭해서 변경
function setMainImg(src) {
    mainImgElement.src = src;
    currentIndex = images.indexOf(src);
    updateThumbStyle();
}

// 2. 좌우 버튼으로 변경
function changeSlide(direction) {
    currentIndex += direction;
    
    // 처음과 끝 순환 처리
    if (currentIndex < 0) currentIndex = images.length - 1;
    if (currentIndex >= images.length) currentIndex = 0;
    
    mainImgElement.src = images[currentIndex];
    updateThumbStyle();
}

// 썸네일 강조 표시 업데이트
function updateThumbStyle() {
    const thumbs = document.querySelectorAll(".sub-images img");
    thumbs.forEach((img, index) => {
        if(index === currentIndex) {
            img.style.border = "2px solid #333";
        } else {
            img.style.border = "1px solid #eee";
        }
    });
} 
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />