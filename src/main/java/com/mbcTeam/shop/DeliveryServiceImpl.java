package com.mbcTeam.shop;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;



@Service
public class DeliveryServiceImpl implements  DeliveryService{

	
	@Autowired
	private DeliveryDao ddao;
	
	@Override
	public List<DeliveryVO> getAddressList(long userIdx) {
		// TODO Auto-generated method stub
		return ddao.getAddressList(userIdx);
	}

	@Override
	public void insertAddress(DeliveryVO vo) {
		// TODO Auto-generated method stub
		ddao.insertAddress(vo);
	}

	@Override
	public void deleteAddresses(List<Long> deliveryIdxList) {
		// TODO Auto-generated method stub
		ddao.deleteAddresses(deliveryIdxList);
	}
	@Transactional // 하나라도 실패하면 롤백되도록 설정
    @Override
    public void updateDefaultAddress(long userIdx, long deliveryIdx) {
        // 인터페이스 기준: DAO에서 초기화와 설정을 동시에 처리하도록 설계했으므로 호출만 하면 됨
		ddao.updateDefaultAddress(userIdx, deliveryIdx);
    }

}
