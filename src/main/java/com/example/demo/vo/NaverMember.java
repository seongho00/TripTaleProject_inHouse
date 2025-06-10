package com.example.demo.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class NaverMember {

	private String id;
	private String regDate;
	private String updateDate;
	private String name;
	private String email;
	private String profileImage;
	private int delStatus;
	private String delDate;
	private int authLevel;
}
