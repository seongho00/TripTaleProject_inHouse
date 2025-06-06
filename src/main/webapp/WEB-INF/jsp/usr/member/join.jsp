<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<c:set var="pageTitle" value="JOIN PAGE"></c:set>
<%@ include file="../common/head.jspf"%>


<div
	class="flex flex-col justify-center items-center w-screen h-screen overflow-hidden gap-2.5 px-[9px] py-[7px] bg-white border border-[#0f0000]">
	<div
		class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[621px] w-[510px] overflow-hidden gap-[29px] py-[7px] rounded-[10px] bg-[#aedff7] border border-black"
		style="box-shadow: 4px 4px 4px 0 rgba(0, 0, 0, 0.25);">
		<div class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 relative overflow-hidden">
			<a href="../home/main">
				<img src="/images/로고.png" class="flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
			</a>
			<p class="mt-2 flex-grow-0 flex-shrink-0 w-[510px] h-[50px] text-5xl text-center text-black">회원가입</p>
		</div>
		<form action="doJoin" id="joinForm" method="POST">
			<div class="flex flex-col justify-start items-start flex-grow-0 flex-shrink-0 relative overflow-hidden">
				<div class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
					<div class="w-[341px] h-[46px] absolute left-[17px] top-[34px] bg-[#f4f5f5] border border-[#757678]"></div>
					<img src="/images/사람.png" class="w-[42px] h-[37px] absolute left-[22px] top-[38px] object-cover" />
					<p class=" w-[103px] h-5 absolute left-[17px] top-2.5 text-lg text-left text-black">아이디</p>
					<input class="w-[289px] h-[46px] absolute left-[69px] top-[34px] bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
						type="text" name="loginId" placeholder="아이디" autocomplete="off"></input>

				</div>
				<div class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
					<p class="w-[78px] h-5 absolute left-[15px] top-[7px] text-lg text-left text-black">비밀번호</p>
					<div class="w-[341px] h-[46px] absolute left-[15px] top-8 bg-[#f4f5f5] border border-[#757678]"></div>
					<input class="w-[289px] h-[46px] absolute left-[67px] top-8 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
						type="text" name="loginPw" placeholder="비밀번호" autocomplete="off"></input>


					<img src="/images/비밀번호.png" class="w-[42px] h-[35px] absolute left-[19px] top-[38px] object-cover" />


				</div>
				<div class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
					<p class="w-[78px] h-5 absolute left-[13px] top-[3px] text-lg text-left text-black">이메일</p>
					<div class="w-[341px] h-[46px] absolute left-[13px] top-7 bg-[#f4f5f5] border border-[#757678]"></div>
					<input class="w-[289px] h-[46px] absolute left-[65px] top-7 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
						type="text" name="email" placeholder="이메일" autocomplete="off"></input>
					<img src="/images/이메일.png" class="w-[35px] h-[35px] absolute left-[21px] top-[33px] opacity-50 object-cover" />
				</div>
				<div class="flex-grow-0 flex-shrink-0 w-[380px] h-[90px] relative overflow-hidden">
					<p class="w-[78px] h-5 absolute left-[13px] top-[3px] text-lg text-left text-black">이름</p>
					<div class="w-[341px] h-[46px] absolute left-[13px] top-7 bg-[#f4f5f5] border border-[#757678]"></div>
					<input class="w-[289px] h-[46px] absolute left-[65px] top-7 bg-[#f4f5f5] border border-[#757678] pl-5 text-lg"
						type="text" name="name" placeholder="이름" autocomplete="off"></input>
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

<%@ include file="../common/foot.jspf"%>