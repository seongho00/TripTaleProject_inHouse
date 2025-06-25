<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="ARTICLE WRITE_BY_AI" />
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/daisyUi.jspf"%>

<style>
.mood-box>div>div>div {
	width: 55px;
}

.mood-box>div>div>div:hover {
	background-color: #61c0e6;
	transition: all 0.3s ease;
}

.mood-box>div>div>div.active:hover {
	background-color: #1e293b;
	transition: all 0.3s ease;
}
</style>

<script>
	$(document).ready(
			function() {
				$('#imageInput').on('change', handleImagePreview);
				const selectedContainer = $('#selectedMoodsContainer');
				$('.mood-box .cursor-pointer')
						.on(
								'click',
								function() {
									const $target = $(this); // 클릭된 .cursor-pointer 요소
									const moodText = $target.text().trim();
									const isSelected = $target
											.hasClass('active');

									if (isSelected) {
										$target.removeClass('active bg-black');
										$target.find('p').removeClass(
												'text-white');
										selectedContainer.find('.' + moodText)
												.remove();
									} else {
										$target.addClass('active bg-black');
										$target.find('p')
												.addClass('text-white');

										$('<input type="hidden">').attr('name',
												'selectedMoods[]').attr(
												'class', moodText)
												.val(moodText).appendTo(
														selectedContainer);
									}
								});

			});

	// 이미지 넣기
	function handleImagePreview(e) {
		const files = e.target.files;
		const $container = $('#previewContainer');

		$
				.each(
						files,
						function(i, file) {

							if (!file.type.startsWith('image/'))
								return;
							const reader = new FileReader();

							reader.onload = function(e) {
								// 기존 글씨 지우기
								$('.beforeDropFile').hide();
								$('.pictureSelectBox').removeClass('pt-[50px]');

								// wrapper div
								const $wrapper = $('<div></div>').addClass(
										'relative w-40 h-40 border rounded');

								// image
								const $img = $('<img>').attr('src',
										e.target.result).addClass(
										'w-full h-full object-cover');

								// delete button
								const $btn = $(
										'<button><i class="fa-solid fa-square-xmark text-2xl"></i></button>')
										.addClass(
												'cursor-pointer absolute top-1 right-1 rounded-full w-4 h-4 flex items-center justify-center bg-white');

								$btn.on('click',
										function() {
											$wrapper.remove();
											// ✅ 모든 이미지가 삭제되었을 때 안내 문구 다시 표시
											if ($('#previewContainer')
													.children().length === 0) {
												$('.beforeDropFile').show();
												$('.pictureSelectBox')
														.addClass('pt-[50px]');
											}

										});

								$wrapper.append($img).append($btn);
								$container.append($wrapper);
							};
							reader.readAsDataURL(file);
						});

	}
</script>

