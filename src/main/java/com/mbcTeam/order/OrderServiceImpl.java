package com.mbcTeam.order;

import java.util.List; 

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;




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
    @Transactional // 하나라도 실패하면 전체 롤백
    public void insertOrder(OrderVO order, List<OrderItemVO> items) {
        // 1. Orders 테이블 저장 (orderIdx가 생성됨)
        dao.insert(order); 

        // 2. 생성된 orderIdx를 각 상세 아이템에 주입 후 저장
        for (OrderItemVO item : items) {
            item.setOrderIdx(order.getOrderIdx()); 
            dao.insertOrderItem(item);
        }
        
        
    }


	
	
	
}
