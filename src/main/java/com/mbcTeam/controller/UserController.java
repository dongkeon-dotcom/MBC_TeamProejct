
package com.mbcTeam.controller;

import java.io.File;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;


import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;

import org.springframework.security.core.context.SecurityContextHolder;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.mbcTeam.security.MemberMapper;
import com.mbcTeam.shop.DeliveryService;
import com.mbcTeam.shop.DeliveryVO;
import com.mbcTeam.shop.OrderItemedVO;
import com.mbcTeam.shop.OrderedService;
import com.mbcTeam.shop.OrderedVO;

import com.mbcTeam.user.ReviewImageVO;
import com.mbcTeam.user.ReviewService;
import com.mbcTeam.user.ReviewVO;
import com.mbcTeam.user.UserService;
import com.mbcTeam.user.UserVO;


@RequestMapping("/user")
@Controller
public class UserController {

	

	@Autowired
MemberMapper memberMapper;
	
	@Autowired
	private UserService service;
	
	@Autowired
	private OrderedService oservice;
	
	@Autowired
	private ReviewService rservice;
	@Autowired
    private DeliveryService dservice;
	
	
	@Autowired
	PasswordEncoder  passwordEncoder;
	
	
	private UserVO getLoginUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        // 시큐리티의 username(여기서는 id/email)으로 DB 조회
        return service.getByEmail(auth.getName());
    }
	
	
	@GetMapping(value = "/list.do")
	public String list(UserVO vo, Model model) {
		System.out.println("/LIST.DO");

		return "user/list";
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
	public String mypage(Model model) { // 매개변수에서 @AuthenticationPrincipal 부분 삭제
		// 1. 직접 시큐리티 컨텍스트에서 인증 정보 추출
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();

	    // 2. 로그인 여부 체크
	    if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
	        return "redirect:/user/login.do";
	    }

	    // 3. 로그인된 아이디(이메일) 가져오기
	    String userId = auth.getName(); 
	    
	    // 4. DB에서 실제 사용자 정보(이름 등) 가져오기
	    // MemberMapperDao를 활용합니다. (컨트롤러 상단에 @Autowired 되어있어야 함)
	    UserVO userVO = memberMapper.getByEmail(userId);
	    
	    // 5. JSP로 전달
	    model.addAttribute("userVO", userVO);
	    model.addAttribute("userId", userId);

	    return "user/mypage";
	}
	
	// 1. 개인정보 수정 페이지
    @GetMapping("/memberEdit.do")
    public String edit(Model model) {
        UserVO loginMember = getLoginUser();
        if (loginMember == null) return "redirect:/user/login.do";

        DeliveryVO delivery = service.getDelivery(loginMember.getUserIdx());
        if (delivery == null) delivery = new DeliveryVO();

        model.addAttribute("d", delivery);
        model.addAttribute("m", loginMember);
        return "user/memberEdit";
    }
	
 // 2. 회원 정보 수정 처리
    @PostMapping("/memberUpdate.do")
    public String memberUpdate(UserVO vo) {
        UserVO loginMember = getLoginUser();
        if (loginMember == null) return "redirect:/user/login.do";

        // 세션 대신 가져온 loginMember에서 번호 추출
        vo.setUserIdx(loginMember.getUserIdx());

        // 비밀번호 처리
        if (vo.getPassword() != null && !vo.getPassword().trim().isEmpty()) {
            vo.setPassword(passwordEncoder.encode(vo.getPassword()));
        } else {
            vo.setPassword(loginMember.getPassword());
        }

        service.updateUser(vo);
        // 시큐리티를 사용하므로 세션 교체 코드는 불필요 (다음에 조회할 때 DB에서 다시 읽어옴)
        return "redirect:/user/mypage.do";
    }
 // 3. 주문 상세 내역
    @GetMapping(value = "/orderDetailList.do")
    public String orderDetailList(@RequestParam("orderIdx") long orderIdx, Model model) {
        UserVO login = getLoginUser();
        if (login == null) return "redirect:/user/login.do";

        OrderedVO order = oservice.selectOrderedByOrderIdx(orderIdx);
        List<OrderItemedVO> detailList = oservice.selectOrderedItems(orderIdx);
        List<ReviewVO> myReviews = rservice.getReviewListByUserIdx(login.getUserIdx());

        // 본인 확인 보안 체크
        if (order != null && order.getUserIdx() != login.getUserIdx()) {
            return "redirect:/user/orderList.do";
        }

        model.addAttribute("order", order);
        model.addAttribute("detailList", detailList);
        model.addAttribute("myReviews", myReviews);
        return "user/orderDetailList";
    }
	
	// 로그인 페이지 이동
    @GetMapping("/login.do")
    public String login() {
    	//메인등에서 로그인하기 클릭시로그인페이지로이동하기위한루트 
    	System.out.println("/LOGINLOGIN.DO 통과함 ");
        return "user/login"; // views/member/login.jsp
    }

    @GetMapping("/loginOK.do")
    public String loginOK() {
    	//메인등에서 로그인하기 클릭시로그인페이지로이동하기위한루트 
    	System.out.println("/loginOK.DO");
        return "redirect:/"; // 메인으로 리다이렉트
    }
    @GetMapping("/member.do")
    public String member() {
    	//로그인페이지에 회원가입으로 이동을 위한 컨트롤  
    System.out.println("memberJoin  확인 용 ");
        return "user/memberJoin"; // views/member/login.jsp
    }
    
    

   /* @RequestMapping("/logout.do")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 전체 무효화 (모든 데이터 삭제)
        return "redirect:/";  // 메인 페이지로 이동
    }
	*/
	// 회원가입 처리
    @RequestMapping(value = "/memberOK.do", method = RequestMethod.POST)
    public String memberOK(HttpServletRequest request) {
    	String id = request.getParameter("id");
        String password  = request.getParameter("password");
        String userName  = request.getParameter("userName");
        String userPhone = request.getParameter("userPhone");

        // 서버단 필수 검증
        if (id == null || id.trim().isEmpty()) {
            request.setAttribute("msg", "이메일이 없습니다.");
            return "user/memberJoin";
        }

        // 이메일 중복 체크 (서버에서도 반드시)
        if (service.existsByEmail(id)) {   // ✅ 수정
            request.setAttribute("msg", "이미 사용 중인 이메일입니다.");
            return "user/memberJoin";
        }

        // VO 세팅
        UserVO vo = new UserVO();
        vo.setId(id);
        String encodedPassword = passwordEncoder.encode(password); 
        vo.setPassword(encodedPassword);
        
        vo.setUserName(userName);
        vo.setUserPhone(userPhone);
        vo.setUserRole("USER");
        vo.setEasyLogin(false);
        vo.setDeleted(false);
//Java Bean 규격에 따라 변수명이 isEasyLogin (소문자 is로 시작)인 경우,
 //Lombok은 setIsEasyLogin()이 아니라 **setEasyLogin()**이라는 이름으로 메서드를 생성합니다.
        service.insert(vo);  // ✅ 수정 (void)

        return "redirect:/user/login.do";
    }

    
    @ResponseBody
    @RequestMapping(value="/checkEmail.do", method=RequestMethod.GET, produces="application/json; charset=UTF-8")
    public Map<String, Object> checkEmail(@RequestParam("id") String id) {
        System.out.println("중복확인 요청 아이디: " + id);
        boolean exists = service.existsByEmail(id);
        System.out.println("중복여부: " + exists);
        
        Map<String, Object> res = new HashMap<>();
        res.put("exists", exists);
        return res;
    }
    
   
 // 4. 주문 내역 (페이징)
    @GetMapping("/orderList.do")
    public String orderList(
            @RequestParam(value="page", defaultValue="1") int page,
            @RequestParam(value="startDate", required=false) String startDate,
            @RequestParam(value="endDate", required=false) String endDate,
            Model model) {

        UserVO login = getLoginUser();
        if (login == null) return "redirect:/user/login.do";

        int pageSize = 10;
        int offset = (page - 1) * pageSize;
        
        List<OrderedVO> orderli = oservice.selectOrderedList(login.getUserIdx(), startDate, endDate, offset, pageSize);
        int totalCount = oservice.countOrderedList(login.getUserIdx(), startDate, endDate);

        // 페이징 계산 로직 (기존과 동일)
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int startPage = ((page - 1) / 5) * 5 + 1;
        int endPage = Math.min(startPage + 4, totalPage);
        if (endPage == 0) endPage = 1;

        model.addAttribute("orderli", orderli);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        return "user/orderList";
    }
  //후기 페이지로 이동을 위한컨트롤러 
    
	@GetMapping(value = "/review.do")
	public String review(UserVO vo, Model model) {
		System.out.println("/review.DO");

		return "user/review";
	}
    
	// 5. 리뷰 등록 처리
    @PostMapping("/reviewInsert.do")
    public String reviewInsert(ReviewVO vo, 
            @RequestParam(value="reviewFiles", required=false) MultipartFile[] files, 
            @RequestParam("orderIdx") int orderIdx, 
            HttpServletRequest request) throws Exception {

        UserVO loginMember = getLoginUser();
        if (loginMember == null) return "redirect:/user/login.do";

        vo.setUserIdx(loginMember.getUserIdx());
        vo.setUserName(loginMember.getUserName());

        int result = rservice.insertReview(vo);

        if(result > 0 && files != null) {
            String uploadPath = request.getSession().getServletContext().getRealPath("/resources/images/");
            File dir = new File(uploadPath);
            if (!dir.exists()) dir.mkdirs();

            int saveCount = 0;
            for (MultipartFile file : files) {
                if (!file.isEmpty() && saveCount < 3) {
                    String originalName = file.getOriginalFilename();
                    String ext = originalName.substring(originalName.lastIndexOf("."));
                    String saveName = UUID.randomUUID().toString() + ext;
                    file.transferTo(new File(uploadPath + File.separator + saveName));

                    ReviewImageVO imgVO = new ReviewImageVO();
                    imgVO.setReviewIdx(vo.getReviewIdx());
                    imgVO.setReviewImg(saveName); 
                    rservice.insertReviewImg(imgVO);
                    saveCount++;
                }
            }
        }
        return "redirect:/user/orderDetailList.do?orderIdx=" + orderIdx;
    }
	
	@GetMapping(value = "/reviewEdit.do")
	public String reviewEdit() {
		System.out.println("/reviewEdit.DO");

		return "user/reviewEdit";
	}

}
	
	
	
