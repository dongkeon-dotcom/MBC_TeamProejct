package com.mbcTeam.security;


import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mbcTeam.user.UserVO;


@Repository
public class MemberMapperDao implements MemberMapper {

			@Autowired
			private SqlSessionTemplate mybatis;
			
			@Override
			public UserVO getByEmail(String id) {
				// TODO Auto-generated method stub
				return mybatis.selectOne("USER.getByEmail", id);
			}
}

