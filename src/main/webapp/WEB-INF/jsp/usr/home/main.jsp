
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="MAIN PAGE"></c:set>
<%@ include file="../common/head.jspf"%>
<script>
	document.addEventListener("DOMContentLoaded", function() {
		const swiper = new Swiper(".mySwiper", {
			loop : true,
			autoplay : {
				delay : 5000,
				disableOnInteraction : false,
			},
			effect : "slide", // 또는 slide
		});
	});

	$(window).on(
			'scroll',
			function() {
				const scrollTop = $(window).scrollTop();
				console.log(scrollTop);

				if (scrollTop >= 300) {
					$('#scrollText').removeClass('opacity-0 translate-y-6')
							.addClass('opacity-100 translate-y-0');

				}

			});
	
	
	$(document).ready(function() {
		$('#addEventBtn').on('click', function(e) {
			if (!confirm('일정을 추가하시겠습니까?')) {
				e.preventDefault();
				return;
			}

			window.location.href = '../planner/region';
		});
	});
</script>


<style>

/* 오른쪽 아래 버튼 */
.floating-btn-wrapper {
	position: fixed;
	bottom: 30px;
	right: 30px;
	z-index: 9999;
}

.floating-btn-wrapper {
	position: fixed;
	bottom: 30px;
	right: 30px;
	z-index: 9999;
}

.floating-btn {
	display: flex;
	align-items: center;
	justify-content: center; /* 처음엔 중앙 정렬 */
	background-color: #007bff;
	color: white;
	border: none;
	border-radius: 50%; /* 원형 */
	width: 50px;
	height: 50px;
	font-size: 20px;
	cursor: pointer;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
	overflow: hidden;
	transition: all 0.3s ease;
	position: relative;
	padding: 0; /* 내부 여백 제거 */
}

.btn-icon {
	display: block;
	font-size: 24px;
	transition: opacity 0.2s ease;
	font-size: 24px;
}

.btn-text {
	display: none;
	margin-left: 10px;
	opacity: 0;
	white-space: nowrap;
	transform: translateX(10px);
	font-size: 16px;
	transition: opacity 0.3s ease, transform 0.3s ease;
	visibility: hidden;
	margin-left: 10px; /* 처음엔 공간 차지도 막음 */
}

/* 🔄 Hover 시 동작 */
.floating-btn:hover {
	width: 110px;
	border-radius: 25px;
	justify-content: flex-start;
	padding-left: 15px;
	background-color: #0056b3;
}

.floating-btn:hover .btn-icon {
	display: none;
}

.floating-btn:hover .btn-text {
	display: block;
	opacity: 1;
	transform: translateX(0);
	visibility: visible;
}

