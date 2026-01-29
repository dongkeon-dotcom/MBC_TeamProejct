package com.mbcTeam.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mbcTeam.product.ProductImgVO;
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
    
    
    @GetMapping("/userproductdetail.do")
    public String detail(@RequestParam("productIdx") int productIdx, Model model) {
        ProductVO product = service.userproductdetail(productIdx); // 상품 기본 정보
        model.addAttribute("product", product);

        List<ProductImgVO> imgList = service.selectImg(productIdx); // 이미지 목록
        model.addAttribute("imgList", imgList);

        List<ProductOptionVO> optionList = service.selectOption(productIdx); // 옵션 + 재고
        model.addAttribute("optionList", optionList);

        return "userproduct/detail"; 
    }

    

}
