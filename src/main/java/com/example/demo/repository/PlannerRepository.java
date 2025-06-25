package com.example.demo.repository;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.TripDay;
import com.example.demo.vo.TripInfo;
import com.example.demo.vo.TripLocation;
import com.example.demo.vo.TripPlace;

@Mapper
public interface PlannerRepository {

	public int getLastInsertId();

	public void createPlan(String tripName, String tripRegion, LocalDateTime tripStartDate, LocalDateTime tripEndDate, int memberId);

	public void insertTripDay(int tripId, int dayIndex, String date, LocalTime startTime, LocalTime endTime);

	public TripInfo getTripInfoById(int tripId);

	public List<TripDay> getTripDayById(int tripId);

	public List<TripPlace> getTripPlaceById(int tripDayId);

	public List<TripPlace> getTripPlaceByClick(int tripId, int index);

	public List<TripPlace> getAllTripPlace(int tripId);

	public void insertTripPlace(Long id, int tripDayId, String startTime, String endTime, String moveDuration);

	public TripLocation getTripLocationById(int tripLocationId);

	public TripPlace getTripPlaceByTripPlaceId(int tripPlaceId);

	public TripDay getTripDayByTripIdAndDayIndex(int tripId, int dayIndex);

	public void updateTripDay(int tripId, int dayIndex, LocalDateTime date, LocalTime startTime,
			LocalTime endTime);

	public void deleteTripPlace(int tripDayId);

	public List<TripInfo> getTripInfoByMemberId(int memberId);

	public List<String> getTripInfoThumbnail(int memberId);


}
