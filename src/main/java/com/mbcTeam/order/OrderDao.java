package com.mbcTeam.order;

import java.util.List;

public interface OrderDao {
    void insert(OrderVO vo);
    void insertOrder(OrderVO order, OrderItemVO item); // 주문 + 상세 함께 저장
    void update(OrderVO vo);
    void delete(OrderVO vo);
    List<OrderVO> select(OrderVO vo);
}
