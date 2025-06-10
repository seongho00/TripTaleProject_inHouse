<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<c:set var="pageTitle" value="ARTICLE LIST"></c:set>
<%@ include file="../common/head.jspf"%>

<div
	class="flex flex-col justify-start items-center w-[1700px] h-[919px] overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<div
		class="flex flex-col justify-start items-start self-stretch flex-grow-0 flex-shrink-0 h-[138px] relative overflow-hidden gap-2.5 px-2.5 bg-[#aedff7] border border-black">
		<div class="self-stretch flex-grow-0 flex-shrink-0 h-[138px] relative overflow-hidden">
			<div
				class="flex justify-center items-center w-[1008px] h-[138px] absolute left-[346px] top-0 gap-2.5 border-0 border-[#f00]">
				<img src="로고.png" class="flex-grow-0 flex-shrink-0 w-[138px] h-[138px] object-cover" />
				<div class="flex justify-start items-start self-stretch flex-grow relative overflow-hidden gap-2.5 p-2.5">
					<p class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">
						숙박</p>
					<p class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">
						맛집</p>
					<p class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">
						명소</p>
				</div>
				<div class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 w-[428px] relative">
					<p class="flex-grow w-[159px] h-14 text-xl font-medium text-center text-black">내 여행</p>
					<p class="flex-grow w-[159px] h-14 text-xl font-medium text-center text-black">계획 작성</p>
					<img src="프로필-아이콘.png" class="flex-grow-0 flex-shrink-0 w-[110px] h-[110px] object-cover" />
				</div>
			</div>
		</div>
	</div>
	<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 overflow-hidden gap-[19px] px-[17px]">
		<div
			class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-2 py-[9px] border border-black">
			<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">여행 이름</p>
			<img src="image-25.png" class="flex-grow-0 flex-shrink-0 w-[15px] h-[15px] object-cover" />
		</div>
		<div
			class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-2 py-[9px] border border-black">
			<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">지역</p>
			<img src="image-25.png" class="flex-grow-0 flex-shrink-0 w-[15px] h-[15px] object-cover" />
		</div>
		<div
			class="flex justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-2 py-[9px] border border-black">
			<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">작성자</p>
			<img src="image-25.png" class="flex-grow-0 flex-shrink-0 w-[15px] h-[15px] object-cover" />
		</div>
		<div
			class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[290px] h-9 relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
			<svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg"
				class="flex-grow-0 flex-shrink-0 w-[21px] h-[21.5px]" preserveAspectRatio="none">
        <circle cx="9" cy="9" r="8.5" transform="matrix(-1 0 0 1 18.5 0)" stroke="black"></circle>
        <path d="M15.5 15.5L21.5 21.5" stroke="black" stroke-linecap="round"></path>
      </svg>
		</div>
	</div>
	<div class="flex justify-center items-start flex-grow w-[1084px] overflow-hidden gap-[13px] py-2.5">
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png" class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울 나들이</p>
				<p class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행 본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수: 2000</p>
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수: 2000</p>
				<img src="image.png" class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png" class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png" class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울 나들이</p>
				<p class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행 본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수: 2000</p>
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수: 2000</p>
				<img src="image.png" class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png" class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png" class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울 나들이</p>
				<p class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행 본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수: 2000</p>
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수: 2000</p>
				<img src="image.png" class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png" class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png" class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울 나들이</p>
				<p class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행 본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수: 2000</p>
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수: 2000</p>
				<img src="image.png" class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png" class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png" class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울 나들이</p>
				<p class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행 본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수: 2000</p>
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수: 2000</p>
				<img src="image.png" class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png" class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png" class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울 나들이</p>
				<p class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행 본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수: 2000</p>
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수: 2000</p>
				<img src="image.png" class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png" class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png" class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울 나들이</p>
				<p class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행 본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수: 2000</p>
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수: 2000</p>
				<img src="image.png" class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png" class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png" class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울 나들이</p>
				<p class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행 본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수: 2000</p>
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수: 2000</p>
				<img src="image.png" class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png" class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png" class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울 나들이</p>
				<p class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행 본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수: 2000</p>
				<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수: 2000</p>
				<img src="image.png" class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png" class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
	</div>
</div>

<%@ include file="../common/foot.jspf"%>