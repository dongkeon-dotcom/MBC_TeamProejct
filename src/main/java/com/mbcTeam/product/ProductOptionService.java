package com.mbcTeam.product;

import java.util.List;

public interface ProductOptionService {
	
    ProductOptionVO getOptionById(int optionIdx);
    
    List<ProductOptionVO> getOptionsByProduct(int productIdx);
    
    void insertOption(ProductOptionVO vo);
}
