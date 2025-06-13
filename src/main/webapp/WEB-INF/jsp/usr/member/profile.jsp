<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<c:set var="pageTitle" value="PROFILE PAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<script>
	function toggleCaret() {
		$('.fa-caret-down').toggleClass('!hidden');
		$('.fa-caret-up').toggleClass('!hidden');
	}

	/* 처음 활성화될 버튼 설정 */
	$(document).ready(function() {
		$('#lookupPlanButton').addClass('btn-active');


	});

	// 여행계획조회 찾기, 여행기록조회 찾기 눌렀을 때
	function lookupPlanButton() {
		if ($('#lookupPlanButton').hasClass('btn-active')) {
			return;
		}
		$('#lookupPlanButton').toggleClass('btn-active');
		$('#lookupRecordButton').toggleClass('btn-active');

	}
	function lookupRecordButton() {
		if ($('#lookupRecordButton').hasClass('btn-active')) {
			return;
		}
		$('#lookupPlanButton').toggleClass('btn-active');
		$('#lookupRecordButton').toggleClass('btn-active');

	}
</script>

<style>
/* 여행계획조회, 여행기록조회 클릭시 색깔, 밑줄 코드 */
#lookupPlanButton.btn-active, #lookupRecordButton.btn-active {
	opacity: 1;
	color: black;
}

#lookupPlanButton, #lookupRecordButton {
	position: relative;
	display: inline-block;
	border-bottom: 2px solid transparent; /* 기본은 안 보임 */
}

#lookupPlanButton::after, #lookupRecordButton::after {
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

#lookupPlanButton.btn-active::after, #lookupRecordButton.btn-active::after
	{
	transform: scaleX(1); /* 애니메이션으로 왼쪽→오른쪽 확장 */
	transition: transform 0.3s;
}
</style>


