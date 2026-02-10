/*  최근검색어 컨트롤 부분 DB 부분 처리후 작업  확인시 로그인 후 확인
package com.mbcTeam.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mbcTeam.cart.CartService;
import com.mbcTeam.user.UserService;
import com.mbcTeam.user.UserVO;


@Controller
public class SearchController {

    @RequestMapping("/search")
    public String search(@RequestParam("keyword") String keyword, HttpSession session) {
        // 세션에서 최근 검색어 리스트 가져오기
        List<String> recentSearches = (List<String>) session.getAttribute("recentSearches");
        if (recentSearches == null) {
            recentSearches = new ArrayList<>();
        }

        // 중복 제거 후 최신 검색어 추가
        recentSearches.remove(keyword);
        recentSearches.add(0, keyword);

        // 최대 5개까지만 유지
        if (recentSearches.size() > 5) {
            recentSearches = recentSearches.subList(0, 5);
        }

        // 세션에 저장
        session.setAttribute("recentSearches", recentSearches);

        // 검색 결과 페이지로 이동
        return "searchResult"; // 결과 페이지 JSP
    }
}
*/