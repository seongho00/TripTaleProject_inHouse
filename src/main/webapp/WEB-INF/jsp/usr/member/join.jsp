<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<c:set var="pageTitle" value="JOIN PAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<script>
	function checkUserIdDuplicate(el) {
		$('.checkIdDup-msg').empty();

		const form = $(el).closest('form').get(0);

		$.get('../member/getLoginIdDup', {
			loginId : form.loginId.value
		}, function(data) {
			if (data.success) {
				$('.checkEmptyMsg').html(
						'<div class="text-green-500">' + data.msg + '</div>')
				validLoginId = data.data1;
			} else {
				$('.checkEmptyMsg').html(
						'<div class="text-red-500">' + data.msg + '</div>')
				validLoginId = '';
			}
		}, 'json');

	}

	function checkUserIdEmpty(el) {
		$('.checkIdDup-msg').empty();

		const form = $(el).closest('form').get(0);
		const value = el.value;
		const msg = el.placeholder;

		if (value.length == 0) {
			console.log("실행됨2");
			$('.checkEmptyMsg')
					.html(
							'<div class="text-red-500">' + msg
									+ '가 입력되지 않았습니다. </div>')
		}

	}

	const checkLoginIdDupDebounced = _.debounce(checkUserIdDuplicate, 600);
</script>

<div
	class="flex flex-col justify-center items-center w-screen h-screen overflow-hidden gap-2.5 px-[9px] py-[7px] bg-white border border-[#0f0000]">
	<div class="flex rounded-[10px] border border-black bg-white" style="box-shadow: 4px 4px 4px 0 rgba(0, 0, 0, 0.25);">
		<div class="w-[800px] h-full relative" >
			<img src="/images/loginPageImg.jpg" class="w-full h-full object-cover" />
			<div class="absolute  left-[30px] top-[500px] flex items-center justify-center">
				<p class="text-black text-4xl font-semibold drop-shadow-md bold"
					style="text-shadow: -0.5px -0.5px black, 0.5px 0.5px white;">Plan Your Trip</p>
			</div>
			<a href="../home/main"
				class="absolute w-12 h-12 left-[30px] top-[420px] rounded-full bg-[#18a0fb] text-white flex items-center justify-center shadow hover:bg-[#0f80d8]">
				<i class="fa-solid fa-arrow-right"></i>
			</a>
		</div>

		<div
			class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 w-[510px] overflow-hidden gap-[29px] py-[7px]  pb-10 ">
			<div class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden">
				<a href="../home/main">
					<img src="/images/로고_blue.png" class="flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
				</a>
				<p class="mt-2 flex-grow-0 flex-shrink-0 w-[510px] h-[50px] text-5xl text-center text-black">SIGN UP</p>
			</div>
			<form action="doJoin" id="joinForm" method="POST">
				<div class="flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 relative overflow-hidden">
					<div class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
						<div class="w-[341px] h-[46px] absolute left-[17px] top-[34px] bg-[#f4f5f5] border border-[#757678]"></div>
						<img src="/images/사람.png" class="w-[42px] h-[37px] absolute left-[22px] top-[38px] object-cover" />
						<p class=" w-[103px] h-5 absolute left-[17px] top-2.5 text-lg text-left text-black">아이디</p>
						<input
							class="w-[289px] h-[46px] absolute left-[69px] top-[34px] bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="text" onkeyup="checkUserIdDuplicate(this);" name="loginId" placeholder="ID" autocomplete="off"
							onblur="checkUserIdEmpty(this);"></input>

					</div>
					<div class="checkEmptyMsg w-full flex justify-center items-center "></div>
					<div class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
						<p class="w-[78px] h-5 absolute left-[15px] top-[7px] text-lg text-left text-black">비밀번호</p>
						<div class="w-[341px] h-[46px] absolute left-[15px] top-8 bg-[#f4f5f5] border border-[#757678]"></div>
						<input class="w-[289px] h-[46px] absolute left-[67px] top-8 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="password" name="loginPw" placeholder="PASSWORD" autocomplete="off">
						</input>
						<!-- <i class="absolute left-[100px] top-[38px] fa-solid fa-eye"></i> -->

						<img src="/images/비밀번호.png" class="w-[42px] h-[35px] absolute left-[19px] top-[38px] object-cover" />


					</div>
					<div class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
						<p class="w-[78px] h-5 absolute left-[13px] top-[3px] text-lg text-left text-black">이메일</p>
						<div class="w-[341px] h-[46px] absolute left-[13px] top-7 bg-[#f4f5f5] border border-[#757678]"></div>
						<input class="w-[289px] h-[46px] absolute left-[65px] top-7 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="text" name="email" placeholder="EMAIL" autocomplete="off"></input>
						<img src="/images/이메일.png" class="w-[35px] h-[35px] absolute left-[21px] top-[33px] opacity-50 object-cover" />
					</div>
					<div class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
						<p class="w-[78px] h-5 absolute left-[13px] top-[3px] text-lg text-left text-black">이름</p>
						<div class="w-[341px] h-[46px] absolute left-[13px] top-7 bg-[#f4f5f5] border border-[#757678]"></div>
						<input class="w-[289px] h-[46px] absolute left-[65px] top-7 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="text" name="name" placeholder="NAME" autocomplete="off"></input>
						<img src="/images/사람.png" class="w-[35px] h-[35px] absolute left-[21px] top-[33px]  object-cover" />
					</div>
				</div>
			</form>

			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[276px] h-12 relative overflow-hidden gap-2.5 py-[13px] rounded-[5px] bg-[#18a0fb] border border-black ">
				<button form="joinForm" class="w-full flex-grow-0 flex-shrink-0 text-2xl text-center text-white cursor-pointer">회원가입</button>
			</div>


		</div>

	</div>
</div>

<%@ include file="../common/foot.jspf"%>