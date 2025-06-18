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
public class TripDay {
	private int id;
	private int tripId;
	private int dayIndex;
	private LocalDateTime date;
	private String startTime;
	private String endTime;
}