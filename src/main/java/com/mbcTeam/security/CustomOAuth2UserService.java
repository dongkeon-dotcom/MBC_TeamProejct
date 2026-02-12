package com.mbcTeam.security;
import java.util.Map;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.mbcTeam.user.UserVO;

import com.mbcTeam.security.MemberMapper;
@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    @Autowired
    private MemberMapper memberMapper;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
    	System.out.println("==============> [확인] OAuth2 서비스 시작됨!");
        System.out.println("Client Registration ID: " + userRequest.getClientRegistration().getRegistrationId());
        
        // 1. 소셜 서비스로부터 기본 유저 정보를 가져옴
        OAuth2User oAuth2User = super.loadUser(userRequest);
        
        // 2. 소셜 구분 및 데이터 파싱
        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        Map<String, Object> attributes = oAuth2User.getAttributes();
        
        String email = "";
        String name = "";

        try {
            if ("google".equals(registrationId)) {
                email = (String) attributes.get("email");
                name = (String) attributes.get("name");
                System.out.println("추출된 정보 - Email 1111: " + email + ", Name: " + name);
            } 
            else if ("naver".equals(registrationId)) {
                // 네이버는 response라는 Map 안에 데이터가 있음
                Map<String, Object> response = (Map<String, Object>) attributes.get("response");
                email = (String) response.get("email");
                name = (String) response.get("name");
                System.out.println("추출된 정보 - Email22222: " + email + ", Name: " + name);
            } 
            else if ("kakao".equals(registrationId)) {
                // 카카오는 kakao_account > profile 안에 데이터가 있음
                Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");
                Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
                email = (String) kakaoAccount.get("email");
                name = (String) profile.get("nickname");
                System.out.println("추출된 정보 - Email33333: " + email + ", Name: " + name);
            }
        } catch (Exception e) {
            System.out.println("소셜 데이터 파싱 중 에러 발생: " + e.getMessage());
        }

        System.out.println("추출된 정보 - Email: " + email + ", Name: " + name);

        // 3. DB 조회
        UserVO user = memberMapper.getByEmail(email);
        if (user == null) {
        	ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        	HttpSession session = attr.getRequest().getSession(true);

        	session.setAttribute("socialId", email); // VO의 id 필드용 이메일
        	session.setAttribute("isSocial", true);
        	session.setAttribute("socialName", name);
        	System.out.println("===> [Service] 세션에 이메일 저장 완료: " + email+name);

        	throw new OAuth2AuthenticationException("not_joined_user");
        }
        return oAuth2User;
    }
}