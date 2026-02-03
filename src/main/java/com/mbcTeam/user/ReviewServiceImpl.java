package com.mbcTeam.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
@Service
public class ReviewServiceImpl implements ReviewService {
	@Autowired
    private ReviewDao rdao;

    @Override
    @Transactional // 중요: 본문과 이미지 저장은 하나의 트랜잭션으로 묶는 것이 좋습니다.
    public int insertReview(ReviewVO vo) {
        return rdao.insertReview(vo);
    }

	@Override
	public int insertReviewImg(ReviewImageVO imgVO) {
		// TODO Auto-generated method stub
		return rdao.insertReviewImg(imgVO);
	}
	
}