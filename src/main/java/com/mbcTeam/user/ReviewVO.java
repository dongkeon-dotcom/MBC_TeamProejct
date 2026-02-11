package com.mbcTeam.user;

import lombok.Data;

@Data
public class ReviewVO {
	private long reviewIdx;				// 후기번호
	private long productIdx;			// 제품번호
	private long userIdx;				// 사용자번호
	private String userName;			// 사용자이름
	private String review;				// 후기내용
	private int rating;					// 별점
	private Boolean isHide= false;		// 후기숨김
	private String regDate;				// 후기등록일
	private String Item_Idx;			// 구매한 제품 주문정보 idx
	
	
	//   orderdetailList에서 후기작성시 각각으 ㅣ상품에 대한 후기작성을 위해서 상품옵션인 컬러와 사이즈를 가져옴 
	private String color; // JOIN해서 가져올 컬러
    private String size;  // JOIN해서 가져올 사이즈
    private long itemIdx; // 가져와야지... 후기쓰려면 /.....
}