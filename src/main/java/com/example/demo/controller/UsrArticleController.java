package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.TripTaleProjectApplication;
import com.example.demo.service.ChatGptService;
import com.example.demo.vo.Rq;

@Controller
public class UsrArticleController {

	private final TripTaleProjectApplication tripTaleProjectApplication;

	@Autowired
	Rq rq;

	@Autowired
	ChatGptService chatGptService;

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

	@RequestMapping("usr/article/write")
	public String write(Model model) {

		return "usr/article/write";
	}

	@RequestMapping("usr/article/doWrite")
	@ResponseBody
	public List<String> doWrite(Model model, @RequestParam(defaultValue = "") List<String> moods,
			List<MultipartFile> images) {

		for (MultipartFile image : images) {
			if (!image.isEmpty()) {
				String originalFilename = image.getOriginalFilename();
				// 저장 또는 처리 로직
				System.out.println("파일 이름: " + originalFilename);
			}
		}

		chatGptService.askQuestion(moods);

		return moods;
	}

}
