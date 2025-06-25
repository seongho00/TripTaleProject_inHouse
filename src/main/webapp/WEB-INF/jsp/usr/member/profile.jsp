<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<c:set var="pageTitle" value="PROFILE PAGE"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<script>
	let currentSort = 'recent';
	
	function toggleCaret(memberId) {
		currentSort = currentSort === 'recent' ? 'old' : 'recent';
		
		$('.fa-caret-down').toggleClass('!hidden');
		$('.fa-caret-up').toggleClass('!hidden');
		
		loadPosts(currentSort, memberId);

	}
	
	function loadPosts(sortType, memberId) {


	    $.ajax({
	        type: 'GET',
	        url: '../planner/getTripInfos',
	        data: { sortType: sortType, memberId : memberId },
	        success: function (tripInfos) {
	        	const container = $('.tripInfoContainer');
				container.empty();
				tripInfos.forEach((tripInfo, index) => {
					const reverseIndex = tripInfos.length - index;
					const html = `
						<div onclick="showDetail(\${tripInfo.id});"
							class="flex justify-start items-center self-stretch flex-grow relative gap-3 pr-[13px] py-2.5 cursor-pointer">
							<p class="flex-grow-0 flex-shrink-0 w-[23px] h-[23px] text-xl font-medium text-center text-black">\${reverseIndex}</p>
							<div class="flex-grow-0 flex-shrink-0 w-[174px] h-[114px] relative border border-black">
								<img src="\${tripInfo.url}" class="w-full h-full object-cover" />
							</div>
							<div class="flex flex-col justify-center items-start self-stretch flex-grow relative gap-2.5 pl-2.5 pr-[27px] py-[15px]">
								<div class="flex justify-start items-end gap-2.5 pr-[7px]">
									<p class="text-xl font-medium text-center text-black">\${tripInfo.tripName}</p>
									<p class="text-[15px] font-medium text-center text-black">\${tripInfo.tripRegion}</p>
								</div>
								<p class="text-[15px] font-medium text-center text-black">\${tripInfo.formattedStartDate} ~ \${tripInfo.formattedEndDate}</p>
							</div>
							<div class="relative">
								<i onclick="event.stopPropagation()" class="articleMenuToggle fa-solid fa-bars fa-lg cursor-pointer"></i>
								<ul class="articleSlideMenu hidden absolute top-[15px] left-0 mt-2 w-40 bg-white border border-gray-300 rounded shadow-lg z-50">
									<li onclick="event.stopPropagation()" class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
										<a href="../article/writeByAI?tripId=\${tripInfo.id}">글쓰기</a>
									</li>
									<li onclick="event.stopPropagation()" class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
										<a href="../planner/modify?tripId=\${tripInfo.id}">수정하기</a>
									</li>
									<li onclick="event.stopPropagation()" class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
										<a href="../planner/delete?tripId=\${tripInfo.id}">삭제하기</a>
									</li>
								</ul>
							</div>
						</div>
					`;
					container.append(html);
				});
	        	
	        	
	        }
	    });
	}

	/* 처음 활성화될 버튼 설정 */
	$(document).ready(function() {
		$('#lookupPlanButton').addClass('btn-active');
		$('.tripPlanUI').addClass('ui-active');
	});

	// 여행계획조회 찾기, 여행기록조회 찾기 눌렀을 때
	function lookupPlanButton() {
		if ($('#lookupPlanButton').hasClass('btn-active')) {
			return;
		}
		$('#lookupPlanButton').toggleClass('btn-active');
		$('#lookupRecordButton').toggleClass('btn-active');
		$('.tripPlanUI').toggleClass('ui-active');
		$('.tripArticleUI').toggleClass('ui-active');

	}
	function lookupRecordButton() {
		if ($('#lookupRecordButton').hasClass('btn-active')) {
			return;
		}
		$('#lookupPlanButton').toggleClass('btn-active');
		$('#lookupRecordButton').toggleClass('btn-active');
		$('.tripPlanUI').toggleClass('ui-active');
		$('.tripArticleUI').toggleClass('ui-active');

	}

	$(document).ready(function() {
		// 햄버거 버튼 클릭 시 해당 메뉴만 토글
		$('.articleMenuToggle').on('click', function(e) {
			e.stopPropagation(); // 다른 이벤트 방지
			const $menu = $(this).siblings('.articleSlideMenu');

			// 모든 메뉴 닫기
			$('.articleSlideMenu').not($menu).addClass('hidden');

			// 해당 메뉴 토글
			$menu.toggleClass('hidden');
		});

		// 바깥 클릭 시 닫기
		$(document).on('click', function() {
			$('.articleSlideMenu').addClass('hidden');
		});
		
		
	});

	function showDetail(tripId) {
		window.location.href = '../planner/detail?tripId=' + tripId;
	}
	
	function getTripUIBySearchKeyword(memberId) {
		const keyword =$('#tripSearchKeyword').val().trim();

		
		$.ajax({
			type: 'GET',
			url: '/usr/planner/searchTripInfos', // ✅ 너의 실제 검색 API 경로로 바꿔줘
			data: { keyword: keyword , memberId : memberId},
			success: function (tripInfos) {
				console.log('검색 결과:', tripInfos);
				// 이곳에 결과를 화면에 뿌리는 코드 작성
				const $container = $('#tripInfoContainer'); // 여행 정보 리스트를 넣을 곳
				$container.empty(); // 기존 목록 비우기

				if (tripInfos.length === 0) {
					$container.append('<p>검색 결과가 없습니다.</p>');
					return;
				}

				tripInfos.forEach((tripInfo, index) => {
					const html = `
						<div onclick="showDetail(${tripInfo.id});"
							class="flex justify-start items-center gap-3 pr-[13px] py-2.5 cursor-pointer">
							<p class="w-[23px] h-[23px] text-xl font-medium text-center">${index + 1}</p>
							<div class="w-[174px] h-[114px] relative border border-black">
								<img src="${tripInfo.url}" class="w-full h-full object-cover" />
							</div>
							<div class="flex flex-col justify-center gap-2.5 pl-2.5 pr-[27px] py-[15px]">
								<div class="flex items-end gap-2.5 pr-[7px]">
									<p class="text-xl font-medium">${tripInfo.tripName}</p>
									<p class="text-[15px] font-medium">${tripInfo.tripRegion}</p>
								</div>
								<p class="text-[15px] font-medium">${tripInfo.formattedStartDate} ~ ${tripInfo.formattedEndDate}</p>
							</div>
						</div>
					`;
					$container.append(html);
				});
			},
			error: function (xhr) {
				console.error('검색 실패:', xhr.responseText);
			}
		});
	}
</script>

<style>
/* 여행계획조회, 여행기록조회 클릭시 색깔, 밑줄 코드 */
#lookupPlanButton.btn-active, #lookupRecordButton.btn-active {
	opacity: 1;
	color: black;
}

#lookupPlanButton, #lookupRecordButton {
	position: relative;
	display: inline-block;
	border-bottom: 2px solid transparent; /* 기본은 안 보임 */
}

#lookupPlanButton::after, #lookupRecordButton::after {
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

#lookupPlanButton.btn-active::after, #lookupRecordButton.btn-active::after
	{
	transform: scaleX(1); /* 애니메이션으로 왼쪽→오른쪽 확장 */
	transition: transform 0.3s;
}

/* 추천장소, 장소 찾기 UI css  */
.tripPlanUI, .tripArticleUI {
	display: none;
}

.tripPlanUI.ui-active, .tripArticleUI.ui-active {
	display: block;
}
</style>



<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<%@ include file="../common/header_blue.jspf"%>
	<div class="flex justify-between items-center flex-grow w-[1028px]  p-2.5">
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 h-[577px] w-[231px] relative overflow-hidden gap-[26px] px-[93px]">
			<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">my page</p>
			<div
				class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[157px] relative overflow-hidden gap-10">
				<i class="fa-solid fa-user fa-5x"></i>
				<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">프로필 관리</p>
				<p class="flex-grow-0 flex-shrink-0 w-[65px] h-[30px] text-xl font-medium text-center text-black">${loginedMember.name }</p>
				<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">아이디</p>
				<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">즐겨찾기</p>
			</div>
		</div>
		<div
			class="flex flex-col justify-between items-center self-stretch flex-grow-0 flex-shrink-0 w-[745px] px-[171px] py-[29px]">
			<div class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[323px] relative overflow-hidden py-[11px]">
				<p onClick="lookupPlanButton();" id="lookupPlanButton"
					class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center opacity-50  text-black/80 cursor-pointer">여행
					계획 조회</p>
				<p onClick="lookupRecordButton();" id="lookupRecordButton"
					class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center opacity-50 text-black/80 cursor-pointer">여행 기록
					조회</p>
			</div>


			<div
				class="tripPlanUI flex flex-col justify-start items-center flex-grow w-[565px] relative  gap-2.5 pt-[18px] pb-[62px]">


				<div class="flex justify-center items-end self-stretch flex-grow-0 flex-shrink-0  gap-2.5 px-[55px] py-1.5">
					<div
						class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[123px] relative  gap-2.5 px-2 py-[9px] border border-black">
						<select name="searchKeyword"
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black focus:outline-none focus:ring-0 focus:border-none">
							<option value="ALL">전체</option>
							<option value="tripName">여행 이름</option>
							<option value="tripLocation">여행 장소</option>
						</select>
					</div>
					<div
						class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[290px] h-[41px] relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
						<input id="tripSearchKeyword" type="text" placeholder="검색어를 입력하세요" autocomplete="off"
							class="focus:outline-none focus:border-none focus:ring-0 flex-grow " />
						<i onClick="getTripUIBySearchKeyword(${loginedMember.id}});" class="cursor-pointer fa-solid fa-magnifying-glass text-lg"></i>
					</div>
					<div onClick="toggleCaret(${loginedMember.id})"
						class="sortOrder flex justify-start items-center flex-grow-0 flex-shrink-0 relative gap-[3px] cursor-pointer">
						<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">최근순</p>
						<i class="fa-solid fa-caret-down"></i>
						<i class="fa-solid fa-caret-up !hidden"></i>
					</div>
				</div>
				<div
					class="tripInfoContainer flex flex-col justify-start items-start self-stretch flex-grow-0 flex-shrink-0  gap-2.5 p-2.5">
					<c:forEach var="tripInfo" items="${tripInfos }" varStatus="status">
						<div onClick="showDetail(${tripInfo.id});"
							class="flex justify-start items-center self-stretch flex-grow relative gap-3 pr-[13px] py-2.5 cursor-pointer">
							<p class="flex-grow-0 flex-shrink-0 w-[23px] h-[23px] text-xl font-medium text-center text-black">${tripInfos.size() - status.index}</p>
							<div class="flex-grow-0 flex-shrink-0 w-[174px] h-[114px] relative border border-black">
								<img src="${urls[status.index] }" class="w-full h-full object-cover" />

							</div>
							<div
								class="flex flex-col justify-center items-start self-stretch flex-grow relative  gap-2.5 pl-2.5 pr-[27px] py-[15px]">
								<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
									<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">${tripInfo.tripName}</p>
									<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripInfo.tripRegion}</p>
								</div>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripInfo.formattedStartDate }
									~ ${tripInfo.formattedEndDate }</p>

							</div>
							<div class="relative">
								<i onclick="event.stopPropagation()" class="articleMenuToggle fa-solid fa-bars fa-lg cursor-pointer"></i>
								<!-- 숨겨진 메뉴 -->
								<ul
									class="articleSlideMenu hidden absolute top-[15px] left-0 mt-2 w-40 bg-white border border-gray-300 rounded shadow-lg z-50">
									<li onclick="event.stopPropagation()" class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
										<a href="../article/writeByAI?tripId=${tripInfo.id}">글쓰기</a>
									</li>
									<li onclick="event.stopPropagation()" class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
										<a href="../planner/modify?tripId=${tripInfo.id}">수정하기</a>
									</li>
									<li onclick="event.stopPropagation()" class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
										<a href="../planner/delete?tripId=${tripInfo.id }">삭제하기</a>
									</li>

								</ul>
							</div>
						</div>
					</c:forEach>

				</div>
			</div>


			<div
				class="tripArticleUI hidden flex flex-col justify-start items-center flex-grow w-[565px] relative  gap-2.5 pt-[18px] pb-[62px]">


				<div class="flex justify-center items-end self-stretch flex-grow-0 flex-shrink-0  gap-2.5 px-[55px] py-1.5">
					<div
						class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[123px] relative  gap-2.5 px-2 py-[9px] border border-black">
						<select name="searchKeyword"
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black focus:outline-none focus:ring-0 focus:border-none">
							<option value="ALL">전체</option>
							<option value="tripName">여행 이름</option>
							<option value="tripLocation">여행 장소</option>
						</select>
					</div>
					<div
						class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[290px] h-[41px] relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
						<input type="text" placeholder="검색어를 입력하세요" autocomplete="off"
							class="focus:outline-none focus:border-none focus:ring-0 flex-grow " />
						<svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg"
							class="flex-grow-0 flex-shrink-0 w-[21px] h-[21.5px] cursor-pointer" preserveAspectRatio="none">
      <circle cx="9" cy="9" r="8.5" transform="matrix(-1 0 0 1 18.5 0)" stroke="black"></circle>
      <path d="M15.5 15.5L21.5 21.5" stroke="black" stroke-linecap="round"></path>
    </svg>
					</div>
					<div onClick="toggleCaret()"
						class="sortOrder flex justify-start items-center flex-grow-0 flex-shrink-0 relative gap-[3px] cursor-pointer">
						<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">최근순</p>
						<i class="fa-solid fa-caret-down"></i>
						<i class="fa-solid fa-caret-up !hidden"></i>
					</div>
				</div>
				<div class="flex flex-col justify-start items-start self-stretch flex-grow-0 flex-shrink-0  gap-2.5 p-2.5">
					<c:forEach var="article" items="${articles }" varStatus="status">
						<div onClick="showDetail(${tripInfo.id});"
							class="flex justify-start items-center self-stretch flex-grow relative gap-3 pr-[13px] py-2.5 cursor-pointer">
							<p class="flex-grow-0 flex-shrink-0 w-[23px] h-[23px] text-xl font-medium text-center text-black">${tripInfos.size() - status.index}</p>
							<div class="flex-grow-0 flex-shrink-0 w-[174px] h-[114px] relative border border-black">
								<img src="${urls[status.index] }" class="w-full h-full object-cover" />

							</div>
							<div
								class="flex flex-col justify-center items-start self-stretch flex-grow relative  gap-2.5 pl-2.5 pr-[27px] py-[15px]">
								<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
									<p class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">${article.tripName}</p>
									<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${article.tripRegion}</p>
								</div>
								<p class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${article.formattedStartDate }
									~ ${article.formattedEndDate }</p>

							</div>
							<div class="relative">
								<i onclick="event.stopPropagation()" class="articleMenuToggle fa-solid fa-bars fa-lg cursor-pointer"></i>
								<!-- 숨겨진 메뉴 -->
								<ul
									class="articleSlideMenu hidden absolute top-[15px] left-0 mt-2 w-40 bg-white border border-gray-300 rounded shadow-lg z-50">
									<li onclick="event.stopPropagation()" class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
										<a href="../planner/modify?articleId=${article.id}">수정하기</a>
									</li>
									<li onclick="event.stopPropagation()" class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
										<a href="../planner/delete?articleId=${article.id }">삭제하기</a>
									</li>
								</ul>
							</div>
						</div>
					</c:forEach>

				</div>
			</div>



		</div>
	</div>
</div>
<%@ include file="../common/foot.jspf"%>