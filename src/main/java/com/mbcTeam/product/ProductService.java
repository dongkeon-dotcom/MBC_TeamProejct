package com.mbcTeam.product;

import java.util.List;

public interface ProductService {

    void insert(ProductVO vo, List<ProductImgVO> imgList, List<ProductOptionVO> options ); // 상품 + 이미지 등록
    void insertOption(ProductOptionVO option);
    void update(ProductVO vo);                             // 상품 수정
    void delete(ProductVO vo);                             // 상품 삭제
    List<ProductVO> select(ProductVO vo);  
    
    ProductVO edit(ProductVO vo);                          // 상품 상세 조회
    
}
