<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<section>
	<div align="center">
        <br>
		<H2>회원 목록보기 </H2>

		<table border=1 width=1000>
			<tr>
				<td>번호</td>
				<td>이메일(아이디)</td>
				<td>이름</td>
				<td>전화번호</td>
				<td>주소</td>
				<td>상세주소</td>
				<td>권한</td>
				<td>나이</td>
				<td>생선일</td>
				

			</tr>
			<c:forEach var="m" items="${li}">
				<tr>
					<td>${m.uidx}</td>
					<td>${m.user_id}</td>
					<td>${m.name}</td>
					<td>${m.tel}</td>
					<td>${m.address}</td>
					<td>${m.addressExtra}</td>

					<td>${m.role}</td>
					<td>${m.age}</td>
					<td>${m.createdate}</td>
					
					
				</tr>
			</c:forEach>
		</table>
	
		<br>
	</div>
	<br>
</section>

<c:import url="/WEB-INF/view/include/bottom.jsp" />