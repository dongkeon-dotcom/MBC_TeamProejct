package com.mbcTeam.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mbcTeam.cart.CartService;
import com.mbcTeam.user.UserService;
import com.mbcTeam.user.UserVO;

@RequestMapping("/order")
@Controller
public class CartCOntroller {
	
	@Autowired
	private CartService cservice;

	
	@GetMapping(value = "/cartlist.do")
	public String cartlist() {
		System.out.println("/LIST.DO");

		return "order/cart";
	}
}
