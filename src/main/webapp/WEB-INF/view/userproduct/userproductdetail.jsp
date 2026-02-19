<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:import url="/WEB-INF/view/include/top.jsp" />
<link rel="stylesheet" href="${path}/resources/css/userproduct/userproductdetail.css">

<div class="main-content-area">
    <div class="product-detail-wrapper">
        <div class="product-top-section">
            <%-- [기능] 이미지 슬라이드 존 --%>
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
                    <img src="${path}/resources/images/ProductMainImg/${product.productMainImg}" class="thumb active" onclick="setMainImg(this.src)">
                    <c:forEach var="img" items="${subImgList}">
                        <img src="${path}/resources/images/ProductImg/${img.productImg}" class="thumb" onclick="setMainImg(this.src)">
                    </c:forEach>
                </div>
            </div>

            <%-- [기능] 상품 정보 및 가격 존 --%>
            <div class="product-info-zone">
                <p class="category-path">${product.category} &gt; ${product.subCategory}</p>
                <h2 class="product-title">${product.productName}</h2>
                
                <div class="price-container">
                    <c:choose>
                        <%-- 할인이 있는 경우: 원가(취소선) + 할인율 + 절삭된 할인가 --%>
                        <c:when test="${product.discountRate > 0}">
                            <span class="original-price"><fmt:formatNumber value="${product.price}" pattern="#,###"/>원</span>
                            <span class="discount-rate">${product.discountRate}% OFF</span>
                            <div class="discounted-price">
                                <%-- VO에서 이미 절삭 계산된 discountedPrice 사용 --%>
                                <fmt:formatNumber value="${product.discountedPrice}" pattern="#,###"/>원
                            </div>
                        </c:when>
                        <%-- 할인이 없는 경우: 절삭된 정가만 표시 --%>
                        <c:otherwise>
                            <div class="normal-price">
                                <fmt:formatNumber value="${product.discountedPrice}" pattern="#,###"/>원
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- 자바스크립트 계산용 Hidden 값 (VO의 절삭된 단가를 기준가로 사용) --%>
                <input type="hidden" id="finalUnitPrice" value="${product.discountedPrice}">
                <hr class="divider">

                <%-- [기능] 옵션 선택 박스 --%>
                <div class="option-select-box">
                    <label>옵션 선택</label>
                    <select id="option" onchange="addOptionAuto()">
                        <option value="">-- 색상 / 사이즈 선택 --</option>
                        <c:forEach var="opt" items="${optionList}">
                            <option value="${opt.optionIdx}" 
                                    data-color="${opt.color}" 
                                    data-size="${opt.size}" 
                                    data-stock="${opt.stock}"
                                    ${opt.stock <= 0 ? 'disabled' : ''}>
                                ${opt.color} / ${opt.size} 
                                <c:out value="${opt.stock <= 0 ? '(품절)' : ''}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <%-- [기능] 선택된 옵션 리스트 및 총 금액 --%>
                <div class="selected-options-container">
                    <table id="optionTable">
                        <thead>
                            <tr><th>옵션</th><th>수량</th><th>가격</th><th>삭제</th></tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <div class="total-amount-box">
                        <span>총 합계 금액</span><span id="totalAmount">0원</span>
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

        <%-- [기능] 하단 탭 메뉴 (정보/사이즈/리뷰) --%>
        <div class="tab-menu">
            <button class="tab-btn active" onclick="openTab('info', this)">상품정보</button>
            <button class="tab-btn" onclick="openTab('size', this)">사이즈 가이드</button>
            <button class="tab-btn" onclick="openTab('review', this)">리뷰 (${fn:length(reviewList)})</button>
        </div>

        <div id="info" class="tab-content active">
            <div class="description-text">${product.productDesc}</div>
            <c:forEach var="descImg" items="${descImgList}">
                <img src="${path}/resources/images/ProductDescImg/${descImg.productDescImg}" style="max-width:100%; display:block; margin:0 auto 20px;">
            </c:forEach>
        </div>

        <div id="size" class="tab-content">
            <c:choose>
                <c:when test="${not empty product.productSizeImg}">
                    <img src="${path}/resources/images/ProductSizeImg/${product.productSizeImg}" style="max-width:100%; display:block; margin:0 auto;">
                </c:when>
                <c:otherwise>
                    <p class="empty-msg">등록된 사이즈 정보 이미지가 없습니다.</p>
                </c:otherwise>
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
        </div>
    </div>
</div>

<script>
// 1. 이미지 슬라이드 로직
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

