package com.example.demo.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.TripInfo;

@Mapper
public interface FullCalendarRepository {

	public List<TripInfo> getschedualeList(int memberId);

	public void updateSchedule(int id, int memberId, LocalDateTime startDate, LocalDateTime endDate);

}
