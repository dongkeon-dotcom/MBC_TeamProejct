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
 <c:forEach var="item" items="${detailList}">
    <tr>
        <%-- 1. 상품 이미지 영역 --%>
        <td class="text-center">
            <img src="${path}/resources/images/${item.productMainImg}" class="product-img" style="width:80px; height:80px; object-fit:cover;">
        </td>
        
        <%-- 2. 상품명 및 옵션 정보 영역 --%>
        <td colspan="2">
            <div class="fw-bold">${item.productName}</div>
            <%-- 현재 주문의 옵션 정보 표시 --%>
            <div class="text-secondary small">
                옵션: ${item.color} / ${item.size}
            </div>
            <div class="text-muted small">구매수량: ${item.quantity}개</div>
        </td>
        
        <%-- 3. 주문 금액 영역 --%>
        <td class="text-end">
            <fmt:formatNumber value="${item.price * item.quantity}" />원
        </td>
        
        <%-- 4. 후기 버튼 영역 (옵션 매칭 로직) --%>
        <td class="text-center">
            <%-- 상품마다 후기번호 0으로 리셋 --%>
            <c:set var="thisItemReviewIdx" value="0" />

            <%-- 내가 쓴 모든 후기 리스트(myReviews)를 돌면서 체크 --%>
            <c:forEach var="rev" items="${myReviews}">
                <%-- 
                    [중요] VO 수정을 피하기 위해, 
                    XML에서 rev.userName에 "컬러_사이즈" 정보를 담아왔다고 가정합니다. 
                --%>
                <c:set var="revFullKey"><c:out value="${rev.productIdx}_${rev.userName}" /></c:set>
                <c:set var="itemFullKey"><c:out value="${item.productIdx}_${item.color}_${item.size}" /></c:set>
                
                <%-- 상품번호 + 옵션 조합이 100% 일치하는지 확인 --%>
                <c:if test="${revFullKey eq itemFullKey}">
                    <c:set var="thisItemReviewIdx" value="${rev.reviewIdx}" />
                </c:if>
            </c:forEach>

            <%-- 매칭 결과에 따른 버튼 출력 --%>
            <c:choose>
                <c:when test="${thisItemReviewIdx != 0 && thisItemReviewIdx != '0'}">
                    <%-- 일치하는 후기번호가 있으면 수정 버튼 --%>
                    <button type="button" class="btn btn-outline-secondary btn-sm" 
                            onclick="editReview('${thisItemReviewIdx}')">
                        후기수정
                    </button>
                </c:when>
                <c:otherwise>
                    <%-- 없으면 새로 쓰기 버튼 --%>
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


</script>
</body>
</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
