<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<link href="${path}/resources/css/admin/orderManagement.css"
	rel="stylesheet">
<section class="container-fluid py-4">
    <div class="filter-card shadow-sm p-3 mb-4 bg-white rounded">
        <form action="${path}/admin/orderList.do" method="get">
            <div class="row align-items-center g-3">
                <div class="col-auto">
                    <span class="filter-label">결제일</span>
                </div>
                <div class="col-auto d-flex align-items-center gap-2">
                    <input type="date" name="startDate" class="form-control form-control-sm">
                    <span>~</span>
                    <input type="date" name="endDate" class="form-control form-control-sm">
                </div>
                <div class="col-auto ms-4">
                    <select class="form-select form-select-sm" name="searchType">
                        <option value="all">=검색조건=</option>
                        <option value="orderId">주문번호</option>
                        <option value="userName">주문자</option>
                    </select>
                </div>
                <div class="col-auto">
                    <input type="text" name="keyword" class="form-control form-control-sm" style="width:200px;">
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
                    <th style="width: 50px;"><input type="checkbox"></th>
                    <th>결제일</th>
                    <th>주문번호</th>
                    <th>주문자</th>
                    <th>상품명(대표)</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orderList}">
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>${order.paymentDate}</td>
                        <td>${order.orderIdx}</td>
                        <td>${order.userName}</td>
                        <td>${order.representativeProduct}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary" onclick="toggleDetail('${order.orderIdx}')">상세보기</button>
                        </td>
                    </tr>
                    <tr id="detail-${order.orderIdx}" class="detail-row" style="display:none;">
                        <td colspan="6" class="bg-light p-0">
                            <div class="detail-content p-4">
                                <table class="table table-sm table-bordered bg-white shadow-sm mb-0">
                                    <thead class="detail-thead">
                                        <tr>
                                            <th>상품명</th>
                                            <th>색상</th>
                                            <th>사이즈</th>
                                            <th>수량</th>
                                            <th>가격(할인포함)</th>
                                        </tr>
                                    </thead>
                                    <tbody id="items-${order.orderIdx}">
                                        </tbody>
                                </table>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <nav class="mt-4">
        <ul class="pagination justify-content-center custom-pagination">
            <li class="page-item"><a class="page-link gray" href="#">&laquo;&laquo; 처음</a></li>
            <li class="page-item"><a class="page-link gray" href="#">이전</a></li>
            <li class="page-item active"><a class="page-link" href="#">1</a></li>
            <li class="page-item"><a class="page-link" href="#">2</a></li>
            <li class="page-item"><a class="page-link" href="#">3</a></li>
            <li class="page-item"><a class="page-link" href="#">다음</a></li>
            <li class="page-item"><a class="page-link blue" href="#">마지막 &raquo;&raquo;</a></li>
        </ul>
    </nav>
</section>

<c:import url="/WEB-INF/view/include/bottom.jsp" />