package com.mbcTeam.user;

import java.util.List;

import com.mbcTeam.product.ProductVO;

public interface UserDao {
  void insert(UserVO vo);
  
  List<UserVO> Select(UserVO vo);
  
  UserVO Login(UserVO vo);
  
  UserVO Edit(UserVO vo);
  

  // 이메일 중복 체크
  boolean existsByEmail(String userID);
	

  UserVO getByEmail(String userID);
  List<ProductVO> selectOrderList(ProductVO vo); 
}
