package com.mbcTeam.shop;

import java.util.List;
import java.util.Map;

public interface OrderDao {
	// 파라미터 5개를 Map<String, Object> 하나로 합쳐서 받겠다고 수정
    List<OrderVO> selectOrderList(Map<String, Object> params);

    // 여기도 Map으로 수정
    int countOrderList(Map<String, Object> params);
    
 // 1. 주문 번호로 주문 기본 정보(배송지 등) 가져오기
    OrderVO selectOrderByOrderIdx(long orderIdx);

    // 2. 주문 번호로 해당 주문에 속한 상품 리스트 가져오기
    List<OrderItemVO> selectOrderItems(long orderIdx);
}