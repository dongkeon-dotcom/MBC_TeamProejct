package com.mbcTeam.cart;

import java.util.List;



public interface CartDao {
    int insertCart(CartVO cartvo);
    int deleteCart(long cartIdx);
    int updateCart(CartVO cartvo);
    List<CartVO> selectCart(long userIdx);
}
