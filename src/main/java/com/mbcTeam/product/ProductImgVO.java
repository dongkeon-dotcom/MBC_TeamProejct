package com.mbcTeam.product;

import lombok.Data;

@Data
public class ProductImgVO {

	private int pImgIdx; // 제품이미지번호
	private int productIdx; // 제품번호
	private String pImgPath; // 제품 이미지
	private String pImgOrder; // 경로	이미지 순서
	
	
	public int getpImgIdx() {
		return pImgIdx;
	}
	public void setpImgIdx(int pImgIdx) {
		this.pImgIdx = pImgIdx;
	}
	public String getpImgPath() {
		return pImgPath;
	}
	public void setpImgPath(String pImgPath) {
		this.pImgPath = pImgPath;
	}
	public String getpImgOrder() {
		return pImgOrder;
	}
	public void setpImgOrder(String pImgOrder) {
		this.pImgOrder = pImgOrder;
	}
	

	
}