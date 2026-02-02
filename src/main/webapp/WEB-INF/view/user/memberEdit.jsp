<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<section>
	<br>
	<div align="center">
		<h1>개인 회원 정보 수정</h1>

		<!-- action은 컨트롤러 매핑에 맞게 수정 -->
		<form action="${path}/member/update.do" method="POST">

			<!-- hidden 값 -->
			<input type="hidden" name="idx" value="${m.idx}">


			<table border="1">
				<tr>
					<td>이메일</td>
					<td><input type="text" name="username" value="${m.username}"
						readonly></td>
				</tr>

				<tr>
					<td>암호</td>
					<td><input type="text" name="password" id="password"
						placeholder="비밀번호를 입력하세요" minlength="4" maxlength="20" required>
					</td>
				</tr>

				<tr>
					<td>회원 이름</td>
					<td><input type="text" name="name" value="${m.name}"></td>
				</tr>



				<tr>
					<td>전화번호</td>
					<td><input type="text" name="tel" value="${m.tel}"></td>
				</tr>


				<tr>
					<td>주소</td>
					<td><input type="text" name="postcode" value="${m.postcode}"
						placeholder="우편번호"></td>
				</tr>

			</table>
		</form>
	</div>
</section>


<c:import url="/WEB-INF/view/include/bottom.jsp" />