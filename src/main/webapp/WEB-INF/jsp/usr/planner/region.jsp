<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="REGION PAGE"></c:set>
<%@ include file="../common/head.jspf"%>
<style>
/* 라벨 css */
.label {
	background: white;
	padding: 4px 8px;
	border: 1px solid #333;
	border-radius: 4px;
	font-size: 12px;
	white-space: nowrap;
	pointer-events: auto; /* 이벤트 받도록 설정 */
	cursor: pointer;
}
</style>


<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<div
		class="flex justify-between items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden px-2.5 bg-[#aedff7] border border-black">
		<a
			class="flex justify-start items-center flex-grow relative overflow-hidden gap-2.5"
			href="../home/main"> <img src="/images/로고.png"
			class="flex-grow-0 flex-shrink-0 w-[121px] h-[121px] object-cover" />
		</a>

		<div
			class="flex justify-center items-center self-stretch  flex-shrink-0 w-[684px] h-[121px] text-[40px] text-black">
			어떤 지역으로 여행하고 싶으신가요?</div>
		<div
			class="self-stretch flex-grow  h-[121px] relative overflow-hidden"></div>
	</div>

	<div
		class="flex flex-col justify-start items-center flex-grow-0 flex-shrink-0 h-[778px] relative overflow-hidden p-2.5 border-2 border-[#7ac4d7]">
		<div
			class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-screen h-full relative px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
			<div id="map" style="width: 100%; height: 100vh;"></div>


		</div>

	</div>
</div>
<script src="/resource/map.js"></script>
<%@ include file="../common/foot.jspf"%>