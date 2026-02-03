package com.mbcTeam.user;

import org.springframework.stereotype.Repository;

@Repository
public interface ReviewDao {
	// 1. 리뷰 본문 저장 (성공 시 생성된 reviewIdx가 vo에 담김)
    int insertReview(ReviewVO vo);

    // 2. 리뷰 이미지 개별 저장
    int insertReviewImg(ReviewImageVO imgVO);
}
