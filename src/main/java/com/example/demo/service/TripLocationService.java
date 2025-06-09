package com.example.demo.service;

import java.time.Duration;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.TripLocationPictureRepository;
import com.example.demo.repository.TripLocationRepository;

@Service
public class TripLocationService {

	private final KakaoOAuthService kakaoOAuthService;

	@Autowired
	private TripLocationRepository tripLocationRepository;
	@Autowired
	private TripLocationPictureRepository tripLocationPictureRepository;

	public TripLocationService(TripLocationRepository tripLocationRepository, KakaoOAuthService kakaoOAuthService) {
		this.tripLocationRepository = tripLocationRepository;
		this.kakaoOAuthService = kakaoOAuthService;
	}

	private WebDriver driver;

	public void process(String keyword, int areaCode) {
		String url = "https://map.naver.com/v5/search/" + keyword;
		// 크롬 드라이버 세팅 (드라이버 설치 경로 입력)
		System.setProperty("webdriver.chrome.driver", "C:\\Spring\\chromedriver-win64\\chromedriver.exe");

		ChromeOptions options = new ChromeOptions();
		options.addArguments("--remote-allow-origins=*");

		// 브라우저 선택
		driver = new ChromeDriver(options);
		driver.get("https://www.google.com");

		getDataList(url, areaCode);

		// 탭 닫기
		driver.close();
		// 브라우저 닫기
		driver.quit();
	}

	// 데이터 가져오기
	private void getDataList(String url, int areaCode) {
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
		// (1) 브라우저에서 url로 이동한다.
		driver.get(url);
		// 브라우저 로딩될 때까지 잠시 기다린다.
		driver.manage().timeouts().implicitlyWait(Duration.ofMillis(1000));

		// (2) 검색결과 iframe으로 frame을 바꾼다.
		try {
			// iframe이 로드될 때까지 대기
			WebElement iframe = wait
					.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("iframe#searchIframe")));
			driver.switchTo().frame(iframe);

			// 검색 결과 장소 목록을 elements에 담는다.
			List<WebElement> elements = driver.findElements(By.cssSelector(".ApCpt>.place_bluelink"));

			// (3) 첫번째 검색결과를 클릭한다.
			elements.get(0).click();

			// 요소가 로드될 때까지 기다린다.
			driver.manage().timeouts().implicitlyWait(Duration.ofMillis(500));

