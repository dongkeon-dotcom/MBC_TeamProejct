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

	@Transactional
	public void insertAddress(DeliveryVO vo) {
	    // 만약 기본 배송지로 체크했다면 리셋 먼저 실행
	    if (vo.isDefaultAddress()) {
	        ddao.resetDefaultAddress(vo.getUserIdx());
	    }
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

	@Override
	public DeliveryVO getOneAddress(long deliveryIdx) {
		// TODO Auto-generated method stub
		return ddao.getOneAddress(deliveryIdx);
	}

	
	// 수정 메서드 수정
	@Transactional
	public void addrUpdate(DeliveryVO vo) {
	    // 수정 시에도 기본 배송지 체크 시 리셋 실행
	    if (vo.isDefaultAddress()) {
	        ddao.resetDefaultAddress(vo.getUserIdx());
	    }
	    ddao.addrUpdate(vo);
	}

	
}
