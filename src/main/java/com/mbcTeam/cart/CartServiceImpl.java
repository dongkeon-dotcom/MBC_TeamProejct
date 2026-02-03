
package com.mbcTeam.cart;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CartServiceImpl implements CartService {

	@Autowired
	private CartDao dao; // 이제 정상 주입됨

	@Override
	public void insertCart(CartVO cart) {
		dao.insertCart(cart);
	}

	@Override
	public List<CartVO> selectCart(long userIdx) {
		return dao.selectCart(userIdx);
	}

	@Override
	public void deleteCart(long cartIdx) {
		dao.deleteCart(cartIdx);
	}
}
