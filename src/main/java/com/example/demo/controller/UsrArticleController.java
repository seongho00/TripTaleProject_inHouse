package com.example.demo.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.TripTaleProjectApplication;
import com.example.demo.service.ArticleService;
import com.example.demo.service.ChatGptService;
import com.example.demo.vo.Article;
import com.example.demo.vo.ArticleImage;
import com.example.demo.vo.Rq;

@Controller
public class UsrArticleController {

	private final TripTaleProjectApplication tripTaleProjectApplication;

	@Autowired
	Rq rq;

	@Autowired
	ChatGptService chatGptService;
	@Autowired
	ArticleService articleService;

	UsrArticleController(TripTaleProjectApplication tripTaleProjectApplication) {
		this.tripTaleProjectApplication = tripTaleProjectApplication;

	}

	@RequestMapping("usr/article/list")
	public String list(Model model) {

		return "usr/article/list";
	}

	@RequestMapping("usr/article/writeByAI")
	public String writeByAI(Model model) {

		return "usr/article/writeByAI";
	}

	@RequestMapping("usr/article/doWriteByAI")
	@ResponseBody
	public List<String> doWrite(Model model, @RequestParam("selectedMoods[]") List<String> moods,
			List<MultipartFile> images) throws IOException {

		int memberId = rq.getLoginedMemberId();
		String title = "";
		String body = chatGptService.askQuestion(moods, images);
		
		System.out.println(body);
		int articleId = articleService.doWrite(memberId, title, body);

		for (MultipartFile image : images) {
			if (!image.isEmpty()) {
				String fileName = image.getOriginalFilename();
				String contentType = image.getContentType();
				byte[] data = image.getBytes();

				articleService.addArticleImage(articleId, fileName, contentType, data);
			}
		}

		return moods;
	}

	@RequestMapping("usr/article/write")
	public String write(Model model) {

		return "usr/article/write";
	}

	@RequestMapping("usr/article/doWrite")
	public String doWrite(Model model, String title, String body, List<MultipartFile> images) throws IOException {

		int memberId = rq.getLoginedMemberId();

		int articleId = articleService.doWrite(memberId, title, body);

		for (MultipartFile image : images) {
			if (!image.isEmpty()) {
				String fileName = image.getOriginalFilename();
				String contentType = image.getContentType();
				byte[] data = image.getBytes();

				articleService.addArticleImage(articleId, fileName, contentType, data);
			}
		}

		return "usr/article/list";
	}
	
	@RequestMapping("usr/article/detail")
	public String detail(Model model, int articleId) {
		
		// 게시글 제목, 내용 등 가져오기
		Article article = articleService.getArticle(articleId);
		
		// 게시글 사진 가져오기
		List<ArticleImage> articleImages = articleService.getArticlePictures(articleId);
		
		 // Base64 인코딩된 이미지 리스트 생성
	    List<String> base64Images = new ArrayList<>();
	    for (ArticleImage img : articleImages) {
	        String base64 = Base64.getEncoder().encodeToString(img.getData());
	        String fullDataUrl = "data:" + img.getContentType() + ";base64," + base64;
	        base64Images.add(fullDataUrl);
	    }
	    
	    System.out.println(article);
		model.addAttribute("article", article);
		model.addAttribute("articleImages", base64Images);
		
		return "usr/article/detail";
	}

}
