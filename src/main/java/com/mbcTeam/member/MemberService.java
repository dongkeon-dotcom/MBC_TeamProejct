package com.mbcTeam.member;

import java.util.List;

import org.springframework.stereotype.Service;

public interface MemberService {

    // 회원가입
    void insert(MemberVO vo);

    // 로그인
    MemberVO login(MemberVO vo);

    // 회원 단건 조회
    MemberVO getById(int uidx);

    // 회원 정보 수정
    void update(MemberVO vo);

    // 회원 탈퇴 (논리 삭제)
    void delete(int uidx);

    // 이메일 중복 체크
    boolean existsByEmail(String user_email);
    
    MemberVO getByEmail(String user_email);
}
