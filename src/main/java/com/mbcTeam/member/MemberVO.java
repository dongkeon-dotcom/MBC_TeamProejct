package com.mbcTeam.member;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class MemberVO {
	private int userIdx;			// 유저번호 / PK
	private String user_email;			// 이메일 형식
	private String userPW;			//비밀번호 
	private String userName;				//유저의 이름 
	private String userPhone;			// 전화번호 
	private String userRole;		//유저롤 
	private boolean userEasyLogin;			//소셜 로그인 유무 
	private boolean userIsDeleted;//탈퇴용  
	//boolean 사용으로 if 문 사용시편의를 위해 userEasyLogin,userIsDeleted 둘다 
	//boolen사용했습니다 
	private LocalDateTime userRegDate;//가입일 

 
}