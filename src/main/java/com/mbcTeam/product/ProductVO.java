package com.mbcTeam.product;

import java.util.List;

import lombok.Data;

@Data
public class ProductVO {

	private int productIdx; // 제품번호
	private String category; // 카테고리
	private String subCategory; // 하위카테고리
	private String productName; // 제품명
	private int price; // 가격
	private String regDate; // 제품등록일
	private String productDesc; // 제품설명
	private String productMainImg; // 제품대표이미지
	private String productSizeImg; // 제품사이즈이미지
	private String discountRate; // 제품할인률
	private String isRecommended; // 제품추천

	// 옵션 리스트 포함
	private List<ProductOptionVO> options;

	private Integer avgRating; // 평균 평점 
	private Integer reviewCount; // 리뷰 개수
	

}