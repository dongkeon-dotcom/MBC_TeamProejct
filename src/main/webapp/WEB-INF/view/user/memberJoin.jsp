<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
    <c:import url="/WEB-INF/view/include/top.jsp" />
<!DOCTYPE html>
<html>
<head> <!-- 회원가입페이지 입니다  -->
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>



<section>
    <br>
    <div align="center">
        <h1>회원 가입2 </h1>
<form name="joinForm" method="post"
      action="${path}/user/memberOK.do">

  <c:if test="${!isSocial}">
    <tr>
      <td>회원아이디</td>
      <td><button type="button" onclick="checkEmail()">아이디 중복체크</button></td>
    </tr>
    <tr>
      <td colspan="2">
        <input type="text" name="id" id="id" size="25" placeholder="이메일을 입력하세요" />
        <span id="emailMsg"></span>
      </td>
    </tr>
  </c:if>

  <c:if test="${!isSocial}">
    <tr><td colspan="2">암호</td></tr>
    <tr>
      <td colspan="2">
        <input type="password" name="password" size="25" placeholder="비밀번호 입력 (최소8자이상)" />
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <input type="password" name="userPWck" size="25" placeholder="비밀번호 재입력" />
      </td>
    </tr>
  </c:if>

  <tr><td colspan="2">이름</td></tr>
  <tr><td colspan="2"><input type="text" name="userName" size="25" /></td></tr>

  <tr><td colspan="2">전화번호</td></tr>
  <tr><td colspan="2"><input type="text" name="userPhone" size="25" placeholder="ex) 010-3608-9336" /></td></tr>

  <tr>
    <td colspan="2" align="center">
      <input type="button" value="회원가입" onclick="joinCheck()" />
    </td>
  </tr>
</form>

     
    </div>
    <br>
</section>
<script>
let emailChecked = false;
const isSocial = ${isSocial == true ? 'true' : 'false'};

function joinCheck() {
  const form = document.joinForm;

  if (!isSocial) {
    if (form.id.value.trim() === "") {
      alert("아이디를 입력하세요");
      form.id.focus();
      return;
    }

    if (!emailChecked) {
      alert("아이디 중복체크를 해주세요");
      return;
    }

    if (form.password.value === "") {
      alert("비밀번호를 입력하세요");
      form.password.focus();
      return;
    }

    if (form.password.value !== form.userPWck.value) {
      alert("비밀번호가 일치하지 않습니다");
      form.userPWck.focus();
      return;
    }
  }

  if (form.userName.value.trim() === "") {
    alert("이름을 입력하세요");
    form.userName.focus();
    return;
  }

  if (form.userPhone.value.trim() === "") {
    alert("전화번호를 입력하세요");
    form.userPhone.focus();
    return;
  }

  form.submit();
}

function checkEmail() {
  const email = document.getElementById("id").value.trim();
  const msg = document.getElementById("emailMsg");

  if (email === "") {
    msg.innerHTML = "이메일을 입력하세요";
    msg.style.color = "red";
    emailChecked = false;
    return;
  }

  fetch("${path}/user/checkEmail.do?id=" + encodeURIComponent(email))
    .then(res => res.json())
    .then(data => {
      if (data.exists) {
        msg.innerHTML = "이미 사용 중인 이메일입니다 ❌";
        msg.style.color = "red";
        emailChecked = false;
      } else {
        msg.innerHTML = "사용 가능한 이메일입니다 ✅";
        msg.style.color = "green";
        emailChecked = true;
      }
    })
    .catch(() => {
      msg.innerHTML = "서버 오류";
      msg.style.color = "red";
      emailChecked = false;
    });
}
</script>


</body>
</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
