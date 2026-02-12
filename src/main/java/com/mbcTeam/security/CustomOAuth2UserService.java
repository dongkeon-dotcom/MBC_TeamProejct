package com.mbcTeam.security;

import java.util.Collections;
import java.util.Map;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.mbcTeam.user.UserVO;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    @Autowired
    private MemberMapper memberMapper;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        System.out.println("==============> [확인] OAuth2 서비스 시작됨!");
        
        // 1. 소셜 서비스로부터 기본 유저 정보를 가져옴
        OAuth2User oAuth2User = super.loadUser(userRequest);
        
        // 2. 소셜 구분 및 데이터 파싱
        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        Map<String, Object> attributes = oAuth2User.getAttributes();
        
        String email = "";
        String name = "";
        int currentLoginType = 0; 

        try {
            if ("google".equals(registrationId)) {
                email = (String) attributes.get("email");
                name = (String) attributes.get("name");
                currentLoginType = 1; 
            } 
            else if ("naver".equals(registrationId)) {
                Map<String, Object> response = (Map<String, Object>) attributes.get("response");
                email = (String) response.get("email");
                name = (String) response.get("name");
                currentLoginType = 2; 
            } 
            else if ("kakao".equals(registrationId)) {
                Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");
                Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
                email = (String) kakaoAccount.get("email");
                name = (String) profile.get("nickname");
                currentLoginType = 3; 
            }
        } catch (Exception e) {
            System.out.println("소셜 데이터 파싱 중 에러 발생: " + e.getMessage());
        }

        // 3. DB 조회
        UserVO user = memberMapper.getByEmail(email);
        
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        HttpSession session = attr.getRequest().getSession(true);

        if (user == null) {
            // [신규 가입 유저]
            session.setAttribute("socialId", email);
            session.setAttribute("isSocial", true);
            session.setAttribute("socialName", name);
            session.setAttribute("loginType", currentLoginType);
            
            System.out.println("===> [Service] 미가입 유저: 세션에 소셜정보 저장 (" + registrationId + ")");
            throw new OAuth2AuthenticationException("not_joined_user");
            
        } else {
            // [기존 가입 유저] 로그인 타입(소셜사) 검증
            if (user.getLoginType() != currentLoginType) {
                String providerName = "";
                switch(user.getLoginType()) {
                    case 0: providerName = "일반"; break;
                    case 1: providerName = "구글"; break;
                    case 2: providerName = "네이버"; break;
                    case 3: providerName = "카카오"; break;
                }
                System.out.println("===> [경고] 로그인 타입 불일치! 가입수단: " + providerName);
                throw new OAuth2AuthenticationException("이미 " + providerName + " 계정으로 가입된 이메일입니다.");
            }

            // [성공] 세션에 정보 저장
            session.setAttribute("userName", user.getUserName());
            session.setAttribute("userIdx", user.getUserIdx());
            session.setAttribute("loginType", user.getLoginType()); // 타입도 세션에 유지
            
            System.out.println("===> [소셜로그인 성공] 기존 유저: " + user.getUserName());

            // ★ 중요: DB의 권한을 포함하여 새로운 OAuth2User 객체를 리턴함 ★
            return new DefaultOAuth2User(
                Collections.singleton(new SimpleGrantedAuthority("ROLE_" + user.getUserRole())), 
                attributes, 
                userRequest.getClientRegistration().getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName()
            );
        }
    }
}