<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<!--  <link href="${path}/resources/product/test.css" rel="stylesheet">-->

<html>
<head>
<title>상품 등록</title>
<!-- 외부 JS 파일 불러오기 -->
<script src="${path}/resources/js/productForm.js">   </script>
<script src="${path}/resources/js/productOption.js"> </script>

</head>
<body>
	<div align="center">
		        <h2>상품 등록</h2>
        <form action="${path}/product/formOK.do" method="post" enctype="multipart/form-data">

            <!-- 상품 기본 정보 -->
            <table border="1">
                <tr>
                    <td>카테고리</td>
                    <td>
                        <select name="productCategory" id="productCategory" onchange="updateSubCategories()">
                            <option value="">-- 카테고리 선택 --</option>
                            <option value="아우터">아우터</option>
                            <option value="상의">상의</option>
                            <option value="바지">바지</option>
                            <option value="치마">치마</option>
                            <option value="원피스">원피스</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>하위카테고리</td>
                    <td>
                        <select name="productSubCategory" id="productSubCategory">
                            <option value="">-- 하위 카테고리 선택 --</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>제품명</td>
                    <td><input type="text" name="productName"></td>
                </tr>
                <tr>
                    <td>가격</td>
                    <td><input type="number" name="productPrice"></td>
                </tr>
                <tr>
                    <td>제품설명</td>
                    <td><textarea name="productDesc" rows="4" cols="40"></textarea></td>
                </tr>
                <tr>
                    <td>제품할인률</td>
                    <td><input type="text" name="productDiscountPer"></td>
                </tr>
                <tr>
                    <td>제품추천</td>
                    <td><input type="text" name="productRecomm"></td>
                </tr>
                <tr>
                    <td>이미지 업로드</td>
                    <td><input type="file" name="files" multiple></td>
                </tr>
            </table>

			<!-- 옵션 입력 테이블 -->
			<h3>상품 옵션</h3>
			<table id="optionTable" border="1">
				<tr>
					<th>컬러</th>
					<th>사이즈</th>
					<th>재고</th>
					<th>삭제</th>
				</tr>
				<tr> 
					<td><select name="options[0].optionColor">
							<option value="Black">Black</option>
							<option value="White">White</option>
							<option value="Red">Red</option>
							<option value="Blue">Blue</option>
							<option value="orange">orange</option>
							<option value="green">green</option>
							<option value="navy">navy</option>
							<option value="yellow">yellow</option>
							
							
					</select></td>
					<td><select name="options[0].optionSize">
							<option value="S">S</option>
							<option value="M">M</option>
							<option value="L">L</option>
							<option value="XL">XL</option>
					</select></td>
					<td><input type="number" name="options[0].productStock"
						value="0" /></td>
					<td><button type="button" onclick="deleteRow(this)">삭제</button></td>
				</tr>
			</table>
			<button type="button" onclick="addOptionRow()">+ 옵션 추가</button>



			<!-- 등록 버튼 -->
            <br/><br/>
            <input type="submit" value="등록" />
        </form>
    </div>
</body>
</html>

<c:import url="/WEB-INF/view/include/bottom.jsp" />