<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white ">
	<%@ include file="../common/header.jspf"%>
	<div
		class="flex flex-col justify-center items-center flex-grow relative overflow-hidden gap-2.5 p-2.5">
		<div
			class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-10">
			<p
				class="flex-grow-0 flex-shrink-0 w-[300px] h-[52px] text-3xl text-center text-black">AI를
				이용해 기록하기</p>

		</div>
		<div
			class="flex justify-start items-end self-stretch flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-10">
			<p
				class="flex-grow-0 flex-shrink-0  h-[52px] text-3xl font-medium text-center text-black">${tripInfo.tripName}</p>
			<p
				class="flex-grow-0 flex-shrink-0  h-[38px] text-xl font-medium text-center text-black">${tripInfo.tripRegion}</p>
			<p
				class="flex-grow-0 flex-shrink-0 h-6 text-[15px] font-medium text-center text-black">${startDate}
				~ ${endDate}</p>
		</div>
		<div
			class="pictureSelectBox flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[1008px] relative overflow-hidden gap-2.5 pt-[50px] pb-[39px] border-2 border-black border-dashed">
			<div
				class="beforeDropFile flex-grow-0 flex-shrink-0 w-[1008px] h-[100px] font-medium text-center text-black">
				<span
					class="flex-grow-0 flex-shrink-0 w-[1008px] h-[222px] text-3xl font-medium text-center text-black">업로드할
					파일 놓기</span>
				<br />
				<br />
				<span
					class="flex-grow-0 flex-shrink-0 w-[1008px] h-[222px] text-xl font-medium text-center text-black">또는</span>
			</div>
			<div class="overflow-x-auto max-w-[1008px]">
				<div id="previewContainer" class="flex gap-4 mt-4 min-w-max"></div>
			</div>
			<div
				class="flex justify-center z-10 items-center relative gap-2.5 p-2.5">
				<form id="moodForm" action="doWriteByAI" method="post"
					enctype="multipart/form-data">
					<div id="selectedMoodsContainer"></div>
					<label class="btn btn-dash btn-primary btn-xl">
						파일 선택
						<input type="file" id="imageInput" name="images" multiple
							accept="image/*" class="hidden" />
					</label>
					<input type="hidden" name="tripRegion" value="${tripInfo.tripRegion }"/>
					<input type="hidden" name="tripId" value="${tripInfo.id }"/>
					<input type="hidden" name="title" value="${tripInfo.tripName }"/>
				</form>
			</div>

		</div>
		<div
			class="mood-box flex justify-center items-center flex-wrap w-[800px] gap-[38px]">
			<div
				class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 h-[137px] w-[326px] relative overflow-hidden px-6 py-[7px] !border-2 !border-black">
				<p
					class="flex-grow-0 flex-shrink-0 w-[132px] h-[31px] text-xl font-medium text-center text-black">긍정적
					기분</p>
				<div
					class="flex flex-wrap justify-start items-center flex-grow-0 flex-shrink-0 w-[296px] overflow-hidden gap-[3px] py-[9px]">
					<div
						class="cursor-pointer flex justify-center items-center h-7 relative overflow-hidden gap-2.5 px-[5px]  py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">행복</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center  h-7 relative overflow-hidden gap-2.5 px-[5px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">기쁨</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center  h-7 relative overflow-hidden gap-2.5 px-[5px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">만족</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center  h-7 relative overflow-hidden gap-2.5 px-[5px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">사랑</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center h-7 relative overflow-hidden gap-2.5 px-[5px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">흥미</p>
					</div>

				</div>
				<div
					class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[296px] overflow-hidden gap-[3px] py-[9px]">
					<div
						class="cursor-pointer flex justify-center items-center  h-7 relative overflow-hidden gap-2.5 px-[5px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">설렘</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center  h-7 relative overflow-hidden gap-2.5 px-[5px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">희망</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center h-7 relative overflow-hidden gap-2.5 px-[5px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">평온</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center h-7 relative overflow-hidden gap-2.5 px-[5px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">감사</p>
					</div>

				</div>
			</div>

			<div
				class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 h-[137px] w-[326px] relative overflow-hidden px-6 py-[7px] !border-2 !border-black">
				<p
					class="flex-grow-0 flex-shrink-0 w-[132px] h-[31px] text-xl font-medium text-center text-black">부정적
					기분</p>
				<div
					class="flex justify-center items-center flex-grow-0 flex-shrink-0 w-[296px] overflow-hidden gap-[3px] py-[9px]">
					<div
						class="cursor-pointer flex justify-center items-center flex-grow h-7 relative overflow-hidden gap-2.5 px-[11px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">슬픔</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center flex-grow h-7 relative overflow-hidden gap-2.5 px-[11px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">분노</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center flex-grow h-7 relative overflow-hidden gap-2.5 px-[11px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">수치심</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center flex-grow h-7 relative overflow-hidden gap-2.5 px-[11px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">불안</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center flex-grow h-7 relative overflow-hidden gap-2.5 px-[11px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">혐오</p>
					</div>
				</div>
				<div
					class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[296px] overflow-hidden gap-[3px] py-[9px]">
					<div
						class="cursor-pointer flex justify-center items-center h-7 relative overflow-hidden gap-2.5 px-[11px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">지루함</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center  h-7 relative overflow-hidden gap-2.5 px-[11px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">후회</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center h-7 relative overflow-hidden gap-2.5 px-[11px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class=" flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">아쉬움</p>
					</div>

				</div>
			</div>
			<div
				class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 h-[137px] w-[326px] relative overflow-hidden px-6 py-[7px] !border-2 !border-black">
				<p
					class="flex-grow-0 flex-shrink-0 w-[132px] h-[31px] text-xl font-medium text-center text-black">복합적
					기분</p>
				<div
					class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[296px] overflow-hidden gap-[3px] py-[9px]">
					<div
						class="cursor-pointer flex justify-center items-center h-7 relative overflow-hidden gap-2.5 px-[11px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">그리움</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center  h-7 relative overflow-hidden gap-2.5 px-[11px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class=" flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">민망함</p>
					</div>
					<div
						class="cursor-pointer flex justify-center items-center  h-7 relative overflow-hidden gap-2.5 px-[11px] py-2.5 rounded-[5px] bg-[#aedff7]">
						<p
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">놀람</p>
					</div>

				</div>
				<div
					class="flex justify-center items-center flex-grow-0 flex-shrink-0 h-7 w-[296px] overflow-hidden gap-[3px] py-[9px]">

				</div>
			</div>

		</div>
	</div>
	<div class="w-[1000px] flex justify-end">
		<button form="moodForm" class="btn btn-neutral">글쓰기</button>
	</div>

</div>

<%@ include file="../common/foot.jspf"%>