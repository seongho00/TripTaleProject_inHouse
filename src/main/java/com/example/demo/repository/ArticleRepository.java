package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Article;
import com.example.demo.vo.ArticleImage;

@Mapper
public interface ArticleRepository {

	public Article getArticle(int articleId);

	public void addArticleImage(int articleId, String fileName, String contentType, byte[] data);

	public void doWrite(int memberId, String title, String body);

	public int getLastInsertId();

	public List<ArticleImage> getArticlePictures(int articleId);

}
