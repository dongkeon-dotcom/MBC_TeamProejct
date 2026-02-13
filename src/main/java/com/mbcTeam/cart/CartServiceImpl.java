package com.mbcTeam.cart;


import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartDao dao;

    
    @Override
    @Transactional // 수량 체크 후 등록하므로 트랜잭션 권장
    public int insertCart(CartVO cartvo) {
        // 1. 이미 같은 옵션의 상품이 있는지 확인
        CartVO existingItem = dao.checkCartItem(cartvo);

        if (existingItem != null) {
            // 2. 있다면? 수량만 업데이트 (기존 IDX와 증가할 수량 넘김)
            cartvo.setCartIdx(existingItem.getCartIdx());
            return dao.updateCartQuantity(cartvo);
        } else {
            // 3. 없다면? 새로 신규 등록
            return dao.insertCart(cartvo);
        }
    }

    @Override
    public List<CartVO> selectCart(long userIdx) {
        return dao.selectCart(userIdx);
    }

    @Override
    public int deleteCart(long cartIdx) {
        return dao.deleteCart(cartIdx);
    }

    @Override
    public int updateCart(CartVO cartvo) {
        return dao.updateCart(cartvo);
    }
    
    @Override
    public CartVO getCartItem(Long cartIdx) {
        return dao.getCartItem(cartIdx); // dao에도 메서드 추가 필요
    }
    
    @Override
    public void deleteByUserId(long userIdx) {
        dao.deleteByUserId(userIdx);
    }
    
    @Override
    public void clearCart(long userIdx) {
        dao.clearCart(userIdx); 
    }
    
    @Override
    @Transactional
    public void removePurchasedItems(List<Long> cartIdxList) {
        if (cartIdxList != null && !cartIdxList.isEmpty()) {
            dao.deleteSelectedCartItems(cartIdxList);
        }
    }
    
    
    @Override
    public void deleteSelectedCartItems(List<Long> cartIdxList) {
        if (cartIdxList != null && !cartIdxList.isEmpty()) {
            dao.deleteSelected(cartIdxList); 
            // 만약 DAO의 메서드명이 다르면 그에 맞춰 수정하세요 (예: deleteCartItems 등)
        }
    }
    
}
