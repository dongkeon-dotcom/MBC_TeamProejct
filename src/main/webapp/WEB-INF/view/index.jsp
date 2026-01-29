<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<link href="${path}/resources/css/main.css" rel="stylesheet">
<section>
	<br>
	<div align="center">


		<p>슬라이드 쇼 </p>
		
		<!-- 슬라이드 쇼 컨테이너 -->
		<div class="slideshow-container">

			<!-- 각 슬라이드 -->
			<div class="slide fade">
				<img src="resources/images/bgd_03.jpg" alt="슬라이드1">
			</div>

			<div class="slide fade">
				<img src="resources/images/br_01.jpg" alt="슬라이드2">
			</div>

			<div class="slide fade">
				<img src="resources/images/br_03.jpg" alt="슬라이드3">
			</div>

			<!-- 좌우 버튼 -->
			<a class="prev" onclick="plusSlides(-1)">&#10094;</a> <a class="next"
				onclick="plusSlides(1)">&#10095;</a>

		</div>

		<!-- 하단 점(네비게이션) -->
		<div class="dots">
			<span class="dot" onclick="currentSlide(1)"></span> <span class="dot"
				onclick="currentSlide(2)"></span> <span class="dot"
				onclick="currentSlide(3)"></span>
		</div>



	</div>
	
<script>
let slideIndex = 1;
showSlides(slideIndex);

// 좌우 버튼 제어
function plusSlides(n) {
  showSlides(slideIndex += n);
}

// 점 제어
function currentSlide(n) {
  showSlides(slideIndex = n);
}

// 슬라이드 표시 함수
function showSlides(n) {
  let slides = document.getElementsByClassName("slide");
  let dots = document.getElementsByClassName("dot");

  if (n > slides.length) { slideIndex = 1 }
  if (n < 1) { slideIndex = slides.length }

  for (let i = 0; i < slides.length; i++) {
    slides[i].style.display = "none";
  }
  for (let i = 0; i < dots.length; i++) {
    dots[i].className = dots[i].className.replace(" active", "");
  }

  slides[slideIndex-1].style.display = "block";
  dots[slideIndex-1].className += " active";
}

// 자동 슬라이드
let autoSlide = setInterval(() => plusSlides(1), 5000);

// 자동 슬라이드 멈추기 + 일정 시간 후 다시 시작
function pauseAutoSlide() {
  clearInterval(autoSlide);
  autoSlide = setInterval(() => plusSlides(1), 5000); // 다시 시작
}

// 이미지 클릭 시 이전/다음 이동 + 자동 슬라이드 잠깐 멈춤
document.querySelectorAll(".slide img").forEach(img => {
  img.addEventListener("click", (e) => {
    pauseAutoSlide();
    const half = img.clientWidth / 2;
    if (e.offsetX < half) {
      plusSlides(-1);
    } else {
      plusSlides(1);
    }
  });
});
</script>

<br>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />