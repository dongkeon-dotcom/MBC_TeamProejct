package com.mbcTeam.user;

import java.util.List; 

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserDaoImpl implements UserDao {
	
	@Autowired
	private SqlSessionTemplate mybatis;
	
	@Override
	public void insert(UserVO vo) {
		mybatis.update("MEMBER.INSERT", vo);
		
	}

	@Override
	public List<UserVO> Select(UserVO vo) {

		return mybatis.selectList("MEMBER.SELECT");
	}

	@Override
	public UserVO Login(UserVO vo) {
		// TODO Auto-generated method stub
		return mybatis.selectOne("MEMBER.LOGIN", vo);
	}

	@Override
	public UserVO Edit(UserVO vo) {
		// TODO Auto-generated method stub
		return mybatis.selectOne("MEMBER.EDIT", vo);
	}

}
