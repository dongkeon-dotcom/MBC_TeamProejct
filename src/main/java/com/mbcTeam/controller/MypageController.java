package com.mbcTeam.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/customerMyPage/")
@Controller
public class MypageController {


	@GetMapping("/mypage.do")
    public String mypage() {
    	//메인등에서 로그인하기 클릭시로그인페이지로이동하기위
	
        return "customerPage/customerMyPage/mypage"; // views/member/login.jsp
    }
	//마이페이지 -주문리스트 이동 
	
       @GetMapping("/orderList.do")
       public String orderList() {
       	//메인등에서 로그인하기 클릭시로그인페이지로이동하기위
    		//로그인페이지에 회원가입으로 이동을 위한 컨트롤  
    	    System.out.println("orderList  확인 용 ");
           return "customerPage/customerMyPage/orderList"; // views/member/login.jsp
       }
	//마이페이지주지 관리로  이동 
	
       @GetMapping("/addressList.do")
       public String addressList() {
       	//메인등에서 로그인하기 클릭시로그인페이지로이동하기위

   	    System.out.println("addressList  확인 용 ");
           return "customerPage/customerMyPage/addressList"; // views/member/login.jsp
       }
	
	
	
	
}
