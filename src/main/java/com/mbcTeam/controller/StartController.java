package com.mbcTeam.controller;

import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class StartController {

	@GetMapping(value="/index.do")
	public String  index(HttpServletRequest request, HttpSession  session){
		System.out.println("==>index() 확인 ");
		return "index";		
	}
	


	
}
