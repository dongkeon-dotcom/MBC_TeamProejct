/*
package com.mbcTeam.controller;

import org.springframework.stereotype.Controller;  
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mbcTeam.product.ProductService;
import com.mbcTeam.product.ProductVO;

@Controller
public class MainPageController {

    private static final Logger logger = LoggerFactory.getLogger(MainPageController.class);

    private final ProductService productService;

    public MainPageController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/index.do")
    public String mainPage(Model model) {
        // 추천 상품 (슬라이드 쇼용)
        List<ProductVO> recommendedProducts = productService.getRecommendedProducts();
        logger.info("추천상품 개수: {}", (recommendedProducts != null ? recommendedProducts.size() : "null"));
        model.addAttribute("recommendedProducts", recommendedProducts);

        // 세일 상품 (하단 리스트용)
        List<ProductVO> saleProducts = productService.getSaleProducts();
        logger.info("세일상품 개수: {}", (saleProducts != null ? saleProducts.size() : "null"));
        model.addAttribute("saleProducts", saleProducts);

       
        
        return "index";
    }
}
*/