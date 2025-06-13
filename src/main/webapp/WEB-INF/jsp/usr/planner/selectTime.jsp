<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="TIME PAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<style>
body {
	position: relative;
}
</style>

<link rel="stylesheet" href="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.js"></script>

<script>
	let instance;

	$(function() {
		// 시작 시간 TimePicker 인스턴스 생성

		const startTimeInstance = new tui.TimePicker('#startTimePicker', {
			initialHour : 10,
			inputType : 'spinbox',
			format : 'HH:mm',
			showMeridiem : true
		});

		// 종료 시간 TimePicker 인스턴스 생성

		const endTimeInstance = new tui.TimePicker('#endTimePicker', {
			initialHour : 22,
			inputType : 'spinbox',
			format : 'HH:mm',
			showMeridiem : true
		});

		// 시간 클릭 시 팝업 열고 index 기억
		$('.time-range').on('click', function() {
			selectedIndex = $(this).data('index');
			$('.timepicker').removeClass('hidden');
		});

		$('#submitBtn').on('click',function() {

					let startHour = String(startTimeInstance.getHour())
							.padStart(2, '0');
					const startMin = String(startTimeInstance.getMinute())
							.padStart(2, '0');
					let endHour = String(endTimeInstance.getHour()).padStart(2,
							'0');
					const endMin = String(endTimeInstance.getMinute())
							.padStart(2, '0');

					const startIsAM = startHour < 12;
					const startMeridiemStr = startIsAM ? 'AM' : 'PM';

					const endIsAM = endHour < 12;
					const endMeridiemStr = endIsAM ? 'AM' : 'PM';

					if (!startIsAM) {
						startHour -= 12;
						startHour = String(endHour).padStart(2, '0');
					}

					if (!endIsAM) {
						endHour -= 12;
						endHour = String(endHour).padStart(2, '0');
					}

					const startTimeStr = startHour + ': ' + startMin + ' '
							+ startMeridiemStr;
					const endTimeStr = endHour + ': ' + endMin + ' '
							+ endMeridiemStr;

					$('.start-time[data-index=' + selectedIndex + ']').text(
							startTimeStr);
					$('.end-time[data-index=' + selectedIndex + ']').text(
							endTimeStr);
					
					
					
					$('.timepicker').addClass('hidden');
				});
	});

	/* 처음 활성화될 버튼 설정 */
	$(document).ready(function() {
		function init() {
			$('#recommendButton').addClass('btn-active');
			$('.recommendUI').addClass('ui-active');
			$('#infoButton').addClass('btn-active');
			$('.infoUI').addClass('ui-active');
		}
		init();
	});

	function hideTimeSelectDiv() {
		$('.selectTimeDiv').addClass('hidden');
		$('.selectLocationDiv').removeClass('hidden');

	}

	function recommendButton() {
		if ($('#recommendButton').hasClass('btn-active')) {
			return;
		}
		$('#recommendButton').toggleClass('btn-active');
		$('#searchButton').toggleClass('btn-active');
		$('.recommendUI').toggleClass('ui-active');
		$('.searchUI').toggleClass('ui-active');
	}
	function searchButton() {
		if ($('#searchButton').hasClass('btn-active')) {
			return;
		}
		$('#recommendButton').toggleClass('btn-active');
		$('#searchButton').toggleClass('btn-active');
		$('.recommendUI').toggleClass('ui-active');
		$('.searchUI').toggleClass('ui-active');
	}
	
	// infoDiv의 정보&사진 버튼 클릭
	function infoButton() {
		if ($('#infoButton').hasClass('btn-active')) {
			return;
		}
		$('#infoButton').toggleClass('btn-active');
		$('#pictureButton').toggleClass('btn-active');
		$('.infoUI').toggleClass('ui-active');
		$('.pictureUI').toggleClass('ui-active');
	}
	function pictureButton() {
		if ($('#pictureButton').hasClass('btn-active')) {
			return;
		}
		$('#infoButton').toggleClass('btn-active');
		$('#pictureButton').toggleClass('btn-active');
		$('.infoUI').toggleClass('ui-active');
		$('.pictureUI').toggleClass('ui-active');
	}

	/* 장소 정보 나타내는 div 열고 닫기 애니메이션 */
	function toggleInfoDiv() {
		const $div = $('.infoDiv');


		const isHidden = $div.hasClass('hidden');


		if (isHidden) {

	    	$div.removeClass('hidden');
	
			requestAnimationFrame(() => {
			$div.removeClass('-translate-x-1/3 opacity-0');
			$div.addClass('translate-x-0 opacity-100');
		});
		} else {
			// 트랜지션으로 숨기는 애니메이션 시작
			$div.removeClass('translate-x-0 opacity-100');
			$div.addClass('-translate-x-1/3 opacity-0');

			// 트랜지션 완료 후 hidden 적용 (트랜지션 시간에 맞춰서)
			setTimeout(() => {
				$div.addClass('hidden');
			}, 300); // Tailwind transition-duration 기준 (기본 300ms)
		}
	}
	
	// 상세보기 Div 닫기
	function closeInfoDiv() {
		const $div = $('.infoDiv');

		// 다시 왼쪽으로 숨김 + 투명도 0
		$div.removeClass('translate-x-0 opacity-100');
		$div.addClass('-translate-x-1/3 opacity-0');

		// transition 후 hidden 처리
		setTimeout(() => {

			$div.addClass('hidden');
		}, 300); 
	}
  
  // N일차 장바구니 toggle

  function toggleDailyPlan() {
	  
	  
	  
	  if ($('.dailyPlan').hasClass('w-0')){
		  // 다시 열기
		  $('.dailyPlan').removeClass('w-0').addClass('w-[527px]');
	  } else {
		  // 넣기
		  $('.dailyPlan').removeClass('w-[527px]').addClass('w-0');
	  }
	  
	  $('.toggleDailyPlanButton').toggleClass('rotate-180');
  }