<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<div
		class="flex flex-col justify-start items-start self-stretch flex-grow-0 flex-shrink-0 h-[138px] relative overflow-hidden gap-2.5 px-2.5 bg-[#aedff7] border border-black">
		<div class="self-stretch flex-grow-0 flex-shrink-0 h-[138px] relative overflow-hidden">
			<div
				class="flex justify-center items-center w-[1008px] h-[138px] absolute left-[346px] top-0 gap-2.5 border-0 border-[#f00]">
				<a href="../home/main">
					<img src="/images/로고.png" class="flex-grow-0 flex-shrink-0 w-[138px] h-[138px] object-cover" />
				</a>
				<div class="flex justify-start items-start self-stretch flex-grow relative overflow-hidden gap-2.5 p-2.5">
					<p class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">숙박</p>
					<p class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">맛집</p>
					<p class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">명소</p>
				</div>
				<div class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 w-[428px] relative">
					<p class="flex-grow w-[159px] h-14 text-xl font-medium text-center text-black">내 여행</p>
					<p class="flex-grow w-[159px] h-14 text-xl font-medium text-center text-black">계획 작성</p>

					<div class="flex-grow-0 flex-shrink-0 w-[110px] h-[110px] object-cover">
						<i class="fa-solid fa-user fa-5x"></i>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="flex justify-between items-center flex-grow w-[1028px] overflow-hidden p-2.5">
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 h-[577px] w-[231px] relative overflow-hidden gap-[26px] px-[93px]">
			<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">my page</p>
			<div
				class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[157px] relative overflow-hidden gap-10">
				<i class="fa-solid fa-user fa-5x"></i>
				<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">프로필 관리</p>
				<p class="flex-grow-0 flex-shrink-0 w-[65px] h-[30px] text-xl font-medium text-center text-black">이름</p>
				<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">아이디</p>
				<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">즐겨찾기</p>
			</div>
		</div>
		<div
			class="flex flex-col justify-between items-center self-stretch flex-grow-0 flex-shrink-0 w-[745px] overflow-hidden px-[171px] py-[29px]">
			<div class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[323px] relative overflow-hidden py-[11px]">
				<p onClick="lookupPlanButton();" id="lookupPlanButton"
					class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center opacity-50  text-black/80 cursor-pointer">여행
					계획 조회</p>
				<p onClick="lookupRecordButton();" id="lookupRecordButton"
					class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center opacity-50 text-black/80 cursor-pointer">여행 기록
					조회</p>
			</div>
			<div
				class="flex flex-col justify-start items-center flex-grow w-[565px] relative overflow-hidden gap-2.5 pt-[18px] pb-[62px]">


				<div
					class="flex justify-center items-end self-stretch flex-grow-0 flex-shrink-0 overflow-hidden gap-2.5 px-[55px] py-1.5">
					<div
						class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[123px] relative overflow-hidden gap-2.5 px-2 py-[9px] border border-black">
						<select name="searchKeyword"
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black focus:outline-none focus:ring-0 focus:border-none">
							<option value="ALL">전체</option>
							<option value="tripName">여행 이름</option>
							<option value="tripLocation">여행 장소</option>
						</select>
					</div>
					<div
						class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[290px] h-[41px] relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
						<input type="text" placeholder="검색어를 입력하세요" autocomplete="off"
							class="focus:outline-none focus:border-none focus:ring-0 flex-grow " />
						<svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg"
							class="flex-grow-0 flex-shrink-0 w-[21px] h-[21.5px] cursor-pointer" preserveAspectRatio="none">
      <circle cx="9" cy="9" r="8.5" transform="matrix(-1 0 0 1 18.5 0)" stroke="black"></circle>
      <path d="M15.5 15.5L21.5 21.5" stroke="black" stroke-linecap="round"></path>
    </svg>
					</div>
					<div onClick="toggleCaret()"
						class="sortOrder flex justify-start items-center flex-grow-0 flex-shrink-0 relative gap-[3px] cursor-pointer">
						<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">최근 순</p>
						<i class="fa-solid fa-caret-down"></i>
						<i class="fa-solid fa-caret-up !hidden"></i>
					</div>
				</div>
				<div
					class="flex flex-col justify-start items-start self-stretch flex-grow-0 flex-shrink-0 h-[442px] overflow-hidden gap-2.5 p-2.5">
					<div class="flex justify-start items-center self-stretch flex-grow relative overflow-hidden gap-3 pr-[13px] py-2.5">
						<p class="flex-grow-0 flex-shrink-0 w-[23px] h-[23px] text-xl font-medium text-center text-black">3</p>
						<div class="flex-grow-0 flex-shrink-0 w-[174px] h-[114px] relative overflow-hidden border border-black">
							<p class="w-20 h-[41px] absolute left-[47px] top-9 text-[15px] font-medium text-center text-black">여행 사진</p>
						</div>
						<div
							class="flex flex-col justify-center items-start self-stretch flex-grow relative overflow-hidden gap-2.5 pl-2.5 pr-[27px] py-[15px]">
							<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
								<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">여행 이름</p>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">여행 장소</p>
							</div>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">여행 기간</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">인원수</p>
						</div>
						<i class="fa-solid fa-bars fa-lg"></i>
					</div>
					<div
						class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-3 pr-[13px] py-2.5">
						<p class="flex-grow-0 flex-shrink-0 w-[23px] h-[23px] text-xl font-medium text-center text-black">2</p>
						<div class="flex-grow-0 flex-shrink-0 w-[174px] h-[114px] relative overflow-hidden border border-black">
							<p class="w-20 h-[41px] absolute left-[47px] top-9 text-[15px] font-medium text-center text-black">여행 사진</p>
						</div>
						<div
							class="flex flex-col justify-center items-start self-stretch flex-grow relative overflow-hidden gap-2.5 pl-2.5 pr-[27px] py-[15px]">
							<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
								<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">여행 이름</p>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">여행 장소</p>
							</div>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">여행 기간</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">인원수</p>
						</div>
						<i class="fa-solid fa-bars fa-lg"></i>
					</div>
					<div
						class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-3 pr-[13px] py-2.5">
						<p class="flex-grow-0 flex-shrink-0 w-[23px] h-[23px] text-xl font-medium text-center text-black">1</p>
						<img src="image-24.png" class="flex-grow-0 flex-shrink-0 w-[171px] h-[114px] object-cover" />
						<div
							class="flex flex-col justify-center items-start self-stretch flex-grow relative overflow-hidden gap-2.5 pl-2.5 pr-[27px] py-[15px]">
							<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
								<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">서울 나들이</p>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">서울</p>
							</div>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">2025.05.24~ 2025.05.25</p>
							<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">인원 : 2명</p>
						</div>
						<i class="fa-solid fa-bars fa-lg"></i>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="../common/foot.jspf"%>