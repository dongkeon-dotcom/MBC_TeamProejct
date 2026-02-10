
package com.mbcTeam.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	/*
	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		 http
	        .csrf(csrf -> csrf.disable())
	        .authorizeHttpRequests(auth -> auth
	            .antMatchers("/", "/login/**", "/resources/**").permitAll() // 로그인 페이지 등은 허용
	            .anyRequest().authenticated()
	        )
	        .formLogin(form -> form
	            .loginPage("/login") // 커스텀 로그인 페이지가 있다면 설정
	            .defaultSuccessUrl("/")
	        )
	        // --- 여기 OAuth2 설정을 추가합니다 ---
	        .oauth2Login(oauth2 -> oauth2
	            .loginPage("/login") // 소셜 로그인 버튼이 있는 페이지
	            .defaultSuccessUrl("/loginSuccess") // 성공 시 이동할 곳
	            // .userInfoEndpoint(userInfo -> userInfo.userService(customOAuth2UserService)) // 사용자 정보 처리 (중요)
	        );
		  return http.build();}

    */
    @Bean
    public UserDetailsService userDetailsService() {
        UserDetails user = User.withUsername("user")
            .password(passwordEncoder().encode("1234"))
            .roles("USER")
            .build();
        System.out.println("SecurityConfig 2");
        return new InMemoryUserDetailsManager(user);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
    	System.out.println("SecurityConfig 3");
        return new BCryptPasswordEncoder();
    }
    
}
