package com.mbcTeam.product;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ProductDescImgVO {

	private int productDescImgIdx; // 제품설명이미지번호
	private int productIdx; // 제품번호
	private String productDescImg; // 제품설명 이미지경로
	private MultipartFile productDescImgfile;
	private String productDescImgOrder; // 제품설명 이미지순서
	
}