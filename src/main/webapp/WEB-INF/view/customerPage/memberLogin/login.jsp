<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<!DOCTYPE html>
<html>
<head>
<!-- 로그인 페이지 소셜 연동 필요  -->
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


<section>
    <br>
    <div align="center">
        <form name="loginForm" method="post" action="${pageContext.request.contextPath}/member/loginOK.do">
            <table >
                <tr>
                    <td>아이디(이메일)</td>
                    <td>
                        <input type="text" name="user_email" size="25" 
                               value="${prevEmail}" placeholder="이메일을 입력하세요"/>
                        
                        <c:if test="${not empty emailError}">
                            <div style="color:red; font-size:12px;">${emailError}</div>
                        </c:if>
                    </td>
                </tr>

                <tr>
                    <td>암호</td>
                    <td>
                        <input type="password" name="userPW" size="25" />
                        
                        <c:if test="${not empty pwError}">
                            <div style="color:red; font-size:12px;">${pwError}</div>
                        </c:if>
                    </td>
                </tr>

                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" value="로그인"/>
                    </td>
                </tr>
            </table>
        </form>
        
      <!-- 소셜로그인 부분  -->  
        
        <a href="/oauth2/authorization/google">
    <button>Google 로그인</button>
</a>
<br><br><br>
<a href="/oauth2/authorization/kakao">
    <button>카카오 로그인</button>
</a>
 <br>     <br><br>  
    
<a href="/oauth2/authorization/naver">
    <button> naver 로그인</button>
</a>  
<br>  <br><br>
<button type="button"
 onclick="location.href='${pageContext.request.contextPath}/memberLogin/member.do'">
 회원가입
</button>

        
        
    </div>
</section>



</body>
</html>







<c:import url="/WEB-INF/view/include/bottom.jsp" />
