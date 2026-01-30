package com.mbcTeam.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mbcTeam.user.UserService;
import com.mbcTeam.user.UserVO;

@RequestMapping("/user")
@Controller
public class UserController {

	@Autowired
	private UserService service;

	@GetMapping(value = "/list.do")
	public String list(UserVO vo, Model model) {
		System.out.println("/LIST.DO");

		return "user/list";
	}

	@GetMapping("edit.do")
	String edit(Model model, UserVO vo) {
		System.out.println("/EDIT.DO");
		return "user/edit";

	}

	@GetMapping(value = "/form.do")
	public String form(UserVO vo, Model model) {
		System.out.println("/FORM.DO");
		return "user/form";
	}

	@GetMapping(value = "/formOK.do")
	public String formOK(UserVO vo, Model model) {
		System.out.println("/FORMOK.DO");
		service.insert(vo);
		return "user/list";

	}

	@GetMapping(value = "/mypage.do")
	public String mypage(UserVO vo, Model model) {
		System.out.println("/MYPAGE.DO");
		return "user/mypage";

	}

	@GetMapping(value = "/addresses.do")
	public String addresses(UserVO vo) {
		System.out.println("/ADDRESS.DO");
		return "user/addresses";

	}
	
	// 로그인 페이지 이동
    @GetMapping("/login.do")
    public String login() {
    	//메인등에서 로그인하기 클릭시로그인페이지로이동하기위한루트 
    	System.out.println("/LOGINLOGIN.DO");
        return "customerPage/memberLogin/login"; // views/member/login.jsp
    }

    
    @GetMapping("/member.do")
    public String member() {
    	//로그인페이지에 회원가입으로 이동을 위한 컨트롤  
    System.out.println("memberJoin  확인 용 ");
        return "customerPage/memberLogin/memberJoin"; // views/member/login.jsp
    }
    
    
    @PostMapping("/memberOK.do") 
    public String memberOK(UserVO vo) {
    	System.out.println("/MEMBEROK.DO");
    	service.insert(vo); // DB 저장

        // 가입 성공 → 홈페이지 이동
        return "redirect:/main.do";
       
    } 
    
    
    @PostMapping("/loginOK.do")
    public String loginOK(UserVO vo, HttpServletRequest request, HttpSession session) {
    	System.out.println("/LOGINOK.DO");
        // 1. 이메일 존재 여부 확인
        boolean emailExists = service.existsByEmail(vo.getUserID());

        if (!emailExists) {
            request.setAttribute("emailError", "가입되지 않은 이메일입니다.");
           
            request.setAttribute("prevEmail", vo.getUserID());  // 입력했던 이메일을 다시 보내줌 (사용자 편의)
         
            return "member/login"; 
        }

        // 2. 로그인 시도 (비밀번호 체크)
        UserVO loginMember = service.Login(vo);

        if (loginMember == null) {
            request.setAttribute("pwError", "틀린 비밀번호입니다.");
            request.setAttribute("prevEmail", vo.getUserID());
            return "member/login";
            
        }

        // 3. 성공
        session.setAttribute("loginMember", loginMember);
        return "redirect:/main";  // 메인페이지로이동 
        
    }

    
}
