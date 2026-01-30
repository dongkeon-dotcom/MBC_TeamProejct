package com.mbcTeam.product;

import java.util.List;

import lombok.Data;

@Data
public class ProductVO {

	private int productIdx; // 제품번호
	private String productCategory; // 카테고리
	private String productSubCategory; // 하위카테고리
	private String productName; // 제품명
	private int productPrice; // 가격
	private String productRegDate; // 제품등록일
	private String productDesc; // 제품설명
	private String pMainImgPath; // 제품대표이미지
	private String pSizeImgPath; // 제품사이즈이미지 
	private String productDiscountPer; // 제품할인률
	private String productRecomm; // 제품추천

	// 옵션 리스트 포함
	private List<ProductOptionVO> options;

	private Integer avgRating; // 평균 평점 
	private Integer reviewCount; // 리뷰 개수
	
	
	public String getpMainImgPath() {
		return pMainImgPath;
	}
	public void setpMainImgPath(String pMainImgPath) {
		this.pMainImgPath = pMainImgPath;
	}
	public String getpSizeImgPath() {
		return pSizeImgPath;
	}
	public void setpSizeImgPath(String pSizeImgPath) {
		this.pSizeImgPath = pSizeImgPath;
	}
	
	
	

}