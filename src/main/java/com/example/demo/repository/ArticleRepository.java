package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Article;
import com.example.demo.vo.ArticleImage;

@Mapper
public interface ArticleRepository {

	public Article getArticleById(int articleId);

	public void addArticleImage(int articleId, String fileName, String contentType, byte[] data);

	public void doWrite(int memberId, String title, String body, int tripId);

	public int getLastInsertId();

	public List<ArticleImage> getArticlePictures(int articleId);

	public List<Article> getArticleByFilterAndKeyword(String filter, String keyword);

	public List<Article> getAllArticles();

	public List<Article> getArticleByMemberId(int memberId);

	public void updateArticle(int articleId, String title, String body);

	public void deleteArticle(int articleId);

}
