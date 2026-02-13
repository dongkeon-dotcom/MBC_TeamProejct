<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />

<link href="${path}/resources/css/delivery/delivery.css" rel="stylesheet">
<!-- 커스터머 주소목록 관리    -->

<section class="address-wrapper">
    <div align="center">
        <h3>주소 관리</h3>

        <table class="address-table"> 
            <thead>
                <tr> 
                    <th><input type="checkbox" id="selectAll" onclick="toggleSelectAll()"></th> 
                    <th>배송지명</th>
                    <th>기본배송</th> 
                    <th>수령인</th> 
                    <th>전화번호</th> 
                    <th style="width: 40%;">주소</th> 
                    <th>삭제</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="m" items="${addressList}" varStatus="status">
                <tr> 
                    <td>
                        <input type="checkbox" name="selectedIdx" value="${m.deliveryIdx}" class="chk">
                    </td>
                    <td class="fw-bold">${m.deliveryName}</td>
                    <td>
                        <c:if test="${m.defaultAddress}">
                            <span class="badge-default">[기본]</span>
                        </c:if>
                    </td>
                    <td>${m.receiver}</td> 
                    <td>${m.deliveryPhone}</td> 
                    <td class="addr-text">
                       <a href="${path}/delivery/addrEdit.do?deliveryIdx=${m.deliveryIdx}">
                           (${m.zipcode}) ${m.address} ${m.extraAddress}
                       </a>
                    </td> 
                    <td>
                        <button type="button" class="btn-del-sm" onClick="addressDel('${m.deliveryIdx}')">삭제</button>
                    </td>
                </tr>
                </c:forEach>
                
                <c:if test="${empty addressList}">
                    <tr>
                        <td colspan="7" style="padding: 100px 0; color: #999;">등록된 배송지가 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <div class="addr-actions">
            <button type="button" class="btn-addr-sub" onclick="setDefaultAddr()">기본배송지로 설정</button>
            <button type="button" class="btn-addr-sub" onclick="addrDel()">선택 삭제</button> 
            <button type="button" class="btn-addr-main" onclick="AddADDR()">+ 새 주소 추가</button>
        </div>
    </div>
</section>
<script>

function setDefaultAddr() {
    const checkedBoxes = document.querySelectorAll('.chk:checked');
    
    // 1. 유효성 검사
    if(checkedBoxes.length === 0) {
        alert("기본 배송지로 설정할 주소를 선택해주세요.");
        return;
    }
    if(checkedBoxes.length > 1) {
        alert("기본 배송지는 하나만 선택 가능합니다.");
        return;
    }
    
    const deliveryIdx = checkedBoxes[0].value;
    
    if(confirm("이 주소를 기본 배송지로 설정하시겠습니까?")) {
        // 컨트롤러로 이동
        location.href = "${path}/delivery/setDefaultAddress.do?deliveryIdx=" + deliveryIdx;
    }
}


function AddADDR() {
     // 팝업창의 가로, 세로 크기 및 위치 설정
    var width = 500;
    var height = 600;
    var left = (window.screen.width / 2) - (width / 2);
    var top = (window.screen.height / 2) - (height / 2);
    
    // window.open("경로", "창이름", "옵션")
    var url = "${path}/delivery/addressInsert.do"; // 주소 API가 있는 JSP와 매핑된 URL
    window.open(url, "AddADDR", 
                "width=" + width + ", height=" + height + 
                ", top=" + top + ", left=" + left + 
                ", resizable=no, scrollbars=yes");
}



function toggleSelectAll() {
    const selectAll = document.getElementById('selectAll');
    const checkboxes = document.querySelectorAll('.chk');
    checkboxes.forEach(cb => cb.checked = selectAll.checked);
}
//3. 단일 삭제
function addressDel(idx) {
    if(confirm("이 주소를 삭제하시겠습니까?")) {
        location.href = "${path}/delivery/deleteAddress.do?deliveryIdx=" + idx;
    }
}
//4. 선택 삭제 (다중 삭제)
function deleteSelected() {
    const checkedBoxes = document.querySelectorAll('.chk:checked');
    if(checkedBoxes.length === 0) {
        alert("삭제할 항목을 선택해주세요.");
        return;
    }
    
    if(confirm(checkedBoxes.length + "개의 주소를 삭제하시겠습니까?")) {
        const ids = Array.from(checkedBoxes).map(cb => cb.value);
        // 리스트 형태(1,2,3)로 파라미터 전달
        location.href = "${path}/delivery/deleteAddresses.do?ids=" + ids.join(",");
    }
  }
</script>


</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
