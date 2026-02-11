package com.mbcTeam.order;

import java.util.List; 


import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class OrderDaoImpl implements OrderDao {

    @Autowired
    private SqlSessionTemplate mybatis;

    @Override
    public void insert(OrderVO vo) {
        mybatis.insert("ORDER.insertOrder", vo);
    }

    @Override
    public void insertOrder(OrderVO order, OrderItemVO item) {
        mybatis.insert("ORDER.insertOrder", order);
        item.setOrderIdx(order.getOrderIdx());
        mybatis.insert("ORDER.insertOrderItem", item);
    }

    @Override
    public void insertOrderItem(OrderItemVO item) { // ✅ 새로 추가
        mybatis.insert("ORDER.insertOrderItem", item);
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





}
