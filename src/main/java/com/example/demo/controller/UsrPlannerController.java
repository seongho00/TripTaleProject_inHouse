package com.example.demo.controller;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.TripTaleProjectApplication;
import com.example.demo.service.ChatGptService;
import com.example.demo.service.NaverOAuthService;
import com.example.demo.service.PlannerService;
import com.example.demo.service.TripLocationService;
import com.example.demo.vo.Rq;
import com.example.demo.vo.TripDay;
import com.example.demo.vo.TripInfo;
import com.example.demo.vo.TripLocation;
import com.example.demo.vo.TripLocationPicture;
import com.example.demo.vo.TripPlace;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class UsrPlannerController {

	private final TripTaleProjectApplication tripTaleProjectApplication;

	@Autowired
	Rq rq;
	@Autowired
	private PlannerService plannerService;
	@Autowired
	private ChatGptService chatGptService;
	@Autowired
	private NaverOAuthService naverOAuthService;

	@Autowired
	private TripLocationService tripLocationService;

	UsrPlannerController(TripTaleProjectApplication tripTaleProjectApplication) {
		this.tripTaleProjectApplication = tripTaleProjectApplication;

	}

	@RequestMapping("usr/planner/calendar")
	public String calender(Model model, @RequestParam(defaultValue = "") String region) {
		if (region.equals("")) {
			return rq.replace("지역을 선택해주세요.", "../planner/region");
		}
		model.addAttribute("region", region);

		return "usr/planner/calendar";
	}

	@RequestMapping("usr/planner/showFullCalendar")
	public String showFullCalendar(Model model, int memberId) {
		model.addAttribute("memberId", memberId);
		return "usr/planner/showFullCalendar";
	}

	@RequestMapping("usr/planner/selectTime")
	public String selectTime(Model model, LocalDateTime startDate, LocalDateTime endDate,
			@RequestParam(defaultValue = "") String region) throws JsonProcessingException {
		if (region.equals("")) {
			return rq.replace("지역을 선택해주세요.", "../planner/region");
		}

		// 시작날짜, 마지막날짜 yyyy-MM-DD 형식으로 formatting
		String dateFormattedStartDate = plannerService.formatter(startDate);
		String dateFormattedEndDate = plannerService.formatter(endDate);

		// 날짜 차이를 이용해 MM/dd 형식으로 formatting
		long diffDays = ChronoUnit.DAYS.between(startDate, endDate) + 1;
		List<String> dateList = plannerService.getDateList(startDate, diffDays);

		// areaCode를 통해 장소 데이터& 사진 데이터 가져오기
		int areaCode = 3;
		String locationType = "관광지";
		List<TripLocation> tripLocations = tripLocationService.getLocationInfo(locationType, areaCode);

		// 날짜 jason으로 넘기기
		ObjectMapper mapper = new ObjectMapper();
		String dateListJson = mapper.writeValueAsString(dateList); // ["2025-06-15", "2025-06-16", ...]

		model.addAttribute("startDate", dateFormattedStartDate);
		model.addAttribute("endDate", dateFormattedEndDate);
		model.addAttribute("dateList", dateList); // ✅ 날짜 리스트 전달
		model.addAttribute("diffDays", diffDays);
		model.addAttribute("tripLocations", tripLocations);
		model.addAttribute("dateListJson", dateListJson);

		return "usr/planner/selectTime";
	}

	@RequestMapping("usr/planner/getTripLocationPicture")
	@ResponseBody
	public List<String> getTripLocationPicture(Model model, int tripLocationId) {

		List<TripLocationPicture> pictureList = tripLocationService.getTripLocationPictures(tripLocationId);
		List<String> pictureUrls = pictureList.stream().map(TripLocationPicture::getPictureUrl).toList();
		return pictureUrls;
	}

	@RequestMapping("usr/planner/region")
	public String region(Model model) {

		return "usr/planner/region";
	}

	@RequestMapping("/usr/planner/createPlan")
	public String generatePlan(@RequestParam("planData") String planDataJson, Model model, String tripRegion,
			LocalDateTime tripStartDate, LocalDateTime tripEndDate) throws IOException {

		int tripId = plannerService.createPlan(planDataJson, tripRegion, tripStartDate, tripEndDate);

		return "usr/planner/detail?tripId=" + tripId;
	}

	@RequestMapping("usr/planner/detail")
	public String detail(Model model, int tripId) {

		TripInfo tripInfo = plannerService.getTripInfoById(tripId);
		LocalDateTime startDate = tripInfo.getTripStartDate();
		LocalDateTime endDate = tripInfo.getTripEndDate();

		// yyyy-MM-dd 날짜 포멧팅
		String formattedStartDate = plannerService.formatter(startDate);
		String formattedEndDate = plannerService.formatter(endDate);
		List<TripDay> tripDays = plannerService.getTripDayById(tripId);

		// 날짜차이
		long diffDays = ChronoUnit.DAYS.between(startDate, endDate) + 1;

		// 오늘의 일정들
		List<TripPlace> todayTripPlaces = plannerService.getTripPlace(tripDays);


		int dayIndex = plannerService.getDayIndexById(tripId, tripDays);

		model.addAttribute("tripInfo", tripInfo);
		model.addAttribute("todayTripPlaces", todayTripPlaces);
		model.addAttribute("formattedStartDate", formattedStartDate);
		model.addAttribute("formattedEndDate", formattedEndDate);
		model.addAttribute("diffDays", diffDays);
		model.addAttribute("tripId", tripId);
		model.addAttribute("dayIndex", dayIndex);

		return "usr/planner/detail";
	}

	@RequestMapping("usr/planner/getTripPlace")
	@ResponseBody
	public List<TripPlace> getTripPlace(Model model, int tripId, int index) {

		List<TripPlace> tripPlaces = plannerService.getTripPlaceByClick(tripId, index);

		return tripPlaces;
	}

	@RequestMapping("usr/planner/getAllTripPlace")
	@ResponseBody
	public Map<Integer, List<TripPlace>> getAllTripPlace(Model model, int tripId) {

		List<TripPlace> tripPlaces = plannerService.getAllTripPlace(tripId);

		// dayIndex 기준으로 그룹핑
		Map<Integer, List<TripPlace>> grouped = new LinkedHashMap<>();

		for (TripPlace tripPlace : tripPlaces) {
			int dayIndex = tripPlace.getDayIndex();
			grouped.computeIfAbsent(dayIndex, k -> new ArrayList<>()).add(tripPlace);
		}

		return grouped; // 자동으로 JSON 형태로 반환됨

	}

	@RequestMapping("usr/planner/modify")
	public String modify(Model model, int tripId) {

		TripInfo tripInfo = plannerService.getTripInfoById(tripId);
		LocalDateTime startDate = tripInfo.getTripStartDate();
		LocalDateTime endDate = tripInfo.getTripEndDate();

		List<TripDay> tripDays = plannerService.getTripDayById(tripId);

		// 시작날짜, 마지막날짜 yyyy-MM-DD 형식으로 formatting
		String dateFormattedStartDate = plannerService.formatter(startDate);
		String dateFormattedEndDate = plannerService.formatter(endDate);

		// 날짜 차이를 이용해 MM/dd 형식으로 formatting
		long diffDays = ChronoUnit.DAYS.between(startDate, endDate) + 1;
		List<String> dateList = plannerService.getDateList(startDate, diffDays);

		List<TripPlace> tripPlaces = plannerService.getAllTripPlace(tripId);

		// dayIndex 기준으로 그룹핑
		Map<Integer, List<TripPlace>> grouped = new LinkedHashMap<>();

		for (TripPlace tripPlace : tripPlaces) {
			int dayIndex = tripPlace.getDayIndex();
			grouped.computeIfAbsent(dayIndex, k -> new ArrayList<>()).add(tripPlace);
		}

		// LocalTime으로 담기
		List<LocalTime> durations = new ArrayList<>();

		for (TripPlace tp : tripPlaces) {
			if (tp.getStartTime() != null && tp.getEndTime() != null) {
				Duration duration = Duration.between(tp.getStartTime(), tp.getEndTime());
				LocalTime durTime = LocalTime.MIDNIGHT.plus(duration); // 00:00 기준으로 더해서 LocalTime으로 만들기
				durations.add(durTime);
			}
		}

		// areaCode를 통해 장소 데이터& 사진 데이터 가져오기
		int areaCode = 3;
		String locationType = "관광지";
		List<TripLocation> tripLocations = tripLocationService.getLocationInfo(locationType, areaCode);

		model.addAttribute("tripInfo", tripInfo);
		model.addAttribute("tripLocations", tripLocations);
		model.addAttribute("startDate", dateFormattedStartDate);
		model.addAttribute("endDate", dateFormattedEndDate);
		model.addAttribute("groupedTripPlaces", grouped);
		model.addAttribute("dateList", dateList);
		model.addAttribute("tripDays", tripDays);
		model.addAttribute("durations", durations);

		return "usr/planner/modify";
	}

	@RequestMapping("usr/planner/updateTripPlaces")
	public void updateTripPlaces(Model model, @RequestBody Map<String, Object> requestBody) {

		plannerService.updateTripPlaces(requestBody);
	}

	@RequestMapping("usr/planner/search")
	@ResponseBody
	public String search(Model model, int tripId, String keyword, String source) {


		if (source.equals("추천")) {

		} else if (source.equals("검색")) {

			naverOAuthService.searchLocal(keyword);
		} else if (source.equals("장바구니")) {

		}

		return "";
	}

}
