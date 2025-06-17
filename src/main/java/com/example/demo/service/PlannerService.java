package com.example.demo.service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.PlannerRepository;
import com.example.demo.vo.DailyPlan;
import com.example.demo.vo.PlanRequest;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class PlannerService {
	
	@Autowired
	private ChatGptService chatGptService;
	
	@Autowired
	private PlannerRepository plannerRepository;

	public PlannerService(PlannerRepository plannerRepository) {
		this.plannerRepository = plannerRepository;

	}
	public String formatter(LocalDateTime date) {

		// yyyy-MM-dd형식 포맷터
		DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

		return date.format(dateFormatter);
	}

	public List<String> getDateList(LocalDateTime startDate, long diffDays) {
		// MM/dd형식 포맷터
		DateTimeFormatter monthDayFormatter = DateTimeFormatter.ofPattern("MM/dd");
		// ✅ 날짜 리스트 생성
		List<String> dateList = new ArrayList<>();
		for (int i = 0; i < diffDays; i++) {
			LocalDateTime targetDate = startDate.plusDays(i);
			dateList.add(targetDate.format(monthDayFormatter)); // "MM/dd" 형식으로
		}
		return dateList;
	}

	public List<String> createPlan(String planDataJson) throws IOException  {
		ObjectMapper objectMapper = new ObjectMapper();

		// JSON → Map<String, DailyPlan>으로 파싱
		Map<String, DailyPlan> plansByDay = objectMapper.readValue(planDataJson,
				new TypeReference<Map<String, DailyPlan>>() {
				});

		PlanRequest planRequest = new PlanRequest();
		planRequest.setPlansByDay(plansByDay);
		
		List<String> results = new ArrayList<>();
		
		// 데이터 까보기
		for (Map.Entry<String, DailyPlan> entry : plansByDay.entrySet()) {

			String day = entry.getKey();
			DailyPlan dailyPlan = entry.getValue();
			System.out.println(day);
			System.out.println(dailyPlan);
			
//			 plannerRepository.createPlan(tripName, tripRegion, tripStartDate, tripEndDate, memberId);
			 int tripId =plannerRepository.getLastInsertId();
			


			if (dailyPlan == null) {
				continue;
			}

//			results.add(chatGptService.generateOptimizedSchedule(day, dailyPlan));
			
		}
		return null;
		
	}


}
