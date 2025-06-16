package com.example.demo.service;

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

import com.example.demo.vo.DailyPlan;
import com.example.demo.vo.PlanRequest;
import com.example.demo.vo.Rq;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class ChatGptService {

	@Autowired
	Rq rq;

	private static final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";

	public String askQuestion(List<String> moods) {

		String question = "단어";

		String API_KEY = "Bearer " + rq.getChatGptClientId();

		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();

		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.set("Authorization", API_KEY);

		Map<String, Object> message = new HashMap<>();
		message.put("role", "user");
		message.put("content", question);

		Map<String, Object> body = new HashMap<>();
		body.put("model", "gpt-3.5-turbo");
		body.put("messages", List.of(message));

		HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);
		ResponseEntity<Map> response = restTemplate.exchange(OPENAI_API_URL, HttpMethod.POST, request, Map.class);

		List<Map<String, Object>> choices = (List<Map<String, Object>>) response.getBody().get("choices");
		Map<String, Object> messageData = (Map<String, Object>) choices.get(0).get("message");

		return messageData.get("content").toString();
	}

	public String generateOptimizedSchedule(PlanRequest planRequest) {
		String OPENAI_API_KEY = rq.getChatGptClientId();
		try {
			ObjectMapper mapper = new ObjectMapper();

			Map<String, DailyPlan> plansByDay = planRequest.getPlansByDay();

			// ✅ 날짜 하루씩 계산 (06/15처럼 하루만)
			String day = plansByDay.keySet().iterator().next(); // 예: "06/15"
			DailyPlan daily = plansByDay.get(day);
			String startTime = daily.getAvailableTime().getStart();
			String endTime = daily.getAvailableTime().getEnd();

			// 👇 여행 계획 JSON 문자열
			String planJson = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(plansByDay);

			// ✅ 사용자 프롬프트 구성
			String prompt = """
					너는 여행 일정 짜주는 도우미야.

					다음은 사용자의 하루 일정 정보와 방문 후보 장소들이야.
					- 날짜: %s
					- 사용 가능한 시간: %s ~ %s
					- 각 장소는 위도(lat), 경도(lng), 머무는 시간(duration) 정보가 있어
					- 장소 간 거리를 고려해 이동 시간은 대략 20~40분으로 추정해줘

					요구사항:
					1. 하루 시간(12시간) 안에서 가능한 한 많은 장소를 방문하도록 계획해줘
					2. 같은 장소는 중복 방문하지 말아줘
					3. 각 장소의 머무는 시간 + 이동 시간을 고려해서 계산해줘
					4. 결과는 다음과 같은 JSON 배열 형식으로 응답해줘. JSON만 출력해줘

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