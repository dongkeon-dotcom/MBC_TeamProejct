package com.mbcTeam.member;

import lombok.Data;

@Data
public class MemberVO {
	private int uidx;				// 유저번호 / PK
	private String user_id;			// 이메일 형식
	private String name;			// 이름
	private String tel;				// 전화번호
	private String address;			// 주소
	private String addressExtra;	// 상세주소		
	private String password;		// 비밀번호
	private String role;			// 권한
	private String age;				// 나이
	private String createdate;		// 생성일 
}