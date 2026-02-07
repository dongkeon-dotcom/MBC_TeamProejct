<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<link href="${path}/resources/css/admin/userManagement.css" rel="stylesheet">

<section>
    <div class="container-fluid py-4">
        <div class="table-container shadow-sm p-4 bg-white rounded">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h5 class="mb-0"><strong>총 회원 수:</strong> <span class="text-primary">${totalCount}</span>명</h5>
                </div>
                <form action="${path}/admin/userManagement.do" class="d-flex gap-2">
                    <select class="form-select search-select" name="search" style="width: 110px;">
                        <option value="name" ${search == 'name' ? 'selected' : ''}>이름</option>
                        <option value="id" ${search == 'id' ? 'selected' : ''}>이메일</option>
                        <option value="code" ${search == 'code' ? 'selected' : ''}>번호</option>
                    </select>
                    <input type="text" class="form-control" style="width: 250px;" name="keyword" value="${keyword}" placeholder="검색어를 입력하세요">
                    <button type="submit" class="btn btn-dark">검색</button>
                </form>
            </div>
            
            <div class="table-responsive">
                <table class="table table-hover table-bordered text-center align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>가입일</th>
                            <th>회원번호</th>
                            <th>이메일</th>
                            <th>전화번호</th>
                            <th>이름</th>
                            <th>주소(대표)</th>
                            <th>누적 구매금액</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty li}">
                                <c:forEach var="m" items="${li}">
                                    <tr>
                                        <td>${m.regDate}</td>
                                        <td>${m.userIdx}</td>
                                        <td>${m.id}</td>
                                        <td>${m.userPhone}</td>
                                        <td>${m.userName}</td>
                                        <td>${m.fullAddress}</td>
                                        <td>
                                        	<fmt:formatNumber value="${m.totalSpent}" pattern="#,###" />원
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-outline-secondary">이력</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="py-5 text-muted">데이터가 존재하지 않습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <nav aria-label="Page navigation" class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:url var="firstPageUrl" value="/admin/userManagement.do">
                        <c:param name="startIdx" value="0"/>
                        <c:param name="search" value="${search}"/>
                        <c:param name="keyword" value="${keyword}"/>
                    </c:url>
                    <li class="page-item ${startIdx == 0 ? 'disabled' : ''}">
                        <a class="page-link" href="${firstPageUrl}">&laquo;&laquo; 처음</a>
                    </li>
            
                    <c:choose>
                        <c:when test="${listStartPage > pageListSize}">
                            <c:url var="beforePageUrl" value="/admin/userManagement.do">
                                <c:param name="startIdx" value="${(listStartPage - pageListSize - 1) * pageSize}" />
                                <c:param name="search" value="${search}"/>
                                <c:param name="keyword" value="${keyword}"/>
                            </c:url>
                            <li class="page-item"><a class="page-link" href="${beforePageUrl}">이전</a></li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled"><span class="page-link">이전</span></li>
                        </c:otherwise>
                    </c:choose>
            
                    <c:forEach var="i" begin="${listStartPage}" end="${listEndPage}">
                        <c:if test="${i <= totalPage}">
                            <c:url var="forPageUrl" value="/admin/userManagement.do">
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
                            <c:url var="afterPageUrl" value="/admin/userManagement.do">
                                <c:param name="startIdx" value="${listEndPage * pageSize}" />
                                <c:param name="search" value="${search}"/>
                                <c:param name="keyword" value="${keyword}"/>
                            </c:url>
                            <li class="page-item"><a class="page-link" href="${afterPageUrl}">다음</a></li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled"><span class="page-link">다음</span></li>
                        </c:otherwise>
                    </c:choose>
            
                    <c:url var="endPageUrl" value="/admin/userManagement.do">
                        <c:param name="startIdx" value="${(totalPage-1) * pageSize}"/>
                        <c:param name="search" value="${search}"/>
                        <c:param name="keyword" value="${keyword}"/>
                    </c:url>
                    <li class="page-item ${startIdx / pageSize + 1 == totalPage ? 'disabled' : ''}">
                        <a class="page-link" href="${endPageUrl}">마지막 &raquo;&raquo;</a>
                    </li>
                </ul>
            </nav>
        </div> </div> </section>

<c:import url="/WEB-INF/view/include/bottom.jsp" />