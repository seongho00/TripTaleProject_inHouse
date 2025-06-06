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

import com.example.demo.vo.Rq;

@Service
public class ChatGptService {

	@Autowired
	Rq rq;

	private static final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";
	
	public String askQuestion(String question) {
		String API_KEY = "Bearer " + rq.getChatGptClientId(); // 🔑 실제 API 키로 바꾸세요
		
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
}