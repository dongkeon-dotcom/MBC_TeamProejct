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

	@Override //단일 주소삭제 
	public void updateDefaultAddress(long userIdx, long deliveryIdx) {
		// 파라미터가 2개 이상일 때는 Map에 담아서 넘기는 것이 편합니다.
        Map<String, Object> params = new HashMap<>();
        params.put("userIdx", userIdx);
        params.put("deliveryIdx", deliveryIdx);
     // 1) 해당 유저의 모든 주소를 '일반(false)'으로 초기화 
		mybatis.update("ADDRESS.resetDefaultAddress", userIdx );
		 // 2) 선택한 주소만 '기본(true)'으로 설정
		mybatis.update("ADDRESS.setDefaultAddress", params );
		
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
