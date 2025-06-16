<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="TIME PAGE"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/daisyUi.jspf"%>

<link rel="stylesheet" href="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.js"></script>

<script>

/* 카카오맵 관련 전역번수 */
let map;       // 전역 지도 객체
let marker;    // 전역 마커 객체

const dayMarkersMap = {};   // 일정별 마커 저장용 배열

let infoMarker = null;    // trip-item 클릭 시 마커
let infoOverlay = null;   // trip-item 클릭 시 이름 오버레이

/* 처음 활성화될 버튼 설정 */
$(document).ready(function() {
	function init() {
		$('#recommendButton').addClass('btn-active');
		$('.recommendUI').addClass('ui-active');
		$('#infoButton').addClass('btn-active');
		$('.infoUI').addClass('ui-active');
	}
	init();
	
	// N일차 날짜 선택 태그 변할 때 다른 dailyPlan 안 보이게
	$('#daySelect').on('change', function () {
		const selectedDay = $(this).val();
		
		// 기존 마커/오버레이 모두 숨기기
		  Object.values(dayMarkersMap).forEach(list =>
		    list.forEach(({ marker, overlay }) => {
		      marker.setMap(null);
		      overlay.setMap(null);
		    })
		  );

		  // 해당 일차만 다시 보여주기
		  if (dayMarkersMap[selectedDay]) {
		    dayMarkersMap[selectedDay].forEach(({ marker, overlay }) => {
		      marker.setMap(map);
		      overlay.setMap(map);
		    });
		  }

		$('.dailyPlan').addClass('hidden');
		$(`.dailyPlan[data-day="\${selectedDay}"]`).removeClass('hidden');	
		
	});
	
	// 카테고리 버튼 활성화
	$('#categoryButtons .btn').on('click', function () {
		// 모든 버튼에 btn-outline 다시 추가
		$('#categoryButtons .btn').addClass('btn-outline');
		// 클릭한 버튼만 btn-outline 제거
		$(this).removeClass('btn-outline');
	});
		
	kakao.maps.load(function () {
		initMap(); // API가 완전히 로드된 후 실행해야 함
	});
});

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

	
	
	// 시간 선택 완료 이후
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
	
	// 추천장소, 장소 찾기 버튼 눌렀을 때
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
	
  // N일차 장바구니 toggle
	function toggleDailyPlan() {

	   if ($('.dailyPlanContainer').hasClass('w-0')){
		  // 다시 열기
		   $('.dailyPlanContainer').removeClass('w-0').addClass('w-[527px]');
	   } else {
		   // 넣기
		   $('.dailyPlanContainer').removeClass('w-[527px]').addClass('w-0');
	   }
	   $('.toggleDailyPlanButton').toggleClass('rotate-180');

	}
  


	// infoDiv 열고 닫기 & 정보 추가하기
   $(function() {
	   $('.trip-item').on('click', function() {
		   // 선택한 데이터 넘겨받기
		   const name = $(this).data('name');
		   const type = $(this).data('type');
		   const address = $(this).data('address');
		   const img = $(this).data('img');
		   const schedule = $(this).data('schedule');
		   const profile = $(this).data('profile');
		   const number = $(this).data('number');
		   const reviewCount = $(this).data('reviewcount');
		   const mapX = $(this).data('mapx');
		   const mapY = $(this).data('mapy');

		   
		   // 넘겨받은 데이터 넣기
		   $('#info-locationName').text(name);
	       $('#info-locationType').text(type);
	       $('#info-address').text(address);
	       $('#info-schedule').text(schedule);
	       $('#info-profile').text(profile);
	       $('#info-number').text(number);
	       $('#info-reviewCount').text("리뷰 : " + reviewCount);
	       $('#info-img').attr('src', img);

	      
	       
	       
 	       const $infoDiv = $('.infoDiv');
	       
 	       if (!$infoDiv.hasClass('hidden')){
 	    	 closeInfoDiv();
 		  	 return;
 	       }
 	       
 	       // infoDiv 열 때 애니메이션
 	       $infoDiv.removeClass('hidden');
 	       requestAnimationFrame(() => {
	         $infoDiv.removeClass('-translate-x-1/3 opacity-0')
	                 .addClass('translate-x-0 opacity-100');
	      	});
 	       
 	 	  // 지도에 마커 찍기
 		   const lat = parseFloat(mapY);
 		   const lng = parseFloat(mapX);

 		   if (!isNaN(lat) && !isNaN(lng)) {
 		     const newPosition = new kakao.maps.LatLng(lat, lng);

 		 // 이전 마커/오버레이 제거
 		    if (infoMarker) infoMarker.setMap(null);
 		    if (infoOverlay) infoOverlay.setMap(null);

 		    // 마커 생성
 		    infoMarker = new kakao.maps.Marker({
 		      position: newPosition,
 		      map: map
 		    });

 		    // 이름 오버레이 생성
 		    const content = `<div style="padding:4px 10px; background:white; border:1px solid #333; border-radius:4px; font-size:13px;">
 		                       \${name}
 		                     </div>`;

 		    infoOverlay = new kakao.maps.CustomOverlay({
 		      content: content,
 		      position: newPosition,
 		      yAnchor: 2.5
 		    });

 		    infoOverlay.setMap(map);
 		    map.setCenter(newPosition);
 		   }

 	       });
  });
	
   
   
	  // 닫는 버튼 눌렀을 때 
	  function closeInfoDiv() {
			  const $infoDiv = $('.infoDiv');
			  $infoDiv.removeClass('translate-x-0 opacity-100')
		      .addClass('-translate-x-1/3 opacity-0');
			  
			  // 🔻 마커 및 오버레이 제거
			    if (infoMarker) {
			        infoMarker.setMap(null);
			        infoMarker = null;
			    }
			    if (infoOverlay) {
			        infoOverlay.setMap(null);
			        infoOverlay = null;
			    }
		  	 // 300ms 후에 hidden 추가
		      setTimeout(() => {
		        $infoDiv.addClass('hidden');
		      }, 300); // Tailwind의 duration-300과 일치
		}
	  
	
	// 추가하기 버튼 눌렀을 때 일정에 장소 추가하기
	function addDailyPlan() {
		addDailyPlanForPlus($('.addDailyPlanButton'));
	}
	
	// + 버튼 누를 때 일정에 장소 추가하기
	function addDailyPlanForPlus(btn) {
		
		// 버튼 눌렀을 때 일정 장바구니가 안 보이면 열기
		if ($('.dailyPlanContainer').hasClass('w-0')){
			toggleDailyPlan();
		}
		
		const locationTypeId = $(btn).parent().data('locationtypeid');
		const name = $(btn).parent().data('name');
		const img = $(btn).parent().data('img')
		let address = $(btn).parent().data('address');
		if (address.length > 16){
			address = address.slice(0, 16) + "..."
		}
		
		// 지도에 마커 추가 (새로운 위치라면)
		const mapX = $(btn).parent().data('mapx');
		const mapY = $(btn).parent().data('mapy');
		
		// select 박스에서 현재 선택된 일차
		const selectedDay = $('#daySelect').val();
		
		if (mapX && mapY) {
		    const lat = parseFloat(mapY);
		    const lng = parseFloat(mapX);
		    if (!isNaN(lat) && !isNaN(lng)) {
		      const position = new kakao.maps.LatLng(lat, lng);
		      const newMarker = new kakao.maps.Marker({ position, map });
		      
		      // 🟡 오버레이 생성 (이름 띄우기)
		      const content = `<div style="padding:4px 10px; background:white; border:1px solid #333; border-radius:4px; font-size:13px;">
		                        \${name}
		                      </div>
		                      `;
		      const overlay = new kakao.maps.CustomOverlay({
				 content: content,
		     	 position: position,
		     	 yAnchor: 2.5
		      });
		       
		      overlay.setMap(map);
		      map.setCenter(position);

		      // 일차별로 저장
		      if (!dayMarkersMap[selectedDay]) {
		        dayMarkersMap[selectedDay] = [];
		      }
		      dayMarkersMap[selectedDay].push({
		          marker: newMarker,
		          overlay: overlay
		        });
		    }
		  }
	
		
		// 해당 일차의 dailyPlan div를 찾기
		const $targetDailyPlan = $(`.dailyPlan[data-day="\${selectedDay}"]`);
		
		// 현재 plan-item 개수를 기준으로 인덱스 계산
		const currentIndex = $targetDailyPlan.find('.plan-item').length + 1;
		
		
		const html = `
			<div class="plan-item flex justify-between items-center flex-grow relative overflow-auto px-2.5 py-3.5 border w-full">
				<p class="index-num flex-grow-0 flex-shrink-0 w-8 text-[15px] font-medium text-center text-black">\${currentIndex}</p>
				<img src="\${img}" class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
				<div
					class="flex justify-between items-start self-stretch flex-grow-0 flex-shrink-0 w-[306px] overflow-hidden px-0.5 ">
					<div
						class="flex flex-col justify-center items-start flex-grow-0 flex-shrink-0 w-[200px] relative overflow-hidden gap-2.5 py-1.5">
						<div
							class="flex flex-col justify-center items-start flex-grow-0 flex-shrink-0 relative overflow-hidden gap-1 py-[3px]">
							<p class="flex justify-start items-center flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-[#7fbc77]">명소</p>
							<p class="flex justify-start items-center flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">\${name}</p>
							<p class="flex justify-start items-center flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">\${address}</p>
						</div>
					
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
					class="flex justify-end items-center self-stretch flex-grow-0 flex-shrink-0 w-[27px] relative overflow-hidden gap-2.5 ">
					<i onclick="deleteDailyPlan(this);" class="fa-solid fa-trash-can cursor-pointer p-2"></i>
				</div>
			</div>
			`;
					
			
		$targetDailyPlan.append(html);

	}
	
	// 일정 삭제하기
	function deleteDailyPlan(i) {
		$(i).parent().parent().remove();
		// 인덱스 재조정
		  $('.dailyPlan .plan-item').each(function(index) {
		    // index는 0부터 시작하므로 +1
		    $(this).find('.index-num').text(index + 1);
		  });
	}
	
	// 모든 일정 삭제
	function deleteAllDailyPlan() {
		if(!confirm("정말 모든 일정을 삭제하시겠습니까?")){
			return;
		}
		$('.dailyPlan').children().remove();
	}
	
	// 카카오톡 맵 설정
	function initMap() {
	    const container = document.getElementById('map'); // 지도 담을 영역
	    const options = {
	      center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울시청 좌표
	      level: 3 // 확대 레벨 (작을수록 확대)
	    };

	    map = new kakao.maps.Map(container, options); // 전역 map 설정

	    marker = new kakao.maps.Marker({ map: map });
	  }
	
