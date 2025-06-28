<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.security.SecureRandom"%>
<%@ page import="java.math.BigInteger"%>

<c:set var="pageTitle" value="LOGIN PAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<%
String clientId = "5lIc5HiT6OdtWBZYb5k5";//애플리케이션 클라이언트 아이디값";
String redirectURI = URLEncoder.encode("http://localhost:8080/usr/member/naverCallback", "UTF-8");
SecureRandom random = new SecureRandom();
String state = new BigInteger(130, random).toString();
String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code" + "&client_id=" + clientId
		+ "&redirect_uri=" + redirectURI + "&state=" + state;
session.setAttribute("state", state);
%>


<script>
	/* 아이디 입력 시 바로 중복체크 */
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
	/* 아이디 입력 안 했을 경우 메시지 띄우기 */
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
<script>
	/* loginDiv, loginImg 서로 크로스  */
	$(document)
			.ready(
					function() {
						$('.signUpButton')
								.on(
										'click',
										function(e) {
											e.preventDefault();

											// 1단계: loginDiv, loginImg 슬라이드+페이드 아웃
											$('.loginDiv').addClass(
													'slide-fade-out-right');
											$('.loginImg').addClass(
													'slide-fade-out-left');

											// 2단계: 0.5초 후 완전히 숨기고 join 요소 보여줌
											setTimeout(
													function() {
														$(
																'.loginDiv, .loginImg')
																.addClass(
																		'hidden')
																.removeClass(
																		'slide-fade-out-right slide-fade-out-left');

														// join 요소 초기 상태 설정
														$('.joinDIv, .joinImg')
																.removeClass(
																		'hidden')
																.addClass(
																		'hidden-slide');

														// 0.01초 후 slide-in + fade-in 적용
														setTimeout(
																function() {
																	$(
																			'.joinDIv, .joinImg')
																			.removeClass(
																					'hidden-slide')
																			.addClass(
																					'slide-fade-in');
																}, 10);
													}, 500);
										});
					});

	function openFindLoginPage() {
	    const width = 500;
	    const height = 600;
	    const left = (screen.width - width) / 2;   // 화면 가운데 정렬
	    const top = (screen.height - height) / 2;
	    
		window.open('/usr/member/findLoginPage',
				'FindIDPW',
				`width=\${width},height=\${height},left=\${left},top=\${top},resizable=no,scrollbars=no`);

	}
	
	function showJoinPassword() {
		const $input = $('#joinPasswordInput');
	    const currentType = $input.attr('type');

	    if (currentType === 'password') {
			$input.attr('type', 'text');
			$('#joinPassword').removeClass('fa-eye').addClass('fa-eye-slash');
	    } else {
			$input.attr('type', 'password');
			$('#joinPassword').removeClass('fa-eye-slash').addClass('fa-eye');
	    }
	}
</script>

<style>/* 슬라이드 아웃 + 페이드 아웃 */
.slide-fade-out-right {
	transform: translateX(800px);
	opacity: 0;
	transition: transform 0.5s ease-in-out, opacity 0.5s ease-in-out;
}

.slide-fade-out-left {
	transform: translateX(-510px);
	opacity: 0;
	transition: transform 0.5s ease-in-out, opacity 0.5s ease-in-out;
}

/* 슬라이드 인 + 페이드 인 */
.slide-fade-in {
	transform: translateX(0);
	opacity: 1;
	transition: transform 0.5s ease-in-out, opacity 0.5s ease-in-out;
}

/* 초기 상태는 opacity: 0, transform 원위치 */
.hidden-slide {
	opacity: 0;
	transform: translateX(0);
}
</style>


