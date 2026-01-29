package com.mbcTeam.shop;

import java.util.List;

import com.mbcTeam.product.ProductDescImgVO;
import com.mbcTeam.product.ProductImgVO;

import lombok.Data;

@Data
public class ProductVO {
    private long productIdx;                            // 제품번호
    private String productCategory;                        // 카테고리
    private String productSubCategory;                    // 하위카테고리
    private String productName;                            // 제품명
    private int productPrice;                            // 가격
    private String productRegDate;                        // 제품등록일
    private String productDesc;                            // 제품설명
    private String pMainImgPath;                        // 제품대표이미지
    private String pSizeImgPath;                        // 제품사이즈이미지
    private int productDiscountPer;                        // 제품할인률
    private Boolean productRecomm;                        // 제품추천

    private List<ProductImgVO> productImgs;              // 상품 촬영 이미지 리스트
    private List<ProductDescImgVO> productDescImgs;      // 상품 상세 설명 이미지 리스트
}




