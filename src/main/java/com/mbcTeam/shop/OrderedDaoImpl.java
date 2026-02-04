package com.mbcTeam.shop;

import java.util.HashMap; 
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class OrderedDaoImpl implements OrderedDao{

	@Autowired
    private SqlSessionTemplate mybatis;

	

	@Override
	public List<OrderedVO> selectOrderedList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return mybatis.selectList("ORDERED.SELECT_ORDER_LIST", params);
	}

	@Override
	public int countOrderedList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return mybatis.selectOne("ORDERED.COUNT_ORDER_LIST", params);
	}

	@Override
	public OrderedVO selectOrderByOrderedIdx(long orderIdx) {
		// orderdetailList에서 표시하기 위한매소드 
		return mybatis.selectOne("ORDERED.DETAILLIST",orderIdx);
	}

	@Override
	public List<OrderItemedVO> selectOrderedItems(long orderIdx) {
		// TODO Auto-generated method stub
		return mybatis.selectList("ORDERED.DETAILITEM",orderIdx);
	}

	    
	}

	

