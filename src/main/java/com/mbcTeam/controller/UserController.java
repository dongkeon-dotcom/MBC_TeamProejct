package com.mbcTeam.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mbcTeam.product.ProductService;
import com.mbcTeam.shop.OrderVO;
import com.mbcTeam.user.UserService;
import com.mbcTeam.user.UserVO;

@RequestMapping("/user")
@Controller
public class UserController {

	@Autowired
	private UserService service;
	
	@Autowired
	private ProductService pservice;
	

	@GetMapping(value = "/list.do")
	public String list(UserVO vo, Model model) {

		return "user/list";
	}

	@GetMapping("edit.do")
	String edit(Model model, UserVO vo) {

		return "user/edit";

	}

	@GetMapping(value = "/form.do")
	public String form(UserVO vo, Model model) {

		return "user/form";
	}

	@GetMapping(value = "/formOK.do")
	public String formOK(UserVO vo, Model model) {

		service.insert(vo);
		return "user/list";

	}


	@GetMapping(value = "/mypage.do")
	public String mypage(UserVO vo, Model model,HttpSession session ) {
	 
		return "user/mypage";

	}

	@GetMapping(value = "/addresses.do")
	public String addresses(UserVO vo) {

		return "user/addresses";

	}

	
	@GetMapping(value = "/review.do")//상세주문리스트에서 후기버튼 누르면 오는곳 
	public String reivew(UserVO vo, Model model) {

		service.insert(vo);
		return "user/review";
		}

	
	
	@GetMapping(value = "/orderDetailList.do")
	public String orderDetailList(UserVO vo,Model medel,HttpSession session,OrderVO ovo) {
		//medel.addAttribute("li",service.Edit(vo));
		//medel.addAttribute("m",pservice.edit(null));
		return "user/orderDetailList";

	}
	
	// 로그인 페이지 이동
    @GetMapping("/login.do")
    public String login() {
    	System.out.println("로그인 확인용");
    	//메인등에서 로그인하기 클릭시로그인페이지로이동하기위한루트 
        return "/user/memberLogin/login"; // views/member/login.jsp
    }

    
    @GetMapping("/member.do")
    public String member() {
    	//로그인페이지에 회원가입으로 이동을 위한 컨트롤  
    System.out.println("memberJoin  확인 용 ");
        return "/user/memberLogin/memberJoin"; // views/member/login.jsp
    }
    
    
    @PostMapping("/memberOK.do") 
    public String memberOK(UserVO vo) {

    	service.insert(vo); // DB 저장

        // 가입 성공 → 홈페이지 이동
        return "redirect:/main.do";
       
    } 
    
    
    @PostMapping("/loginOK.do")
    public String loginOK(UserVO vo, HttpServletRequest request, HttpSession session) {

        // 1. 이메일 존재 여부 확인
        boolean emailExists = service.existsByEmail(vo.getUserID());

        if (!emailExists) {
            request.setAttribute("emailError", "가입되지 않은 이메일입니다.");
           
            request.setAttribute("prevEmail", vo.getUserID());  // 입력했던 이메일을 다시 보내줌 (사용자 편의)
         
            return "/user/memberLogin/login"; 
        }

        // 2. 로그인 시도 (비밀번호 체크)
        UserVO loginMember = service.Login(vo);

        if (loginMember == null) {
            request.setAttribute("pwError", "틀린 비밀번호입니다.");
            request.setAttribute("prevEmail", vo.getUserID());
            return "/user/memberLogin/member/login";
            
        }

     //마이페이지에 이름 부르기위한 부
        session.setAttribute("loginMember", loginMember);
        
        // 3. 성공
        session.setAttribute("loginMember", loginMember);
        return "redirect:/main";  // 메인페이지로이동 
        
    }

 
	
    //고객 주문리트를위한 
    @GetMapping("/orderList.do") // 리스트를 보여주는 것은 보통 GET 방식입니다.
    public String orderList(HttpSession session, Model model) {
       
    	 // 1. 세션에서 로그인한 유저 정보를 가져옴
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "redirect:/login.do"; // 로그인 안 되어 있으면 로그인 페이지로
        }

        // 2. 서비스 계층을 통해 해당 유저의 주문 리스트를 가져옴
        // orderService.selectOrderList(loginUser.getUserIdx()) 형태의 메서드가 필요합니다.
       // List<OrderVO> orderli =service.selectOrderList(loginUser.getUserIdx());

        // 3. JSP에서 사용할 수 있도록 Model에 추가
     //   model.addAttribute("orderli", orderli);
        return "user/orderList"; // 이동할 JSP 경로 (예: WEB-INF/views/user/cart.jsp)
    }
    
    
    
}
