package com.mbcTeam.shop;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OrderedServiceImpl implements OrderedService{
	
	@Autowired
    private OrderedDao odao;

    @Override
    public List<OrderedVO> selectOrderedList(long userIdx, String startDate, String endDate, int offset, int pageSize) {
        Map<String, Object> params = new HashMap<>();
        params.put("userIdx", userIdx);
        params.put("startDate", startDate);
        params.put("endDate", endDate);
        params.put("offset", offset);
        params.put("pageSize", pageSize);
        
        return odao.selectOrderedList(params);
    }

    @Override
    public int countOrderedList(long userIdx, String startDate, String endDate) {
        Map<String, Object> params = new HashMap<>();
        params.put("userIdx", userIdx);
        params.put("startDate", startDate);
        params.put("endDate", endDate);
        
        return odao.countOrderedList(params);
    }

	@Override
	public OrderedVO selectOrderedByOrderIdx(long orderIdx) {
		// TODO Auto-generated method stub
		return odao.selectOrderByOrderedIdx(orderIdx);
	}

	@Override
	public List<OrderItemedVO> selectOrderedItems(long orderIdx) {
		// TODO Auto-generated method stub
		return odao.selectOrderedItems(orderIdx);
	}
}