</script>


<style>
/* 추천장소, 장소 찾기 클릭시 색깔, 밑줄 코드 */
#recommendButton.btn-active, #searchButton.btn-active {
	opacity: 1;
	color: black;
}

#recommendButton, #searchButton {
	position: relative;
	display: inline-block;
	border-bottom: 2px solid transparent; /* 기본은 안 보임 */
}

#recommendButton::after, #searchButton::after {
	content: "";
	position: absolute;
	bottom: 0;
	left: 0;
	height: 2px;
	width: 100%;
	background-color: black;
	transform: scaleX(0); /* 처음엔 안 보이게 */
	transform-origin: left; /* 왼쪽에서 시작 */
}

#recommendButton.btn-active::after, #searchButton.btn-active::after {
	transform: scaleX(1); /* 애니메이션으로 왼쪽→오른쪽 확장 */
	transition: transform 0.3s;
}

/* 추천장소, 장소 찾기 UI css  */
.recommendUI, .searchUI {
	display: none;
}

.recommendUI.ui-active, .searchUI.ui-active {
	display: block;
}

/* 정보, 사진 클릭시 색깔, 밑줄 코드 */
#infoButton.btn-active, #pictureButton.btn-active {
	opacity: 1;
	color: black;
}

#infoButton, #pictureButton {
	position: relative;
	display: inline-block;
	border-bottom: 2px solid transparent; /* 기본은 안 보임 */
}

#infoButton::after, #pictureButton::after {
	content: "";
	position: absolute;
	bottom: 0;
	left: 0;
	height: 2px;
	width: 100%;
	background-color: black;
	transform: scaleX(0); /* 처음엔 안 보이게 */
	transform-origin: left; /* 왼쪽에서 시작 */
}

#infoButton.btn-active::after, #pictureButton.btn-active::after {
	transform: scaleX(1); /* 애니메이션으로 왼쪽→오른쪽 확장 */
	transition: transform 0.3s;
}

/* 아이디 찾기, 비밀번호 찾기 Ui 코드 */
.infoUI, .pictureUI {
	display: none;
}

