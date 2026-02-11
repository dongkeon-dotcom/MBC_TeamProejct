package com.mbcTeam.dto;

import lombok.Data;

@Data
public class OrderManagementDTO {

	private int status;
	private String orderDate;
	private int orderIdx;
	private String receiver;
	private String deliveryPhone;
	private String fullAddress;
	private String zipcode;
	private String productName;
	private String size;
	private String color;
	private int quantity;
	private int itemIdx;
	
	
	
	//검색용 데이터
	private String search;		//검색 항목
	private String keyword; 	//검색 값
	
	private String startDate;
	private String endDate;
	
	//페이지 사이즈 조절용 데이터
	private int startIdx;		//검색 시작번호
	private int pageSize;		//표시할 갯수
	
}
