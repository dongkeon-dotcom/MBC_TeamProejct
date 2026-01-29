package com.mbcTeam.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mbcTeam.user.UserService;
import com.mbcTeam.user.UserVO;

@RequestMapping("/user")
@Controller
public class UserController {

	@Autowired
	private UserService service;

	@GetMapping(value = "/list.do")
	public String list(UserVO vo, Model model) {

		return "user/list";
	}

	@GetMapping("edit.do")
	String edit(Model model, UserVO vo) {

		return "user/edit";

	}

	@GetMapping(value = "/form.do")
	public String form(UserVO vo, Model model) {

		return "user/form";
	}

	@GetMapping(value = "/formOK.do")
	public String formOK(UserVO vo, Model model) {

		service.insert(vo);
		return "user/list";

	}

	@GetMapping(value = "/login.do")
	public String login(UserVO vo, Model model) {

		return "user/login";

	}

	@GetMapping(value = "/mypage.do")
	public String mypage(UserVO vo, Model model) {

		return "user/mypage";

	}

	@GetMapping(value = "/addresses.do")
	public String addresses(UserVO vo) {

		return "user/addresses";

	}

}
