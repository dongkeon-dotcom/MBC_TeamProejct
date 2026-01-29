package com.mbcTeam.shop;

import lombok.Data;

@Data
public class ProductDescImgVO {
    private Long pDescImgIdx;            //제품설명이미지번호
    private Long productIdx;            //제품번호
    private String pDescImgPath;        //이미지경로
    private Integer pDescImgOrder;        //이미지순서
}