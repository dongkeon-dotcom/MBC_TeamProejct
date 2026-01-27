package com.mbcTeam.user;

import lombok.Data;

@Data
public class ReviewVO {
	private long reviewIdx;				// 후기번호
	private long productIdx;			// 제품번호
	private long userIdx;				// 사용자번호
	private String userName;			// 사용자이름
	private String reviewDesc;			// 후기내용
	private int reviewRating;			// 별점
	private Boolean reviewHide;			// 후기숨김
	private String reviewRegDate;		// 후기등록일
}