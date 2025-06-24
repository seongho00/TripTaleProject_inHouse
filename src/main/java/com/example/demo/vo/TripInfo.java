package com.example.demo.vo;

import java.time.LocalDateTime;

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
	private LocalDateTime tripStartDate;
	private LocalDateTime tripEndDate;
	private int memberId;
	
	private String formattedStartDate; // 👉 새 필드 추가
	private String formattedEndDate; // 👉 새 필드 추가

}