package com.mbcTeam.shop;

import lombok.Data;

@Data
public class ProductDescImgVO {
    private long pDescImgIdx;            //제품설명이미지번호
    private long productIdx;            //제품번호
    private String pDescImgPath;        //이미지경로
    private int pDescImgOrder;        //이미지순서
}