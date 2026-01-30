<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<!DOCTYPE html>
<html>
<head>
<!-- 커스터머 주소목록 관리    -->
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


<section>
    <br>
    <div align="center">
       <h3> 주소관리  </h3>
  
      체크 박스 이름 전화번호 주소지 주소지 삭제 버튼 
      
      선택사항 삭제 				배송지 등록 버튼 
      <form action="">
     <table > 

     <tr> <td></td> <td>이름</td> <td>전화번호</td><td>주소지</td><td>삭제/td>
     <c:forEach var="m" items="" varstatus="status">
     <tr> <td><input type="checkbox" name="agree" value="Y"> </td> <td>${ deliveryRecevier}</td> 
     <td>${ deliveryPhone}</td><td>${ deliveryAddress}</td><td><input type=button onClick="addressDel()" value="삭제 "></td>
     
     </c:forEach>
     <button>선택사항 삭제</button>  <button>배송지추가 </button> 
     
     
     </table>
      
        </form>
        
    </div>
</section>


<script type="text/javascript">

function addressDel(){
	
	alert("주소삭")
	location.href="${path}//delete.do?${}";
}


</script>


</body>
</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
