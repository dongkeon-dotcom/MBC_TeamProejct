package com.mbcTeam.shop;

import lombok.Data;

@Data
public class OrderVO {
    private long orderIdx;                        // 주문목록번호 
    private long userIdx;                        // 사용자번호
    private int totalPrice;                        // 총결제금액
    private String deliveryRecevier;            // 받는사람
    private String deliveryPhone;                // 받는사람번호
    private String deliveryAddress;                // 주소
    private String deliveryExtraAddress;        // 상세주소
    private String deliveryZipcode;                // 우편번호
    private String orderRegDate;                // 주문일자
}