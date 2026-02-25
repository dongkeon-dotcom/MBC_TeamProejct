<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:import url="/WEB-INF/view/include/top.jsp" />

<!-- 커스터머오더 관리    -->
<link href="${path}/resources/css/user/orderdetailList.css" rel="stylesheet">

<section>
    <h3>상세 주문 리스트</h3>
    
    <table class="info-table">
        <tr><td><strong>주문 날짜 :</strong> ${order.orderDate}</td></tr>
        <tr><td><strong>주문 번호 :</strong> ${order.orderIdx}</td></tr>
        <tr><td><strong>수령인 :</strong> ${order.recevier}</td></tr>
        <tr><td><strong>연락처 :</strong> ${order.deliveryPhone}</td></tr>
        <tr><td><strong>배송지 주소 :</strong> ${order.address} ${order.extraAddress}</td></tr>
    </table>

    <table class="item-table">
        <thead>
            <tr>
                <th colspan="5" style="text-align:left;">주문 상품 내역 (총 ${fn:length(detailList)}종)</th>
            </tr>
            <tr>
                <th>이미지</th>
                <th>상품정보</th>
                <th>수량</th> <th>가격</th>
                <th>상태</th>
            </tr>
        </thead>
        <tbody>
           <c:forEach var="item" items="${detailList}">
    <tr>
       <td class="text-center">
    <a href="${path}/userproduct/userproductdetail.do?productIdx=${item.productIdx}&orderIdx=${order.orderIdx}">
        <img src="${path}/resources/images/ProductMainImg/${item.productMainImg}" 
             class="product-img" 
             style="width:80px; height:80px; object-fit:cover; cursor:pointer;">
    </a>
</td>
        <td>
            <div class="fw-bold">${item.productName}</div>
            <div class="text-secondary small">옵션: ${item.color} / ${item.size}</div>
        </td>
        <td class="text-center">${item.quantity}개</td>
        <td class="text-end fw-bold">
            <fmt:formatNumber value="${item.price * item.quantity}" />원
        </td>
       <td class="text-center">
    <%-- 
       OrderItems 테이블은 상품이 삭제되어도 이름이 남아있으므로, 
       우리가 컨트롤러에서 DB를 직접 찔러보고 만든 productExistMap을 사용해야 합니다.
    --%>
    <c:set var="isExists" value="${productExistMap[item.productIdx]}" />

    <c:choose>
        <%-- 실제 상품 테이블(PRODUCT)에 데이터가 있을 때만 --%>
        <c:when test="${isExists == true}">
            <c:set var="rIdx" value="${reviewMap[item.itemIdx]}" />

            <c:choose>
                <c:when test="${not empty rIdx && rIdx != 0}">
                    <button type="button" class="btn btn-outline-secondary btn-sm" 
                            onclick="editReview('${rIdx}', '${order.orderIdx}')">후기수정</button>
                </c:when>
                <c:otherwise>
                    <button type="button" class="btn btn-primary btn-sm" 
                            onclick="review('${item.productIdx}', '${order.orderIdx}', '${item.itemIdx}')">후기쓰기</button>
                </c:otherwise>
            </c:choose>
        </c:when>

        <%-- 실제 상품 테이블에서 삭제되었다면 --%>
        <c:otherwise>
            <span class="text-muted" style="font-size: 0.85em;">판매 종료된 상품</span>
        </c:otherwise>
    </c:choose>
</td>
    </tr>
</c:forEach>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="4" class="text-end">최종 결제 금액:</td>
                <td class="text-center">
                    <strong><fmt:formatNumber value="${order.totalPrice}" pattern="#,###" />원</strong>
                </td>
            </tr>
        </tfoot>
    </table>
</section>


<script type="text/javascript">

function review(pIdx, oIdx, iIdx) {
    // 주소창에 itemIdx가 포함되는지 확인하세요!
    location.href = "${path}/user/review.do?productIdx=" + pIdx + "&orderIdx=" + oIdx + "&itemIdx=" + iIdx;
}


function editReview(rIdx, oIdx) { // 함수가 받을 때 이름을 rIdx, oIdx로 정함
    if(confirm("작성하신 후기를 수정하시겠습니까?")) {
        // 위에서 정한 이름(rIdx, oIdx)을 그대로 써줘야 합니다.
        location.href = "reviewEdit.do?reviewIdx=" + rIdx + "&orderIdx=" + oIdx;
    }
}

function checkProductStatus(productIdx, isDeleted) {
    // isDeleted가 'true', 'Y', 1 등 삭제를 의미하는 값인지 확인
    if (isDeleted === 'true' || isDeleted === '1' || isDeleted === 'Y') {
        alert("더이상 판매하지 않는 상품입니다.");
        // 아무것도 하지 않음 (현재 페이지 유지)
    } else {
        // 삭제되지 않은 경우 상세 페이지로 이동
        location.href = "${path}/userproduct/userproductdetail.do?productIdx=" + productIdx;
    }
}
</script>
<script>
    // 페이지 로드 시 실행
    document.addEventListener("DOMContentLoaded", function() {
        var message = "${msg}";
        if (message) {
            alert(message);
        }
    });
</script>




<c:import url="/WEB-INF/view/include/bottom.jsp" />
