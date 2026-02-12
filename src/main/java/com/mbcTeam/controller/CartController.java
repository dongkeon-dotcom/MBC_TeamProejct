package com.mbcTeam.controller;

import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.mbcTeam.cart.CartService;
import com.mbcTeam.cart.CartVO;
import com.mbcTeam.user.UserService;
import com.mbcTeam.user.UserVO;

import java.util.List;

import javax.servlet.http.HttpSession;


@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;
    
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

    @PostMapping("/add.do")
    public String addCart(@RequestParam long productIdx,
                          @RequestParam(value="optionIdxList") List<Long> optionIdxList,
                          @RequestParam(value="quantityList") List<Integer> quantityList,
                          HttpSession session) {
        
        // 시큐리티 혹은 세션에서 유저 정보 가져오기
        UserVO loginUser = getLoginUser(); 
        if (loginUser == null) {
            return "redirect:/user/login.do";
        }

        // 여러 개의 옵션을 각각 CartVO로 만들어 인서트
        for (int i = 0; i < optionIdxList.size(); i++) {
            CartVO cart = new CartVO();
            cart.setUserIdx(loginUser.getUserIdx());
            cart.setProductIdx(productIdx);
            cart.setOptionIdx(optionIdxList.get(i));
            cart.setQuantity(quantityList.get(i));

            cartService.insertCart(cart);
        }
        
        return "redirect:/cart/cartlist.do";
    }
    
    
    @GetMapping("/cartlist.do")
    public String listCart(Model model) {
        // 1. 시큐리티 컨텍스트에서 로그인 유저 정보 가져오기
        // (컨트롤러 내부에 getLoginUser() 메서드가 정의되어 있다고 가정합니다)
        UserVO loginUser = getLoginUser(); 

        // 2. 로그인 체크
        if (loginUser == null) {
            return "redirect:/user/login.do";
        }

        // 3. 로그인된 유저의 idx를 사용하여 장바구니 조회
        List<CartVO> cartList = cartService.selectCart(loginUser.getUserIdx());
        
        // 4. JSP로 데이터 전달
        model.addAttribute("cartList", cartList);
        
        return "cart/cartlist";
    } 
    
    

    
    @PostMapping("/update.do")
    public String updateCart(@RequestParam long cartIdx,
                             @RequestParam int quantity) {
        // 1. 로그인 체크 (시큐리티 활용)
        UserVO loginUser = getLoginUser();
        if (loginUser == null) {
            return "redirect:/user/login.do";
        }

        // 2. 수량 업데이트 실행
        CartVO cart = new CartVO();
        cart.setCartIdx(cartIdx);
        cart.setQuantity(quantity);

        cartService.updateCart(cart);
        return "redirect:/cart/cartlist.do";
    }

    @PostMapping("/delete.do")
    public String deleteCart(@RequestParam long cartIdx) {
        UserVO loginUser = getLoginUser();
        if (loginUser == null) {
            return "redirect:/user/login.do";
        }
        
        cartService.deleteCart(cartIdx);
        return "redirect:/cart/cartlist.do";
    }
}