			// 현재 프레임에서 상위 프레임으로 이동한다.
			driver.switchTo().defaultContent();

		} catch (Exception e) {
			List<WebElement> buttonDivs = driver.findElements(By.className("end_inner"));
			for (WebElement buttonDiv : buttonDivs) {
				String text = buttonDiv.findElement(By.className("title")).getText();
				if (text.equals("이 주소의 장소")) {

					List<WebElement> buttons = buttonDiv.findElements(By.className("item_space"));
					buttons.get(0).click();
					break;
				}
			}

		}

		driver.switchTo().defaultContent();

		driver.manage().timeouts().implicitlyWait(Duration.ofMillis(3000));
		// (4) 상세정보가 나오는 프레임으로 이동한다.
		
		WebElement iframe = wait
				.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("iframe#entryIframe")));
		driver.switchTo().frame(iframe);

		String schedule = "";

		// "일정" 버튼 요소를 찾아 클릭한다.
		try {
			WebElement scheduleButton = driver.findElement(By.className("vI8SM"));
			scheduleButton.click();

			List<WebElement> scheduleInfos = driver.findElements(By.className("A_cdD"));

			for (WebElement scheduleInfo : scheduleInfos) {
				schedule += scheduleInfo.getText() + "\n";
			}
		} catch (Exception e) {
			System.out.println("일정 정보 없음");
			schedule = "일정 정보 없음";
		}

		// (6) 로딩될때까지 기다렸다가 "주소" 버튼 요소를 찾아 클릭한다.
		WebElement addressButton = wait.until(ExpectedConditions.presenceOfElementLocated(By.className("LDgIH")));
		addressButton.click();

		// (7) 주소 정보가 들어있는 div 요소를 찾아서, 해당 정보를 가져온다.
		WebElement addressSpan = driver.findElement(By.className("LDgIH"));
		String address = addressSpan.getText();

		// "이름" 정보가 들어있는 div 요소 찾기
		WebElement titleDiv = driver.findElement(By.className("LylZZ"));

		// title div 아래에 있는 span 태그들을 가져와 직접적인 정보 얻기
		List<WebElement> titleInfos = titleDiv.findElements(By.tagName("span"));
		String title = titleInfos.get(0).getText();
		String number = "";
		try {
			// 전화번호 정보가 담겨있는 span 요소 찾기
			WebElement numberSpan = driver.findElement(By.className("xlx7Q"));
			number = numberSpan.getText();

		} catch (Exception e) {
			System.out.println("번호 정보 없음");
			number = "번호 정보 없음";
		}

		// 별점 정보가 담겨있는 span 요소찾기
		String star = "";
		try {
			WebElement starSpan = driver.findElement(By.className("LXIwF"));
			WebElement starType = starSpan.findElement(By.tagName("span"));
			star = starSpan.getText().replace(starType.getText(), "").trim();
		} catch (Exception e) {
			System.out.println("별점 정보 없음");
			star = "별점 정보 없음";
		}
		int reviewCount = 0;
		// 리뷰 정보가 담겨있는 span 요소찾기
		try {
			List<WebElement> reviewSpans = driver.findElements(By.className("PXMot"));
			int visitReviewCount = 0;
			int vlogReviewCount = 0;
			for (WebElement reviewSpan : reviewSpans) {

				if (reviewSpan.getText().contains("방문자 리뷰")) {
					String visitReview = reviewSpan.getText().replace("방문자 리뷰", "").trim();
					visitReviewCount = Integer.parseInt(visitReview.replace(",", ""));
				} else if (reviewSpan.getText().contains("블로그 리뷰")) {
					String vlogReview = reviewSpan.getText().replace("블로그 리뷰", "").trim();
					vlogReviewCount = Integer.parseInt(vlogReview.replace(",", ""));
				}
			}

			reviewCount = visitReviewCount + vlogReviewCount;

		} catch (Exception e) {
			System.out.println("리뷰 정보 없음");
			reviewCount = 0;
		}

		// 소개글 정보 span 요소 찾기
		List<WebElement> profileSpans = driver.findElements(By.className("veBoZ"));
		String profile = "";
		try {
			for (WebElement profileSpan : profileSpans) {
				String text = profileSpan.getText();
				if (text.equals("정보")) {
					profileSpan.click();
					profile = driver.findElement(By.className("T8RFa")).getText();
				}
			}
		} catch (Exception e) {
			System.out.println(e + "소개글 정보 없음");
			profile = "소개글 정보 없음";
		}
		tripLocationRepository.insertData(areaCode, title, profile, address, number, schedule, star, reviewCount);
		int id = tripLocationRepository.getLastInsertId();

		// 사진 정보 요소 찾기 (6개정도)
		try {
			for (WebElement profileSpan : profileSpans) {
				String text = profileSpan.getText();
				if (text.equals("사진")) {
					profileSpan.click();
					WebElement photoDiv = driver.findElement(By.className("Nd2nM"));
					List<WebElement> photos = photoDiv.findElements(By.className("place_thumb"));
					int count = photos.size() > 6 ? 6 : photos.size();

					for (int i = 0; i < count; i++) {
						WebElement photoImg = photos.get(i).findElement(By.tagName("img"));
						String photoUrl = photoImg.getAttribute("src");
						tripLocationPictureRepository.insertPicture(photoUrl, id);

					}
				}
			}
		} catch (Exception e) {
			System.out.println(e + "사진 정보 없음");
			profile = "사진 정보 없음";
		}

	}

}
