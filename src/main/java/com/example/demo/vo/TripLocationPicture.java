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
public class TripLocationPicture {

	private int id;
	private String regDate;
	private String updateDate;
	private String pictureUrl;
	private int tripLocationId;

}