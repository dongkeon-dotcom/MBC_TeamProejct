
package com.mbcTeam.controller;

import java.io.File; 
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
import org.springframework.web.multipart.MultipartFile;

import com.mbcTeam.order.OrderItemVO;
import com.mbcTeam.shop.OrderedService;
import com.mbcTeam.order.OrderVO;
import com.mbcTeam.user.ReviewImageVO;
import com.mbcTeam.user.ReviewService;
import com.mbcTeam.user.ReviewVO;
import com.mbcTeam.user.UserService;
import com.mbcTeam.user.UserVO;


@RequestMapping("/user")
@Controller
public class UserController {

	@Autowired
	private UserService service;
	
	@Autowired
	private OrderedService oservice;
	
	@Autowired
	private ReviewService rservice;


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
	public String mypage(HttpSession session, Model model) {
	    // 1. 세션에서 로그인 정보("loginMember")를 꺼냅니다.
	    UserVO login = (UserVO) session.getAttribute("loginMember");

	    // 2. 로그인 정보가 없으면 로그인 페이지로 튕겨냅니다. (보안)
	    if (login == null) {
	        return "redirect:/user/login.do";
	    }

	    // 3. 화면(JSP)에서 사용할 수 있도록 모델에 담아줍니다.
	    // 로그상에서 'userVO'라는 이름을 찾고 있으므로 이름을 맞춰줍니다.
	    model.addAttribute("userVO", login);

	    System.out.println("마이페이지 접속: " + login.getId());
	    return "user/mypage";
	}
	@GetMapping("/memberEdit.do")
	public String edit(HttpSession session, Model model) {
	    System.out.println("개인정보수정페이지 /memberEdit.do");

	    // 1. 세션에서 로그인된 회원 정보 가져오기
	    UserVO loginMember = (UserVO) session.getAttribute("loginMember");

	    // 2. 로그인이 안 된 경우 처리 (보안)
	    if (loginMember == null) {
	        return "redirect:/user/login.do"; 
	    }

	    // 3. JSP에서 'm'이라는 이름으로 쓰기로 했으므로 이름을 맞춰서 보냄
	    model.addAttribute("m", loginMember);

	    return "user/memberEdit";
	}
	
	
	
	@PostMapping("/update.do")
	public String update(UserVO vo, HttpSession session) {
	   
	    service.updateUser(vo);
	    
	    // 중요: DB가 수정되었으므로 세션 정보도 최신화해야 함
	    // (보통 다시 조회해서 넣거나, vo 객체를 다시 세션에 저장)
	    UserVO updatedMember = service.getUserById(vo.getId()); 
	    session.setAttribute("loginMember", updatedMember);
	    
	    return "redirect:/user/mypage"; // 수정 완료 후 메인으로
	}

	@GetMapping(value = "/addressList.do")
	public String addresses(UserVO vo) {
		System.out.println("/ADDRESS.DO");
		return "user/addressList";

	}

//orderlist 에서  orderdetailList로 이동하기
	@GetMapping(value = "/orderDetailList.do")
	public String orderDetailList(
	        @RequestParam("orderIdx") long orderIdx, 
	        HttpSession session, 
	        Model model) {
	    
	    // 1. 로그인 체크
	    UserVO login = (UserVO) session.getAttribute("loginMember");
	    if (login == null) return "redirect:/user/login.do";

	 // 2. 서비스 호출하여 데이터 가져오기
	    // (1) 주문 기본 정보 (주소, 수령인, 총 결제금액 등)
	    OrderVO order = oservice.selectOrderByOrderIdx(orderIdx);
	    
	    // (2) 해당 주문의 상세 상품 리스트 (상품명, 수량, 옵션 등)
	    List<OrderItemVO> detailList = oservice.selectOrderItems(orderIdx);
	    // 3. 보안 체크 (주문한 본인인지 확인하는 로직 - 권장)
	    if (order != null && order.getUserIdx() != login.getUserIdx()) {
	        return "redirect:/user/orderList.do"; // 본인 주문이 아니면 목록으로 튕겨냄
	    }

	    // 4. JSP로 데이터 전달
	    model.addAttribute("order", order);      // 상세 상단용
	    model.addAttribute("detailList", detailList); // 상세 하단 리스트용
	    
	    // 콘솔 로그 확인 (값이 잘 오는지 체크)
	    System.out.println("조회된 상품 수: " + (detailList != null ? detailList.size() : 0));
	    
	    return "user/orderDetailList"; // 파일명: orderDetailList.jsp
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
        if (vo.getId() == null || vo.getId().trim().isEmpty()) {
            request.setAttribute("emailError", "이메일을 입력하세요.");
            return "user/login";
        }
        if (vo.getPassword() == null || vo.getPassword().trim().isEmpty()) {
            request.setAttribute("pwError", "비밀번호를 입력하세요.");
            request.setAttribute("prevEmail", vo.getId());
            return "user/login";
        }

        // 1) 이메일 존재 여부 확인 (탈퇴 제외하도록 mapper도 수정 권장)
        if (!service.existsByEmail(vo.getId())) {
            request.setAttribute("emailError", "가입되지 않은 이메일입니다.");
            request.setAttribute("prevEmail", vo.getId());
            return "user/login";
        }

        // 2) 로그인 시도
        UserVO loginMember = service.Login(vo);
        if (loginMember == null) {
            request.setAttribute("pwError", "틀린 비밀번호입니다.");
            request.setAttribute("prevEmail", vo.getId());
            return "user/login";
        }

        // 3) 성공
        session.setAttribute("loginMember", loginMember);
        return "redirect:/";
    }

