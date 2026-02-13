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
	
	@Override
	public CartVO checkCartItem(CartVO cart) {
	    return mybatis.selectOne("CARTS.checkCartItem", cart);
	}

	@Override
	public int updateCartQuantity(CartVO cart) {
	    return mybatis.update("CARTS.updateCartQuantity", cart);
	}
	
	@Override
    public void deleteSelectedCartItems(List<Long> cartIdxList) {
        // "CARTS"는 XML의 namespace와 일치해야 합니다.
        mybatis.delete("CARTS.deleteSelectedCartItems", cartIdxList);
    }

    // 만약 인터페이스(CartDao)에 deleteSelected라는 이름으로 등록되어 있다면 아래처럼 작성하세요.
    @Override
    public void deleteSelected(List<Long> cartIdxList) {
        mybatis.delete("CARTS.deleteSelectedCartItems", cartIdxList);
    }
	
}