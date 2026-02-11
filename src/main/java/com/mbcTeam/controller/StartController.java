package com.mbcTeam.controller;

import java.util.Collections; 
import java.util.List; 

import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mbcTeam.product.ProductVO;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mbcTeam.product.ProductService;



@Controller
public class StartController {

    private final ProductService productService;

    public StartController(ProductService productService) {
        this.productService = productService;
    }
    
    @GetMapping("/index.do")
    public String index(Model model, HttpServletRequest request, HttpSession  session) {
        // 추천 상품 (슬라이드 쇼용)
        List<ProductVO> recommendedProducts = productService.getRecommendedProducts();
        Collections.shuffle(recommendedProducts); // 랜덤 섞기
        
        // 최대 8개만 추리기
        if (recommendedProducts.size() > 8) {
            recommendedProducts = recommendedProducts.subList(0, 8);
        }
        model.addAttribute("recommendedProducts", recommendedProducts);

        // 세일 상품 (하단 리스트용)
        List<ProductVO> saleProducts = productService.getSaleProducts();
        
        model.addAttribute("saleProducts", saleProducts);
        
        
       
        
        return "index";
    }

    
}