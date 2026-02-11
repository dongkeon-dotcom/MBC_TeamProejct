package com.mbcTeam.admin;

import java.util.List;
import java.util.Map;

import com.mbcTeam.dto.OrderManagementDTO;
import com.mbcTeam.dto.UserManagementDTO;
import com.mbcTeam.order.OrderItemVO;
import com.mbcTeam.order.OrderVO;
import com.mbcTeam.user.UserVO;

public interface AdminService {

    //매출통계 페이지용
    List<Map<String,Object>> getMonthlySales(String year);					//월별 매출 통계
    List<Map<String,Object>> getCategorySales(Map<String,Object> params);	//카테고리별 매출 통계
    
    //회원관리 페이지용
    List<UserManagementDTO> getUserManagement(UserManagementDTO dto);
    int getUserTotalCount(UserManagementDTO dto);

    //주문관리 페이지용
    List<OrderManagementDTO> getOrderManagement(OrderManagementDTO dto);
    int getOrderTotalCount(OrderManagementDTO dto);
    
    
    //구매자 이력 확인페이지
    UserVO getUserInfo(long value);
    List<OrderVO> getUserOrderList(long value);
    List<OrderItemVO> getUserDetailOrderItems(long value);
}
