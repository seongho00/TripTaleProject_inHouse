package com.example.demo.controller;

import java.io.IOException;
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
	public List<String> doWrite(Model model, @RequestParam(defaultValue = "") List<String> moods,
			List<MultipartFile> images) throws IOException {

		int memberId = rq.getLoginedMemberId();
		String title = "";
		String body = chatGptService.askQuestion(moods);

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

}
