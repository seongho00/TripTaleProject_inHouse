package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.example.demo.repository.KakaoOAuthRepository;
import com.example.demo.repository.MemberRepository;
import com.example.demo.vo.Member;
import com.example.demo.vo.Rq;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;

@Service
public class KakaoOAuthService {

	@Autowired
	private Rq rq;

	@Autowired
	private MemberRepository memberRepository;

	public KakaoOAuthService(MemberRepository memberRepository) {
		this.memberRepository = memberRepository;

	}

	// 토큰 요청 함수
	public String requestAccessToken(String authorizationCode) {
		String clientId = rq.getKakaoClientId();
		String clientSecret = rq.getKakaoClientSecret();

		// 1. 요청 URL
		String url = "https://kauth.kakao.com/oauth/token";

		// 2. 파라미터 설정
		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
		params.add("grant_type", "authorization_code");
		params.add("client_id", clientId);
		params.add("redirect_uri", "http://localhost:8080/usr/member/kakaoCallback");
		params.add("code", authorizationCode);
		params.add("client_secret", clientSecret);

		// 3. 헤더 설정
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
		headers.set("Accept-Charset", "UTF-8");

		// 4. 요청 조합
		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

		// 5. 요청 실행
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
		String accessTokenBody = parseResponseBody(response.getBody());
		return accessTokenBody;

	}

	// 토큰 요청 데이터 까보기
	public String parseResponseBody(String responseBody) {

		try {

			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode root = objectMapper.readTree(responseBody);

			String kakaoAccessToken = root.path("access_token").asText();
			String tokenType = root.path("token_type").asText();
			String idToken = root.path("id_token").asText();
			String scope = root.path("scope").asText();
			String refreshToken = root.path("refresh_token").asText();
			int expiresIn = root.path("expires_in").asInt();
			int refreshTokenExpiresIn = root.path("refresh_token_expires_in").asInt();
			HttpSession session = (HttpSession) rq.getSession();
			session.setAttribute("kakaoAccessToken", kakaoAccessToken);

			return kakaoAccessToken;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	// 토큰을 통해 유저 데이터 요청
	public void getUserInfo(String accessToken) {
		String url = "https://kapi.kakao.com/v2/user/me?secure_resource=true";

		// 1. 헤더 설정
		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(accessToken); // "Authorization: Bearer {토큰}"
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<String> entity = new HttpEntity<>(headers);

		// 2. RestTemplate으로 GET 요청
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);

		// 3. 응답 출력
//		System.out.println("응답 상태: " + response.getStatusCode());
//		System.out.println("응답 바디: " + response.getBody());
		parseUserResponseBody(response.getBody());

	}

	// 유저 데이터 까보기
	public void parseUserResponseBody(String responseBody) {
		try {

			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode root = objectMapper.readTree(responseBody);

			String id = root.path("id").asText();
			String connectedAt = root.path("connected_at").asText();
			String nickname = root.path("properties").path("nickname").asText();
			String profileImage = root.path("properties").path("profile_image").asText();
			String thumbnailImage = root.path("properties").path("thumbnail_image").asText();
			String email = root.path("kakao_account").path("email").asText();

			Member loginedMember = memberRepository.getMemberById("kakao", id);

			if (loginedMember == null) {
				memberRepository.doJoin("kakao", id, null, nickname, email, profileImage);
			}

			rq.login(loginedMember.getId(), loginedMember);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public String coordToAddress(String x, String y) {
		String apiKey = "KakaoAK " + rq.getKakaoClientId(); // KakaoAK 꼭 포함

		// API URL
		String url = "https://dapi.kakao.com/v2/local/geo/coord2address.json";

		// URI에 파라미터 추가
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("x", x).queryParam("y", y)
				.queryParam("input_coord", "WGS84");

		// 헤더 설정
		HttpHeaders headers = new HttpHeaders();
		headers.set("Authorization", apiKey);
		headers.setContentType(MediaType.APPLICATION_JSON);

		// 요청 엔티티 생성
		HttpEntity<String> entity = new HttpEntity<>(headers);

		// 요청 보내기
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response = restTemplate.exchange(builder.toUriString(), HttpMethod.GET, entity,
				String.class);

		// 응답 출력
		System.out.println("응답 결과:");
		System.out.println(response.getBody());
		return response.getBody();
	}

}
