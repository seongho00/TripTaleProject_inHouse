package com.example.demo.repository;

import java.time.LocalDateTime;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.TripInfo;

@Mapper
public interface PlannerRepository {

	public int getLastInsertId();

	public void createPlan(String tripRegion, LocalDateTime tripStartDate, LocalDateTime tripEndDate, int memberId);

	public void insertTripDay(int tripId, int dayIndex, String date, String startTime, String endTime);

	public TripInfo getTripInfoById(int id);

}
