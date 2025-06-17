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
					<p class="flex-grow-0 flex-shrink-0 w-[201px] h-6 text-[15px] font-medium text-center text-black">${formattedStartDate} ~
						${formattedEndDate }</p>
				</div>
				<div onClick="viewAllSchedule(this);"
					class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[90px] h-[30px] relative overflow-hidden gap-2.5 px-[11px] rounded-[20px] bg-black/[0.81] cursor-pointer">
					<p class=" flex justify-center items-center w-[65px] text-[15px] font-medium text-white">전체 보기</p>
				</div>
				<!-- 가로 데이지 UI 시작 -->
				<ul class="h-5 colTimeLine timeline transition-all duration-500">
					<li class="transition-all duration-500 w-[80px]">
						<div class="timeline-end timeline-box cursor-pointer">1일차</div>
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<hr class="bg-primary" />
					</li>
					<li class="transition-all duration-500 w-[80px]">
						<hr class="bg-primary" />
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<div class="timeline-end timeline-box cursor-pointer">2일차</div>
						<hr class="bg-primary" />
					</li>
					<li class="transition-all duration-500 w-[80px]">
						<hr class="bg-primary" />
						<div class="timeline-end timeline-box cursor-pointer">3일차</div>
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<hr />
					</li>
					<li class="transition-all duration-500 w-[80px]">
						<hr />
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<div class="timeline-end timeline-box cursor-pointer">4일차</div>
						<hr />
					</li>
					<li class="transition-all duration-500 w-[80px]">
						<hr />
						<div class="timeline-end timeline-box cursor-pointer">5일차</div>
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
					</li>
				</ul>
				<!-- 가로 데이지 UI 끝 -->
			</div>
			<div class="flex justify-start items-start self-stretch flex-grow relative overflow-auto gap-2.5 px-[5px] py-[23px]">

				<!-- 세로 데이지UI 시작 -->
				<ul class="timeline timeline-vertical w-[50px]">
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
					<div draggable="true"
						class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[21px] px-2.5 py-3.5">
						<img src="image-9.png" class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
						<div
							class="flex flex-col justify-between items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">02:33 ~ 4:33</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">명소</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">서울 롯데타워</p>
						</div>
					</div>
					<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
						<i class="fa-solid fa-bus-simple"></i>
						<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">50분</p>
					</div>
					<div
						class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[21px] px-2.5 py-3.5">
						<img src="image-9.png" class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
						<div
							class="flex flex-col justify-between items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">머무는 시간</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">명소</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">장소 이름</p>
						</div>
					</div>
					<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
						<i class="fa-solid fa-bus-simple"></i>
						<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">50분</p>
					</div>
					<div
						class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[21px] px-2.5 py-3.5">
						<img src="image-9.png" class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
						<div
							class="flex flex-col justify-between items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">머무는 시간</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">명소</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">장소 이름</p>
						</div>
					</div>
					<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
						<i class="fa-solid fa-bus-simple"></i>
						<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">50분</p>
					</div>
					<div
						class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[21px] px-2.5 py-3.5">
						<img src="image-9.png" class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
						<div
							class="flex flex-col justify-between items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">머무는 시간</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">명소</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">장소 이름</p>
						</div>
					</div>
					<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
						<i class="fa-solid fa-bus-simple"></i>
						<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">50분</p>
					</div>
					<div
						class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[21px] px-2.5 py-3.5">
						<img src="image-9.png" class="flex-grow-0 flex-shrink-0 w-[79px] h-[79px] rounded-[100px] object-cover" />
						<div
							class="flex flex-col justify-between items-start self-stretch flex-grow relative overflow-hidden px-0.5 py-[5px]">
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">머무는 시간</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">명소</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">장소 이름</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="../common/foot.jspf"%>