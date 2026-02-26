package com.mbcTeam.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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

	@RequestMapping(value = "/payment.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String paymentPage(@RequestParam(required = false) Integer productIdx,
			@RequestParam(required = false) List<Integer> optionIdxList,
			@RequestParam(required = false) List<Integer> quantityList,
			@RequestParam(required = false, value = "cartIdxList") List<Long> cartIdxList, Model model) {

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
			return "redirect:/user/login.do";
		}

		UserVO loginUser = userService.getByEmail(auth.getName());
		model.addAttribute("loginUser", loginUser);

		DeliveryVO delivery = null;
		List<DeliveryVO> addresses = dservice.getAddressList(loginUser.getUserIdx());
		if (addresses != null && !addresses.isEmpty()) {
			delivery = addresses.stream().filter(DeliveryVO::isDefaultAddress).findFirst().orElse(addresses.get(0));
		}
		model.addAttribute("delivery", delivery);

		List<OrderItemVO> orderItems = new ArrayList<>();
		int totalAmount = 0;

		// Case A: 장바구니 구매
		if (cartIdxList != null && !cartIdxList.isEmpty()) {
			for (Long cartIdx : cartIdxList) {
				CartVO cart = cartService.getCartItem(cartIdx);
				if (cart != null) {
					// Cart의 항목중 stock이 0인거 체크
					// System.out.println("OPTION IDX: "+cart.getOptionIdx());
					// System.out.println("Stock: " +
					// optionService.getOptionStock(cart.getOptionIdx()));

					if (optionService.getOptionStock(cart.getOptionIdx()) < 1) {
						return "redirect:/cart/cartlist.do";
					}

					// [중요] DB의 cart.getPrice() 대신 상품 정보를 다시 조회하여 정확한 할인가 계산
					ProductVO product = productService.detail((int) cart.getProductIdx());

					int basePrice = product.getPrice();
					int discountedPrice = product.getDiscountRate() > 0
							? (int) Math.floor(basePrice * (100 - product.getDiscountRate()) / 1000.0) * 10 // 10원 단위 절삭
							: basePrice;

					OrderItemVO item = new OrderItemVO();
					item.setProductIdx((int) cart.getProductIdx());
					item.setProductName(cart.getProductName());
					item.setOptionIdx((int) cart.getOptionIdx());
					item.setColor(cart.getColor());
					item.setSize(cart.getSize());
					item.setQuantity(cart.getQuantity());

					// 계산된 정확한 단가 세팅
					item.setPrice(discountedPrice);
					item.setTotalPrice(discountedPrice * cart.getQuantity());

					orderItems.add(item);
					totalAmount += item.getTotalPrice();
				}
			}
		}
		// Case B: 바로 구매
		else if (productIdx != null && optionIdxList != null) {
			ProductVO product = productService.detail(productIdx);
			for (int i = 0; i < optionIdxList.size(); i++) {

				// 결제할 항목중 stock이 0인거 체크
				if (optionService.getOptionStock(optionIdxList.get(i)) < 1) {
					return "redirect:/userproduct/userproductdetail.do?productIdx=" + productIdx;
				}

				ProductOptionVO option = optionService.getOptionById(optionIdxList.get(i));
				int quantity = quantityList.get(i);
				int basePrice = product.getPrice();
				int discountedPrice = product.getDiscountRate() > 0
						? (int) Math.floor(basePrice * (100 - product.getDiscountRate()) / 100.0)
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
		model.addAttribute("cartIdxList", cartIdxList);

		return "order/payment";
	}

	/**
	 * 2. 주문 완료 처리 (재고 차감 및 장바구니 삭제)
	 */
	@Transactional
	@RequestMapping("/complete.do")
	public String completeOrder(@RequestParam(value = "productIdx") List<Integer> productIdxList,
			@RequestParam(value = "optionIdxList") List<Integer> optionIdxList,
			@RequestParam(value = "quantityList") List<Integer> quantityList,
			@RequestParam(value = "cartIdxList", required = false) List<Long> cartIdxList,
			@RequestParam(value = "receiver") String receiver,
			@RequestParam(value = "deliveryPhone") String deliveryPhone,
			@RequestParam(value = "address") String address, @RequestParam(value = "extraAddress") String extraAddress,
			@RequestParam(value = "zipcode") String zipcode, Model model, RedirectAttributes rttr) {

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
			return "redirect:/user/login.do";
		}
		UserVO loginUser = userService.getByEmail(auth.getName());

		OrderVO order = new OrderVO();
		order.setUserIdx(loginUser.getUserIdx());
		order.setReceiver(receiver);
		order.setDeliveryPhone(deliveryPhone);
		order.setAddress(address);
		order.setExtraAddress(extraAddress);
		order.setZipcode(zipcode);
		order.setStatus(0);

		List<OrderItemVO> items = new ArrayList<>();
		int totalAmountForVerify = 0;

		for (int i = 0; i < optionIdxList.size(); i++) {
			int pIdx = (productIdxList.size() > i) ? productIdxList.get(i) : productIdxList.get(0);
			int oIdx = optionIdxList.get(i);
			int qty = quantityList.get(i);

			ProductVO product = productService.detail(pIdx);
			ProductOptionVO option = optionService.getOptionById(oIdx);

			int discountedPrice = product.getDiscountRate() > 0
					? (int) Math.floor(product.getPrice() * (100 - product.getDiscountRate()) / 100.0)
					: product.getPrice();

			totalAmountForVerify += (discountedPrice * qty);

			OrderItemVO item = new OrderItemVO();
			item.setProductIdx(pIdx);
			item.setProductName(product.getProductName());

			// [에러 해결 포인트] 필수 카테고리 정보 세팅
			item.setCategory(product.getCategory());
			item.setSubCategory(product.getSubCategory());

			item.setOptionIdx(oIdx);
			item.setQuantity(qty);
			item.setPrice(discountedPrice);
			item.setStatus(0);

			// 옵션 텍스트 정보 추가 (선택사항)
			item.setColor(option.getColor());
			item.setSize(option.getSize());

			String mainImg = product.getProductMainImg();
			item.setProductMainImg((mainImg == null || mainImg.isEmpty()) ? "no_image.jpg" : mainImg);
			items.add(item);
		}
		order.setTotalPrice(totalAmountForVerify);

		try {
			// 주문 정보 저장
			orderService.insertOrder(order, items);

			// 장바구니에서 구매한 상품만 삭제
			if (cartIdxList != null && !cartIdxList.isEmpty()) {
				cartService.deleteSelectedCartItems(cartIdxList);
			}

			model.addAttribute("order", order);
			model.addAttribute("items", items);

			return "order/complete";

		} catch (RuntimeException e) {
			e.printStackTrace();
			rttr.addFlashAttribute("errorMsg", e.getMessage());
			return "redirect:/order/payment.do";
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/index.do?error=system";
		}
	}

	@GetMapping("/Test.do")
	public String StockCheck() {
		System.out.println("TRANSACTIONAL TEST");
		try {
			orderService.Test();
		} catch (Exception e) {
			System.out.println(e);
		}

		return "redirect:/index.do";
	}

}