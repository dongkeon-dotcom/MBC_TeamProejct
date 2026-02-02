package com.mbcTeam.product;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ProductRequestDTO {

	private List<ProductOptionVO> productOptionList;
	
	//DTO에서는 파일을 원본 그대로 받고, 서비스(Service) 레이어에서 그 파일을 읽어 DB에 저장할 VO로 변환해야 합니다.
	private List<MultipartFile> productImgList;
	private List<MultipartFile> productDescImgList;
	
	
}
