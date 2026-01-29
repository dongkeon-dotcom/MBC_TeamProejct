package com.mbcTeam.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
@Service
public class MemberServiceImpl implements MemberService{

	
	@Autowired 
	private MemberDao dao;

	@Override
	public void insert(MemberVO vo) {
		dao.insert(vo);
	}

	@Override
	public MemberVO login(MemberVO vo) {
		// TODO Auto-generated method stub
		return dao.login(vo);
	}

	@Override
	public MemberVO getById(int uidx) {
		
		return  dao.getById(uidx);
	}

	@Override
	public void update(MemberVO vo) { 
		dao.update(vo);
	}

	@Override
	public void delete(int uidx) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public boolean existsByEmail(String user_email) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public MemberVO getByEmail(String user_email) {
		// TODO Auto-generated method stub
		return dao.getByEmail(user_email);
	}
	
}
