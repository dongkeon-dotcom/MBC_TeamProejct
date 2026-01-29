package com.mbcTeam.shop;

import java.util.List;


public interface ProductService {

    void adminProductInsert(ProductVO vo, ProductImgVO imgVO, ProductDescImgVO DImgVO);
    List<ProductVO> getSelect(ProductVO vo);
	void adminProductInsert(ProductVO vo);
    
    
    
}