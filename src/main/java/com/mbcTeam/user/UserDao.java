package com.mbcTeam.user;

import java.util.List;

import com.mbcTeam.product.ProductVO;
import com.mbcTeam.shop.DeliveryVO;

public interface UserDao {
  void insert(UserVO vo);
  
  List<UserVO> Select(UserVO vo);
  
  UserVO Login(UserVO vo);
  
  UserVO Edit(UserVO vo);

  

  // 이메일 중복 체크
  boolean existsByEmail(String userID);
	

  UserVO getByEmail(String userID);
  List<ProductVO> selectOrderList(ProductVO vo); 
  
//후기 저장을 위한 컨트롤러에 사용 
int insertReview(ReviewVO vo);
void insertReviewImg(ReviewImageVO imgVO);
//수정을 위한 매소
void updateUser(UserVO vo);
//추가: ID로 사용자 정보 조회
UserVO getUserById(String id);

// 마이페이지 회원정보 수정에서 주소확인ㅇ르 위한 메소드 
DeliveryVO getDelivery(long userIdx);
}
