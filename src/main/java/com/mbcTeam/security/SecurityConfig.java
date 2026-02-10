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
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.core.oidc.IdTokenClaimNames;
import java.util.ArrayList;
import java.util.List;
@SuppressWarnings("deprecation")
@Configuration
@EnableWebSecurity
@PropertySource("classpath:config/oauth.properties")
public class SecurityConfig extends WebSecurityConfigurerAdapter{

	
	SecurityConfig(){
		System.out.println("==>SecurityConfig들어옴 ");
	}
	
	
	@Autowired
	private CustomUserDetailsService userDetailsService;
	

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String googleClientId;
    @Value("${spring.security.oauth2.client.registration.google.client-secret}")
    private String googleClientSecret;

    @Value("${spring.security.oauth2.client.registration.naver.client-id}")
    private String naverClientId;
    @Value("${spring.security.oauth2.client.registration.naver.client-secret}")
    private String naverClientSecret;

    @Value("${spring.security.oauth2.client.registration.kakao.client-id}")
    private String kakaoClientId;
    @Value("${spring.security.oauth2.client.registration.kakao.client-secret}")
    private String kakaoClientSecret;

    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }
    @Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
	    auth.userDetailsService(userDetailsService)
	   .passwordEncoder(passwordEncoder());
	}
    
    
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable(); // CSRF 비활성화
        
        http.authorizeRequests()
            // 1. 누구나 접근 가능한 경로 (로그인, 회원가입, 정적 리소스 등)
            .antMatchers("/user/login.do", "/user/memberJoin.do", "/user/memberOK.do", "/main.do", "/index.do", "/resources/**").permitAll()
            
            // 2. /user/** 전체를 permitAll 하셨으므로, 사실 위 설정들이 여기에 포함됩니다.
            // 만약 마이페이지처럼 '로그인한 사람만' 가야 하는 곳이 있다면 나중에 .authenticated()로 세밀하게 조정하세요.
            .antMatchers("/user/**").permitAll() 
            
            .anyRequest().authenticated() // 그 외 모든 요청은 로그인 필요
            .and()
            
        .formLogin()
            .loginPage("/user/login.do")             // 커스텀 로그인 페이지
            .loginProcessingUrl("/user/loginOK.do")   // 실제 로그인 처리 (이건 컨트롤러 안 만들어도 됨)
            .defaultSuccessUrl("/index.do", true)      // 성공 시 메인으로 (index.do와 main.do 중 사용하는 걸로 맞추세요)
            .usernameParameter("id")
            .passwordParameter("password")
            .permitAll()
            .and()
            
        .logout()
            .logoutUrl("/user/logout.do")             // 로그아웃 요청 경로
            .logoutSuccessUrl("/index.do")            // 성공 후 메인으로
            .invalidateHttpSession(true)
            .deleteCookies("JSESSIONID")
            // 아래 설정 덕분에 <a> 태그 클릭으로 로그아웃이 가능해집니다!
            .logoutRequestMatcher(new AntPathRequestMatcher("/user/logout.do")) 
            .permitAll();
    }
	  
   /*
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .antMatchers("/", "/index.do", "/user/login.do", 
                		"/user/member.do", "/user/insert.do", 
                             "/resources/**", "/static/**", 
                             "/login/oauth2/code/**", "/oauth2/authorization/**").permitAll()
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
            		.loginPage("/user/loginOK.do")              // 로그인 화면 주소
            	    .loginProcessingUrl("/user/loginOK.do")      // JSP의 <form action> 주소와 일치시킴!
            	    .usernameParameter("id")                    // JSP의 <input name="id">와 일치시킴! (중요)
            	    .passwordParameter("password")              // JSP의 <input name="password">와 일치
            	    .defaultSuccessUrl("/index.do", true )       // 로그인 성공 시 이동
            	    .permitAll()
            )
            
            .logout(logout -> logout
            	    .logoutUrl("/user/logout.do")          // 사용자가 로그아웃을 요청할 주소
            	    .logoutSuccessUrl("/")                 // 로그아웃 성공 후 이동할 주소
            	    .invalidateHttpSession(true)           // 세션 삭제
            	    .deleteCookies("JSESSIONID")           // 쿠키 삭제
            	    .permitAll()
            	)
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/user/loginOK.do")
                // [필수] 서블릿이 *.do만 받으므로 콜백 주소에도 .do가 붙도록 설정
                .redirectionEndpoint(redirection -> redirection
                    .baseUri("/login/oauth2/code/*.do") 
                )
                
                .userInfoEndpoint(userInfo -> userInfo.userService(customOAuth2UserService))
                .successHandler(oauth2SuccessHandler)
               
            )
            .userDetailsService(securityUserDetailsService);
        return http.build();
    }


    @Bean
    public ClientRegistrationRepository clientRegistrationRepository() {
        List<ClientRegistration> registrations = new ArrayList<>();
        registrations.add(googleClientRegistration());
        registrations.add(naverClientRegistration());
        registrations.add(kakaoClientRegistration());
        return new InMemoryClientRegistrationRepository(registrations);
    }

    // 각 설정의 redirectUri 끝에 .do를 추가하여 서블릿 매핑과 일치시킵니다.
    private ClientRegistration kakaoClientRegistration() {
        return ClientRegistration.withRegistrationId("kakao")
            .clientId(kakaoClientId)
            .clientSecret(kakaoClientSecret)
            .authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
            .redirectUri("{baseUrl}/login/oauth2/code/{registrationId}.do")
            .scope("profile_nickname", "account_email")
            .authorizationUri("https://kauth.kakao.com/oauth/authorize")
            .tokenUri("https://kauth.kakao.com/oauth/token")
            .userInfoUri("https://kapi.kakao.com/v2/user/me")
            .userNameAttributeName("id")
            .clientName("Kakao")
            .build();
    }  

    private ClientRegistration googleClientRegistration() {
        return ClientRegistration.withRegistrationId("google")
            .clientId(googleClientId)
            .clientSecret(googleClientSecret)
            .redirectUri("{baseUrl}/login/oauth2/code/{registrationId}.do")
            .scope("profile", "email")
            .authorizationUri("https://accounts.google.com/o/oauth2/v2/auth")
            .tokenUri("https://www.googleapis.com/oauth2/v4/token")
            .userInfoUri("https://www.googleapis.com/oauth2/v3/userinfo")
            .userNameAttributeName(IdTokenClaimNames.SUB)
            .clientName("Google")
            .authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
            .build();
    }

    private ClientRegistration naverClientRegistration() {
        return ClientRegistration.withRegistrationId("naver")
            .clientId(naverClientId)
            .clientSecret(naverClientSecret)
            .redirectUri("{baseUrl}/login/oauth2/code/{registrationId}.do")
            .authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
            .authorizationUri("https://nid.naver.com/oauth2.0/authorize")
            .tokenUri("https://nid.naver.com/oauth2.0/token")
            .userInfoUri("https://openapi.naver.com/v1/nid/me")
            .userNameAttributeName("response")
            .clientName("Naver")
            .build();
    }
    */

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}