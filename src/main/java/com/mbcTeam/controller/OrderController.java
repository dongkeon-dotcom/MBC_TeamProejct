package com.mbcTeam.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
import com.mbcTeam.shop.DeliveryService;
import com.mbcTeam.shop.DeliveryVO;
import com.mbcTeam.user.UserService;
import com.mbcTeam.user.UserVO;
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
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private DeliveryService dservice;


    // 결제 페이지 이동 (여러 옵션 처리)
    @PostMapping("/payment.do")
    public String paymentPage(@RequestParam int productIdx,
                              @RequestParam List<Integer> optionIdxList,
                              @RequestParam List<Integer> quantityList,
                              Model model) {

        // 로그인 사용자 가져오기
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        UserVO loginUser = userService.getByEmail(auth.getName());

        // ✅ 기본 배송지 가져오기
        DeliveryVO delivery = null;
        List<DeliveryVO> addresses = dservice.getAddressList(loginUser.getUserIdx());
        if (addresses != null && !addresses.isEmpty()) {
            delivery = addresses.stream()
                                .filter(DeliveryVO::isDefaultAddress)
                                .findFirst()
                                .orElse(addresses.get(0)); // 기본 배송지가 없으면 첫 번째 주소 사용
        }
        model.addAttribute("delivery", delivery);

        // 상품 조회
        ProductVO product = productService.detail(productIdx);

        // 주문상품 리스트 생성
        List<OrderItemVO> orderItems = new ArrayList<>();
        int totalAmount = 0;
        for (int i = 0; i < optionIdxList.size(); i++) {
            ProductOptionVO option = optionService.getOptionById(optionIdxList.get(i));
            int quantity = quantityList.get(i);

            int basePrice = product.getPrice();
            int discountedPrice = product.getDiscountRate() > 0
                    ? (int)Math.floor(basePrice * (100 - product.getDiscountRate()) / 100.0)
                    : basePrice;
            int itemTotalPrice = discountedPrice * quantity;

            OrderItemVO item = new OrderItemVO();
            item.setProductIdx(productIdx);
            item.setProductName(product.getProductName());
            item.setColor(option.getColor());
            item.setSize(option.getSize());
            item.setQuantity(quantity);
            item.setPrice(discountedPrice);
            item.setTotalPrice(itemTotalPrice);

            orderItems.add(item);
            totalAmount += itemTotalPrice;
        }

        model.addAttribute("product", product);
        model.addAttribute("orderItems", orderItems);
        model.addAttribute("totalAmount", totalAmount);

        return "order/payment";
    }


    // 결제 완료 처리
    @PostMapping("/complete.do")
    public String completeOrder(@RequestParam int productIdx,
                                @RequestParam List<Integer> optionIdxList,
                                @RequestParam List<Integer> quantityList,
                                @RequestParam String receiver,
                                @RequestParam String deliveryPhone,
                                @RequestParam String address,
                                @RequestParam String extraAddress,
                                @RequestParam String zipcode,
                                Model model) {

        // 로그인 사용자 가져오기
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return "redirect:/user/login.do";
        }
        UserVO loginUser = userService.getByEmail(auth.getName());

        ProductVO product = productService.detail(productIdx);

        // 주문 객체 생성
        OrderVO order = new OrderVO();
        order.setUserIdx(loginUser.getUserIdx());
        order.setReceiver(receiver);
        order.setDeliveryPhone(deliveryPhone);
        order.setAddress(address);
        order.setExtraAddress(extraAddress);
        order.setZipcode(zipcode);

        List<OrderItemVO> items = new ArrayList<>();
        int totalAmount = 0;

        for (int i = 0; i < optionIdxList.size(); i++) {
            ProductOptionVO option = optionService.getOptionById(optionIdxList.get(i));
            int quantity = quantityList.get(i);

            int basePrice = product.getPrice();
            int discountedPrice = product.getDiscountRate() > 0
                    ? (int)Math.floor(basePrice * (100 - product.getDiscountRate()) / 100.0)
                    : basePrice;

            int itemTotal = discountedPrice * quantity;
            totalAmount += itemTotal;

            OrderItemVO item = new OrderItemVO();
            item.setOrderIdx(order.getOrderIdx()); // FK 연결
            item.setProductIdx(productIdx);
            item.setProductName(product.getProductName());
            item.setCategory(product.getCategory());
            item.setSubCategory(product.getSubCategory());
            item.setColor(option.getColor());
            item.setSize(option.getSize());
            item.setQuantity(quantity);
            item.setPrice(basePrice);
            item.setDiscountRate(product.getDiscountRate());
            item.setProductMainImg(product.getProductMainImg());

            items.add(item);
        }

        order.setTotalPrice(totalAmount); // ✅ 전체 합계 저장

        // 주문 + 주문상세 저장
        orderService.insertOrder(order, items);

        // JSP에 전달할 데이터
        model.addAttribute("product", product);
        model.addAttribute("order", order);
        model.addAttribute("items", items);
        model.addAttribute("message", "결제가 완료되었습니다!");

        return "order/complete";
    }


}

