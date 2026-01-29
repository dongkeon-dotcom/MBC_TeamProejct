<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />


<link href="${path}/resources/member/login.css" rel="stylesheet">

<section class="signup-section">
   
<br>

<h1 class="login-title">회원 로그인</h1>

<form class="login-form" method="POST" action="${path}/member/login.do">
  <input type="text" name="username" placeholder="이메일" required> <br>
  
  <input type="password" name="password" placeholder="비밀번호" required> <br>
  
  <button type="submit" class="login-btn">로그인</button>

  <div class="login-options">
    <div align="center">
      <a href="${path}/member/form.do">회원가입</a>&emsp; |&emsp; 
      <a href="${path}/member/findId.do">아이디 찾기</a>&emsp; |&emsp; 
      <a href="${path}/member/findPw.do">비밀번호 찾기</a>
    </div>
  </div>
</form>

<br>


<script >

    
</script>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />