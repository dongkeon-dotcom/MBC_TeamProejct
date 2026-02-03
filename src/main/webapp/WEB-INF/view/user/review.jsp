<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />


<section>
   <h3>리뷰 폼 </h3>
<br>
<div class="product-detail">

<!-- 사진  별점 받기 텍스트 박스작성완료버튼  -->


<section>
    <div align="center">
        <h2>상품 후기 작성</h2>
       <form action="${path}/user/reviewInsert.do" method="post" enctype="multipart/form-data" onsubmit="return checkFileCount()">
 <input type="hidden" name="productIdx" value="${param.productIdx}">
<input type="hidden" name="orderIdx" value="${param.orderIdx}">
           <table border="1">
        <tr>
            <td>별점</td>
            <td>
                <select name="rating"> 
                    <option value="5">★★★★★</option>
                    <option value="4">★★★★☆</option>
                    <option value="3">★★★☆☆</option>
                    <option value="2">★★☆☆☆</option>
                    <option value="1">★☆☆☆☆</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>후기 내용</td>
            <td>
                <textarea name="review" rows="10" cols="50" placeholder="상품 후기를 작성해주세요." required></textarea>
            </td>
        </tr>
        <tr>
            <td>사진 첨부 (최대 3장)</td>
            <td>
                <input type="file" name="reviewFiles" id="reviewFiles" multiple accept="image/*">
            </td>
        </tr>
                <tr>
                    <td colspan="2" align="center">
                        <button type="submit">저장하기</button>
                        <button type="button" onclick="history.back()">취소</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</section>


</div>





<br>

<script>
function checkFileCount() {
    const fileInput = document.getElementById('reviewFiles');
    if (fileInput.files.length > 3) {
        alert("사진은 최대 3장까지만 선택 가능합니다.");
        return false;
    }
    return true;
}

</script>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />