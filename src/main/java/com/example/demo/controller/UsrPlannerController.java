package com.example.demo.controller;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.TripTaleProjectApplication;
import com.example.demo.service.PlannerService;
import com.example.demo.service.TripLocationService;
import com.example.demo.vo.Rq;
import com.example.demo.vo.TripLocation;

@Controller
public class UsrPlannerController {

	private final TripTaleProjectApplication tripTaleProjectApplication;

	@Autowired
	Rq rq;
	@Autowired
	private PlannerService plannerService;
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
			@RequestParam(defaultValue = "") String region) {
		if (region.equals("")) {
			return rq.replace("지역을 선택해주세요.", "../planner/region");
		}

		// 시작날짜, 마지막날짜 formatting
		String dateFormattedStartDate = plannerService.formatter(startDate);
		String dateFormattedEndDate = plannerService.formatter(endDate);

		// 날짜 차이를 이용해 MM/dd 형식으로 formatting
		long diffDays = ChronoUnit.DAYS.between(startDate, endDate) + 1;
		List<String> dateList = plannerService.getDateList(startDate, diffDays);

		// areaCode를 통해 장소 데이터& 사진 데이터 가져오기
		int areaCode = 3;
		int locationTypeId = 1;
		List<TripLocation> tripLocations = tripLocationService.getLocationInfo(locationTypeId, areaCode);
		// tripLocationPicture 가져오기
//		tripLocationService.getLocationPicuture();
//		System.out.println(tripLocations);

		model.addAttribute("startDate", dateFormattedStartDate);
		model.addAttribute("endDate", dateFormattedEndDate);
		model.addAttribute("dateList", dateList); // ✅ 날짜 리스트 전달
		model.addAttribute("diffDays", diffDays);
		model.addAttribute("tripLocations", tripLocations);

		return "usr/planner/selectTime";
	}

	@RequestMapping("usr/planner/region")
	public String region(Model model) {

		return "usr/planner/region";
	}

}
