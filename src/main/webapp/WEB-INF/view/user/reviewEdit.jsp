<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<section class="container mt-5">
    <div class="product-detail">
        <div align="center">
            <h2>상품 후기 수정</h2>
            <p>작성하신 후기를 수정하실 수 있습니다.</p>
            <br>
            
            <form action="${path}/user/reviewUpdate.do" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                <div style="color:red; font-size: 0.8em; margin-bottom: 10px;">
                    디버그용: 리뷰번호 - ${reviewVO.reviewIdx} / 주문번호 - ${orderIdx}
                </div>

                <input type="hidden" name="orderIdx" value="${orderIdx}">
                <input type="hidden" name="reviewIdx" value="${reviewVO.reviewIdx}">
                <input type="hidden" name="itemIdx" value="${reviewVO.itemIdx}">
                <input type="hidden" name="productIdx" value="${reviewVO.productIdx}">

                <table border="1" style="width: 80%; border-collapse: collapse; text-align: left;">
                    <colgroup>
                        <col style="width: 25%; background-color: #f9f9f9;">
                        <col style="width: 75%;">
                    </colgroup>
                    
                    <tr>
                        <td style="padding: 10px; text-align: center;">별점</td>
                        <td style="padding: 10px;">
                            <select name="rating" style="padding: 5px;"> 
                                <option value="5" ${reviewVO.rating == 5 ? 'selected' : ''}>★★★★★ (5점)</option>
                                <option value="4" ${reviewVO.rating == 4 ? 'selected' : ''}>★★★★☆ (4점)</option>
                                <option value="3" ${reviewVO.rating == 3 ? 'selected' : ''}>★★★☆☆ (3점)</option>
                                <option value="2" ${reviewVO.rating == 2 ? 'selected' : ''}>★★☆☆☆ (2점)</option>
                                <option value="1" ${reviewVO.rating == 1 ? 'selected' : ''}>★☆☆☆☆ (1점)</option>
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="padding: 10px; text-align: center;">후기 내용</td>
                        <td style="padding: 10px;">
                            <textarea name="review" rows="10" style="width: 95%; padding: 10px;" required>${reviewVO.review}</textarea>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="padding: 10px; text-align: center;">사진 수정 (최대 3장)</td>
                        <td style="padding: 10px;">
                            <c:if test="${not empty imgList}">
                                <div style="margin-bottom: 10px; color: #007bff;">
                                    <strong>[알림]</strong> 기존에 등록된 사진이 있습니다.
                                    <c:forEach var="img" items="${imgList}">
                                        <p style="font-size: 0.8em; margin-bottom: 2px;">📄 ${img.reviewImg}</p>
                                    </c:forEach>
                                </div>
                            </c:if>
                            
                            <input type="file" name="reviewFiles" id="reviewFiles" multiple accept="image/*">
                            <p style="font-size: 0.8em; color: #666; margin-top: 5px;">
                                * 새 파일을 선택하면 기존에 등록된 사진이 모두 교체됩니다.<br>
                                * 사진을 변경하지 않으려면 파일을 선택하지 마세요.<br>
                                * <strong>총 용량은 10MB를 초과할 수 없습니다.</strong>
                            </p>
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="2" align="center" style="padding: 20px;">
                            <button type="submit" style="padding: 10px 30px; cursor: pointer;">수정완료</button>
                            <button type="button" onclick="history.back()" style="padding: 10px 30px; cursor: pointer; margin-left: 10px;">취소</button>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
</section>

<br><br>

<script>
/**
 * 폼 제출 시 통합 유효성 검사 (개수 + 용량)
 */
function validateForm() {
    const fileInput = document.getElementById('reviewFiles');
    const files = fileInput.files;
    const maxCount = 3;
    const maxSize = 10 * 1024 * 1024; // 10MB 기준
    
    // 1. 파일 개수 체크
    if (files.length > maxCount) {
        alert("사진은 최대 " + maxCount + "장까지만 선택 가능합니다.");
        return false;
    }

    // 2. 파일 용량 체크
    let totalSize = 0;
    for (let i = 0; i < files.length; i++) {
        totalSize += files[i].size;
    }

    if (totalSize > maxSize) {
        alert("첨부파일 총 용량이 너무 큽니다.\n현재 용량: " + (totalSize / 1024 / 1024).toFixed(2) + "MB\n제한 용량: 10.00MB");
        return false;
    }

    return true;
}

// 파일 선택 시 실시간으로 용량 경고해주는 기능 (선택사항)
document.getElementById('reviewFiles').addEventListener('change', function() {
    const maxSize = 10 * 1024 * 1024;
    let totalSize = 0;
    for (let file of this.files) {
        totalSize += file.size;
    }
    if (totalSize > maxSize) {
        alert("선택하신 파일의 총 용량이 10MB를 넘습니다. 다른 파일을 선택해주세요.");
        this.value = ""; // 파일 선택 취소
    }
});
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />