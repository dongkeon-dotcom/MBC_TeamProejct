package com.mbcTeam.shop;

import java.util.List;

public interface DeliveryDao {
	// 1. 주소록 목록 가져오기 (특정 유저의 전체 주소록)
    List<DeliveryVO> getAddressList(long userIdx);
    
    // 2. 새 주소 등록하기 (주소 API 입력 후 저장)
    void insertAddress(DeliveryVO vo);
    
    // 3. 주소 삭제하기 (단일 삭제 또는 선택 삭제 공용)
    // 여러 개를 한 번에 삭제하기 위해 List나 배열을 받는 방식이 효율적입니다.
    void deleteAddresses(List<Long> deliveryIdxList);

    // 4. (선택사항) 기본 배송지 변경
    // 새 주소를 기본 배송지로 설정할 경우 기존 기본 배송지를 일반으로 바꿔주는 로직
    void updateDefaultAddress(long userIdx, long deliveryIdx);
}
