
package com.mbcTeam.controller;

import java.io.File;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;

import org.springframework.security.core.context.SecurityContextHolder;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
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
	PasswordEncoder  passwordEncoder;
	

	private UserVO getLoginUser() {
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    
	    if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
	        return null;
	    }

	    String email = "";

	    // 1. 소셜 로그인(OAuth2)인 경우 처리
	    if (auth instanceof OAuth2AuthenticationToken) {
	        OAuth2User oAuth2User = (OAuth2User) auth.getPrincipal();
	        // 구글/네이버/카카오 모두 'email' 속성을 가지고 있다면 아래와 같이 추출
	        email = (String) oAuth2User.getAttributes().get("email");
	    } else {
	        // 2. 일반 로그인인 경우 처리
	        email = auth.getName();
	    }

	    System.out.println("===> 실제 조회할 이메일: " + email);
	    
	    // DB에서 이메일로 유저 정보를 가져옴
	    return service.getByEmail(email);
	}
		
	
	
	/**
	  * 전화번호 자동 하이픈 생성 메서드
	  */
	 private String formatPhoneNumber(String phone) {
	     if (phone == null || phone.isEmpty()) return "";
	     
	     // 숫자 이외의 문자 제거
	     phone = phone.replaceAll("[^0-9]", "");

	     if (phone.length() == 11) { // 010-1234-5678
	         return phone.replaceFirst("([0-9]{3})([0-9]{4})([0-9]{4})$", "$1-$2-$3");
	     } else if (phone.length() == 10) { 
	         if (phone.startsWith("02")) { // 02-1234-5678
	             return phone.replaceFirst("(02)([0-9]{4})([0-9]{4})$", "$1-$2-$3");
	         } else { // 010-123-4567
	             return phone.replaceFirst("([0-9]{3})([0-9]{3})([0-9]{4})$", "$1-$2-$3");
	         }
	     } else if (phone.length() == 9 && phone.startsWith("02")) { // 02-123-4567
	         return phone.replaceFirst("(02)([0-9]{3})([0-9]{4})$", "$1-$2-$3");
	     }
	     
	     return phone; // 형식이 맞지 않으면 숫자 그대로 반환
	 }
	 
	
	
	@GetMapping(value = "/mypage.do")
	public String mypage(Model model) {
	    // 1. 소셜/일반 로그인 구분해서 유저 정보를 가져오는 메서드 호출
	    UserVO userVO = getLoginUser();

	    // 2. 로그인 안 되어 있으면 로그인 페이지로
	    if (userVO == null) {
	        return "redirect:/user/login.do";
	    }

	    // 3. 모델에 담기 (이제 userVO.userName에 "홍길동" 같은 진짜 이름이 들어있음)
	    model.addAttribute("user", userVO); 

	    return "user/mypage";
	}
	
	// 1. 개인정보 수정 페이지
    @GetMapping("/memberEdit.do")
    public String edit(Model model) {
    	
        UserVO loginMember = getLoginUser();
        System.out.println("/되.DO"+loginMember);
        if (loginMember == null) return "redirect:/user/login.do";

        DeliveryVO delivery = service.getDelivery(loginMember.getUserIdx());
        if (delivery == null) delivery = new DeliveryVO();
        String formatted = formatPhoneNumber(loginMember.getUserPhone());
        loginMember.setUserPhone(formatted);
        model.addAttribute("d", delivery);
        model.addAttribute("m", loginMember);
        return "user/memberEdit";
    }
	
 // 2. 회원 정보 수정 처리
    @PostMapping("/memberUpdate.do")
    public String memberUpdate(UserVO vo) {
    	UserVO loginMember = getLoginUser();
        if (loginMember == null) return "redirect:/user/login.do";

        // 1. 유저 식별값 설정
        vo.setUserIdx(loginMember.getUserIdx());

        // 2. [추가] 전화번호 포맷팅 (01012345678 -> 010-1234-5678)
        // JSP에서 합쳐서 보낸 숫자를 다시 하이픈 형태로 변환합니다.
        if (vo.getUserPhone() != null) {
            vo.setUserPhone(formatPhoneNumber(vo.getUserPhone()));
        }

        // 3. 비밀번호 처리
        if (vo.getPassword() != null && !vo.getPassword().trim().isEmpty()) {
            vo.setPassword(passwordEncoder.encode(vo.getPassword()));
        } else {
            // 비밀번호를 입력하지 않았다면 기존 비밀번호 유지
            vo.setPassword(loginMember.getPassword());
        }

        // 4. DB 업데이트
        service.updateUser(vo);
        
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
    public String loginOK(HttpSession session) {
    	// 세션에서 꺼내기
        Integer userIdx = (Integer) session.getAttribute("userIdx");
        String userName = (String) session.getAttribute("userName");

        System.out.println("로그인 성공 유저 PK: " + userIdx);
        System.out.println("로그인 성공 유저 이름: " + userName);
        
        return "redirect:/";
    }

 // 1. 회원가입 페이지 이동
 @GetMapping("/member.do")
 public String member(HttpSession session, Model model) {
    
	 System.out.println("===> [Controller] 세션 ID: " + session.getId());
	// 서비스에서 저장한 키값인 "socialId"로 꺼냄
	    String socialId = (String) session.getAttribute("socialId");
	    String socialName = (String) session.getAttribute("socialName");
	    Boolean isSocial = (Boolean) session.getAttribute("isSocial");
	 // 로그 확인! 여기서 두 값이 똑같이 이메일로 나오면 서비스 단이 범인입니다.
	    System.out.println("DEBUG socialId: " + socialId);
	    System.out.println("DEBUG socialName: " + socialName);
	    
	    
	    if (Boolean.TRUE.equals(isSocial) && socialId != null) {
	        model.addAttribute("id", socialId); // JSP의 ${id}로 전달
	        model.addAttribute("userName", socialName);
	        model.addAttribute("isSocial", true);
	        System.out.println("===> 성공: 소셜 가입 모드 진입 (ID: " + socialId + ")");
	    } else {
	        model.addAttribute("isSocial", false);
	        System.out.println("===> 실패: 일반 가입 모드 진입");
	    }
	    return "user/memberJoin";
	}

 @RequestMapping(value = "/memberOK.do", method = RequestMethod.POST)
 public String memberOK(HttpServletRequest request, HttpSession session) {
     String id = request.getParameter("id");
     String password = request.getParameter("password");
     String userName = request.getParameter("userName");
     String userPhone = request.getParameter("userPhone"); // JSP에서 합쳐진 값 (예: 01012345678)
     String isSocialUser = request.getParameter("isSocialUser");

     // 1. 서버단 필수 검증
     if (id == null || id.trim().isEmpty()) {
         request.setAttribute("msg", "이메일 정보가 없습니다.");
         return "user/memberJoin";
     }

     // 2. 이메일 중복 체크
     if (service.existsByEmail(id)) {
         request.setAttribute("msg", "이미 가입된 계정입니다.");
         return "user/memberJoin";
     }

     // [추가] 전화번호 포맷팅 처리 (01012345678 -> 010-1234-5678)
     String formattedPhone = formatPhoneNumber(userPhone);

     // 3. VO 기본 세팅
     UserVO vo = new UserVO();
     vo.setId(id); 
     vo.setUserName(userName);
     vo.setUserPhone(formattedPhone); // ★ 포맷팅된 번호 세팅
     vo.setUserRole("USER");
     vo.setDeleted(false);

     // 4. 소셜 유저 여부에 따른 분기 처리
     if ("Y".equals(isSocialUser)) {
         vo.setEasyLogin(true); 
         vo.setPassword(passwordEncoder.encode("SOCIAL_AUTH_TEMP_PW")); 
         
         Integer socialLoginType = (Integer) session.getAttribute("loginType");
         vo.setLoginType(socialLoginType != null ? socialLoginType : 1); 
     } else {
         vo.setEasyLogin(false);
         vo.setLoginType(0); 
         
         if (password != null && !password.isEmpty()) {
             vo.setPassword(passwordEncoder.encode(password));
         }
     }

     // 5. DB 인서트
     service.insert(vo);

     // 6. 가입 직후 세션 설정
     session.setAttribute("userName", userName);
     session.setAttribute("loginType", vo.getLoginType());
     session.setAttribute("userIdx", vo.getUserIdx());

     // 7. 가입 성공 후 소셜 관련 임시 세션 제거
     if ("Y".equals(isSocialUser)) {
         session.removeAttribute("socialId");
         session.removeAttribute("socialName");
         session.removeAttribute("isSocial");
     }

     System.out.println("===> 회원가입 완료: " + userName + " (" + formattedPhone + ")");
     
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
        
        // 데이터 조회
        List<OrderedVO> orderli = oservice.selectOrderedList(login.getUserIdx(), startDate, endDate, offset, pageSize);
        int totalCount = oservice.countOrderedList(login.getUserIdx(), startDate, endDate);

        // 페이징 계산
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int startPage = ((page - 1) / 5) * 5 + 1;
        int endPage = Math.min(startPage + 4, totalPage);
        if (endPage == 0) endPage = 1;

        // 모델 담기
        model.addAttribute("orderli", orderli);
        model.addAttribute("page", page);        // JSP의 ${page}와 이름 맞춤
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        
        // ✅ 검색 조건 유지 (이걸 넣어줘야 페이지 넘길 때 날짜가 안 풀려요)
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
    
	// 5. 리뷰 등록 처리
    @PostMapping("/reviewInsert.do")
    public String reviewInsert(ReviewVO vo, 
            @RequestParam(value="reviewFiles", required=false) MultipartFile[] files, 
            @RequestParam("orderIdx") int orderIdx, 
            HttpServletRequest request) throws Exception {
    	System.out.println("아이템 인덱스 확인: " + vo.getItemIdx());
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
    public String reviewEdit(@RequestParam("reviewIdx") long reviewIdx, 
                             @RequestParam("orderIdx") long orderIdx, // 1. 여기서 orderIdx를 꼭 받아야 합니다!
                             Model model) {
        
        System.out.println("/reviewEdit.DO 요청 들어옴! 리뷰번호: " + reviewIdx + ", 주문번호: " + orderIdx);

        // 1. DB에서 기존 후기 텍스트 데이터를 가져옵니다.
        ReviewVO vo = rservice.getReviewOne(reviewIdx);
         
        // 2. DB에서 해당 리뷰에 달린 이미지 리스트를 가져옵니다.
        List<ReviewImageVO> imgList = rservice.getReviewImages(reviewIdx);

        // 3. 보따리(Model)에 담아서 JSP로 보냅니다.
        model.addAttribute("reviewVO", vo);
        model.addAttribute("imgList", imgList);
        model.addAttribute("orderIdx", orderIdx); // 2. JSP로 orderIdx를 넘겨줘야 hidden에 담을 수 있어요!

        return "user/reviewEdit";
    }
	
	// 2. 실제 수정 실행 (DB 업데이트)

	@RequestMapping(value = "/reviewUpdate.do", method = RequestMethod.POST)
	public String reviewUpdate(ReviewVO vo, 
	                           @RequestParam(value="reviewFiles", required=false) List<MultipartFile> files, 
	                           @RequestParam("orderIdx") long orderIdx, // VO에 없으므로 직접 받음
	                           HttpSession session) { // request 대신 session 사용

	    // 1. 텍스트 정보 업데이트 (내용, 별점 등)
	    rservice.updateReview(vo);
	    
	    // 2. 사진 교체 로직 (파일이 새로 들어왔을 때만 기존 사진 삭제)
	    if (files != null && !files.isEmpty() && !files.get(0).isEmpty()) {
	        
	        // [필수] 기존 DB에 등록된 이미지 정보 삭제
	        // rservice에 해당 메서드가 있는지 확인하세요!
	        rservice.deleteReviewImgs(vo.getReviewIdx()); 
	        
	        // 실제 서버 내 저장 경로 찾기 (session 사용)
	        String uploadPath = session.getServletContext().getRealPath("/resources/upload/");
	        
	        for (MultipartFile file : files) {
	            if (!file.isEmpty()) {
	                String saveFileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
	                
	                try {
	                    // 서버 폴더에 실제 파일 저장
	                    file.transferTo(new File(uploadPath, saveFileName));
	                    
	                    // DB에 새 이미지 정보 저장 (기존에 있던 REVIEWINSERTIMG 쿼리 활용)
	                    ReviewImageVO imgVO = new ReviewImageVO();
	                    imgVO.setReviewIdx(vo.getReviewIdx());
	                    imgVO.setReviewImg(saveFileName);
	                    
	                    rservice.insertReviewImg(imgVO); // REVIEWINSERTIMG 호출
	                    
	                } catch (Exception e) {
	                    System.out.println("사진 저장 중 오류: " + e.getMessage());
	                }
	            }
	        }
	    }
	    
	    // 3. 리다이렉트 (파라미터로 받은 orderIdx를 직접 사용)
	    return "redirect:/user/orderDetailList.do?orderIdx=" + orderIdx;
	}
	}

	
	
	
