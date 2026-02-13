<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:import url="/WEB-INF/view/include/top.jsp" />

<link rel="stylesheet" href="${path}/resources/css/userproduct/userproductdetail.css">

<div class="main-content-area">
    <div class="product-detail-wrapper">
        
        <div class="product-top-section">
            <div class="product-image-zone">
                <div class="main-img-container">
                    <button type="button" class="btn-prev" onclick="changeSlide(-1)">〈</button>
                    <c:choose>
                        <c:when test="${not empty product.productMainImg}">
                            <img id="currentMainImg" src="${path}/resources/images/ProductMainImg/${product.productMainImg}" alt="${product.productName}">
                        </c:when>
                        <c:otherwise>
                            <img src="${path}/resources/images/no-image.png" alt="이미지 준비중">
                        </c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-next" onclick="changeSlide(1)">〉</button>
                </div>

                <div class="sub-images">
                    <img src="${path}/resources/images/ProductMainImg/${product.productMainImg}" 
                         class="thumb active" onclick="setMainImg(this.src)">
                    <c:forEach var="img" items="${subImgList}">
                        <img src="${path}/resources/images/ProductImg/${img.productImg}" 
                             class="thumb" onclick="setMainImg(this.src)">
                    </c:forEach>
                </div>
            </div>

            <div class="product-info-zone">
                <p class="category-path">${product.category} &gt; ${product.subCategory}</p>
                <h2 class="product-title">${product.productName}</h2>

                <div class="price-container">
                    <c:choose>
                        <c:when test="${product.discountRate > 0}">
                            <span class="original-price"><fmt:formatNumber value="${product.price}" pattern="#,###"/>원</span>
                            <span class="discount-rate">${product.discountRate}% OFF</span>
                            <div class="discounted-price">
                                <fmt:parseNumber var="dPrice" value="${product.price * (100 - product.discountRate) / 100}" integerOnly="true" />
                                <fmt:formatNumber value="${dPrice}" pattern="#,###"/>원
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="normal-price"><fmt:formatNumber value="${product.price}" pattern="#,###"/>원</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <input type="hidden" id="basePrice" value="${product.price}">
                <input type="hidden" id="discountRate" value="${product.discountRate}">

                <hr class="divider">

                <div class="option-select-box">
                    <label>옵션 선택</label>
                    <select id="option" onchange="addOptionAuto()">
                        <option value="">-- 색상 / 사이즈 선택 --</option>
                        <c:forEach var="opt" items="${optionList}">
                            <option value="${opt.optionIdx}" data-color="${opt.color}" data-size="${opt.size}">
                                ${opt.color} / ${opt.size}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="selected-options-container">
                    <table id="optionTable">
                        <thead>
                            <tr>
                                <th>옵션</th>
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

        <div id="info" class="tab-content active">
            <div class="description-text">${product.productDesc}</div>
            <c:forEach var="descImg" items="${descImgList}">
                <img src="${path}/resources/images/ProductDescImg/${descImg.productDescImg}" style="max-width: 100%; display: block; margin: 0 auto 20px;">
            </c:forEach>
        </div>

        <div id="size" class="tab-content">
            <c:choose>
                <c:when test="${not empty product.productSizeImg}">
                    <img src="${path}/resources/images/ProductSizeImg/${product.productSizeImg}" style="max-width: 100%; display: block; margin: 0 auto;">
                </c:when>
                <c:otherwise><p class="empty-msg">등록된 사이즈 정보 이미지가 없습니다.</p></c:otherwise>
            </c:choose>
        </div>

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
            <c:if test="${empty reviewList}"><p class="empty-msg">등록된 리뷰가 없습니다.</p></c:if>
        </div>
    </div> </div> <script>
// 1. 유효성 검사 및 폼 전송
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
    if (optionIdx) input.dataset.optionIdx = optionIdx;
    return input;
}

