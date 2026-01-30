<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />




  <html lang="ko">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CSS Grid Layout</title>
    <style>      
      .gallery{
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(160px,1fr)); /* 크기조절 */
        grid-gap:1rem;   
      }

      .gallery img{
          width: 100%;   /* 그리드 칸의 가로폭을 꽉 채움 */
          height: 250px;
          display: block; /* 이미지 밑에 여백 제거 */
      }
    </style>
  </head>
  <body>
  
  
    <div class="gallery">
   		
   		
      <div class="card">
      <a href="${path}/userproductdetail.do?productIdx=${p.productIdx}">
      <img class="photo1" src="images/photo-1.jpg"  >
      </a>
      <div> 사진설명 1 </div>
      <div> 가격: 100만원 </div>
      </div>
      
      <div class="card">
        <img class="photo2" src="images/photo-2.jpg" >
        <div> 사진설명 2 </div>
        
      </div>
      
      
      <div class="card">
        <img class="photo3" src="images/photo-3.jpg" >
      </div>
      <div class="card">
        <img class="photo4" src="images/photo-4.jpg" >
      </div>
      <div class="card">
        <img class="photo5" src="images/photo-5.jpg" >
      </div>
      <div class="card">
        <img class="photo6" src="images/photo-6.jpg" >
      </div>
      <div class="card">
        <img class="photo5" src="images/photo-5.jpg" >
      </div>
      <div class="card">
        <img class="photo6" src="images/photo-6.jpg" >
      </div>
      
    </div>
  </body>
  </html>
  
  
<c:import url="/WEB-INF/view/include/bottom.jsp" />
