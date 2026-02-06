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

}
