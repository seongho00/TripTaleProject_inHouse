package com.example.demo.service;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.repository.MemberRepository;
import com.example.demo.vo.Member;
import com.example.demo.vo.Rq;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class NaverOAuthService {

	@Autowired
	private Rq rq;

	@Autowired
	private MemberRepository memberRepository;
	@Autowired
	private TripLocationService tripLocationService;

	public NaverOAuthService(MemberRepository memberRepository, TripLocationService tripLocationService) {
		this.memberRepository = memberRepository;
		this.tripLocationService = tripLocationService;
	}

	public String requestAccessToken(String code, String state) throws UnsupportedEncodingException {
		String clientId = rq.getNaverClientId();
		String clientSecret = rq.getNaverClientSecret();
		String redirectURI = URLEncoder.encode("http://localhost:8080/usr/home/main", "UTF-8");

		String url = "https://nid.naver.com/oauth2.0/token" + "?grant_type=authorization_code" + "&client_id="
				+ clientId + "&client_secret=" + clientSecret + "&redirect_uri=" + redirectURI + "&code=" + code
				+ "&state=" + state;

		// 1. 헤더 설정
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		// 2. 요청 생성 (GET 방식은 보통 파라미터만 넣음)
		HttpEntity<String> request = new HttpEntity<>(headers);

		// 3. RestTemplate로 요청
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, request, String.class);

		// 4. 응답 출력 및 반환
//		System.out.println("응답 코드: " + response.getStatusCode());
//		System.out.println("응답 바디: " + response.getBody());

		String accessToken = parseResponseBody(response.getBody());
//		System.out.println(accessToken);
		return accessToken; // 필요시 JSON 파싱 가능
	}

	public String parseResponseBody(String responseBody) {

		try {

			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode root = objectMapper.readTree(responseBody);

			String naverAccessToken = root.path("access_token").asText();
			String tokenType = root.path("token_type").asText();
			String refreshToken = root.path("refresh_token").asText();
			int expiresIn = root.path("expires_in").asInt();

			return naverAccessToken;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public String getUserInfo(String accessToken) {
		String url = "https://openapi.naver.com/v1/nid/me";

		// 1. 헤더 구성
		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(accessToken); // "Authorization: Bearer {accessToken}"
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<String> requestEntity = new HttpEntity<>(headers);

		// 2. 요청 실행
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, requestEntity, String.class);

		// 3. 응답 처리
//		System.out.println("응답 코드: " + response.getStatusCode());
//		System.out.println("응답 바디: " + response.getBody());

		parseUserResponseBody(response.getBody());

		return response.getBody();
	}

	// 유저 데이터 까보기
	public void parseUserResponseBody(String responseBody) {
		try {

			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode root = objectMapper.readTree(responseBody);

			String resultCode = root.path("resultcode").asText();
			String message = root.path("message").asText();
			String id = root.path("response").path("id").asText();
			String nickname = root.path("response").path("nickname").asText();
			String email = root.path("response").path("email").asText();
			String name = root.path("response").path("name").asText();
			String profileImage = root.path("response").path("profile_image").asText();
			String birthyear = root.path("response").path("birthyear").asText();

			Member loginedMember = memberRepository.getMemberById("naver", id);

			if (loginedMember == null) {
				memberRepository.doJoin("naver", id, null, name, email, profileImage);
				loginedMember = memberRepository.getMemberById("naver", id);
			}

			rq.login(loginedMember.getId(), loginedMember);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public Map<String, Object> searchLocal() {
		String query = "대전 대덕구 관광지";
		String clientId = rq.getNaverClientId();
		String clientSecret = rq.getNaverClientSecret();
		RestTemplate restTemplate = new RestTemplate();
		int start = 10;
		String url = "https://openapi.naver.com/v1/search/local.json?display=5&sort=comment&start=" + start + "&query="
				+ query;

		HttpHeaders headers = new HttpHeaders();
		headers.set("X-Naver-Client-Id", clientId);
		headers.set("X-Naver-Client-Secret", clientSecret);

		HttpEntity<?> entity = new HttpEntity<>(headers);

		ResponseEntity<Map<String, Object>> response = restTemplate.exchange(url, HttpMethod.GET, entity,
				new ParameterizedTypeReference<Map<String, Object>>() {
				});
		System.out.println("Query: [" + query + "]");

		Map<String, Object> body = response.getBody();
		System.out.println(body);
		if (body != null && body.containsKey("items")) {
			List<Map<String, Object>> items = (List<Map<String, Object>>) body.get("items");
			System.out.println("items.size = " + items.size());

			for (Map<String, Object> item : items) {
				String title = Jsoup.parse((String) item.get("title")).text();
				System.out.println(title);
				System.out.println(item.get("link"));
				System.out.println(item.get("category"));
				System.out.println(item.get("description"));
				System.out.println(item.get("roadAddress"));
				System.out.println(item.get("mapx"));
				System.out.println(item.get("mapy"));
				System.out.println();

				if (!title.contains("대전")) {
					title = "대전 " + title;
				}

				double mapx = Double.parseDouble(item.get("mapx").toString()) / 10000000.0;
				double mapy = Double.parseDouble(item.get("mapy").toString()) / 10000000.0;


				tripLocationService.process(title, 3, mapx, mapy);
				try {
					Thread.sleep(5000); // 15초 대기
				} catch (InterruptedException e) {
					Thread.currentThread().interrupt(); // ← 권장 방식
				}
			}
		}

		return body;

	}

}
