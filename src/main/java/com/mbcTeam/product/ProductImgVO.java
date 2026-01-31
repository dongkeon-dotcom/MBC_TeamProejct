package com.mbcTeam.product;

import lombok.Data;

@Data
public class ProductImgVO {

	private int productImgIdx; // 제품이미지번호
	private int productIdx; // 제품번호
	private String productImg; // 제품 이미지
	private String productImgOrder; // 경로	이미지 순서
	

	
}