package com.mbcTeam.controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

public class SocialLoginController {

	

    @GetMapping("/")
    public String home() {
    	System.out.println("/.DO");
        return "home";
    }

    @GetMapping("/login")
    public String login() {
    	System.out.println("/LOGIN.DO");
        return "login";
    }
    
    @GetMapping("/mypage")
    public String mypage(Model model) {
//@AuthenticationPrincipal OAuth2User user
       // String email = user.getAttribute("email");
        //String name = user.getAttribute("name");
        
       // model.addAttribute("name", name);
       // model.addAttribute("email", email);
    	System.out.println("/MYPAGE.DO");

        return "home";
    }
    
	
}
