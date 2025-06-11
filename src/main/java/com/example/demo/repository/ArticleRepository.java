package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Article;

@Mapper
public interface ArticleRepository {

	public Article getArticle();

	public void addArticleImage(int articleId, String fileName, String contentType, byte[] data);

	public void doWrite(int memberId, String title, String body);

	public int getLastInsertId();

}
