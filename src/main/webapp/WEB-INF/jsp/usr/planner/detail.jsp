<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="PLANNER DETAIL"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/daisyUi.jspf"%>

<script>
	let isExpanded = false;

	function viewAllSchedule(elem) {
		const $sidebar = $('.sidebar');
		const $timelineItems = $('.colTimeLine').find('li');

		if (!isExpanded) {
			$sidebar.removeClass('w-[497px]').addClass('w-[1000px]');
			$timelineItems.removeClass('w-[80px]').addClass('w-[150px]');
			$(elem).find('p').text("축소하기");
		} else {
			$timelineItems.removeClass('w-[150px]').addClass('w-[80px]');
			$sidebar.removeClass('w-[1000px]').addClass('w-[497px]');
			$(elem).find('p').text("전체 보기");
		}

		isExpanded = !isExpanded;
	}
	
	// 세로 게이지 오늘까지만 차게끔
	$(document).ready(function () {
		  const today = toDateOnly(new Date()); // 오늘 날짜만
		
		  const tripStartDate = new Date('${formattedStartDate}');;
			
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
		  const now = new Date();

		  function parseTimeString(timeStr) {
		    const [hours, minutes] = timeStr.split(":").map(Number);
		    const d = new Date();
		    d.setHours(hours, minutes, 0, 0);
		    return d;
		  }

		  $('.colTimeLine > li').each(function () {
		    const $li = $(this);
		    const timeStr = $li.data('time'); // ex: "10:00"

		    if (!timeStr) return; // time 없으면 skip

		    const targetTime = parseTimeString(timeStr);
		    const $hrs = $li.find('hr');
		    const $icon = $li.find('svg');

		    if (targetTime < now) {
		      $hrs.addClass('bg-primary');
		      $icon.addClass('text-primary');
		    } else if (
		      targetTime.getHours() === now.getHours() &&
		      targetTime.getMinutes() === now.getMinutes()
		    ) {
		      $hrs.addClass('bg-primary');
		      $icon.addClass('text-primary');

		      // ➤ 지금 시간일 경우: 오른쪽 막대 (timeline-box 아래 hr)만 제거
		      $li.find('.timeline-box').next('hr').removeClass('bg-primary');
		    } else {
		      $hrs.removeClass('bg-primary');
		      $icon.removeClass('text-primary');
		    }
		  });
		});
</script>



<div class="flex flex-col justify-start items-center h-[919px] overflow-hidden  bg-white border border-[#0f0000]">
	<div class="flex justify-end items-center self-stretch flex-grow relative overflow-hidden ">
		<div
			class="sidebar transition-all duration-500 flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 h-[919px] w-[497px] absolute left-0 top-0 overflow-hidden gap-2.5 bg-white border border-black">
			<div
				class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[217px] w-full relative overflow-auto bg-[#aedff7] border border-black">
				<div
					class="flex justify-between items-center self-stretch flex-grow-0 flex-shrink-0 h-[53px] relative overflow-hidden">
					<a href="../home/main">
						<img src="/images/로고.png" class="flex-grow-0 flex-shrink-0 w-[77px] h-[53px] object-cover" />
					</a>
					<p
						class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[141px] h-[52px] text-3xl font-medium text-black">${tripInfo.tripName }</p>
					<div
						class="mr-2 flex justify-center items-center flex-grow-0 flex-shrink-0 w-[84px] h-[30px] relative overflow-hidden gap-2.5 px-[11px] rounded-[20px] bg-black/[0.81]">
						<p class="flex-grow w-[62px] text-[15px] font-medium text-center text-white cursor-pointer">수정하기</p>
					</div>
				</div>
				<div class="flex justify-center items-end flex-grow-0 flex-shrink-0 relative overflow-hidden px-11 py-[13px]">
					<p class="flex-grow-0 flex-shrink-0 max-w-[100px] text-xl font-medium text-center text-black">${tripInfo.tripRegion }</p>
					<p class="flex-grow-0 flex-shrink-0 w-[201px] h-6 text-[15px] font-medium text-center text-black">${formattedStartDate}
						~ ${formattedEndDate }</p>
				</div>
				<div onClick="viewAllSchedule(this);"
					class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[90px] h-[30px] relative overflow-hidden gap-2.5 px-[11px] rounded-[20px] bg-black/[0.81] cursor-pointer">
					<p class=" flex justify-center items-center w-[65px] text-[15px] font-medium text-white">전체 보기</p>
				</div>
				<!-- 가로 데이지 UI 시작 -->
				<ul class="h-5 colTimeLine timeline transition-all duration-500">
					<li class="transition-all duration-500 w-[80px]">
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
							<li class="transition-all duration-500 w-[80px]">
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
						<li class="transition-all duration-500 w-[80px]">
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
			<div class="flex justify-start items-start self-stretch flex-grow relative overflow-auto gap-2.5 px-[5px] py-[23px]">

				<!-- 세로 데이지UI 시작 -->
				<ul class="rowTimeLine timeline timeline-vertical w-[50px]">
					<li class="relative min-h-[120px]">


						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<hr class="bg-primary" />
					</li>
					<li class="relative min-h-[180px]">
						<hr class="bg-primary" />
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>

						<hr class="bg-primary" />
					</li>
					<li class="relative min-h-[150px]">
						<hr class="bg-primary" />

						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<hr />
					</li>
					<li class="relative min-h-[150px]">
						<hr />
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>

						<hr />
					</li>
					<li class="relative min-h-[150px]">
						<hr />
						<div class="timeline-start timeline-box"></div>
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
					</li>
				</ul>
				<!-- 데이지UI 끝-->
				<div id="timelineList" class="flex flex-col justify-start items-start flex-grow-0 w-[400px] flex-shrink-0  gap-3">
					<c:forEach var="tripLocation" items="${todayTripLocations}">
						<div draggable="true"
							class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[21px] px-2.5 py-3.5">
							<img src="${tripLocation.extra__pictureUrl}"
								class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
							<div
								class="flex flex-col justify-between items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">02:33 ~ 4:33</p>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripLocation.extra__locationType}</p>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripLocation.locationName}</p>
							</div>
						</div>
						<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
							<i class="fa-solid fa-bus-simple"></i>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">50분</p>
						</div>
					</c:forEach>
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="../common/foot.jspf"%>