    @RequestMapping("/logout.do")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 전체 무효화 (모든 데이터 삭제)
        return "redirect:/";  // 메인 페이지로 이동
    }
	
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
        vo.setPassword(password);
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
    
   
    
     //// 마이페이지에서 orderList로이동 및 페이징 처리 이따가 디비 받아서 서비스 주입하고 받아오기
    @GetMapping("/orderList.do")
    public String orderList(
            @RequestParam(value="page", defaultValue="1") int page,
            @RequestParam(value="startDate", required=false) String startDate,
            @RequestParam(value="endDate", required=false) String endDate,
            HttpSession session,
            Model model) {

        // 1. 로그인 체크
        UserVO login = (UserVO) session.getAttribute("loginMember");
        if (login == null) return "redirect:/user/login.do";

        // 2. 페이징 설정
        int pageSize = 10;
        int offset = (page - 1) * pageSize;
        long userIdx = login.getUserIdx(); // long 타입 그대로 유지

        // 3. 서비스 호출
        List<OrderVO> orderli = oservice.selectOrderList(userIdx, startDate, endDate, offset, pageSize);
        int totalCount = oservice.countOrderList(userIdx, startDate, endDate);

        // 4. 페이징 로직 처리
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int blockSize = 5;
        int startPage = ((page - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPage);
        
        // 만약 데이터가 하나도 없을 경우 endPage가 0이 되는 것 방지
        if (endPage == 0) endPage = 1;

        // 5. JSP 데이터 전달
        model.addAttribute("orderli", orderli);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);

        return "user/orderList";
    }
  //후기 페이지로 이동을 위한컨트롤러 
    
	@GetMapping(value = "/review.do")
	public String review(UserVO vo, Model model) {
		System.out.println("/review.DO");

		return "user/review";
	}
    
   //후기입력을 위한 컨트롤러 
	@PostMapping("/reviewInsert.do")
	public String reviewInsert(ReviewVO vo, 
	        @RequestParam(value="reviewFiles", required=false) MultipartFile[] files, 
	        @RequestParam("orderIdx") int orderIdx, 
	        HttpSession session, 
	        HttpServletRequest request) throws Exception {

	    // 1. 세션 체크
	    UserVO loginMember = (UserVO) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        return "redirect:/user/login.do";
	    }

	    // 2. VO 데이터 보완 (작성자 정보)
	    vo.setUserIdx(loginMember.getUserIdx());
	    vo.setUserName(loginMember.getUserName());

	    // 3. 리뷰 본문 저장 
	    // Mapper에서 useGeneratedKeys="true"에 의해 vo.reviewIdx에 자동 생성된 PK가 채워짐
	    int result = rservice.insertReview(vo);

	    // 4. 파일 처리 (본문 저장 성공 시에만 실행)
	    if(result > 0 && files != null) {
	        // 실제 저장 경로 설정 (resources/upload/reviews)
	        String uploadPath = request.getSession().getServletContext().getRealPath("/resources/images/");
	        System.out.println("데이터 확인: 1" );
	        File dir = new File(uploadPath);
	        if (!dir.exists()) {
	            dir.mkdirs(); 
	        }

	        int saveCount = 0;
	        for (MultipartFile file : files) {
	            // 비어있지 않은 파일만 처리하며 최대 3장 제한
	            if (!file.isEmpty() && saveCount < 3) {
	                // 고유 파일명 생성
	                String originalName = file.getOriginalFilename();
	                String ext = originalName.substring(originalName.lastIndexOf("."));
	                String saveName = UUID.randomUUID().toString() + ext;
	                
	                // 실제 물리적 저장
	                file.transferTo(new File(uploadPath + File.separator + saveName));
	                
	                // 5. 리뷰 이미지 DB 저장 (ReviewImageVO)
	                ReviewImageVO imgVO = new ReviewImageVO();
	                imgVO.setReviewIdx(vo.getReviewIdx()); // 방금 생성된 review_Idx 사용
	                imgVO.setReviewImg(saveName); 
	                
	                rservice.insertReviewImg(imgVO);
	                saveCount++;
	            } System.out.println("데이터 확인: 2" );
	        }
	    }
	    System.out.println("데이터 확인: 3" );
	    // 6. 작성 완료 후 원래 보고 있던 주문 상세 페이지로 리다이렉트
	    return "redirect:/user/orderDetailList.do?orderIdx=" + orderIdx; 
	}

}
	
	
	
