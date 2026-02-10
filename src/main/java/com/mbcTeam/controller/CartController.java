package com.mbcTeam.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.mbcTeam.cart.CartService;
import com.mbcTeam.cart.CartVO;
import com.mbcTeam.user.UserVO;

import java.util.List;

import javax.servlet.http.HttpSession;


@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @PostMapping("/add.do")
    public String addCart(@RequestParam long productIdx,
                          @RequestParam long optionIdx,
                          @RequestParam int quantity,
                          HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginMember");
        if (loginUser == null) {
            return "redirect:/user/login.do"; // 로그인 필요
        }

        CartVO cart = new CartVO();
        cart.setUserIdx(loginUser.getUserIdx());
        cart.setProductIdx(productIdx);
        cart.setOptionIdx(optionIdx);
        cart.setQuantity(quantity);

        cartService.insertCart(cart);
        return "redirect:/cart/cartlist.do?userIdx=" + loginUser.getUserIdx();
    }

    @GetMapping("/cartlist.do")
    public String listCart(HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("loginMember");
        if (loginUser == null) {
            return "redirect:/user/login.do";
        }
        List<CartVO> cartList = cartService.selectCart(loginUser.getUserIdx());
        model.addAttribute("cartList", cartList);
        return "cart/cartlist";
    }


    @PostMapping("/delete.do")
    public String deleteCart(@RequestParam long cartIdx, HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginMember");
        cartService.deleteCart(cartIdx);
        return "redirect:/cart/cartlist.do";

    }

    @PostMapping("/update.do")
    public String updateCart(@RequestParam long cartIdx,
                             @RequestParam int quantity,
                             HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginMember");

        CartVO cart = new CartVO();
        cart.setCartIdx(cartIdx);
        cart.setQuantity(quantity);

        cartService.updateCart(cart);
        return "redirect:/cart/cartlist.do";

    }
}
