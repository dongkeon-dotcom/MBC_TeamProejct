package com.mbcTeam.cart;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository 
public class CartDaoImpl implements CartDao {

	@Autowired
	private SqlSessionTemplate mybatis;

	@Override
	public void insertCart(CartVO cart) {
		mybatis.insert("CARTS.insertCarts", cart);
	}

	@Override
	public List<CartVO> selectCart(long userIdx) {
		return mybatis.selectList("CARTS.selectCarts", userIdx);
	}

	@Override
	public void deleteCart(long cartIdx) {
		mybatis.delete("CARTS.deleteCarts", cartIdx);
	}
}
