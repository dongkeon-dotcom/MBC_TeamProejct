package com.mbcTeam.controller;

import java.io.File;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.mbcTeam.product.ProductService;
import com.mbcTeam.product.ProductVO;
import com.mbcTeam.product.ProductImgVO;

@RequestMapping("/product")
@Controller
public class ProductController {

	@Autowired
	private ProductService service;

	@Autowired
	private ServletContext servletContext; // 프로젝트 내부 경로 접근용

	// 상품 등록 폼 이동
	@GetMapping("/form.do")
	public String form() {
		return "product/form"; // /WEB-INF/view/product/form.jsp
	}

	@PostMapping("/formOK.do")
	public String formOK(ProductVO vo, @RequestParam("files") List<MultipartFile> files) throws Exception {

		// 1. 등록일 세팅 (insert 전에!)
		vo.setProductRegDate(LocalDate.now().toString());

		// 2. 이미지 처리
		List<ProductImgVO> imgList = new ArrayList<ProductImgVO>();
		int order = 1;
		String uploadDir = servletContext.getRealPath("/resources/images");

		for (MultipartFile file : files) {
			if (!file.isEmpty()) {
				String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
				String uploadPath = uploadDir + File.separator + fileName;

				file.transferTo(new File(uploadPath));

				String dbPath = "/resources/images/" + fileName;

				ProductImgVO imgVO = new ProductImgVO();
				imgVO.setPImgPath(dbPath);
				imgVO.setPImgOrder(String.valueOf(order++));
				imgList.add(imgVO);

			}
		}

		// 3. 서비스 호출 (상품 + 이미지 + 옵션 등록)
		service.insert(vo, imgList, vo.getOptions());

		return "redirect:/product/list.do";
	}

	// 상품 목록
	@GetMapping("/list.do")
	public String list(ProductVO vo, Model model) {
		List<ProductVO> productList = service.select(vo);
		model.addAttribute("li", productList);
		return "product/list"; // /WEB-INF/view/product/list.jsp
	}

	// 유저 상품 리스트
	@GetMapping("/userproduclist.do")
	public String userproduclist(ProductVO vo, Model model) {
		List<ProductVO> productList = service.select(vo);
		model.addAttribute("li", productList);
		return "userproduc/userproduclist"; // /WEB-INF/view/product/list.jsp
	}

	// 상품 수정 폼
	@GetMapping("/edit.do")
	public String edit(Model model, ProductVO vo) {
		model.addAttribute("product", service.edit(vo));
		return "product/edit";
	}
	
	
	

}
