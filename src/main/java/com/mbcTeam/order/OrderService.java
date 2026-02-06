package com.mbcTeam.order;

import java.util.List;
import java.util.Map;




public interface OrderService {
		
	    void insert(OrderVO vo); 
	    void insertOrder(OrderVO order, OrderItemVO item);
	    
	    
	    void update(OrderVO vo); 
	    void delete(OrderVO vo); 

	    List<OrderVO> select(OrderVO vo); 
	    OrderVO selectOrderByOrderIdx(long orderIdx);
	    
	    //매출통계 페이지용
	    List<Map<String,Object>> getMonthlySales(String year);					//월별 매출 통계
	    List<Map<String,Object>> getCategorySales(Map<String,Object> params);	//카테고리별 매출 통계
	    

	  

	
}
