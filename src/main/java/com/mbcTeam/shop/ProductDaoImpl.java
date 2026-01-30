/**package com.mbcTeam.shop;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mbcTeam.product.ProductDescImgVO;

@Repository
public class ProductDaoImpl implements ProductDao {

    @Autowired
    private SqlSessionTemplate mybatis;
    
    
    @Override
    public void adminProductInsert(ProductVO vo) {
        mybatis.update(null);
        
    }
    
    @Override
    public void adminProductInsert(ProductImgVO vo) {
    
        
    }

    @Override
    public void adminProductInsert(ProductDescImgVO vo) {

        
    }
    

    @Override
    public List<ProductVO> getSelect(ProductVO vo) {
        return mybatis.selectList(null);
    }




}**/