<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:import url="/WEB-INF/view/include/top.jsp" />

    <style>
        .social-badge { background-color: #fee500; color: #3c1e1e; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; margin-left: 5px; border: 1px solid #e2d100; }
        .readonly-box { background-color: #f8f9fa; border: 1px solid #dee2e6; cursor: not-allowed; color: #6c757d; }
        .msg-text { font-size: 13px; margin-top: 5px; display: block; }
    </style>


<section>
    <br>
    <div align="center">
        <h1>${isSocial ? '소셜 계정 회원가입' : '일반 회원가입'}</h1>
        
        <c:set var="path" value="${pageContext.request.contextPath}" />

        <form name="joinForm" method="post" action="${path}/user/memberOK.do" onsubmit="return validateForm()">
            <%-- Security 필수: CSRF 토큰 --%>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <%-- 서버 컨트롤러의 isSocialUser 파라미터와 매칭 --%>
            <input type="hidden" name="isSocialUser" value="${isSocial ? 'Y' : 'N'}" />

            <table cellpadding="5" style="max-width: 500px; width: 100%;">
                <%-- 1. 아이디 영역 --%>
                <tr>
                    <td style="font-weight: bold;">
                        아이디(이메일) 
                        <c:if test="${isSocial}">
                            <span class="social-badge">소셜인증 완료</span>
                        </c:if>
                    </td>
                    <td align="right">
                        <c:if test="${!isSocial}">
                            <button type="button" onclick="checkEmail()" class="btn btn-sm btn-outline-secondary">중복체크</button>
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="text" name="id" id="id" style="width: 100%; padding: 8px;"
                               value="${id}" 
                               ${isSocial ? 'readonly class="readonly-box"' : ''} 
                               placeholder="이메일을 입력하세요" />
                        <span id="emailMsg" class="msg-text"></span>
                    </td>
                </tr>

                <%-- 2. 비밀번호 영역 --%>
                <c:choose>
                    <c:when test="${!isSocial}">
                        <tr><td colspan="2" style="font-weight: bold; padding-top: 15px;">비밀번호</td></tr>
                        <tr>
                            <td colspan="2">
                                <input type="password" name="password" id="password" style="width: 100%; padding: 8px;" placeholder="비밀번호 입력 (최소 4자 이상)" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="password" name="userPWck" id="userPWck" style="width: 100%; padding: 8px;" placeholder="비밀번호 재입력" />
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <%-- 소셜 유저는 비밀번호를 입력받지 않지만, 컨트롤러가 parameter를 기대하므로 빈 값 전송 --%>
                        <input type="hidden" name="password" value="" />
                    </c:otherwise>
                </c:choose>

                <%-- 3. 이름 영역 --%>
                <tr><td colspan="2" style="font-weight: bold; padding-top: 15px;">이름</td></tr>
                <tr>
                    <td colspan="2">
                        <input type="text" name="userName" id="userName" style="width: 100%; padding: 8px;" value="${userName}" />
                    </td>
                </tr>

               <%-- 4. 전화번호 영역 --%>
<tr><td colspan="2" style="font-weight: bold; padding-top: 15px;">전화번호</td></tr>
<tr>
    <td colspan="2" style="display: flex; align-items: center; gap: 5px;">
        <select id="phone1" style="width: 80px; padding: 8px;">
            <option value="010">010</option>
            <option value="011">011</option>
            <option value="016">016</option>
            <option value="02">02</option>
            <option value="031">031</option>
        </select>
        <span style="padding: 0 5px;">-</span>
        <input type="text" id="phone_body" style="flex: 1; padding: 8px;" 
               placeholder="숫자만 입력" maxlength="8"
               oninput="this.value=this.value.replace(/[^0-9]/g,'');" />
        
        <input type="hidden" name="userPhone" id="userPhone" />
    </td>
</tr>

                <tr>
                    <td colspan="2" align="center">
                        <br><br>
                        <button type="button" onclick="joinCheck()" style="width: 100%; height: 45px; background-color: #007bff; color: white; border: none; border-radius: 5px; font-weight: bold; cursor: pointer;">
                            회원가입 완료
                        </button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</section>

<script>
const isSocial = ${isSocial == true ? true : false};
let emailChecked = isSocial; // 소셜 가입이면 중복체크 이미 된 것으로 간주
function joinCheck() {
    const form = document.joinForm;

    // 1. 아이디 공통 검사
    if (form.id.value.trim() === "") {
        alert("아이디를 입력하세요");
        form.id.focus();
        return;
    }

    // 2. 일반 가입 전용 유효성 검사
    if (!isSocial) {
        if (!emailChecked) {
            alert("아이디 중복체크를 해주세요");
            return;
        }
        if (form.password.value.length < 4) {
            alert("비밀번호를 4자 이상 입력하세요");
            form.password.focus();
            return;
        }
        if (form.password.value !== form.userPWck.value) {
            alert("비밀번호가 일치하지 않습니다");
            form.userPWck.focus();
            return;
        }
    }

    // 3. 이름 검사
    if (form.userName.value.trim() === "") {
        alert("이름을 입력하세요");
        form.userName.focus();
        return;
    }

    // 4. [수정] 전화번호 검사 및 합치기
    const p1 = document.getElementById('phone1').value;
    const pBody = document.getElementById('phone_body').value;
    
    if (pBody.trim() === "" || pBody.length < 7) {
        alert("전화번호 뒷자리를 정확히 입력해 주세요.");
        document.getElementById('phone_body').focus();
        return;
    }

    // ★ 여기서 번호를 합쳐서 hidden 필드에 넣어줍니다.
    document.getElementById('userPhone').value = p1 + pBody;

    // 5. 최종 제출
    if(confirm("입력하신 정보로 회원가입을 진행할까요?")) {
        form.submit();
    }
}

function checkEmail() {
    const email = document.getElementById("id").value.trim();
    const msg = document.getElementById("emailMsg");
    const path = "${pageContext.request.contextPath}";

    if (email === "") {
        msg.innerHTML = "이메일을 입력하세요";
        msg.style.color = "red";
        emailChecked = false;
        return;
    }

    fetch(path + "/user/checkEmail.do?id=" + encodeURIComponent(email))
        .then(res => res.json())
        .then(data => {
            if (data.exists) {
                msg.innerHTML = "이미 사용 중인 이메일입니다 ❌";
                msg.style.color = "red";
                emailChecked = false;
            } else {
                msg.innerHTML = "사용 가능한 이메일입니다 ✅";
                msg.style.color = "green";
                emailChecked = true;
            }
        })
        .catch(err => {
            console.error(err);
            msg.innerHTML = "중복 체크 중 오류가 발생했습니다.";
            msg.style.color = "orange";
        });
}

</script>
<c:import url="/WEB-INF/view/include/bottom.jsp" />
