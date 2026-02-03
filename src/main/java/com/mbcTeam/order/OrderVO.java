package com.mbcTeam.order;

import lombok.Data;


@Data
public class OrderVO {
    private long orderIdx;                        // 주문목록번호 
    private long userIdx;                        // 사용자번호
    private int totalPrice;                        // 총결제금액
    private String recevier;            // 받는사람
    private String deliveryPhone;                // 받는사람번호
    private String address;                // 주소
    private String extraAddress;        // 상세주소
    private String zipcode;                // 우편번호
    private String orderDate;                // 주문일자
    
    
}
