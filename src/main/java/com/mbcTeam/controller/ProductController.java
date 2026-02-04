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
import com.google.protobuf.Option;
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
		vo.setRegDate(LocalDateTime.now().toString());
		vo.setDiscountRate(0);
		vo.setRecommended(false);

		// 2. 제품 대표 이미지 처리
		MultipartFile mainFile = vo.getProductMainImgfile();
		String mainFileName = mainFile.getOriginalFilename();

		String uploadMainDir = imgPath + "ProductMainImg";

		if (!mainFile.isEmpty()) {
			mainFileName = System.currentTimeMillis() + "_MAIN_" + mainFile.getOriginalFilename();
			String uploadPath = uploadMainDir + File.separator + mainFileName;

			// System.out.println("메인이미지 최종저장경로 및 파일이름: " + uploadPath);
			mainFile.transferTo(new File(uploadPath));
		}
		// 3. 제품 사이즈 이미지 처리
		MultipartFile sizeFile = vo.getProductSizeImgfile();
		String sizeFileName = sizeFile.getOriginalFilename();

		String uploadSizeDir = imgPath + "ProductSizeImg";

		if (!sizeFile.isEmpty()) {
			sizeFileName = System.currentTimeMillis() + "_SIZE_" + sizeFile.getOriginalFilename();
			String uploadPath = uploadSizeDir + File.separator + sizeFileName;

			System.out.println("제품사이즈이미지 최종저장경로 및 파일이름: " + uploadPath);
			sizeFile.transferTo(new File(uploadPath));
		}

		// 3. 서비스 INSERT 작업
		vo.setProductMainImg(mainFileName);
		vo.setProductSizeImg(sizeFileName);
		service.insert(vo);

		// 4. 제품 이미지 처리
		for (int i = 0; i < dto.getProductImgList().size(); i++) {
			ProductImgVO ivo = new ProductImgVO();
			MultipartFile imgFile = dto.getProductImgList().get(i);
			String imgFileName = imgFile.getOriginalFilename();
			String uploadImgDir = imgPath + "ProductImg";

			if (!imgFile.isEmpty()) {
				imgFileName = System.currentTimeMillis() + "_IMG_" + imgFile.getOriginalFilename();
				String uploadPath = uploadImgDir + File.separator + imgFileName;

				imgFile.transferTo(new File(uploadPath));
			}
			ivo.setProductIdx(vo.getProductIdx());
			ivo.setProductImg(imgFileName);
			ivo.setProductImgOrder(i + 1);
			service.insertImg(ivo);
		}

		// 5. 제품 설명 이미지 처리
		for (int i = 0; i < dto.getProductDescImgList().size(); i++) {
			ProductDescImgVO divo = new ProductDescImgVO();
			MultipartFile dimgFile = dto.getProductDescImgList().get(i);
			String dimgFileName = dimgFile.getOriginalFilename();
			String uploadDescImgDir = imgPath + "ProductDescImg";

			if (!dimgFile.isEmpty()) {
				dimgFileName = System.currentTimeMillis() + "_DESCIMG_" + dimgFile.getOriginalFilename();
				String uploadPath = uploadDescImgDir + File.separator + dimgFileName;

				dimgFile.transferTo(new File(uploadPath));
			}
			divo.setProductIdx(vo.getProductIdx());
			divo.setProductDescImg(dimgFileName);
			divo.setProductDescImgOrder(i + 1);
			service.insertDescImg(divo);

		}

		// 6. 제품 옵션 처리
		List<ProductOptionVO> ovo = dto.getProductOptionList();
		for (int i = 0; i < ovo.size(); i++) {
			ProductOptionVO option = ovo.get(i);
			option.setProductIdx(vo.getProductIdx());
			service.insertOption(option);
		}

		return "redirect:/product/list.do";
	}

	@GetMapping("/list.do")
	public String list(ProductVO vo, Model model) {
		System.out.println("/LIST.DO");

		model.addAttribute("li", service.select(vo));
		return "product/list";
	}

	@GetMapping("/adminProductList.do")
	public String ProductList(@RequestParam(value = "search", defaultValue = "code", required = false) String search,
			@RequestParam(value = "keyword", defaultValue = "", required = false) String keyword, ProductVO vo,
			Model model) {
		System.out.println("/adminProductList.DO");
		System.out.println("테스트: " + search);
		System.out.println("테스트: " + keyword);
		vo.setSearch(search);
		vo.setKeyword(keyword);

		int pageSize = 10;
		int pageListSize = 10;

		if (vo.getStartIdx() == 0) {
			vo.setStartIdx(0);
		} else {
			vo.setStartIdx(vo.getStartIdx());
		}

		int totalCount = service.totalCount(vo);

		vo.setPageSize(pageSize);

		int totalPage = (int) Math.ceil((double) totalCount / pageSize);
		int nowPage = (vo.getStartIdx() / pageSize) + 1;
		int lastPage = (totalPage - 1) * pageSize;

		int listStartPage = (nowPage - 1) / pageListSize * pageListSize + 1;

		int listEndPage = listStartPage + pageListSize - 1;
		
		model.addAttribute("startIdx", vo.getStartIdx());
		model.addAttribute("pageSize", vo.getPageSize());

		model.addAttribute("li", service.adminSelect(vo));
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("pageListSize", pageListSize);
		model.addAttribute("listStartPage", listStartPage);
		model.addAttribute("listEndPage", listEndPage);
		
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("nowPage", nowPage);
		
		model.addAttribute("search", vo.getSearch());
		model.addAttribute("keyword", vo.getKeyword());
		
		System.out.println("************************************************");
		System.out.println("startIdx: " + vo.getStartIdx());
		System.out.println("pageSize: " + vo.getPageSize());
		System.out.println("search: " +  vo.getSearch());
		System.out.println("keyword: " + vo.getKeyword());
		
		return "product/productList";
	}
	
	@ResponseBody
	@PostMapping("/adminUpdateStatus.do")
	public String adminUpdateProductStatus(ProductVO vo) throws Exception {
		System.out.println("/adminUpdateStatus.do");
		service.adminUpdateProductStatus(vo);
		return "T"; 
		
	}
	
	@GetMapping(value="/adminProductEdit.do")
	public String adminProductEdit(Model model, ProductVO vo) {
		System.out.println("/adminProductEdit");
		int idx= vo.getProductIdx();
		model.addAttribute("m",service.adminProductEdit(vo));
		model.addAttribute("imgList",service.adminProductEditImg(idx));
		model.addAttribute("descImgList",service.adminProductEditDescImg(idx));
		model.addAttribute("optionList",service.adminProductEditOption(idx));
		return "product/productEdit";
	}

	@GetMapping("/edit.do")
	public String edit(Model model, ProductVO vo) {
		System.out.println("/EDIT.DO");
		model.addAttribute("product", service.edit(vo));
		return "product/edit";
	}

}
