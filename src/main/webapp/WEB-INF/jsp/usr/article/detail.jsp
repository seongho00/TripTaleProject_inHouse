<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="ARTICLE DETAIL" />
<%@ include file="../common/head.jspf"%>

<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
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
</script>
<style>
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
</style>


<div class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white ">


	<div class="h-[100px]"></div>
	<div
		class="flex fixed justify-center items-center self-stretch w-full z-3 flex-grow-0 flex-shrink-0 h-[100px] gap-2.5 px-[293px] py-[41px] bg-[#aedff7] border-b border-black">


		<div
			class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-full h-full relative gap-2.5 border-0 border-[#f00]">
			<a href="../home/main">
				<img src="/images/로고_blue.png" class="flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
			</a>


			<c:if test="${!rq.isLogined() }">
				<div class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 w-[300px] relative">
					<p class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">여행 리스트</p>




					<a href="../member/login"
						class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">로그인</a>



				</div>
			</c:if>
			<c:if test="${rq.isLogined() }">

				<div class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 w-[400px] relative">
					<p class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">
						<a href="../article/list">여행 리스트</a>
					</p>
					<p class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">
						<a href="../planner/region">여행 작성</a>
					</p>
					<div onClick="showProfileMenu();" class="relative justify-center items-center flex-grow h-14 ">
						<button class="h-full flex justify-center items-center text-xl font-medium text-[#2f3a4b] cursor-pointer">
							<div id="profileThumbnail" class="w-18 h-18 rounded-full bg-white flex items-center justify-center">
								<c:if test="${base64Image == null and developerImage == null}">
									<i class="fa-solid fa-user fa-3x text-gray-700"></i>
								</c:if>
								<c:if test="${base64Image == null and developerImage != null}">
									<img src="${developerImage}" class="w-full h-full object-cover rounded-full" />
								</c:if>
								<c:if test="${base64Image != null}">
									<img src="data:image/jpeg;base64,${base64Image}" class="w-full h-full object-cover rounded-full" />
								</c:if>
							</div>

						</button>
						<!-- 숨겨진 메뉴 -->
						<ul id="ProfileMenu"
							class="absolute right-0 mt-2 w-40 bg-white border border-gray-300 rounded shadow-lg hidden z-51">
							<li class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
								<a href="../member/profile?memberId=${rq.getLoginedMemberId() }">내 정보</a>
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
	<div class="flex justify-center items-center self-stretch flex-grow overflow-hidden gap-2.5 p-2.5">
		<div
			class="flex flex-col justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 p-2.5">
			<div
				class="flex justify-start items-end self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-10">
				<p class="flex-grow-0 flex-shrink-0  h-[52px] text-3xl text-center text-black">여행 이름</p>
				<p class="flex-grow-0 flex-shrink-0 h-[38px] text-xl text-center text-black">${article.extra__tripRegion }</p>
				<p class="flex-grow-0 flex-shrink-0  h-6 text-[15px] font-medium text-center text-black">${startDate }~
					${endDate }</p>
				<div class="flex-grow flex justify-end items-center">
					<a href="modify?articleId=${param.articleId }">
						<i class="fa-solid fa-pen-to-square text-3xl cursor-pointer"></i>
					</a>

				</div>

			</div>

			<!-- Swiper -->
			<div class="flex swiper relative overflow-hidden w-full  mx-auto">
				<div class="swiper-wrapper ">
					<div class="swiper-slide">
						<img
							src="https://images.unsplash.com/photo-1566679056462-2075774c8c07?q=80&w=2675&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />
					</div>
					<div class="swiper-slide">
						<img
							src="https://images.unsplash.com/photo-1494806812796-244fe51b774d?q=80&w=2667&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />
					</div>
					<div class="swiper-slide">
						<img
							src="https://images.unsplash.com/photo-1670414701148-16ac8873a150?q=80&w=2648&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />
					</div>
					<div class="swiper-slide">
						<img
							src="https://images.unsplash.com/photo-1590041794748-2d8eb73a571c?q=80&w=2856&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />
					</div>
					<div class="swiper-slide">
						<img
							src="https://images.unsplash.com/photo-1526772662000-3f88f10405ff?q=80&w=2748&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />
					</div>
					<div class="swiper-slide">
						<img
							src="https://images.unsplash.com/photo-1443632864897-14973fa006cf?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />
					</div>
					<div class="swiper-slide">
						<img
							src="https://images.unsplash.com/photo-1483921020237-2ff51e8e4b22?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />
					</div>
					<div class="swiper-slide">
						<img
							src="https://images.unsplash.com/photo-1446488547543-78c11468449a?q=80&w=2669&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />
					</div>
					<div class="swiper-slide">
						<img
							src="https://images.unsplash.com/photo-1463693396721-8ca0cfa2b3b5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />
					</div>
				</div>
				<div
					class="flex justify-center items-center swiper-button swiper-button-next absolute bg-blue-500 hover:bg-blue-600 top-[45%]">
					<i class="fas fa-chevron-right text-2xl"></i>
				</div>
				<div
					class="flex justify-center items-center swiper-button swiper-button-prev absolute bg-blue-500 hover:bg-blue-600 top-[45%]">
					<i class="fas fa-chevron-left text-2xl"></i>
				</div>
			</div>

			<div
				class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[306px] w-[1000px] relative overflow-hidden gap-2.5">
				<p class="flex-grow-0 flex-shrink-0 w-[1000px] h-[161px] text-xl font-medium text-start text-black">
					${article.body}</p>
			</div>

		</div>
	</div>
</div>

<%@ include file="../common/foot.jspf"%>