// 2. 옵션 자동 추가
function addOptionAuto() {
    const optionSelect = document.getElementById("option");
    const selected = optionSelect.options[optionSelect.selectedIndex];
    
    if (!selected.value) return;

    const color = selected.dataset.color;
    const size = selected.dataset.size;
    const optionIdx = selected.value;
    const basePrice = parseInt(document.getElementById("basePrice").value);
    const discountRate = parseInt(document.getElementById("discountRate").value);
    const discountedPrice = discountRate > 0 ? Math.floor(basePrice * (100 - discountRate) / 100) : basePrice;

    const rows = document.querySelectorAll("#optionTable tbody tr");
    for (let row of rows) {
        if (row.dataset.optionIdx === optionIdx) {
            const qtyInput = row.querySelector("input[type='number']");
            qtyInput.value = parseInt(qtyInput.value) + 1;
            updateRowTotal(row);
            return;
        }
    }

    const table = document.getElementById("optionTable").querySelector("tbody");
    const row = document.createElement("tr");
    row.dataset.optionIdx = optionIdx;
    row.dataset.price = discountedPrice;
    row.innerHTML = `
        <td>\${color} / \${size}</td>
        <td><input type="number" value="1" min="1" onchange="updateRowTotal(this.closest('tr'))"></td>
        <td class="price-cell">\${discountedPrice.toLocaleString()}원</td>
        <td><button type="button" class="btn-delete" onclick="removeRow(this)">×</button></td>
    `;
    table.appendChild(row);

    [document.getElementById("buyForm"), document.getElementById("cartForm")].forEach(form => {
        form.appendChild(createHidden("optionIdxList", optionIdx));
        form.appendChild(createHidden("quantityList", 1, optionIdx));
    });

    updateTotal();
    optionSelect.selectedIndex = 0;
}

function updateRowTotal(row) {
    const qty = parseInt(row.querySelector("input[type='number']").value) || 1;
    const price = parseInt(row.dataset.price);
    row.querySelector(".price-cell").innerText = (price * qty).toLocaleString() + "원";
    const optionIdx = row.dataset.optionIdx;
    document.querySelectorAll(`input[name='quantityList'][data-option-idx='\${optionIdx}']`).forEach(input => { input.value = qty; });
    updateTotal();
}

function removeRow(btn) {
    const row = btn.closest("tr");
    const optionIdx = row.dataset.optionIdx;
    document.querySelectorAll(`input[data-option-idx='\${optionIdx}'], input[name='optionIdxList'][value='\${optionIdx}']`).forEach(el => el.remove());
    row.remove();
    updateTotal();
}

function updateTotal() {
    let total = 0;
    document.querySelectorAll("#optionTable tbody tr").forEach(row => {
        const qty = parseInt(row.querySelector("input[type='number']").value) || 0;
        total += (qty * parseInt(row.dataset.price));
    });
    document.getElementById("totalAmount").innerText = total.toLocaleString() + "원";
}

// 3. 탭 전환
function openTab(tabId, btn) {
    document.querySelectorAll(".tab-content").forEach(tab => tab.classList.remove("active"));
    document.querySelectorAll(".tab-btn").forEach(tabBtn => tabBtn.classList.remove("active"));
    document.getElementById(tabId).classList.add("active");
    btn.classList.add("active");
}

// 4. 이미지 슬라이드
let images = [];
const mainImgElement = document.getElementById("currentMainImg");
let currentIndex = 0;

window.addEventListener('load', function() {
    const thumbs = document.querySelectorAll(".sub-images img");
    thumbs.forEach(img => images.push(img.src));
});

function setMainImg(src) {
    mainImgElement.src = src;
    currentIndex = images.indexOf(src);
    updateThumbStyle();
}

function changeSlide(direction) {
    if(images.length <= 1) return;
    currentIndex += direction;
    if (currentIndex < 0) currentIndex = images.length - 1;
    if (currentIndex >= images.length) currentIndex = 0;
    mainImgElement.src = images[currentIndex];
    updateThumbStyle();
}

function updateThumbStyle() {
    const thumbs = document.querySelectorAll(".sub-images img");
    thumbs.forEach((img, index) => {
        img.style.borderColor = (index === currentIndex) ? "#333" : "transparent";
    });
}
function openTab(tabId, btn) {
    // 1. 모든 콘텐츠 숨기기
    document.querySelectorAll(".tab-content").forEach(tab => {
        tab.classList.remove("active");
    });

    // 2. 모든 버튼 비활성화
    document.querySelectorAll(".tab-btn").forEach(tabBtn => {
        tabBtn.classList.remove("active");
    });

    // 3. 선택된 탭 활성화
    const activeTab = document.getElementById(tabId);
    activeTab.classList.add("active");
    btn.classList.add("active");

    // 4. 해당 탭 위치로 스크롤 이동 (헤더+탭 높이 고려)
    const headerHeight = 60; // 상단 헤더 높이
    const tabMenuHeight = 50; // 탭 메뉴 높이
    const offset = headerHeight + tabMenuHeight; // 총 가려지는 높이

    const elementPosition = activeTab.getBoundingClientRect().top;
    const offsetPosition = elementPosition + window.pageYOffset - offset;

    window.scrollTo({
        top: offsetPosition,
        behavior: "smooth" // 부드럽게 이동
        
        	document.getElementById(tabId).scrollIntoView({ behavior: 'smooth', block: 'start' });
    });
}


</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />