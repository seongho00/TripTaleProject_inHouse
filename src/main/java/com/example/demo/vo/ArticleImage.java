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
public class ArticleImage {

	private int id;
	private int articleId;
	private String fileName;
	private String contentType;

	@Lob
	private byte[] data;
}