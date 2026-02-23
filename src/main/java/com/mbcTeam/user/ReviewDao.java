package com.mbcTeam.user;

import java.util.List;

import org.springframework.stereotype.Repository;

@Repository
public interface ReviewDao {
	// 1. 리뷰 본문 저장 (성공 시 생성된 reviewIdx가 vo에 담김)
    int insertReview(ReviewVO vo);

    // 2. 리뷰 이미지 개별 저장
    int insertReviewImg(ReviewImageVO imgVO);
    List<ReviewVO> getReviewListByUserIdx(long userIdx);
    
 // 4. 특정 리뷰 한 건 가져오기 (수정 폼에 기존 내용을 뿌려줄 때 필요)
    ReviewVO getReviewOne(long reviewIdx);

    // 5. 리뷰 본문 수정하기
    int updateReview(ReviewVO vo);

    // 6. (선택) 기존 리뷰 이미지 삭제하기
    // 수정 시 기존 사진을 지우고 새 사진을 올릴 경우 필요합니다.
    int deleteReviewImgs(long reviewIdx);
    
    List<ReviewImageVO> getReviewImages(long reviewIdx);
    
    List<ReviewVO> getReviewListByProduct(long productIdx); 
    ///후기 숨김
    int hideReview(long reviewIdx);
    
    
    
}