<div
	class="flex bg-black/40 justify-center items-center w-screen h-screen overflow-hidden px-[9px] py-[7px]  border border-[#0f0000]">

	<div class="flex rounded-[10px] border border-black bg-white"
		style="box-shadow: 4px 4px 4px 0 rgba(0, 0, 0, 0.25);">
		<div
			class="loginDiv flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 w-[510px] overflow-hidden gap-[29px] py-[7px] ">
			<div
				class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden">
				<a href="../home/main">
					<img src="/images/로고_blue.png"
						class="bg-white flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
				</a>

			</div>
			<div
				class="flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 relative overflow-hidden">
				<form action="doLogin" id="loginForm">
					<div
						class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
						<div
							class="w-[341px] h-[46px] absolute left-[17px] top-[34px] bg-[#f4f5f5] border border-[#757678]"></div>
						<div
							class="w-[289px] h-[46px] absolute left-[69px] top-[34px] bg-[#f4f5f5] border border-[#757678]"></div>
						<p
							class="w-[235px] h-[46px] absolute left-[95px] top-[35px] text-lg text-left text-[#757678]">아이디</p>
						<img src="/images/사람.png"
							class="w-[42px] h-[37px] absolute left-[22px] top-[38px] object-cover" />
						<input
							class="w-[289px] h-[46px] absolute left-[69px] top-[34px] bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="text" name="loginId" placeholder="ID" autocomplete="off"></input>

						<!-- <p class="w-[103px] h-5 absolute left-[17px] top-2.5 text-lg text-left text-black">아이디</p> -->
					</div>
					<div
						class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
						<div
							class="w-[341px] h-[46px] absolute left-[15px] top-8 bg-[#f4f5f5] border border-[#757678]"></div>
						<div
							class="w-[289px] h-[46px] absolute left-[67px] top-8 bg-[#f4f5f5] border border-[#757678]"></div>
						<input
							class="w-[289px] h-[46px] absolute left-[67px] top-8 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="text" name="loginPw" placeholder="PASSWORD"
							autocomplete="off"></input>

						<img src="/images/비밀번호.png"
							class="w-[42px] h-[35px] absolute left-[19px] top-[38px] object-cover" />
						<!-- <p class="w-[78px] h-5 absolute left-[15px] top-[7px] text-lg text-left text-black">비밀번호</p> -->
					</div>
				</form>
			</div>
			<div
				class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 overflow-hidden gap-1 px-2">
				<div
					class=" w-[350px] flex justify-between items-center gap-[20px] px-7">

					<a
						class="flex-grow-0 flex-shrink-0 text-[11px] text-center text-[#757678]"
						href="#" onclick="openFindLoginPage()">forgot ID OR password?</a>
					<div
						class=" w-[100px] h-12 overflow-hidden gap-2.5 rounded-[5px] bg-[#18a0fb] border border-black">

						<button
							class="flex justify-center items-center h-full w-full flex-grow-0 flex-shrink-0 text-sm text-white cursor-pointer hover:bg-[#0f80d8]"
							form="loginForm">LOGIN</button>
					</div>

				</div>
				<div
					class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
					<svg width="150" height="2" viewBox="0 0 177 2" fill="none"
						xmlns="http://www.w3.org/2000/svg"
						class="flex-grow-0 flex-shrink-0" preserveAspectRatio="none">
        <path d="M0.5 1H176.5" stroke="black" stroke-opacity="0.5"></path>
      </svg>
					<p
						class="flex-grow-0 flex-shrink-0 text-xl text-center text-black/50">OR</p>
					<svg width="150" height="2" viewBox="0 0 177 2" fill="none"
						xmlns="http://www.w3.org/2000/svg"
						class="flex-grow-0 flex-shrink-0" preserveAspectRatio="none">
        <path d="M0.5 1H176.5" stroke="black" stroke-opacity="0.5"></path>
      </svg>
				</div>

				<div
					class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[19px] p-2.5">
					<a href="<%=apiURL%>">
						<img src="/images/네이버 로그인.png"
							class="w-[276px] h-12 object-cover rounded-md" />
					</a>
					<a
						href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=${kakaoClientId}&redirect_uri=${kakaoRedirectUri}">
						<img src="/images/카카오 로그인.png"
							class="w-[276px] h-12 object-cover rounded-md" />
					</a>
					<div class="flex w-full ">
						<a
							class="signUpButton flex-grow-0 flex-shrink-0 text-[13px] text-center text-[#0000EE]"
							href="#">Create your account</a>
					</div>

				</div>


			</div>
		</div>

		<div class="joinImg hidden w-[800px] h-[500px] relative">
			<img src="/images/joinPageImg.jpg" class="w-full h-full object-cover" />
			<div
				class="absolute left-[30px] top-[530px] flex items-center justify-center">
				<p class="text-black text-4xl font-semibold drop-shadow-md bold"
					style="text-shadow: -0.5px -0.5px black, 0.5px 0.5px white;">Plan
					Your Trip</p>
			</div>
			<a href="../home/main"
				class="absolute w-12 h-12 left-[30px] top-[475px] rounded-full bg-[#18a0fb] text-white flex items-center justify-center shadow hover:bg-[#0f80d8]">
				<i class="fa-solid fa-arrow-right"></i>
			</a>
		</div>



		<div class="loginImg w-[800px] h-full relative">
			<img src="/images/loginPageImg.jpg"
				class="w-full h-full object-cover" />
			<div
				class="absolute  left-[30px] top-[500px] flex items-center justify-center">
				<p class="text-black text-4xl font-semibold drop-shadow-md bold"
					style="text-shadow: -0.5px -0.5px black, 0.5px 0.5px white;">Plan
					Your Trip</p>
			</div>
			<a href="../home/main"
				class=" absolute w-12 h-12 left-[30px] top-[420px] rounded-full bg-[#18a0fb] text-white flex items-center justify-center shadow hover:bg-[#0f80d8]">
				<i class="fa-solid fa-arrow-right"></i>
			</a>
		</div>

		<div
			class="joinDIv hidden flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 w-[510px] overflow-hidden py-[7px]  pb-10 ">
			<div
				class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden">
				<a href="../home/main">
					<img src="/images/로고_blue.png"
						class="flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
				</a>
				<p
					class="mt-2 flex-grow-0 flex-shrink-0 w-[510px] h-[50px] text-5xl text-center text-black">Sign
					Up</p>
			</div>
			<form action="doJoin" id="joinForm" method="POST">
				<div
					class="flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 relative overflow-hidden">
					<div
						class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
						<div
							class="w-[341px] h-[46px] absolute left-[17px] top-[34px] bg-[#f4f5f5] border border-[#757678]"></div>
						<img src="/images/사람.png"
							class="w-[42px] h-[37px] absolute left-[22px] top-[38px] object-cover" />
						<!-- <p class=" w-[103px] h-5 absolute left-[17px] top-2.5 text-lg text-left text-black">아이디</p> -->
						<input
							class="w-[289px] h-[46px] absolute left-[69px] top-[34px] bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="text" onkeyup="checkUserIdDuplicate(this);" name="loginId"
							placeholder="ID" autocomplete="off"
							onblur="checkUserIdEmpty(this);"></input>

					</div>
					<div class="checkEmptyMsg w-full flex justify-center items-center "></div>
					<div
						class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative ">
						<!-- <p class="w-[78px] h-5 absolute left-[15px] top-[7px] text-lg text-left text-black">비밀번호</p> -->
						<div
							class="w-[341px] h-[46px] absolute left-[15px] top-8 bg-[#f4f5f5] border border-[#757678]"></div>
						<input id="joinPasswordInput"
							class="w-[289px] h-[46px] absolute left-[67px] top-8 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="password" name="loginPw" placeholder="PASSWORD"
							autocomplete="off">
						</input>


						<img src="/images/비밀번호.png"
							class="w-[42px] h-[35px] absolute left-[19px] top-[38px] object-cover" />

						<i onClick="showJoinPassword();" id="joinPassword"
							class="top-[40px] right-[30px] absolute fa-solid fa-eye cursor-pointer p-1 z-5 text-xl"></i>
					</div>

					<div
						class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
						<!-- <p class="w-[78px] h-5 absolute left-[13px] top-[3px] text-lg text-left text-black">이메일</p> -->
						<div
							class="w-[341px] h-[46px] absolute left-[13px] top-7 bg-[#f4f5f5] border border-[#757678]"></div>
						<input
							class="w-[289px] h-[46px] absolute left-[65px] top-7 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="text" name="email" placeholder="EMAIL" autocomplete="off"></input>
						<img src="/images/이메일.png"
							class="w-[35px] h-[35px] absolute left-[21px] top-[33px] opacity-50 object-cover" />
					</div>
					<div
						class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
						<!-- <p class="w-[78px] h-5 absolute left-[13px] top-[3px] text-lg text-left text-black">이름</p> -->
						<div
							class="w-[341px] h-[46px] absolute left-[13px] top-7 bg-[#f4f5f5] border border-[#757678]"></div>
						<input
							class="w-[289px] h-[46px] absolute left-[65px] top-7 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="text" name="name" placeholder="NAME" autocomplete="off"></input>
						<img src="/images/사람.png"
							class="w-[35px] h-[35px] absolute left-[21px] top-[33px]  object-cover" />
					</div>
				</div>
			</form>

			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[276px] h-12 relative overflow-hidden py-[13px] rounded-[5px] bg-[#18a0fb] border border-black ">
				<button form="joinForm"
					class="w-full flex-grow-0 flex-shrink-0 text-2xl text-center text-white cursor-pointer">SIGN
					UP</button>
			</div>


		</div>


	</div>

</div>

<%@ include file="../common/foot.jspf"%>