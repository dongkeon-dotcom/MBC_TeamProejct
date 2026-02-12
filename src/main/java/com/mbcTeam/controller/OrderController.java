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
import com.mbcTeam.cart.CartService;
import com.mbcTeam.cart.CartVO;
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
    
    @Autowired
    private CartService cartService;
    

    // 결제 페이지 이동 (여러 옵션 처리)
 // 결제 페이지 이동 (여러 옵션 처리)
    @PostMapping("/payment.do")
    public String paymentPage(
            @RequestParam(required = false) Integer productIdx, 
            @RequestParam(required = false) List<Integer> optionIdxList, 
            @RequestParam(required = false) List<Integer> quantityList, 
            @RequestParam(required = false, value = "cartIdxList") List<Long> cartIdxList, 
            Model model) {

        // 1. 로그인 사용자 확인 (Spring Security 활용)
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return "redirect:/user/login.do";
        }
        
        // DB에서 최신 유저 정보(이메일 포함)를 가져와 모델에 추가
        UserVO loginUser = userService.getByEmail(auth.getName());
        model.addAttribute("loginUser", loginUser);

        // 2. 배송지 정보 가져오기 (기본 배송지 우선순위)
        DeliveryVO delivery = null;
        List<DeliveryVO> addresses = dservice.getAddressList(loginUser.getUserIdx());
        if (addresses != null && !addresses.isEmpty()) {
            delivery = addresses.stream()
                                .filter(DeliveryVO::isDefaultAddress)
                                .findFirst()
                                .orElse(addresses.get(0));
        }
        model.addAttribute("delivery", delivery);

        List<OrderItemVO> orderItems = new ArrayList<>();
        int totalAmount = 0;

        // --- Case A: 장바구니에서 선택 구매로 넘어온 경우 ---
        if (cartIdxList != null && !cartIdxList.isEmpty()) {
            for (Long cartIdx : cartIdxList) {
                CartVO cart = cartService.getCartItem(cartIdx); 
                
                if (cart != null) {
                    OrderItemVO item = new OrderItemVO();
                    item.setProductIdx((int)cart.getProductIdx());
                    item.setProductName(cart.getProductName());
                    item.setOptionIdx((int)cart.getOptionIdx());
                    item.setColor(cart.getColor());
                    item.setSize(cart.getSize());
                    item.setQuantity(cart.getQuantity());
                    item.setPrice(cart.getPrice()); // 이미 할인 적용된 개별 단가
                    item.setTotalPrice(cart.getPrice() * cart.getQuantity());

                    orderItems.add(item);
                    totalAmount += item.getTotalPrice();
                }
            }
        } 
        // --- Case B: 상세페이지에서 '바로 구매하기'로 넘어온 경우 ---
        else if (productIdx != null && optionIdxList != null) {
            ProductVO product = productService.detail(productIdx);
            
            for (int i = 0; i < optionIdxList.size(); i++) {
                ProductOptionVO option = optionService.getOptionById(optionIdxList.get(i));
                int quantity = quantityList.get(i);

                // 가격 계산 (할인율 적용)
                int basePrice = product.getPrice();
                int discountedPrice = product.getDiscountRate() > 0
                        ? (int)Math.floor(basePrice * (100 - product.getDiscountRate()) / 100.0)
                        : basePrice;
                int itemTotalPrice = discountedPrice * quantity;

                OrderItemVO item = new OrderItemVO();
                item.setProductIdx(productIdx);
                item.setProductName(product.getProductName());
                item.setOptionIdx(option.getOptionIdx());
                item.setColor(option.getColor());
                item.setSize(option.getSize());
                item.setQuantity(quantity);
                item.setPrice(discountedPrice);
                item.setTotalPrice(itemTotalPrice);

                orderItems.add(item);
                totalAmount += itemTotalPrice;
            }
            model.addAttribute("product", product); 
        }

        // 3. 뷰 데이터 전달
        model.addAttribute("orderItems", orderItems);
        model.addAttribute("totalAmount", totalAmount);

        return "order/payment";
    }

    // 결제 완료 처리
    @RequestMapping("/complete.do")
    public String completeOrder(
            @RequestParam(value="productIdx") List<Integer> productIdxList, 
            @RequestParam(value="optionIdxList") List<Integer> optionIdxList,
            @RequestParam(value="quantityList") List<Integer> quantityList,
            @RequestParam(value="receiver") String receiver,
            @RequestParam(value="deliveryPhone") String deliveryPhone,
            @RequestParam(value="address") String address,
            @RequestParam(value="extraAddress") String extraAddress,
            @RequestParam(value="zipcode") String zipcode,
            Model model) {

        // 1. 사용자 인증 확인
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return "redirect:/user/login.do";
        }
        UserVO loginUser = userService.getByEmail(auth.getName());

        // 2. 주문(Orders) 객체 생성
        OrderVO order = new OrderVO();
        order.setUserIdx(loginUser.getUserIdx());
        order.setReceiver(receiver);
        order.setDeliveryPhone(deliveryPhone);
        order.setAddress(address);
        order.setExtraAddress(extraAddress);
        order.setZipcode(zipcode);
        order.setStatus(0); // 주문 상태 (0: 결제완료)

        List<OrderItemVO> items = new ArrayList<>();
        int totalAmount = 0;

        // 3. 리스트 데이터 처리
        for (int i = 0; i < optionIdxList.size(); i++) {
            // 인덱스 안전 장치
            int pIdx = (productIdxList.size() > i) ? productIdxList.get(i) : productIdxList.get(0);
            int oIdx = optionIdxList.get(i);
            int qty = quantityList.get(i);

            ProductVO product = productService.detail(pIdx);
            ProductOptionVO option = optionService.getOptionById(oIdx);

            int discountedPrice = product.getDiscountRate() > 0
                    ? (int)Math.floor(product.getPrice() * (100 - product.getDiscountRate()) / 100.0)
                    : product.getPrice();
            
            totalAmount += (discountedPrice * qty);

            OrderItemVO item = new OrderItemVO();
            item.setProductIdx(pIdx);
            item.setProductName(product.getProductName());
            item.setCategory(product.getCategory());
            item.setSubCategory(product.getSubCategory());
            item.setColor(option.getColor());
            item.setSize(option.getSize());
            item.setQuantity(qty);
            item.setPrice(discountedPrice);
            item.setDiscountRate(product.getDiscountRate());
            item.setOptionIdx(oIdx);
            item.setStatus(0); // 상세 항목 상태값 추가

            // 이미지 NULL 방지
            String mainImg = product.getProductMainImg();
            item.setProductMainImg((mainImg == null || mainImg.isEmpty()) ? "no_image.jpg" : mainImg);
            
            items.add(item);
        }

        order.setTotalPrice(totalAmount);

        // 4. DB 저장 및 장바구니 비우기
        try {
            orderService.insertOrder(order, items);
            cartService.clearCart(loginUser.getUserIdx()); 
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/order/payment.do?error=db";
        }

        // 5. 결과 전달
        model.addAttribute("order", order);
        model.addAttribute("items", items);
        
        return "order/complete";
    }
}
