package com.mbcTeam.controller;

import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mbcTeam.product.ProductOptionVO;
import com.mbcTeam.product.ProductService;
import com.mbcTeam.product.ProductVO;
import com.mbcTeam.shop.DeliveryService;
import com.mbcTeam.shop.DeliveryVO;
import com.mbcTeam.shop.OrderedService;
import com.mbcTeam.user.ReviewService;
import com.mbcTeam.user.ReviewVO;
import com.mbcTeam.user.UserService;
import com.mbcTeam.user.UserVO;

@RequestMapping("/delivery")
@Controller
public class DeliveryController {


	@Autowired
    private DeliveryService dservice;
    

	
	// 1. 주소록 목록 보기 +	//링크를 통해 addressList로 향하기 위한컨트롤러
    @GetMapping("/addressList.do")
    public String addressList(HttpSession session, Model model) {
        // 세션에서 로그인한 유저 정보 가져오기 (세션 key는 프로젝트에 맞게 수정하세요)
        UserVO loginUser = (UserVO) session.getAttribute("loginMember");
        
        if (loginUser == null) {
            return "redirect:/user/login.do"; // 로그인 안 되어 있으면 로그인으로
        }

        // 로그인한 유저의 고유 번호(idx)로 주소 목록 조회
        List<DeliveryVO> list = dservice.getAddressList(loginUser.getUserIdx());
        model.addAttribute("addressList", list);
        
        return "delivery/addressList"; // JSP 파일 경로
    }

    // 2. 단일 주소 삭제 (버튼 클릭)
    @GetMapping("/deleteAddress.do")
    public String deleteAddress(@RequestParam("deliveryIdx") long deliveryIdx) {
        // 서비스에서 만든 단일 삭제 호출 (또는 Arrays.asList로 감싸서 전달)
        dservice.deleteAddresses(Arrays.asList(deliveryIdx));
        
        return "redirect:/delivery/addressList.do";
    }

    // 3. 선택 주소 삭제 (체크박스 다중 삭제)
    @GetMapping("/deleteAddresses.do")
    public String deleteAddresses(@RequestParam("ids") String ids) {
        // 쉼표로 구분된 문자열 "1,2,5"를 List<Long>으로 변환
        List<Long> idList = Arrays.stream(ids.split(","))
                                  .map(Long::parseLong)
                                  .collect(Collectors.toList());
        dservice.deleteAddresses(idList);
        
        return "redirect:/delivery/addressList.do";
    }
    
    // 4. 주소 추가 팝업창 띄우기
 // 1-1. 등록 페이지 이동 (빈 화면)
    @GetMapping("/addressInsert.do")
    public String addressInsert() {
        return "delivery/addressInsert"; // addressInsert.jsp 호출
    }
	
	
	// @ResponseBody 지워진 상태여야 함!
	@PostMapping("/addressInsertProcess.do")
	public String addressInsertProcess(DeliveryVO dvo, HttpSession session, HttpServletResponse response) throws Exception {
		System.out.println("전달된 VO 객체: " + dvo.toString());
		System.out.println("기본배송지 체크여부: " + dvo.isDefaultAddress());
	    // 이 로그가 찍히는지 확인하는 게 최우선!
	    System.out.println(">>> [진입성공] 전달받은 이름: " + dvo.getDeliveryName());
	    
	    UserVO loginUser = (UserVO) session.getAttribute("loginMember");
	    
	    if (loginUser == null) {
	        // 세션 없을 때 처리
	        response.setContentType("text/html; charset=UTF-8");
	        PrintWriter out = response.getWriter();
	        out.println("<script>alert('세션이 만료되었습니다. 다시 로그인해주세요.'); window.close();</script>");
	        out.flush();
	        return null;
	    }

	    dvo.setUserIdx(loginUser.getUserIdx());
	 // 핵심: PK(deliveryIdx)가 있으면 수정, 없으면 등록
	    if (dvo.getDeliveryIdx() > 0) {
	        dservice.addrUpdate(dvo); // 아까 만든 update 메서드 호출
	    } else {
	        dservice.insertAddress(dvo); 
	    }

	    response.setContentType("text/html; charset=UTF-8");
	    PrintWriter out = response.getWriter();
	    out.println("<script>");
	    out.println("alert('" + (dvo.getDeliveryIdx() > 0 ? "수정" : "등록") + "되었습니다.');");
	    out.println("if(window.opener) window.opener.location.reload();");
	    out.println("window.close();");
	    out.println("</script>");
	    out.flush();
	    
	    return null;
	}
	
//// deliveyLIst에서 주소 선택시 수정하기로 넘어가는 컨트롤러 	
	// 2-1. 수정 페이지 이동 (기존 데이터 채워진 화면)
    @GetMapping("/addrEdit.do")
    public String addressEdit(@RequestParam("deliveryIdx") Long deliveryIdx, Model model) {
        // 1. 클릭한 주소의 정보를 DB에서 한 줄 가져옴
        DeliveryVO vo = dservice.getOneAddress(deliveryIdx);
        
        // 2. JSP로 데이터를 넘김 (수정 페이지에서 value="${addr.xxx}" 로 사용)
        model.addAttribute("addr", vo);
        
        return "delivery/addrEdit"; // addressEdit.jsp 호출
    }
 // 2-2. 수정 실행 (DB 업데이트)
    @PostMapping("/addressUpdateProcess.do")
    public String addressUpdateProcess(DeliveryVO vo,@RequestParam(value="defaultCheck", defaultValue="false") boolean defaultCheck // 여기서 낚아챔
    		) {
    	vo.setDefaultAddress(defaultCheck);
    	System.out.println("========== 수정 시도 데이터 확인 ==========");
        System.out.println("사용자 번호(userIdx): " + vo.getUserIdx());
        System.out.println("배송지 번호(deliveryIdx): " + vo.getDeliveryIdx());
        System.out.println("기본배송지 여부(isDefaultAddress): " + vo.isDefaultAddress());
        System.out.println("기본배송지 여부(isDefaultAddress): " + defaultCheck);
        System.out.println("=========================================");
    	// DAO의 addrUpdate를 호출하게 됩니다.
    	dservice.addrUpdate(vo); 
        
        // 수정 완료 후 목록으로 이동하면서 팝업을 닫으려면 
        // 별도의 'close.jsp'를 보내거나 redirect를 활용합니다.
        return "redirect:/delivery/addressList.do";
    }
}

