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
                    <td><input type="checkbox" class="form-check-input item-check" value="10001"></td>
                    <td>${m.productIdx}</td>
                    <td>${m.productName}</td>
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

            <nav>
            
            <!-- paging 처음 생성 -->
            <c:url var = "fisrtPageUrl" value="${path}/product/adminProductList.do">
            	<c:param name="startIdx" value="0"/>
            	<c:param name="search" value="${search}"/>
            	<c:param name="keyword" value="${keyword }"/>            	            
            </c:url>
            <a href="${fisrtPageUrl}">처음</a>&emsp;
            
            <!-- paging 이전 목록 생성 -->
            <c:if test="${listStartPage <= pageListSize }">
            	이전 &emsp;
            </c:if>
            <c:if test="${listStartPage > pageListSize }">
            <c:url var = "beforePageUrl" value ="${path}/product/adminProductList.do">
            	<c:param name="startIdx" value="${(listStartPage-pageListSize-1) * pageSize }" />
            	<c:param name="search" value="${search }"/>
            	<c:param name="keyword" value="${keyword }"/>
            </c:url>
            	<a href="${beforePageUrl }">이전</a> &emsp;
            </c:if>
            
            <!-- paging 번호 for문 생성 -->
            <c:forEach var="i" begin="${listStartPage }" end="${listEndPage }">
            <c:if test="${i <totalPage }">
            	<c:url var ="forPageUrl" value="${path}/product/adminProductList.do">
            		<c:param name="startIdx" value="${(i-1)*pageSize}"/>
            		<c:param name="search" value="${search }"/>
            		<c:param name="keyword" value="${keyword }"/>
            	</c:url>
            	<a href="${forPageUrl }">[${i}]</a>
            </c:if>            
            </c:forEach>
            
            <!-- paging 다음 목록 생성 -->
            <c:if test="${listEndPage < totalPage }">
            <c:url var = "afterPageUrl" value ="${path}/product/adminProductList.do">
            	<c:param name="startIdx" value="${listEndPage * pageSize }" />
            	<c:param name="search" value="${search }"/>
            	<c:param name="keyword" value="${keyword }"/>
            </c:url>
            	<a href="${afterPageUrl }">다음</a> &emsp;
            </c:if>
            <c:if test="${listEndPage >= totalPage }">
            	다음 &emsp;
            </c:if>
            
            <!-- paging 마지막 생성 -->
            <c:url var = "endPageUrl" value="${path}/product/adminProductList.do">
            	<c:param name="startIdx" value="${(totalPage-1)*pageSize }"/>
            	<c:param name="search" value="${search}"/>
            	<c:param name="keyword" value="${keyword }"/>            	            
            </c:url>
            <a href="${endPageUrl}">마지막</a>&emsp;
            
            
                <ul class="pagination">
                    <li class="page-item"><a class="page-link" href="#">1</a></li>
                    <li class="page-item active"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                </ul>
            </nav>
        </div>
    </div>
</div>

<script>

window.onload = function() {

	// 1. 오늘 날짜 가져오기
	const today = new Date();
	const lastMonth = new Date();
    // 2. YYYY-MM-DD 형식으로 변환
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 +1
    const dd = String(today.getDate()).padStart(2, '0');
    
    const formattedToday = `${yyyy}-${mm}-${dd}`;
    
    lastMonth.setMonth(today.getMonth() - 1);
    const startM = String(lastMonth.getMonth() + 1).padStart(2, '0');

 // 3. input 태그에 값 할당
    document.getElementById('startDate').value = `${yyyy}-${startM}-${dd}`;  
    document.getElementById('endDate').value = formattedToday;
};

document.getElementById('bulkAction').addEventListener('change', function() {
    const action = this.value;
    const bulkInput = document.getElementById('bulkInput');
    const bulkUnit = document.getElementById('bulkUnit');

    if (action === 'sale') {
        // '세일'일 때만 보임
    	bulkInput.classList.remove('d-none');
        bulkUnit.classList.remove('d-none');
    } else {
        // '추천'이나 '해제'일 때는 숨김
    	bulkInput.classList.add('d-none');
        bulkUnit.classList.add('d-none');
    }
});

document.addEventListener('DOMContentLoaded', function() {
    const selectAllCheck = document.getElementById('selectAll');
    const itemChecks = document.querySelectorAll('.item-check');
    const applyBtn = document.getElementById('applyBulkAction');

    // 1. 전체 선택/해제 로직
    selectAllCheck.addEventListener('change', function() {
        itemChecks.forEach(cb => {
            cb.checked = this.checked;
        });
    });

    // 2. 적용 버튼 클릭 시 (체크된 항목 수집)
    applyBtn.addEventListener('click', function() {
        const selectedIds = [];
        itemChecks.forEach(cb => {
            if (cb.checked) {
                // 체크박스의 value에 상품 ID가 담겨있다고 가정
                selectedIds.push(cb.value);
            }
        });

        if (selectedIds.length === 0) {
            alert('적용할 상품을 선택해주세요.');
            return;
        }

        const action = document.getElementById('bulkAction').value;
        console.log("선택된 ID들:", selectedIds);
        console.log("수행할 작업:", action);
        
        // 여기서 fetch나 $.ajax를 이용해 서버로 데이터를 보냅니다.
        alert(selectedIds.length + '개의 항목에 [' + action + '] 기능을 적용합니다.');
    });
});
</script>



</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />