<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="path" scope="request" value="${pageContext.request.contextPath }"/>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새 배송지 등록</title>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
    body { font-family: sans-serif; padding: 20px; }
    .form-group { margin-bottom: 15px; }
    label { display: block; margin-bottom: 5px; font-weight: bold; }
    input[type="text"] { width: 100%; padding: 8px; box-sizing: border-box; }
    .btn-submit { width: 100%; padding: 10px; background: #007bff; color: white; border: none; cursor: pointer; }
    .btn-addr { padding: 5px 10px; background: #6c757d; color: white; border: none; cursor: pointer; margin-bottom: 5px; }
</style>
</head>
<body>

<h3>새 배송지 등록</h3>

<form action="${pageContext.request.contextPath}/delivery/addressInsertProcess.do" method="post">
    <div class="form-group">
        <label>배송지 이름 (예: 집, 회사)</label>
        <input type="text" name="deliveryName" placeholder="배송지 이름을 입력하세요" required>
    </div>
    
    <div class="form-group">
        <label>수령인</label>
        <input type="text" name="receiver" required> 
    </div>
    
    <div class="form-group">
        <label>전화번호</label>
        <input type="text" name="deliveryPhone" placeholder="010-0000-0000" required>
    </div>
    
    <div class="form-group">
        <label>주소</label>
        <input type="text" id="zipcode" name="zipcode" style="width:100px;" readonly required>
        <button type="button" class="btn-addr" onclick="execDaumPostcode()">우편번호 찾기</button>
        <input type="text" id="address" name="address" readonly required style="margin-top:5px;">
        <input type="text" id="extraAddress" name="extraAddress" placeholder="상세주소를 입력하세요" style="margin-top:5px;">
    </div>
    
    <div class="form-group">
        <label>
            <input type="checkbox" name="isDefaultAddress" value="1"> 기본 배송지로 설정
        </label>
    </div>

    <button type="submit" class="btn-submit">저장하기</button>
</form>

<script>
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

</body>
</html>