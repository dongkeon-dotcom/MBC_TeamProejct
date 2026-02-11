package com.mbcTeam.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mbcTeam.admin.AdminService;
import com.mbcTeam.admin.GeminiService;
import com.mbcTeam.dto.OrderManagementDTO;
import com.mbcTeam.dto.UserManagementDTO;
import com.mbcTeam.order.OrderItemVO;

@RequestMapping("/admin")
@Controller
public class AdminController {
	
	@Autowired
	private AdminService service;
	
	@Autowired
	private GeminiService geminiService;
	
    @ResponseBody
    @RequestMapping(value = "/geminiAjax.do", 
            method = RequestMethod.GET, 
            produces = "text/plain;charset=UTF-8")
    public String GeminiAjax(@RequestParam String name, @RequestParam String feature) {
		System.out.println("GeminiAjax.DO");
        return geminiService.getAiDescription(name, feature);
    }
	
	@GetMapping("/salesChart.do")
	public String SalesChart(Model model,
			@RequestParam(defaultValue = "2025") String year,
			@RequestParam(defaultValue = "01") String month){
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
			@RequestParam(value = "keyword", defaultValue = "", required = false) String keyword,
			Model model, UserManagementDTO dto) {
		
		dto.setSearch(search);
		dto.setKeyword(keyword);
		int pageSize=20;
		int pageListSize=10;
		
		if (dto.getStartIdx() == 0) {
			dto.setStartIdx(0);
		} else {
			dto.setStartIdx(dto.getStartIdx());
		}
		
		int totalCount = service.getUserTotalCount(dto);
		
		dto.setPageSize(pageSize);
		
		int totalPage = (totalCount <=0) ? 1 : (int) Math.ceil((double) totalCount / pageSize);
		int nowPage = (dto.getStartIdx() / pageSize) + 1;
		int lastPage = Math.max(0, (totalPage - 1) * pageSize);

		int listStartPage = (nowPage - 1) / pageListSize * pageListSize + 1;

		int listEndPage = listStartPage + pageListSize - 1;
		
		if(listEndPage > totalPage) {
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
	public List<OrderItemVO> UserDetailOrderItemsAjax(int orderIdx){
		System.out.println("/userDetailOrderItemsAjax.do");
		
		List<OrderItemVO> list = service.getUserDetailOrderItems(orderIdx);
		return list;
	}
	
	@GetMapping("/orderManagement.do")
	public String OrderManagement(
			@RequestParam(value = "search", defaultValue = "orderId", required = false) String search,
			@RequestParam(value = "keyword", defaultValue = "", required = false) String keyword,
			@RequestParam(value="startDate", defaultValue = "", required=false) String startDate,
            @RequestParam(value="endDate", defaultValue = "", required=false) String endDate,
			Model model, OrderManagementDTO dto){

		
		dto.setSearch(search);
		dto.setKeyword(keyword);
		int pageSize=10;
		int pageListSize=10;
		
		if (dto.getStartIdx() == 0) {
			dto.setStartIdx(0);
		} else {
			dto.setStartIdx(dto.getStartIdx());
		}
		
		int totalCount = service.getOrderTotalCount(dto);
		
		dto.setPageSize(pageSize);
		
		int totalPage = (totalCount <=0) ? 1 : (int) Math.ceil((double) totalCount / pageSize);
		int nowPage = (dto.getStartIdx() / pageSize) + 1;
		int lastPage = Math.max(0, (totalPage - 1) * pageSize);

		int listStartPage = (nowPage - 1) / pageListSize * pageListSize + 1;

		int listEndPage = listStartPage + pageListSize - 1;
		
		if(listEndPage > totalPage) {
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
