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

	private String resultcode;

	private String message;

	private Object response;
	private NaverUserDetail naverUserDetail;

	@Getter
	@NoArgsConstructor
	@AllArgsConstructor
	public static class NaverUserDetail {
		@JsonProperty("id")
		private String id;
		@JsonProperty("nickname")
		private String nickname;
		@JsonProperty("profile_image")
		private String profile_image;
		@JsonProperty("name")
		private String name;
		@JsonProperty("email")
		private String email;
		@JsonProperty("birthyear")
		private String birthyear;
	}
}
