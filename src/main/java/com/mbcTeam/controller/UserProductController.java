package com.mbcTeam.controller;

import java.util.List; 

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mbcTeam.product.ProductOptionVO;
import com.mbcTeam.product.ProductService;
import com.mbcTeam.product.ProductVO;
import com.mbcTeam.user.ReviewVO;

@RequestMapping("/userproduct")
@Controller
public class UserProductController {

    @Autowired
    private ProductService service;
    
    // 유저 상품 리스트
    @GetMapping("/userproductlist.do")
    public String userProductList(@RequestParam(value="category", required=false) String category, Model model) {
        List<ProductVO> productList;
        if (category != null && !category.isEmpty()) {
            productList = service.selectByCategory(category);
        } else {
            productList = service.selectAll();
        }
        model.addAttribute("li", productList);
        model.addAttribute("selectedCategory", category);
        return "userproduct/userproductlist";
    }

    
    
    @GetMapping("/userproductdetail.do")
    public String userProductDetail(@RequestParam("productIdx") int productIdx, Model model) {
        // 상품 정보 조회
        ProductVO product = service.detail(productIdx);
        model.addAttribute("product", product);

        // 옵션 조회
        List<ProductOptionVO> optionList = service.selectOptions(productIdx);
        model.addAttribute("optionList", optionList);

        // 리뷰 조회
        List<ReviewVO> reviewList = service.selectReviews(productIdx);
        model.addAttribute("reviewList", reviewList);

        return "userproduct/userproductdetail"; 
    }

    
}

