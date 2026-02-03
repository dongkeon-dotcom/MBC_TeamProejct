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
                <td><img src="${path}/resources/images/${item.productMainImg}" class="product-img"></td>
                <td colspan="2"> ${item.productName}<br>
                ${item.quantity}</td>
                <td><fmt:formatNumber value="${item.price * item.quantity}" />원</td>
              <td><button type="button" onclick="review('${item.productIdx}', '${order.orderIdx}')">
              후기쓰기</button> </td>
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
