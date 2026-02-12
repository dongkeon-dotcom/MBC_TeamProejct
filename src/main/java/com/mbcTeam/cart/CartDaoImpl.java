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
    public int insertCart(CartVO cart) {
        return mybatis.insert("CARTS.insertCart", cart);
    }

    @Override
    public List<CartVO> selectCart(long userIdx) {
        return mybatis.selectList("CARTS.selectCart", userIdx);
    }

    @Override
    public int deleteCart(long cartIdx) {
        return mybatis.delete("CARTS.deleteCart", cartIdx);
    }

    @Override
    public int updateCart(CartVO cart) {
        return mybatis.update("CARTS.updateCart", cart);
    }

	
	@Override
	public CartVO getCartItem(Long cartIdx) {
	    return mybatis.selectOne("CARTS.getCartItem", cartIdx);
	}
	
	@Override
	public void deleteByUserId(long userIdx) {
	    mybatis.delete("CARTS.deleteByUserId", userIdx);
	}

	@Override
	public void clearCart(long userIdx) {
	    mybatis.delete("CARTS.deleteByUserId", userIdx);
	}
	
}