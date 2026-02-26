package com.mbcTeam.order;

import java.util.List; 

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;




@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao dao;

    @Override
    public void insert(OrderVO vo) {
        dao.insert(vo);
    }

    @Override
    public List<OrderVO> select(OrderVO vo) {
        return dao.select(vo);
    }

    @Override
    public void update(OrderVO vo) {
        dao.update(vo);
    }

    @Override
    public void delete(OrderVO vo) {
        dao.delete(vo);
    }

	@Override
	public OrderVO selectOrderByOrderIdx(long orderIdx) {
		// TODO Auto-generated method stub
		return dao.selectOrderByOrderIdx(orderIdx);
	}
	
	


	@Override
	@Transactional(rollbackFor = Exception.class) // 어떤 에러가 나도 전체 취소
	public void insertOrder(OrderVO order, List<OrderItemVO> items) {
	    // 1. Orders 테이블 저장 (orderIdx가 생성됨)
	    dao.insert(order); 

	    // 2. 각 상세 아이템 처리
	    for (OrderItemVO item : items) {
	        // [추가된 로직] 재고 차감 시도
	        // VO에 추가하신 optionIdx를 사용합니다.
	        int result = dao.deductStock(item.getOptionIdx(), item.getQuantity());
	        
	        if (result == 0) {
	            // WHERE 조건(stock >= quantity) 때문에 재고가 없으면 0이 반환됨
	            // 런타임 예외를 발생시켜서 1번에서 저장한 Orders까지 롤백시킵니다.
	            throw new RuntimeException(item.getProductName() + " 상품의 재고가 부족합니다.");
	        }

	        // 3. 생성된 orderIdx를 상세 아이템에 주입 후 저장
	        item.setOrderIdx(order.getOrderIdx()); 
	        dao.insertOrderItem(item);
	    }
	}

	@Override
	@Transactional(rollbackFor = Exception.class) // 추가
	public void Test() {
		dao.insertTest();
		dao.insertTest();
	}
	
	
	
}
