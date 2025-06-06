package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TripInfo {

	private int id;
	private String regDate;
	private String updateDate;
	private String tripName;
	private String tripRegion;
	private String tripStartDate;
	private String tripEndDate;
	private int memberId;

}