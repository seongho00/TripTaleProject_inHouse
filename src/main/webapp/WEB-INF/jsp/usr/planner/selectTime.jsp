<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="TIME PAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<style>
body {
	position: relative;
}

#timepicker .tui-timepicker {
	transform: scale(0.6); /* 전체 축소 */
	width: 130px; /* 최대 너비 */
	height: auto;
}
/* 전체 영역 최소화 */
#timepicker .tui-timepicker {
	padding: 0 !important;
	margin: 0 !important;
}
</style>
<script>
	let instance;

	$(function() {
		// ✅ DOM 요소 직접 전달
		instance = new tui.TimePicker(document.getElementById('timepicker'), {
			inputType : 'spinbox',
			format : 'HH:mm',
			timeStep : 10,
			showMeridiem : false
		});

		$('form').on('submit', function() {
			const hours = String(instance.hour).padStart(2, '0');
			const minutes = String(instance.minute).padStart(2, '0');

			$('#selectedHourInput').val(hours);
			$('#selectedMinuteInput').val(minutes);
		});
	});
</script>


<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<div
		class="flex absolute justify-end items-center self-stretch flex-grow relative overflow-hidden gap-3 pr-2.5">
		<div
			class="flex flex-col justify-between items-start flex-grow-0 flex-shrink-0 h-[919px] w-[497px] absolute left-px top-0 overflow-hidden pl-px pt-px pb-2.5 bg-white border border-black">
			<div
				class="self-stretch flex-grow-0 flex-shrink-0 h-[121px] relative overflow-hidden bg-[#aedff7] border border-black">
				<a href="../home/main">
					<img src="/images/로고.png"
						class="w-[77px] h-[53px] absolute left-[-1px] top-[-1px] object-cover" />
				</a>
				<div
					class="flex justify-center items-end absolute left-[78px] top-[47px] overflow-hidden px-11 py-[13px]">
					<p
						class="flex-grow-0 flex-shrink-0 w-[51px] h-[38px] text-xl font-medium text-center text-black">${param.region}</p>
					<p
						class="flex-grow-0 flex-shrink-0 w-[210px] h-6 text-[15px] font-medium text-center text-black">${startDate}
						~ ${endDate}</p>
				</div>
				<p
					class="w-[141px] h-[52px] absolute left-[177.5px] top-2.5 text-3xl font-medium text-center text-black">여행
					이름</p>
			</div>

			<div
				class="self-stretch flex-grow-0 flex-shrink-0 h-[759px] relative overflow-auto">
				<p
					class="w-[184px] h-[51px] absolute left-[146.5px] top-0 text-3xl font-medium text-center text-black">시간
					선택</p>
				<div
					class="flex flex-col justify-start items-start w-[407px] absolute left-[35px] top-[95px] gap-3">
					<c:forEach var="date" items="${dateList}" varStatus="status">
						<div
							class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 overflow-hidden gap-2.5 border border-black">
							<div
								class="flex flex-col justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
								<p
									class="flex-grow-0 flex-shrink-0 text-xs font-medium text-center text-black">${status.index + 1}일차</p>
								<p
									class="flex-grow-0 flex-shrink-0 w-[61px] h-[23px] text-[15px] font-medium text-center text-black">${date}
								</p>
							</div>
							<div
								class="flex flex-col justify-between items-center self-stretch flex-grow overflow-hidden py-2.5">
								<div
									class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[227px] relative overflow-hidden">
									<p
										class="flex-grow-0 flex-shrink-0 w-[78px] h-[18px] text-[10px] font-medium text-center text-black">출발
										시간</p>
									<p
										class="flex-grow-0 flex-shrink-0 w-[73px] h-[17px] text-[10px] font-medium text-center text-black">종료
										시간</p>
								</div>
								<div
									class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[283px] relative overflow-hidden gap-2.5 px-2.5 pb-px">
									<div onClick=""
										class="relative flex justify-start items-center flex-grow-0 flex-shrink-0 h-[37px] relative overflow-hidden gap-2.5 py-[11px] cursor-pointer">
										<i
											class="fa-regular fa-clock flex-grow-0 flex-shrink-0 w-3.5 h-3.5 object-cover"></i>
										<!-- <p class="flex-grow-0 flex-shrink-0 w-[87px] h-[17px] text-[15px] font-medium text-center text-black">10:
											00 AM</p> -->
										<div class="absolute top-0 left-0">
											<form action="../test/timePickerResult" method="get">
												<input type="hidden" name="selectHour"
													id="selectedHourInput" />
												<input type="hidden" name="selectMinute"
													id="selectedMinuteInput" />
												<div id="timepicker" class="border-0"></div>

											</form>
										</div>

									</div>


									<p
										class="flex-grow-0 flex-shrink-0 w-[21px] h-[13px] text-[15px] font-medium text-center text-black">~</p>
									<div onClick=""
										class="flex justify-start items-center flex-grow-0 flex-shrink-0 h-[37px] relative overflow-hidden gap-2.5 py-[11px] cursor-pointer">
										<i
											class="fa-regular fa-clock flex-grow-0 flex-shrink-0 w-3.5 h-3.5 object-cover"></i>
										<p
											class="flex-grow-0 flex-shrink-0 w-[87px] h-[17px] text-[15px] font-medium text-center text-black">10:
											00 AM</p>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>


					<div
						class="flex justify-center items-end self-stretch flex-grow-0 flex-shrink-0 h-[99px] overflow-hidden gap-2.5 pl-[72px] pr-[85px] py-[19px]">
						<div
							class="flex justify-start items-start flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 p-2.5 rounded-[10px] bg-black">
							<p
								class="flex-grow-0 flex-shrink-0 w-[205px] h-[41px] text-xl font-medium text-center text-white">시간
								설정 완료</p>
						</div>
					</div>
				</div>
			</div>
		</div>
		<img src="지도-이미지.png"
			class="self-stretch flex-grow-0 flex-shrink-0 w-[1180px] object-cover" />
	</div>

</div>
<!-- 
<div class="selectTime fixed top-0 left-0 w-full h-full z-50 bg-black/40 flex items-center justify-center">
	<div class="flex-grow-0 flex-shrink-0 w-[701px] h-[439px] relative overflow-hidden flex items-center justify-center">
		<form action="../test/timePickerResult" method="get">
			<input type="hidden" name="selectHour" id="selectedHourInput" />
			<input type="hidden" name="selectMinute" id="selectedMinuteInput" />
			<div id="timepicker"></div>

			<button type="submit">확인</button>
		</form>
	</div>
</div> -->

<%@ include file="../common/foot.jspf"%>