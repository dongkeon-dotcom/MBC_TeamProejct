<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<link href="${path}/resources/member/mypage.css" rel="stylesheet">

   
<br>
<div align="center">
<section class="mypage-section">
    <h1>마이페이지1</h1>
   
  <table>   
    <tr> <td> <strong>${sessionScope.loginMember.userName}</strong>님 환영합니다!</td></tr>
      <tr> <td>  <a href="${path}/member/edit.do">회원정보 수정 </a></td></tr>
       <tr> <td>  <a href="${path}/user/orderList.do">주문내역</a></td></tr>
        <tr> <td><a href="${path}/user/addressList.do">주소지관리</a></td></tr>
        <tr> <td><a href="${path}/cart/list.do">장바구니관</a></td></tr>
      
      </table> 



</div>
<br>
<script >

    
</script>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />