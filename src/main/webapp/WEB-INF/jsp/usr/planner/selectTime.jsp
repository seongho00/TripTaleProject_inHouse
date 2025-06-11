<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="TIME PAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<style>
body {
	position: relative;
}
</style>

<link rel="stylesheet" href="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.js"></script>

<script>
	let instance;

	$(function() {
		// 시작 시간 TimePicker 인스턴스 생성

		const startTimeInstance = new tui.TimePicker('#startTimePicker', {
			initialHour : 10,
			inputType : 'spinbox',
			format : 'HH:mm',
			showMeridiem : true
		});

		// 종료 시간 TimePicker 인스턴스 생성

		const endTimeInstance = new tui.TimePicker('#endTimePicker', {
			initialHour : 22,
			inputType : 'spinbox',
			format : 'HH:mm',
			showMeridiem : true
		});

		// 시간 클릭 시 팝업 열고 index 기억
		$('.time-range').on('click', function() {
			selectedIndex = $(this).data('index');
			console.log(selectedIndex);
			$('.timepicker').removeClass('hidden');
		});

		$('#submitBtn').on(
				'click',
				function() {

					let startHour = String(startTimeInstance.getHour())
							.padStart(2, '0');
					const startMin = String(startTimeInstance.getMinute())
							.padStart(2, '0');
					let endHour = String(endTimeInstance.getHour()).padStart(2,
							'0');
					const endMin = String(endTimeInstance.getMinute())
							.padStart(2, '0');

					const startIsAM = startHour < 12;
					const startMeridiemStr = startIsAM ? 'AM' : 'PM';

					const endIsAM = endHour < 12;
					const endMeridiemStr = endIsAM ? 'AM' : 'PM';

					if (!startIsAM) {
						startHour -= 12;
						startHour = String(endHour).padStart(2, '0');
					}

					if (!endIsAM) {
						endHour -= 12;
						endHour = String(endHour).padStart(2, '0');
					}

					const startTimeStr = startHour + ': ' + startMin + ' '
							+ startMeridiemStr;
					const endTimeStr = endHour + ': ' + endMin + ' '
							+ endMeridiemStr;

					$('.start-time[data-index=' + selectedIndex + ']').text(
							startTimeStr);
					$('.end-time[data-index=' + selectedIndex + ']').text(
							endTimeStr);

					$('.selectTime').addClass('hidden');
				});
	});

	function hideTimeSelectDiv() {
		$('.selectTimeDiv').addClass('hidden');
		$('.selectLocationDiv').removeClass('hidden');

	}
</script>

