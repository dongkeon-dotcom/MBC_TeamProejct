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

<section style="max-width: 1000px; margin: 0 auto; padding: 20px;">
    <div align="center">
        <h2>마이페이지 - 주문 내역2222</h2>
        
        <div style="background: #f4f4f4; padding: 15px; border-radius: 8px;">
            <form method="get" action="${path}/user/orderList.do">
                <strong>조회 기간:</strong>
                <input type="date" name="startDate" value="${startDate}" /> ~ 
                <input type="date" name="endDate" value="${endDate}" />
                <button type="submit" style="padding: 5px 15px;">조회하기</button>
            </form>
        </div>

        <table class="order-table">
            <thead>
                <tr>
                    <th>주문번호</th>
                    <th>주문금액</th>
                    <th>주문일자</th>
                    <th>상태/상세</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty orderli}">
                        <c:forEach var="m" items="${orderli}">
                            <tr>
                                <td><strong>${m.orderIdx}</strong></td>
                                <td><fmt:formatNumber value="${m.totalPrice}" pattern="#,###" />원</td>
                                <td>${m.orderDate}</td>
                                <td>
                                    <a href="${path}/user/orderDetailList.do?orderIdx=${m.orderIdx}" class="page-link" style="font-size: 12px;">상세보기</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="4" style="padding: 50px 0;">주문 내역이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="pagination-container">
            <c:if test="${startPage > 1}">
                <a href="${path}/user/orderList.do?page=${startPage - 1}&startDate=${startDate}&endDate=${endDate}" class="page-link">&laquo; 이전</a>
            </c:if>
            
            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                <a href="${path}/user/orderList.do?page=${i}&startDate=${startDate}&endDate=${endDate}" 
                   class="page-link ${i == page ? 'active' : ''}">
                    ${i}
                </a>
            </c:forEach>

            <c:if test="${endPage < totalPage}">
                <a href="${path}/user/orderList.do?page=${endPage + 1}&startDate=${startDate}&endDate=${endDate}" class="page-link">다음 &raquo;</a>
            </c:if>
        </div>
    </div>
</section>

</body>
</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
