package com.mbcTeam.user;

import java.util.List; 

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mbcTeam.product.ProductVO;

@Repository
public class UserDaoImpl implements UserDao {
	
	@Autowired
	private SqlSessionTemplate mybatis;
	
	@Override
	public void insert(UserVO vo) {
		mybatis.insert("USER.INSERT", vo);
		
	}

	@Override
	public List<UserVO> Select(UserVO vo) {

		return mybatis.selectList("USER.SELECT",vo);
	}

	@Override
	public UserVO Login(UserVO vo) {
		// TODO Auto-generated method stub
		return mybatis.selectOne("USER.LOGIN", vo);
	}

	@Override
	public UserVO Edit(UserVO vo) {
		// TODO Auto-generated method stub
		return mybatis.selectOne("USER.EDIT", vo);
	}

	@Override
	public boolean existsByEmail(String userID) {
		// TODO Auto-generated method stub
		
		Integer count = mybatis.selectOne("USER.countByEmail", userID);
		return count != null && count > 0;

	}

	@Override
	public UserVO getByEmail(String userID) {
		// TODO Auto-generated method stub

		 return mybatis.selectOne("USER.getByEmail", userID);
	}

	@Override
	public List<ProductVO> selectOrderList(ProductVO vo ) {
		// TODO Auto-generated method stub
		return mybatis.selectList("USER.selectOrder",vo );
	}

}
