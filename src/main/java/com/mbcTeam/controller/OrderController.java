package com.mbcTeam.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mbcTeam.order.OrderService;
import com.mbcTeam.order.OrderVO;
import com.mbcTeam.order.OrderItemVO;
import com.mbcTeam.product.ProductService;
import com.mbcTeam.product.ProductVO;
import com.mbcTeam.product.ProductOptionVO;
import com.mbcTeam.product.ProductOptionService;

@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private ProductService productService;

    @Autowired
    private ProductOptionService optionService;

    @Autowired
    private OrderService orderService;

    // 결제 페이지 이동
    @PostMapping("/payment.do")
    public String paymentPage(@RequestParam int productIdx,
                              @RequestParam int optionIdx,
                              @RequestParam int quantity,
                              Model model) {
        // 상품 조회
        ProductVO product = productService.detail(productIdx);
        	
        // 옵션 조회
        ProductOptionVO option = optionService.getOptionById(optionIdx);
        model.addAttribute("selectedOption", option);

     
        // 총 결제 금액 계산
        int totalPrice = product.getPrice() * quantity;

        // JSP에 전달할 데이터 세팅
        model.addAttribute("product", product);
        model.addAttribute("selectedOption", option);
        model.addAttribute("quantity", quantity);
        model.addAttribute("totalPrice", totalPrice);

        return "order/payment"; // 결제 JSP
    }

    // 결제 완료 처리
    @PostMapping("/complete.do")
    public String completeOrder(@RequestParam int productIdx,
                                @RequestParam int optionIdx,
                                @RequestParam int quantity,
                                @RequestParam int totalPrice,
                                @RequestParam String recevier,
                                @RequestParam String deliveryPhone,
                                @RequestParam String address,
                                @RequestParam String extraAddress,
                                @RequestParam String zipcode,
                                Model model) {

        // 상품 조회
        ProductVO product = productService.detail(productIdx);

        // 옵션 조회
        ProductOptionVO option = optionService.getOptionById(optionIdx);
        
        

        // 주문 객체 생성
        OrderVO order = new OrderVO();
        order.setUserIdx(1L); // 로그인 사용자 ID (임시)
        order.setTotalPrice(totalPrice);
        order.setRecevier("홍길동");
        order.setDeliveryPhone("010-1234-5678");
        order.setAddress("서울시 강남구");
        order.setExtraAddress("101호");
        order.setZipcode("12345");

        // 주문 상세 객체 생성
        OrderItemVO item = new OrderItemVO();
        item.setProductIdx(productIdx);
        item.setQuantity(quantity);
        item.setPrice(product.getPrice()); // 단가 저장
        item.setProductName(product.getProductName());
        item.setColor(option.getColor());
        item.setSize(option.getSize());
        item.setProductMainImg(product.getProductMainImg());
        item.setCategory(product.getCategory());
        item.setSubCategory(product.getSubCategory());
        item.setDiscountRate(product.getDiscountRate());
        
        String mainImg = product.getProductMainImg();
        if (mainImg == null || mainImg.isEmpty()) {
            mainImg = "/images/default.png"; // 기본 이미지 경로
        }
        item.setProductMainImg(mainImg);


        
        // 주문 + 주문상세 함께 저장
        orderService.insertOrder(order, item);

        // JSP에 전달할 데이터 세팅
        model.addAttribute("product", product);
        model.addAttribute("selectedOption", option);
        model.addAttribute("quantity", quantity);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("order", order);
        model.addAttribute("item", item);

        model.addAttribute("message", "결제가 완료되었습니다!");
        
        return "order/complete";       // 결제 완료 JSP
        
    }

}
