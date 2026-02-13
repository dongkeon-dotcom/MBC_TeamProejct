<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:import url="/WEB-INF/view/include/top.jsp" />

<link rel="stylesheet" href="${path}/resources/css/userproduct/userproductdetail.css">

<div class="main-content-area">
    <div class="product-detail-wrapper">
        
        <div class="product-top-section">
            <div class="product-image">
                <div class="main-img-container" style="position: relative; overflow: hidden;">
                    <button type="button" class="btn-prev" onclick="changeSlide(-1)">〈</button>
                    
                    <c:choose>
                        <c:when test="${not empty product.productMainImg}">
                            <img id="currentMainImg" src="${path}/resources/images/ProductMainImg/${product.productMainImg}" 
                                 alt="${product.productName}">
                        </c:when>
                        <c:otherwise>
                            <img id="currentMainImg" src="${path}/resources/images/no-image.png" alt="이미지 준비중">
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

            <div class="product-info">
                <p class="category-path">
                    <c:out value="${product.category}" /> &gt; <c:out value="${product.subCategory}" />
                </p>
                
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
                <img src="${path}/resources/images/ProductDescImg/${descImg.productDescImg}" class="desc-img">
            </c:forEach>
        </div>
        
        <div id="size" class="tab-content">
            <img src="${path}/resources/images/ProductSizeImg/${product.productSizeImg}" class="desc-img">
        </div>

        <div id="review" class="tab-content">
            <c:forEach var="r" items="${reviewList}">
                <div class="review-item">
                    <strong>${r.userName}</strong> <span>${r.rating}점</span>
                    <p>${r.review}</p>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
/* [1] 이미지 슬라이드 (가장 최근 로직) */
let images = [];
let currentIndex = 0;

window.addEventListener('load', function() {
    const thumbs = document.querySelectorAll(".sub-images img");
    thumbs.forEach(img => images.push(img.src));
    updateThumbStyle();
});

function setMainImg(src) {
    document.getElementById("currentMainImg").src = src;
    currentIndex = images.indexOf(src);
    updateThumbStyle();
}

function changeSlide(direction) {
    if (images.length <= 1) return;
    currentIndex = (currentIndex + direction + images.length) % images.length;
    document.getElementById("currentMainImg").src = images[currentIndex];
    updateThumbStyle();
}

function updateThumbStyle() {
    const thumbs = document.querySelectorAll(".sub-images img");
    thumbs.forEach((img, index) => {
        img.style.border = (index === currentIndex) ? "2px solid #333" : "1px solid #eee";
        img.style.opacity = (index === currentIndex) ? "1" : "0.6";
    });
}

/* [2] 옵션 추가 및 계산 */
function addOptionAuto() {
    const sel = document.getElementById("option");
    const opt = sel.options[sel.selectedIndex];
    if (!opt.value) return;

    const color = opt.dataset.color;
    const size = opt.dataset.size;
    const idx = opt.value;
    const base = parseInt(document.getElementById("basePrice").value);
    const rate = parseInt(document.getElementById("discountRate").value);
    const price = rate > 0 ? Math.floor(base * (100 - rate) / 100) : base;

    // 중복 체크
    const rows = document.querySelectorAll("#optionTable tbody tr");
    for (let r of rows) {
        if (r.dataset.optionIdx === idx) {
            const input = r.querySelector("input[type='number']");
            input.value = parseInt(input.value) + 1;
            updateRowTotal(r); sel.selectedIndex = 0; return;
        }
    }

    const tr = document.createElement("tr");
    tr.dataset.optionIdx = idx;
    tr.dataset.price = price;
    tr.innerHTML = '<td>' + color + ' / ' + size + '</td>' +
                   '<td><input type="number" value="1" min="1" onchange="updateRowTotal(this.closest(\'tr\'))"></td>' +
                   '<td class="price-cell">' + price.toLocaleString() + '원</td>' +
                   '<td><button type="button" class="btn-delete" onclick="removeRow(this)">×</button></td>';
    document.querySelector("#optionTable tbody").appendChild(tr);

    // Hidden Input 추가
    [document.getElementById("buyForm"), document.getElementById("cartForm")].forEach(f => {
        const i1 = document.createElement("input"); i1.type="hidden"; i1.name="optionIdxList"; i1.value=idx;
        const i2 = document.createElement("input"); i2.type="hidden"; i2.name="quantityList"; i2.value=1; i2.dataset.optionIdx=idx;
        f.appendChild(i1); f.appendChild(i2);
    });

    updateTotal();
    sel.selectedIndex = 0;
}

function updateRowTotal(r) {
    const qty = r.querySelector("input").value;
    r.querySelector(".price-cell").innerText = (qty * r.dataset.price).toLocaleString() + "원";
    const idx = r.dataset.optionIdx;
    document.querySelectorAll("input[name='quantityList'][data-option-idx='"+idx+"']").forEach(i => i.value = qty);
    updateTotal();
}

function removeRow(btn) {
    const r = btn.closest("tr");
    const idx = r.dataset.optionIdx;
    document.querySelectorAll("input[data-option-idx='"+idx+"'], input[name='optionIdxList'][value='"+idx+"']").forEach(e => e.remove());
    r.remove();
    updateTotal();
}

function updateTotal() {
    let t = 0;
    document.querySelectorAll("#optionTable tbody tr").forEach(r => {
        t += (r.querySelector("input").value * r.dataset.price);
    });
    document.getElementById("totalAmount").innerText = t.toLocaleString() + "원";
}

/* [3] 탭 메뉴 */
function openTab(tabId, btn) {
    document.querySelectorAll(".tab-content").forEach(t => t.classList.remove("active"));
    document.querySelectorAll(".tab-btn").forEach(b => b.classList.remove("active"));
    document.getElementById(tabId).classList.add("active");
    btn.classList.add("active");
}

function validateForm() {
    if (document.querySelectorAll("#optionTable tbody tr").length === 0) {
        alert("옵션을 선택해주세요."); return false;
    }
    return true;
}
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />