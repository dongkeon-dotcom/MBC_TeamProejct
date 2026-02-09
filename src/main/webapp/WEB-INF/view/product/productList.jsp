<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<link href="${path}/resources/css/product/adminProductList.css" rel="stylesheet">

<section>

<div class="container-fluid">
    <div class="table-container shadow-sm mt-4">
        
        <div class="d-flex justify-content-between mb-3">
            <form action="${path}/product/adminProductList.do" class="d-flex gap-2" >
                <select class="form-select search-select" name=search>
                    <option value="code">제품코드</option>
                    <option value="name">제품이름</option>
                </select>
                <input type="text" class="form-control" style="width: 200px;" name=keyword>
                <button type=submit class="btn btn-secondary">검색하기</button>
            </form>
        </div>

        <table class="table table-bordered text-center align-middle">
            <thead>
                <tr>
                    <th><input type="checkbox" id="selectAll" class="form-check-input"></th>
                    <th>제품코드</th>
                    <th>제품이름</th>
                    <th>추천유무</th>
                    <th>할인정보</th>
                    <th>카테고리</th>
                    <th>가격</th>
                    <th>메인이미지</th>
                    <th>등록일</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach var="m" items="${li}">
                <tr>
                    <td><input type="checkbox" class="form-check-input item-check" value="${m.productIdx}"></td>
                    <td>${m.productIdx}</td>
                    <td>
                    <a href="${path}/product/adminProductEdit.do?productIdx=${m.productIdx}">
                    ${m.productName}
                    </a>
                    </td>
                    <td>${m.recommended ? "추천" : "보통"}</td>
                    <td>${m.discountRate}</td>
                    <td>${m.category}</td>                    
                    <td>${m.price}</td>
                    <td><img src="${path}/resources/images/ProductMainImg/${m.productMainImg}" width=50 height=50 ></td>
                    <td>${m.regDate}</td>
                </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="d-flex justify-content-between align-items-start mt-4">
            <div class="card bulk-action-card p-3 shadow-sm" style="width: fit-content;">
                <p class="small fw-bold mb-2">선택 상품에 대해:</p>
                <div class="input-group">
                    <select class="form-select" id="bulkAction" style="max-width: 120px;">
                        <option value="sale">세일</option>
                        <option value="recommend">추천</option>
                        <option value="reset">해제</option>
                    </select>
                    	<input type="number" class="form-control" id="bulkInput" value="0" style="max-width: 100px;">
                    	<span class="input-group-text" id="bulkUnit">%</span>
                    <button class="btn btn-primary" id="applyBulkAction">적용</button>
                </div>
            </div>

		<nav aria-label="Page navigation">
		    <ul class="pagination justify-content-center">
				<!-- paging 처음 생성 -->
		        <c:url var="firstPageUrl" value="/product/adminProductList.do">
		            <c:param name="startIdx" value="0"/>
		            <c:param name="search" value="${search}"/>
		            <c:param name="keyword" value="${keyword}"/>
		        </c:url>
		        <li class="page-item">
		            <a class="page-link" href="${firstPageUrl}" aria-label="First">
		                <span aria-hidden="true">&laquo;&laquo; 처음</span>
		            </a>
		        </li>
		
		        <c:choose>
		            <c:when test="${listStartPage > pageListSize}">
		                <c:url var="beforePageUrl" value="/product/adminProductList.do">
		                    <c:param name="startIdx" value="${(listStartPage - pageListSize - 1) * pageSize}" />
		                    <c:param name="search" value="${search}"/>
		                    <c:param name="keyword" value="${keyword}"/>
		                </c:url>
		                <li class="page-item">
		                    <a class="page-link" href="${beforePageUrl}">이전</a>
		                </li>
		            </c:when>
		            <c:otherwise>
		                <li class="page-item disabled"><span class="page-link">이전</span></li>
		            </c:otherwise>
		        </c:choose>
		
		        <c:forEach var="i" begin="${listStartPage}" end="${listEndPage}">
		            <c:if test="${i <= totalPage}"> <c:url var="forPageUrl" value="/product/adminProductList.do">
		                    <c:param name="startIdx" value="${(i-1) * pageSize}"/>
		                    <c:param name="search" value="${search}"/>
		                    <c:param name="keyword" value="${keyword}"/>
		                </c:url>
						<li class="page-item ${i == (startIdx / pageSize + 1) ? 'active' : ''}">
            				<a class="page-link" href="${forPageUrl}">${i}</a>
        				</li>
		            </c:if>
		        </c:forEach>
		
		        <c:choose>
		            <c:when test="${listEndPage < totalPage}">
		                <c:url var="afterPageUrl" value="/product/adminProductList.do">
		                    <c:param name="startIdx" value="${listEndPage * pageSize}" />
		                    <c:param name="search" value="${search}"/>
		                    <c:param name="keyword" value="${keyword}"/>
		                </c:url>
		                <li class="page-item">
		                    <a class="page-link" href="${afterPageUrl}">다음</a>
		                </li>
		            </c:when>
		            <c:otherwise>
		                <li class="page-item disabled"><span class="page-link">다음</span></li>
		            </c:otherwise>
		        </c:choose>
		
		        <c:url var="endPageUrl" value="/product/adminProductList.do">
		            <c:param name="startIdx" value="${(totalPage-1) * pageSize}"/>
		            <c:param name="search" value="${search}"/>
		            <c:param name="keyword" value="${keyword}"/>
		        </c:url>
		        <li class="page-item">
		            <a class="page-link" href="${endPageUrl}" aria-label="Last">
		                <span aria-hidden="true">마지막 &raquo;&raquo;</span>
		            </a>
		        </li>
		
		    </ul>
		</nav>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // 0. jQuery 존재 여부 확인 (에러 방지)
    if (typeof $ === 'undefined') {
        console.error('jQuery가 로드되지 않았습니다. top.jsp에 jQuery CDN이 있는지 확인하세요.');
        return;
    }

    const selectAllCheck = document.getElementById('selectAll');
    const applyBtn = document.getElementById('applyBulkAction');
    const bulkActionSelect = document.getElementById('bulkAction');
    const bulkInput = $('#bulkInput');
    const bulkUnit = $('#bulkUnit');

    // 1. 선택 박스 변경 시 세일 입력창 UI 제어
    // 초기 상태 설정 (페이지 로드 시 세일이 아니면 숨김)
    if (bulkActionSelect.value !== 'sale') {
        bulkInput.addClass('d-none');
        bulkUnit.addClass('d-none');
    }

    bulkActionSelect.addEventListener('change', function() {
        if (this.value === 'sale') {
            bulkInput.removeClass('d-none');
            bulkUnit.removeClass('d-none');
        } else {
            bulkInput.addClass('d-none');
            bulkUnit.addClass('d-none');
        }
    });

    // 2. 전체 선택/해제 로직
    if (selectAllCheck) {
        $(selectAllCheck).on('change', function() {
            $('.item-check').prop('checked', this.checked);
        });
    }

    // 3. 적용 버튼 클릭 시 (AJAX 통신)
    applyBtn.addEventListener('click', function() {
        const selectedIds = [];
        
        $('.item-check:checked').each(function() {
            selectedIds.push($(this).val());
        });

        if (selectedIds.length === 0) {
            alert('변경할 상품을 선택해주세요.');
            return;
        }

        const action = $('#bulkAction').val(); 
        let actionColumn = "";
        let actionValue = 0;
        
        // ✨ 변수 오타 수정 완료: action 값에 따라 분기
        if (action === 'recommend') {
            actionColumn = 'is_recommended';
            actionValue = 1;
        }
        else if (action === 'reset') {
            actionColumn = 'is_recommended';
            actionValue = 0;
        }
        else if (action === 'sale') {
            actionColumn = 'sale';
            actionValue = bulkInput.val();
            if (actionValue === "" || actionValue < 0) {
                alert("유효한 세일 값을 입력해주세요.");
                return;
            }
        }
		var path = '${path}';
        if (confirm(selectedIds.length + "개의 항목을 변경하시겠습니까?")) {
            $.ajax({
                type: 'POST',
                url: path + '/product/adminUpdateStatus.do',                
                traditional: true, 
                data: {
                    'productIdxs': selectedIds,
                    'productStatus': actionColumn,
                    'productStatusValue': actionValue
                },
                success: function(result) {
                    if (result === "T") {
                        alert('성공적으로 변경되었습니다.');
                        location.reload();
                    } else {
                        alert('변경 중 오류가 발생했습니다.');
                    }
                },
                error: function(xhr, status, error) {
                    alert('저장 실패: ' + status + '(' + error + ')');
                }
            });
        }
    });
});
</script>



</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />