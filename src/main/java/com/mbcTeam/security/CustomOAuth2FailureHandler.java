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
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;
@Component
public class CustomOAuth2FailureHandler extends SimpleUrlAuthenticationFailureHandler {


	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
	                                    AuthenticationException exception) throws IOException, ServletException {

	    String errorMessage = "아이디 또는 비밀번호가 일치하지 않습니다.";
	    String msg = (exception != null && exception.getMessage() != null) ? exception.getMessage() : "";

	    // 로그 확인용
	    System.out.println("--- 실패 분석 ---");
	    System.out.println("Type: " + exception.getClass().getSimpleName());
	    System.out.println("Msg: " + msg);

	    // 1. 메시지에 키워드가 포함되어 있거나, 
	    // 2. 메시지가 비어있더라도 OAuth2AuthenticationException 라면 (위에서 던진 것)
	    if (msg.contains("deleted_user") || msg.contains("ALREADY_WITHDRAWN") || 
	        exception instanceof OAuth2AuthenticationException) {
	        
	        // OAuth2AuthenticationException가 발생했다는 건 
	        // 우리가 UserService에서 탈퇴 로직으로 던졌을 확률이 매우 높음
	        errorMessage = "탈퇴 처리 중인 계정입니다.";
	    } 
	    else if (exception instanceof DisabledException) {
	        errorMessage = "탈퇴 처리 중인 계정입니다.";
	    }

	    String encodedMsg = java.net.URLEncoder.encode(errorMessage, "UTF-8");
	    response.sendRedirect(request.getContextPath() + "/user/login.do?error=true&exception=" + encodedMsg);
	}
}