package com.mbcTeam.admin;

import java.util.List;
import java.util.Map;

import com.mbcTeam.dto.UserManagementDTO;

public interface AdminDao {

    //매출통계 페이지용
    List<Map<String,Object>> getMonthlySales(String year);					//월별 매출 통계
    List<Map<String,Object>> getCategorySales(Map<String,Object> params);	//카테고리별 매출 통계
    
    //회원관리 페이지용
    List<UserManagementDTO> getUserManagement(UserManagementDTO dto);
    int getUserTotalCount(UserManagementDTO dto);
}
