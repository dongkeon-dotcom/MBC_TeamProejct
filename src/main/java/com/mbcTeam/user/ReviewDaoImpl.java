package com.mbcTeam.user;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
@Repository
public class ReviewDaoImpl implements ReviewDao {


	@Autowired
	private SqlSessionTemplate mybatis;
	
	@Override
	public int insertReview(ReviewVO vo) {
		// TODO Auto-generated method stub
		return mybatis.insert("REVIEW.REVIEWINSERT",vo);
	}

	@Override
	public int insertReviewImg(ReviewImageVO imgVO) {
		// TODO Auto-generated method stub
		return mybatis.insert("REVIEW.REVIEWINSERTIMG",imgVO);
	}

	@Override
	public List<ReviewVO> getReviewListByUserIdx(long userIdx) {
		// TODO Auto-generated method stub
		return mybatis.selectList("REVIEW.REVIEWLIST",userIdx);
	}

	@Override
	public ReviewVO getReviewOne(long reviewIdx) {
		// TODO Auto-generated method stub
		return mybatis.selectOne("REVIEW.getReviewOne", reviewIdx);
	}

	@Override
	public int updateReview(ReviewVO vo) {
		// TODO Auto-generated method stub
		return mybatis.update("REVIEW.updateReview", vo);
	}

	@Override
	public int deleteReviewImgs(long reviewIdx) {
		// TODO Auto-generated method stub
		return mybatis.delete("REVIEW.deleteReviewImgs", reviewIdx);
	}

	@Override
	public List<ReviewImageVO> getReviewImages(long reviewIdx) {
		// TODO Auto-generated method stub
		return mybatis.selectList("REVIEW.getReviewImages", reviewIdx);
	}
	
	@Override
    public List<ReviewVO> getReviewListByProduct(long productIdx) {
        // XML mapper의 <select id="getReviewListByProduct">를 호출
        return mybatis.selectList("REVIEW.getReviewListByProduct", productIdx);
    }
}
