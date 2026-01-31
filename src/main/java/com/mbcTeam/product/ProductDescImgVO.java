package com.mbcTeam.product;

import lombok.Data;

@Data
public class ProductDescImgVO {

	private int productImgIdx; // 제품설명이미지번호
	private int productIdx; // 제품번호
	private String productDescImg; // 제품설명 이미지경로
	private String productDescImgOrder; // 제품설명 이미지순서
	

	
}