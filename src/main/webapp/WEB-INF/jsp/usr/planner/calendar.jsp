<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="CALENDAR PAGE"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/daisyUi.jspf"%>
<script>
	let lastValidRange = [];
	$(document).ready(
			function() {flatpickr("#datepicker", {
					dateFormat : "Y-m-d", // 출력 포맷
					mode : "range",
					minDate : "today", // 오늘 이전 날짜 선택 불가능
					inline : true,
					locale : "ko", // 한국어 사용 시
					showMonths : 2,
					onChange : function(selectedDates, dateStr, instance) {
					console.log(selectedDates);
					if (selectedDates.length === 2) {
						const startDate = selectedDates[0];
						const endDate = selectedDates[1];
						console.log(startDate);

						// 날짜 계산
						const diffTime = Math.abs(selectedDates[1] - selectedDates[0]);
						const diffDays = diffTime / (1000 * 60 * 60 * 24);

						if (diffDays > 4) { // 5일 초과 선택 불가
							alert("최대 5일까지 선택할 수 있습니다.");
							instance.setDate(lastValidRange, false); // 이전 유효 범위로 되돌리기
							return;
						}

						// ✅ 날짜 가공 (yyyy-MM-dd 포맷으로)
						const formattedStart = formatDateToLocalYYYYMMDD(startDate);
						const formattedEnd = formatDateToLocalYYYYMMDD(endDate);

						// jQuery 방식으로 값 설정
						$('#startDateInput').val(formattedStart + "T00:00:00");
						$('#endDateInput').val(formattedEnd + "T00:00:00");
					}
				},

			});
		});
	
	function formatDateToLocalYYYYMMDD(date) {
		const year = date.getFullYear();
		const month = String(date.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작
		const day = String(date.getDate()).padStart(2, '0');
		return `\${year}-\${month}-\${day}`;
	}
</script>

<style>
.flatpickr-day.inRange {
	background: #AEDFF7; /* 파란 계열 배경 */
	color: black; /* 글자색 */
	border-color: #AEDFF7;
}

/* 시작일과 종료일 강조 */
.flatpickr-day.startRange, .flatpickr-day.endRange {
	background: #007BFF; /* 진한 파랑 배경 */
	color: white;
	border-radius: 50%; /* 원형으로 강조 */
}
/* 호버 시에도 inRange 색 유지 */
.flatpickr-day.inRange:hover {
	background: #90cdf4;
	color: black;
}

/* 오늘 날짜 (선택되지 않았을 때): 빨간 테두리 동그라미 */
.flatpickr-day.today:not(.selected) {
	border: 2px solid red !important; /* 🔴 빨간 테두리 */
	border-radius: 50% !important; /* 동그라미 */
	background: transparent !important; /* 배경색은 기본 유지 */
	color: inherit; /* 기본 글자색 유지 */
	box-sizing: border-box; /* 테두리 포함 정렬 */
}
/* Flatpickr 내부 달력 컨테이너 스타일 조작 */
.flatpickr-innerContainer {
	position: relative;
}

/* 달력 사이 구분선 */
.flatpickr-innerContainer::before {
	content: "";
	position: absolute;
	top: 0;
	bottom: 0;
	left: 50%;
	width: 1px;
	background-color: #ccc;
	z-index: 10;
}
</style>


<body>
	<div
		class="planner_calender flex flex-col justify-center items-center w-screen h-screen overflow-hidden gap-2.5 bg-[#020000]/[0.43] border border-[#0f0000]">
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[839px] relative overflow-hidden gap-2.5 px-[29px] rounded-[10px] bg-white border-2 border-black">
			<p class=" flex-grow-0 flex-shrink-0 w-[467px] text-[32px] text-center text-black mt-5">여행 일정 선택 하기</p>
			<p class=" flex-grow-0 flex-shrink-0 h-[22px] text-[15px] text-center text-black">유의사항 : 최대 5일까지 선택하실 수 있습니다.</p>
			<div
				class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[839px] relative overflow-hidden px-[165px]">
				<div class="flex justify-start items-center flex-grow-0 flex-shrink-0 overflow-hidden">
					<div
						class=" flex flex-col justify-start items-start flex-grow-0 flex-shrink-0  overflow-hidden   rounded-lg  h-[300px]"
						style="box-shadow: 2px 16px 19px 0 rgba(0, 0, 0, 0.09);">
						<form action="selectTime" id="calendarForm">
							<input type="hidden" name="startDate" id="startDateInput">
							<input type="hidden" name="endDate" id="endDateInput">
							<input type="hidden" name="region" value="${region }" />
							<input type="hidden" name="tripName" value="${tripName }" />
							<input type="text" id="datepicker" style="position: absolute; left: -9999px;">

						</form>
					</div>

				</div>
				<div class="flex justify-end items-center w-[500px] mb-5">
					<button form="calendarForm" class="btn btn-outline btn-info ">확인</button>
				</div>

			</div>
		</div>
	</div>

	<%@ include file="../common/foot.jspf"%>