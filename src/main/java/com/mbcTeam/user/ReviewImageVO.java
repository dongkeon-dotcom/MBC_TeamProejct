package com.mbcTeam.user;

import lombok.Data;

@Data
public class ReviewImageVO {

	private long rImgIdx;			// 후기이미지번호
	private long reviewIdx;			// 후기번호
	private String rImgPath;		// 후기이미지경로
}
