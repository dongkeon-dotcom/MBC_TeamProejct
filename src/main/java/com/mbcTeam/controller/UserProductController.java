package com.mbcTeam.controller;

import java.util.List;  

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mbcTeam.product.ProductDescImgVO;
import com.mbcTeam.product.ProductImgVO;
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
            	//카테고리랑 서브카테고리 고른거
                userProductList = service.selectByCategoryAndSub(category, subCategory);
            } else {
            	//카테고리 고른거
                userProductList = service.selectByCategory(category);
            }
        } else {
        	//전체
            userProductList = service.selectAll();
        }

        model.addAttribute("userProductList", userProductList); 
        //26-02-12 동건: 안쓰는거 같아서 주석처리
        //model.addAttribute("selectedCategory", category);
        //model.addAttribute("selectedSubCategory", subCategory);

        return "userproduct/userproductlist";
    }



    @GetMapping("/userproductdetail.do")
    public String userproductdetail(@RequestParam("productIdx") int productIdx, Model model) {
        System.out.println("/userproductdetail.DO 호출 - 상품번호: " + productIdx);

        // [중요] 기존 service.detail 대신, JOIN 없는 원본 데이터를 가져오는 메소드 사용
        ProductVO vo = new ProductVO();
        vo.setProductIdx(productIdx);
        
        // 1. 상품 상세 정보 (Products 테이블 단일 행 - 메인/사이즈 이미지 포함)
        // adminProductEdit가 매퍼의 'EDIT_PRODUCT'를 호출하므로 이걸 쓰는 게 가장 정확합니다.
        ProductVO product = service.adminProductEdit(vo); 
        model.addAttribute("product", product);

        // 2. 추가 이미지들 (ProductImg 테이블 리스트)
        List<ProductImgVO> subImgList = service.adminProductEditImg(productIdx);
        model.addAttribute("subImgList", subImgList);

        // 3. 설명 이미지들 (ProductDescImg 테이블 리스트)
        List<ProductDescImgVO> descImgList = service.adminProductEditDescImg(productIdx);
        model.addAttribute("descImgList", descImgList);

        // 4. 옵션 및 리뷰
        List<ProductOptionVO> optionList = service.selectOptions(productIdx);
        List<ReviewVO> reviewList = service.selectReviews(productIdx);
        model.addAttribute("optionList", optionList);
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

