package com.mbcTeam.shop;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DeliveryDaoImpl implements DeliveryDao{

	@Autowired
    private SqlSessionTemplate mybatis;

	@Override
	public List<DeliveryVO> getAddressList(long userIdx) {
		// TODO Auto-generated method stub
		return mybatis.selectList("ADDRESS.ADDRLIST",userIdx);
	}

	@Override
	public void insertAddress(DeliveryVO vo) {
		// TODO Auto-generated method stub
		mybatis.insert("ADDRESS.ADDRINSERT", vo );
	}

	@Override //선택 주소 삭제 
	public void deleteAddresses(List<Long> deliveryIdxList) {
		// TODO Auto-generated method stub
		mybatis.delete("ADDRESS.ADDRDELLIST", deliveryIdxList );
	}

	@Override 
	public void updateDefaultAddress(long userIdx, long deliveryIdx) {
	    // DAO에서는 "특정 주소를 기본(Y)으로 설정"하는 이 쿼리 하나만 담당하게 합니다.
	    // 어차피 deliveryIdx는 고유값이므로 userIdx 없이 deliveryIdx만 넘겨도 충분합니다.
	    mybatis.update("ADDRESS.setDefaultAddress", deliveryIdx);
	}

	@Override
	public DeliveryVO getOneAddress(long deliveryIdx) {
		// TODO Auto-generated method stub
		return mybatis.selectOne("ADDRESS.getOneAddress", deliveryIdx);
	}
	@Override
	public void addrUpdate(DeliveryVO vo) {
	    // 1. 만약 이번에 수정하는 주소가 '기본 배송지'로 체크되었다면 (true)
	    if (vo.isDefaultAddress()) {
	        // 해당 유저의 모든 주소를 0으로 만드는 리셋 쿼리 실행
	        // 매퍼 ID는 "ADDRESS.resetDefaultAddress" (보여주신 XML 기준)
	        mybatis.update("ADDRESS.resetDefaultAddress", vo.getUserIdx());
	    }
	    
	    // 2. 실제 해당 주소의 정보를 업데이트 (이름, 주소, 기본배송지 여부 등)
	    // 여기서 vo안의 isDefaultAddress가 1(true)이므로 최종적으로 이 주소만 1이 됨
	    mybatis.update("ADDRESS.addrUpdate", vo);
	}

	@Override
	public void resetDefaultAddress(long userIdx) {
		// TODO Auto-generated method stub
		mybatis.update("ADDRESS.resetDefaultAddress", userIdx);
	}

	

	
	
	
}
