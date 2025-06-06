package com.example.demo.vo;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TripLocation {

	private int id;
	private String regDate;
	private String updateDate;
	private String locationName;
	private int locationTypeId;
	private String address;
	private String scheduleInfo;
	private String numberInfo;
	private String profile;
	private String star;
	private int reviewCount;

}