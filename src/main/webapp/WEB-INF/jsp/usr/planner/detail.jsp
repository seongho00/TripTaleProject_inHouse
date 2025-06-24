<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="PLANNER DETAIL"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/daisyUi.jspf"%>

<script>
	let isExpanded = false;
	let size = ${todayTripPlaces.size() - 1};
	

	/* 카카오맵 관련 전역번수 */
	let map;       // 전역 지도 객체
	let marker;    // 전역 마커 객체

	let infoMarker = null;    // trip-item 클릭 시 마커
	let infoOverlay = null;   // trip-item 클릭 시 이름 오버레이

	let lastInfoId = null; // 전역 변수로 마지막으로 연 info-id 저장
	
	
	$(document).ready(function() {
		kakao.maps.load(function () {
			initMap(); // API가 완전히 로드된 후 실행해야 함
		});
	});
	
	// 카카오톡 맵 설정
	function initMap() {
	    // ✨ 1. li에서 좌표 추출
	    const lineCoords = getPathCoordsFromTimeline();
	    
	    // ✨ 2. 평균 좌표 계산
	    const centerCoord = getCenterFromCoords(lineCoords);

	    const container = document.getElementById('map'); // 지도 담을 영역
	    const options = {
			center: centerCoord, // 서울시청 좌표
			level: 7 // 확대 레벨 (작을수록 확대)
	    };

	    map = new kakao.maps.Map(container, options); // 전역 map 설정

	    marker = new kakao.maps.Marker({ map: map });
	    
	    drawPolyline(map, lineCoords);
	    drawMarkers(map, lineCoords);  
	    // ✨ li 클릭 시 지도 center 이동
	    bindTimelineClickEvents(map);
	    showAllPlaceOverlays(map);
	}

	// 모든 일정 보기 버튼
	function viewAllSchedule(elem) {
		const $sidebar = $('.sidebar');
		const $timelineItems = $('.colTimeLine').find('li');
		const tripId = ${tripId};
		$.ajax({
			type: 'GET',
			url: '/usr/planner/getAllTripPlace', // 컨트롤러 매핑 경로
			data: { tripId: tripId},
			success: function (groupedTripPlaces) {
				const $rowTimeLine = $('.rowTimeLine');
				const $timelineList = $('#timelineList');
				const $tripPlaceList = $('.tripPlaceList'); // 고정된 외부 컨테이너
				$tripPlaceList.empty(); // ⛔ #timelineList 포함 전부 삭제됨
				
			    
				
				Object.entries(groupedTripPlaces).forEach(([dayIndex, tripPlaces]) => {

					let $rowTimeLine = $(`
							  <ul class="rowTimeLine timeline timeline-vertical w-[50px]" data-date="\${tripPlaces[0].extra__date}"></ul>
							`);
				    $tripPlaceList.append($rowTimeLine);
				    let $timelineList = $('<div id="timelineList" class="flex flex-col justify-start items-start flex-grow-0 w-[300px] flex-shrink-0 gap-3"></div>');
				    $tripPlaceList.append($timelineList);
				    
				    const getMinutesFromDuration = (durationStr) => {
					    if (!durationStr) return 0;
					    const parts = durationStr.split(':');
					    const hours = parseInt(parts[0] || '0', 10);
					    const minutes = parseInt(parts[1] || '0', 10);
					    return hours * 60 + minutes;
					};
				    
					tripPlaces.forEach((tripPlace, i) => {
						
						
						const formatTime = (timeStr) => timeStr?.substring(0, 5);
						const durationMinutes = getMinutesFromDuration(tripPlace.duration);
						
						let html = '';
						
						// =========================
						// ✅ 장소 출력
						// =========================
						if(i == 0){
							html += `
								<div draggable="true"
									class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[21px] px-2.5 py-3.5">
								<img src="\${tripPlace.extra__pictureUrl}"
									class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
						        <div class="flex flex-col justify-between items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
									<p class="text-[15px] font-medium text-center text-black">\${formatTime(tripPlace.startTime)} ~ \${formatTime(tripPlace.endTime)}</p>
									<p class="text-[15px] font-medium text-center text-black">\${tripPlace.extra__locationType}</p>
									<p class="text-[15px] font-medium text-center text-black">\${tripPlace.locationName}</p>
								</div>
								</div>
								
								`;
						} else {
							html += `
								<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
								<i class="fa-solid fa-bus-simple"></i>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">\${durationMinutes}분</p>
								</div>
								<div draggable="true"
									class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[21px] px-2.5 py-3.5">
								<img src="\${tripPlace.extra__pictureUrl}"
									class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
						        <div class="flex flex-col justify-between items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
									<p class="text-[15px] font-medium text-center text-black">\${formatTime(tripPlace.startTime)} ~ \${formatTime(tripPlace.endTime)}</p>
									<p class="text-[15px] font-medium text-center text-black">\${tripPlace.extra__locationType}</p>
									<p class="text-[15px] font-medium text-center text-black">\${tripPlace.locationName}</p>
								</div>
								</div>
								
								`;
						}
					    
						$timelineList.append(html);
							
							// =========================
							// ✅ 타임라인 출력
							// =========================
							let liHeight = '145px';
							if (i === 0) liHeight = '120px';
							if (i === 1) liHeight = '180px';
							if (i !== 0 && i !== 1) liHeight = '150px';
							
							const timeLineItem = `
								<li data-startTime="\${formatTime(tripPlace.startTime)}" data-endTime="\${formatTime(tripPlace.endTime)}" class="relative min-h-[\${liHeight}]">
									\${i !== 0 ? '<hr />' : ''}
									<div class="timeline-middle">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
											<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
										</svg>
									</div>
									\${i !== tripPlaces.length - 1 ? '<hr />' : ''}
								</li>
							`;
							$rowTimeLine.append(timeLineItem);
							
						});
					
					
				});
				markTimelineByTime();
				
				// 1. 자식 전체 내용 너비 측정용 dummy span 만들기
				const $clone = $sidebar.clone().css({
					position: 'absolute',
					visibility: 'hidden',
					width: 'fit-content',
					'max-width': 'none'
				}).appendTo('body');

				// 2. 실제 너비 측정
				const contentWidth = $clone.outerWidth();
				const targetWidth = contentWidth * 0.9;
				const eachBoxWidth = targetWidth / 3; 
				
				// 3. 클론 제거
				$clone.remove();
				if (!isExpanded) {
					// 4. 측정된 너비로 max-width 적용
					$sidebar.css('max-width', contentWidth + 'px');
					$sidebar.removeClass('w-[497px]').addClass(`w-[\${contentWidth}px]`);
					$timelineItems.removeClass('w-[80px]').addClass(`w-[\${eachBoxWidth}px]`);
					$(elem).find('button').text("축소하기");
				} else {
					$timelineItems.removeClass(`w-[\${eachBoxWidth}px]`).addClass('w-[80px]');
					$sidebar.removeClass(`w-[\${contentWidth}px]`).addClass('w-[497px]');
					$(elem).find('button').text("전체 보기");
					

					$tripPlaceList.empty(); // ⛔ #timelineList 포함 전부 삭제됨
					let $rowTimeLine = $('<ul class="rowTimeLine timeline timeline-vertical w-[50px]"></ul>');
				    $tripPlaceList.append($rowTimeLine);
				    let $timelineList = $('<div id="timelineList" class="flex flex-col justify-start items-start flex-grow-0 w-[300px] flex-shrink-0 gap-3"></div>');
				    $tripPlaceList.append($timelineList);
					
					
					$('.day-tab[data-index="${dayIndex}"]').trigger('click');
				}

				isExpanded = !isExpanded;
			},
			error: function (xhr, status, error) {
				console.error('에러 발생:', error);
		        alert('데이터를 불러오지 못했습니다.');
			}
		});
		
		
		
	}
	
	// 세로 게이지 오늘까지만 차게끔
	$(document).ready(function () {
		  const today = toDateOnly(new Date()); // 오늘 날짜만
		
		  const tripStartDate = new Date('${formattedStartDate}');
			
		  function toDateOnly(date) {
		    return new Date(date.getFullYear(), date.getMonth(), date.getDate());
		  }

		  $('.colTimeLine > li').each(function (index) {
		    const currentDay = new Date(tripStartDate);
		    currentDay.setDate(tripStartDate.getDate() + index);

		    const currentDateOnly = toDateOnly(currentDay);

		    const $hrs = $(this).find('hr');
		    const $icon = $(this).find('svg');

		    if (currentDateOnly < today) {
		      $hrs.addClass('bg-primary');
		      $icon.addClass('text-primary');
		    } else if (currentDateOnly.getTime() === today.getTime()) {
		      $hrs.addClass('bg-primary');
		      $icon.addClass('text-primary');
		      $(this).find('.timeline-box').next('hr').removeClass('bg-primary');
		    } else {
		      $hrs.removeClass('bg-primary');
		      $icon.removeClass('text-primary');
		    }
		  });
		});
	
	// 가로 타임라인 시간별로 색칠
	$(document).ready(function () {
		markTimelineByTime(); // 최초 실행
	});
	
	function markTimelineByTime() {
		const now = new Date();
		const todayStr = now.toISOString().split('T')[0]; // "YYYY-MM-DD"
		const nowMinutes = now.getHours() * 60 + now.getMinutes();
		
		$('.rowTimeLine > li').each(function () {
			
			const date = $('.rowTimeLine').data('date');
			const dateStr = date.split(' ')[0];
 			const startTimeStr = $(this).data('starttime'); // "HH:mm"
 			const endTimeStr = $(this).data('endtime'); // "HH:mm"

 			const $hrs = $(this).find('hr');
 			const $icon = $(this).find('svg');


			if (!dateStr) return;

			const liDate = new Date(dateStr);

			if (dateStr < todayStr) {
				// 과거 날짜: 전부 색칠
				$hrs.addClass('bg-primary');
				$icon.addClass('text-primary');
			} else if (dateStr === todayStr) {
				// 오늘 날짜: 시간 기준으로 분 비교
				if (!startTimeStr || !endTimeStr) return;

				const [startH, startM] = startTimeStr.split(':').map(Number);
			    const [endH, endM] = endTimeStr.split(':').map(Number);

			    const startMinutes = startH * 60 + startM;
			    const endMinutes = endH * 60 + endM;
				
				if (endMinutes < nowMinutes) {
					$hrs.addClass('bg-primary');
					$icon.addClass('text-primary');
				} else if (startMinutes < nowMinutes && nowMinutes <= endMinutes) {
					$hrs.addClass('bg-primary');
					$icon.addClass('text-primary');
					$(this).find('.timeline-middle').next('hr').removeClass('bg-primary');
				} else {
					$hrs.removeClass('bg-primary');
					$icon.removeClass('text-primary');
				}
			} else {
			// 미래 날짜: 전부 제거
				$hrs.removeClass('bg-primary');
				$icon.removeClass('text-primary');
			}
		});
	}
	
	// N일차 클릭시 그 데이터 가져오기
	$(document).ready(function () {
		$('.day-tab').on('click', function () {
		    const index = $(this).data('index');
		    const tripId = ${tripId};
		    const container = $('#timelineList');
		    const timeLine = $('.rowTimeLine');
		    
		    container.empty(); // ✅ 기존 내용 제거
		    timeLine.empty(); // 타임라인 내용 제거
		    
		    
			$.ajax({
				type: 'GET',
				url: '/usr/planner/getTripPlace', // 컨트롤러 매핑 경로
				data: { tripId: tripId, index: index },
				success: function (tripPlaces) {
					const getMinutesFromDuration = (durationStr) => {
					    if (!durationStr) return 0;
					    const parts = durationStr.split(':');
					    const hours = parseInt(parts[0] || '0', 10);
					    const minutes = parseInt(parts[1] || '0', 10);
					    return hours * 60 + minutes;
					};
					$('.rowTimeLine').removeData('date'); // 캐시 초기화
					$('.rowTimeLine').attr('data-date', tripPlaces[0].extra__date);

					$('.timelineList').innerHTML = '';
					
					tripPlaces.forEach((tripPlace, i) => {
						
						
						
						const formatTime = (timeStr) => timeStr?.substring(0, 5);
						const durationMinutes = getMinutesFromDuration(tripPlace.duration);
						
						let html = '';
						
						// =========================
						// ✅ 장소 출력
						// =========================
						if(i == 0){
							html += `
								<div draggable="true"
									class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[21px] px-2.5 py-3.5">
								<img src="\${tripPlace.extra__pictureUrl}"
									class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
						        <div class="flex flex-col justify-between items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
									<p class="text-[15px] font-medium text-center text-black">\${formatTime(tripPlace.startTime)} ~ \${formatTime(tripPlace.endTime)}</p>
									<p class="text-[15px] font-medium text-center text-black">\${tripPlace.extra__locationType}</p>
									<p class="text-[15px] font-medium text-center text-black">\${tripPlace.locationName}</p>
								</div>
								</div>
								
								`;
						} else {
							html += `
								<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
								<i class="fa-solid fa-bus-simple"></i>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">\${durationMinutes}분</p>
								</div>
								<div draggable="true"
									class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[21px] px-2.5 py-3.5">
								<img src="\${tripPlace.extra__pictureUrl}"
									class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
						        <div class="flex flex-col justify-between items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
									<p class="text-[15px] font-medium text-center text-black">\${formatTime(tripPlace.startTime)} ~ \${formatTime(tripPlace.endTime)}</p>
									<p class="text-[15px] font-medium text-center text-black">\${tripPlace.extra__locationType}</p>
									<p class="text-[15px] font-medium text-center text-black">\${tripPlace.locationName}</p>
								</div>
								</div>
								
								`;
						}
					    
							container.append(html);
							
							// =========================
							// ✅ 타임라인 출력
							// =========================
							let liHeight = '145px';
							if (i === 0) liHeight = '120px';
							if (i === 1) liHeight = '180px';
							if (i !== 0 && i !== 1) liHeight = '150px';
							
							const timeLineItem = `
								<li data-startTime="\${formatTime(tripPlace.startTime)}" data-endTime="\${formatTime(tripPlace.endTime)}" class="relative min-h-[\${liHeight}]">
									\${i !== 0 ? '<hr />' : ''}
									<div class="timeline-middle">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
											<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
										</svg>
									</div>
									\${i !== tripPlaces.length - 1 ? '<hr />' : ''}
								</li>
							`;
							timeLine.append(timeLineItem);
							
						});
					markTimelineByTime(); 
					
				},
				error: function (xhr, status, error) {
					console.error('에러 발생:', error);
			        alert('데이터를 불러오지 못했습니다.');
				}
			});
		});
	});
	
	// 카카오맵을 위한 좌표 추출
	function getPathCoordsFromTimeline() {
	    const coords = [];

	    $('#timelineList .placeList').each(function () {
	        const mapx = $(this).data('mapx');
	        const mapy = $(this).data('mapy');

	        if (mapx && mapy) {
	            coords.push(new kakao.maps.LatLng(mapy, mapx)); // mapY = lat, mapX = lng
	        }
	    });

	    return coords;
	}
	
	// 좌표 그리는 함수
	function drawPolyline(map, coords) {
	    const polyline = new kakao.maps.Polyline({
	        path: coords,
	        strokeWeight: 4,
	        strokeColor: '#FF0000',
	        strokeOpacity: 0.8,
	        strokeStyle: 'solid'
	    });

	    polyline.setMap(map);

	    if (coords.length > 0) {
	        map.setCenter(coords[Math.floor(coords.length / 2)]);
	    }

	    return polyline;
	}
	
	// 처음 보여지는 평균 좌표 계산(중심점)
	function getCenterFromCoords(coords) {
	    if (coords.length === 0) return new kakao.maps.LatLng(37.5665, 126.9780); // fallback center

	    let sumLat = 0;
	    let sumLng = 0;

	    coords.forEach(coord => {
	        sumLat += coord.getLat(); // 위도
	        sumLng += coord.getLng(); // 경도
	    });

	    const avgLat = sumLat / coords.length;
	    const avgLng = sumLng / coords.length;

	    return new kakao.maps.LatLng(avgLat, avgLng);
	}
	
	// 지도 상에 마커 찍기
	function drawMarkers(map, coords) {
	    coords.forEach(coord => {
	        new kakao.maps.Marker({
	            position: coord,
	            map: map
	        });
	    });
	}
	
	// li 클릭 시 지도 이동
	function bindTimelineClickEvents(map) {
	    $('#timelineList .placeList').on('click', function () {
	        const mapx = $(this).data('mapx');
	        const mapy = $(this).data('mapy');

	        if (mapx && mapy) {
	            const center = new kakao.maps.LatLng(mapy, mapx);
	            map.setCenter(center);
			}
		});
	}
	
	// 오버레이 표시
	function showAllPlaceOverlays(map) {
	    $('.placeList').each(function () {
	        const mapx = $(this).data('mapx');
	        const mapy = $(this).data('mapy');
	        const name = $(this).data('name'); // 또는 다른 p 요소

	        if (mapx && mapy && name) {
	            const position = new kakao.maps.LatLng(mapy, mapx);

	            const content = `
	                <div style="padding:4px 10px; background:white; border:1px solid #333; border-radius:4px; font-size:13px;">
	                    \${name}
	                </div>`;

	            const overlay = new kakao.maps.CustomOverlay({
	                content: content,
	                position: position,
	                yAnchor: 2.5
	            });

	            overlay.setMap(map);
	        }
	    });
	}
</script>



<div class="flex flex-col justify-start items-center h-[919px] overflow-hidden  bg-white">
	<div class="flex justify-end items-center self-stretch flex-grow relative overflow-hidden ">
		<div class="fixed left-[300px] h-screen w-screen" id="map"></div>
		<div
			class="sidebar transition-all duration-500 flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 h-[919px] w-[497px] absolute left-0 top-0 overflow-hidden gap-2.5 bg-white border border-black">
			<div
				class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[217px] w-full relative overflow-auto bg-[#aedff7] border-b border-black">
				<div
					class="flex justify-between items-center self-stretch flex-grow-0 flex-shrink-0 h-[53px] relative overflow-hidden">
					<a href="../home/main">
						<img src="/images/로고.png" class="flex-grow-0 flex-shrink-0 w-[77px] h-[53px] object-cover" />
					</a>
					<p
						class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[141px] h-[52px] text-3xl font-medium text-black">${tripInfo.tripName }</p>
					<a href="modify?tripId=${tripId}"
						class="mr-2 flex justify-center items-center flex-grow-0 flex-shrink-0 w-[84px] h-[30px] relative overflow-hidden gap-2.5 px-[11px] rounded-[5px] bg-black/[0.81]">
						<button class="btn btn-neutral flex justify-center items-center flex-grow text-[15px] font-medium text-white">수정하기</button>
					</a>
				</div>
				<div class="flex justify-center items-end flex-grow-0 flex-shrink-0 relative overflow-hidden px-11 py-[13px]">
					<p class="flex-grow-0 flex-shrink-0  text-xl font-medium text-center text-black">${tripInfo.tripRegion }</p>
					<p class="flex-grow-0 flex-shrink-0  h-6 text-[15px] font-medium text-center text-black">${formattedStartDate}
						~ ${formattedEndDate }</p>
				</div>
				<div onClick="viewAllSchedule(this);"
					class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[90px] h-[30px] relative overflow-hidden gap-2.5 px-[11px] rounded-[5px] cursor-pointer">
					<button class="btn btn-neutral flex justify-center items-center text-[15px] font-medium text-white">전체 보기</button>
				</div>
				<!-- 가로 데이지 UI 시작 -->
				<ul class="h-5 colTimeLine timeline transition-all duration-500">
					<li data-index="1" class="day-tab transition-all duration-500 w-[80px]">
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<div class="timeline-end timeline-box cursor-pointer">1일차</div>

						<hr />
					</li>

					<!-- ✅ 반복 출력: 2일차 ~ diffDays-1일차 -->
					<c:if test="${diffDays > 1}">
						<c:forEach var="i" begin="2" end="${diffDays - 1}">
							<li data-index="${i}" class="day-tab transition-all duration-500 w-[80px]">
								<hr />
								<div class="timeline-middle">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
            <path fill-rule="evenodd"
											d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
											clip-rule="evenodd" />
          </svg>
								</div>
								<div class="timeline-end timeline-box cursor-pointer">${i}일차</div>
								<hr />
							</li>
						</c:forEach>

						<!-- ✅ 마지막 li: diffDays일차 (오른쪽 hr 없는 경우) -->
						<li data-index="${diffDays}" class="day-tab transition-all duration-500 w-[80px]">
							<hr />
							<div class="timeline-middle">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
          <path fill-rule="evenodd"
										d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
										clip-rule="evenodd" />
        </svg>
							</div>
							<div class="timeline-end timeline-box cursor-pointer">${diffDays}일차</div>
						</li>
					</c:if>
				</ul>
				<!-- 가로 데이지 UI 끝 -->
			</div>
			<div
				class="tripPlaceList flex justify-start items-start self-stretch flex-grow relative overflow-auto gap-2.5 px-[5px] py-[23px]">

				<!-- 세로 데이지UI 시작 -->
				<ul class="rowTimeLine timeline timeline-vertical w-[50px]" data-date="${todayTripPlaces[0].extra__date}">
					<li data-startTime="${todayTripPlaces[0].startTime }" data-endTime="${todayTripPlaces[0].endTime }"
						class="relative min-h-[120px]">


						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<hr />
					</li>
					<c:if test="${todayTripPlaces.size() >= 2}">

						<li data-startTime="${todayTripPlaces[1].startTime }" data-endTime="${todayTripPlaces[1].endTime }"
							class="relative min-h-[180px]">
							<hr />
							<div class="timeline-middle">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
										d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
										clip-rule="evenodd" />
      </svg>
							</div>
							<hr />
						</li>
					</c:if>
					<!-- ✅ 반복 	 -->
					<c:if test="${todayTripPlaces.size() > 2}">
						<c:forEach var="i" begin="2" end="${todayTripPlaces.size() - 2}">
							<li data-startTime="${todayTripPlaces[i].startTime }" data-endTime="${todayTripPlaces[i].endTime }"
								class="relative min-h-[150px]">
								<hr />
								<div class="timeline-middle">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
											d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
											clip-rule="evenodd" />
      </svg>
								</div>

								<hr />
							</li>
						</c:forEach>

						<!-- ✅ 마지막 li -->
						<li data-startTime="${todayTripPlaces[size].startTime }" data-endTime="${todayTripPlaces[size].endTime }"
							class="relative min-h-[150px]">
							<hr />
							<div class="timeline-middle">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
        <path fill-rule="evenodd"
										d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
										clip-rule="evenodd" />
      </svg>
							</div>
						</li>
					</c:if>
				</ul>
				<!-- 데이지UI 끝-->

				<div id="timelineList" class="flex flex-col justify-start items-start flex-grow-0 w-[300px] flex-shrink-0  gap-3">
					<c:forEach var="tripPlace" items="${todayTripPlaces}" varStatus="status">
						<c:if test="${status.index != 0}">
							<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
								<i class="fa-solid fa-bus-simple"></i>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripPlace.duration.minute }분</p>
							</div>
						</c:if>

						<div draggable="true" data-mapx="${tripPlace.mapX }" data-mapy="${tripPlace.mapY }"
							data-name="${tripPlace.locationName }"
							class="placeList cursor-pointer flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[21px] px-2.5 py-3.5">
							<img src="${tripPlace.extra__pictureUrl}"
								class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
							<div
								class="flex flex-col justify-between items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripPlace.startTime}~
									${tripPlace.endTime}</p>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripPlace.extra__locationType}</p>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripPlace.locationName}</p>
							</div>
						</div>

					</c:forEach>
				</div>



			</div>
		</div>
	</div>
</div>

<%@ include file="../common/foot.jspf"%>