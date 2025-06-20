package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PlacePlan {
	private int id;
	private String name;
	private String address;
	private String duration;
	private double lat;
	private double lng;

}