.infoUI.ui-active, .pictureUI.ui-active {
	display: block;
}
</style>

<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<div class="flex absolute  justify-start items-center self-stretch flex-grow relative overflow-hidden  pr-2.5">
		<div
			class="flex flex-col justify-between items-start flex-grow-0 flex-shrink-0 h-[919px] w-[497px] left-px top-0 overflow-hidden pl-px pt-px pb-2.5 bg-white border-r border-black">
			<div
				class="self-stretch flex-grow-0 flex-shrink-0 h-[121px] relative overflow-hidden bg-[#aedff7] border-b border-black">
				<a href="../home/main">
					<img src="/images/로고.png" class="w-[77px] h-[53px] absolute left-[-1px] top-[-1px] object-cover" />
				</a>
				<div class="flex justify-center items-end absolute left-[78px] top-[47px] overflow-hidden px-11 py-[13px]">
					<p class="flex-grow-0 flex-shrink-0 w-[51px] h-[38px] text-xl font-medium text-center text-black">${param.region}</p>
					<p class="flex-grow-0 flex-shrink-0 w-[210px] h-6 text-[15px] font-medium text-center text-black">${startDate}
						~ ${endDate}</p>
				</div>
				<p class="w-[141px] h-[52px] absolute left-[177.5px] top-2.5 text-3xl font-medium text-center text-black">여행 이름</p>
			</div>

			<div class="selectTimeDiv hidden self-stretch flex-grow-0 flex-shrink-0 h-[759px] relative overflow-auto">
				<p class="w-[184px] h-[51px] absolute left-[146.5px] top-0 text-3xl font-medium text-center text-black">시간 선택</p>
				<div class="flex flex-col justify-start items-start w-[407px] absolute left-[35px] top-[95px] gap-3">
					<c:forEach var="date" items="${dateList}" varStatus="status">
						<div
							class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 overflow-hidden gap-2.5 border border-black">
							<div
								class="flex flex-col justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
								<p class="flex-grow-0 flex-shrink-0 text-xs font-medium text-center text-black">${status.index + 1}일차</p>
								<p class="flex-grow-0 flex-shrink-0 w-[61px] h-[23px] text-[15px] font-medium text-center text-black">${date}
								</p>
							</div>
							<div class="flex flex-col justify-between items-center self-stretch flex-grow overflow-hidden py-2.5">
								<div class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[227px] relative overflow-hidden">
									<p class="flex-grow-0 flex-shrink-0 w-[78px] h-[18px] text-[10px] font-medium text-center text-black">출발 시간</p>
									<p class="flex-grow-0 flex-shrink-0 w-[73px] h-[17px] text-[10px] font-medium text-center text-black">종료 시간</p>
								</div>
								<div
									class="time-range flex justify-start items-center flex-grow-0 flex-shrink-0 w-[283px] relative overflow-hidden gap-2.5 px-2.5 pb-px cursor-pointer"
									data-index="${status.index}">
									<div
										class="relative flex justify-start items-center flex-grow-0 flex-shrink-0 h-[37px] relative overflow-hidden gap-2.5 py-[11px] ">
										<i class="fa-regular fa-clock flex-grow-0 flex-shrink-0 w-3.5 h-3.5 object-cover"></i>
										<div
											class="start-time flex-grow-0 flex-shrink-0 w-[87px] h-[17px] text-[15px] font-medium text-center text-black"
											data-index="${status.index}">10: 00 AM</div>
									</div>
									<p class="flex-grow-0 flex-shrink-0 w-[21px] h-[13px] text-[15px] font-medium text-center text-black">~</p>
									<div onClick=""
										class="flex justify-start items-center flex-grow-0 flex-shrink-0 h-[37px] relative overflow-hidden gap-2.5 py-[11px] ">
										<i class="fa-regular fa-clock flex-grow-0 flex-shrink-0 w-3.5 h-3.5 object-cover"></i>
										<div
											class="end-time flex-grow-0 flex-shrink-0 w-[87px] h-[17px] text-[15px] font-medium text-center text-black"
											data-index="${status.index}">10: 00 AM</div>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>


					<div
						class="flex justify-center items-end self-stretch flex-grow-0 flex-shrink-0 h-[99px] overflow-hidden gap-2.5 pl-[72px] pr-[85px] py-[19px]">
						<button onclick="hideTimeSelectDiv()"
							class="flex justify-start items-start flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 p-2.5 rounded-[10px] bg-black cursor-pointer">
							<p
								class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[205px] h-[41px] text-xl font-medium text-center text-white">시간
								설정 완료</p>
						</button>
					</div>
				</div>

			</div>
			<div
				class="selectLocationDiv flex flex-col justify-start items-center self-stretch flex-grow relative overflow-hidden gap-[18px] px-10 py-4">
				<p class="flex-grow-0 flex-shrink-0 w-[184px] h-[27px] text-3xl font-medium text-center text-black">장소 선택</p>
				<div
					class="flex justify-start items-start flex-grow-0 flex-shrink-0 w-[244px] relative overflow-hidden gap-2.5 px-[22px] py-[9px]">
					<button onClick="recommendButton()" id="recommendButton"
						class="flex-grow-0 flex-shrink-0 w-[91px] h-[39px] text-xl font-medium text-center opacity-50 text-black/80 cursor-pointer">추천
						장소</button>
					<button onClick="searchButton()" id="searchButton"
						class="flex-grow-0 flex-shrink-0 w-[99px] h-[37px] text-xl font-medium text-center opacity-50 text-black/80 cursor-pointer">장소
						찾기</button>

				</div>
				<div
					class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[309px] h-[41px] relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
					<input
						class="flex-grow-0 flex-shrink-0 w-[260px]  text-xl font-medium  outline-none border-none focus:outline-none focus:border-none"
						placeholder="장소를 입력해주세요"></input>
					<i class="fa-solid fa-magnifying-glass text-lg"></i>
				</div>

				<div class="recommendUI flex-grow-0 flex-shrink-0 w-[268px] h-14 relative overflow-hidden">
					<div
						class="flex justify-center items-center w-[66px] h-[34px] absolute left-4 top-3 gap-2.5 px-[13px] py-2 rounded-[10px] bg-[#9dcbff]/[0.63]">
						<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">추천</p>
					</div>
					<div
						class="flex justify-center items-center w-[66px] h-[34px] absolute left-[103px] top-3 gap-2.5 px-[13px] py-2 rounded-[10px] bg-white/[0.63]">
						<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">명소</p>
					</div>
					<div
						class="flex justify-center items-center w-[66px] h-[34px] absolute left-[183px] top-3 gap-2.5 px-[13px] py-2 rounded-[10px] bg-white/[0.63]">
						<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">맛집</p>
					</div>
				</div>
				
				<div class="recommendUI flex flex-col justify-start items-start flex-grow w-[407px] relative overflow-auto gap-3">
					<c:forEach var="tripLocation" items="${tripLocations}">
						<div onClick="toggleInfoDiv()"
							class="cursor-pointer flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[19px] px-[9px] py-[13px]">
							<img src="${tripLocation.extra__pictureUrl }" class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
							
							<div class="flex flex-col justify-center items-start flex-grow relative overflow-hidden gap-[11px]">
								<p
									class="self-stretch flex-grow-0 flex-shrink-0 w-[233px] h-[15px]  text-[15px] font-medium text-left text-black">
									${tripLocation.locationTypeId }</p>
								<p
									class="self-stretch flex-grow-0 flex-shrink-0 w-[233px] h-[15px] text-[15px] font-medium text-left text-black">
									${tripLocation.locationName }</p>
								<p
									class="self-stretch flex-grow-0 flex-shrink-0 w-[233px] h-[15px] text-[15px] font-medium text-left text-black">
									${tripLocation.address }</p>
							</div>
							<button class="cursor-pointer pointer-events-auto">
								<i class="fa-solid fa-square-plus text-3xl"></i>
							</button>

						</div>
					</c:forEach>


				</div>
				<div
					class="flex flex-col justify-start items-end self-stretch flex-grow-0 flex-shrink-0 overflow-hidden gap-2.5 py-1.5">
					<div
						class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[51px] h-[25px] relative overflow-hidden gap-2.5 px-[9px] rounded-[5px] bg-black">
						<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-white">완료</p>
					</div>

				</div>
			</div>

		</div>
		<div
			class="infoDiv z-1 left-[520px] transform -translate-x-1/3 opacity-0 transition-all duration-300 hidden flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[898px] w-[377px] absolute gap-2.5 rounded-[20px] bg-white border border-black">
			<img src="image-9.png"
				class="flex-grow-0 flex-shrink-0 w-[377px] h-[209px] rounded-tl-[20px] rounded-tr-[20px] object-cover" />
			<div class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[343px] overflow-hidden px-0.5 py-[7px]">
				<div class="flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 overflow-hidden py-px">
					<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden">
						<p class="flex-grow-0 flex-shrink-0 w-[142px] h-[42px] text-[25px] font-medium text-center text-black">서울 대공원</p>
						<p class="flex-grow-0 flex-shrink-0 w-[42px] h-[18px] text-[15px] font-medium text-center text-black">명소</p>
					</div>
					<div
						class="flex flex-col justify-center items-start flex-grow-0 flex-shrink-0 h-[72px] relative overflow-hidden pl-2">
						<p class="flex-grow-0 flex-shrink-0 w-[184px] h-7 text-[15px] font-medium text-left text-black">리뷰 : 2000</p>
						<p class="flex-grow-0 flex-shrink-0 w-[184px] h-7 text-[15px] font-medium text-left text-black">조회수 : 2000</p>
					</div>
				</div>
				<div onClick=""
					class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 rounded-[10px] bg-black cursor-pointer">
					<p
						class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[104px] h-[50px] text-xl font-medium text-white">
						추가하기</p>
				</div>
			</div>
			<div
				class="flex justify-center items-start flex-grow-0 flex-shrink-0 w-[260px] relative overflow-hidden gap-[54px] px-4">
				<p onClick="infoButton()" id="infoButton"
					class="cursor-pointer flex-grow-0 flex-shrink-0 w-10 h-[30px] text-xl font-medium text-center text-black">정보</p>
				<p onClick="pictureButton()" id="pictureButton"
					class="cursor-pointer flex-grow-0 flex-shrink-0 w-10 h-[30px] text-xl font-medium text-center text-black/40">사진</p>
			</div>
			<div class="infoUI flex flex-col justify-start items-start flex-grow overflow-hidden px-[17px]">
				<div
					class=" flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[5px]">
					<div class="pr-2 pl-3">
						<i class="fa-solid fa-location-dot text-3xl"></i>
					</div>
					<p
						class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[257px] h-[53px] text-xl font-medium text-black">위치
						정보</p>
				</div>
				<div
					class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[11px] px-2">

					<div class="">
						<i class="fa-solid fa-clock text-3xl"></i>
					</div>

					<p
						class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[257px] h-[53px] text-xl font-medium text-black">일정
						정보</p>
				</div>
				<div
					class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[5px]">
					<div class="pr-2 pl-2">
						<i class="fa-solid fa-phone text-3xl"></i>
					</div>
					<p
						class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[257px] h-[53px] text-xl font-medium text-black">번호
						정보</p>
				</div>
				<div class="flex justify-start items-start self-stretch flex-grow relative overflow-hidden gap-2.5">
					<div class="pl-2">
						<i class="fa-solid fa-pen-to-square text-3xl"></i>
					</div>
					<p class="flex-grow-0 flex-shrink-0 w-[303px] h-[173px] text-xl font-medium text-black">소개글 정보</p>
				</div>

			</div>
			<button onClick="closeInfoDiv()"
				class="absolute top-2 right-2 z-10 w-8 h-8 flex items-center justify-center rounded-full bg-gray-200
						hover:bg-gray-300">
				<i class="fa-solid fa-xmark text-lg text-black"></i>
			</button>
		</div>

		<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 overflow-hidden ">
			<div
				class="dailyPlan w-[527px] transition-all duration-[500ms] ease-in-out flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[914px] relative overflow-hidden gap-[9px] bg-white border-t-0 border-r border-b-0 border-l-0 border-black">
				<div class="flex-grow-0 flex-shrink-0 w-[527px] h-[134px] relative overflow-hidden">
					<p class="w-[99px] h-[21px] absolute left-[428px] top-[113px] text-[15px] font-medium text-center text-[#f00]">
						설정 초기화</p>
					<select id="daySelect"
						class="w-60 h-[59px] absolute left-0 top-0 text-2xl font-medium text-center text-black mt-2 border-none focus:outline-none bg-white border border-gray-300 rounded">
						<c:forEach var="i" begin="1" end="${diffDays}">
							<option value="${i}">${i}일차일정 장바구니</option>
						</c:forEach>
					</select>
					<p class="w-[207px] h-10 absolute left-6 top-[84px] text-xl font-medium text-center text-black">시간 : 10:00 ~
						22:00</p>

				</div>
				<div class="flex flex-col justify-start items-center flex-grow w-[527px] overflow-hidden gap-2.5">
					<div
						class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 h-[114px] overflow-hidden gap-2.5 px-0.5">
						<div class="flex justify-start items-center flex-grow relative overflow-hidden gap-[21px] px-2.5 py-3.5">
							<p class="flex-grow-0 flex-shrink-0 w-8 text-[15px] font-medium text-center text-black">1</p>
							<img src="image-9.png" class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
							<div
								class="flex justify-between items-start self-stretch flex-grow-0 flex-shrink-0 w-[306px] overflow-hidden px-0.5 py-[5px]">
								<div
									class="flex flex-col justify-center items-start flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 py-1.5">
									<div
										class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-3.5 py-[3px]">
										<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-[#7fbc77]">명소</p>
										<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">02:33 ~ 4:33</p>
									</div>
									<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">서울 롯데타워</p>
									<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">장소 주소</p>
								</div>
								<div
									class="flex justify-end items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 py-6">
									<p class="flex-grow-0 flex-shrink-0 w-[98px] h-[35px] text-[15px] font-medium text-center">
										<span class="flex-grow-0 flex-shrink-0 w-[98px] h-[35px] text-[15px] font-medium text-center text-black">머무는
											시간</span>
										<br />
										<span class="flex-grow-0 flex-shrink-0 w-[98px] h-[35px] text-[15px] font-medium text-center text-[#4abef8]">02:00</span>
									</p>
								</div>
							</div>
							<div
								class="flex justify-end items-center self-stretch flex-grow-0 flex-shrink-0 w-[27px] relative overflow-hidden gap-2.5 px-px">
								<i class="fa-solid fa-trash-can"></i>
							</div>
						</div>
					</div>


				</div>
			</div>
			<div onClick="toggleDailyPlan();"
				class="flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 border-r border-t border-b cursor-pointer">
				<p
					class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[30px] h-[50px] text-xs font-medium text-center text-black">
					<i class="toggleDailyPlanButton fa-solid fa-chevron-left text-2xl transition-transform duration-300"></i>
				</p>
			</div>
		</div>
	</div>


</div>



<div class="timepicker fixed top-0 left-0 w-full h-full z-50 bg-black/40 flex items-center justify-center hidden">
	<div
		class="bg-white flex-col flex-grow-0 flex-shrink-0 w-[500px] h-[350px] relative overflow-hidden flex items-center justify-center rounded">

		<div class="flex gap-10 mb-5">
			<div>
				<label class="block mb-2">시작 시간</label>
				<div id="startTimePicker"></div>
			</div>
			<div>
				<label class="block mb-2">종료 시간</label>
				<div id="endTimePicker"></div>
			</div>
		</div>

		<div class="flex justify-end">
			<button class="cursor-pointer" type="submit" id="submitBtn">확인</button>
		</div>

	</div>
</div>

<%@ include file="../common/foot.jspf"%>