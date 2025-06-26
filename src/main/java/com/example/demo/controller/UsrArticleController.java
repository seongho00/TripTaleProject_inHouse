package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.TripTaleProjectApplication;
import com.example.demo.service.ArticleService;
import com.example.demo.service.ChatGptService;
import com.example.demo.service.PlannerService;
import com.example.demo.vo.Article;
import com.example.demo.vo.ArticleImage;
import com.example.demo.vo.Rq;
import com.example.demo.vo.TripInfo;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrArticleController {

	private final TripTaleProjectApplication tripTaleProjectApplication;

	@Autowired
	Rq rq;

	@Autowired
	private ChatGptService chatGptService;
	@Autowired
	private ArticleService articleService;
	@Autowired
	private PlannerService plannerService;

	UsrArticleController(TripTaleProjectApplication tripTaleProjectApplication) {
		this.tripTaleProjectApplication = tripTaleProjectApplication;

	}

	@RequestMapping("usr/article/list")

	public String list(Model model) {

		List<Article> articles = articleService.getAllArticles();

		List<String> articleImages = new ArrayList<>();
		for (Article article : articles) {
			String base64 = Base64.getEncoder().encodeToString(article.getExtra__thumbnailImg());
			String fullDataUrl = "data:" + article.getExtra__contentType() + ";base64," + base64;
			articleImages.add(fullDataUrl);
		}

		model.addAttribute("articles", articles);
		model.addAttribute("articleImages", articleImages);

		return "usr/article/list";
	}

	@RequestMapping("usr/article/writeByAI")
	public String writeByAI(Model model, int tripId) {

		TripInfo tripInfo = plannerService.getTripInfoById(tripId);

		// 시작날짜, 마지막날짜 yyyy-MM-DD 형식으로 formatting
		String dateFormattedStartDate = plannerService.formatter(tripInfo.getTripStartDate());
		String dateFormattedEndDate = plannerService.formatter(tripInfo.getTripEndDate());

		model.addAttribute("tripInfo", tripInfo);
		model.addAttribute("startDate", dateFormattedStartDate);
		model.addAttribute("endDate", dateFormattedEndDate);

		return "usr/article/writeByAI";
	}

	@RequestMapping("usr/article/doWriteByAI")
	public String doWrite(Model model, @RequestParam("selectedMoods[]") List<String> moods, List<MultipartFile> images,
			String tripRegion, String title, int tripId) throws IOException {

		int memberId = rq.getLoginedMemberId();

		String body = chatGptService.askQuestion(moods, images, tripRegion);

		int articleId = articleService.doWrite(memberId, title, body, tripId);

		for (MultipartFile image : images) {
			if (!image.isEmpty()) {
				String fileName = image.getOriginalFilename();
				String contentType = image.getContentType();
				byte[] data = image.getBytes();

				articleService.addArticleImage(articleId, fileName, contentType, data);
			}
		}

		return "redirect:detail?articleId=" + articleId;
	}

	@RequestMapping("usr/article/write")
	public String write(Model model) {

		return "usr/article/write";
	}

	@RequestMapping("usr/article/detail")
	public String detail(Model model, int articleId) {

		// 게시글 제목, 내용 등 가져오기
		Article article = articleService.getArticleById(articleId);

		// tripId 가져오기
		int tripId = article.getTripId();

		// TripInfo 가져오기
		TripInfo tripInfo = plannerService.getTripInfoById(tripId);

		String dateFormattedStartDate = plannerService.formatter(tripInfo.getTripStartDate());
		String dateFormattedEndDate = plannerService.formatter(tripInfo.getTripEndDate());

		// 게시글 사진 가져오기
		List<ArticleImage> articleImages = articleService.getArticlePictures(articleId);

		// Base64 인코딩된 이미지 리스트 생성
		List<String> base64Images = new ArrayList<>();
		for (ArticleImage img : articleImages) {
			String base64 = Base64.getEncoder().encodeToString(img.getData());
			String fullDataUrl = "data:" + img.getContentType() + ";base64," + base64;
			base64Images.add(fullDataUrl);
		}

		model.addAttribute("article", article);
		model.addAttribute("articleImages", base64Images);
		model.addAttribute("startDate", dateFormattedStartDate);
		model.addAttribute("endDate", dateFormattedEndDate);

		return "usr/article/detail";
	}

	@RequestMapping("usr/article/searchKeyword")
	@ResponseBody
	public Map<String, Object> searchword(Model model, String filter, String keyword) {

		List<Article> articles = articleService.getArticleByFilterAndKeyword(filter, keyword);

		List<String> articleImages = new ArrayList<>();
		for (Article article : articles) {
			String base64 = Base64.getEncoder().encodeToString(article.getExtra__thumbnailImg());
			String fullDataUrl = "data:" + article.getExtra__contentType() + ";base64," + base64;
			articleImages.add(fullDataUrl);
		}

		Map<String, Object> response = new HashMap<>();
		response.put("articles", articles);
		response.put("articleImages", articleImages);

		return response;
	}

	@RequestMapping("usr/article/modify")
	public String modify(Model model, int articleId) {

		Article article = articleService.getArticleById(articleId);
		List<ArticleImage> articleImages = articleService.getArticlePictures(articleId);

		model.addAttribute("article", article);
		model.addAttribute("articleImages", articleImages);
		System.out.println(article);

		return "usr/article/modify";
	}

	@RequestMapping("usr/article/fileUpload")
	@ResponseBody
	public Map<String, Object> uploadImage(@RequestParam("file") MultipartFile file, HttpServletRequest request) {
		Map<String, Object> result = new HashMap<>();

		if (file.isEmpty()) {
			result.put("error", "파일이 비어 있습니다.");
			return result;
		}

		try {
			// 저장 경로 설정 (예: /upload)
			String uploadDir = request.getServletContext().getRealPath("/upload");
			File dir = new File(uploadDir);
			if (!dir.exists()) {
				dir.mkdirs();
			}

			// 저장할 파일 이름 설정 (UUID로 중복 방지)
			String uuid = UUID.randomUUID().toString();
			String originalFilename = file.getOriginalFilename();
			String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
			String savedFilename = uuid + extension;

			// 파일 저장
			File savedFile = new File(dir, savedFilename);
			file.transferTo(savedFile);

			// 클라이언트에 제공할 이미지 경로
			String fileUrl = "/upload/" + savedFilename;

			result.put("url", fileUrl);
			return result;

		} catch (IOException e) {
			result.put("error", "파일 업로드 실패");
			return result;
		}
	}

	@PostMapping("/usr/article/doModify")
	public String doModify(int articleId, String title, String body) {

		articleService.updateArticle(articleId, title, body);

		return "redirect:detail?articleId=" + articleId;
	}

}
