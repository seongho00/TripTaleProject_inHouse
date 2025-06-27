package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.TripLocation;
import com.example.demo.vo.TripLocationPicture;

@Mapper
public interface TripLocationRepository {
	public void insertData(int areaCode, String title, String profile, String address, String number, String schedule,
			String star, int reviewCount, double mapX, double mapY);

	public int getLastInsertId();

	public List<TripLocation> getLocationInfo(String locationTypeCode, int areaCode);

	public List<TripLocationPicture> getTripLocationPictures(int tripLocationId);
}
