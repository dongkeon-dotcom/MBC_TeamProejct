<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<!DOCTYPE html>
<html>
<head>
<!-- 마이페이지   -->
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


<section>
    <br>
    <div align="center">
       <h3>마이페이지 </h3>
      <table>
      
      <tr> <td>로그인유저 이름  </td></tr>
      
       <tr> <td>  <a href="${pageContext.request.contextPath}/user/customerMyPage/orderList.do">
    주문내역
</a>
 </td></tr>
        <tr> <td><a href="${pageContext.request.contextPath}/customerMyPage/addressList.do">
    주소지관리
</a>
       </td></tr>
      
      </table> 
   
   
   
        
    </div>
</section>



</body>
</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
