package com.mbcTeam.security;

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

	@Override
	public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
		System.out.println("member(1):" + id);
		UserVO user = memberMapper.getByEmail(id);
        System.out.println("member(2):" + id);

		if (user == null) {
		   throw new UsernameNotFoundException(id);
		}

		return User.builder()
		.username(user.getId())
		.password(user.getPassword())
		.roles(user.getUserRole())
		.build();
		}
}

