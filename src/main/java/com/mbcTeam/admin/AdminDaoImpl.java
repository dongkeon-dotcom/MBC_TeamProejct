package com.mbcTeam.admin;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mbcTeam.dto.OrderManagementDTO;
import com.mbcTeam.dto.UserManagementDTO;
import com.mbcTeam.order.OrderItemVO;
import com.mbcTeam.order.OrderVO;
import com.mbcTeam.user.UserVO;

@Repository
public class AdminDaoImpl implements AdminDao {

	@Autowired
	private SqlSessionTemplate mybatis;

	// 매출통계 페이지용
	@Override
	public List<Map<String, Object>> getMonthlySales(String year) {
		return mybatis.selectList("ORDER.getMonthlySales", year);
	}

	@Override
	public List<Map<String, Object>> getCategorySales(Map<String, Object> data) {
		return mybatis.selectList("ORDER.getCategorySales", data);
	}

	// 회원관리 페이지용
	@Override
	public List<UserManagementDTO> getUserManagement(UserManagementDTO dto) {
		return mybatis.selectList("USER.getUserManagement", dto);
	}

	@Override
	public int getUserTotalCount(UserManagementDTO dto) {
		return mybatis.selectOne("USER.GET_USER_TOTAL_COUNT", dto);
	}

	// 구매자 이력 확인페이지
	@Override
	public UserVO getUserInfo(long value) {
		return mybatis.selectOne("USER.GET_USER_INFO", value);
	}

	@Override
	public List<OrderVO> getUserOrderList(long value) {
		return mybatis.selectList("ORDER.GET_USER_ORDER_LIST", value);
	}

	@Override
	public List<OrderItemVO> getUserDetailOrderItems(long value) {
		return mybatis.selectList("ORDER.GET_USER_DETAIL_ORDER_ITEMS", value);
	}

	@Override
	public List<OrderManagementDTO> getOrderManagement(OrderManagementDTO dto) {
		return mybatis.selectList("ORDER.GET_ORDER_MANAGEMENT", dto);
	}

	@Override
	public int getOrderTotalCount(OrderManagementDTO dto) {
		return mybatis.selectOne("ORDER.GET_ORDER_TOTAL_COUNT", dto);
	}

}
