package com.mbcTeam.shop;

import java.util.List;

public interface ProductDao {
	void adminProductInsert(ProductVO vo);
	void adminProductInsert(ProductImgVO vo);
	void adminProductInsert(ProductDescImgVO vo);
	
	List<ProductVO> getSelect(ProductVO vo);
	
	
	
	
}
