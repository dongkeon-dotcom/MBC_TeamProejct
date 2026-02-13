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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    /**
     * 1. 결제 페이지 이동 (장바구니 선택 구매 또는 상세페이지 바로구매)
     */
    @PostMapping("/payment.do")
    public String paymentPage(
            @RequestParam(required = false) Integer productIdx, 
            @RequestParam(required = false) List<Integer> optionIdxList, 
            @RequestParam(required = false) List<Integer> quantityList, 
            @RequestParam(required = false, value = "cartIdxList") List<Long> cartIdxList, 
            Model model) {

        // 로그인 사용자 확인
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return "redirect:/user/login.do";
        }
        
        UserVO loginUser = userService.getByEmail(auth.getName());
        model.addAttribute("loginUser", loginUser);

        // 기본 배송지 정보 가져오기
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

        // Case A: 장바구니 구매
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
                    item.setPrice(cart.getPrice());
                    item.setTotalPrice(cart.getPrice() * cart.getQuantity());
                    orderItems.add(item);
                    totalAmount += item.getTotalPrice();
                }
            }
        } 
        // Case B: 바로 구매
        else if (productIdx != null && optionIdxList != null) {
            ProductVO product = productService.detail(productIdx);
            for (int i = 0; i < optionIdxList.size(); i++) {
                ProductOptionVO option = optionService.getOptionById(optionIdxList.get(i));
                int quantity = quantityList.get(i);
                int basePrice = product.getPrice();
                int discountedPrice = product.getDiscountRate() > 0
                        ? (int)Math.floor(basePrice * (100 - product.getDiscountRate()) / 100.0)
                        : basePrice;
                
                OrderItemVO item = new OrderItemVO();
                item.setProductIdx(productIdx);
                item.setProductName(product.getProductName());
                item.setOptionIdx(option.getOptionIdx());
                item.setColor(option.getColor());
                item.setSize(option.getSize());
                item.setQuantity(quantity);
                item.setPrice(discountedPrice);
                item.setTotalPrice(discountedPrice * quantity);
                orderItems.add(item);
                totalAmount += item.getTotalPrice();
            }
        }
        
        model.addAttribute("orderItems", orderItems);
        model.addAttribute("totalAmount", totalAmount);

        return "order/payment";
    }

    /**
     * 2. 결제 완료 및 DB 처리 (재고 차감 핵심 로직 포함)
     */
    /**
     * 2. 결제 완료 및 DB 처리
     */
    /**
     * 2. 결제 완료 및 DB 처리 (주문서 생성 및 재고 차감)
     */
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
            Model model,
            RedirectAttributes rttr) { // RedirectAttributes 정상 추가

        // 1. 사용자 인증 확인
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return "redirect:/user/login.do";
        }
        UserVO loginUser = userService.getByEmail(auth.getName());

        // 2. 주문(Order) 정보 설정
        OrderVO order = new OrderVO();
        order.setUserIdx(loginUser.getUserIdx());
        order.setReceiver(receiver);
        order.setDeliveryPhone(deliveryPhone);
        order.setAddress(address);
        order.setExtraAddress(extraAddress);
        order.setZipcode(zipcode);
        order.setStatus(0); // 결제완료 상태

        List<OrderItemVO> items = new ArrayList<>();
        int totalAmountForVerify = 0;

        // 3. 주문 상세 아이템(OrderItem) 리스트 생성
        for (int i = 0; i < optionIdxList.size(); i++) {
            // 리스트 인덱스 예외 방지 (단일 상품일 경우 productIdxList[0] 참조)
            int pIdx = (productIdxList.size() > i) ? productIdxList.get(i) : productIdxList.get(0);
            int oIdx = optionIdxList.get(i);
            int qty = quantityList.get(i);

            ProductVO product = productService.detail(pIdx);
            ProductOptionVO option = optionService.getOptionById(oIdx);

            // 실시간 할인 적용가 계산 (보안상 서버에서 다시 계산)
            int discountedPrice = product.getDiscountRate() > 0
                    ? (int)Math.floor(product.getPrice() * (100 - product.getDiscountRate()) / 100.0)
                    : product.getPrice();
            
            totalAmountForVerify += (discountedPrice * qty);

            OrderItemVO item = new OrderItemVO();
            item.setProductIdx(pIdx);
            item.setProductName(product.getProductName());
            item.setCategory(product.getCategory());
            item.setSubCategory(product.getSubCategory());
            item.setColor(option.getColor());
            item.setSize(option.getSize());
            item.setQuantity(qty);
            item.setPrice(discountedPrice);
            item.setOptionIdx(oIdx);
            item.setStatus(0);
            
            String mainImg = product.getProductMainImg();
            item.setProductMainImg((mainImg == null || mainImg.isEmpty()) ? "no_image.jpg" : mainImg);
            items.add(item);
        }
        order.setTotalPrice(totalAmountForVerify);

        // 4. DB 트랜잭션 처리 (주문 저장 + 재고 차감 + 장바구니 비우기)
        try {
            // 트랜잭션 범위 내에서 한 번에 처리
            orderService.insertOrder(order, items);
            cartService.clearCart(loginUser.getUserIdx());
            
            model.addAttribute("order", order);
            model.addAttribute("items", items);
            
            return "order/complete"; // 주문 완료 페이지로 이동

        } catch (RuntimeException e) {
            // 재고 부족 등의 비즈니스 로직 예외 처리
            e.printStackTrace();
            rttr.addFlashAttribute("errorMsg", e.getMessage()); // 리다이렉트 후에도 메시지 유지
            return "redirect:/order/payment.do"; 
            
        } catch (Exception e) {
            // 일반 시스템 오류
            e.printStackTrace();
            return "redirect:/index.do?error=system";
        }
    } 
} 