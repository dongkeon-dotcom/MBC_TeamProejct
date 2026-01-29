package com.mbcTeam.product;

import lombok.Data;

@Data
public class ProductOptionVO {

	private int optionIdx; // 옵션 번호
	private int productIdx; // 제품번호
	private String optionColor; // 컬러
	private String optionSize; // 사이즈
	private String productStock; // 재고

	
	
}