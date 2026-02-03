package com.mbcTeam.shop;

import java.util.List;

import org.springframework.stereotype.Service;

import com.mbcTeam.order.OrderItemVO;
import com.mbcTeam.order.OrderVO;


public interface OrderedService {
	// 주문 내역 리스트 조회
    List<OrderVO> selectOrderList(long userIdx, String startDate, String endDate, int offset, int pageSize);
    
    // 전체 주문 개수 조회 (페이징용)
    int countOrderList(long userIdx, String startDate, String endDate);

    // 1. 주문 번호로 주문 기본 정보(배송지 등) 가져오기
    OrderVO selectOrderByOrderIdx(long orderIdx);

    // 2. 주문 번호로 해당 주문에 속한 상품 리스트 가져오기
    List<OrderItemVO> selectOrderItems(long orderIdx);
}
