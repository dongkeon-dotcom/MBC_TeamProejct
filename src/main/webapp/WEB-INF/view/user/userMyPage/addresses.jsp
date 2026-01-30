<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />


<section class="address-section"> <br>


  <h1>배송지 관리</h1>
  
  <!-- 배송지 추가 버튼 -->
  <button onclick="location.href='${path}/address/addForm.do'">
    배송지 추가하기
  </button>
  
  <!-- 배송지 리스트 -->
  <c:forEach var="addr" items="${addressList}">
    <div class="address-box">
      <p><strong>${addr.receiver}</strong> 
         <c:if test="${addr.defaultYn eq 'Y'}">기본 배송지</c:if> 
         <c:if test="${addr.recentYn eq 'Y'}">최근 사용</c:if>
      </p>
      <p>${addr.address} ${addr.detail}</p>
      <p>${addr.tel}</p>
      
      <button onclick="location.href='${path}/address/editForm.do?id=${addr.id}'">수정</button>
      <button onclick="location.href='${path}/address/delete.do?id=${addr.id}'">삭제</button>
    </div>
  </c:forEach>









<br>
<script >

    
</script>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />