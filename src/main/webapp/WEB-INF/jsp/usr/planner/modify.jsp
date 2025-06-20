<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="PLANNER DETAIL"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/daisyUi.jspf"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- 시간선택 UI -->
<link rel="stylesheet" href="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.css" />
<script src="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.js"></script>

<!-- jQuery UI Sortable -->
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">

<!-- 머무는 시간 UI -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>

/* 카카오맵 관련 전역번수 */
let map;       // 전역 지도 객체
let marker;    // 전역 마커 객체

let infoMarker = null;    // trip-item 클릭 시 마커
let infoOverlay = null;   // trip-item 클릭 시 이름 오버레이

let lastInfoId = null; // 전역 변수로 마지막으로 연 info-id 저장


	// 처음 활성화 될 버튼
	$(document).ready(function() {
		function init() {
			$('#recommendButton').addClass('btn-active');
			$('.recommendUI').addClass('ui-active');
			$('#infoButton').addClass('btn-active');
			$('.infoUI').addClass('ui-active');
		}
		init();
		
		kakao.maps.load(function () {
			initMap(); // API가 완전히 로드된 후 실행해야 함
		});
	});


	// 드래그 가능 함수
	$(document).ready(
			function() {
				$(".connected-sortable").sortable({
					handle : ".fa-grip-vertical",
					placeholder : "sortable-placeholder",
					connectWith : ".connected-sortable", // 💡 핵심: 서로 연결
					update : function(event, ui) {
						const $this = $(this);
						const dayIndex = $this.data('day-index');
						const sortedIds = $this.children().map(function() {
							return $(this).data('id');
						}).get();

						// 다른 일차로 이동된 경우
						if (ui.sender) {
							const fromDay = ui.sender.data('day-index');
						}

					}
				}).disableSelection(); // 선택 방지

				// 좌우로 넓이조절
				const $modifyContent = $('#modifyContent');
				const $dragPoint = $('#dragPoint');
				let isDragging = false;

				// 드래그 시작
				$dragPoint.on('mousedown', function(e) {
					isDragging = true;
					$('body').css('cursor', 'ew-resize');
					e.preventDefault();
				});

				// 드래그 중
				$(document).on(
						'mousemove',
						function(e) {
							if (!isDragging)
								return;

							const containerLeft = $modifyContent.offset().left;
							const newWidth = e.clientX - containerLeft;

							const minWidth = 50;
							const maxWidth = 1500;

							const clampedWidth = Math.max(minWidth, Math.min(
									maxWidth, newWidth));

							$modifyContent.css('width', clampedWidth + 'px');

						});

				// 드래그 끝
				$(document).on('mouseup', function() {
					isDragging = false;
					$('body').css('cursor', 'default');
				});

				// 초기 위치 설정
				function updateDragPointPosition() {
					const left = $modifyContent.offset().left;
					const width = $modifyContent.outerWidth();

				}

				// 최초 위치 계산
				updateDragPointPosition();

				// 창 크기 바뀌면 dragPoint 위치 재계산
				$(window).on('resize', updateDragPointPosition);

			});

	// 일정 삭제 버튼
	function deleteDailyPlan(el) {
		$(el).parent().parent().remove();
		updateBucketCount();
	}

	// 수정 완료 버튼
	function submitUpdatedTripOrder() {
		const confirmed = confirm("수정하시겠습니까?");
		if (!confirmed)
			return; // 취소 시 종료

		const allDayData = [];
		
		$(".modifyContent .connected-sortable").each(function() {
			const dayIndex = $(this).data('day-index');
			const tripPlaceIds = $(this).children().map(function() {
				const $place = $(this);
				const id = $place.data('id');
				const duration = $place.find('.duration-input').text().trim(); // ⬅️ duration 추출
				
				return {
					id: id,
					duration: duration
				};
			}).get();
			
			// ⬇️ start-time / end-time 추출 (같은 dayIndex에 해당하는 div에서)
			const $timeRange = $(`.time-range[data-index="\${dayIndex - 1}"]`);
			const startTime = $timeRange.find(".start-time").text().trim(); // ex) "10:00 AM"
			const endTime = $timeRange.find(".end-time").text().trim();     // ex) "01:20 PM"
			

			allDayData.push({
				dayIndex : dayIndex,
				startTime: startTime,
				endTime: endTime,
				tripPlaceIds : tripPlaceIds
			});
		});
		

		

		// Ajax로 데이터 전송
		$.ajax({
			type: "POST",
			url: "/usr/planner/updateTripPlaces",
			contentType: "application/json",
			data: JSON.stringify({
				tripId: ${param.tripId},
				dayDataList: allDayData
			}),
			success: function (response) {
				alert("수정이 완료되었습니다.");
				// location.href = "/usr/planner/detail?tripId=" + tripId;
			},
			error: function (xhr) {
				console.log("수정 실패: " + xhr.responseText);
			}
		});
	}
	
	// 추천장소, 장소 찾기, 장바구니 버튼 눌렀을 때
	function recommendButton() {
		if ($('#recommendButton').hasClass('btn-active')) {
			return;
		}
		$('#recommendButton').addClass('btn-active');
		$('#searchButton').removeClass('btn-active');
		$('#bucketButton').removeClass('btn-active');
		$('.recommendUI').addClass('ui-active');
		$('.searchUI').removeClass('ui-active');
		$('.bucketUI').removeClass('ui-active');
	}
	function searchButton() {
		if ($('#searchButton').hasClass('btn-active')) {
			return;
		}
		$('#recommendButton').removeClass('btn-active');
		$('#searchButton').addClass('btn-active');
		$('#bucketButton').removeClass('btn-active');
		$('.recommendUI').removeClass('ui-active');
		$('.searchUI').addClass('ui-active');
		$('.bucketUI').removeClass('ui-active');
	}
	
	function bucketButton() {
		if ($('#bucketButton').hasClass('btn-active')) {
			return;
		}
		$('#recommendButton').removeClass('btn-active');
		$('#searchButton').removeClass('btn-active');
		$('#bucketButton').addClass('btn-active');
		$('.recommendUI').removeClass('ui-active');
		$('.searchUI').removeClass('ui-active');
		$('.bucketUI').addClass('ui-active');
	}
	
	// 사진, 정보 찾기 버튼 눌렀을 때
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
		
		const tripLocationId = $('#info-id').text();
		
		// 이미지 가져오기
		$.ajax({
				url: 'getTripLocationPicture', 
				method: 'GET',
				data: { tripLocationId : tripLocationId },
				success: function (data) {
					const $container = $('.pictureUI');
		    	    $container.empty(); // 기존 이미지 제거
		    	    data.forEach(url => {
		    			const $img = $(`
		    	        <img src="\${url}" class="w-full mb-4 rounded-xl" />
		    		`);
		    		$container.append($img);
		    	});
		    },
			error: function () {
		    	alert('이미지를 불러오지 못했습니다.');
		    }
		});
	}
	
	// 카카오톡 맵 설정
	function initMap() {
	    const container = document.getElementById('map'); // 지도 담을 영역
	    const options = {
			center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울시청 좌표
			level: 5 // 확대 레벨 (작을수록 확대)
	    };

	    map = new kakao.maps.Map(container, options); // 전역 map 설정

	    marker = new kakao.maps.Marker({ map: map });
	}
	
	// infoDiv 열고 닫기 & 정보 추가하기
	$(function() {
		$('.trip-item').on('click', function() {
			// 선택한 데이터 넘겨받기
			   
			const id = $(this).data('id');
			const name = $(this).data('name');
			const type = $(this).data('type');
			const address = $(this).data('address');
			const img = $(this).data('img');
			const schedule = $(this).data('schedule');
			const profile = $(this).data('profile');
			const number = $(this).data('number');
			const reviewCount = $(this).data('reviewcount');
			const star = $(this).data('star');
			const mapX = $(this).data('mapx');
			const mapY = $(this).data('mapy');
			   
		 	// 이미 열려 있고, 같은 id를 클릭했으면 닫음
		 	if (!$('.infoDiv').hasClass('hidden') && lastInfoId === id) {
		 		closeInfoDiv();
				lastInfoId = null;
		 		return;
		 	}
			   
			// 넘겨받은 데이터 넣기
			$('#info-id').text(id);
			$('#info-locationName').text(name);
			$('#info-locationType').text(type);
			$('#info-address').text(address);
			$('#info-schedule').text(schedule);
			$('#info-profile').text(profile);
			$('#info-number').text(number);
			$('#info-reviewCount').text("리뷰 : " + reviewCount);
			$('#info-star').text("별점 : " + star);
			$('#info-img').attr('src', img);

		      
	 		const $infoDiv = $('.infoDiv');
		       

	 		// infoDiv 열 때 애니메이션
	 		$infoDiv.removeClass('hidden');
	 		requestAnimationFrame(() => {
				$infoDiv.removeClass('-translate-x-1/3 opacity-0').addClass('translate-x-0 opacity-100');
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
	 		
	 		// 현재 id를 저장
	 		lastInfoId = id;
	 	});
	});
		
	   
	   
	// 닫는 버튼 눌렀을 때 
	function closeInfoDiv() {
		const $infoDiv = $('.infoDiv');
		$infoDiv.removeClass('translate-x-0 opacity-100').addClass('-translate-x-1/3 opacity-0');
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
	
	// "추가하기 버튼 누를 때 바구니에 장소 추가하기"
	function addDailyPlan(btn) {
		addDailyPlanForPlus(btn);
	}
	
	// + 버튼 누를 때 바구니에 장소 추가하기
	function addDailyPlanForPlus(btn) {
		
		const $origin = $(btn).closest('.trip-item');

		// 데이터 추출
		const tripData = {
			id: $origin.data('id'),
			name: $origin.data('name'),
			type: $origin.data('type'),
			address: $origin.data('address'),
			number: $origin.data('number'),
			profile: $origin.data('profile'),
			schedule: $origin.data('schedule'),
			img: $origin.data('img'),
			reviewCount: $origin.data('reviewcount'),
			mapX: $origin.data('mapx'),
			mapY: $origin.data('mapy'),
			star: $origin.data('star'),
			locationType: $origin.find('p').eq(0).text()
		};
		
		// bucketUI에 추가할 div 생성
		const $newItem = $(`
			<div
				class="trip-item cursor-pointer flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[19px] px-[9px] py-[13px]"
				data-id="\${tripData.id}" data-name="\${tripData.name}" data-type="\${tripData.type}"
				data-address="\${tripData.address}" data-number="\${tripData.number}"
				data-profile="\${tripData.profile}" data-schedule="\${tripData.schedule}"
				data-img="\${tripData.img}" data-reviewCount="\${tripData.reviewCount}"
				data-mapX="\${tripData.mapX}" data-mapY="\${tripData.mapY}" data-star="\${tripData.star}">

				<img src="\${tripData.img}"
					class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />

				
				<div
					class="flex flex-col justify-end items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
					<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">\${tripData.locationType}</p>
					<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">\${tripData.name}</p>
				</div>
				<div
				class="durationDiv flex justify-end items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 py-6 cursor-pointer">
					<p class="flex-grow-0 flex-shrink-0 w-[98px] h-[35px] text-[13px] font-medium text-center">
						<span class="flex-grow-0 flex-shrink-0 w-[98px] h-[35px] text-[13px] font-medium text-center text-black">머무는
							시간</span>
						<br />
						<span
						class="duration-input flex-grow-0 flex-shrink-0 w-[98px] h-[35px] text-[13px] font-medium text-center text-[#4abef8]">02:00</span>
					</p>
				</div>

				<div
				class="flex flex-col justify-end items-start flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[18px] py-2">
					<i class="cursor-grab fa-solid fa-grip-vertical p-2"></i>
					<i onclick="deleteDailyPlan(this); " class=" fa-solid fa-trash-can cursor-pointer p-2"></i>
				</div>
			</div>
		`);

		// bucketUI에 추가
		$('.bucketUI').append($newItem);
		
		// 숫자 계산
		updateBucketCount();
		
		// ✅ 알림 메시지 띄우기
		showToast("장바구니에 추가되었습니다.");

	}
	
	// 머무는 시간 클릭 시
	$(document).on('click', '.durationDiv', function () {
  		const $div = $(this);
  		const $span = $div.find('.duration-input');
  		const currentValue = $span.text().trim();
		
 		// input 생성 후 span 대체
 		const $input = $('<input type="text" class="temp-duration-input w-[60px] text-center border text-sm" />');
 		$input.val(currentValue);
 		$span.replaceWith($input);
	
 		// Flatpickr 바인딩
		flatpickr($input[0], {
  			enableTime: true,
  			noCalendar: true,
 			dateFormat: "H:i",
  			time_24hr: true,
  			defaultDate: currentValue,
  			onClose: function (selectedDates, dateStr) {
  		    const $newSpan = $('<span class="duration-input flex-grow-0 flex-shrink-0 w-[60px] h-[35px] text-[15px] font-medium text-center text-[#4abef8]"></span>').text(dateStr);
  			$input.replaceWith($newSpan);
 			}
  		});

 		$input[0].focus(); // 입력 포커스
	});
	
	let instance;

	$(function() {
		// 시작 시간 TimePicker 인스턴스 생성

		const startTimeInstance = new tui.TimePicker('#startTimePicker', {
			inputType : 'spinbox',
			format : 'HH:mm',
			showMeridiem : true
		});

		// 종료 시간 TimePicker 인스턴스 생성

		const endTimeInstance = new tui.TimePicker('#endTimePicker', {
			inputType : 'spinbox',
			format : 'HH:mm',
			showMeridiem : true
		});

		// 시간 클릭 시 팝업 열고 index 기억
		$('.time-range').on('click', function() {
			selectedIndex = $(this).data('index');
			
			const startText = $('.start-time[data-index=' + selectedIndex + ']').text();
			const endText = $('.end-time[data-index=' + selectedIndex + ']').text();

			// 🕒 시간 설정 함수
			function applyTime(instance, timeText) {
				if (!timeText || !timeText.includes(':')) return false;

				const [time, meridiem] = timeText.trim().split(' ');
				let [hour, minute] = time.split(':').map(Number);
				if (meridiem === 'PM' && hour < 12) hour += 12;
				if (meridiem === 'AM' && hour === 12) hour = 0;

				instance.setHour(hour);
				instance.setMinute(minute);
				return true;
			}

			const hasStart = applyTime(startTimeInstance, startText);
			const hasEnd = applyTime(endTimeInstance, endText);

			// 값이 없으면 기본값 설정 (10:00 AM, 10:00 PM)
			if (!hasStart) {
				startTimeInstance.setHour(10);
				startTimeInstance.setMinute(0);
			}
			if (!hasEnd) {
				endTimeInstance.setHour(22);
				endTimeInstance.setMinute(0);
			}

			$('.timepicker').removeClass('hidden');
		});

		// 제출 시 텍스트로 표시
		$('#submitBtn').on('click', function () {
			let sh = startTimeInstance.getHour();
			let sm = startTimeInstance.getMinute();
			let eh = endTimeInstance.getHour();
			let em = endTimeInstance.getMinute();

			const startMeridiem = sh >= 12 ? 'PM' : 'AM';
			const endMeridiem = eh >= 12 ? 'PM' : 'AM';

			if (sh === 0) sh = 12;
			if (sh > 12) sh -= 12;
			if (eh === 0) eh = 12;
			if (eh > 12) eh -= 12;

			const startStr = `\${String(sh).padStart(2, '0')}:\${String(sm).padStart(2, '0')} \${startMeridiem}`;
			const endStr = `\${String(eh).padStart(2, '0')}:\${String(em).padStart(2, '0')} \${endMeridiem}`;

			$('.start-time[data-index=' + selectedIndex + ']').text(startStr);
			$('.end-time[data-index=' + selectedIndex + ']').text(endStr);
			
			
			$('.timepicker').removeClass('hidden');
		});

		$('#submitBtn').on('click',function() {

			let startHour = String(startTimeInstance.getHour()).padStart(2, '0');
			const startMin = String(startTimeInstance.getMinute()).padStart(2, '0');
			let endHour = String(endTimeInstance.getHour()).padStart(2,'0');
			const endMin = String(endTimeInstance.getMinute()).padStart(2, '0');

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

			const startTimeStr = startHour + ':' + startMin + ' ' + startMeridiemStr;
			const endTimeStr = endHour + ':' + endMin + ' ' + endMeridiemStr;

			$('.start-time[data-index=' + selectedIndex + ']').text(startTimeStr);
			$('.end-time[data-index=' + selectedIndex + ']').text(endTimeStr);
					
					
					
			$('.timepicker').addClass('hidden');
		});
	});

	// 장바구니 추가 시 알림 메세지
	function showToast(message) {
		const $toast = $('#toast');
		$toast.text(message).removeClass('opacity-0');

		setTimeout(() => {
			$toast.addClass('opacity-0');
		}, 2000); // 2초 후 사라짐
	}
	
	// 장바구니 div 개수세기
	function updateBucketCount() {
		const count = $('.bucketUI .trip-item').length;
		const $badge = $('#bucketCount');

		if (count === 0) {
			$badge.addClass('!hidden');
		} else {
			$badge.removeClass('!hidden').text(count);
		}
	}
	
	
	
	function getUIBysearchKeyword(icon) {
		// 부모 중 recommendUI, searchUI, bucketUI 중 하나를 기준으로 input 찾기
		const $container = $(icon).closest('.recommendUI, .searchUI, .bucketUI');
		const keyword = $container.find('input').val().trim();
		const tripId = ${param.tripId};

		if ($container.hasClass('recommendUI')) source = '추천';
		else if ($container.hasClass('searchUI')) source = '검색';
		else if ($container.hasClass('bucketUI')) source = '장바구니';
		sendKeywordToServer(tripId, keyword, source);
	}
	
	// 키워드 & 종류를 통해 ajax 보내기
	function sendKeywordToServer(tripId, keyword, source) {
		if (!keyword || keyword.trim() === '') {
		    alert('검색어를 입력해주세요.');
		    return;
		}

		$.ajax({
		    url: 'search', // ✅ 서버에 맞게 경로 조정
		    method: 'POST',
		    data:{ tripId :tripId, keyword: keyword, source : source },
		    success: function (response) {
		      console.log(`✅ [${source}] 검색 성공:`, response);
		      // TODO: 결과 UI 업데이트 (source에 따라 다르게 처리 가능)
		    },
		    error: function (xhr, status, error) {
				console.error(`❌ [${source}] 검색 실패:`, error);
				alert('검색 중 오류가 발생했습니다.');
		    }
		});
	}
</script>

<style>
/* 드래그 시 영역 나오게끔 */
.sortable-placeholder {
	height: 107px;
	background: #e0f7ff;
	border: 2px dashed #2196f3;
}

/* 추천장소, 장소 찾기 클릭시 색깔, 밑줄 코드 */
#recommendButton.btn-active, #searchButton.btn-active, #bucketButton.btn-active
	{
	opacity: 1;
	color: black;
}

#recommendButton, #searchButton, #bucketButton {
	position: relative;
	display: inline-block;
	border-bottom: 2px solid transparent; /* 기본은 안 보임 */
}

#recommendButton::after, #searchButton::after, #bucketButton::after {
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

#recommendButton.btn-active::after, #searchButton.btn-active::after,
	#bucketButton.btn-active::after {
	transform: scaleX(1); /* 애니메이션으로 왼쪽→오른쪽 확장 */
	transition: transform 0.3s;
}

/* 추천장소, 장소 찾기 UI css  */
.recommendUI, .searchUI, .bucketUI {
	display: none;
}

.recommendUI.ui-active, .searchUI.ui-active, .bucketUI.ui-active {
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

/* 정보, 사진 Ui 코드 */
.infoUI, .pictureUI {
	display: none;
}

.infoUI.ui-active, .pictureUI.ui-active {
	display: block;
}

/* 머무는 시간 ui 크기 설정 코드 */
.flatpickr-calendar {
	width: 90px !important;
	font-size: 13px;
}
</style>

<div class=" flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5">
	<div class=" flex justify-start items-center self-stretch flex-grow relative overflow-hidden gap-3 pr-2.5">
		<div class="fixed left-[500px] h-screen w-screen" id="map"></div>
		<div
			class="flex flex-col justify-between items-start flex-grow-0 flex-shrink-0 h-[919px] w-[497px] left-px top-0 overflow-hidden pl-px pt-px pb-2.5 bg-white border-r border-black">
			<div
				class="self-stretch flex-grow-0 flex-shrink-0 h-[121px] relative overflow-hidden bg-[#aedff7] border-b border-black">
				<a href="../home/main">
					<img src="/images/로고.png" class="w-[77px] h-[53px] absolute left-[-1px] top-[-1px] object-cover" />
				</a>
				<div class="flex justify-center items-end absolute left-[78px] top-[47px] overflow-hidden px-11 py-[13px]">
					<p
						class="flex justify-center items-center flex-grow-0 flex-shrink-0 max-w-[85px] h-[38px] text-xl font-medium text-center text-black">${tripInfo.tripRegion}</p>
					<p class="flex-grow-0 flex-shrink-0 w-[210px] h-6 text-[15px] font-medium text-center text-black">${startDate}
						~ ${endDate}</p>
				</div>
				<p class="w-[141px] h-[52px] absolute left-[177.5px] top-2.5 text-3xl font-medium text-center text-black">여행 이름</p>
			</div>
			<div
				class="selectLocationDiv flex flex-col justify-start items-center self-stretch flex-grow relative overflow-hidden gap-[18px] px-10 pt-4">
				<p class="flex-grow-0 flex-shrink-0 w-[184px] h-[27px] text-3xl font-medium text-center text-black">장소 선택</p>
				<div
					class="flex justify-start items-start flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[22px] py-[9px]">
					<button onClick="recommendButton()" id="recommendButton"
						class="flex-grow-0 flex-shrink-0 w-[91px] h-[39px] text-xl font-medium text-center opacity-50 text-black/80 cursor-pointer">추천
						장소</button>
					<button onClick="searchButton()" id="searchButton"
						class="flex-grow-0 flex-shrink-0 w-[99px] h-[37px] text-xl font-medium text-center opacity-50 text-black/80 cursor-pointer">장소
						찾기</button>
					<div class="indicator">
						<span id="bucketCount" class="indicator-item badge badge-secondary badge-sm !hidden"></span>
						<button onClick="bucketButton()" id="bucketButton"
							class="flex-grow-0 flex-shrink-0 w-[99px] h-[37px] text-xl font-medium text-center opacity-50 text-black/80 cursor-pointer">장바구니</button>
					</div>
				</div>
				<div
					class="recommendUI flex justify-between items-center flex-grow-0 flex-shrink-0 w-[309px] h-[41px] relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
					<input id="searchInput"
						class="flex-grow-0 flex-shrink-0 w-[260px]  text-xl font-medium  outline-none border-none focus:outline-none focus:border-none"
						placeholder="장소를 입력해주세요" autocomplete="off"></input>
					<i onClick="getUIBysearchKeyword(this);" class="cursor-pointer fa-solid fa-magnifying-glass text-lg"></i>
				</div>

				<div
					class="searchUI flex justify-between items-center flex-grow-0 flex-shrink-0 w-[309px] h-[41px] relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
					<input id="searchInput"
						class="flex-grow-0 flex-shrink-0 w-[260px]  text-xl font-medium  outline-none border-none focus:outline-none focus:border-none"
						placeholder="장소를 입력해주세요" autocomplete="off"></input>
					<i onClick="getUIBysearchKeyword(this);" class="cursor-pointer fa-solid fa-magnifying-glass text-lg"></i>
				</div>

				<div
					class="bucketUI flex justify-between items-center flex-grow-0 flex-shrink-0 w-[309px] h-[41px] relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
					<input id="searchInput"
						class="flex-grow-0 flex-shrink-0 w-[260px]  text-xl font-medium  outline-none border-none focus:outline-none focus:border-none"
						placeholder="장소를 입력해주세요" autocomplete="off"></input>
					<i onClick="getUIBysearchKeyword(this);" class="cursor-pointer fa-solid fa-magnifying-glass text-lg"></i>
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
							data-id="${tripLocation.id}" data-name="${tripLocation.locationName}" data-type="${tripLocation.locationTypeId}"
							data-address="${tripLocation.address}" data-number="${tripLocation.number }"
							data-profile="${tripLocation.profile }" data-schedule="${tripLocation.schedule }"
							data-img="${tripLocation.extra__pictureUrl}" data-reviewCount="${tripLocation.reviewCount }"
							data-mapX="${tripLocation.mapX }" data-mapY="${tripLocation.mapY }" data-star="${tripLocation.star }">

							<img src="${tripLocation.extra__pictureUrl }"
								class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />

							<div class="flex flex-col justify-center items-start flex-grow relative overflow-hidden gap-[11px]">
								<p
									class="self-stretch flex-grow-0 flex-shrink-0 w-[233px] h-[15px]  text-[15px] font-medium text-left text-black">
									${tripLocation.extra__locationType }</p>
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
				<div
					class="bucketUI connected-sortable flex flex-col justify-start items-start flex-grow w-[407px] relative overflow-hidden gap-3">
					<!-- 추가하기를 통해 추가될 공간 -->

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
						<p id="info-star" class="flex-grow-0 flex-shrink-0 w-[184px] h-7 text-[15px] font-medium text-left text-black"></p>
					</div>
				</div>
				<div onClick="addDailyPlan(this);"
					class="top-[50px] left-[230px] flex justify-center items-center flex-grow-0 flex-shrink-0 absolute overflow-hidden gap-2.5 rounded-[10px] bg-black cursor-pointer">
					<p
						class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[104px] h-[50px] text-xl font-medium text-white">
						추가하기</p>
				</div>
			</div>
			<div
				class="flex justify-center items-start flex-grow-0 flex-shrink-0 w-[260px] relative overflow-hidden gap-[54px] px-4">
				<p onClick="infoButton()" id="infoButton"
					class="cursor-pointer flex-grow-0 flex-shrink-0 w-10 h-[30px] text-xl font-medium text-center text-black/40">정보</p>
				<p onClick="pictureButton()" id="pictureButton"
					class="cursor-pointer flex-grow-0 flex-shrink-0 w-10 h-[30px] text-xl font-medium text-center text-black/40">사진</p>
			</div>
			<div class="infoUI flex flex-col justify-start items-start flex-grow overflow-hidden px-[17px]">
				<div
					class=" flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[5px]">
					<div class="pr-2 pl-3">
						<i class="fa-solid fa-location-dot text-3xl"></i>
					</div>
					<p id="info-id" class="hidden"></p>
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
			<div class="pictureUI grid columns-2 gap-4 px-4 overflow-auto"></div>
			<button onClick="closeInfoDiv();"
				class="absolute top-2 right-2 z-10 w-8 h-8 flex items-center justify-center rounded-full bg-gray-200
						hover:bg-gray-300 cursor-pointer">
				<i class="fa-solid fa-xmark text-lg text-black"></i>
			</button>
		</div>



		<div id="modifyContent"
			class="modifyContent flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 h-[919px] w-[977px] absolute left-[497px] top-0 	overflow-hidden gap-2.5 pl-2.5 py-2.5 bg-white border-r border-black">
			<div
				class="flex justify-start items-start self-stretch flex-grow-0 flex-shrink-0 h-[909px] relative overflow-hidden gap-2.5 py-[23px]">


				<c:forEach var="entry" items="${groupedTripPlaces}" varStatus="status">
					<div class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 gap-2.5 overflow-auto">
						<div
							class="flex justify-start items-start self-stretch flex-grow-0 flex-shrink-0  overflow-hidden gap-2.5 pb-[23px]">


							<div class="flex flex-col justify-start items-start self-stretch flex-grow gap-3 ">
								<div
									class="flex flex-col justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden px-[57px] py-3 border border-black">
									<p class="flex-grow-0 flex-shrink-0 w-[72px] font-medium text-center text-black">
										<span class="flex-grow-0 flex-shrink-0 w-[72px] text-xs font-medium text-center text-black">${entry.key}일차</span>
										<br />
										<span class="flex-grow-0 flex-shrink-0 w-[72px] text-[15px] font-medium text-center text-black">${dateList[entry.key - 1]}</span>
									</p>

									<div
										class="time-range flex justify-center items-center flex-grow-0 flex-shrink-0  relative overflow-hidden px-2.5 cursor-pointer"
										data-index="${status.index}">
										<div
											class="relative flex justify-start items-center flex-grow-0 flex-shrink-0  relative overflow-hidden gap-2.5 ">
											<c:set var="startHour" value="${fn:substring(tripDays[status.index].startTime, 0, 2)}" />
											<c:set var="startMinute" value="${fn:substring(tripDays[status.index].startTime, 3, 5)}" />
											<c:set var="startHourInt" value="${startHour + 0}" />
											<c:set var="ampm" value="${startHourInt lt 12 ? 'AM' : 'PM'}" />
											<c:set var="formattedStartHour" value="${startHourInt lt 13 ? startHourInt : startHourInt - 12}" />
											<div
												class="start-time flex-grow-0 flex-shrink-0 w-[87px] h-[17px] text-[13px] font-medium text-center text-black"
												data-index="${status.index}" data-start="">${formattedStartHour}:${startMinute}&nbsp;${ampm}</div>
										</div>
										<p>~</p>

										<div class="flex justify-start items-center flex-grow-0 flex-shrink-0  relative overflow-hidden gap-2.5 ">
											<c:set var="endHour" value="${fn:substring(tripDays[status.index].endTime, 0, 2)}" />
											<c:set var="endMinute" value="${fn:substring(tripDays[status.index].endTime, 3, 5)}" />
											<c:set var="endHourInt" value="${endHour + 0}" />
											<c:set var="ampm" value="${endHourInt lt 12 ? 'AM' : 'PM'}" />
											<c:set var="formattedEndHour" value="${endHourInt lt 13 ? endHourInt : endHourInt - 12}" />
											<div
												class="end-time flex-grow-0 flex-shrink-0 w-[87px] h-[17px] text-[13px] font-medium text-center text-black"
												data-index="${status.index}">${formattedEndHour}:${endMinute}&nbsp;${ampm}</div>
										</div>
									</div>


								</div>
								<div class="trip-day" data-day-index="${entry.key}">
									<div class="sortable-day connected-sortable" data-day-index="${entry.key}">
										<c:forEach var="tripPlace" items="${entry.value}" varStatus="status">
											<div data-id="${tripPlace.tripLocationId}"
												class="trip-place-card flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 h-[107px] relative overflow-hidden gap-[21px] px-2.5 py-3.5">
												<img src="${tripPlace.extra__pictureUrl}"
													class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
												<div
													class="flex flex-col justify-end items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
													<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripPlace.extra__locationType}</p>
													<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripPlace.locationName}</p>
												</div>
												<div
													class="durationDiv flex justify-end items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 py-6 cursor-pointer">
													<p class="flex-grow-0 flex-shrink-0 w-[98px] h-[35px] text-[13px] font-medium text-center">
														<span class="flex-grow-0 flex-shrink-0 w-[98px] h-[35px] text-[13px] font-medium text-center text-black">머무는
															시간</span>
														<br />
														<span
															class="duration-input flex-grow-0 flex-shrink-0 w-[98px] h-[35px] text-[13px] font-medium text-center text-[#4abef8]">${durations.get(status.index)}
														</span>
													</p>
												</div>
												<div
													class="flex flex-col justify-end items-start flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[18px] py-2">
													<i class="cursor-grab fa-solid fa-grip-vertical p-2"></i>
													<i onclick="deleteDailyPlan(this); " class=" fa-solid fa-trash-can cursor-pointer p-2"></i>
												</div>
											</div>
										</c:forEach>
									</div>


								</div>
							</div>
							<div class="fixed bottom-8 right-8 z-50">
								<button onclick="submitUpdatedTripOrder()" class="btn btn-primary text-white text-lg px-6 py-2 shadow-md">
									수정 완료</button>
							</div>
						</div>
					</div>
				</c:forEach>
				<div id="dragPoint"
					class="dragPoint cursor-ew-resize flex justify-start items-center flex-grow-0 flex-shrink-0 absolute right-0 top-0 h-screen overflow-hidden gap-2.5 px-[15px] py-[310px] bg-white">
					<svg width="12" height="28" viewBox="0 0 12 28" fill="none" xmlns="http://www.w3.org/2000/svg"
						class="flex-grow-0 flex-shrink-0" preserveAspectRatio="none">
            <path d="M1 0V28M11 0V28" stroke="black" stroke-width="2"></path>
          </svg>
				</div>
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

<div id="toast"
	class="fixed bottom-5 left-1/2 transform -translate-x-1/2 bg-black text-white text-sm px-4 py-2 rounded-md shadow-lg opacity-0 transition-opacity duration-500 z-50">
	장바구니에 추가되었습니다.</div>

<%@ include file="../common/foot.jspf"%>