package com.mbcTeam.product;

import java.util.List;

public interface ProductDao {

	void insert(ProductVO vo); // 상품 등록
	void insertImg(ProductImgVO img); // 대표/추가 이미지 등록
	void insertOption(ProductOptionVO option);
	void update(ProductVO vo); // 상품 수정
	void delete(ProductVO vo); // 상품 삭제
	List<ProductVO> select(ProductVO vo); // 상품 목록 조회
	ProductVO edit(ProductVO vo); // 상품 상세 조회

}
