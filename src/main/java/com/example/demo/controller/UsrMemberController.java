package com.example.demo.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.WebMvcConfigurer;
import com.example.demo.interceptor.BeforeActionInterceptor;
import com.example.demo.service.ArticleService;
import com.example.demo.service.KakaoOAuthService;
import com.example.demo.service.MemberService;
import com.example.demo.service.NaverOAuthService;
import com.example.demo.service.PlannerService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Article;
import com.example.demo.vo.Member;
import com.example.demo.vo.MemberImage;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import com.example.demo.vo.TripInfo;

import jakarta.servlet.http.HttpSession;

@Controller
public class UsrMemberController {

	private final WebMvcConfigurer webMvcConfigurer;

	private final BeforeActionInterceptor beforeActionInterceptor;

	@Autowired
	private MemberService memberService;
	@Autowired
	private ArticleService articleService;
	@Autowired
	private PlannerService plannerService;
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
	public String profile(Model model, int memberId) {
		Member loginedMember = rq.getLoginedMember();

		List<TripInfo> tripInfos = plannerService.getTripInfoByMemberId(memberId);

		List<String> urls = plannerService.getTripInfoThumbnail(memberId);
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

		// 변환 후 새로운 속성에 저장
		for (TripInfo info : tripInfos) {
			info.setFormattedStartDate(info.getTripStartDate().format(formatter));
			info.setFormattedEndDate(info.getTripEndDate().format(formatter));
		}

		// 게시글 가져오기
		List<Article> articels = articleService.getArticleByMemberId(memberId);

		// 프로필 이미지 가져오기
		MemberImage memberImage = memberService.getMemberImageByMemberId(memberId);
		System.out.println(loginedMember.getProfileImage());
		if (loginedMember.getProfileImage() != null) {

			model.addAttribute("developerImage", loginedMember.getProfileImage());
		} else {
			model.addAttribute("developerImage", null);
		}

		if (memberImage.getData() != null) {
			String base64Image = Base64.getEncoder().encodeToString(memberImage.getData());
			model.addAttribute("base64Image", base64Image);
		} else {
			model.addAttribute("base64Image", null);
		}

		model.addAttribute("loginedMember", loginedMember);
		model.addAttribute("tripInfos", tripInfos);
		model.addAttribute("urls", urls);
		model.addAttribute("articels", articels);

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

		return rq.replace(name + "님 회원가입되었습니다.", "http://localhost:8080/usr/member/login");
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
	public String findLoginPage(Model model, @RequestParam(defaultValue = "id") String findType) {

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

		rq.login(loginedMember.getId(), loginedMember);

		return rq.replace(loginedMember.getName() + "님 환영합니다.", "http://localhost:8080/usr/home/main");
	}

	@RequestMapping("usr/member/getLoginIdDup")
	@ResponseBody
	public ResultData getLoginIdDup(Model model, String loginId) {

		Member existsMember = memberService.getMemberById("local", loginId);

		if (existsMember != null) {
			return ResultData.from("F-1", "해당 아이디는 이미 사용중입니다.", "loginId", loginId);
		}
		return ResultData.from("S-1", "사용 가능한 아이디입니다.", "loginId", loginId);
	}

	@RequestMapping("usr/member/updateProfileImage")
	@ResponseBody
	public ResultData updateProfileImage(Model model, @RequestParam("profileImage") MultipartFile profileImage) {

		int loginedMemberId = rq.getLoginedMemberId();

		if (profileImage.isEmpty()) {
			return ResultData.from("F-1", "파일이 없습니다.");
		}

		try {

			byte[] imageBytes = profileImage.getBytes();
			int memberId = rq.getLoginedMemberId();
			String fileName = profileImage.getOriginalFilename();

			memberService.updateProfileImageData(memberId, fileName, imageBytes);

			return ResultData.from("S-1", "업로드 성공");
		} catch (IOException e) {
			e.printStackTrace();
			return ResultData.from("F-2", "파일 저장 중 오류");
		}
	}

	@RequestMapping("usr/member/doDelete")
	@ResponseBody
	public ResultData doDelete(Model model, int memberId) {

		memberService.doDelete(memberId);

		return ResultData.from("S-1", "삭제 성공");

	}

	@RequestMapping("usr/member/findLoginId")
	@ResponseBody
	public ResultData findLoginId(Model model, String name, String email) {

		Member member = memberService.getMemberByNameAndEmail(name, email);

		if (member == null) {
			return ResultData.from("F-1", "아이디 찾기 실패");
		}

		return ResultData.from("S-1", "아이디 찾기 성공", "아이디", member.getProviderId());

	}

	@RequestMapping("/usr/member/doFindLoginPw")
	@ResponseBody
	public ResultData doFindLoginPw(String providerId, String email) {

		Member member = memberService.getMemberByProviderId(providerId);
		if (member == null) {
			return ResultData.from("F-1", "비밀번호 찾기 실패");
		}
		

		ResultData notifyTempLoginPwByEmailRd = memberService.notifyTempLoginPwByEmail(member);

		return ResultData.from("S-1", "비밀번호 찾기 성공");
	}

}
