<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<link href="${path}/resources/css/user/review.css" rel="stylesheet">

<section class="review-wrapper"> <div class="product-detail">
        <div align="center">
            <h2>상품 후기 작성 </h2>

            
            <form action="${path}/user/reviewInsert.do" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
              <input type="hidden" name="orderIdx" value="${not empty orderIdx ? orderIdx : reviewVO.orderIdx}">
<input type="hidden" name="reviewIdx" value="${not empty reviewVO.reviewIdx ? reviewVO.reviewIdx : 0}">
<input type="hidden" name="itemIdx" value="${not empty itemIdx ? itemIdx : reviewVO.itemIdx}">
<input type="hidden" name="productIdx" value="${not empty productIdx ? productIdx : reviewVO.productIdx}">

                <table class="review-table"> <tr>
                        <td class="label-cell">별점</td> <td>
                            <select name="rating"> 
                                <option value="5" ${reviewVO.rating == 5 ? 'selected' : ''}>★★★★★ (5점)</option>
                                <option value="4" ${reviewVO.rating == 4 ? 'selected' : ''}>★★★★☆ (4점)</option>
                                <option value="3" ${reviewVO.rating == 3 ? 'selected' : ''}>★★★☆☆ (3점)</option>
                                <option value="2" ${reviewVO.rating == 2 ? 'selected' : ''}>★★☆☆☆ (2점)</option>
                                <option value="1" ${reviewVO.rating == 1 ? 'selected' : ''}>★☆☆☆☆ (1점)</option>
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="label-cell">후기 내용</td>
                        <td>
                            <textarea name="review" rows="10" required>${reviewVO.review}</textarea>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="label-cell">사진 수정<br><span style="font-weight:normal; font-size:11px;">(최대 3장)</span></td>
                        <td>
                            <c:if test="${not empty imgList}">
                                <div style="margin-bottom: 12px; padding: 10px; background-color: #eef6ff; border-radius: 4px;">
                                    <strong style="color: #0d6efd; font-size: 13px;">[알림] 기존에 등록된 사진:</strong>
                                    <c:forEach var="img" items="${imgList}">
                                        <p style="font-size: 12px; margin: 4px 0; color: #444;">📄 ${img.reviewImg}</p>
                                    </c:forEach>
                                </div>
                            </c:if>
                            
                            <input type="file" name="reviewFiles" id="reviewFiles" multiple accept="image/*">
                            <span class="file-note">
                                * 새 파일을 선택하면 기존 사진이 모두 교체됩니다.<br>
                                * 변경하지 않으려면 파일을 선택하지 마세요. (최대 10MB)
                            </span>
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="2" class="button-group"> <button type="submit" class="btn-save">작성완료</button>
                            <button type="button" onclick="history.back()" class="btn-cancel">취소</button>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
</section>
<br>

<script>
/**폼 전송 시 개수와 용량을 모두 체크**/
function validateForm() {
    const fileInput = document.getElementById('reviewFiles');
    const files = fileInput.files;
    const maxCount = 3;
    const maxSize = 10 * 1024 * 1024; // 10MB 바이트로 제한두기 
    

    if (files.length > maxCount) {
        alert("사진은 최대 " + maxCount + "장까지만 업로드 가능합니다.");
        return false;
    }

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