<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="MAIN PAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<a href="../member/developerJoin">회원가입</a>
<a href="../member/login">로그인</a>
<a href="../member/doLogout">로그아웃</a>
<a href="../planner/calendar">캘린더</a>
<a href="../planner/showFullCalendar">캘린더 보기</a>
<a href="../planner/region">지역선택</a>
<a href="../planner/selectTime">시간선택</a>
<a href="../member/profile">프로필 보기</a>
<a href="../article/writeByAI">글쓰기</a>

<div
	class="flex flex-col justify-between items-center w-screen h-[2232px] overflow-hidden bg-white border border-[#0f0000]">
	<div
		class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 h-[138px] overflow-hidden gap-2.5 px-[293px] py-[41px] bg-[#aedff7] border border-black">
		<div
			class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[1008px] h-[138 px] relative gap-2.5 bg-[#aedff7] border-0 border-[#f00]">
			<a href="../home/main">
				<img src="/images/로고.png" class="flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
			</a>
			<div class="flex justify-start items-start self-stretch flex-grow relative overflow-hidden gap-2.5 p-2.5">
				<p class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-[#2f3a4b]">숙박</p>
				<p class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-[#2f3a4b]">맛집</p>
				<p class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-[#2f3a4b]">명소</p>
			</div>
			<div class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 w-[428px] relative">
				<p class="flex-grow w-[107px] h-14 text-xl font-medium text-center text-[#2f3a4b]">여행 기록</p>
				<p class="flex-grow w-[107px] h-14 text-xl font-medium text-center text-[#2f3a4b]">계획 작성</p>
				<p class="flex-grow w-[107px] h-14 text-xl font-medium text-center text-[#2f3a4b]">로그인</p>
				<p class="flex-grow w-[107px] h-14 text-xl font-medium text-center text-[#2f3a4b]">회원가입</p>
			</div>
		</div>
	</div>
	<div
		class="flex flex-col justify-start items-center self-stretch flex-grow relative overflow-hidden gap-[46px] px-2.5 pb-2.5">
		<img src="/images/썸네일.png" class="flex-grow-0 flex-shrink-0 w-[1695px] h-[937px] object-cover" />
		<div
			class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[147px] px-[25px] py-[26px]">
			<p class="self-stretch flex-grow w-[741.5px] h-[401.68px] text-6xl text-center text-black">
				<span class="self-stretch flex-grow w-[741.5px] h-[401.68px] text-6xl text-center text-black">나만의 여행 코스를 </span>
				<br />
				<span class="self-stretch flex-grow w-[741.5px] h-[401.68px] text-6xl text-center text-black">간편하게 만들고</span>
			</p>
			<img src="/images/지도.png" class="flex-grow h-[401.68px] object-cover" />
		</div>
		<p class="self-stretch flex-grow w-[993px] h-[83px] text-6xl text-center text-black">사진과 함께 나만의 경험을 남겨보세요</p>
		<img src="/images/게시판.png" class="flex-grow-0 flex-shrink-0 w-[948.46px] h-[420px] object-cover" />
		<p class="flex-grow-0 flex-shrink-0 w-[501px] h-[274px] text-6xl text-center text-black">
			<span class="flex-grow-0 flex-shrink-0 w-[501px] h-[274px] text-6xl text-center text-black">나만의 여행계획 웹</span>
			<br />
			<span class="flex-grow-0 flex-shrink-0 w-[501px] h-[274px] text-6xl text-center text-black">TripTale</span>
		</p>
		<div
			class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[180px] h-[38px] absolute left-[1125px] top-[1993px] overflow-hidden gap-[19px] px-[37px] rounded-[20px] bg-[#6f89f0]">
			<p class="self-stretch flex-grow-0 flex-shrink-0 w-[109px] h-[38px] text-xl font-medium text-center text-black">
				계획 만들기</p>
			<svg width="23" height="18" viewBox="0 0 23 18" fill="none" xmlns="http://www.w3.org/2000/svg"
				class="flex-grow-0 flex-shrink-0" preserveAspectRatio="none">
        <path d="M21 9.25L13.4051 16.75M21 9.25L13.4051 1.25M21 9.25H1" stroke="white" stroke-width="2"
					stroke-linecap="round"></path>
      </svg>
		</div>
		<p class="flex-grow-0 flex-shrink-0 text-3xl font-medium text-left text-black">계획부터 기록까지, 손쉬운 여행을 위한</p>
	</div>
</div>



<%@ include file="../common/foot.jspf"%>