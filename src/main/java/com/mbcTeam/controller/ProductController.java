package com.mbcTeam.controller;

import java.io.File;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.mbcTeam.product.ProductService;
import com.mbcTeam.product.ProductVO;
import com.mbcTeam.dto.ProductRequestDTO;
import com.mbcTeam.product.ProductDescImgVO;
import com.mbcTeam.product.ProductImgVO;
import com.mbcTeam.product.ProductOptionVO;

@RequestMapping("/product")
@Controller
public class ProductController {

	@Autowired
	private ProductService service;

	@Autowired
	private ServletContext servletContext; // 프로젝트 내부 경로 접근용

	String imgPath = "";

	@PostConstruct
	public void init() {
		imgPath = servletContext.getRealPath("/resources/images/");
	}


	@GetMapping("/list.do")
	public String list(ProductVO vo, Model model) {
		System.out.println("/LIST.DO");

		model.addAttribute("li", service.select(vo));
		return "product/list";
	}


	@GetMapping("/edit.do")
	public String edit(Model model, ProductVO vo) {
		System.out.println("/EDIT.DO");
		model.addAttribute("product", service.edit(vo));
		return "product/edit";
	}
	
	
	@GetMapping("/category.do")
	public String categoryList(@RequestParam("category") String category, Model model) {
	    //List<ProductVO> productList = service.getProductsByCategory(category);
	    //model.addAttribute("productList", productList);
	    //model.addAttribute("category", category);
	    return "product/productList"; // 카테고리별 상품 목록 JSP
	}



}
