package com.mbcTeam.shop;

import lombok.Data;

@Data
public class DeliveryVO {
    private long deliveryIdx;                    //배송지번호(PK)
    private long userIdx;                        //사용자번호(FK)
    private String deliveryName;                //배송지명
    private String Receiver;            //받는사람
    private String deliveryPhone;                //받는사람번호
    private String address;                //주소
    private String extraAddress;        //상세주소
    private int zipcode;                //우편번호
    private boolean isDefaultAddress;        //기본배송지 유무
}