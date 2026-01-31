package com.mbcTeam.user;

import lombok.Data;

@Data
public class ReviewVO {
	private long reviewIdx;				// 후기번호
	private long productIdx;			// 제품번호
	private long userIdx;				// 사용자번호
	private String userName;			// 사용자이름
	private String review;			// 후기내용
	private int rating;			// 별점
	private Boolean isHide;			// 후기숨김
	private String regDate;		// 후기등록일
}