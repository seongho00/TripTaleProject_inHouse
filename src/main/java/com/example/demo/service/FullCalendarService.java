package com.example.demo.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.FullCalendarRepository;
import com.example.demo.vo.TripInfo;

@Service
public class FullCalendarService {

	@Autowired
	private FullCalendarRepository fullCalendarRepository;

	public List<TripInfo> getschedualeList(int memberId) {
		return fullCalendarRepository.getschedualeList(memberId);

	}

	public void updateSchedule(int id, int memberId, LocalDateTime startDate, LocalDateTime endDate) {
		fullCalendarRepository.updateSchedule(id, memberId, startDate, endDate);
	}

}
