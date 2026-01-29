package com.mbcTeam.user;

import java.util.List;

public interface UserDao {
  void insert(UserVO vo);
  
  List<UserVO> Select(UserVO vo);
  
  UserVO Login(UserVO vo);
  
  UserVO Edit(UserVO vo);
}
