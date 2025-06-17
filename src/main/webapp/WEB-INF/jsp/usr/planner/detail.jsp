<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="PLANNER DETAIL"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/daisyUi.jspf"%>

<script>
let isExpanded = false;

	function viewAllSchedule(elem) {
		const $sidebar = $('.sidebar');
		
		if (!isExpanded) {
			$sidebar.removeClass('w-[497px]').addClass('w-[1000px]');
			$(elem).find('p').text("축소하기");
		} else {
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
				class="flex flex-col justify-between items-center flex-grow-0 flex-shrink-0 h-[217px] w-full relative overflow-auto bg-[#aedff7] border border-black">
				<div
					class="flex justify-between items-center self-stretch flex-grow-0 flex-shrink-0 h-[53px] relative overflow-hidden">
					<img src="/images/로고.png" class="flex-grow-0 flex-shrink-0 w-[77px] h-[53px] object-cover" />
					<p class="flex-grow-0 flex-shrink-0 w-[141px] h-[52px] text-3xl font-medium text-center text-black">여행 이름</p>
					<div
						class="mr-2 flex justify-center items-center flex-grow-0 flex-shrink-0 w-[84px] h-[30px] relative overflow-hidden gap-2.5 px-[11px] rounded-[20px] bg-black/[0.81]">
						<p class="flex-grow w-[62px] text-[15px] font-medium text-center text-white">수정하기</p>
					</div>
				</div>
				<div class="flex justify-center items-end flex-grow-0 flex-shrink-0 relative overflow-hidden px-11 py-[13px]">
					<p class="flex-grow-0 flex-shrink-0 w-[39px] text-xl font-medium text-center text-black">서울</p>
					<p class="flex-grow-0 flex-shrink-0 w-[201px] h-6 text-[15px] font-medium text-center text-black">2024.05.24 ~
						2024.05.25</p>
				</div>
				<div onClick="viewAllSchedule(this);"
					class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[90px] h-[30px] relative overflow-hidden gap-2.5 px-[11px] rounded-[20px] bg-black/[0.81] cursor-pointer">
					<p class=" flex justify-center items-center w-[65px] text-[15px] font-medium text-white">전체 보기</p>
				</div>
				<!-- 세로 데이지 UI 시작 -->
				<ul class="h-5 timeline">
					<li>
						<div class="timeline-end timeline-box">1일차</div>
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<hr class="bg-primary" />
					</li>
					<li>
						<hr class="bg-primary" />
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<div class="timeline-end timeline-box">2일차</div>
						<hr class="bg-primary" />
					</li>
					<li>
						<hr class="bg-primary" />
						<div class="timeline-end timeline-box">3일차</div>
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="text-primary h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<hr />
					</li>
					<li>
						<hr />
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
						<div class="timeline-end timeline-box">4일차</div>
						<hr />
					</li>
					<li>
						<hr />
						<div class="timeline-end timeline-box">5일차</div>
						<div class="timeline-middle">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
        <path fill-rule="evenodd"
									d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
									clip-rule="evenodd" />
      </svg>
						</div>
					</li>
				</ul>
				<!-- 세로 데이지 UI 끝 -->
			</div>
			<div class="flex justify-start items-start self-stretch flex-grow relative overflow-auto gap-2.5 px-[5px] py-[23px]">

				<!-- 가로 데이지UI 시작 -->
				<ul class="timeline timeline-vertical  ">
					<li class="relative min-h-[120px]">

						<div class="timeline-start timeline-box"></div>
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
						<div class="timeline-end timeline-box"></div>
						<hr class="bg-primary" />
					</li>
					<li class="relative min-h-[150px]">
						<hr class="bg-primary" />
						<div class="timeline-start timeline-box"></div>
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
						<div class="timeline-end timeline-box"></div>
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
				<div class="flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 w-[407px] gap-3">
					<div
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