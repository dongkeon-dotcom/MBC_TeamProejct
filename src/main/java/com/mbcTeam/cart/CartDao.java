package com.mbcTeam.cart;

import java.util.List;

public interface CartDao {

	void insertCart(CartVO cart);

	void deleteCart(long cartIdx);

	List<CartVO> selectCart(long userIdx);

}
