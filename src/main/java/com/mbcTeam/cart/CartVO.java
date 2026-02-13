package com.mbcTeam.cart;

import lombok.Data;

@Data
public class CartVO {
    private long cartIdx;        // 장바구니번호
    private long userIdx;        // 사용자번호
    private long productIdx;     // 제품번호
    private long optionIdx;      // 제품옵션번호
    private int quantity;        // 장바구니 수량

    // 조회용 필드  DB 추가 X 
    private String productName;
    private int price;
    private String color;
    private String size;
    private String productMainImg; // 메인 이미지 파일명
    
    private int discountRate; // 장바구니 할인율 표기

  
        
       

    
}
