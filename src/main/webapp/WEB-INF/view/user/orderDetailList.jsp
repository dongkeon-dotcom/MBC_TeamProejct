<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:import url="/WEB-INF/view/include/top.jsp" />
<!DOCTYPE html>
<html>
<head>
<!-- 커스터머오더 관리    -->
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


<section>
    <br>
    <div align="center">
       <h3>상세주문리스트   </h3>
    
        <table class="info-table">
        <tr><td>주문 날짜 :${order.orderDate}</td> </tr>
        <tr><td>주문 번호 :${order.orderIdx}</td> </tr>
        <tr><td>수령인 :${order.recevier}</td> </tr>
        <tr><td>연락처 :${order.deliveryPhone}</td> </tr>
        <tr><td>배송지 주소:${order.address} ${order.extraAddress}</td> </tr>
        
        <tr><td>주문상태 :${order.status} </td> </tr>
         </table>
   
   
   
   <table class="item-table">
    <thead>
        <tr>
            <th >주문 상품 내역 (총 ${fn:length(detailList)}종) </th>
        </tr>
        <tr>
            <th>이미지</th>
            <th>상품정보</th>
            <th>판매가</th>
            <th>가격 </th>
        </tr>
    </thead>
    <tbody>
<%-- 상세 주문 리스트 반복 시작 --%>
<c:forEach var="item" items="${detailList}">
    <tr>
        <%-- 1. 상품 이미지 --%>
        <td class="text-center">
            <img src="${path}/resources/images/ProductMainImg/${item.productMainImg}" class="product-img" style="width:80px; height:80px; object-fit:cover;">
        </td>
        
        <%-- 2. 상품명 및 옵션 정보 --%>
        <td colspan="2">
            <div class="fw-bold">${item.productName}</div>
            <div class="text-secondary small">
                옵션: ${item.color} / ${item.size}
            </div>
            <div class="text-muted small">구매수량: ${item.quantity}개</div>
        </td>
        
        <%-- 3. 주문 금액 --%>
        <td class="text-end">
            <fmt:formatNumber value="${item.price * item.quantity}" />원
        </td>
        
        <%-- 4. 후기 버튼 영역 (VO에 추가된 필드 활용) --%>
        <td class="text-center">
            <%-- 매칭되는 후기 번호를 담을 변수 리셋 --%>
            <c:set var="thisItemReviewIdx" value="0" />

            <%-- 내가 쓴 후기 리스트(myReviews)를 돌며 현재 상품+옵션과 일치하는지 체크 --%>
            <c:forEach var="rev" items="${myReviews}">
                <c:if test="${rev.productIdx == item.productIdx && rev.color eq item.color && rev.size eq item.size}">
                    <%-- 일치하면 해당 후기 번호를 변수에 저장 --%>
                    <c:set var="thisItemReviewIdx" value="${rev.reviewIdx}" />
                </c:if>
            </c:forEach>

            <%-- 버튼 출력 로직 --%>
            <c:choose>
                <%-- 후기 번호가 0이 아니면 이미 쓴 후기가 있다는 뜻 --%>
                <c:when test="${thisItemReviewIdx != 0}">
                    <button type="button" class="btn btn-outline-secondary btn-sm" 
                            onclick="editReview('${thisItemReviewIdx}')">
                        후기수정
                    </button>
                </c:when>
                <%-- 후기 번호가 0이면 새로 작성 --%>
                <c:otherwise>
                    <button type="button" class="btn btn-primary btn-sm" 
                            onclick="review('${item.productIdx}', '${order.orderIdx}', '${item.color}', '${item.size}')">
                        후기쓰기
                    </button>
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
</c:forEach>
    </tbody>
    <tfoot>
            <tr>
                <td colspan="4" align="right">최종 결제 금액:</td>
                <td>
                    <strong><fmt:formatNumber value="${order.totalPrice}" pattern="#,###" />원</strong>
                </td>
                
            </tr>
        </tfoot>
</table>
   
   
    </div>
    
    
   <%--  아 페이징 처리 필요 없을듯 
    <div class="pagination">
        <c:if test="${startPage > 1}">
            <a href="orderList.do?page=${startPage-1}">[이전]</a>
        </c:if>
        <c:forEach var="i" begin="${startPage}" end="${endPage}">
            <a href="orderList.do?page=${i}" style="${i == currentPage ? 'font-weight:bold;' : ''}">[${i}]</a>
        </c:forEach>
        <c:if test="${endPage < totalPage}">
            <a href="orderList.do?page=${endPage+1}">[다음]</a>
        </c:if>
    </div>
 --%> 
</section>


<script type="text/javascript">

function review(pIdx, oIdx){
	
	alert("review ")
	location.href = "${path}/user/review.do?productIdx=" + pIdx + "&orderIdx=" + oIdx;
	
}

function editReview(rIdx) {
    if(confirm("작성하신 후기를 수정하시겠습니까?")) {
        // 후기 번호(reviewIdx)를 가지고 수정 폼으로 이동
        location.href = "${path}/user/reviewEdit.do?reviewIdx=" + rIdx;
    }
}

</script>
</body>
</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
