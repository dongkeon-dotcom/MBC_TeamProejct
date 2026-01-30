package com.mbcTeam.product;

import lombok.Data;

@Data
public class ProductDescImgVO {

	private int pDescImgIdx; // 제품설명이미지번호
	private int productIdx; // 제품번호
	private String pDescImgPath; // 제품설명 이미지경로
	private String pDescImgOrder; // 제품설명 이미지순서
	
	
	public int getpDescImgIdx() {
		return pDescImgIdx;
	}
	public void setpDescImgIdx(int pDescImgIdx) {
		this.pDescImgIdx = pDescImgIdx;
	}
	public String getpDescImgPath() {
		return pDescImgPath;
	}
	public void setpDescImgPath(String pDescImgPath) {
		this.pDescImgPath = pDescImgPath;
	}
	public String getpDescImgOrder() {
		return pDescImgOrder;
	}
	public void setpDescImgOrder(String pDescImgOrder) {
		this.pDescImgOrder = pDescImgOrder;
	}
	
	

	
}