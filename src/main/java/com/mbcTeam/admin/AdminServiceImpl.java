package com.mbcTeam.admin;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcTeam.dto.UserManagementDTO;
import com.mbcTeam.order.OrderItemVO;
import com.mbcTeam.order.OrderVO;
import com.mbcTeam.user.UserVO;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	private AdminDao dao;
	
	@Override
	public List<Map<String,Object>>  getMonthlySales(String year) {
		
		return dao.getMonthlySales(year);	
	}

	@Override
	public List<Map<String, Object>> getCategorySales(Map<String,Object> data) {
		return dao.getCategorySales(data);
	}

	@Override
	public List<UserManagementDTO> getUserManagement(UserManagementDTO dto) {
		return dao.getUserManagement(dto);
	}

	@Override
	public int getUserTotalCount(UserManagementDTO dto) {
		return dao.getUserTotalCount(dto);
	}

	@Override
	public UserVO getUserInfo(long value) {
		return dao.getUserInfo(value);
	}

	@Override
	public List<OrderVO> getUserOrderList(long value) {
		return dao.getUserOrderList(value);
	}

	@Override
	public List<OrderItemVO> getUserDetailOrderItems(long value) {
		return dao.getUserDetailOrderItems(value);
	}
}
