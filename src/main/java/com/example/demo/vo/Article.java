package com.example.demo.vo;

import jakarta.persistence.Lob;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Article {

	private int id;
	private String regDate;
	private String updateDate;
	private String title;
	private String body;
	private String tripRegion;

	private String extra__name;
	private String extra__contentType;

	@Lob
	private byte[] extra__thumbnailImg;

}