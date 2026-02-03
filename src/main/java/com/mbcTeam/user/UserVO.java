package com.mbcTeam.user;

import lombok.Data;

@Data
public class UserVO {

	private long userIdx;				//사용자번호(PK)
	private String id;				//사용자 ID(E-mail)
	private String password;				//비밀번호(Security 작업필요)
	private String userName;			//이름
	private String userPhone;			//연락처
	private String regDate;			//등록일 (LocalDateTime로 해야되나?)
	private String userRole;			//권한(ADMIN/USER)
	private boolean isEasyLogin;		//외부로그인유무
	private boolean isDeleted;		//탈퇴유무
	
	//isDeleted,isEasyLogin 매서드 호출시 is제외한 이름으로호촐됩니다 그런 규칙이래요...
	//userController의 memberOK.do 에서 확인가능 

}
