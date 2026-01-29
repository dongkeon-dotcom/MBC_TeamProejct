package com.mbcTeam.shop;

import lombok.Data;

@Data
public class ProductImgVO {
    private long pImgIdx;            //제품이미지번호
    private long productIdx;        //제품번호
    private String pImgPath;        //이미지경로
    private int pImgOrder;        //이미지순서
}