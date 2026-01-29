package com.mbcTeam.shop;

import java.util.List;

public interface ProductDao {
	void adminProductInsert(ProductVO vo);
	void adminProductImgInsert(ProductImgVO vo);
	void adminProductDescImgInsert(ProductDescImgVO vo);
	
	List<ProductVO> getSelect(ProductVO vo);
	
	
	
	
}
