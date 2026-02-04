<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<!DOCTYPE html>
<html>
<head>
<!-- 커스터머 주소목록 관리    -->
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


<section>
    <br>
    <div align="center">
       <h3> 주소관리  </h3>
  
<!-- 체크 박스 이름 전화번호 주소지 주소지 삭제 버튼  -->
       

    <table> 
            <thead>
                <tr> 
                    <th><input type="checkbox" id="selectAll" onclick="toggleSelectAll()"></th> 
                    <th>배송지명</th> 
                    <th>수령인</th> 
                    <th>전화번호</th> 
                    <th>주소</th> 
                    <th>삭제</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="m" items="${addressList}" varStatus="status">
                <tr> 
                    <td>
                        <input type="checkbox" name="selectedIdx" value="${m.deliveryIdx}" class="chk">
                    </td>
                    <td>
                        ${m.deliveryName}
                       <c:if test="${m.defaultAddress}">
                            <span class="default-badge">기본</span>
                        </c:if>
                    </td> 
                    <td>${m.Receiver}</td> <td>${m.deliveryPhone}</td> 
                    <td align="left">
                        (${m.zipcode}) ${m.address} ${m.extraAddress}
                    </td> 
                    <td>
                        <input type="button" onClick="addressDel('${m.deliveryIdx}')" value="삭제">
                    </td>
                </tr>
                </c:forEach>
                
                <c:if test="${empty addressList}">
                    <tr>
                        <td colspan="6">등록된 배송지가 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
   <button type="button" onclick="addrDel()">선택사항 삭제</button> <button type="button" onclick="AddADDR()">주소 추가 </button>
    
     
     
    </div>
</section>
</body>


<script>

function AddADDR() {
     // 팝업창의 가로, 세로 크기 및 위치 설정
    var width = 500;
    var height = 600;
    var left = (window.screen.width / 2) - (width / 2);
    var top = (window.screen.height / 2) - (height / 2);
    
    // window.open("경로", "창이름", "옵션")
    var url = "${path}/user/addressInsert.do"; // 주소 API가 있는 JSP와 매핑된 URL
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
        location.href = "${path}/user/deleteAddress.do?deliveryIdx=" + idx;
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
        location.href = "${path}/user/deleteAddresses.do?ids=" + ids.join(",");
    }
</script>


</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