@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(20px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.animate-fade-in-up {
	animation: fadeInUp 1s ease-out forwards;
}
</style>

<div class="flex flex-col justify-between items-center w-full  overflow-hidden bg-white">
	<div class="h-[100px]"></div>
	<div
		class="flex fixed justify-center items-center self-stretch w-full z-3 bg-white flex-grow-0 flex-shrink-0 h-[100px] overflow-hidden gap-2.5 px-[293px] py-[41px]  border border-black">


		<div
			class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-full h-full relative gap-2.5 border-0 border-[#f00]">
			<a href="../home/main">
				<img src="/images/로고_blue.png" class="flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
			</a>

			<div class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 w-[428px] relative">
				<p class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">여행 기록</p>
				<p class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">계획 작성</p>
				<p class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">로그인</p>
				<p class="flex justify-center items-center flex-grow w-[107px] h-14 text-xl font-medium text-[#2f3a4b]">회원가입</p>
			</div>
		</div>
	</div>
	<div class="flex flex-col justify-start items-center self-stretch flex-grow relative overflow-hidden gap-[46px] pb-2.5">
		<div class="w-screen flex justify-center h-[600px] ">
			<div class="swiper mySwiper h-full">
				<div class="swiper-wrapper">
					<div class="swiper-slide flex justify-center">
						<img src="/images/서울.jpg" class="w-full w-screen mx-auto h-full object-cover" />
						<div
							class="w-[300px] h-[100px] absolute bottom-0 right-[1310px] bg-black/30 text-white text-2xl font-semibold px-3 py-1 shadow-md">
							<div class="flex justify-center items-center pb-3">📍 서울 도시 야경</div>
							<div class="flex justify-center items-center text-sm">밤이 되면 더 빛나는 도시, 서울</div>
						</div>
						<div style="text-shadow: -0.5px -0.5px black, 0.5px 0.5px black;"
							class="absolute bottom-[65px] left-[1000px] text-white text-4xl font-semibold px-3 py-1 ">어디로 여행을 가고 싶으신가요?</div>
						<div style="text-shadow: -0.5px -0.5px black, 0.5px 0.5px black;"
							class="absolute bottom-[20px] left-[1000px] text-white text-4xl font-semibold px-3 py-1 ">TripTale로 여행을
							간편하게</div>
					</div>
					<div class="swiper-slide flex justify-center">
						<img src="/images/대전.jpg" class="w-full w-screen mx-auto h-full object-cover" />
						<div
							class="w-[300px] h-[100px] absolute bottom-0 right-[1310px] bg-black/30 text-white text-2xl font-semibold px-3 py-1 shadow-md">
							<div class=" flex justify-center items-center pb-3">📍 대전 엑스포다리</div>
							<div class="flex justify-center items-center text-sm">과학과 도시를 잇는 길, 엑스포다리</div>

						</div>
						<div style="text-shadow: -0.5px -0.5px black, 0.5px 0.5px black;"
							class="absolute bottom-[65px] left-[1000px] text-white text-4xl font-semibold px-3 py-1 ">어디로 여행을 가고 싶으신가요?</div>
						<div style="text-shadow: -0.5px -0.5px black, 0.5px 0.5px black;"
							class="absolute bottom-[20px] left-[1000px] text-white text-4xl font-semibold px-3 py-1 ">TripTale로 여행을
							간편하게</div>
					</div>
					<div class="swiper-slide">
						<img src="/images/부산.jpg" class="w-full w-screen mx-auto h-full object-cover" />
						<div
							class="w-[300px] h-[100px] absolute bottom-0 right-[1310px] bg-black/30 text-white text-2xl font-semibold px-3 py-1 shadow-md">
							<div class=" flex justify-center items-center pb-3">📍 부산 해운대</div>
							<div class="flex justify-center items-center text-sm">도심과 바다가 만나는 곳, 해운대</div>
						</div>
						<div style="text-shadow: -0.5px -0.5px black, 0.5px 0.5px black;"
							class="absolute bottom-[65px] left-[1000px] text-white text-4xl font-semibold px-3 py-1 ">어디로 여행을 가고 싶으신가요?</div>
						<div style="text-shadow: -0.5px -0.5px black, 0.5px 0.5px black;"
							class="absolute bottom-[20px] left-[1000px] text-white text-4xl font-semibold px-3 py-1 ">TripTale로 여행을
							간편하게</div>
					</div>
					<div class="swiper-slide">
						<img src="/images/제주도.jpg" class="w-full w-screen mx-auto h-full object-cover" />
						<div
							class="w-[300px] h-[100px] absolute bottom-0 right-[1310px] bg-black/30 text-white text-2xl font-semibold px-3 py-1 shadow-md">
							<div class=" flex justify-center items-center pb-3">📍 제주도 성산일출봉</div>
							<div class="flex justify-center items-center text-sm">제주의 하루가 가장 먼저 시작되는 곳</div>
						</div>
						<div style="text-shadow: -0.5px -0.5px black, 0.5px 0.5px black;"
							class="absolute bottom-[65px] left-[1000px] text-white text-4xl font-semibold px-3 py-1 ">어디로 여행을 가고 싶으신가요?</div>
						<div style="text-shadow: -0.5px -0.5px black, 0.5px 0.5px black;"
							class="absolute bottom-[20px] left-[1000px] text-white text-4xl font-semibold px-3 py-1 ">TripTale로 여행을
							간편하게</div>
					</div>

				</div>

			</div>

		</div>

		<div class="h-[200px]"></div>
		<div id="scrollText"
			class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[147px] px-[25px] py-[26px] opacity-0 translate-y-6 transition-all duration-[1000ms]">
			<p class="self-stretch flex-grow w-[741.5px] h-[401.68px] text-6xl text-center text-black">
				<span class="self-stretch flex-grow w-[741.5px] h-[401.68px] text-6xl text-center text-black">나만의 여행 코스를 </span>
				<br />
				<span class="self-stretch flex-grow w-[741.5px] h-[401.68px] text-6xl text-center text-black">간편하게 만들고</span>
			</p>
			<img src="/images/지도.png" class="flex-grow h-[401.68px] object-cover" />
		</div>
		<div class="h-[200px]"></div>

		<div class="flex flex-col">
			<p class="self-stretch flex-grow  h-[83px] text-6xl text-center text-black">사진과 함께 나만의 경험을 남겨보세요</p>
			<img src="/images/게시판.png" class="flex-grow-0 flex-shrink-0 w-[948.46px] h-[420px] object-cover" />
			<p class="flex-grow-0 flex-shrink-0 w-[501px] h-[274px] text-6xl text-center text-black"></p>
		</div>


	</div>
</div>
<div class="floating-btn-wrapper">
	<button id="addEventBtn" class="floating-btn fixed">
		<span class="btn-icon">
			<i class="fas fa-plus"></i>
		</span>
		<span class="btn-text">일정생성</span>
	</button>
</div>


<%@ include file="../common/foot.jspf"%>