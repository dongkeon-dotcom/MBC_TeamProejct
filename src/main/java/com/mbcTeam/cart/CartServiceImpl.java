package com.mbcTeam.cart;


import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartDao dao;

    @Override
    public int insertCart(CartVO cartvo) {
        return dao.insertCart(cartvo);
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
}
