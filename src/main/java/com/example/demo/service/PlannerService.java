package com.example.demo.service;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.MonthDay;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import com.example.demo.controller.UsrArticleController;
import com.example.demo.repository.PlannerRepository;
import com.example.demo.vo.AvailableTime;
import com.example.demo.vo.ChatPlanPlace;
import com.example.demo.vo.DailyPlan;
import com.example.demo.vo.PlacePlan;
import com.example.demo.vo.PlanRequest;
import com.example.demo.vo.Rq;
import com.example.demo.vo.TripDay;
import com.example.demo.vo.TripInfo;
import com.example.demo.vo.TripLocation;
import com.example.demo.vo.TripPlace;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

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

	public int createPlan(String planDataJson, String tripRegion, LocalDateTime tripStartDate,
			LocalDateTime tripEndDate) throws IOException {

		Gson gson = new Gson();

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
		String formattedtripRegion = tripRegion.replace("특별시", "").replace("광역시", "").trim();
		plannerRepository.createPlan(formattedtripRegion, tripStartDate, tripEndDate, memberId);
		int tripId = plannerRepository.getLastInsertId();

		int dayIndex = 1;
		// 데이터 까보기 & 데이터 넣기 & chatgpt에게 물어보기
		for (Map.Entry<String, DailyPlan> entry : plansByDay.entrySet()) {

			String rawDate = entry.getKey(); // "06/17"
			MonthDay md = MonthDay.parse(rawDate, formatter);
			LocalDate parsedDate = md.atYear(year); // → LocalDate 객체
			String date = parsedDate.toString(); // → "2025-06-17"

			DailyPlan dailyPlan = entry.getValue();
			String startTime = dailyPlan.getAvailableTime().getStart();
			String endTime = dailyPlan.getAvailableTime().getEnd();

			String gptResult = chatGptService.generateOptimizedSchedule(dailyPlan, dayIndex);

			List<ChatPlanPlace> planList = gson.fromJson(gptResult, new TypeToken<List<ChatPlanPlace>>() {
			}.getType());

			Map<Integer, List<ChatPlanPlace>> groupedByDayIndex = new LinkedHashMap<>();

			for (ChatPlanPlace place : planList) {

				groupedByDayIndex.computeIfAbsent(place.getDayIndex(), k -> new ArrayList<>()).add(place);

			}

			String fixedStartTime = startTime.replaceAll(":\\s+", ":").trim();
			String fixedEndTime = endTime.replaceAll(":\\s+", ":").trim();

			DateTimeFormatter amFormatter = DateTimeFormatter.ofPattern("h:mm a", Locale.ENGLISH);

			LocalTime formattingStartTime = LocalTime.parse(fixedStartTime, amFormatter); // → 10:15
			LocalTime formattingEndTime = LocalTime.parse(fixedEndTime, amFormatter); // → 14:30

			plannerRepository.insertTripDay(tripId, dayIndex, date, formattingStartTime, formattingEndTime);
			int tripDayId = plannerRepository.getLastInsertId();

			groupedByDayIndex.forEach((day, places) -> {

				for (ChatPlanPlace p : places) {
					plannerRepository.insertTripPlace(p.getId(), tripDayId, p.getStart(), p.getEnd(),
							p.getMoveDuration());
				}
			});
			dayIndex++;

		}
		return tripId;

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

	public List<TripPlace> getTripPlaceByClick(int tripId, int index) {

		return plannerRepository.getTripPlaceByClick(tripId, index);
	}

	public List<TripPlace> getAllTripPlace(int tripId) {

		return plannerRepository.getAllTripPlace(tripId);
	}

	public int getDayIndexById(int tripId, List<TripDay> tripDays) {
		LocalDate today = LocalDate.now(); // 오늘 날짜

		for (TripDay tripDay : tripDays) {
			LocalDateTime dateTime = tripDay.getDate(); // DATETIME 타입이라고 가정
			if (dateTime.toLocalDate().equals(today)) {
				// 오늘 날짜와 일치하는 TripDay 발견 시 처리
				return tripDay.getDayIndex();

			}

		}
		return 1;
	}

	public ResponseEntity<String> updateTripPlaces(Map<String, Object> requestBody) {
		Gson gson = new Gson();

		try {
			// tripId 파싱
			Object tripIdObj = requestBody.get("tripId");
			if (tripIdObj == null) {
				return ResponseEntity.badRequest().body("tripId가 누락되었습니다.");
			}
			int tripId = Integer.parseInt(tripIdObj.toString());

			// 기존 일정 삭제

			// tripId를 통해 tripDay 다 가져오기
			List<TripDay> tripDays = plannerRepository.getTripDayById(tripId);

			// 순회 시켜서 원래 일정 다 삭제
			for (TripDay tripDay : tripDays) {
				int tripDayId = tripDay.getId();
				plannerRepository.deleteTripPlace(tripDayId);
			}

			// 일정 다시 생성

			// dayDataList 가져오기
			List<Map<String, Object>> dayDataList = (List<Map<String, Object>>) requestBody.get("dayDataList");

			// N일차만큼 반복
			for (Map<String, Object> dayData : dayDataList) {
				Object dayIndexObj = dayData.get("dayIndex");
				int dayIndex = (dayIndexObj != null) ? Integer.parseInt(dayIndexObj.toString()) : -1;

				String startTime = (String) dayData.get("startTime");
				String endTime = (String) dayData.get("endTime");

				AvailableTime availableTime = new AvailableTime(startTime, endTime);

				List<Map<String, Object>> tripPlaceList = (List<Map<String, Object>>) dayData.get("tripPlaceIds");
				if (tripPlaceList == null)
					continue;
				List<PlacePlan> plans = new ArrayList<>();

				// N일차 장소 개수만큼 반복
				for (Map<String, Object> place : tripPlaceList) {

					Object idObj = place.get("id");
					Object durationObj = place.get("duration");

					int tripLocationId = Integer.parseInt(idObj.toString());

					TripLocation tripLocation = plannerRepository.getTripLocationById(tripLocationId);

					String duration = durationObj.toString();

					PlacePlan placePlan = new PlacePlan(tripLocation.getId(), tripLocation.getLocationName(),
							tripLocation.getAddress(), duration, tripLocation.getMapY(), tripLocation.getMapX());

					plans.add(placePlan);

				}

				// 데이터 객체에 다 담아서 chatGpt API에게 물어보기
				DailyPlan dailyPlan = new DailyPlan(availableTime, plans);
				String gptResult = chatGptService.generateOptimizedSchedule(dailyPlan, dayIndex);

				List<ChatPlanPlace> planList = gson.fromJson(gptResult, new TypeToken<List<ChatPlanPlace>>() {
				}.getType());

				Map<Integer, List<ChatPlanPlace>> groupedByDayIndex = new LinkedHashMap<>();
				for (ChatPlanPlace place : planList) {

					groupedByDayIndex.computeIfAbsent(place.getDayIndex(), k -> new ArrayList<>()).add(place);

				}

				// TripDay 업데이트
				String fixedStartTime = startTime.replace('\u00A0', ' ').trim();
				String fixedEndTime = endTime.replace('\u00A0', ' ').trim();

				DateTimeFormatter amFormatter = DateTimeFormatter.ofPattern("h:mm a", Locale.ENGLISH);

				LocalTime formattingStartTime = LocalTime.parse(fixedStartTime, amFormatter); // → 10:15
				LocalTime formattingEndTime = LocalTime.parse(fixedEndTime, amFormatter); // → 14:30

				LocalDateTime date = null;

				plannerRepository.updateTripDay(tripId, dayIndex, date, formattingStartTime, formattingEndTime);

				// chatGpt API에게 얻은 데이터를 통해 TripPlace insert
				groupedByDayIndex.forEach((day, places) -> {
					TripDay tripDay = plannerRepository.getTripDayByTripIdAndDayIndex(tripId, day);

					int tripDayId = tripDay.getId();

					for (ChatPlanPlace p : places) {
						plannerRepository.insertTripPlace(p.getId(), tripDayId, p.getStart(), p.getEnd(),
								p.getMoveDuration());
					}
				});

			}

			return ResponseEntity.ok("수정 완료");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.internalServerError().body("서버 오류 발생: " + e.getMessage());
		}

	}

	public List<TripInfo> getTripInfoByMemberId(int memberId) {
		return plannerRepository.getTripInfoByMemberId(memberId);
	}

	public List<String> getTripInfoThumbnail(int memberId) {
		return plannerRepository.getTripInfoThumbnail(memberId);
	}

}
