<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<section>
	<br>
	<div align="center">
		<h1>개인 회원 정보 수정</h1>

		<!-- action은 컨트롤러 매핑에 맞게 수정 -->
		<form id="updateForm" action="${path}/user/memberUpdate.do" method="POST">

			<!-- hidden 값 -->
			<input type="hidden" name="userIdx" value="${m.userIdx}">
			<input type="hidden" name="id" value="${m.id}">


			<table  align="center">
				<tr><td>이메일</td><td><input type="text" name="id" value="${m.id}"readonly></td></tr>
				<tr><td>암호</td><td><input type="text" name="password" id="password"placeholder="비밀번호를 입력하세요" minlength="4" maxlength="20" required></td></tr>
				<tr><td>회원 이름</td><td><input type="text" name="userName" value="${m.userName}"></td></tr>
				<tr><td>전화번호</td><td><input type="text" name="userPhone" value="${m.userPhone}"></td></tr>
				<tr><td>주소</td> <td>(${d.zipcode}) ${d.address} ${d.extraAddress}</td></tr>
				<tr ><td colspan="2" align="center"> <input type="button" value="수정하기" onclick="memberUpdate()" /> 
				 <input type="button" value="뒤로가기" onclick="memberBack()" /></td> </tr>
			</table>
		</form>
	</div>
</section>
<script>
function memberUpdate(){
    if(confirm("정보를 수정하시겠습니까?")) {
        // location.href 대신 form의 id를 찾아 submit() 호출!
        document.getElementById("updateForm").submit();
    }
}

function memberBack(){
	
	alert("memberBack ")
	location.href = "${path}/user/mypage.do";
	
}

</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />