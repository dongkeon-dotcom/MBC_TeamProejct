<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/view/include/top.jsp" />


<link href="${path}/resources/member/login.css" rel="stylesheet">

   
<br>



  <div align="center">
  <h1 class="login-title">회원 로그인1</h1>
  <form action="${path}/user/loginOK.do" method="post">
     	<table  >
                <tr><td>아이디(이메일)</td>
                    <td><input type="text" name="id" size="25" value="${prevEmail}" placeholder="이메일을 입력하세요"/>
                        
                      <c:if test="${not empty emailError}">
                       <div style="color:red; font-size:12px;">${emailError}</div> </c:if> </td></tr>

                <tr><td>암호</td>
                    <td> <input type="password" name="password" size="25" />
                    <c:if test="${not empty pwError}">
                            <div style="color:red; font-size:12px;">${pwError}</div></c:if></td> </tr>

                <tr><td colspan="2" align="center">
                     <input type="submit" value="로그인"/></td></tr>
            </table>
        </form>
     
     
 <a href="/oauth2/authorization/google"><button>Google 로그인</button></a>
<br><br><br>
<a href="/oauth2/authorization/kakao"><button>카카오 로그인</button></a>
 <br>     <br><br>  
    
<a href="/oauth2/authorization/naver"><button> naver 로그인</button></a>  
<button type="button" onclick="location.href='${path}/user/member.do'">회원가입</button>
     
     
     

  </div>


<br>


<script >

    
</script>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />