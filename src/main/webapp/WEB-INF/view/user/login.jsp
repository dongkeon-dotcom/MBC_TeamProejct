<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<c:import url="/WEB-INF/view/include/top.jsp" />

<link href="${path}/resources/member/login.css" rel="stylesheet">

<div align="center" style="margin-top: 50px; margin-bottom: 50px;">

    <form action="${path}/user/loginOK.do" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <table style="border-spacing: 10px;">
            <tr>
                <td>아이디(이메일)</td>
                <td>
                    <input type="text" name="id" size="30" placeholder="이메일을 입력하세요" required />
                </td>
            </tr>
            <tr>
                <td>비밀번호</td>
                <td> 
                    <input type="password" name="password" size="30" placeholder="비밀번호를 입력하세요" required />
                </td>
            </tr>
            
            <%-- 일반 시큐리티 로그인 실패 시 처리 (ID/PW 불일치) --%>
            <c:if test="${param.error == 'true' && empty param.exception}">
                <tr>
                    <td colspan="2" style="color:red; font-size:12px; text-align:center;">
                        아이디 또는 비밀번호가 일치하지 않습니다.
                    </td>
                </tr>
            </c:if>

            <tr>
                <td colspan="2" align="center">
                    <button type="submit" style="width: 100%; padding: 10px; cursor: pointer;">로그인</button>
                </td>
            </tr>
        </table>
    </form>

    <hr style="width: 300px; margin: 20px 0;">

    <div class="social-login-buttons" style="display: flex; flex-direction: column; gap: 10px; width: 300px;">
        <a href="${path}/oauth2/authorization/google" 
           style="background-color: #fff; border: 1px solid #ddd; padding: 10px; text-decoration: none; color: #000; border-radius: 5px;">
           구글 계정으로 로그인
        </a>
        
        <a href="${path}/oauth2/authorization/naver" 
           style="background-color: #03C75A; padding: 10px; text-decoration: none; color: #fff; border-radius: 5px;">
           네이버 계정으로 로그인
        </a>
        
        <a href="${path}/oauth2/authorization/kakao" 
           style="background-color: #FEE500; padding: 10px; text-decoration: none; color: #3C1E1E; border-radius: 5px;">
           카카오 계정으로 로그인
        </a>
    </div>

    <div style="margin-top: 20px;">
        <span>아직 회원이 아니신가요?</span>
        <button type="button" onclick="location.href='${path}/user/member.do'" 
                style="margin-left: 10px; padding: 5px 15px;">회원가입</button>
    </div>
</div>

<c:import url="/WEB-INF/view/include/bottom.jsp" />

<script>
    window.onload = function() {
        // 1. URL에서 파라미터 추출
        const urlParams = new URLSearchParams(window.location.search);
        const errorMsg = urlParams.get('exception');
        
        // 2. exception 파라미터가 있으면 alert 띄우기
        if (errorMsg) {
            // URLEncoder로 인코딩된 메시지를 다시 한글로 변환하여 출력
            alert(decodeURIComponent(errorMsg));
            
            // 3. (선택) 알림 확인 후 주소창의 에러 파라미터를 제거하여 새로고침 시 중복 팝업 방지
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    }
</script>