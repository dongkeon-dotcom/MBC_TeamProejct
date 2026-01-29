package com.mbcTeam.shop;

import java.util.List;

public interface ProductService {

	void adminProductInsert(ProductVO vo);
	List<ProductVO> getSelect(ProductVO vo);
	
}
