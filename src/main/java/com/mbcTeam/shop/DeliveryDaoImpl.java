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

	
	
}