<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<div class="flex absolute justify-end items-center self-stretch flex-grow relative overflow-hidden gap-3 pr-2.5">
		<div
			class="flex flex-col justify-between items-start flex-grow-0 flex-shrink-0 h-[919px] w-[497px] absolute left-px top-0 overflow-hidden pl-px pt-px pb-2.5 bg-white border border-black">
			<div
				class="self-stretch flex-grow-0 flex-shrink-0 h-[121px] relative overflow-hidden bg-[#aedff7] border border-black">
				<a href="../home/main">
					<img src="/images/로고.png" class="w-[77px] h-[53px] absolute left-[-1px] top-[-1px] object-cover" />
				</a>
				<div class="flex justify-center items-end absolute left-[78px] top-[47px] overflow-hidden px-11 py-[13px]">
					<p class="flex-grow-0 flex-shrink-0 w-[51px] h-[38px] text-xl font-medium text-center text-black">${param.region}</p>
					<p class="flex-grow-0 flex-shrink-0 w-[210px] h-6 text-[15px] font-medium text-center text-black">${startDate}
						~ ${endDate}</p>
				</div>
				<p class="w-[141px] h-[52px] absolute left-[177.5px] top-2.5 text-3xl font-medium text-center text-black">여행 이름</p>
			</div>

			<div class="selectTimeDiv self-stretch flex-grow-0 flex-shrink-0 h-[759px] relative overflow-auto">
				<p class="w-[184px] h-[51px] absolute left-[146.5px] top-0 text-3xl font-medium text-center text-black">시간 선택</p>
				<div class="flex flex-col justify-start items-start w-[407px] absolute left-[35px] top-[95px] gap-3">
					<c:forEach var="date" items="${dateList}" varStatus="status">
						<div
							class="flex justify-start items-center self-stretch flex-grow-0 flex-shrink-0 overflow-hidden gap-2.5 border border-black">
							<div
								class="flex flex-col justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
								<p class="flex-grow-0 flex-shrink-0 text-xs font-medium text-center text-black">${status.index + 1}일차</p>
								<p class="flex-grow-0 flex-shrink-0 w-[61px] h-[23px] text-[15px] font-medium text-center text-black">${date}
								</p>
							</div>
							<div class="flex flex-col justify-between items-center self-stretch flex-grow overflow-hidden py-2.5">
								<div class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[227px] relative overflow-hidden">
									<p class="flex-grow-0 flex-shrink-0 w-[78px] h-[18px] text-[10px] font-medium text-center text-black">출발 시간</p>
									<p class="flex-grow-0 flex-shrink-0 w-[73px] h-[17px] text-[10px] font-medium text-center text-black">종료 시간</p>
								</div>
								<div onClick="hideTimeSelectDiv();"
									class="time-range flex justify-start items-center flex-grow-0 flex-shrink-0 w-[283px] relative overflow-hidden gap-2.5 px-2.5 pb-px cursor-pointer"
									data-index="${status.index}">
									<div
										class="relative flex justify-start items-center flex-grow-0 flex-shrink-0 h-[37px] relative overflow-hidden gap-2.5 py-[11px] ">
										<i class="fa-regular fa-clock flex-grow-0 flex-shrink-0 w-3.5 h-3.5 object-cover"></i>
										<div
											class="start-time flex-grow-0 flex-shrink-0 w-[87px] h-[17px] text-[15px] font-medium text-center text-black"
											data-index="${status.index}">10: 00 AM</div>
									</div>
									<p class="flex-grow-0 flex-shrink-0 w-[21px] h-[13px] text-[15px] font-medium text-center text-black">~</p>
									<div onClick=""
										class="flex justify-start items-center flex-grow-0 flex-shrink-0 h-[37px] relative overflow-hidden gap-2.5 py-[11px] ">
										<i class="fa-regular fa-clock flex-grow-0 flex-shrink-0 w-3.5 h-3.5 object-cover"></i>
										<div
											class="end-time flex-grow-0 flex-shrink-0 w-[87px] h-[17px] text-[15px] font-medium text-center text-black"
											data-index="${status.index}">10: 00 AM</div>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>


					<div
						class="flex justify-center items-end self-stretch flex-grow-0 flex-shrink-0 h-[99px] overflow-hidden gap-2.5 pl-[72px] pr-[85px] py-[19px]">
						<button onclick="hideTimeSelectDiv()"
							class="flex justify-start items-start flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 p-2.5 rounded-[10px] bg-black cursor-pointer">
							<p
								class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[205px] h-[41px] text-xl font-medium text-center text-white">시간
								설정 완료</p>
						</button>
					</div>
				</div>

			</div>
			<div
				class="selectLocationDiv hidden flex flex-col justify-start items-center self-stretch flex-grow relative overflow-hidden gap-[18px] px-10 py-4">
				<p class="flex-grow-0 flex-shrink-0 w-[184px] h-[27px] text-3xl font-medium text-center text-black">장소 선택</p>
				<div
					class="flex justify-start items-start flex-grow-0 flex-shrink-0 w-[244px] relative overflow-hidden gap-2.5 px-[22px] py-[9px]">
					<p class="flex-grow-0 flex-shrink-0 w-[91px] h-[39px] text-xl font-medium text-center text-black">추천 장소</p>
					<p class="flex-grow-0 flex-shrink-0 w-[99px] h-[37px] text-xl font-medium text-center text-black/40">장소
						찾기</p>
					<svg width="83" height="2" viewBox="0 0 83 2" fill="none" xmlns="http://www.w3.org/2000/svg"
						class="flex-grow-0 flex-shrink-0" preserveAspectRatio="none">
      <path d="M0.5 1H82" stroke="black" stroke-linecap="round"></path>
    </svg>
				</div>
				<div
					class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[309px] h-[41px] relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
					<p class="flex-grow-0 flex-shrink-0 w-[183px] text-xl font-medium text-center text-black/40">장소명을 입력하세요</p>
					<svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg"
						class="flex-grow-0 flex-shrink-0 w-[21px] h-[21.5px]" preserveAspectRatio="none">
      <circle cx="9" cy="9" r="8.5" transform="matrix(-1 0 0 1 18 0)" stroke="black"></circle>
      <path d="M15 15.5L21 21.5" stroke="black" stroke-linecap="round"></path>
    </svg>
				</div>
				<div class="flex-grow-0 flex-shrink-0 w-[268px] h-14 relative overflow-hidden">
					<div
						class="flex justify-center items-center w-[66px] h-[34px] absolute left-4 top-3 gap-2.5 px-[13px] py-2 rounded-[10px] bg-[#9dcbff]/[0.63]">
						<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">추천</p>
					</div>
					<div
						class="flex justify-center items-center w-[66px] h-[34px] absolute left-[103px] top-3 gap-2.5 px-[13px] py-2 rounded-[10px] bg-white/[0.63]">
						<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">명소</p>
					</div>
					<div
						class="flex justify-center items-center w-[66px] h-[34px] absolute left-[183px] top-3 gap-2.5 px-[13px] py-2 rounded-[10px] bg-white/[0.63]">
						<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">맛집</p>
					</div>
				</div>
				<div class="flex flex-col justify-start items-start flex-grow w-[407px] relative overflow-hidden gap-3">
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
				<div
					class="flex flex-col justify-start items-end self-stretch flex-grow-0 flex-shrink-0 overflow-hidden gap-2.5 py-1.5">
					<div
						class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[51px] h-[25px] relative overflow-hidden gap-2.5 px-[9px] rounded-[5px] bg-black">
						<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-white">완료</p>
					</div>
				</div>
			</div>
		</div>
	
	</div>

</div>

<div class="timepicker fixed top-0 left-0 w-full h-full z-50 bg-black/40 flex items-center justify-center hidden">
	<div
		class="bg-white flex-col flex-grow-0 flex-shrink-0 w-[500px] h-[350px] relative overflow-hidden flex items-center justify-center rounded">

		<div class="flex gap-10 mb-5">
			<div>
				<label class="block mb-2">시작 시간</label>
				<div id="startTimePicker"></div>
			</div>
			<div>
				<label class="block mb-2">종료 시간</label>
				<div id="endTimePicker"></div>
			</div>
		</div>

		<div class="flex justify-end">
			<button type="submit" id="submitBtn">확인</button>
		</div>

	</div>
</div>

<%@ include file="../common/foot.jspf"%>