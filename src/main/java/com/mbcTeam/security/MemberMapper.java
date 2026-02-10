package com.mbcTeam.security;
import com.mbcTeam.user.UserVO;

public interface MemberMapper {
	
	UserVO getByEmail(String id);

}

