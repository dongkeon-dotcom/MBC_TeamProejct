<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
       <h3>고객 주문내 리스트  </h3>
      
   
        <table> 
        <tr> <td>주문번호 </td>
        <td>주문금액 </td>
        <td>주문 날짜 </td></tr>
        
        <c:forEach var="m" items="${orderli}">
          <tr> <td>${orderli.} </td> <!-- 링크 달아서 상세 주문리스트로 이동해야함  -->
          <td>${orderli.} </td>
          <td>${orderli.} </td></tr>
        </c:forEach>
        
        </table>
        
    </div>
</section>



</body>
</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
