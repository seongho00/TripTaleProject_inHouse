package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.TripLocation;

@Mapper
public interface TripLocationRepository {
	public void insertData(int areaCode, String title, String profile, String address, String number, String schedule,
			String star, int reviewCount);

	public int getLastInsertId();

	public List<TripLocation> getLocationInfo(int locationTypeId, int areaCode);
}
