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
    public void insertOrderItem(OrderItemVO item) {
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


	@Override
	public int deductStock(int optionIdx, int quantity) {
	    java.util.Map<String, Object> map = new java.util.HashMap<>();
	    map.put("optionIdx", optionIdx);
	    map.put("quantity", quantity);
	    // 쿼리 실행 후 영향을 받은 행(row)의 수를 반환 (성공하면 1, 재고부족 시 0)
	    return mybatis.update("ORDER.deductStock", map);
	}

//	@Override
//	public void insertTest() {
//		mybatis.insert("ORDER.INSERT_TEST");		
//	}


}
