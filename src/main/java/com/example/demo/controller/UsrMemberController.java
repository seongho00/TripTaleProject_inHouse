package com.example.demo.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.WebMvcConfigurer;
import com.example.demo.interceptor.BeforeActionInterceptor;
import com.example.demo.service.KakaoOAuthService;
import com.example.demo.service.MemberService;
import com.example.demo.service.NaverOAuthService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Member;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpSession;

@Controller
public class UsrMemberController {

	private final WebMvcConfigurer webMvcConfigurer;

	private final BeforeActionInterceptor beforeActionInterceptor;

	@Autowired
	private MemberService memberService;
	@Autowired
	private KakaoOAuthService kakaoOAuthService;
	@Autowired
	private NaverOAuthService naverOAuthService;
	@Autowired
	private Rq rq;

	UsrMemberController(BeforeActionInterceptor beforeActionInterceptor, WebMvcConfigurer webMvcConfigurer) {
		this.beforeActionInterceptor = beforeActionInterceptor;
		this.webMvcConfigurer = webMvcConfigurer;

	}

	@RequestMapping("usr/member/profile")
	public String profile(Model model) {
		rq.getLoginedMemberId();

		return "usr/member/profile";
	}

	@RequestMapping("usr/member/developerJoin")
	public String developerJoin(Model model) {

		if (rq.isLogined()) {
			System.out.println("로그인 되어있음");
			return "usr/home/main";
		}

		String kakaoClientId = rq.getKakaoClientId();
		String kakaoRedirectUri = "http://localhost:8080/usr/member/kakaoCallback";

		model.addAttribute("kakaoClientId", kakaoClientId);
		model.addAttribute("kakaoRedirectUri", kakaoRedirectUri);

		return "usr/member/developerJoin";
	}

	@RequestMapping("usr/member/naverCallback")
	public String naverCallback(String code, String state) throws UnsupportedEncodingException {

		String accessToken = naverOAuthService.requestAccessToken(code, state);

		naverOAuthService.getUserInfo(accessToken);

		return "usr/home/main";
	}

	@RequestMapping("usr/member/kakaoCallback")
	public String kakaoCallback(String code) {

		String accessToken = kakaoOAuthService.requestAccessToken(code);

		kakaoOAuthService.getUserInfo(accessToken);

		return "usr/home/main";
	}

	@GetMapping("usr/member/doLogout")
	public String doLogout(Model model) {
		HttpSession session = (HttpSession) rq.getSession();

		if (rq.isLogined()) {
			rq.logout();

			if (session.getAttribute("kakaoAccessToken") != null) {
				session.removeAttribute("kakaoAccessToken");
				return "redirect:http://localhost:8080/usr/member/kakaoLogout";
			}

		}
		return "usr/home/main";
	}

	@GetMapping("usr/member/kakaoLogout")
	public String kakaoLogoutRedirect() {

		String clientId = rq.getKakaoClientId();
		String logoutRedirectUri = "http://localhost:8080/usr/home/main";
		String url = "https://kauth.kakao.com/oauth/logout?client_id=" + clientId + "&logout_redirect_uri="
				+ URLEncoder.encode(logoutRedirectUri, StandardCharsets.UTF_8);
		return "redirect:" + url;
	}

	@RequestMapping("usr/member/join")
	public String join(Model model) {

		return "usr/member/join";
	}

	@RequestMapping("usr/member/doJoin")
	public String doJoin(Model model, String loginId, String loginPw, String name, String email) {

		if (Ut.isEmptyOrNull(loginId)) {
			return rq.historyBackOnView("아이디를 입력해주세요.");
		}

		if (Ut.isEmptyOrNull(loginPw)) {
			return rq.historyBackOnView("비밀번호를 입력해주세요.");
		}

		if (Ut.isEmptyOrNull(name)) {
			return rq.historyBackOnView("이름을 입력해주세요.");
		}

		if (Ut.isEmptyOrNull(email)) {
			return rq.historyBackOnView("이메일을 입력해주세요.");
		}

		Member member = memberService.getMemberById("local", loginId);
		if (member != null) {
			return rq.historyBackOnView("이미 존재하는 아이디입니다.");
		}

		ResultData doJoinRd = memberService.doJoin(loginId, loginPw, name, email);

		return rq.replace(name + "님 환영합니다.", "http://localhost:8080/usr/home/main");
	}

	@RequestMapping("usr/member/login")
	public String login(Model model) {

		String kakaoClientId = rq.getKakaoClientId();
		String kakaoRedirectUri = "http://localhost:8080/usr/member/kakaoCallback";

		model.addAttribute("kakaoClientId", kakaoClientId);
		model.addAttribute("kakaoRedirectUri", kakaoRedirectUri);

		return "usr/member/login";
	}

	@RequestMapping("usr/member/findLoginPage")
	public String findLoginId(Model model, @RequestParam(defaultValue = "id") String findType) {

		if (findType.equals("id")) {
			model.addAttribute("activeId", true);
			model.addAttribute("activePw", false);
		} else if (findType.equals("pw")) {
			model.addAttribute("activePw", true);
			model.addAttribute("activeId", false);
		}

		return "usr/member/findLoginPage";
	}

	@RequestMapping("usr/member/doLogin")
	public String doLogin(Model model, String loginId, String loginPw) {

		if (Ut.isEmptyOrNull(loginId)) {
			return rq.historyBackOnView("아이디를 입력해주세요.");
		}

		if (Ut.isEmptyOrNull(loginPw)) {
			return rq.historyBackOnView("비밀번호를 입력해주세요.");
		}

		Member loginedMember = memberService.getMemberById("local", loginId);

		if (loginedMember == null) {
			return rq.historyBackOnView("존재하지 않는 아이디입니다.");
		}
		if (!loginedMember.getLoginPw().equals(loginPw)) {
			return rq.historyBackOnView("비밀번호가 일치하지 않습니다.");
		}

		return rq.replace(loginedMember.getName() + "님 환영합니다.", "http://localhost:8080/usr/home/main");
	}

}
