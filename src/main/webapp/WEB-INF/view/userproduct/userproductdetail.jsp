<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<link href="${path}/resources/css/userproductdetail.css" rel="stylesheet">

<label for="option">옵션 선택:</label>
<select name="optionIdx" id="option" required>
    <c:forEach var="opt" items="${optionList}">
        <option value="${opt.optionIdx}" 
                <c:if test="${opt.stock == 0}">disabled</c:if>>
            ${opt.optionName} - ${opt.optionValue}
            <c:choose>
                <c:when test="${opt.stock > 0}">
                    (재고: ${opt.stock})
                </c:when>
                <c:otherwise>
                    [품절]
                </c:otherwise>
            </c:choose>
        </option>
    </c:forEach>
</select>

<label for="qty">수량:</label>
<input type="number" name="quantity" id="qty" value="1" min="1"/>
<button type="submit">장바구니 담기</button>


<br>
<c:import url="/WEB-INF/view/include/bottom.jsp" />
