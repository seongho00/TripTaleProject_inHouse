<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="PLANNER DETAIL"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/daisyUi.jspf"%>

<!-- jQuery UI Sortable -->
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">

<script>
	// 드래그 가능 함수
	$(document).ready(function() {
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

				console.log(`변경된 ${dayIndex}일차 순서:`, sortedIds);

				// 다른 일차로 이동된 경우
				if (ui.sender) {
					const fromDay = ui.sender.data('day-index');
					console.log(`→ ${fromDay}일차에서 ${dayIndex}일차로 이동됨`);
				}

			}
		}).disableSelection(); // 선택 방지
		
		
		// 좌우로 넓이조절
		const $modifyContent = $('#modifyContent');
	    const $dragPoint = $('#dragPoint');
	    let isDragging = false;

	    // 드래그 시작
	    $dragPoint.on('mousedown', function (e) {
	      isDragging = true;
	      $('body').css('cursor', 'ew-resize');
	      e.preventDefault();
	    });

	    // 드래그 중
	    $(document).on('mousemove', function (e) {
	      if (!isDragging) return;

	      const containerLeft = $modifyContent.offset().left;
	      const newWidth = e.clientX - containerLeft;

	      const minWidth = 300;
	      const maxWidth = 1200;

	      const clampedWidth = Math.max(minWidth, Math.min(maxWidth, newWidth));

	      $modifyContent.css('width', clampedWidth + 'px');
	      
	    });

	    // 드래그 끝
	    $(document).on('mouseup', function () {
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
	}

	// 수정 완료 버튼
	function submitUpdatedTripOrder() {
		const confirmed = confirm("수정하시겠습니까?");
		if (!confirmed)
			return; // 취소 시 종료

		const allDayData = [];

		$(".connected-sortable").each(function() {
			const dayIndex = $(this).data('day-index');
			const tripPlaceIds = $(this).children().map(function() {
				return $(this).data('id');
			}).get();

			allDayData.push({
				dayIndex : dayIndex,
				tripPlaceIds : tripPlaceIds
			});
		});

		// location.href = "/usr/planner/detail?tripId=" + ${param.tripId};
	}
</script>

<style>
.sortable-placeholder {
	height: 107px;
	background: #e0f7ff;
	border: 2px dashed #2196f3;
}
</style>

<div class=" flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5">
	<div class=" flex justify-start items-center self-stretch flex-grow relative overflow-hidden gap-3 pr-2.5">
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
							data-id="${tripLocation.id}" data-name="${tripLocation.locationName}" data-type="${tripLocation.locationTypeId}"
							data-address="${tripLocation.address}" data-number="${tripLocation.number }"
							data-profile="${tripLocation.profile }" data-schedule="${tripLocation.schedule }"
							data-img="${tripLocation.extra__pictureUrl}" data-reviewCount="${tripLocation.reviewCount }"
							data-mapX="${tripLocation.mapX }" data-mapY="${tripLocation.mapY }">

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
			</div>
		</div>



		<div id="modifyContent"
			class="modifyContent flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 h-[919px] w-[977px] absolute left-[497px] top-0 overflow-hidden gap-2.5 pl-2.5 py-2.5 bg-white border-r border-black">
			<div
				class="flex justify-start items-start self-stretch flex-grow-0 flex-shrink-0 h-[909px] relative overflow-hidden gap-2.5 py-[23px]">


				<c:forEach var="entry" items="${groupedTripPlaces}">
					<div class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 gap-2.5">
						<div
							class="flex justify-start items-start self-stretch flex-grow-0 flex-shrink-0 w-[310px] overflow-hidden gap-2.5 pb-[23px]">


							<div class="flex flex-col justify-start items-start self-stretch flex-grow gap-3">
								<div
									class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[57px] py-3 border border-black">
									<p class="flex-grow-0 flex-shrink-0 w-[72px] font-medium text-center text-black">
										<span class="flex-grow-0 flex-shrink-0 w-[72px] text-xs font-medium text-center text-black">${entry.key}일차</span>
										<br />
										<span class="flex-grow-0 flex-shrink-0 w-[72px] text-[15px] font-medium text-center text-black">${dateList[entry.key - 1]}</span>
									</p>
								</div>
								<div class="trip-day" data-day-index="${entry.key}">
									<div class="sortable-day connected-sortable" data-day-index="${entry.key}">
										<c:forEach var="tripPlace" items="${entry.value}">
											<div data-id="${tripPlace.id}"
												class="trip-place-card flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 h-[107px] w-[310px] relative overflow-hidden gap-[21px] px-2.5 py-3.5">
												<img src="${tripPlace.extra__pictureUrl}"
													class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
												<div
													class="flex flex-col justify-end items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
													<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripPlace.extra__locationType}</p>
													<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripPlace.locationName}</p>
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
					class="dragPoint cursor-ew-resize flex justify-start items-center flex-grow-0 flex-shrink-0 absolute right-0 top-[130px] overflow-hidden gap-2.5 px-[15px] py-[310px] bg-white">
					<svg width="12" height="28" viewBox="0 0 12 28" fill="none" xmlns="http://www.w3.org/2000/svg"
						class="flex-grow-0 flex-shrink-0" preserveAspectRatio="none">
            <path d="M1 0V28M11 0V28" stroke="black" stroke-width="2"></path>
          </svg>
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="../common/foot.jspf"%>