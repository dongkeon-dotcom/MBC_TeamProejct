/*
package com.mbcTeam.security;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.mbcTeam.member.MemberService;
import com.mbcTeam.member.MemberVO;

@Controller
@RequestMapping("/oauth/google")
public class OAuthCallbackController {

	  private static final String CLIENT_ID = "너의_CLIENT_ID";
	    private static final String CLIENT_SECRET = "너의_CLIENT_SECRET";

	    @Autowired
	    private MemberService service;

	    @GetMapping("/callback.do")
	    public String callback(@RequestParam String code,
	                           @RequestParam(required = false) String state,
	                           HttpServletRequest request,
	                           HttpSession session) {

	        // 1) state 검증(권장)
	        String savedState = (String) session.getAttribute("OAUTH_STATE");
	        if (savedState != null && state != null && !savedState.equals(state)) {
	            // 위조 가능성
	            return "redirect:/member/login.do";
	        }

	        // redirect_uri 다시 동일하게 생성 (login.do에서 만든 것과 완전 동일해야 함)
	        String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
	                + request.getContextPath() + "/oauth/google/callback.do";

	        // 2) code -> access_token 요청
	        RestTemplate rt = new RestTemplate();

	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

	        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
	        params.add("code", code);
	        params.add("client_id", CLIENT_ID);
	        params.add("client_secret", CLIENT_SECRET);
	        params.add("redirect_uri", redirectUri);
	        params.add("grant_type", "authorization_code");

	        HttpEntity<MultiValueMap<String, String>> tokenReq = new HttpEntity<>(params, headers);

	        ResponseEntity<Map> tokenRes = rt.postForEntity(
	                "https://oauth2.googleapis.com/token",
	                tokenReq,
	                Map.class
	        );

	        String accessToken = (String) tokenRes.getBody().get("access_token");

	        // 3) access_token -> 사용자 정보 요청 (userinfo)
	        HttpHeaders h2 = new HttpHeaders();
	        h2.setBearerAuth(accessToken);

	        HttpEntity<Void> userReq = new HttpEntity<>(h2);

	        ResponseEntity<Map> userRes = rt.exchange(
	                "https://www.googleapis.com/oauth2/v3/userinfo",
	                HttpMethod.GET,
	                userReq,
	                Map.class
	        );

	        Map body = userRes.getBody();
	        String email = (String) body.get("email");
	        String name  = (String) body.get("name");
	        String sub   = (String) body.get("sub"); // 구글 고유 ID (선택 저장)

	        // 4) DB 조회/가입/로그인
	        MemberVO member = service.getByEmail(email); // 이 메서드 만들기

	        if (member == null) {
	            MemberVO vo = new MemberVO();
	            vo.setUser_email(email);              //  이메일
	            vo.setUserName(name);            //  이름
	            vo.setUserEasyLogin(true);       //  소셜 로그인
	            vo.setUserIsDeleted(false);      // 탈퇴 아님

	            // 소셜회원은 비번 없어도 되게 설계(또는 랜덤값 저장)
	            vo.setUserPW("SOCIAL");

	            service.insert(vo);
	            member = service.getByEmail(email);
	        }

	        session.setAttribute("loginMember", member);
	        session.setAttribute("isSocial", true);

	        return "redirect:/main.do";
	    }
	}
*/