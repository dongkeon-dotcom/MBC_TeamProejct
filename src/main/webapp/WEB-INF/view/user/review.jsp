<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<section>
    <h3 style="text-align:center; margin-top:20px;">리뷰 폼</h3>
    <br>
    <div class="product-detail">
        <div align="center">
            <h2>상품 후기 작성</h2>
            <form action="${path}/user/reviewInsert.do" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                <input type="hidden" name="productIdx" value="${param.productIdx}">
                <input type="hidden" name="orderIdx" value="${param.orderIdx}">
                <input type="hidden" name="itemIdx" value="${param.itemIdx}">

                <table border="1" style="border-collapse: collapse; width: 500px;">
                    <tr>
                        <td style="padding:10px; text-align:center; background-color:#f9f9f9;">별점</td>
                        <td style="padding:10px;">
                            <select name="rating"> 
                                <option value="5">★★★★★ (5점)</option>
                                <option value="4">★★★★☆ (4점)</option>
                                <option value="3">★★★☆☆ (3점)</option>
                                <option value="2">★★☆☆☆ (2점)</option>
                                <option value="1">★☆☆☆☆ (1점)</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:10px; text-align:center; background-color:#f9f9f9;">후기 내용</td>
                        <td style="padding:10px;">
                            <textarea name="review" rows="10" cols="50" style="width:90%;" placeholder="상품 후기를 작성해주세요." required></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:10px; text-align:center; background-color:#f9f9f9;">사진 첨부 (최대 3장)</td>
                        <td style="padding:10px;">
                            <input type="file" name="reviewFiles" id="reviewFiles" multiple accept="image/*">
                            <p style="font-size: 0.8em; color: #666; margin-top: 5px;">
                                * 사진은 최대 3장, 총 용량 10MB까지 가능합니다.
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center" style="padding:15px;">
                            <button type="submit" style="padding:5px 20px; cursor:pointer;">저장하기</button>
                            <button type="button" onclick="history.back()" style="padding:5px 20px; cursor:pointer;">취소</button>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
</section>

<br>

<script>
/**
 * 폼 전송 시 개수와 용량을 모두 체크
 */
function validateForm() {
    const fileInput = document.getElementById('reviewFiles');
    const files = fileInput.files;
    const maxCount = 3;
    const maxSize = 10 * 1024 * 1024; // 10MB 바이트 환산
    
    // 1. 개수 체크
    if (files.length > maxCount) {
        alert("사진은 최대 " + maxCount + "장까지만 업로드 가능합니다.");
        return false;
    }

    // 2. 용량 체크
    let totalSize = 0;
    for (let i = 0; i < files.length; i++) {
        totalSize += files[i].size;
    }

    if (totalSize > maxSize) {
        alert("선택한 사진들의 총 용량이 10MB를 초과합니다.\n현재 용량: " + (totalSize / 1024 / 1024).toFixed(2) + "MB");
        return false;
    }

    return true;
}

/**
 * [실시간 체크] 파일 선택 즉시 용량이 너무 크면 알려줌
 */
document.getElementById('reviewFiles').addEventListener('change', function() {
    const maxSize = 10 * 1024 * 1024;
    let totalSize = 0;
    
    for (let file of this.files) {
        totalSize += file.size;
    }
    
    if (totalSize > maxSize) {
        alert("파일 용량이 너무 커서 선택할 수 없습니다. (최대 10MB)");
        this.value = ""; // 선택한 파일들 초기화
    }
});
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />