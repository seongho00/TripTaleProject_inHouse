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
public class Member {

	private int id;
	private String provider;
	private String providerId;
	private String regDate;
	private String updateDate;
	private String loginPw;
	private String name;
	private String email;
	private int delStatus;
	private String delDate;
	private int authLevel;
	
	@Lob
	private byte[] extra__data;

}