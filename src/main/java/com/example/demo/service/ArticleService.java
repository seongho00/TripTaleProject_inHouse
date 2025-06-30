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

	public Article getArticleById(int articleId) {
		return articleRepository.getArticleById(articleId);

	}

	public void addArticleImage(int articleId, String fileName, String contentType, byte[] data) {

		articleRepository.addArticleImage(articleId, fileName, contentType, data);
	}

	public int doWrite(int memberId, String title, String body, int tripId) {
		articleRepository.doWrite(memberId, title, body, tripId);
		return articleRepository.getLastInsertId();
	}

	public List<ArticleImage> getArticlePictures(int articleId) {

		return articleRepository.getArticlePictures(articleId);
	}

	public List<Article> getArticleByFilterAndKeyword(String filter, String keyword) {

		return articleRepository.getArticleByFilterAndKeyword(filter, keyword);
	}

	public List<Article> getAllArticles() {

		return articleRepository.getAllArticles();
	}

	public List<Article> getArticleByMemberId(int memberId) {
		return articleRepository.getArticleByMemberId(memberId);

	}

	public void updateArticle(int articleId, String title, String body) {

		articleRepository.updateArticle(articleId, title, body);
	}

	public void deleteArticle(int articleId) {
		articleRepository.deleteArticle(articleId);

	}

	public int getLikeCount(int articleId) {

		return articleRepository.getLikeCount(articleId);
	}

	public boolean getLikeCountByArticleIdAndMemberId(int articleId, int memberId) {

		int likeCount = articleRepository.getLikeCountByArticleIdAndMemberId(articleId, memberId);

		return likeCount != 0;
	}

	public void increseLikeCount(int articleId, int memberId) {
		articleRepository.increseLikeCount(articleId, memberId);

	}

	public void decreseLikeCount(int articleId, int memberId) {
		articleRepository.decreseLikeCount(articleId, memberId);

	}

	public void deleteArticleImage(int articleId) {
		articleRepository.deleteArticleImage(articleId);

	}

	public void updateArticleImages(int articleId, List<String> existingFileNames) {
		// DB에 저장된 기존 이미지 목록
		List<String> savedFileNames = articleRepository.getImageFileNamesByArticleId(articleId);

		// 삭제 대상 이미지 = 기존에 있던 것 중, 클라이언트가 보내지 않은 것
		for (String savedFileName : savedFileNames) {
			if (existingFileNames == null || !existingFileNames.contains(savedFileName)) {
				articleRepository.deleteArticleImageByFileName(articleId, savedFileName);
			}
		}

	}

	public ArticleImage getArticleImage(int articleId) {

		return articleRepository.getArticleImage(articleId);
	}

	public void addArticleHitCount(int articleId) {
		articleRepository.addArticleHitCount(articleId);
		
	}

}
