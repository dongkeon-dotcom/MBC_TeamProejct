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
import com.mbcTeam.user.ReviewImageVO;
import com.mbcTeam.user.ReviewVO;

@RequestMapping("/userproduct")
@Controller
public class UserProductController {

    @Autowired
    private ProductService service;

    @Autowired
    private com.mbcTeam.user.ReviewService rservice;

    // 1. 유저 상품 리스트 (카테고리 필터링 포함)
    @GetMapping("/userproductlist.do")
    public String userProductList(
            @RequestParam(value="category", required=false) String category,
            @RequestParam(value="subCategory", required=false) String subCategory,
            Model model) {
        
        List<ProductVO> userProductList;

        // 카테고리 파라미터 존재 여부에 따른 조회 분기
        if (category != null && !category.trim().isEmpty()) {
            if (subCategory != null && !subCategory.trim().isEmpty()) {
                // 카테고리 + 서브카테고리 선택 시
                userProductList = service.selectByCategoryAndSub(category, subCategory);
            } else {
                // 메인 카테고리만 선택 시
                userProductList = service.selectByCategory(category);
            }
        } else {
            // 전체 상품 조회
            userProductList = service.selectAll();
        }

        // JSP 전달 데이터 구성
        model.addAttribute("userProductList", userProductList);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("selectedSubCategory", subCategory);
        model.addAttribute("totalCount", userProductList != null ? userProductList.size() : 0);

        return "userproduct/userproductlist";
    }

    // 2. 유저 상품 상세 페이지 (상품 정보 + 옵션 + 이미지 + 리뷰/리뷰사진)
    @GetMapping("/userproductdetail.do")
    public String userproductdetail(@RequestParam("productIdx") int productIdx, Model model) {
        
        // (1) 상품 기본 정보 조회 (관리자 수정용 메서드 재활용)
        ProductVO vo = new ProductVO();
        vo.setProductIdx(productIdx);
        ProductVO product = service.adminProductEdit(vo); 
        model.addAttribute("product", product);

        // (2) 상품 이미지들 (서브 슬라이드 & 상세 설명 이미지)
        model.addAttribute("subImgList", service.adminProductEditImg(productIdx));
        model.addAttribute("descImgList", service.adminProductEditDescImg(productIdx));

        // (3) 상품 옵션 조회 (사이즈, 컬러 등)
        model.addAttribute("optionList", service.selectOptions(productIdx));

        // (4) 리뷰 및 각 리뷰에 딸린 이미지 리스트 조회
        // rservice에 구현한 getReviewListByProduct 메서드 사용
        List<ReviewVO> reviewList = rservice.getReviewListByProduct((long)productIdx);
        
        if (reviewList != null) {
            for (ReviewVO rvo : reviewList) {
                // 각 리뷰 번호(reviewIdx)로 해당 리뷰의 사진들을 가져와 VO에 셋팅
                List<ReviewImageVO> images = rservice.getReviewImages(rvo.getReviewIdx());
                rvo.setReviewImages(images); 
            }
        }
        model.addAttribute("reviewList", reviewList);

        return "userproduct/userproductdetail"; 
    }

    // 3. 상품 검색 기능
    @GetMapping("/search.do")
    public String search(@RequestParam("keyword") String keyword, Model model) {
        List<ProductVO> results = service.searchProducts(keyword);
        model.addAttribute("userProductList", results);
        model.addAttribute("searchKeyword", keyword);
        model.addAttribute("totalCount", results.size());
        
        return "userproduct/userproductlist";
    }
}

