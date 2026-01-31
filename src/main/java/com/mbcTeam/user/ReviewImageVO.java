package com.mbcTeam.user;

import lombok.Data;

@Data
public class ReviewImageVO {

	private long reviewImgIdx;			// 후기이미지번호
	private long reviewIdx;			// 후기번호
	private String reviewImg;		// 후기이미지경로
}
