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




<div
	class="flex justify-center items-center w-screen h-screen overflow-hidden gap-2.5 px-[9px] py-[7px] bg-white border border-[#0f0000]">
	<div
		class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[621px] w-[510px] overflow-hidden gap-[29px] py-[7px] rounded-[10px] bg-[#aedff7] border border-black"
		style="box-shadow: 4px 4px 4px 0 rgba(0, 0, 0, 0.25);">
		<div
			class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden">
			<a href="../home/main"> <img src="/images/로고.png"
				class="flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
			</a>
			<p
				class="mt-2 flex-grow-0 flex-shrink-0 w-[510px] h-[50px] text-5xl text-center text-black">로그인</p>
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
						type="text" name="loginId" placeholder="아이디" autocomplete="off"></input>

					<p
						class="w-[103px] h-5 absolute left-[17px] top-2.5 text-lg text-left text-black">아이디</p>
				</div>
				<div
					class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
					<div
						class="w-[341px] h-[46px] absolute left-[15px] top-8 bg-[#f4f5f5] border border-[#757678]"></div>
					<div
						class="w-[289px] h-[46px] absolute left-[67px] top-8 bg-[#f4f5f5] border border-[#757678]"></div>
					<input
						class="w-[289px] h-[46px] absolute left-[67px] top-8 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
						type="text" name="loginPw" placeholder="비밀번호" autocomplete="off"></input>

					<img src="/images/비밀번호.png"
						class="w-[42px] h-[35px] absolute left-[19px] top-[38px] object-cover" />
					<p
						class="w-[78px] h-5 absolute left-[15px] top-[7px] text-lg text-left text-black">비밀번호</p>
				</div>
			</form>
		</div>
		<div
			class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 overflow-hidden gap-1 px-2">
			<div
				class=" w-[276px] h-12 overflow-hidden gap-2.5 rounded-[5px] bg-[#18a0fb] border border-black">
				<button
					class="flex justify-center items-center h-full w-full flex-grow-0 flex-shrink-0 text-2xl  text-white"
					form="loginForm">로그인</button>
			</div>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[218px] relative overflow-hidden">
				<a
					class="flex-grow-0 flex-shrink-0 w-[71px] text-[11px] text-center text-[#757678]"
					href="findLoginPage?findType=id">아이디 찾기</a>
				<p
					class="flex-grow-0 flex-shrink-0 text-[11px] text-center text-[#757678]">|</p>
				<a class="flex-grow w-20 text-[11px] text-center text-[#757678]"
					href="findLoginPage?findType=pw">비밀번호 찾기</a>
				<p
					class="flex-grow-0 flex-shrink-0 text-[11px] text-center text-[#757678]">|</p>
				<a
					class="flex-grow-0 flex-shrink-0 w-[57px] text-[11px] text-center text-[#757678]"
					href="join">회원가입</a>
			</div>
			<div
				class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-[19px] p-2.5">
				<a href="<%=apiURL%>"> <img class=" w-full h-16"
					src="/images/네이버 로그인.png" />
				</a> <a
					href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=${kakaoClientId}&redirect_uri=${kakaoRedirectUri}">
					<img src="/images/카카오 로그인.png" width="222" />
				</a>

			</div>
		</div>

	</div>

</div>

<%@ include file="../common/foot.jspf"%>