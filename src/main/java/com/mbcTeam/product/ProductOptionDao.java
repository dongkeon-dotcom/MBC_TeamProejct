package com.mbcTeam.product;

import java.util.List;

public interface ProductOptionDao {
	
	void insertOption(ProductOptionVO vo);
	
    ProductOptionVO findById(int optionIdx);
    List<ProductOptionVO> findByProduct(int productIdx);
    
}
