package com.mbcTeam.security;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.mbcTeam.user.UserVO;
@Service
public class CustomUserDetailsService implements UserDetailsService{
	@Autowired
	private MemberMapper memberMapper;
	@Autowired
	private HttpSession session; // 세션 주입// 일반로그인만 찍히는게 맞습니다 아이고 
	@Override
	public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
	    System.out.println("로그인 시도 아이디: " + id);
	    UserVO user = memberMapper.getByEmail(id);

	    if (user == null) {
	        throw new UsernameNotFoundException("존재하지 않는 사용자: " + id);
	    }

	    // ★ 여기에 추가: 탈퇴 처리된 회원(isDeleted = true/1)인지 확인
	    if (user.isDeleted()) {
	        System.out.println("탈퇴된 회원 로그인 시도 차단: " + id);
	        // 시큐리티 전용 예외인 DisabledException을 던집니다.
	        throw new org.springframework.security.authentication.DisabledException("탈퇴 처리 중인 계정입니다.");
	    }

	    // 세션 저장 로직 (기존 코드 유지)
	    session.setAttribute("userIdx", user.getUserIdx());
	    session.setAttribute("userName", user.getUserName());
	    session.setAttribute("loginType", 0);

	    System.out.println("로그인 성공 유저: " + user.getUserName());

	    return User.builder()
	            .username(user.getId())
	            .password(user.getPassword())
	            .roles(user.getUserRole())
	            // 시큐리티 내부 빌더에서도 비활성화를 알려주면 더 좋습니다.
	            .disabled(user.isDeleted()) 
	            .build();
	}

}

