package com.mbcTeam.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.core.ClientAuthenticationMethod;
import org.springframework.security.oauth2.core.oidc.IdTokenClaimNames;
import java.util.ArrayList;
import java.util.List;
@SuppressWarnings("deprecation")
@Configuration
@EnableWebSecurity
@PropertySource("classpath:config/oauth.properties")
public class SecurityConfig extends WebSecurityConfigurerAdapter{

	@Autowired
	private CustomOAuth2FailureHandler customOAuth2FailureHandler;
	
	@Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private CustomOAuth2UserService customOAuth2UserService; // 소셜 로그인 처리 서비스

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String googleClientId;
    @Value("${spring.security.oauth2.client.registration.google.client-secret}")
    private String googleClientSecret;

    @Value("${spring.security.oauth2.client.registration.naver.client-id}")
    private String naverClientId;
    @Value("${spring.security.oauth2.client.registration.naver.client-secret}")
    private String naverClientSecret;

   // @Value("${spring.security.oauth2.client.registration.kakao.client-id}")
    private String kakaoClientId="d894dc2c77f2e85f0790ded3bfdcfa68";
   // @Value("${spring.security.oauth2.client.registration.kakao.client-secret}")
    private String kakaoClientSecret="Ec4CvEJDZsyS7zh6vWCdTWiMPSLvf6et";

    

	SecurityConfig(){
		System.out.println("==>SecurityConfig들어옴   " + kakaoClientSecret+""+kakaoClientId);
	}
    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }
    @Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
	    auth.userDetailsService(userDetailsService)
	   .passwordEncoder(passwordEncoder());
	}
   
    
    @Bean
    public AuthenticationEntryPoint customAuthenticationEntryPoint() {
        return (request, response, authException) -> {
            // 컨트롤러 경로인 /user/member.do 로 이동 (컨텍스트 패스 포함)
            // 만약 컨트롤러가 @RequestMapping("/user")를 가지고 있다면 "/user/member.do"로 적으세요.
            response.sendRedirect(request.getContextPath() + "/user/member.do");
        };
    }

        @Override
        protected void configure(HttpSecurity http) throws Exception {
            // 1. CSRF 비활성화, 실제로는 배포전 활성화 해야하나 테스트 상 비활성화 활성화 후 일반폼의 경우 <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> 추가 필요 
            http.csrf().disable(); 
            // 2. 권한 설정
            http.authorizeRequests()
            // [Admin 전용] 관리자 페이지는 ADMIN 롤만 접근 가능
            .antMatchers("/admin/**").hasRole("ADMIN")
            // [User 전용] 장바구니, 주문, 결제 등은 로그인한 유저(USER, ADMIN)만 가능
            // Guest(로그인 안 한 사용자)는 아래 주소로 접근 시 로그인 페이지로 튕김
            .antMatchers("/cart/**", "/order/**","/delivery/**", "/user/reivew.do", "/user/member.do", "/user/orderList.do", "/user/orderDetailList.do").hasAnyRole("USER", "ADMIN")

            // [공통] 상품 목록, 상세 페이지, 로그인/회원가입 등은 누구나 접근 가능
            .antMatchers("/", "/index.do", "/user/login.jsp", "/user/login.do", "/user/member.do", "/userproduct/**", "/resources/**").permitAll()
            // 그 외 나머지는 인증된 사용자만 (선택 사항)
           
            .anyRequest().permitAll() 
            .and()

            // 3. 일반 폼 로그인 설정
            .formLogin()
            .loginPage("/user/login.do")
            .loginProcessingUrl("/user/loginOK.do")
            .defaultSuccessUrl("/index.do", true)
            .usernameParameter("id")
            .failureHandler(customOAuth2FailureHandler) 
            .permitAll()
            .and()
            // 4. 소셜 로그인 설정
            .oauth2Login()
            .loginPage("/user/login.do")
            .redirectionEndpoint()
                .baseUri("/login/oauth2/code/**") 
                .and()
            .userInfoEndpoint()
                .userService(customOAuth2UserService) 
                .and()
            .defaultSuccessUrl("/index.do", true)
            .failureHandler(customOAuth2FailureHandler) 
            .and()
            // 5. 로그아웃 설정
            .logout()
            .logoutRequestMatcher(new AntPathRequestMatcher("/user/logout.do")) // 이 주소가 호출되면 로그아웃
            .logoutSuccessUrl("/index.do")
            .invalidateHttpSession(true) 
            .deleteCookies("JSESSIONID") 
            .permitAll()
            .and()
            // 6. 세션 관리 (데이터 유실 방지)
            .sessionManagement()
                .sessionFixation().none(); 
        }
    
 // 3. 소셜 클라이언트 등록 정보 설정 (ClientRegistrationRepository)
    @Bean
    public ClientRegistrationRepository clientRegistrationRepository() {
        List<ClientRegistration> registrations = new ArrayList<>();
        registrations.add(googleClientRegistration());
        registrations.add(naverClientRegistration());
        registrations.add(kakaoClientRegistration());
        return new InMemoryClientRegistrationRepository(registrations);
    }

    // 구글 설정
    private ClientRegistration googleClientRegistration() {
        return ClientRegistration.withRegistrationId("google")
                .clientId(googleClientId)
                .clientSecret(googleClientSecret)
                .scope("profile", "email")
                .authorizationUri("https://accounts.google.com/o/oauth2/v2/auth")
                .tokenUri("https://www.googleapis.com/oauth2/v4/token")
                .userInfoUri("https://www.googleapis.com/oauth2/v3/userinfo")
                .userNameAttributeName(IdTokenClaimNames.SUB)
                .clientName("Google")
                .authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
                .redirectUri("{baseUrl}/login/oauth2/code/google")
                .build();
    }

    // 네이버 설정
    private ClientRegistration naverClientRegistration() {
        return ClientRegistration.withRegistrationId("naver")
                .clientId(naverClientId)
                .clientSecret(naverClientSecret)
                .clientAuthenticationMethod(ClientAuthenticationMethod.POST)
                .authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
                .redirectUri("{baseUrl}/login/oauth2/code/naver")
                .scope("name", "email", "profile_image")
                .authorizationUri("https://nid.naver.com/oauth2.0/authorize")
                .tokenUri("https://nid.naver.com/oauth2.0/token")
                .userInfoUri("https://openapi.naver.com/v1/nid/me")
                .userNameAttributeName("response") // 네이버 응답 JSON의 키값
                .clientName("Naver")
                .build();
    }

    private ClientRegistration kakaoClientRegistration() {
        return ClientRegistration.withRegistrationId("kakao")
            .clientId(kakaoClientId)             
            .clientSecret(kakaoClientSecret)     
            .clientAuthenticationMethod(ClientAuthenticationMethod.POST) 
            .authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
            .redirectUri("{baseUrl}/login/oauth2/code/kakao")
            .scope("profile_nickname", "account_email")
            .authorizationUri("https://kauth.kakao.com/oauth/authorize")
            .tokenUri("https://kauth.kakao.com/oauth/token")
            .userInfoUri("https://kapi.kakao.com/v2/user/me")
            .userNameAttributeName("id")
            .clientName("Kakao")
            .build();
    }
  
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}