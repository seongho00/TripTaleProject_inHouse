<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="ARTICLE DETAIL" />
<%@ include file="../common/head.jspf"%>

<script
	src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script>

document.addEventListener("DOMContentLoaded", function () {
    const swiper = new Swiper(".swiper", {
      slidesPerView: 5,
      spaceBetween: 0,
      centeredSlides: true,
      loop: true,
      simulateTouch: 'ontouchstart' in window || navigator.maxTouchPoints > 0,
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev",
      },
    });

    // 높이 계산도 여기서 실행
    const calculateHeight = () => {
      const swiperSlideElements = Array.from(document.querySelectorAll('.swiper .swiper-slide'));
      if (!swiperSlideElements.length) return;
      const width = swiperSlideElements[0].getBoundingClientRect().width;
      const height = Math.round(width / (16 / 9));
      swiperSlideElements.forEach(element => element.style.height = `${height}px`);
    };

    calculateHeight();
    window.addEventListener('resize', calculateHeight);
  });
  
	function showProfileMenu() {
		$('#ProfileMenu').toggle();
	}

	$(document).ready(function () {
		  const content = $('#articleContent').val();

		  toastui.Editor.factory({
		    el: $('#viewer')[0],
		    viewer: true,
		    initialValue: content
		  });

		  setTimeout(() => {
		    const $contents = $('#viewer .toastui-editor-contents');
		    const $toc = $('<ul class="toc-list"></ul>');
		    let currentLevel1 = null;
		    let currentLevel2 = null;

		    const MAX_TITLE_LENGTH = 10; // ✅ 제목 최대 길이 설정

		    $contents.find('h1, h2, h3').each(function () {
		      const $el = $(this);
		      const tag = this.tagName.toLowerCase();
		      let text = $el.text().trim();

		      // ✅ 길면 자르기
		      const displayText = text.length > MAX_TITLE_LENGTH
		        ? text.slice(0, MAX_TITLE_LENGTH) + '...'
		        : text;

		      const id = text.replace(/\s+/g, '-').toLowerCase();
		      $el.attr('id', id);

		      const $link = $(`<a href="#\${id}" class="hover:underline">\${displayText}</a>`);
		      const $li = $('<li></li>').append($link);

		      if (tag === 'h1') {
		        currentLevel1 = $('<ul></ul>').append($li);
		        $toc.append(currentLevel1);
		      } else if (tag === 'h2') {
		        if (!currentLevel1) currentLevel1 = $('<ul></ul>').appendTo($toc);
		        currentLevel2 = $('<ul class="ml-4"></ul>').append($li);
		        currentLevel1.append(currentLevel2);
		      } else if (tag === 'h3') {
		        if (!currentLevel2) currentLevel2 = $('<ul class="ml-4"></ul>').appendTo(currentLevel1);
		        const $subList = $('<ul class="ml-4"></ul>').append($li);
		        currentLevel2.append($subList);
		      }
		    });

		    $('#toc').empty().append($toc);
		  }, 100);
		});

	function toggleHeartButton(articleId) {
		$('#heartButton').toggleClass('fa-regular').toggleClass('fa-solid');
		
		$.ajax({
            type: 'POST',
            url: 'toggleLike', // 서버 엔드포인트
            data: { articleId: articleId },
            success: function (likeCount) {

				$('#likeCount').text(likeCount);

				$('#heartButton').toggleClass('fa-regular');
				$('#heartButton').toggleClass('fa-solid');

            },
            error: function () {
                alert("서버 오류가 발생했습니다.");
            }
        });
		
		
	}
</script>
<style>
.toc-list {
	list-style: none;
	padding-left: 0;
}

.toc-list ul {
	list-style: none;
	margin-left: 1rem;
}

.toc-list a {
	text-decoration: none;
	color: #374151; /* Tailwind gray-700 */
	display: block;
	padding: 4px 0;
}

.toc-list a:hover {
	text-decoration: underline;
}

