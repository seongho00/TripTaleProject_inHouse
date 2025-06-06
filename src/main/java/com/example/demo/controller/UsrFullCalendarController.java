package com.example.demo.controller;

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.TripTaleProjectApplication;
import com.example.demo.service.FullCalendarService;
import com.example.demo.vo.Rq;
import com.example.demo.vo.TripInfo;

@Controller
public class UsrFullCalendarController {

	private final TripTaleProjectApplication tripTaleProjectApplication;

	@Autowired
	FullCalendarService fullCalendarService;
	@Autowired
	Rq rq;

	UsrFullCalendarController(TripTaleProjectApplication tripTaleProjectApplication) {
		this.tripTaleProjectApplication = tripTaleProjectApplication;

	}

	@RequestMapping("/fullCalendar/showScheduleList")
	@ResponseBody
	public List<Map<String, Object>> scheduleList(Model model, int memberId) {

		List<Map<String, Object>> schedualeList = new ArrayList<>();

		List<TripInfo> fullCalendarList = fullCalendarService.getschedualeList(memberId);

		for (TripInfo fullCalendar : fullCalendarList) {
			Map<String, Object> scheduale = new HashMap<>();
			scheduale.put("id", fullCalendar.getId());
			scheduale.put("title", fullCalendar.getTripName());
			scheduale.put("start", fullCalendar.getTripStartDate());
			scheduale.put("end", fullCalendar.getTripEndDate());
			schedualeList.add(scheduale);
		}

		return schedualeList;
	}

	@RequestMapping("/fullCalendar/updateSchedule")
	@ResponseBody
	public String updateSchedule(Model model, int id, int memberId, String startDate, String endDate) {

		LocalDateTime startLocalDate = OffsetDateTime.parse(startDate).toLocalDateTime();
		LocalDateTime endLocalDate = OffsetDateTime.parse(endDate).toLocalDateTime();
		fullCalendarService.updateSchedule(id, memberId, startLocalDate, endLocalDate);
		return "";
	}

}
