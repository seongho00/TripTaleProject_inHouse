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
public class MemberImage {

	private int id;
	private int memberId;
	private String fileName;

	@Lob
	private byte[] data;
}