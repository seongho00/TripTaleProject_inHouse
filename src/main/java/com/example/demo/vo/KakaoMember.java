package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class KakaoMember {

	private String id;
	private String regDate;
	private String updateDate;
	private String nickname;
	private String email;
	private String profileImage;
	private int delStatus;
	private String delDate;
	private int authLevel;

}