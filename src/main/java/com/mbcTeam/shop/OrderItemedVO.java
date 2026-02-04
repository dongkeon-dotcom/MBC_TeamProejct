
package com.mbcTeam.shop;

import lombok.Data;

@Data
public class OrderItemedVO {
    private long itemIdx;                // 주문상세번호
    private long orderIdx;                    // 주문정보번호
    private long productIdx;                // 제품번호
    private String category;            // 카테고리
    private String subCategory;        // 하위카테고리
    private String productName;                // 제품명
    private int price;                // 가격
    private int discountRate;            // 할인률
    private String color;                // 컬러
    private String size;                // 사이즈
    private int quantity;                // 구매수량
    private String productMainImg;            // 제품대표이미지
    
    
    
}
