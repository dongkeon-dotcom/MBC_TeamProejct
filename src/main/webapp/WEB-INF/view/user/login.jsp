<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<c:import url="/WEB-INF/view/include/top.jsp" />

<link href="${path}/resources/css/user/login.css" rel="stylesheet">
<div class="login-wrapper">
    <div class="login-container">
        <h1>로그인</h1>
        
        <form action="${path}/user/loginOK.do" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <table class="login-table">
                <tr>
                    <td>아이디(이메일)</td>
                </tr>
                <tr>
                    <td>
                        <input type="text" name="id" placeholder="이메일을 입력하세요" required />
                    </td>
                </tr>
                <tr>
                    <td>비밀번호</td>
                </tr>
                <tr>
                    <td> 
                        <input type="password" name="password" placeholder="비밀번호를 입력하세요" required />
                    </td>
                </tr>
                
                <%-- 로그인 실패 메시지 --%>
                <c:if test="${param.error == 'true' && empty param.exception}">
                    <tr>
                        <td class="error-msg">
                            아이디 또는 비밀번호가 일치하지 않습니다.
                        </td>
                    </tr>
                </c:if>

                <tr>
                    <td>
                        <button type="submit" class="btn-login">로그인</button>
                    </td>
                </tr>
            </table>
        </form>

        <div class="divider-container">
            <hr class="divider">
            <span>또는</span>
        </div>

        <div class="social-login-buttons">
            <a href="${path}/oauth2/authorization/google" class="btn-google">
                구글 계정으로 로그인
            </a>
            
            <a href="${path}/oauth2/authorization/naver" class="btn-naver">
                네이버 계정으로 로그인
            </a>
            
            <a href="${path}/oauth2/authorization/kakao" class="btn-kakao">
                카카오 계정으로 로그인
            </a>
        </div>

        <div class="join-guide">
            <span>아직 회원이 아니신가요?</span>
            <button type="button" class="btn-join" onclick="location.href='${path}/user/member.do'">회원가입</button>
        </div>
    </div>
</div>

<script>
    window.onload = function() {
        // 현재 URL 확인용 로그
        console.log("Current URL Params:", window.location.search);

        const urlParams = new URLSearchParams(window.location.search);
        
        // 1. 로그인 실패 시 (FailureHandler에서 보낸 메시지)
        let errorMsg = urlParams.get('exception');
        if (errorMsg) {
            alert(decodeURIComponent(errorMsg.replace(/\+/g, ' '))); // + 기호 공백 치환 처리
            window.history.replaceState({}, document.title, window.location.pathname);
        }

        // 2. 회원탈퇴 버튼 클릭 직후 (Controller에서 보낸 메시지)
        let status = urlParams.get('status');
        if (status === 'withdrawn') {
            alert("회원 탈퇴가 정상적으로 처리되었습니다.");
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    }
</script>
<c:import url="/WEB-INF/view/include/bottom.jsp" />