// 2. 옵션 추가 및 실시간 계산 (10원 단위 절삭 유지)
function addOptionAuto() {
    const optionSelect = document.getElementById("option");
    const selected = optionSelect.options[optionSelect.selectedIndex];
    if (!selected.value) return;

    const optionIdx = selected.value;
    const color = selected.dataset.color;
    const size = selected.dataset.size;
    const stock = parseInt(selected.dataset.stock);

    if (stock <= 0) {
        alert("품절된 옵션입니다.");
        optionSelect.selectedIndex = 0;
        return;
    }

    // [기능] 중복 선택 시 수량 증가
    const rows = document.querySelectorAll("#optionTable tbody tr");
    for (let row of rows) {
        if (row.dataset.optionIdx === optionIdx) {
            const qtyInput = row.querySelector("input[type='number']");
            if (parseInt(qtyInput.value) + 1 > stock) {
                alert("재고가 부족합니다.");
                return;
            }
            qtyInput.value = parseInt(qtyInput.value) + 1;
            updateRowTotal(row);
            optionSelect.selectedIndex = 0;
            return;
        }
    }

    // [기능] VO에서 넘어온 '절삭 완료된 단가'를 JS 변수로 사용
    const unitPrice = parseInt(document.getElementById("finalUnitPrice").value);

    const table = document.getElementById("optionTable").querySelector("tbody");
    const row = document.createElement("tr");
    row.dataset.optionIdx = optionIdx;
    row.dataset.price = unitPrice;
    row.dataset.stock = stock;
    
    row.innerHTML = `
        <td>\${color} / \${size}</td>
        <td><input type="number" value="1" min="1" max="\${stock}" onchange="updateRowTotal(this.closest('tr'))"></td>
        <td class="price-cell">\${unitPrice.toLocaleString()}원</td>
        <td><button type="button" class="btn-remove" onclick="removeRow(this)">×</button></td>
    `;
    table.appendChild(row);

    // Form 데이터 동기화
    [document.getElementById("buyForm"), document.getElementById("cartForm")].forEach(form => {
        form.appendChild(createHidden("optionIdxList", optionIdx, optionIdx));
        form.appendChild(createHidden("quantityList", 1, optionIdx));
    });

    updateTotal();
    optionSelect.selectedIndex = 0;
}

// [기능] 개별 옵션 행의 가격 업데이트
function updateRowTotal(row) {
    const qtyInput = row.querySelector("input[type='number']");
    const stock = parseInt(row.dataset.stock);
    let qty = parseInt(qtyInput.value) || 1;

    if (qty > stock) {
        alert("최대 재고는 " + stock + "개입니다.");
        qty = stock;
        qtyInput.value = stock;
    }
    if (qty < 1) {
        qty = 1;
        qtyInput.value = 1;
    }

    // 단가(절삭됨) * 수량
    const rowPrice = parseInt(row.dataset.price) * qty;
    row.querySelector(".price-cell").innerText = rowPrice.toLocaleString() + "원";
    
    const optionIdx = row.dataset.optionIdx;
    document.querySelectorAll(`input[name='quantityList'][data-option-idx='\${optionIdx}']`).forEach(el => {
        el.value = qty;
    });
    
    updateTotal();
}

function removeRow(btn) {
    const row = btn.closest("tr");
    const optionIdx = row.dataset.optionIdx;
    document.querySelectorAll(`input[data-option-idx='\${optionIdx}']`).forEach(el => el.remove());
    row.remove();
    updateTotal();
}

// [기능] 전체 합계 금액 업데이트 (toLocaleString으로 콤마 적용)
function updateTotal() {
    let total = 0;
    document.querySelectorAll("#optionTable tbody tr").forEach(row => {
        const qty = parseInt(row.querySelector("input[type='number']").value) || 0;
        const price = parseInt(row.dataset.price) || 0;
        total += (qty * price);
    });
    document.getElementById("totalAmount").innerText = total.toLocaleString() + "원";
}

function createHidden(name, value, optionIdx) {
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = name;
    input.value = value;
    if (optionIdx) input.dataset.optionIdx = optionIdx;
    return input;
}

function validateForm() {
    const rowCount = document.querySelectorAll("#optionTable tbody tr").length;
    if (rowCount === 0) {
        alert("옵션을 선택해주세요.");
        return false;
    }
    return true;
}

// 3. 탭 제어 로직
function openTab(tabId, btn) {
    document.querySelectorAll(".tab-content, .tab-btn").forEach(el => el.classList.remove("active"));
    document.getElementById(tabId).classList.add("active");
    btn.classList.add("active");
    
    const offset = document.getElementById(tabId).offsetTop - 120;
    window.scrollTo({ top: offset, behavior: "smooth" });
}
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />