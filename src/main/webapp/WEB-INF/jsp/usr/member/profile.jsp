<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<c:set var="pageTitle" value="PROFILE PAGE"></c:set>
<%@ include file="../common/head.jspf"%>


<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<div
		class="flex flex-col justify-start items-start self-stretch flex-grow-0 flex-shrink-0 h-[138px] relative overflow-hidden gap-2.5 px-2.5 bg-[#aedff7] border border-black">
		<div
			class="self-stretch flex-grow-0 flex-shrink-0 h-[138px] relative overflow-hidden">
			<div
				class="flex justify-center items-center w-[1008px] h-[138px] absolute left-[346px] top-0 gap-2.5 border-0 border-[#f00]">
				<a href="../home/main">
					<img src="/images/로고.png"
						class="flex-grow-0 flex-shrink-0 w-[138px] h-[138px] object-cover" />
				</a>
				<div
					class="flex justify-start items-start self-stretch flex-grow relative overflow-hidden gap-2.5 p-2.5">
					<p
						class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">
						숙박</p>
					<p
						class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">
						맛집</p>
					<p
						class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">
						명소</p>
				</div>
				<div
					class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 w-[428px] relative">
					<p
						class="flex-grow w-[159px] h-14 text-xl font-medium text-center text-black">내
						여행</p>
					<p
						class="flex-grow w-[159px] h-14 text-xl font-medium text-center text-black">
						계획 작성</p>

					<div
						class="flex-grow-0 flex-shrink-0 w-[110px] h-[110px] object-cover">
						<i class="fa-solid fa-user fa-5x"></i>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div
		class="flex justify-between items-center flex-grow w-[1028px] overflow-hidden p-2.5">
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 h-[577px] w-[231px] relative overflow-hidden gap-[26px] px-[93px]">
			<p
				class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">my
				page</p>
			<div
				class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[157px] relative overflow-hidden gap-10">
				<i class="fa-solid fa-user fa-5x"></i>
				<p
					class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">
					프로필 관리</p>
				<p
					class="flex-grow-0 flex-shrink-0 w-[65px] h-[30px] text-xl font-medium text-center text-black">
					이름</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">아이디</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">즐겨찾기</p>
			</div>
		</div>
		<div
			class="flex flex-col justify-between items-center self-stretch flex-grow-0 flex-shrink-0 w-[745px] overflow-hidden px-[171px] py-[29px]">
			<div
				class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[323px] relative overflow-hidden py-[11px]">
				<p
					class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">
					여행 계획 조회</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black/40">
					여행 기록 조회</p>
			</div>
			<div
				class="flex flex-col justify-start items-center flex-grow w-[565px] relative overflow-hidden gap-2.5 pt-[18px] pb-[62px]">
				<div class="flex-grow-0 flex-shrink-0 w-[77px] h-[17px]">
					<p
						class="absolute left-[488px] top-[66px] text-[15px] font-medium text-center text-black">
						최근 항목</p>
					<svg width="12" height="8" viewBox="0 0 12 8" fill="none"
						xmlns="http://www.w3.org/2000/svg"
						class="absolute left-[564.5px] top-[78.5px]"
						preserveAspectRatio="none">
            <path d="M6 8L0.803848 0.5L11.1962 0.5L6 8Z" fill="black"></path>
          </svg>
				</div>
				<div
					class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 overflow-hidden gap-2.5 px-[55px] py-1.5">
					<div
						class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[123px] relative overflow-hidden gap-2.5 px-2 py-[9px] border border-black">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">
							여행 이름</p>
						<img src="image-25.png"
							class="flex-grow-0 flex-shrink-0 w-[18px] h-[18px] object-cover" />
					</div>
					<div
						class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[290px] h-[41px] relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
						<svg width="22" height="22" viewBox="0 0 22 22" fill="none"
							xmlns="http://www.w3.org/2000/svg"
							class="flex-grow-0 flex-shrink-0 w-[21px] h-[21.5px]"
							preserveAspectRatio="none">
              <circle cx="9" cy="9" r="8.5"
								transform="matrix(-1 0 0 1 18 0)" stroke="black"></circle>
              <path d="M15 15.5L21 21.5" stroke="black"
								stroke-linecap="round"></path>
            </svg>
					</div>
				</div>
				<div
					class="flex flex-col justify-start items-start self-stretch flex-grow-0 flex-shrink-0 h-[442px] overflow-hidden gap-2.5 p-2.5">
					<div
						class="flex justify-start items-center self-stretch flex-grow relative overflow-hidden gap-3 pr-[13px] py-2.5">
						<p
							class="flex-grow-0 flex-shrink-0 w-[23px] h-[23px] text-xl font-medium text-center text-black">
							3</p>
						<div
							class="flex-grow-0 flex-shrink-0 w-[174px] h-[114px] relative overflow-hidden border border-black">
							<p
								class="w-20 h-[41px] absolute left-[47px] top-9 text-[15px] font-medium text-center text-black">
								여행 사진</p>
						</div>
						<div
							class="flex flex-col justify-center items-start self-stretch flex-grow relative overflow-hidden gap-2.5 pl-2.5 pr-[27px] py-[15px]">
							<div
								class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
								<p
									class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">
									여행 이름</p>
								<p
									class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">
									여행 장소</p>
							</div>
							<p
								class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">
								여행 기간</p>
							<p
								class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">
								인원수</p>
						</div>
						<img src="image.png"
							class="flex-grow-0 flex-shrink-0 w-6 h-6 object-cover" />
					</div>
					<div
						class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-3 pr-[13px] py-2.5">
						<p
							class="flex-grow-0 flex-shrink-0 w-[23px] h-[23px] text-xl font-medium text-center text-black">
							2</p>
						<div
							class="flex-grow-0 flex-shrink-0 w-[174px] h-[114px] relative overflow-hidden border border-black">
							<p
								class="w-20 h-[41px] absolute left-[47px] top-9 text-[15px] font-medium text-center text-black">
								여행 사진</p>
						</div>
						<div
							class="flex flex-col justify-center items-start self-stretch flex-grow relative overflow-hidden gap-2.5 pl-2.5 pr-[27px] py-[15px]">
							<div
								class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
								<p
									class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">
									여행 이름</p>
								<p
									class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">
									여행 장소</p>
							</div>
							<p
								class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">
								여행 기간</p>
							<p
								class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">
								인원수</p>
						</div>
						<img src="image.png"
							class="flex-grow-0 flex-shrink-0 w-6 h-6 object-cover" />
					</div>
					<div
						class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-3 pr-[13px] py-2.5">
						<p
							class="flex-grow-0 flex-shrink-0 w-[23px] h-[23px] text-xl font-medium text-center text-black">
							1</p>
						<img src="image-24.png"
							class="flex-grow-0 flex-shrink-0 w-[171px] h-[114px] object-cover" />
						<div
							class="flex flex-col justify-center items-start self-stretch flex-grow relative overflow-hidden gap-2.5 pl-2.5 pr-[27px] py-[15px]">
							<div
								class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
								<p
									class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">
									서울 나들이</p>
								<p
									class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">
									서울</p>
							</div>
							<p
								class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">
								2025.05.24~ 2025.05.25</p>
							<p
								class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">
								인원 : 2명</p>
						</div>
						<img src="image.png"
							class="flex-grow-0 flex-shrink-0 w-6 h-6 object-cover" />
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="../common/foot.jspf"%>