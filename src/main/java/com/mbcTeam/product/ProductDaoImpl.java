package com.mbcTeam.product;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProductDaoImpl implements ProductDao {

    @Autowired
    private SqlSessionTemplate mybatis;

    @Override
    public void insert(ProductVO vo) {
        mybatis.insert("PRODUCT.INSERT_PRODUCT", vo);
    }

    @Override
    public void insertImg(ProductImgVO img) {
        mybatis.insert("PRODUCT.INSERT_PRODUCT_IMG", img); // 네임스페이스 + SQL ID 일관성
    }
    
    @Override
	public void insertOption(ProductOptionVO option) {
		mybatis.insert("PRODUCT.INSERT_PRODUCT_OPTION", option);
		
	}

    @Override
    public void update(ProductVO vo) {
        mybatis.update("PRODUCT.UPDATE_PRODUCT", vo);
    }

    @Override
    public void delete(ProductVO vo) {
        mybatis.delete("PRODUCT.DELETE_PRODUCT", vo);
    }

    @Override
    public List<ProductVO> select(ProductVO vo) {
        return mybatis.selectList("PRODUCT.SELECT_PRODUCT_LIST", vo);
    }

    @Override
    public ProductVO edit(ProductVO vo) {
        return mybatis.selectOne("PRODUCT.SELECT_PRODUCT_DETAIL", vo);
    }


}
