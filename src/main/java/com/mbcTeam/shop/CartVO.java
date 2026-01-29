package com.mbcTeam.shop;

import lombok.Data;

@Data
public class CartVO {
    private long cartIdx;        // 장바구니번호
    private long userIdx;        // 사용자번호
    private long productIdx;    // 제품번호
    private long optionIdx;        // 제품옵션번호
    private int cartQuantity;    // 장바구니 수량
}