</script>



<style>
body {
	position: relative;
}
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
	class=" relative flex justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<div class="left-[500px] z-0 h-screen w-screen" id="map"></div>
	<div class="flex absolute justify-start items-center self-stretch flex-grow overflow-hidden pr-2.5">
		<div
			class="flex flex-col justify-between items-start flex-grow-0 flex-shrink-0 h-[919px] w-[497px] left-px top-0 overflow-hidden pl-px pt-px pb-2.5 bg-white border-r border-black">
			<div
				class="self-stretch flex-grow-0 flex-shrink-0 h-[121px] relative overflow-hidden bg-[#aedff7] border-b border-black">
				<a href="../home/main">
					<img src="/images/로고.png" class="w-[77px] h-[53px] absolute left-[-1px] top-[-1px] object-cover" />
				</a>
				<div class="flex justify-center items-end absolute left-[78px] top-[47px] overflow-hidden px-11 py-[13px]">
					<p
						class="flex justify-center items-center flex-grow-0 flex-shrink-0 max-w-[85px] h-[38px] text-xl font-medium text-center text-black">${param.region}</p>
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
				class="selectLocationDiv flex flex-col justify-start items-center self-stretch flex-grow relative overflow-hidden gap-[18px] px-10 pt-4">
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


				<div id="categoryButtons" class="recommendUI flex !justify-between !items-center w-[315px] px-4 py-2">
					<button class="btn btn-info text-black !text-lg w-[90px]">관광지</button>
					<button class="btn btn-outline btn-info text-black !text-lg w-[90px]">명소</button>
					<button class="btn btn-outline btn-info text-black !text-lg w-[90px]">맛집</button>
				</div>

				<div class="recommendUI flex flex-col justify-start items-start flex-grow w-[407px] relative overflow-auto gap-3">
					<c:forEach var="tripLocation" items="${tripLocations}">
						<div
							class="trip-item cursor-pointer flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[19px] px-[9px] py-[13px]"
							data-name="${tripLocation.locationName}" data-type="${tripLocation.locationTypeId}"
							data-address="${tripLocation.address}" data-number="${tripLocation.number }"
							data-profile="${tripLocation.profile }" data-schedule="${tripLocation.schedule }"
							data-img="${tripLocation.extra__pictureUrl}" data-reviewCount="${tripLocation.reviewCount }"
							data-mapX="${tripLocation.mapX }" data-mapY="${tripLocation.mapY }">

							<img src="${tripLocation.extra__pictureUrl }"
								class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />

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
							<button onClick="event.stopPropagation(); addDailyPlanForPlus(this);"
								class="addDailyPlanButton cursor-pointer pointer-events-auto">
								<i class="fa-solid fa-square-plus text-3xl"></i>
							</button>
						</div>
					</c:forEach>


				</div>

			</div>
			<div class="flex flex-col justify-start items-end self-stretch flex-grow-0 flex-shrink-0 overflow-hidden pr-4">
				<div onClick="if(!confirm('일정을 생성하시겠습니까?')) return false"
					class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[80px] h-[40px] relative overflow-hidden gap-2.5 px-[9px] rounded-[5px] bg-black cursor-pointer">
					<p
						class="flex justify-center items-center flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-white">일정
						생성</p>
				</div>

			</div>

		</div>

		<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 overflow-hidden bg-white">
			<div
				class="dailyPlanContainer w-[527px] transition-all duration-[500ms] ease-in-out flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-screen relative overflow-hidden gap-[9px] border-t-0 border-r border-b-0 border-l-0 border-black">
				<div class="flex-grow-0 flex-shrink-0 w-[527px] h-[134px] relative overflow-hidden">
					<p onClick="deleteAllDailyPlan();"
						class="cursor-pointer w-[99px] h-[21px] absolute left-[428px] top-[113px] text-[15px] font-medium text-center text-[#f00]">
						설정 초기화</p>
					<select id="daySelect"
						class="w-60 h-[59px] absolute left-2 top-0 text-2xl font-medium text-center text-black mt-2 border-none focus:outline-none bg-white border border-gray-300 rounded">
						<c:forEach var="i" begin="1" end="${diffDays}">
							<option value="${i}">${i}일차일정장바구니</option>
						</c:forEach>
					</select>
					<p class="w-[207px] h-10 absolute left-6 top-[84px] text-xl font-medium text-center text-black">시간 : 10:00 ~
						22:00</p>
				</div>
				<div class=" flex flex-col justify-start items-center flex-grow w-[527px] overflow-hidden gap-2.5">
					<c:forEach var="i" begin="1" end="${diffDays}">
						<div
							class="dailyPlan flex-col flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0  overflow-hidden gap-1 px-0.5"
							data-day="${i}">
							<!-- javascript를 통해 일정 생성하는 공간 -->

						</div>
					</c:forEach>
				</div>
			</div>
			<div class="bg-transparent h-screen flex items-center">
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
	<div
		class="infoDiv z-1 left-[520px] transform -translate-x-1/3 opacity-0 transition-all duration-300 hidden flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[898px] w-[377px] absolute gap-2.5 rounded-[20px] bg-white border border-black">
		<img id="info-img"
			class="flex-grow-0 flex-shrink-0 w-[377px] h-[209px] rounded-tl-[20px] rounded-tr-[20px] object-cover" />
		<div
			class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[343px] relative overflow-hidden px-0.5 py-[7px]">
			<div class="flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 overflow-hidden py-px">
				<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden">
					<p id='info-locationName'
						class="flex-grow-0 flex-shrink-0 max-w-[300px] h-[42px] text-[25px] font-medium text-center text-black"></p>
					<p id='info-locationTypeId'
						class="flex-grow-0 flex-shrink-0 w-[42px] h-[18px] text-[15px] font-medium text-center text-black">명소</p>
				</div>
				<div
					class="flex flex-col justify-center items-start flex-grow-0 flex-shrink-0 h-[72px] relative overflow-hidden pl-2">
					<p id="info-reviewCount"
						class="flex-grow-0 flex-shrink-0 w-[184px] h-7 text-[15px] font-medium text-left text-black"></p>
					<p class="flex-grow-0 flex-shrink-0 w-[184px] h-7 text-[15px] font-medium text-left text-black">조회수 : 2000</p>
				</div>
			</div>
			<div onClick="addDailyPlan();"
				class="top-[50px] left-[230px] flex justify-center items-center flex-grow-0 flex-shrink-0 absolute overflow-hidden gap-2.5 rounded-[10px] bg-black cursor-pointer">
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
				<p id="info-address"
					class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[257px] h-[53px] font-medium text-black text-sm"></p>
			</div>
			<div
				class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[11px] px-2">

				<div class="">
					<i class="fa-solid fa-clock text-3xl"></i>
				</div>

				<p id="info-schedule"
					class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[257px] h-[53px] text-xl font-medium text-black"></p>
			</div>
			<div
				class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[5px]">
				<div class="pr-2 pl-2">
					<i class="fa-solid fa-phone text-3xl"></i>
				</div>
				<p id="info-number"
					class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[257px] h-[53px] text-xl font-medium text-black"></p>
			</div>
			<div class="flex justify-start items-start self-stretch flex-grow relative overflow-hidden gap-2.5">
				<div class="pl-2">
					<i class="fa-solid fa-pen-to-square text-3xl"></i>
				</div>
				<p id="info-profile" class="flex-grow-0 flex-shrink-0 w-[303px] h-[173px] text-xl font-medium text-black"></p>
			</div>

		</div>
		<button onClick="closeInfoDiv();"
			class="absolute top-2 right-2 z-10 w-8 h-8 flex items-center justify-center rounded-full bg-gray-200
						hover:bg-gray-300 cursor-pointer">
			<i class="fa-solid fa-xmark text-lg text-black"></i>
		</button>
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