package com.mbcTeam.security;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;
@Component
public class CustomOAuth2FailureHandler extends SimpleUrlAuthenticationFailureHandler {

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
            AuthenticationException exception) throws IOException, ServletException {
        
        // 1. 에러 메시지 가져오기 (null일 경우 빈 문자열 또는 기본 메시지 설정)
        String errorMessage = (exception.getMessage() != null) ? exception.getMessage() : "이미 가입된 이메일 입니다 ";
        
        System.out.println("===> OAuth2 로그인 실패 이유: " + errorMessage);

        // 2. 분기 처리
        if ("not_joined_user".equals(errorMessage)) {
            // 회원가입 안 된 유저는 가입 페이지로
            response.sendRedirect(request.getContextPath() + "/user/member.do");
        } else {
            // 3. 중복 가입 유저 등 그 외 에러는 메시지를 인코딩하여 로그인 페이지로
            // URLEncoder.encode에 null이 들어가지 않도록 확실히 처리
            String encodedMsg = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8.toString());
            
            response.sendRedirect(request.getContextPath() + "/user/login.do?error=true&exception=" + encodedMsg);
        }
    }
}