package com.mbcTeam.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mbcTeam.member.MemberService;
import com.mbcTeam.member.MemberVO;

@RequestMapping("/memberLogin/")
@Controller
public class MemberController {

	@Autowired 
	private MemberService service;
	
	
	// 로그인 페이지 이동
    @GetMapping("/login.do")
    public String login() {
    	//메인등에서 로그인하기 클릭시로그인페이지로이동하기위
        return "customerPage/memberLogin/login"; // views/member/login.jsp
    }
    
    @GetMapping("/member.do")
    public String member() {
    	//로그인페이지에 회원가입으로 이동을 위한 컨트롤  
    System.out.println("memberJoin  확인 용 ");
        return "customerPage/memberLogin/memberJoin"; // views/member/login.jsp
    }
    
    
    @PostMapping("/memberOK.do")
    public String memberOK(MemberVO vo) {

    	service.insert(vo); // DB 저장

        // 가입 성공 → 메인으로 이동
        return "redirect:/main.do";
    } 
    @PostMapping("/loginOK.do")
    public String loginOK(MemberVO vo, HttpServletRequest request, HttpSession session) {

        // 1. 이메일 존재 여부 확인
        boolean emailExists = service.existsByEmail(vo.getUser_email());

        if (!emailExists) {
            request.setAttribute("emailError", "가입되지 않은 이메일입니다.");
           
            request.setAttribute("prevEmail", vo.getUser_email());  // 입력했던 이메일을 다시 보내줌 (사용자 편의)
         
            return "member/login"; 
        }

        // 2. 로그인 시도 (비밀번호 체크)
        MemberVO loginMember = service.login(vo);

        if (loginMember == null) {
            request.setAttribute("pwError", "틀린 비밀번호입니다.");
            request.setAttribute("prevEmail", vo.getUser_email());
            return "member/login";
            
        }

        // 3. 성공
        session.setAttribute("loginMember", loginMember);
        return "redirect:/main"; 
    }


}
