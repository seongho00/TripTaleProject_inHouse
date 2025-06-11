<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="REGION PAGE"></c:set>
<%@ include file="../common/head.jspf"%>



<div
	class="flex flex-col justify-start items-center w-[1700px] h-[919px] overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<div class="flex justify-end items-center self-stretch flex-grow relative overflow-hidden gap-3 pr-2.5">
		<img src="지도-이미지.png" class="self-stretch flex-grow-0 flex-shrink-0 w-[1180px] object-cover" />
		<div
			class="flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 h-[919px] w-[497px] absolute left-px top-0 overflow-hidden gap-1.5 bg-white border border-black">
			<div
				class="self-stretch flex-grow-0 flex-shrink-0 h-[121px] relative overflow-hidden bg-[#aedff7] border border-black">
				<img src="로고.png" class="w-[77px] h-[53px] absolute left-[-1px] top-[-1px] object-cover" />
				<div class="flex justify-center items-end h-16 absolute left-[79px] top-[47px] overflow-hidden px-11 py-[13px]">
					<p class="flex-grow-0 flex-shrink-0 w-[51px] h-[38px] text-xl font-medium text-center text-black">
						서울</p>
					<p class="flex-grow-0 flex-shrink-0 w-[201px] h-6 text-[15px] font-medium text-center text-black">
						2024.05.24 ~ 2024.05.25</p>
				</div>
				<p class="w-[141px] h-[52px] absolute left-[178.5px] top-2.5 text-3xl font-medium text-center text-black">
					여행 이름</p>
			</div>
			<div class="self-stretch flex-grow relative overflow-hidden">
				<p class="w-[91px] h-[39px] absolute left-[153px] top-[51px] text-xl font-medium text-center text-black">
					추천 장소</p>
				<p class="w-[99px] h-[37px] absolute left-[254px] top-[53px] text-xl font-medium text-center text-black/40">
					장소 찾기</p>
				<div
					class="flex justify-start items-center w-[309px] h-[41px] absolute left-[105px] top-28 gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
					<p class="flex-grow-0 flex-shrink-0 w-[183px] text-xl font-medium text-center text-black/40">장소명을
						입력하세요</p>
					<svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg"
						class="flex-grow-0 flex-shrink-0 w-[21px] h-[21.5px]" preserveAspectRatio="none">
            <circle cx="9" cy="9" r="8.5" transform="matrix(-1 0 0 1 18 0)" stroke="black"></circle>
            <path d="M15 15.5L21 21.5" stroke="black" stroke-linecap="round"></path>
          </svg>
				</div>
				<svg width="83" height="1" viewBox="0 0 83 1" fill="none" xmlns="http://www.w3.org/2000/svg"
					class="absolute left-[157.5px] top-[89.5px]" preserveAspectRatio="none">
          <path d="M0.5 0.5H82" stroke="black" stroke-linecap="round"></path>
        </svg>
				<div
					class="flex justify-center items-center w-[66px] h-[34px] absolute left-[114px] top-[181px] gap-2.5 px-[13px] py-2 rounded-[10px] bg-[#9dcbff]/[0.63]">
					<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">추천</p>
				</div>
				<div
					class="flex justify-center items-center w-[66px] h-[34px] absolute left-[201px] top-[181px] gap-2.5 px-[13px] py-2 rounded-[10px] bg-white/[0.63]">
					<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">명소</p>
				</div>
				<div
					class="flex justify-center items-center w-[66px] h-[34px] absolute left-[281px] top-[181px] gap-2.5 px-[13px] py-2 rounded-[10px] bg-white/[0.63]">
					<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">맛집</p>
				</div>
				<div class="flex flex-col justify-start items-start w-[407px] absolute left-10 top-[231px] gap-3">
					<div class="self-stretch flex-grow-0 flex-shrink-0 h-[107px] relative overflow-hidden">
						<p class="w-[53px] h-5 absolute left-[101px] top-1.5 text-[15px] font-medium text-center text-black">
							명소</p>
						<p class="w-[65px] h-[15px] absolute left-[108px] top-9 text-[15px] font-medium text-center text-black">
							장소 이름</p>
						<p class="w-[65px] h-[15px] absolute left-[108px] top-[67px] text-[15px] font-medium text-center text-black">
							장소 주소</p>
						<img src="image-9.png" class="w-[79px] h-[79px] absolute left-[9px] top-[13px] rounded-[100px] object-cover" />
						<p class="w-[39px] h-[34px] absolute left-[359px] top-[37px] text-3xl font-medium text-center text-black">
							➕</p>
					</div>
					<div class="self-stretch flex-grow-0 flex-shrink-0 h-[107px] relative overflow-hidden">
						<p class="w-[53px] h-5 absolute left-[101px] top-1.5 text-[15px] font-medium text-center text-black">
							명소</p>
						<p class="w-[65px] h-[15px] absolute left-[108px] top-9 text-[15px] font-medium text-center text-black">
							장소 이름</p>
						<p class="w-[65px] h-[15px] absolute left-[108px] top-[67px] text-[15px] font-medium text-center text-black">
							장소 주소</p>
						<p class="w-[39px] h-[34px] absolute left-[359px] top-[37px] text-3xl font-medium text-center text-black">
							➕</p>
						<img src="image-9.png" class="w-[79px] h-[79px] absolute left-[9px] top-[13px] rounded-[100px] object-cover" />
					</div>
					<div class="self-stretch flex-grow-0 flex-shrink-0 h-[107px] relative overflow-hidden">
						<p class="w-[53px] h-5 absolute left-[101px] top-1.5 text-[15px] font-medium text-center text-black">
							명소</p>
						<p class="w-[65px] h-[15px] absolute left-[108px] top-9 text-[15px] font-medium text-center text-black">
							장소 이름</p>
						<p class="w-[65px] h-[15px] absolute left-[108px] top-[67px] text-[15px] font-medium text-center text-black">
							장소 주소</p>
						<p class="w-[39px] h-[34px] absolute left-[359px] top-[37px] text-3xl font-medium text-center text-black">
							➕</p>
						<img src="image-9.png" class="w-[79px] h-[79px] absolute left-[9px] top-[13px] rounded-[100px] object-cover" />
					</div>
				</div>
				<p class="w-[184px] h-[27px] absolute left-[147px] top-4 text-3xl font-medium text-center text-black">
					장소 선택</p>
			</div>
			<div class="self-stretch flex-grow-0 flex-shrink-0 h-[37px] relative overflow-hidden">
				<div
					class="flex justify-center items-center w-[51px] h-[25px] absolute left-[422px] top-1.5 overflow-hidden gap-2.5 px-[9px] rounded-[5px] bg-black">
					<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-white">완료</p>
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="../common/foot.jspf"%>