package com.mbcTeam.member;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDaoImpl implements MemberDao {

	@Autowired
	private SqlSessionTemplate mybatis;
//회원가
	@Override
	public void insert(MemberVO vo) {
		mybatis.update("MEMBER.INSERT", vo);

	}

// 로그인
	@Override
	public MemberVO login(MemberVO vo) {
		return mybatis.selectOne("MEMBER.login", vo);
	}

// 회원 단건 조회
	@Override
	public MemberVO getById(int uidx) {
		return mybatis.selectOne("MEMBER.getById", uidx);
	}

// 회원 정보 수정
	@Override
	public void update(MemberVO vo) {
		mybatis.update("MEMBER.update", vo);
	}

// 회원 탈퇴 (논리 삭제)
	@Override
	public void delete(int uidx) {
		mybatis.update("MEMBER.delete", uidx);
	}

// 이메일 중복 체크
	@Override
	public boolean existsByEmail(String user_email) {
		Integer count = mybatis.selectOne("MEMBER.countByEmail", user_email);
		return count != null && count > 0;
	}

	@Override
	public MemberVO getByEmail(String user_email) {
		// TODO Auto-generated method stub
		return mybatis.selectOne("MEMBER.getByEmail", user_email);
	}
}
