<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<section>
	<div align="center">
		<br>
		<h2>상품 등록목록</h2>

		<table border="1" width="1000">
			<tr>
				<th>제품번호</th>
				<th>카테고리</th>
				<th>하위카테고리</th>
				<th>제품명</th>
				<th>가격</th>
				<th>제품등록일</th>
				<th>제품설명</th>
				<th>대표이미지</th>
				<th>사이즈이미지</th>
				<th>할인률</th>
				<th>추천</th>
				<th>옵션</th>
			</tr>

			<c:forEach var="m" items="${li}">
				<tr>
					<td>${m.productIdx}</td>
					<td>${m.productCategory}</td>
					<td>${m.productSubCategory}</td>
					<td>${m.productName}</td>
					<td>${m.productPrice}</td>
					<td>${m.productRegDate}</td>
					<td>${m.productDesc}</td>
					<th>${getpMainImgPath}</th>
					<th></th>
					<td>${m.productDiscountPer}</td>
					<td>${m.productRecomm}</td>
					<td><c:forEach var="opt" items="${m.options}">
                            컬러: ${opt.optionColor}, 사이즈: ${opt.optionSize}, 재고: ${opt.productStock}<br />
						</c:forEach></td>
				</tr>
			</c:forEach>
		</table>

		<br>
	</div>
	<br>
</section>

<c:import url="/WEB-INF/view/include/bottom.jsp" />
