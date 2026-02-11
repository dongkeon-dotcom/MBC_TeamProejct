package com.mbcTeam.shop;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DeliveryServiceImpl implements DeliveryService {

    @Autowired
    private DeliveryDao ddao;

    // 1. 주소록 목록 가져오기
    @Override
    public List<DeliveryVO> getAddressList(long userIdx) {
        return ddao.getAddressList(userIdx);
    }

    // 2. 새 주소 등록하기
    @Transactional
    @Override
    public void insertAddress(DeliveryVO vo) {
        // 만약 새 주소를 '기본 배송지'로 체크했다면 기존 주소들을 모두 N으로 리셋
        if (vo.isDefaultAddress()) {
            ddao.resetDefaultAddress(vo.getUserIdx());
        }
        ddao.insertAddress(vo);
    }

    // 3. 선택 주소들 삭제하기
    @Override
    public void deleteAddresses(List<Long> deliveryIdxList) {
        ddao.deleteAddresses(deliveryIdxList);
    }

    // 4. 기본 배송지 변경 (체크박스 선택 후 '기본배송지로 설정' 버튼 클릭 시)
    @Transactional
    @Override
    public void updateDefaultAddress(long userIdx, long deliveryIdx) {
        // [로직] 전체 리셋 후 특정 주소만 설정
        // 1) 해당 유저의 모든 주소를 'N'으로 초기화
        ddao.resetDefaultAddress(userIdx);
        
        // 2) 선택한 주소(deliveryIdx)만 'Y'로 설정
        ddao.updateDefaultAddress(userIdx, deliveryIdx);
    }

    // 5. 단일 주소 정보 가져오기 (수정 폼 호출용)
    @Override
    public DeliveryVO getOneAddress(long deliveryIdx) {
        return ddao.getOneAddress(deliveryIdx);
    }

    // 6. 주소 정보 수정하기
    @Transactional
    @Override
    public void addrUpdate(DeliveryVO vo) {
        // 수정 시 '기본 배송지'로 설정 체크를 했다면 리셋 먼저 실행
        if (vo.isDefaultAddress()) {
            ddao.resetDefaultAddress(vo.getUserIdx());
        }
        ddao.addrUpdate(vo);
    }
}