/* swiper 코드 */
.swiper {
	width: 80%;
	height: 80%;
	max-width: 1200px;
}

.swiper-wrapper {
	display: flex;
	align-items: center;
}

.swiper-slide {
	flex: 0 0 auto; /* 고정 너비 */
	width: calc(100%/ 5); /* 5개만 보이도록 설정 */
	height: auto;
	transition: transform 250ms ease-in-out;
	border-radius: 0.5rem;
}

.swiper-slide.swiper-slide-active {
	transform: scale(2);
	z-index: 10;
}

.swiper-slide.swiper-slide-prev, .swiper-slide.swiper-slide-next {
	transform: scale(1.7);
	z-index: 5;
	transition-duration: 150ms;
}

.swiper-slide.swiper-slide-next+.swiper-slide {
	z-index: 2;
}

.swiper-slide img {
	display: block;
	border-radius: 0.5rem;
	width: 100%;
	height: 100%;
	object-fit: cover;
	user-select: none;
}

.swiper-button {
	position: absolute;
	top: 50%;
	transform: translateY(-50%);
	height: 3rem;
	width: 3rem;
	border-radius: 0.5rem;
	z-index: 20;
	border: 1px solid black;
}

.swiper-button-prev {
	left: 12%;
}

.swiper-button-next {
	right: 12%;
}

.swiper-button::after {
	font-size: 1.5rem;
	color: white;
}

/* 본문 텍스트 크기 및 줄간격 조정 */
.toastui-editor-contents {
	font-size: 20px !important; /* 본문 글씨 크기 */
	line-height: 1.8 !important; /* 줄 간격 추가로 가독성 향상 */
	word-break: break-word !important; /* 긴 단어 줄바꿈 */
}

/* 헤딩(h1~h6) 크기 설정 */
.toastui-editor-contents h1 {
	font-size: 2.25rem !important; /* 36px */
	line-height: 1.3 !important;
	margin: 1.2em 0 0.6em;
}

.toastui-editor-contents h2 {
	font-size: 1.875rem !important; /* 30px */
	line-height: 1.3 !important;
	margin: 1.1em 0 0.5em;
}

.toastui-editor-contents h3 {
	font-size: 1.5rem !important; /* 24px */
	line-height: 1.4 !important;
}

.toastui-editor-contents h4 {
	font-size: 1.25rem !important; /* 20px */
	line-height: 1.3 !important;
}

.toastui-editor-contents h5 {
	font-size: 1.125rem !important; /* 18px */
	line-height: 1.3 !important;
}

.toastui-editor-contents h6 {
	font-size: 1rem !important; /* 16px */
	line-height: 1.3 !important;
}

/* 마크다운 프리뷰 강조 배경 제거 */
.toastui-editor-md-preview-highlight {
	background-color: transparent !important;
}
</style>


