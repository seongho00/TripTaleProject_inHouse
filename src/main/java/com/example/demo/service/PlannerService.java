package com.example.demo.service;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.MonthDay;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.PlannerRepository;
import com.example.demo.vo.DailyPlan;
import com.example.demo.vo.PlanRequest;
import com.example.demo.vo.Rq;
import com.example.demo.vo.TripDay;
import com.example.demo.vo.TripInfo;
import com.example.demo.vo.TripLocation;
import com.example.demo.vo.TripPlace;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class PlannerService {

	@Autowired
	private ChatGptService chatGptService;
	@Autowired
	Rq rq;

	@Autowired
	private PlannerRepository plannerRepository;

	public PlannerService(PlannerRepository plannerRepository) {
		this.plannerRepository = plannerRepository;

	}

	public String formatter(LocalDateTime date) {

		// yyyy-MM-dd형식 포맷터
		DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy.MM.dd");

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

	public List<String> createPlan(String planDataJson, String tripRegion, LocalDateTime tripStartDate,
			LocalDateTime tripEndDate) throws IOException {
		int memberId = rq.getLoginedMemberId();

		ObjectMapper objectMapper = new ObjectMapper();

		// JSON → Map<String, DailyPlan>으로 파싱
		Map<String, DailyPlan> plansByDay = objectMapper.readValue(planDataJson,
				new TypeReference<Map<String, DailyPlan>>() {
				});

		PlanRequest planRequest = new PlanRequest();
		planRequest.setPlansByDay(plansByDay);

		List<String> results = new ArrayList<>();

		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd");
		int year = tripStartDate.getYear();

		plannerRepository.createPlan(tripRegion, tripStartDate, tripEndDate, memberId);
		int tripId = plannerRepository.getLastInsertId();

		int dayIndex = 1;
		// 데이터 까보기 & 데이터 넣기 & chatgpt에게 물어보기
		for (Map.Entry<String, DailyPlan> entry : plansByDay.entrySet()) {

			String rawDate = entry.getKey(); // "06/17"
			MonthDay md = MonthDay.parse(rawDate, formatter);
			LocalDate parsedDate = md.atYear(year); // → LocalDate 객체
			String date = parsedDate.toString(); // → "2025-06-17"

			DailyPlan dailyPlan = entry.getValue();

			String startTime = "10:00";
			String endTime = "22:00";
			plannerRepository.insertTripDay(tripId, dayIndex, date, startTime, endTime);
			dayIndex++;
			if (dailyPlan == null) {
				continue;
			}

//			results.add(chatGptService.generateOptimizedSchedule(date, dailyPlan));

		}
		return results;

	}

	public TripInfo getTripInfoById(int tripId) {

		return plannerRepository.getTripInfoById(tripId);
	}

	public List<TripDay> getTripDayById(int tripId) {
		return plannerRepository.getTripDayById(tripId);
	}

	public List<TripPlace> getTripPlace(List<TripDay> tripDays) {
		LocalDate today = LocalDate.now(); // 오늘 날짜

		for (TripDay tripDay : tripDays) {
			LocalDateTime dateTime = tripDay.getDate(); // DATETIME 타입이라고 가정
			if (dateTime.toLocalDate().equals(today)) {
				// 오늘 날짜와 일치하는 TripDay 발견 시 처리
				return plannerRepository.getTripPlaceById(tripDay.getId()); // 예: 해당 TripDay에 연결된 TripPlace
			}

		}
		return plannerRepository.getTripPlaceById(tripDays.get(0).getId());
	}

	public List<TripLocation> getTripLocationById(List<TripPlace> todayTripPlace) {

		List<TripLocation> tripLocations = new ArrayList<>();
		for (TripPlace tripPlace : todayTripPlace) {
			tripLocations.add(plannerRepository.getTripLocationById(tripPlace.getTripLocationId()));
		}

		return tripLocations;
	}

}
