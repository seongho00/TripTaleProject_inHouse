package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class tripDay {
	private int id;
	private int tripId;
	private int dayIndex;
	private String date;
	private String startTime;
	private String endTime;
}