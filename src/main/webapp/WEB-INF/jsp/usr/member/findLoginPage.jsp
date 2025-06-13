<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="LOGIN PAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<script >

	var activeId = ${activeId};
	var activePw = ${activePw};

</script>

<script>
	/* 처음 활성화될 버튼 설정 */
	$(document).ready(function() {
		function init() {
			if (activeId) {
				$('#idButton').addClass('btn-active');
				$('.findIdUi').addClass('ui-active');
			} else if (activePw) {
				$('#pwButton').addClass('btn-active');
				$('.findPwUi').addClass('ui-active');
			}
		}
		init();
	});
	/* 아이디 찾기, 비밀번호 찾기 눌렀을 때 */

	function findIdButton() {
		if ($('#idButton').hasClass('btn-active')) {
			return;
		}
		$('#idButton').toggleClass('btn-active');
		$('#pwButton').toggleClass('btn-active');
		$('.findIdUi').toggleClass('ui-active');
		$('.findPwUi').toggleClass('ui-active');
	}
	function findPwButton() {
		if ($('#pwButton').hasClass('btn-active')) {
			return;
		}
		$('#idButton').toggleClass('btn-active');
		$('#pwButton').toggleClass('btn-active');
		$('.findIdUi').toggleClass('ui-active');
		$('.findPwUi').toggleClass('ui-active');
	}
</script>

<style>
/* 아이디 찾기, 비밀번호 찾기 클릭시 색깔, 밑줄 코드 */
#idButton.btn-active, #pwButton.btn-active {
	opacity: 1;
	color: black;
}

#idButton, #pwButton {
	position: relative;
	display: inline-block;
	border-bottom: 2px solid transparent; /* 기본은 안 보임 */
}

#idButton::after, #pwButton::after {
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

#idButton.btn-active::after, #pwButton.btn-active::after {
	transform: scaleX(1); /* 애니메    이션으로 왼쪽→오른쪽 확장 */
	transition: transform 0.3s;
}

/* 아이디 찾기, 비밀번호 찾기 Ui 코드 */
.findIdUi, .findPwUi {
	display: none;
}

.findIdUi.ui-active, .findPwUi.ui-active {
	display: block;
}
</style>

<div
	class="flex justify-center items-center w-screen h-screen overflow-hidden gap-2.5 px-[9px] py-[7px] bg-white border border-[#0f0000]">
	<div
		class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[611px] w-[510px] relative overflow-hidden gap-[18px] px-[41px] py-[29px] rounded-[10px] bg-[#aedff7] border border-black"
		style="box-shadow: 4px 4px 4px 0 rgba(0, 0, 0, 0.25);">
		<div
			class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 w-[398px] relative overflow-hidden px-[60px]">
			<a href="../home/main">
				<img src="/images/로고.png" class="flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
			</a>
			<div class="flex justify-center items-center flex-grow-0 flex-shrink-0 h-[67px] relative overflow-hidden gap-[31px]">
				<p class="self-stretch flex-grow-0 flex-shrink-0 w-[322px] h-[67px] text-3xl text-center text-black">아이디/비밀번호 찾기</p>
			</div>
		</div>
		<div
			class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 h-[33px] relative overflow-hidden gap-[10px]">

			<a onClick="findIdButton()" id="idButton"
				class="flex justify-center items-center flex-col flex-grow-0 opacity-50 text-black/80 flex-shrink-0 w-[140px] h-[33px] text-xl text-center text-black cursor-pointer">
				아이디 찾기 </a>

			<a onClick="findPwButton()" id="pwButton"
				class="x self-stretch flex-grow-0 flex-shrink-0 w-[140px] h-[33px] opacity-50 text-xl text-center text-black/80 cursor-pointer">
				비밀번호 찾기</a>
			<div class="underline"></div>
		</div>
		<div class="findIdUi">
			<div class="flex-grow-0 flex-shrink-0 w-[373px] h-[95px] relative overflow-hidden">
				<p class="w-[78px] h-5 absolute left-[17px] top-[7px] text-lg text-left text-black">이름</p>
				<div class="w-[341px] h-[46px] absolute left-[17px] top-[38px] bg-[#f4f5f5] border border-[#757678]"></div>
				<input class="pl-5 w-[289px] h-[46px] absolute left-[69px] top-[38px] bg-[#f4f5f5] border border-[#757678] text-lg"
					type="text" name="name" placeholder="이름" autocomplete="off"></input>

				<br>
				<img class="w-[35px] h-[35px] absolute left-[25px] top-[43px] opacity-50" src="/images/사람.png" />
			</div>
			<div class="flex-grow-0 flex-shrink-0 w-[373px] h-[95px] relative overflow-hidden">
				<p class="w-[78px] h-5 absolute left-[17px] top-[7px] text-lg text-left text-black">이메일</p>
				<div class="w-[341px] h-[46px] absolute left-[17px] top-[38px] bg-[#f4f5f5] border border-[#757678]"></div>
				<input class="pl-5 w-[289px] h-[46px] absolute left-[69px] top-[38px] bg-[#f4f5f5] border border-[#757678] text-lg"
					type="text" name="name" placeholder="이메일" autocomplete="off"></input>
				<img class="w-[35px] h-[35px] absolute left-[25px] top-[43px] opacity-50" src="/images/이메일.png" />
			</div>
		</div>
		<div class="findPwUi">
			<div class="flex-grow-0 flex-shrink-0 w-[373px] h-[95px] relative overflow-hidden">
				<p class="w-[78px] h-5 absolute left-[17px] top-[7px] text-lg text-left text-black">아이디</p>
				<div class="w-[341px] h-[46px] absolute left-[17px] top-[38px] bg-[#f4f5f5] border border-[#757678]"></div>
				<input class="pl-5 w-[289px] h-[46px] absolute left-[69px] top-[38px] bg-[#f4f5f5] border border-[#757678] text-lg"
					type="text" name="name" placeholder="아이디" autocomplete="off"></input>

				<br>
				<img class="w-[35px] h-[35px] absolute left-[25px] top-[43px] opacity-50" src="/images/사람.png" />
			</div>
			<div class="flex-grow-0 flex-shrink-0 w-[373px] h-[95px] relative overflow-hidden">
				<p class="w-[78px] h-5 absolute left-[17px] top-[7px] text-lg text-left text-black">이메일</p>
				<div class="w-[341px] h-[46px] absolute left-[17px] top-[38px] bg-[#f4f5f5] border border-[#757678]"></div>
				<input class="pl-5 w-[289px] h-[46px] absolute left-[69px] top-[38px] bg-[#f4f5f5] border border-[#757678] text-lg"
					type="text" name="name" placeholder="이메일" autocomplete="off"></input>
				<img class="w-[35px] h-[35px] absolute left-[25px] top-[43px] opacity-50" src="/images/이메일.png" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 h-12 w-[276px] relative overflow-hidden rounded-[5px] bg-[#18a0fb]">
			<a class="findIdUi flex-grow-0 flex-shrink-0 text-2xl text-center text-white" href="#">아이디 찾기</a>
			<a class="findPwUi flex-grow-0 flex-shrink-0 text-2xl text-center text-white" href="#">비밀번호 찾기</a>
		</div>
	</div>
</div>

<%@ include file="../common/foot.jspf"%>