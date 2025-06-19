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
		String prompt = "이 이미지를 보고 다음 감정들을 느꼈다고 가정하고 글을 써줘: " + moodsText + ". 글의 형식은 일기 또는 짧은 에세이처럼 해줘. "
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

	public String generateOptimizedSchedule(String day, DailyPlan dailyPlan, int dayIndex) {
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
					너는 여행 일정을 계획해주는 도우미야.

					다음은 사용자의 하루 일정 정보와 방문 후보 장소들이야:
					- 날짜: %s
					- 사용 가능한 시간: %s ~ %s
					- 현재 이 계획은 dayIndex: %d
					- 각 장소는 고유한 id, 위도(lat), 경도(lng), 머무는 시간(duration)을 포함하고 있어
					- 장소 간 이동 시간은 평균 20~40분이 걸려 (실제 위치를 기준으로 추정해줘)

					요구사항:
					1. 하루 시간 안에서 가능한 한 많은 장소를 방문할 수 있도록 계획해줘
					2. 장소 간 **물리적 거리(위도/경도 기준)** 를 고려해서 가장 가까운 동선을 따라 방문하도록 구성해줘 (최단 경로)
					3. 같은 장소는 연달아 방문하지 말아줘
					4. 각 장소의 방문 시간은 start, end 로 표시하고, 이동 시간은 moveDuration으로 표시해줘
					5. 첫 장소의 moveDuration은 "00:00"으로 해줘
					6. 각 장소 객체에 "dayIndex"도 함께 포함해줘
					7. 결과는 다음 JSON 형식의 **배열만 출력해줘** (배열 외 문장이나 설명은 절대 출력하지 마)

					출력 예시:
					[
					  {
					    "id": 4,
					    "start": "10:00",
					    "end": "12:00",
					    "moveDuration": "00:00"
					    "dayIndex": 1
					  },
					  {
					    "id": 5,
					    "start": "12:30",
					    "end": "14:30",
					    "moveDuration": "00:30"
					    "dayIndex": 1
					  }
					]

					장소 정보:
					""".formatted(day, startTime, endTime, dayIndex, dayIndex) + planJson;

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