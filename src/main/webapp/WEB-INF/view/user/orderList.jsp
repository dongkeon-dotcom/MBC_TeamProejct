<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
       <h3>고객 주문내 리스트  </h3>
      <form method="get" action="${path}/user/orderList.do">
    시작일:
    <input type="date" name="startDate" value="${startDate}" />

    종료일:
    <input type="date" name="endDate" value="${endDate}" />

    <button type="submit">조회</button>
</form>
      
   <form method= "post" action="${path}/user/cart.do">
        <table> 
        <tr> <td>주문번호(orderIdx) </td>
        <td>주문금액(totalPrice) </td>
        <td>주문 날짜 (orderRegDate)</td></tr>
        <c:choose>
                    <c:when test="${not empty orderli}">
        <c:forEach var="m" items="${orderli}" varStatus="status">
          <tr> <td><a href="${path}/user/orderDetailList.do?orderIdx=${m.orderIdx}">${m.orderIdx}</a> </td> <!-- 링크 달아서 상세 주문리스트로 이동해야함  -->
          <td>${m.totalPrice} </td>
          <td>${m.orderRegDate} </td></tr>
        </c:forEach>
        </c:when>
        <c:otherwise>
                     <tr> <td colspan="3">주문 내역이 없습니다.</td></tr>
        </c:otherwise>
        </c:choose>
        </table>
        </form>
    </div>
</section>


<!-- 페이징 처리 최소 5 -->



<!-- 페이징 영역 -->
<div style="margin-top:15px; text-align:center;">

  <c:if test="${totalPage > 0}">

    <!-- 이전 블록 -->
    <c:choose>
      <c:when test="${startPage <= 1}">
        <span style="color:gray;">[이전]</span>
      </c:when>
      <c:otherwise>
        <a href="${path}/user/orderList.do?page=${startPage - 1}">[이전]</a>
      </c:otherwise>
    </c:choose>

    <!-- 페이지 번호 (최대 10개) -->
    <c:forEach var="p" begin="${startPage}" end="${endPage}">
      <c:choose>
        <c:when test="${p == page}">
          <strong>[${p}]</strong>
        </c:when>
        <c:otherwise>
          <a href="${path}/user/orderList.do?page=${p}">[${p}]</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>

    <!-- 다음 블록 -->
    <c:choose>
      <c:when test="${endPage >= totalPage}">
        <span style="color:gray;">[다음]</span>
      </c:when>
      <c:otherwise>
        <a href="${path}/user/orderList.do?page=${endPage + 1}">[다음]</a>
      </c:otherwise>
    </c:choose>

  </c:if>

</div>



</body>
</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
