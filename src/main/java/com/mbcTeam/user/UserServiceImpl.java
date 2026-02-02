package com.mbcTeam.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcTeam.product.ProductVO;

@Service
public class UserServiceImpl implements UserService  {

	@Autowired
	private UserDao dao;
	
	@Override
	public void insert(UserVO vo) {
		dao.insert(vo);		
	}

	@Override
	public List<UserVO> Select(UserVO vo) {
		// TODO Auto-generated method stub
		return dao.Select(vo);
	}

	@Override
	public UserVO Login(UserVO vo) {
		// TODO Auto-generated method stub
		return dao.Login(vo);
	}

	@Override
	public UserVO Edit(UserVO vo) {
		// TODO Auto-generated method stub
		return dao.Edit(vo);
	}

	@Override
	public boolean existsByEmail(String userID) {
		// TODO Auto-generated method stub
		return dao.existsByEmail(userID);
	}

	@Override
	public UserVO getByEmail(String userID) {
		// TODO Auto-generated method stub
		return dao.getByEmail(userID);
	}

	@Override
	public List<ProductVO> selectOrderList(ProductVO vo) {
		// TODO Auto-generated method stub
		return dao.selectOrderList(vo);
	}

}
