package com.mbcTeam.controller;

import java.io.File;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mbcTeam.admin.AdminService;
import com.mbcTeam.admin.GeminiService;
import com.mbcTeam.dto.OrderManagementDTO;
import com.mbcTeam.dto.ProductRequestDTO;
import com.mbcTeam.dto.UserManagementDTO;
import com.mbcTeam.order.OrderItemVO;
import com.mbcTeam.order.OrderService;
import com.mbcTeam.product.ProductDescImgVO;
import com.mbcTeam.product.ProductImgVO;
import com.mbcTeam.product.ProductOptionVO;
import com.mbcTeam.product.ProductService;
import com.mbcTeam.product.ProductVO;

@RequestMapping("/admin")
@Controller
public class AdminController {

	@Autowired
	private AdminService service;

	@Autowired
	private ProductService productService;
	
	@Autowired
	private OrderService orderService;
	
	@Autowired
	private GeminiService geminiService;
	
	
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
		return "admin/productAddForm";
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
		productService.insert(vo);

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
			productService.insertImg(ivo);
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
			productService.insertDescImg(divo);

		}

		// 6. 제품 옵션 처리
		List<ProductOptionVO> ovo = dto.getProductOptionList();
		for (int i = 0; i < ovo.size(); i++) {
			ProductOptionVO option = ovo.get(i);
			option.setProductIdx(vo.getProductIdx());
			productService.insertOption(option);
		}

		return "redirect:/admin/adminProductList.do";
	}
	
	@GetMapping("/adminProductList.do")
	public String ProductList(
			@RequestParam(value = "search", defaultValue = "code", required = false) String search,
			@RequestParam(value = "keyword", defaultValue = "", required = false) String keyword,
			@RequestParam(value = "recommendedFilter", defaultValue="all", required = false ) String recommendedFilter,
			@RequestParam(value = "discountFilter", defaultValue="all", required = false) String discountFilter,			
			ProductVO vo,
			Model model) {
		System.out.println("/adminProductList.DO");
		//System.out.println("테스트: " + search);
		//System.out.println("테스트: " + keyword);
		vo.setSearch(search);
		vo.setKeyword(keyword);
		vo.setRecommendedFilter(recommendedFilter);
		vo.setDiscountFilter(discountFilter);

		int pageSize = 10;
		int pageListSize = 10;

		if (vo.getStartIdx() == 0) {
			vo.setStartIdx(0);
		} else {
			vo.setStartIdx(vo.getStartIdx());
		}

		int totalCount = productService.totalCount(vo);

		vo.setPageSize(pageSize);

		int totalPage = (int) Math.ceil((double) totalCount / pageSize);
		int nowPage = (vo.getStartIdx() / pageSize) + 1;
		int lastPage = (totalPage - 1) * pageSize;

		int listStartPage = (nowPage - 1) / pageListSize * pageListSize + 1;

		int listEndPage = listStartPage + pageListSize - 1;

		model.addAttribute("startIdx", vo.getStartIdx());
		model.addAttribute("pageSize", vo.getPageSize());

		model.addAttribute("li", productService.adminSelect(vo));
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("pageListSize", pageListSize);
		model.addAttribute("listStartPage", listStartPage);
		model.addAttribute("listEndPage", listEndPage);

		model.addAttribute("totalPage", totalPage);
		model.addAttribute("nowPage", nowPage);

		model.addAttribute("search", vo.getSearch());
		model.addAttribute("keyword", vo.getKeyword());
		model.addAttribute("recommendedFilter", vo.getRecommendedFilter());
		model.addAttribute("discountFilter", vo.getDiscountFilter());
		

//		System.out.println("************************************************");
//		System.out.println("startIdx: " + vo.getStartIdx());
//		System.out.println("pageSize: " + vo.getPageSize());
//		System.out.println("search: " + vo.getSearch());
//		System.out.println("keyword: " + vo.getKeyword());

		return "admin/productList";
	}


	@GetMapping(value = "/adminProductEdit.do")
	public String adminProductEdit(Model model, ProductVO vo) {
		System.out.println("/adminProductEdit");
		int idx = vo.getProductIdx();
		model.addAttribute("m", productService.adminProductEdit(vo));
		model.addAttribute("imgList", productService.adminProductEditImg(idx));
		model.addAttribute("descImgList", productService.adminProductEditDescImg(idx));
		model.addAttribute("optionList", productService.adminProductEditOption(idx));

		return "admin/productEdit";
	}
	
	@Transactional
	@PostMapping(value = "/adminProductEditOK.do")
	public String adminProductEditOK(Model model, ProductVO vo, ProductRequestDTO dto) throws Exception {
		System.out.println("adminProductEditOK");
		ProductVO oldData = productService.adminProductEdit(vo);
		int productIdx = vo.getProductIdx();

		// 제품 메인 이미지 처리
		MultipartFile mainFile = vo.getProductMainImgfile();
		String mainFileName = oldData.getProductMainImg();
		if (mainFile != null && !mainFile.isEmpty()) {
			String uploadMainDir = imgPath + "ProductMainImg";
			File oldFile = new File(uploadMainDir + File.separator + oldData.getProductMainImg());
			if (oldFile.exists()) {
				oldFile.delete();
			}

			mainFileName = System.currentTimeMillis() + "_MAIN_" + mainFile.getOriginalFilename();
			String uploadPath = uploadMainDir + File.separator + mainFileName;
			mainFile.transferTo(new File(uploadPath));
		}

		// 제품 사이즈 이미지 처리
		MultipartFile sizeFile = vo.getProductSizeImgfile();
		String sizeFileName = oldData.getProductSizeImg();

		if (sizeFile != null && !sizeFile.isEmpty()) {
			String uploadSizeDir = imgPath + "ProductSizeImg";
			File oldFile = new File(uploadSizeDir + File.separator + oldData.getProductSizeImg());
			if (oldFile.exists()) {
				oldFile.delete();
			}
			sizeFileName = System.currentTimeMillis() + "_SIZE_" + sizeFile.getOriginalFilename();
			String uploadPath = uploadSizeDir + File.separator + sizeFileName;
			sizeFile.transferTo(new File(uploadPath));

		}
		// 서비스 INSERT 작업
		vo.setProductMainImg(mainFileName);
		vo.setProductSizeImg(sizeFileName);
		productService.update(vo);

		//이미지 제거, Order 재정렬, 등록
		if (dto.getDeleteImgIdx() != null) {
			for (Integer imgIdx : dto.getDeleteImgIdx()) {
				ProductImgVO oldImg = productService.adminOneImg(imgIdx);
				String imgDir = imgPath + "ProductImg";
				File file = new File(imgDir + File.separator + oldImg.getProductImg());
				if (file.exists()) {
					file.delete();
				}
				productService.deleteImg(imgIdx);
			}
		}

		int imgCount = productService.imgCount(productIdx);
		for (int i = 0; i < imgCount; i++) {
			ProductImgVO orderUpdateIVO = new ProductImgVO();
			orderUpdateIVO.setProductImgOrder(i+1);
			orderUpdateIVO.setProductImgIdx(dto.getExistingImgIdx().get(i));
			
			productService.updateImgOrder(orderUpdateIVO);
		}
		
		
		if (dto.getProductImgList() != null) {
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
				ivo.setProductIdx(productIdx);
				ivo.setProductImg(imgFileName);
				ivo.setProductImgOrder(i + 1 + imgCount);
				productService.insertImg(ivo);
			}
		}

		if (dto.getDeleteDescImgIdx() != null) {
			for (Integer descImgIdx : dto.getDeleteDescImgIdx()) {
				ProductDescImgVO oldDescImg = productService.adminOneDescImg(descImgIdx);
				String descImgDir = imgPath + "ProductDescImg";
				File file = new File(descImgDir + File.separator + oldDescImg.getProductDescImg());
				if (file.exists()) {
					file.delete();
				}
				productService.deleteDescImg(descImgIdx);
			}
		}
		int descImgCount = productService.descImgCount(productIdx);
		for (int i = 0; i < descImgCount; i++) {
			ProductDescImgVO orderUpdateDIVO = new ProductDescImgVO();
			orderUpdateDIVO.setProductDescImgOrder(i+1);
			orderUpdateDIVO.setProductDescImgIdx(dto.getExistingDescImgIdx().get(i));
			
			productService.updateDescImgOrder(orderUpdateDIVO);
		}

		if (dto.getProductDescImgList() != null) {
			for (int i = 0; i < dto.getProductDescImgList().size(); i++) {
				ProductDescImgVO divo = new ProductDescImgVO();
				MultipartFile descImgFile = dto.getProductDescImgList().get(i);
				String descImgFileName = descImgFile.getOriginalFilename();
				String uploadDescImgDir = imgPath + "ProductDescImg";

				if (!descImgFile.isEmpty()) {
					descImgFileName = System.currentTimeMillis() + "_DESCIMG_" + descImgFile.getOriginalFilename();
					String uploadPath = uploadDescImgDir + File.separator + descImgFileName;

					descImgFile.transferTo(new File(uploadPath));
				}
				divo.setProductIdx(productIdx);
				divo.setProductDescImg(descImgFileName);
				divo.setProductDescImgOrder(i + 1 + descImgCount);
				productService.insertDescImg(divo);
			}
		}
		
		//옵션처리
		if (dto.getDeleteOptionIdx() != null) {
			for (Integer optionIdx : dto.getDeleteOptionIdx()) {
				productService.deleteOption(optionIdx);
			}
		}
		
		if(dto.getProductOptionList() != null) {
			for(ProductOptionVO ovo: dto.getProductOptionList()) {
				if(ovo.getOptionIdx() == 0) {
					//OptionIdx가 없으면 신규(insert)
					ovo.setProductIdx(productIdx);
					productService.insertOption(ovo);
				}else {
					//OptionIdx가 있으면 기존꺼(update)
					productService.updateOption(ovo);
				}
			}
		}		

		return "redirect:/admin/adminProductList.do";
	}
	
	@ResponseBody
	@PostMapping("/adminUpdateStatus.do")
	public String adminUpdateProductStatus(ProductVO vo) throws Exception {
		System.out.println("/adminUpdateStatus.do");
		productService.adminUpdateProductStatus(vo);
		return "T";

	}
	
	@ResponseBody
	@PostMapping("updateOrderStatus.do")
	public String updateOrderStatus(OrderManagementDTO dto) throws Exception{
		System.out.println("******************************************");
		System.out.println("DTO: "+ dto);
		
		service.adminUpdateOrderStatus(dto);
		
		return "success";
	}

	@ResponseBody
	@RequestMapping(value = "/geminiAjax.do", method = RequestMethod.GET, produces = "text/plain;charset=UTF-8")
	public String GeminiAjax(@RequestParam String name, @RequestParam String feature) {
		System.out.println("GeminiAjax.DO");
		return geminiService.getAiDescription(name, feature);
	}

	@GetMapping("/salesChart.do")
	public String SalesChart(Model model, @RequestParam(defaultValue = "2025") String year,
			@RequestParam(defaultValue = "01") String month) {
		System.out.println("/salesChart.do");
		Map<String, Object> params = new HashMap<>();
		params.put("year", year);
		params.put("month", month);
		model.addAttribute("monthlyData", service.getMonthlySales(year));
		model.addAttribute("categoryData", service.getCategorySales(params));

		model.addAttribute("selectedYear", year);
		model.addAttribute("selectedMonth", month);

		return "admin/salesChart";
	}

	@ResponseBody
	@GetMapping("/salesChartAjax.do")
	public Map<String, Object> SalesChartAjax(String year, String month) throws Exception {
		System.out.println("SalesChartAjax.do");
		// 1. 결과 데이터를 담을 Map 생성
		Map<String, Object> resultMap = new HashMap<>();

		// 2. 쿼리용 파라미터 Map 생성
		Map<String, Object> params = new HashMap<>();
		params.put("year", year);
		params.put("month", month);

		// 3. 실제 데이터를 resultMap에 담기
		resultMap.put("monthlyData", service.getMonthlySales(year));
		resultMap.put("categoryData", service.getCategorySales(params));

		// 4. 리턴된 resultMap은 Jackson 라이브러리에 의해 JSON으로 변환되어 JS로 전달됩니다.
		return resultMap;
	}

	@GetMapping("/userManagement.do")
	public String UserManagement(@RequestParam(value = "search", defaultValue = "code", required = false) String search,
			@RequestParam(value = "keyword", defaultValue = "", required = false) String keyword, Model model,
			UserManagementDTO dto) {

		dto.setSearch(search);
		dto.setKeyword(keyword);
		int pageSize = 20;
		int pageListSize = 10;

		if (dto.getStartIdx() == 0) {
			dto.setStartIdx(0);
		} else {
			dto.setStartIdx(dto.getStartIdx());
		}

		int totalCount = service.getUserTotalCount(dto);

		dto.setPageSize(pageSize);

		int totalPage = (totalCount <= 0) ? 1 : (int) Math.ceil((double) totalCount / pageSize);
		int nowPage = (dto.getStartIdx() / pageSize) + 1;
		int lastPage = Math.max(0, (totalPage - 1) * pageSize);

		int listStartPage = (nowPage - 1) / pageListSize * pageListSize + 1;

		int listEndPage = listStartPage + pageListSize - 1;

		if (listEndPage > totalPage) {
			listEndPage = totalPage;
		}

		model.addAttribute("startIdx", dto.getStartIdx());
		model.addAttribute("pageSize", dto.getPageSize());

		model.addAttribute("li", service.getUserManagement(dto));

		model.addAttribute("totalCount", totalCount);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("pageListSize", pageListSize);
		model.addAttribute("listStartPage", listStartPage);
		model.addAttribute("listEndPage", listEndPage);

		model.addAttribute("totalPage", totalPage);
		model.addAttribute("nowPage", nowPage);

		model.addAttribute("search", dto.getSearch());
		model.addAttribute("keyword", dto.getKeyword());

		return "admin/userManagement";
	}

	@GetMapping("/userPurchaseDetail.do")
	public String UserPurchaseDetail(Model model, int userIdx) {
		System.out.println("/userPurchaseDetail.do");

		model.addAttribute("userInfo", service.getUserInfo(userIdx));
		model.addAttribute("orderInfo", service.getUserOrderList(userIdx));

		return "admin/userPurchaseDetail";
	}

	@ResponseBody
	@GetMapping("/userDetailOrderItemsAjax.do")
	public List<OrderItemVO> UserDetailOrderItemsAjax(int orderIdx) {
		System.out.println("/userDetailOrderItemsAjax.do");

		List<OrderItemVO> list = service.getUserDetailOrderItems(orderIdx);
		return list;
	}

	@GetMapping("/orderManagement.do")
	public String OrderManagement(
			@RequestParam(value = "search", defaultValue = "orderId", required = false) String search,
			@RequestParam(value = "keyword", defaultValue = "", required = false) String keyword,
			@RequestParam(value = "startDate", defaultValue = "", required = false) String startDate,
			@RequestParam(value = "endDate", defaultValue = "", required = false) String endDate,
			Model model, OrderManagementDTO dto) {

		System.out.println("**********************************************");
		System.out.println("Search: " + search);
		System.out.println("Keyword: " + keyword);
		System.out.println("StartDate: " + startDate);
		System.out.println("EndDate: " + endDate);

		dto.setSearch(search);
		dto.setKeyword(keyword);
		dto.setStartDate(startDate);
		dto.setEndDate(endDate);
		
		int pageSize = 10;
		int pageListSize = 10;

		if (dto.getStartIdx() == 0) {
			dto.setStartIdx(0);
		} else {
			dto.setStartIdx(dto.getStartIdx());
		}

		int totalCount = service.getOrderTotalCount(dto);

		dto.setPageSize(pageSize);

		int totalPage = (totalCount <= 0) ? 1 : (int) Math.ceil((double) totalCount / pageSize);
		int nowPage = (dto.getStartIdx() / pageSize) + 1;
		int lastPage = Math.max(0, (totalPage - 1) * pageSize);

		int listStartPage = (nowPage - 1) / pageListSize * pageListSize + 1;

		int listEndPage = listStartPage + pageListSize - 1;

		if (listEndPage > totalPage) {
			listEndPage = totalPage;
		}

		model.addAttribute("startIdx", dto.getStartIdx());
		model.addAttribute("pageSize", dto.getPageSize());

		model.addAttribute("orderList", service.getOrderManagement(dto));

		model.addAttribute("totalCount", totalCount);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("pageListSize", pageListSize);
		model.addAttribute("listStartPage", listStartPage);
		model.addAttribute("listEndPage", listEndPage);

		model.addAttribute("totalPage", totalPage);
		model.addAttribute("nowPage", nowPage);

		model.addAttribute("search", dto.getSearch());
		model.addAttribute("keyword", dto.getKeyword());

		return "admin/orderManagement";
	}

}
