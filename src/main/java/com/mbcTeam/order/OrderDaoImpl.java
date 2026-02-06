package com.mbcTeam.order;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class OrderDaoImpl implements OrderDao {

    @Autowired
    private SqlSessionTemplate mybatis;

    @Override
    public void insert(OrderVO vo) {
        mybatis.insert("ORDERS.insertOrder", vo);
    }

    @Override
    public void insertOrder(OrderVO order, OrderItemVO item) {
        // 1. 주문 저장
        mybatis.insert("ORDERS.insertOrder", order);

        // 2. 주문 상세 저장 (orderIdx를 PK로 받아서 연결)
        item.setOrderIdx(order.getOrderIdx());
        mybatis.insert("ORDERS.insertOrderItem", item);
    }

    @Override
    public void update(OrderVO vo) {
        mybatis.update("ORDERS.updateOrder", vo);
    }

    @Override
    public void delete(OrderVO vo) {
        mybatis.delete("ORDERS.deleteOrder", vo);
    }

    @Override
    public List<OrderVO> select(OrderVO vo) {
        return mybatis.selectList("ORDERS.selectOrder", vo);
    }

	@Override
	public OrderVO selectOrderByOrderIdx(long orderIdx) {
		// orderdetailList에서 표시하기 위한매소드 
		return mybatis.selectOne("ORDER.DETAILLIST",orderIdx);
	}

	@Override
	public List<Map<String,Object>> getMonthlySales(String year) {
		return mybatis.selectList("ORDER.getMonthlySales", year);
		
	}

	@Override
	public List<Map<String, Object>> getCategorySales(Map<String, Object> data) {
		return mybatis.selectList("ORDER.getCategorySales",data);
	}
}
