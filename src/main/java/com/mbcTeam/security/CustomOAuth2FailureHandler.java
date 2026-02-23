package com.mbcTeam.security;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;

import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;
@Component
public class CustomOAuth2FailureHandler extends SimpleUrlAuthenticationFailureHandler {


	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
	                                    AuthenticationException exception) throws IOException, ServletException {

	    String errorMessage = "아이디 또는 비밀번호가 일치하지 않습니다.";

	    // 1. 예외 분석 (로그에 찍힌 InternalAuthenticationServiceException 대응)
	    if (exception instanceof InternalAuthenticationServiceException) {
	        // 내부 원인이 DisabledException인지 확인
	        if (exception.getCause() instanceof DisabledException || 
	            exception.getMessage().contains("탈퇴")) {
	            errorMessage = "탈퇴 처리 중인 계정입니다.";
	        }
	    } else if (exception instanceof DisabledException) {
	        errorMessage = "탈퇴 처리 중인 계정입니다.";
	    }

	    System.out.println("===> 로그인 실패 처리 메시지: " + errorMessage);

	    // 2. 한글 인코딩
	    String encodedMsg = java.net.URLEncoder.encode(errorMessage, "UTF-8");

	    // 3. 리다이렉트 (이 주소로 가야 JSP의 스크립트가 돌아갑니다)
	    // contextPath가 /main 이라면 결과는 /main/user/login.do?... 가 됩니다.
	    response.sendRedirect(request.getContextPath() + "/user/login.do?error=true&exception=" + encodedMsg);
	}
}