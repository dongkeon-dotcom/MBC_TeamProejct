package com.mbcTeam.controller;

import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mbcTeam.product.ProductOptionVO;
import com.mbcTeam.product.ProductService;
import com.mbcTeam.product.ProductVO;
import com.mbcTeam.security.MemberMapper;
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
    
	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	private UserService service;
	
	private UserVO getLoginUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        // 시큐리티의 username(여기서는 id/email)으로 DB 조회
        return service.getByEmail(auth.getName());
    }
	
	
	// 1. 주소록 목록 보기
    @GetMapping("/addressList.do")
    public String addressList(Model model) {
        UserVO loginUser = getLoginUser();
        
        if (loginUser == null) {
            return "redirect:/user/login.do";
        }

        List<DeliveryVO> list = dservice.getAddressList(loginUser.getUserIdx());
        model.addAttribute("addressList", list);
        
        return "delivery/addressList";
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
	
 // 5. 주소 등록/수정 프로세스 (팝업창에서 호출)
    @PostMapping("/addressInsertProcess.do")
    public String addressInsertProcess(DeliveryVO dvo, HttpServletResponse response) throws Exception {
        UserVO loginUser = getLoginUser();
        
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (loginUser == null) {
            out.println("<script>alert('로그인이 필요합니다.'); window.close();</script>");
            out.flush();
            return null;
        }

        dvo.setUserIdx(loginUser.getUserIdx());

        // PK(deliveryIdx)가 있으면 수정, 없으면 등록
        if (dvo.getDeliveryIdx() > 0) {
            dservice.addrUpdate(dvo);
        } else {
            dservice.insertAddress(dvo); 
        }

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
 // 7. 수정 실행 (목록에서 바로 수정할 경우 등)
    @PostMapping("/addressUpdateProcess.do")
    public String addressUpdateProcess(DeliveryVO vo, @RequestParam(value="defaultCheck", defaultValue="false") boolean defaultCheck) {
        UserVO loginUser = getLoginUser();
        if (loginUser == null) return "redirect:/user/login.do";

        vo.setUserIdx(loginUser.getUserIdx()); // 사용자 번호 유지
        vo.setDefaultAddress(defaultCheck);
        
        dservice.addrUpdate(vo); 
        
        return "redirect:/delivery/addressList.do";
    }
}


