package com.mbcTeam.controller;

import java.io.File;
import java.time.LocalDate;
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
import org.springframework.web.multipart.MultipartFile;

import com.mbcTeam.product.ProductService;
import com.mbcTeam.product.ProductVO;
import com.mbcTeam.product.ProductDescImgVO;
import com.mbcTeam.product.ProductImgVO;
import com.mbcTeam.product.ProductOptionVO;
import com.mbcTeam.product.ProductRequestDTO;

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
	

	// 상품 등록 폼 이동
	@GetMapping("/productAddForm.do")
	public String productAddForm() {
		System.out.println("/productAddForm.DO");
		return "product/productAddForm";
	}

	@Transactional
	@PostMapping("/productAddFormOK.do")
	public String formOK(ProductVO vo, ProductRequestDTO dto) throws Exception {
		System.out.println("/productAddFormOK.DO");		
		
		// 1. 전달받은 값 이외의 값 세팅
		vo.setRegDate(LocalDate.now().toString());
		vo.setDiscountRate(0);
		vo.setRecommended(false);
		

		// 2. 제품 대표 이미지 처리
		MultipartFile mainFile = vo.getProductMainImgfile();
		String mainFileName = mainFile.getOriginalFilename();

		String uploadMainDir = imgPath + "ProductMainImg";

		if (!mainFile.isEmpty()) {
			String fileName = System.currentTimeMillis() + "_" + mainFile.getOriginalFilename();
			String uploadPath = uploadMainDir + File.separator + fileName;

			System.out.println("메인이미지 최종저장경로 및 파일이름: " + uploadPath);
			// mainFile.transferTo(new File(uploadPath));
		}
		// 3. 제품 사이즈 이미지 처리
		MultipartFile sizeFile = vo.getProductSizeImgfile();
		String sizeFileName = sizeFile.getOriginalFilename();
		
		String uploadSizeDir = imgPath + "ProductSizeImg";
		
		if(!sizeFile.isEmpty()) {
			String fileName = System.currentTimeMillis() + "_" + sizeFile.getOriginalFilename();
			String uploadPath = uploadSizeDir + File.separator + fileName;
			
			System.out.println("제품사이즈이미지 최종저장경로 및 파일이름: " + uploadPath);
		}

		// 3. 서비스 호출 (상품 + 이미지 + 옵션 등록)
		// service.insert(vo, imgList, vo.getOptions());

		//List<ProductOptionVO> ovo = dto.getProductOptionList();

//		System.out.println("PRODUCT OPTION VO 값: \n");
//		for (int i = 0; i < ovo.size(); i++) {
//			ProductOptionVO option = ovo.get(i);
//			System.out.println("Option IDX: " + option.getOptionIdx() + "\nColor: " + option.getColor() + "\nSize: "
//					+ option.getSize() + "\nStock: " + option.getStock());
//		}
//
//		System.out.println("PRODUCT Img VO 값: \n");
//		for (int i = 0; i < dto.getProductImgList().size(); i++) {
//
//			MultipartFile imgFile = dto.getProductImgList().get(i);
//			String imgFileName = imgFile.getOriginalFilename();
//
//			System.out.println("ImgFileName: " + imgFileName);
//		}
//
//		System.out.println("PRODUCT Desc Img VO 값: \n");
//		for (int i = 0; i < dto.getProductDescImgList().size(); i++) {
//
//			MultipartFile dimgFile = dto.getProductDescImgList().get(i);
//			String dimgFileName = dimgFile.getOriginalFilename();
//
//			System.out.println("DescImgFileName: " + dimgFileName);
//		}
//
		System.out.println(
				"PRODUCT VO 값: \n" + 
		"Product IDX: " + vo.getProductIdx() + 
		"\nCategory: " + vo.getCategory() + 
		"\nSubCategory: " + vo.getSubCategory() +
		"\nProductName: " + vo.getProductName() +
		"\nPrice: " + vo.getPrice() +
		"\nRegDate: " + vo.getRegDate() +
		"\nProductDesc: " + vo.getProductDesc() + 
		"\nmainFileName: " + mainFileName +
		"\nsizeFileName: " + sizeFileName + 
		"\ndiscountRate: " + vo.getDiscountRate() + //입력받은 값이 없으므로 NULL
		"\nisRecommended: " + vo.isRecommended() //입력받은 값이 없으므로 NULL
				);


		return "redirect:/product/list.do";
	}

	@GetMapping("/list.do")
	public String list(ProductVO vo, Model model) {
		System.out.println("/LIST.DO");
		List<ProductVO> productList = service.select(vo);
		model.addAttribute("li", productList);
		return "product/list";
	}

	@GetMapping("/edit.do")
	public String edit(Model model, ProductVO vo) {
		System.out.println("/EDIT.DO");
		model.addAttribute("product", service.edit(vo));
		return "product/edit";
	}

}
