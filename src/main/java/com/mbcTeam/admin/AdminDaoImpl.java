package com.mbcTeam.admin;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mbcTeam.dto.UserManagementDTO;

@Repository
public class AdminDaoImpl implements AdminDao{

    @Autowired
    private SqlSessionTemplate mybatis;

	@Override
	public List<Map<String,Object>> getMonthlySales(String year) {
		return mybatis.selectList("ORDER.getMonthlySales", year);	
	}
	
	@Override
	public List<Map<String, Object>> getCategorySales(Map<String, Object> data) {
		return mybatis.selectList("ORDER.getCategorySales",data);
	}

	@Override
	public List<UserManagementDTO> getUserManagement(UserManagementDTO dto) {
		return mybatis.selectList("USER.getUserManagement", dto);
	}

	@Override
	public int getUserTotalCount(UserManagementDTO dto) {
		return mybatis.selectOne("USER.GET_USER_TOTAL_COUNT", dto);
	}
}
