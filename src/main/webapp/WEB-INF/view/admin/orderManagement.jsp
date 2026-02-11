<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<link href="${path}/resources/css/admin/orderManagement.css"
	rel="stylesheet">
<section class="container-fluid py-4">
    <div class="filter-card shadow-sm p-3 mb-4 bg-white rounded">
        <form action="${path}/admin/orderManagement.do" method="get">
            <div class="row align-items-center g-3">
                <div class="col-auto">
                    <span class="filter-label">결제일</span>
                </div>
                <div class="col-auto d-flex align-items-center gap-2">
                    <input type="date" name="startDate" value="${param.startDate}"  class="form-control form-control-sm">
                    <span>~</span>
                    <input type="date" name="endDate" value="${param.endDate}" class="form-control form-control-sm">
                </div>
                <div class="col-auto ms-4">
                    <select class="form-select form-select-sm" name="search">
                        <option value="orderId" ${param.search == 'orderId' ? 'selected' : '' }>주문번호</option>
                        <option value="userName" ${param.search == 'userName' ? 'selected' : '' }>주문자</option>
                    </select>
                </div>
                <div class="col-auto">
                    <input type="text" name="keyword" value="${param.keyword}" class="form-control form-control-sm" style="width:200px;">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-sm btn-dark">검색</button>
                </div>
            </div>
        </form>
    </div>

    <div class="table-container shadow-sm bg-white rounded">
        <table class="table table-hover align-middle mb-0">
            <thead>
                <tr>
                	<th>주문번호</th>
                    <th>상태</th>
                    <th>결제일</th>                    
                    <th>주문자</th>
                    <th>연락처</th>
                    <th>배송주소 (우편번호)</th>
                    <th>상품명</th>
                    <th>사이즈</th>
                    <th>컬러</th>
                    <th>수량</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orderList}">
                    <tr>
                    	<td>${order.orderIdx}-${order.itemIdx}</td>
                    	<td>
                        <c:choose>
                        	<c:when test="${order.status == 0}">
                        		<button type="button" class="btn btn-sm btn-outline-primary status-btn"
                        				data-idx="${order.itemIdx}" data-status="0">주문</button>                        	
                        	</c:when>
                        	<c:otherwise>
                        		<button type="button" class="btn btn-sm btn-success status-btn"
                        				data-idx="${order.itemIdx}" data-status="1">완료</button>
                        	</c:otherwise>
                        </c:choose>
                        </td>
                        <td>${order.orderDate}</td>                        
                        <td>${order.receiver}</td>
                        <td>${order.deliveryPhone}</td>
                        <td>${order.fullAddress}</td>
                        <td>${order.productName}</td>
                        <td>${order.size}</td>
                        <td>${order.color}</td>                        
                        <td>${order.quantity}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

	<nav aria-label="Page navigation" class="mt-4">
		<ul class="pagination justify-content-center">
			<c:url var="firstPageUrl" value="/admin/orderManagement.do">
				<c:param name="startIdx" value="0" />
				<c:param name="search" value="${search}" />
				<c:param name="keyword" value="${keyword}" />
			</c:url>
			<li class="page-item ${startIdx == 0 ? 'disabled' : ''}"><a
				class="page-link" href="${firstPageUrl}">&laquo;&laquo; 처음</a></li>

			<c:choose>
				<c:when test="${listStartPage > pageListSize}">
					<c:url var="beforePageUrl" value="/admin/orderManagement.do">
						<c:param name="startIdx"
							value="${(listStartPage - pageListSize - 1) * pageSize}" />
						<c:param name="search" value="${search}" />
						<c:param name="keyword" value="${keyword}" />
					</c:url>
					<li class="page-item"><a class="page-link"
						href="${beforePageUrl}">이전</a></li>
				</c:when>
				<c:otherwise>
					<li class="page-item disabled"><span class="page-link">이전</span></li>
				</c:otherwise>
			</c:choose>

			<c:forEach var="i" begin="${listStartPage}" end="${listEndPage}">
				<c:if test="${i <= totalPage}">
					<c:url var="forPageUrl" value="/admin/orderManagement.do">
						<c:param name="startIdx" value="${(i-1) * pageSize}" />
						<c:param name="search" value="${search}" />
						<c:param name="keyword" value="${keyword}" />
					</c:url>
					<li
						class="page-item ${i == (startIdx / pageSize + 1) ? 'active' : ''}">
						<a class="page-link" href="${forPageUrl}">${i}</a>
					</li>
				</c:if>
			</c:forEach>

			<c:choose>
				<c:when test="${listEndPage < totalPage}">
					<c:url var="afterPageUrl" value="/admin/orderManagement.do">
						<c:param name="startIdx" value="${listEndPage * pageSize}" />
						<c:param name="search" value="${search}" />
						<c:param name="keyword" value="${keyword}" />
					</c:url>
					<li class="page-item"><a class="page-link"
						href="${afterPageUrl}">다음</a></li>
				</c:when>
				<c:otherwise>
					<li class="page-item disabled"><span class="page-link">다음</span></li>
				</c:otherwise>
			</c:choose>

			<c:url var="endPageUrl" value="/admin/orderManagement.do">
				<c:param name="startIdx" value="${(totalPage-1) * pageSize}" />
				<c:param name="search" value="${search}" />
				<c:param name="keyword" value="${keyword}" />
			</c:url>
			<li
				class="page-item ${startIdx / pageSize + 1 == totalPage ? 'disabled' : ''}">
				<a class="page-link" href="${endPageUrl}">마지막 &raquo;&raquo;</a>
			</li>
		</ul>
	</nav>

</section>
<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script>
$(document).ready(function() {
    $('.status-btn').on('click', function() {
        const btn = $(this);
        const itemIdx = btn.data('idx');
        const currentStatus = btn.data('status');
        // 상태 전환: 0이면 1로, 1이면 0으로
        const nextStatus = currentStatus === 0 ? 1 : 0;

        if (!confirm('주문 상태를 변경하시겠습니까?')) return;
		
        const path = '${path}';
        
        $.ajax({
            url: path + '/admin/updateOrderStatus.do',
            type: 'POST',
            data: { 
            	itemIdx: itemIdx, 
                status: nextStatus 
            },
            success: function(response) {
                if(response === "success") {
                    // 성공 시 버튼 디자인 및 텍스트 즉시 변경
                    if (nextStatus === 1) {
                        btn.text('완료').removeClass('btn-outline-primary').addClass('btn-success').data('status', 1);
                    } else {
                        btn.text('주문').removeClass('btn-success').addClass('btn-outline-primary').data('status', 0);
                    }
                    alert('상태가 변경되었습니다.');
                } else {
                    alert('변경 실패: ' + response);
                }
            },
            error: function() {
                alert('서버 통신 오류가 발생했습니다.');
            }
        });
    });
});
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />