package com.mbcTeam.dto;

import lombok.Data;

@Data
public class UserManagementDTO {
	private String regDate;
	private int userIdx;
	private String id;
	private String userPhone;
	private String userName;
	private String fullAddress;
	private int totalSpent;
	
	//검색용 데이터
	private String search;		//검색 항목
	private String keyword; 	//검색 값
	
	//페이지 사이즈 조절용 데이터
	private int startIdx;		//검색 시작번호
	private int pageSize;		//표시할 갯수

}
