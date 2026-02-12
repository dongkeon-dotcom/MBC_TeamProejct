package com.mbcTeam.dto;

import lombok.Data;

@Data
public class UserPurchaseDTO {

    
	private int productIdx;			// 제품번호
	private String productName;		// 제품명
	private String color;			// 컬러
    private String size;			// 사이즈
    private int quantity;			// 구매수량
    private int finalPrice;				// 가격
	private String review;			// 후기내용
	private int rating;				// 별점
	private Boolean isHide= false;	// 후기숨김
	
	
}
