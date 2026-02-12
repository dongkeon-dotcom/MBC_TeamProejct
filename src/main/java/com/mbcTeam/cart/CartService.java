package com.mbcTeam.cart;

import java.util.List;

public interface CartService {
	
	
	
    int insertCart(CartVO cartvo);
    int deleteCart(long cartIdx);
    int updateCart(CartVO cartvo);
    List<CartVO> selectCart(long userIdx);
    
    CartVO getCartItem(Long cartIdx);
    void deleteByUserId(long userIdx);
    void clearCart(long userIdx);
    
}
