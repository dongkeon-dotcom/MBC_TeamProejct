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
    
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

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
          <input type="checkbox" name="defaultAddress" value="true">기본 배송지로 설정
        </label>
    </div>

    <button type="submit" class="btn-submit">저장하기</button>
</form>

<script>
function execDaumPostcode() {
    new daum.Postcode({
        // 팝업창 디자인 테마 (필요 없으면 theme 블록 전체 삭제 가능)
        theme: {
            searchBgColor: "#0B65C8", // 검색창 배경색
            queryTextColor: "#FFFFFF" // 검색창 글자색
        },
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을 때 실행할 코드를 작성하는 부분입니다.

            var addr = ''; // 주소 변수

            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 우편번호와 주소 정보를 해당 필드(input)에 넣는다.
            document.getElementById('zipcode').value = data.zonecode;
            document.getElementById("address").value = addr;
            
            // 상세주소 입력 필드로 포커스를 이동한다.
            document.getElementById("extraAddress").focus();
        }
    }).open(); // .embed() 대신 .open()을 사용하면 새 창이 뜹니다.
}
</script>

</body>
</html>