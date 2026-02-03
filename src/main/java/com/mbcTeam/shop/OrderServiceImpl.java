package com.mbcTeam.shop;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OrderServiceImpl implements OrderService{
	@Autowired
    private OrderDao odao;

    @Override
    public List<OrderVO> selectOrderList(long userIdx, String startDate, String endDate, int offset, int pageSize) {
        Map<String, Object> params = new HashMap<>();
        params.put("userIdx", userIdx);
        params.put("startDate", startDate);
        params.put("endDate", endDate);
        params.put("offset", offset);
        params.put("pageSize", pageSize);
        
        return odao.selectOrderList(params);
    }

    @Override
    public int countOrderList(long userIdx, String startDate, String endDate) {
        Map<String, Object> params = new HashMap<>();
        params.put("userIdx", userIdx);
        params.put("startDate", startDate);
        params.put("endDate", endDate);
        
        return odao.countOrderList(params);
    }

	@Override
	public OrderVO selectOrderByOrderIdx(long orderIdx) {
		// TODO Auto-generated method stub
		return odao.selectOrderByOrderIdx(orderIdx);
	}

	@Override
	public List<OrderItemVO> selectOrderItems(long orderIdx) {
		// TODO Auto-generated method stub
		return odao.selectOrderItems(orderIdx);
	}
}