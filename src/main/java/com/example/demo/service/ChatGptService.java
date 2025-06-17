package com.example.demo.service;

import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.vo.DailyPlan;
import com.example.demo.vo.Rq;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class ChatGptService {

	@Autowired
	Rq rq;

	private static final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";

	public String askQuestion(List<String> moods, List<MultipartFile> images) throws IOException {


		String apiKey = "Bearer " + rq.getChatGptClientId();
		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();

		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.set("Authorization", apiKey);

		// base64 인코딩 (이미지 1장 예시)
		String base64Image = Base64.getEncoder().encodeToString(images.get(0).getBytes());
		String imageUrl = "data:image/jpeg;base64," + base64Image;

		// 감정 텍스트 만들기
		String moodsText = String.join(", ", moods);
		String prompt = "이 이미지를 보고 다음 감정들을 느꼈다고 가정하고 글을 써줘: " 
                + moodsText + ". 글의 형식은 일기 또는 짧은 에세이처럼 해줘. "
                + "감정 표현이 자연스럽게 드러나도록 이미지 분위기와 감정을 연결해줘.";

		// messages 구성
		Map<String, Object> textPart = Map.of("type", "text", "text", prompt);

		Map<String, Object> imagePart = Map.of("type", "image_url", "image_url", Map.of("url", imageUrl));

		Map<String, Object> userMessage = Map.of("role", "user", "content", List.of(textPart, imagePart));

		// body 구성
		Map<String, Object> body = new HashMap<>();
		body.put("model", "gpt-4o");
		body.put("messages", List.of(userMessage));

		HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);
		ResponseEntity<Map> response = restTemplate.exchange(OPENAI_API_URL, HttpMethod.POST, request, Map.class);

		// 응답 파싱
		List<Map<String, Object>> choices = (List<Map<String, Object>>) response.getBody().get("choices");
		Map<String, Object> messageData = (Map<String, Object>) choices.get(0).get("message");

		return messageData.get("content").toString();
	}

	public String generateOptimizedSchedule(String day, DailyPlan dailyPlan) {
		String OPENAI_API_KEY = rq.getChatGptClientId();
		try {
			ObjectMapper mapper = new ObjectMapper();

			// ✅ 날짜 하루씩 계산 (06/15처럼 하루만)
			String startTime = dailyPlan.getAvailableTime().getStart();
			String endTime = dailyPlan.getAvailableTime().getEnd();

			// 👇 여행 계획 JSON 문자열
			String planJson = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(dailyPlan);

			// ✅ 사용자 프롬프트 구성
			String prompt = """
					너는 여행 일정 짜주는 도우미야.

					다음은 사용자의 하루 일정 정보와 방문 후보 장소들이야.
					- 날짜: %s
					- 사용 가능한 시간: %s ~ %s
					- 각 장소는 위도(lat), 경도(lng), 머무는 시간(duration) 정보가 있어
					- 장소 간 거리를 고려해 이동 시간은 대략 20~40분으로 추정해줘

					요구사항:
					1. 하루 시간 안에서 가능한 한 많은 장소를 방문하도록 계획해줘
					2. 같은 장소는 중복 방문하지 말아줘
					3. 각 장소의 머무는 시간 + 이동 시간을 고려해서 계산해줘
					4. 결과는 다음 JSON 형식의 **배열만** 출력해줘. `배열 안에 있는 요소는 장소 객체이고, 그 외에는 아무것도 출력하지 마`

					출력 형식:
					[
					  {
					    "place": "동춘당공원",
					    "lat": 36.3657396,
					    "lng": 127.441732,
					    "start": "10:00 AM",
					    "end": "12:30 PM",
					    "duration": "02:00"
					  },
					  {
					    "place": "계족산",
					    "lat": 36.3847228,
					    "lng": 127.4391981,
					    "start": "1:00 PM",
					    "end": "3:30 PM",
					    "duration": "02:00"
					  }
					]
					장소 정보:
					""".formatted(day, startTime, endTime) + planJson;

			// 👇 ChatGPT 메시지 포맷
			Map<String, Object> message = Map.of("role", "user", "content", prompt);

			Map<String, Object> requestBody = Map.of("model", "gpt-3.5-turbo", "temperature", 0.7, "messages",
					List.of(message));

			// 👇 HTTP 요청 설정
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);
			headers.set("Authorization", "Bearer " + OPENAI_API_KEY);

			HttpEntity<Map<String, Object>> httpRequest = new HttpEntity<>(requestBody, headers);

			// 👇 API 호출
			RestTemplate restTemplate = new RestTemplate();
			ResponseEntity<Map> response = restTemplate.exchange(OPENAI_API_URL, HttpMethod.POST, httpRequest,
					Map.class);

			// 👇 응답 파싱
			List<Map<String, Object>> choices = (List<Map<String, Object>>) response.getBody().get("choices");
			Map<String, Object> messageData = (Map<String, Object>) choices.get(0).get("message");
			return messageData.get("content").toString();

		} catch (Exception e) {
			e.printStackTrace();
			return "ChatGPT 호출 실패: " + e.getMessage();
		}
	}
}