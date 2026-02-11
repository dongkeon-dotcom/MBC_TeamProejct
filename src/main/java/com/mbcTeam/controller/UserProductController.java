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
    public String userProductList(@RequestParam(value="category", required=false) String category,
                                  @RequestParam(value="subCategory", required=false) String subCategory,
                                  Model model) {
        List<ProductVO> userProductList;
        if (category != null && !category.isEmpty()) {
            if (subCategory != null && !subCategory.isEmpty()) {
                userProductList = service.selectByCategoryAndSub(category, subCategory);
            } else {
                userProductList = service.selectByCategory(category);
            }
        } else {
            userProductList = service.selectAll();
        }

        model.addAttribute("userProductList", userProductList); 
        model.addAttribute("selectedCategory", category);
        model.addAttribute("selectedSubCategory", subCategory);

        return "userproduct/userproductlist";
    }



    @GetMapping("/userproductdetail.do")
    public String userproductdetail(@RequestParam("productIdx") int productIdx, Model model) {
    	System.out.println("/userproductdetail.DO");
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

    
    
    // 검색기능 
    @GetMapping("/search.do")
    public String search(@RequestParam("keyword") String keyword, Model model) {
        List<ProductVO> results = service.searchProducts(keyword);
        model.addAttribute("userProductList", results);
        model.addAttribute("searchKeyword", keyword);
        model.addAttribute("resultCount", results.size()); // 결과 개수 추가
        
        return "userproduct/userproductlist";
    }

    
}

