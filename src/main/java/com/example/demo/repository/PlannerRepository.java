package com.example.demo.repository;

import java.time.LocalDateTime;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PlannerRepository {

	public int getLastInsertId();

	public void createPlan(String tripRegion, LocalDateTime tripStartDate, LocalDateTime tripEndDate, int memberId);

	public void insertTripDay(int tripId, int dayIndex, String date, String startTime, String endTime);

}
