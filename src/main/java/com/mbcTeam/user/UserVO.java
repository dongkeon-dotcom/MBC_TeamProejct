package com.mbcTeam.user;

import lombok.Data;

@Data
public class UserVO {
	private long userIdx;				//사용자번호(PK)
	private String userID;				//사용자 ID(E-mail)
	private String userPW;				//비밀번호(Security 작업필요)
	private String userName;			//이름
	private String userPhone;			//연락처
	private String userRegDate;			//등록일 (LocalDateTime로 해야되나?)
	private String userRole;			//권한(ADMIN/USER)
	private boolean userEasyLogin;		//외부로그인유무
	private boolean userIsDeleted;		//탈퇴유무
}
