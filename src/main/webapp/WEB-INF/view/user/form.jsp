<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />


<section>
   
<br>
<div class="product-detail">
  <!-- 왼쪽: 상품 이미지 -->
  <div class="product-image">
    <img src="images/product01.jpg" alt="상품 이미지">
  </div>


  <!-- 오른쪽: 상품 정보 -->
  <div class="product-info">
    <h2 class="product-title">[브랜드] 상품명 예시</h2>
    <p class="product-price">₩39,900</p>

    <form class="product-form">
      <label for="color">색상 선택:</label>
      <select id="color" name="color">
        <option value="red">레드</option>
        <option value="blue">블루</option>
        <option value="black">블랙</option>
      </select>

      <label for="size">사이즈 선택:</label>
      <select id="size" name="size">
        <option value="S">S</option>
        <option value="M">M</option>
        <option value="L">L</option>
      </select>

      <label for="quantity">수량:</label>
      <input type="number" id="quantity" name="quantity" value="1" min="1">

      <div class="buttons">
        <button type="submit" class="btn-cart">장바구니 담기</button>
        <button type="button" class="btn-buy">바로 구매</button>
      </div>
    </form>
  </div>
</div>





<br>



<script >


 
    
    
</script>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />