package com.mbcTeam.order;

import java.util.List;


public interface OrderDao {
    void insert(OrderVO vo); // 주문 저장
    void insertOrder(OrderVO order, OrderItemVO item); // 주문 + 단일 상세 저장
    void insertOrderItem(OrderItemVO item); // ✅ 주문 상세만 저장 (추가)

    void update(OrderVO vo);
    void delete(OrderVO vo);
    List<OrderVO> select(OrderVO vo);
    OrderVO selectOrderByOrderIdx(long orderIdx);
    int deductStock(int optionIdx, int quantity); // 재고 차감 확인용
    
    
}

