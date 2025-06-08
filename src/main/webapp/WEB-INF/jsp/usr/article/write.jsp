<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="관광사진" />
<%@ include file="../common/head.jspf"%>
<%--  --%><%@ include file="../common/daisyUi.jspf"%>
<%@ include file="../common/toastUiEditorLib.jspf"%>

<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden bg-white ">

	<div
		class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 h-[138px] overflow-hidden gap-2.5 px-[293px] py-[41px] bg-[#aedff7] border border-black">
		<div
			class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[1008px] h-[138px] relative gap-2.5 bg-[#aedff7] border-0 border-[#f00]">
			<a href="../home/main">
				<img src="/images/로고.png"
					class="flex-grow-0 flex-shrink-0 w-[109px] h-[76px] object-cover" />
			</a>
			<div
				class="flex justify-start items-start self-stretch flex-grow relative overflow-hidden gap-2.5 p-2.5">
				<p
					class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-[#2f3a4b]">숙박</p>
				<p
					class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-[#2f3a4b]">맛집</p>
				<p
					class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-[#2f3a4b]">명소</p>
			</div>
			<div
				class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 w-[428px] relative">
				<p
					class="flex-grow w-[107px] h-14 text-xl font-medium text-center text-[#2f3a4b]">여행
					기록</p>
				<p
					class="flex-grow w-[107px] h-14 text-xl font-medium text-center text-[#2f3a4b]">계획
					작성</p>
				<p
					class="flex-grow w-[107px] h-14 text-xl font-medium text-center text-[#2f3a4b]">로그인</p>
				<p
					class="flex-grow w-[107px] h-14 text-xl font-medium text-center text-[#2f3a4b]">회원가입</p>
			</div>
		</div>
	</div>
	<div class="w-[1000px] h-[600px] border-2 border-black">
		<div class="toast-ui-editor">
			<script type="text/x-template"></script>
		</div>
	</div>

</div>

<%@ include file="../common/foot.jspf"%>