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
		System.out.println("member(1):" + id);
		UserVO user = memberMapper.getByEmail(id);
        System.out.println("member(2):" + id);

		if (user == null) {
		   throw new UsernameNotFoundException(id);
		}
		session.setAttribute("userIdx", user.getUserIdx()); // 이 한 줄 추가응 
		session.setAttribute("userName", user.getUserName());
		session.setAttribute("loginType", 0); // ★ 일반 로그인은 항상 0으로 세팅!
		 System.out.println("이름 (2):" + user.getUserName());
			System.out.println("유저 (2):" + user.getId());
		return User.builder()
		.username(user.getId())
		.password(user.getPassword())
		.roles(user.getUserRole())
		.build();
		}

}

