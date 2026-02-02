
package com.mbcTeam.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
        return "user/login"; // views/member/login.jsp
    }

    
    @GetMapping("/member.do")
    public String member() {
    	//로그인페이지에 회원가입으로 이동을 위한 컨트롤  
    System.out.println("memberJoin  확인 용 ");
        return "user/memberJoin"; // views/member/login.jsp
    }
    
    //로그인
    @PostMapping("/loginOK.do")
    public String loginOK(UserVO vo, HttpServletRequest request, HttpSession session) {

        // 0) 입력 검증
        if (vo.getUserID() == null || vo.getUserID().trim().isEmpty()) {
            request.setAttribute("emailError", "이메일을 입력하세요.");
            return "member/login";
        }
        if (vo.getUserPW() == null || vo.getUserPW().trim().isEmpty()) {
            request.setAttribute("pwError", "비밀번호를 입력하세요.");
            request.setAttribute("prevEmail", vo.getUserID());
            return "member/login";
        }

        // 1) 이메일 존재 여부 확인 (탈퇴 제외하도록 mapper도 수정 권장)
        if (!service.existsByEmail(vo.getUserID())) {
            request.setAttribute("emailError", "가입되지 않은 이메일입니다.");
            request.setAttribute("prevEmail", vo.getUserID());
            return "member/login";
        }

        // 2) 로그인 시도
        UserVO loginMember = service.Login(vo);
        if (loginMember == null) {
            request.setAttribute("pwError", "틀린 비밀번호입니다.");
            request.setAttribute("prevEmail", vo.getUserID());
            return "member/login";
        }

        // 3) 성공
        session.setAttribute("loginMember", loginMember);
        return "redirect:/main";
    }


	
	// 회원가입 처리
    @RequestMapping(value = "/memberOK.do", method = RequestMethod.POST)
    public String memberOK(HttpServletRequest request) {
    	String userID = request.getParameter("userID");
        String password  = request.getParameter("password");
        String userName  = request.getParameter("userName");
        String userPhone = request.getParameter("userPhone");

        // 서버단 필수 검증
        if (userID == null || userID.trim().isEmpty()) {
            request.setAttribute("msg", "이메일이 없습니다.");
            return "member/join";
        }

        // 이메일 중복 체크 (서버에서도 반드시)
        if (service.existsByEmail(userID)) {   // ✅ 수정
            request.setAttribute("msg", "이미 사용 중인 이메일입니다.");
            return "member/join";
        }

        // VO 세팅
        UserVO vo = new UserVO();
        vo.setUserID(userID);
        vo.setUserPW(password);
        vo.setUserName(userName);
        vo.setUserPhone(userPhone);
        vo.setUserRole("USER");
        vo.setUserEasyLogin(false);
        vo.setUserIsDeleted(false);

        service.insert(vo);  // ✅ 수정 (void)

        return "redirect:/member/login.do";
    }

    
    @ResponseBody
    @RequestMapping(value="/checkEmail.do", method=RequestMethod.GET)
    public Map<String, Object> checkEmail(@RequestParam("userID") String userID) {
    	System.out.println("중복확인 ");
        boolean exists = service.existsByEmail(userID);
    	System.out.println("중복확인 "+ exists);
        Map<String, Object> res = new HashMap<>();
        res.put("exists", exists);
        return res;
    }
    
}
	
	
	
