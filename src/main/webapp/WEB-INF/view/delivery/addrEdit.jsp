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

  
<!-- 체크 박스 이름 전화번호 주소지 주소지 삭제 버튼  -->
    

<h2>배송지 수정</h2>

<form action="${path}/delivery/addressUpdateProcess.do" method="post">
    
    <input type="hidden" name="deliveryIdx" value="${addr.deliveryIdx}">
<input type="hidden" name="userIdx" value="${addr.userIdx}">
    <table style="width:100%; border-collapse: collapse;">
        <colgroup>
            <col style="width: 30%;">
            <col style="width: 70%;">
        </colgroup>
        
        <tr>
            <th><label>배송지 이름</label></th>
            <td>
                <input type="text" name="deliveryName" value="${addr.deliveryName}" required>
            </td>
        </tr>

        <tr>
            <th><label>수령인</label></th>
            <td>
                <input type="text" name="receiver" value="${addr.receiver}" required>
            </td>
        </tr>

        <tr>
            <th><label>전화번호</label></th>
            <td>
                <input type="text" name="deliveryPhone" value="${addr.deliveryPhone}" required>
            </td>
        </tr>

        <tr>
            <th><label>주소</label></th>
            <td>
                <input type="text" id="zipcode" name="zipcode" value="${addr.zipcode}" readonly style="width:80px;">
                <button type="button" onclick="execDaumPostcode()">주소찾기</button><br>
                <input type="text" id="address" name="address" value="${addr.address}" readonly style="width:100%; margin-top:5px;">
                <input type="text" id="extraAddress" name="extraAddress" value="${addr.extraAddress}" placeholder="상세주소" style="width:100%; margin-top:5px;">
            </td>
        </tr>

        <tr>
            <td colspan="2">

		<input type="checkbox" name="defaultCheck" value="true" id="isDefault" 
       ${addr.defaultAddress ? 'checked' : ''}>
	<label for="isDefault">기본 배송지로 설정</label>
            </td>
        </tr>
    </table>

    <div style="margin-top: 20px; text-align: center;">
        <button type="submit" class="btn-submit">수정완료</button>
        <button type="button" onclick="window.close()">취소</button>
    </div>
</form>
</div>
</section>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
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

function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = ''; 
            if (data.userSelectedType === 'R') { addr = data.roadAddress; } 
            else { addr = data.jibunAddress; } 

            document.getElementById('zipcode').value = data.zonecode;
            document.getElementById("address").value = addr;
            document.getElementById("extraAddress").focus();
        }
    }).open();
}
</script>
</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
