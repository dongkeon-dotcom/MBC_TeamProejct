<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<link href="${path}/resources/css/admin/userPurchaseDetail.css" rel="stylesheet">
<section>
	<div class="container-fluid py-4">
		<div class="table-container shadow-sm p-4 bg-white rounded">

			<div class="d-flex justify-content-between align-items-center mb-4">
				<div>
					<h5 class="mb-0">
						<strong>회원 번호:</strong> <span class="text-primary">${userInfo.userIdx}</span>
						<strong>이름:</strong> <span class="text-primary">${userInfo.userName}</span>
						<strong>전화 번호:</strong> <span class="text-primary">${userInfo.userPhone}</span>
					</h5>
				</div>
			</div>

			<div class="table-responsive">
				<table
					class="table table-hover table-bordered text-center align-middle">
					<thead class="table-light">
						<tr>
							<th>주문날짜</th>
							<th>주문번호</th>
							<th>배송 주소</th>
							<th>결제금액</th>
							<th>상세보기</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${not empty orderInfo}">
								<c:forEach var="m" items="${orderInfo}">
									<tr class="order-row">
										<td>${m.orderDate}</td>
										<td>${m.orderIdx}</td>
										<td>${m.address}</td>
										<td><fmt:formatNumber value="${m.totalPrice}" pattern="#,###"/>원</td>
										<td>
											<button type="button"
												class="btn btn-sm btn-outline-secondary"
												onclick="toggleDetail('${m.orderIdx}')">상세내역</button>
										</td>
									</tr>
									<tr id="detail-${m.orderIdx}" class="detail-row" style="display: none;">
					                    <td colspan="5">
					                        <div class="p-4 shadow-inner" style="background-color: #f8f9fa;">
					                        	<div style="max-width: 850px; margin: 0 auto;">
					                        	<table class="table table-sm table-bordered text-center bg-white mb-0">
					                        		<thead class="table-dark">
					                        		<tr>
					                        			<th>상품명</th>
					                        			<th>색상</th>
					                        			<th>사이즈</th>
					                        			<th>수량</th>
					                        			<th>가격(할인포함)</th>
					                        			<th>리뷰</th>
					                        			<th>별점</th>
					                        		</tr>
					                        		</thead>
					                        		<tbody id="content-${m.orderIdx}">
					                        		</tbody>
					                        	</table>
					                        	</div>
					                        </div>
					                    </td>
					                </tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="5" class="py-5 text-muted">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
			<div class="d-flex justify-content-center mt-4">
			    <button type="button" class="btn btn-secondary px-4" onclick="history.back();">뒤로가기</button>
			</div>
		</div>
	</div>
<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script>
function toggleDetail(orderIdx){
	const detailRow = $('#detail-' + orderIdx);
	const contentBox = $('#content-' + orderIdx);
	
	if(detailRow.is(':visible')){
		detailRow.hide();
		return; // 숨길때는 ajax 처리 안함
	} else {
		detailRow.show();
	}
	
	//이미 내용이 있다면 AJAX 실행 안 함
	if(contentBox.children().length > 0) return;
	
	const path = '${path}';
	
	$.ajax({
		type: "GET",
		url: path + "/admin/userDetailOrderItemsAjax.do",
		data: { orderIdx: orderIdx },
		dataType: "json",
		success: function(data){
			let html = "";
			if(data.length > 0){
				data.forEach(item =>{
					let formattedPrice = new Intl.NumberFormat().format(item.finalPrice) + "원";
					let reviewText = (item.review === null || item.review === undefined || item.review === "" ) ? "리뷰 없음" : item.review;
					let ratingText = (item.rating === null || item.rating === 0) ? "-" : item.rating;
					
					html += "<tr>";
					html += "	<td>" + item.productName + "</td>";
					html += "	<td>" + item.color + "</td>";
					html += "	<td>" + item.size + "</td>";
					html += "	<td>" + item.quantity + "</td>";
					html += "	<td>" + formattedPrice + "</td>";
					html += "	<td>" + reviewText + "</td>"
					html += "	<td>" + ratingText + "</td>"
					html += "</tr>";
				});
			} else{
				html = "<tr><td colspan='5' class='text-center'>상세 내역이 없습니다.</td></tr>";
			}
			contentBox.html(html);
		},
		error: function(){
			alert("상세 데이터를 가져오는 데 실패했습니다.");
		}
   });
}


</script>		
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />