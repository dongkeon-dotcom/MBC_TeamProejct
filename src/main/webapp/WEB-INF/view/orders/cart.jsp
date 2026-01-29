<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />


<section>
 
<html>
<head>
    <title>장바구니</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { text-align: center; }
        table { width: 80%; margin: 0 auto; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background: #f5f5f5; }
        .btn { padding: 8px 12px; background: #0077FF; color: white; border: none; cursor: pointer; }
        .btn:hover { background: #0055aa; }
    </style>
</head>
<body>
    <h1>장바구니</h1>

    <!-- 장바구니 테이블 -->
    <table>
        <tr>
            <th>상품명</th>
            <th>옵션</th>
            <th>수량</th>
            <th>가격</th>
            <th>삭제</th>
        </tr>
        
        <!-- JSTL로 장바구니 목록 출력 -->
        <c:forEach var="item" items="${cartList}">
            <tr>
                <td>${item.productName}</td>
                <td>${item.option}</td>
                <td>
                    <form action="${pageContext.request.contextPath}/cart/update.do" method="post">
                        <input type="hidden" name="id" value="${item.id}">
                        <input type="number" name="quantity" value="${item.quantity}" min="1">
                        <button type="submit" class="btn">변경</button>
                    </form>
                </td>
                <td>${item.price}원</td>
                <td>
                    <form action="${pageContext.request.contextPath}/cart/delete.do" method="post">
                        <input type="hidden" name="id" value="${item.id}">
                        <button type="submit" class="btn">삭제</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>


    <div style="text-align:center; margin-top:20px;">
        <form action="${pageContext.request.contextPath}/order/checkout.do" method="post">
            <button type="submit" class="btn">구매하기</button>
        </form>
    </div>
</body>
</html>

<script>
    
</script>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />