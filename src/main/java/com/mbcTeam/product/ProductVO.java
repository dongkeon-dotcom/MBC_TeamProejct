package com.mbcTeam.product;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

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
	private MultipartFile productMainImgfile;
	private String productSizeImg; // 제품사이즈이미지
	private MultipartFile productSizeImgfile;
	private int discountRate; // 제품할인률
	private boolean isRecommended; // 제품추천

	//검색용 데이터
	private String search;		//검색 항목
	private String keyword; 	//검색 값
	private String startDate;	//검색 시작일
	private String endDate;		//검색 마지막일
	
	//페이지 사이즈 조절용 데이터
	private int startIdx;		//검색 시작번호
	private int pageSize;		//표시할 갯수

	// 옵션 리스트 포함
	private List<ProductOptionVO> options;

	private Integer avgRating; // 평균 평점
	private Integer reviewCount; // 리뷰 개수

}