package com.mbcTeam.cart;

import java.util.List;



public interface CartDao {
    int insertCart(CartVO cartvo);
    int deleteCart(long cartIdx);
    int updateCart(CartVO cartvo);
    List<CartVO> selectCart(long userIdx);
    
    CartVO getCartItem(Long cartIdx);
    void deleteByUserId(long userIdx);
    void clearCart(long userIdx);
    
    CartVO checkCartItem(CartVO cartvo); // 추가
    int updateCartQuantity(CartVO cartvo); // 추가
    
 
    void deleteSelectedCartItems(List<Long> cartIdxList); // 개별상품 구매후 개별상품만 삭제
    
    
    void deleteSelected(List<Long> cartIdxList);
    
    
}
