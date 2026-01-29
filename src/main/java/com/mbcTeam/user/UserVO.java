package com.mbcTeam.user;

import lombok.Data;

@Data
public class UserVO {
	
	
	private int userIdx;			// 유저번호 / PK
	private String user_id;			// 사용자 ID(E-mail)
	private String userPW;			// PW
	private String userName;		// 이름
	private String userPhone;		// 연락처
	private String userRegDate;	    // 등록일		
	private String userRole;		// 권한(관리자/유저)
	private String userEasyLogin;	// 외부로그인유무
	private String userIsDeleted;	// 탈퇴유무
	
	
									
}