package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.ArticleRepository;
import com.example.demo.vo.Article;
import com.example.demo.vo.ArticleImage;

@Service
public class ArticleService {

	@Autowired
	private ArticleRepository articleRepository;

	public ArticleService(ArticleRepository articleRepository) {
		this.articleRepository = articleRepository;
	}

	public Article getArticle(int articleId) {
		return articleRepository.getArticle(articleId);

	}

	public void addArticleImage(int articleId, String fileName, String contentType, byte[] data) {

		articleRepository.addArticleImage(articleId, fileName, contentType, data);
	}

	public int doWrite(int memberId, String title, String body) {
		articleRepository.doWrite(memberId, title, body);
		return articleRepository.getLastInsertId();
	}

	public List<ArticleImage> getArticlePictures(int articleId) {

		return articleRepository.getArticlePictures(articleId);
	}

}
