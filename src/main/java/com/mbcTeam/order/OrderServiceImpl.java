package com.mbcTeam.order;

import java.util.List; 

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;




@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao dao;

    @Override
    public void insertOrder(OrderVO order, OrderItemVO item) {
        dao.insertOrder(order, item);
    }

    @Override
    public void insert(OrderVO vo) {
        dao.insert(vo);
    }

    @Override
    public List<OrderVO> select(OrderVO vo) {
        return dao.select(vo);
    }

    @Override
    public void update(OrderVO vo) {
        dao.update(vo);
    }

    @Override
    public void delete(OrderVO vo) {
        dao.delete(vo);
    }

	@Override
	public OrderVO selectOrderByOrderIdx(long orderIdx) {
		// TODO Auto-generated method stub
		return dao.selectOrderByOrderIdx(orderIdx);
	}

	
	@Override
	public void insertOrder(OrderVO order, List<OrderItemVO> items) {
	    // 주문 저장
	    dao.insert(order);

	    // 주문 상세 반복 저장
	    for (OrderItemVO item : items) {
	        item.setOrderIdx(order.getOrderIdx()); // FK 연결
	        dao.insertOrderItem(item); // ✅ 새로 추가된 메서드 사용
	    }
	}


	
}
