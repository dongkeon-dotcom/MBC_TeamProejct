package com.mbcTeam.shop;

import java.util.List;

import com.mbcTeam.product.ProductDescImgVO;

public interface ProductDao {
    void adminProductInsert(ProductVO vo);
    void adminProductInsert(ProductImgVO vo);
    void adminProductInsert(ProductDescImgVO vo);
    
    List<ProductVO> getSelect(ProductVO vo);
    
    
    
    
}