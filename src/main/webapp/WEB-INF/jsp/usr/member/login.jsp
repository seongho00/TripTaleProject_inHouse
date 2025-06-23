<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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




<div
	class="flex bg-black/40 justify-center items-center w-screen h-screen overflow-hidden px-[9px] py-[7px]  border border-[#0f0000]">

	<div class="flex rounded-[10px] border border-black bg-white" style="box-shadow: 4px 4px 4px 0 rgba(0, 0, 0, 0.25);">
		<div
			class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[621px] w-[510px] overflow-hidden gap-[29px] py-[7px] ">
			<div class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden">
				<a href="../home/main">
					<img src="/images/로고_blue.png" class="bg-white flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
				</a>

			</div>
			<div class="flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 relative overflow-hidden">
				<form action="doLogin" id="loginForm">
					<div class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
						<div class="w-[341px] h-[46px] absolute left-[17px] top-[34px] bg-[#f4f5f5] border border-[#757678]"></div>
						<div class="w-[289px] h-[46px] absolute left-[69px] top-[34px] bg-[#f4f5f5] border border-[#757678]"></div>
						<p class="w-[235px] h-[46px] absolute left-[95px] top-[35px] text-lg text-left text-[#757678]">아이디</p>
						<img src="/images/사람.png" class="w-[42px] h-[37px] absolute left-[22px] top-[38px] object-cover" />
						<input
							class="w-[289px] h-[46px] absolute left-[69px] top-[34px] bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="text" name="loginId" placeholder="ID" autocomplete="off"></input>

						<!-- <p class="w-[103px] h-5 absolute left-[17px] top-2.5 text-lg text-left text-black">아이디</p> -->
					</div>
					<div class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
						<div class="w-[341px] h-[46px] absolute left-[15px] top-8 bg-[#f4f5f5] border border-[#757678]"></div>
						<div class="w-[289px] h-[46px] absolute left-[67px] top-8 bg-[#f4f5f5] border border-[#757678]"></div>
						<input class="w-[289px] h-[46px] absolute left-[67px] top-8 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
							type="text" name="loginPw" placeholder="PASSWORD" autocomplete="off"></input>

						<img src="/images/비밀번호.png" class="w-[42px] h-[35px] absolute left-[19px] top-[38px] object-cover" />
						<!-- <p class="w-[78px] h-5 absolute left-[15px] top-[7px] text-lg text-left text-black">비밀번호</p> -->
					</div>
				</form>
			</div>
			<div class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 overflow-hidden gap-1 px-2">
				<div class=" w-[350px] flex justify-between items-center gap-[20px] px-7">

					<a class="flex-grow-0 flex-shrink-0 text-[11px] text-center text-[#757678]" href="findLoginPage?findType=id">forgot
						ID OR password?</a>
					<div class=" w-[100px] h-12 overflow-hidden gap-2.5 rounded-[5px] bg-[#18a0fb] border border-black">

						<button
							class="flex justify-center items-center h-full w-full flex-grow-0 flex-shrink-0 text-sm text-white cursor-pointer hover:bg-[#0f80d8]"
							form="loginForm">LOGIN</button>
					</div>

				</div>
				<div
					class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5">
					<svg width="150" height="2" viewBox="0 0 177 2" fill="none" xmlns="http://www.w3.org/2000/svg"
						class="flex-grow-0 flex-shrink-0" preserveAspectRatio="none">
        <path d="M0.5 1H176.5" stroke="black" stroke-opacity="0.5"></path>
      </svg>
					<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black/50">OR</p>
					<svg width="150" height="2" viewBox="0 0 177 2" fill="none" xmlns="http://www.w3.org/2000/svg"
						class="flex-grow-0 flex-shrink-0" preserveAspectRatio="none">
        <path d="M0.5 1H176.5" stroke="black" stroke-opacity="0.5"></path>
      </svg>
				</div>

				<div
					class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[19px] p-2.5">
					<a href="<%=apiURL%>">
						<img src="/images/네이버 로그인.png" class="w-[276px] h-12 object-cover rounded-md" />
					</a>
					<a
						href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=${kakaoClientId}&redirect_uri=${kakaoRedirectUri}">
						<img src="/images/카카오 로그인.png" class="w-[276px] h-12 object-cover rounded-md" />
					</a>
					<div class="flex w-full ">
						<a class="flex-grow-0 flex-shrink-0 text-[13px] text-center text-[#0000EE]" href="join">Create your account</a>
					</div>

				</div>


			</div>
		</div>
		<div class="w-[800px] h-[621px] relative">
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
	</div>

</div>

<%@ include file="../common/foot.jspf"%>