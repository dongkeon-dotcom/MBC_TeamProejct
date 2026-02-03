package com.mbcTeam.product;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProductOptionDaoImpl implements ProductOptionDao {

    @Autowired
    private SqlSessionTemplate mybatis;

    
    @Override
    public ProductOptionVO findById(int optionIdx) {
        return mybatis.selectOne("PRODUCT.SELECT_PRODUCT_OPTION_BY_ID", optionIdx);
    }

    @Override
    public List<ProductOptionVO> findByProduct(int productIdx) {
        return mybatis.selectList("PRODUCT.SELECT_PRODUCT_OPTIONS", productIdx);
    }


    @Override
    public void insertOption(ProductOptionVO vo) {
        mybatis.insert("PRODUCT.INSERT_PRODUCT_OPTION", vo);
    }
}
