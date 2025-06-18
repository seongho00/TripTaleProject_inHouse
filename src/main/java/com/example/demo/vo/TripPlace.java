package com.example.demo.vo;

import java.time.LocalTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TripPlace {

	private int id;
	private int tripLocationId;
	private int tripDayId;
	private LocalTime startTime;
	private LocalTime endTime;
	
	private String locationName;
	private int locationTypeId;
	private String address;
	private String schedule;
	private String number;
	private String profile;
	private String star;
	private int reviewCount;
	private int areaCode;
	private double mapX; 
	private double mapY;
	
	private int dayIndex;
	
	private String extra__pictureUrl;
    private String extra__locationType;

}