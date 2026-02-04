package com.mbcTeam.product;

import java.util.List;
import com.mbcTeam.user.ReviewVO;

public interface ProductService {

    void insert(ProductVO vo);
    void insertImg(ProductImgVO ivo); // 이미지 등록
    void insertDescImg(ProductDescImgVO divo);
    void insertOption(ProductOptionVO ovo);
    
    List<ProductVO> adminSelect(ProductVO vo); //제품 조회
    void adminUpdateProductStatus(ProductVO vo); //제품 상태(추천,세일) 변경
    int  totalCount(ProductVO vo); //제품 전체 갯수

    //제품 수정에 필요한 값들, Products, ProductImg, ProductDescImg, ProductOption
    ProductVO adminProductEdit(ProductVO vo);	//제품 DB 수정
    List<ProductImgVO> adminProductEditImg(int productIdx); //이미지 DB
    List<ProductDescImgVO> adminProductEditDescImg(int productIdx); //설명 이미지 DB
    List<ProductOptionVO> adminProductEditOption(int productIdx);	//옵션 DB
    
    void update(ProductVO vo); // 상품 수정
    void delete(ProductVO vo); // 상품 삭제

    List<ProductVO> select(ProductVO vo); // 조건 조회
    ProductVO edit(ProductVO vo); // 관리자 상품 수정용 조회
    ProductVO detail(int productIdx); // 사용자 상세 조회

    List<ProductOptionVO> selectOptions(int productIdx); // 옵션 조회
    List<ReviewVO> selectReviews(int productIdx); // 리뷰 조회

    List<ProductVO> selectAll(); // 전체 상품 조회
    List<ProductVO> selectByCategory(String category); // 카테고리별 조회
}
