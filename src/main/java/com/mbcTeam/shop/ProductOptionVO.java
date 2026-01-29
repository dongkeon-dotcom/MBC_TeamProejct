package com.mbcTeam.shop;

import lombok.Data;

@Data
public class ProductOptionVO {
    private long optionIdx;            // 옵션번호
    private long productIdx;        // 제품번호
    private String optionColor;        // 컬러
    private String optionSize;        // 사이즈
    private int productStock;        // 재고
}