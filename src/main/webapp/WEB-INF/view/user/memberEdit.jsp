<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="/WEB-INF/view/include/top.jsp" />

<section>
    <br>
    <div align="center">
        <h1>개인 회원 정보 수정</h1>

        <form id="updateForm" action="${path}/user/memberUpdate.do" method="POST">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <input type="hidden" name="userIdx" value="${m.userIdx}">
            <input type="hidden" name="id" value="${m.id}">
            <input type="hidden" name="userPhone" id="userPhone" value="${m.userPhone}">

            <table align="center" cellpadding="10">
                <tr>
                    <td>이메일</td>
                    <td><input type="text" value="${m.id}" readonly style="background-color: #f8f9fa;"></td>
                </tr>
                <tr>
                    <td>비밀번호</td>
                    <td><input type="password" name="password" id="password" placeholder="변경할 비밀번호 입력" minlength="4" maxlength="20" required></td>
                </tr>
                <tr>
                    <td>회원 이름</td>
                    <td><input type="text" name="userName" value="${m.userName}"></td>
                </tr>
                <tr>
                    <td>전화번호</td>
                    <td style="display: flex; align-items: center; gap: 5px;">
                        <select id="phone1" style="padding: 5px;">
                            <option value="010">010</option>
                            <option value="011">011</option>
                            <option value="016">016</option>
                            <option value="02">02</option>
                            <option value="031">031</option>
                        </select>
                        <span>-</span>
                        <input type="text" id="phone_body" style="padding: 5px;" placeholder="숫자만 입력" maxlength="8"
                               oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                    </td>
                </tr>
                <tr>
                    <td>주소</td>
                    <td>
                        (${d.zipcode}) ${d.address} ${d.extraAddress} 
                        <input type="button" value="주소변경하기" onclick="addrCH()" style="margin-left:10px;"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <br>
                        <input type="button" value="수정하기" onclick="memberUpdate()" style="width: 100px; height: 40px;"/> 
                        <input type="button" value="뒤로가기" onclick="memberBack()" style="width: 100px; height: 40px;"/>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</section>

<script>
// 페이지 로드 시 기존 전화번호 분리해서 세팅하기
window.onload = function() {
    const originPhone = "${m.userPhone}"; // 예: 010-1111-2222
    if (originPhone) {
        // 하이픈 제거 또는 분리 처리
        const parts = originPhone.split('-'); 
        
        if (parts.length === 3) {
            // 010-1111-2222 형태인 경우
            document.getElementById('phone1').value = parts[0];
            document.getElementById('phone_body').value = parts[1] + parts[2];
        } else {
            // 하이픈이 없는 경우 (숫자만 있는 경우)
            const p1 = originPhone.substring(0, 3);
            const pRest = originPhone.substring(3);
            document.getElementById('phone1').value = p1;
            document.getElementById('phone_body').value = pRest;
        }
    }
}

function memberUpdate(){
    const p1 = document.getElementById('phone1').value;
    const pBody = document.getElementById('phone_body').value;
    const pw = document.getElementById('password').value;

    if(pw.trim() === "") {
        alert("정보 수정을 위해 비밀번호를 입력해주세요.");
        document.getElementById('password').focus();
        return;
    }

    if(pBody.length < 7) {
        alert("전화번호를 정확히 입력해주세요.");
        document.getElementById('phone_body').focus();
        return;
    }

    if(confirm("정보를 수정하시겠습니까?")) {
        // 번호 합쳐서 hidden 필드에 넣기
        document.getElementById("userPhone").value = p1 + pBody;
        document.getElementById("updateForm").submit();
    }
}

function memberBack(){
    location.href = "${path}/user/mypage.do";
}

function addrCH(){
    location.href = "${path}/delivery/addressList.do";
}
</script>

<c:import url="/WEB-INF/view/include/bottom.jsp" />