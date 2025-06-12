package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class NaverLocationInfo {

	private String title;
	private String link;
	private String category;
	private String description;
	private String telephone;
	private String address;
	private String roadAddress;
	private String mapx;
	private String mapy;

}