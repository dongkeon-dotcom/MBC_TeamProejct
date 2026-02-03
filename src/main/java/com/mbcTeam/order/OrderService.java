package com.mbcTeam.order;

import java.util.List;




public interface OrderService {
		
	    void insert(OrderVO vo); 
	    void insertOrder(OrderVO order, OrderItemVO item);
	    
	    
	    void update(OrderVO vo); 
	    void delete(OrderVO vo); 

	    List<OrderVO> select(OrderVO vo); 
	    OrderVO selectOrderByOrderIdx(long orderIdx);
	    

	  

	
}
