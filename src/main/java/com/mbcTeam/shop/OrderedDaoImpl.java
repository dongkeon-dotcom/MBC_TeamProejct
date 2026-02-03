package com.mbcTeam.shop;

import java.util.HashMap; 
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mbcTeam.order.OrderItemVO;
import com.mbcTeam.order.OrderVO;
@Repository
public class OrderedDaoImpl implements OrderedDao{

	@Autowired
    private SqlSessionTemplate mybatis;

	

	@Override
	public List<OrderVO> selectOrderList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return mybatis.selectList("ORDER.SELECT_ORDER_LIST", params);
	}

	@Override
	public int countOrderList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return mybatis.selectOne("ORDER.COUNT_ORDER_LIST", params);
	}

	@Override
	public OrderVO selectOrderByOrderIdx(long orderIdx) {
		// orderdetailList에서 표시하기 위한매소드 
		return mybatis.selectOne("ORDER.DETAILLIST",orderIdx);
	}

	@Override
	public List<OrderItemVO> selectOrderItems(long orderIdx) {
		// TODO Auto-generated method stub
		return mybatis.selectList("ORDER.DETAILITEM",orderIdx);
	}

	    
	}

	

