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

@RequestMapping("/userproduct")
@Controller
public class UserProductController {

    @Autowired
    private ProductService service;
    

    // 유저 상품 리스트
    @GetMapping("/userproductlist.do")
    public String userProductList(ProductVO vo, Model model) {
        List<ProductVO> productList = service.select(vo);
        model.addAttribute("li", productList);

        return "userproduct/userproductlist"; 
        // 실제 위치: /WEB-INF/view/userproduct/userproductlist.jsp
    }
    
    // 유저 상품 상세
    @GetMapping("/userproductdetail.do")
    public String userproductdetail(@RequestParam("productIdx") int productIdx, Model model) {
        // 상품 정보 조회
        ProductVO product = service.detail(productIdx);
        model.addAttribute("product", product);

        // 옵션 조회
        List<ProductOptionVO> optionList = service.selectOptions(productIdx);
        model.addAttribute("optionList", optionList);

        return "userproduct/userproductdetail"; 
        // 실제 위치: /WEB-INF/view/userproduct/userproductdetail.jsp
    }
}