<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-auto gap-2.5 bg-white ">


	<div class="h-[100px]"></div>
	<div
		class="flex fixed justify-center items-center self-stretch w-full z-3 flex-grow-0 flex-shrink-0 h-[100px] gap-2.5 px-[293px] py-[41px] bg-[#aedff7] border-b border-black">


		<div
			class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-full h-full relative gap-2.5 border-0 border-[#f00]">
			<a href="../home/main">
				<img src="/images/로고_blue.png"
					class="flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
			</a>


			<c:if test="${!rq.isLogined() }">
				<div
					class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 w-[300px] relative">
					<p
						class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">
						<a href="../article/list">여행 리스트</a>
					</p>

					<a href="../member/login"
						class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">로그인</a>

				</div>
			</c:if>
			<c:if test="${rq.isLogined() }">

				<div
					class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 w-[400px] relative">
					<p
						class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">
						<a href="../article/list">여행 리스트</a>
					</p>
					<p
						class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">
						<a href="../planner/region">여행 작성</a>
					</p>
					<div onClick="showProfileMenu();"
						class="relative justify-center items-center flex-grow h-14 ">
						<button
							class="h-full flex justify-center items-center text-xl font-medium text-[#2f3a4b] cursor-pointer">
							<div id="profileThumbnail"
								class="w-18 h-18 rounded-full bg-white flex items-center justify-center">
								<c:if test="${base64Image == null and developerImage == null}">
									<i class="fa-solid fa-user fa-3x text-gray-700"></i>
								</c:if>
								<c:if test="${base64Image == null and developerImage != null}">
									<img src="${developerImage}"
										class="w-full h-full object-cover rounded-full" />
								</c:if>
								<c:if test="${base64Image != null}">
									<img src="data:image/jpeg;base64,${base64Image}"
										class="w-full h-full object-cover rounded-full" />
								</c:if>
							</div>

						</button>
						<!-- 숨겨진 메뉴 -->
						<ul id="ProfileMenu"
							class="absolute right-0 mt-2 w-40 bg-white border border-gray-300 rounded shadow-lg hidden z-51">
							<li class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
								<a href="../member/profile?memberId=${rq.getLoginedMemberId() }">내
									정보</a>
							</li>
							<li class="px-4 py-2 hover:bg-gray-100 cursor-pointer">설정</li>
							<li class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
								<a href="../member/doLogout">로그아웃</a>
							</li>
						</ul>
					</div>

				</div>
			</c:if>
		</div>

	</div>
	<div
		class="flex justify-center items-center self-stretch flex-grow overflow-auto gap-2.5 p-2.5">
		<div
			class="flex flex-col justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative  gap-2.5 p-2.5">
			<div
				class="flex justify-between items-center self-stretch flex-grow-0 flex-shrink-0 relative w-[1200px] px-30 gap-2.5 pr-10">
				<div class="text-5xl">${article.title }</div>
				<div class="flex justify-end items-center">
					<a href="modify?articleId=${param.articleId }">
						<i class="fa-solid fa-pen-to-square text-3xl cursor-pointer"></i>
					</a>

				</div>

			</div>
			<div class="flex w-[950px] justify-start items-center text-xl">${article.extra__name }
				&nbsp;
				<span class="flex justify-start items-end h-full text-sm">${article.updateDate }</span>
			</div>
			<div></div>

			<!-- Swiper -->
			<div class="flex swiper relative  w-full  mx-auto">
				<div class="swiper-wrapper ">
					<c:forEach var="articleImage" items="${articleImages }"
						varStatus="">
						<div class="swiper-slide">
							<img src="${articleImage }" />
						</div>
					</c:forEach>

				</div>
				<div
					class="flex justify-center items-center swiper-button swiper-button-next absolute bg-blue-500 hover:bg-blue-600 top-[45%]">

				</div>
				<div
					class="flex justify-center items-center swiper-button swiper-button-prev absolute bg-blue-500 hover:bg-blue-600 top-[45%]">

				</div>
			</div>

			<div
				class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[306px] w-[1000px] relative  gap-2.5">
				<p id="viewer"
					class="flex-grow-0 flex-shrink-0 w-[1000px]  text-xl font-medium text-start text-black">
			</div>

		</div>
	</div>
</div>
<input type="hidden" id="articleContent" value="${article.body}" />

<div id="toc" class="fixed right-[300px] top-1/2"></div>
<div id="heart"
	class="fixed left-[370px] w-[50px] h-[100px] rounded-full border border-black top-1/2">
	<i onClick="toggleHeartButton(${article.id});" id="heartButton"
		class="fa-regular fa-heart text-red-500 absolute rounded-full top-[10px] left-1/2 -translate-x-1/2 text-3xl cursor-pointer"></i>
	<div id="likeCount"
		class="text-black absolute top-[60px] left-1/2 -translate-x-1/2 text-2xl">${article.extra__likeCount }</div>
</div>

<%@ include file="../common/foot.jspf"%>