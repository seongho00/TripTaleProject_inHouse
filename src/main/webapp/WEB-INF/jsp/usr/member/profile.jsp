<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<c:set var="pageTitle" value="PROFILE PAGE"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/daisyUi.jspf"%>
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
	
	function getUIBySearchKeyword(memberId, keywordType) {
		
		let keyword;
		let searchKeyword;
		
		if (keywordType === 'tripInfo') {
			keyword = $('#tripSearchKeyword').val().trim();
			searchKeywordType = $('#tripSearchKeywordType').val();
		} else if (keywordType === 'article') {
			keyword = $('#articleSearchKeyword').val().trim();
			searchKeywordType = $('#articleSearchKeywordType').val();
		}
		
		$.ajax({
			type: 'GET',
			url: '/usr/planner/searchByKeywordType', // ✅ 너의 실제 검색 API 경로로 바꿔줘
			data: { keyword: keyword , memberId : memberId, searchKeywordType : searchKeywordType},
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
			},
			error: function (xhr) {
				console.error('검색 실패:', xhr.responseText);
			}
		});
	}
	
	function showProfileInput() {

		$('#profileInput').click();
	}
	$(document).ready(function () {
		$('#profileInput').on('change', function (e) {
			const file = e.target.files[0];
			console.log("실행1");
			if (!file) return;
			console.log("실행2");
			const reader = new FileReader();
			reader.onload = function (event) {
				console.log("실행3");
				$('#profileThumbnail').empty();
			    $('#profileThumbnail').html(`
					<img src="\${event.target.result}" class="w-full h-full object-cover rounded-full" />
			    `);
			};
		
			reader.readAsDataURL(file);
		
			// 🔸 서버에 Ajax로 전송
			const formData = new FormData();
			formData.append("profileImage", file);
			
			$.ajax({
			    url: "/usr/member/updateProfileImage", // 서버 업로드 경로
			    method: "POST",
			    data: formData,
			    processData: false,
			    contentType: false,
			    success: function (response) {
					console.log("업로드 성공:", response);
					// 알림 또는 UI 업데이트
			    },
			    error: function (xhr, status, error) {
					console.error("업로드 실패:", error);
					alert("프로필 업로드 중 오류가 발생했습니다.");
			    }
			});
		});
		
		
	});
	
	function showPassword() {
		const $input = $('#profilePassword');
	    const currentType = $input.attr('type');

	    if (currentType === 'password') {
			$input.attr('type', 'text');
			$('#showPassword').removeClass('fa-eye').addClass('fa-eye-slash');
	    } else {
			$input.attr('type', 'password');
			$('#showPassword').removeClass('fa-eye-slash').addClass('fa-eye');
	    }
	}
	
	// 장바구니 추가 시 알림 메세지
	function showToast(message) {
		const $toast = $('#toast');
		$toast.text(message).removeClass('opacity-0');

		setTimeout(() => {
			$toast.addClass('opacity-0');
		}, 2000); // 2초 후 사라짐
	}
	
	function deleteMember(memberId) {
		 $.ajax({
				url: '/usr/member/doDelete',  // 컨트롤러 매핑 경로
		        type: 'POST',               // GET도 가능하지만 POST가 더 안전
		        data: { memberId: memberId },     // 서버에서 `@RequestParam("id")`로 받음
		        success: function() {
					alert('삭제가 완료되었습니다.');
		            location.replace("../home/main"); // 또는 페이지 이동
		        },
		        error: function(xhr, status, error) {
		            alert('삭제 중 오류가 발생했습니다.');
		            console.error(error);
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
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white ">
	<%@ include file="../common/header_blue.jspf"%>
	<div
		class="flex justify-between items-center flex-grow w-[1028px]  p-2.5">
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 h-[577px] w-[231px] bg-slate-200 rounded-[5px] relative overflow-hidden gap-[26px] px-[93px] border border-black">
			<p
				class="flex-grow-0 flex-shrink-0  h-[30px] text-xl font-medium text-center text-black z-1">PROFILE</p>

			<svg class="absolute top-0" width="100%" height="230"
				viewBox="0 0 1200 100" xmlns="http://www.w3.org/2000/svg"
				preserveAspectRatio="none">
  <defs>
    <linearGradient id="grad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#1e3a8a" />
      <stop offset="100%" stop-color="#93c5fd" />
    </linearGradient>
  </defs>
  <path
					d="
    M0,60
    C200,50 400,70 600,60
    S1000,70 1200,60
    L1200,0
    L0,0
    Z"
					fill="url(#grad)" />
</svg>


			<div
				class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[157px]  relative  gap-10">



				<div onClick="showProfileInput();" class="indicator cursor-pointer">
					<!-- ✅ 그라데이션 border 처리용 wrapper -->
					<div
						class="w-20 h-20 rounded-full p-[3px] bg-gradient-to-tr from-purple-500 via-pink-500 to-red-500 ">
						<!-- ✅ 실제 프로필 썸네일 -->
						<div id="profileThumbnail"
							class="w-full h-full rounded-full bg-white flex items-center justify-center">
							<c:if test="${base64Image == null and developerImage == null}">
								<i class="fa-solid fa-user fa-3x text-gray-700"></i>
							</c:if>
							<c:if test="${base64Image == null and developerImage != null}">
								<img src="${developerImage}"
									class="w-full h-full object-cover rounded-full" />
							</c:if>
							<c:if test="${base64Image != null}">
								<img src="data:image/jpeg;base64,${base64Image}"
									class="w-full h-full object-cover rounded-full" />
							</c:if>
						</div>
					</div>

					<!-- 배지 (카메라 아이콘) -->
					<span
						class="indicator-item badge !bg-neutral-400 w-6 h-6 p-0 flex items-center justify-center">
						<i class="fa-solid fa-camera text-xs"></i>
					</span>


				</div>
				<!-- 숨겨진 파일 선택 input -->
				<input type="file" id="profileInput" class="hidden" accept="image/*" />

				<div class="flex flex-col gap-[5px]">
					<div class="flex flex-col w-[200px]">
						<p class="text-lg font-bold text-left text-black">Name</p>

						<div class="pt-2 pl-5">
							<input type="text"
								class=" text-base font-medium text-left text-[#544c4c] outline-none border-none focus:outline-none focus:border-none"
								value="${loginedMember.name }" />
						</div>
					</div>



					<div class="flex flex-col w-[200px]">
						<p class="text-lg font-bold text-left text-black ">Email</p>
						<div class="pt-2 pl-5 ">
							<input type="text"
								class="text-base font-medium text-left text-[#544c4c] outline-none border-none focus:outline-none focus:border-none"
								value="${loginedMember.email }" />
						</div>
					</div>


					<div class="flex flex-col w-[200px] relative">
						<p class="text-lg font-bold text-left text-black ">Password</p>
						<div class="flex jutify-between pt-2 pl-5 ">
							<input type="password" id="profilePassword"
								class="text-base font-medium text-left text-[#544c4c] outline-none border-none focus:outline-none focus:border-none"
								value="${loginedMember.loginPw }" />

						</div>
						<i onClick="showPassword();" id="showPassword"
							class="top-[37px] right-0 absolute fa-solid fa-eye  cursor-pointer p-1"></i>
					</div>

					<div class="flex flex-col w-[200px]">
						<p class="text-lg font-bold text-left text-black ">Email</p>
						<div class="pt-2 pl-5 ">
							<input
								class="text-base font-medium text-left text-[#544c4c] outline-none border-none focus:outline-none focus:border-none"
								value="${loginedMember.name }" />
						</div>
					</div>


					<button onClick="showToast('변경사항이 저장되었습니다.');"
						class="mt-5 btn btn-outline btn-primary flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">저장하기</button>


				</div>

			</div>
			<a href="#"
				onClick="if(confirm('정말 삭제하시겠습니까?')) deleteMember(${loginedMember.id}});"
				class="absolute bottom-2 right-[15px] flex-grow-0 flex-shrink-0 text-sm font-medium text-center !text-red-500 underline decoration-2 decoration-red-500">삭제하기</a>
			<!-- <a href="#" onClick=""
				class="flex justify-center items-center absolute inset-0 bg-black/20 flex-grow-0 flex-shrink-0  z-5"></a> -->
		</div>
		<div
			class="flex flex-col justify-between items-center self-stretch flex-grow-0 flex-shrink-0 w-[745px] px-[171px] py-[29px]">
			<div
				class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[323px] relative overflow-hidden py-[11px]">
				<p onClick="lookupPlanButton();" id="lookupPlanButton"
					class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center opacity-50  text-black/80 cursor-pointer">여행
					계획 조회</p>
				<p onClick="lookupRecordButton();" id="lookupRecordButton"
					class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center opacity-50 text-black/80 cursor-pointer">여행
					기록 조회</p>
			</div>


			<div
				class="tripPlanUI flex flex-col justify-start items-center flex-grow w-[565px] relative  gap-2.5 pt-[18px] pb-[62px]">


				<div
					class="flex justify-center items-end self-stretch flex-grow-0 flex-shrink-0  gap-2.5 px-[55px] py-1.5">
					<div
						class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[123px] relative  gap-2.5 px-2 py-[9px] border border-black">
						<select id="tripSearchKeywordType"
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black outline-none border-none focus:outline-none focus:border-none">
							<option value="ALL">전체</option>
							<option value="tripName">여행 이름</option>
							<option value="tripRegion">여행 장소</option>
						</select>
					</div>
					<div
						class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[290px] h-[41px] relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
						<input id="tripSearchKeyword" type="text" placeholder="검색어를 입력하세요"
							autocomplete="off"
							class="outline-none border-none focus:outline-none focus:border-none flex-grow " />
						<i
							onClick="getUIBySearchKeyword(${loginedMember.id}, 'tripInfo');"
							class="cursor-pointer fa-solid fa-magnifying-glass text-lg"></i>
					</div>
					<div onClick="toggleCaret(${loginedMember.id})"
						class="sortOrder flex justify-start items-center flex-grow-0 flex-shrink-0 relative gap-[3px] cursor-pointer">
						<p
							class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">최근순</p>
						<i class="fa-solid fa-caret-down"></i>
						<i class="fa-solid fa-caret-up !hidden"></i>
					</div>
				</div>
				<div
					class="tripInfoContainer flex flex-col justify-start items-start self-stretch flex-grow-0 flex-shrink-0  gap-2.5 p-2.5">
					<c:forEach var="tripInfo" items="${tripInfos }" varStatus="status">
						<div onClick="showDetail(${tripInfo.id});"
							class="flex justify-start items-center self-stretch flex-grow relative gap-3 pr-[13px] py-2.5 cursor-pointer">
							<p
								class="flex-grow-0 flex-shrink-0 w-[23px] h-[23px] text-xl font-medium text-center text-black">${tripInfos.size() - status.index}</p>
							<div
								class="flex-grow-0 flex-shrink-0 w-[174px] h-[114px] relative border border-black">
								<img src="${urls[status.index] }"
									class="w-full h-full object-cover" />

							</div>
							<div
								class="flex flex-col justify-center items-start self-stretch flex-grow relative  gap-2.5 pl-2.5 pr-[27px] py-[15px]">
								<div
									class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
									<p
										class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">${tripInfo.tripName}</p>
									<p
										class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripInfo.tripRegion}</p>
								</div>
								<p
									class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${tripInfo.formattedStartDate }
									~ ${tripInfo.formattedEndDate }</p>

							</div>
							<div class="relative">
								<i onclick="event.stopPropagation()"
									class="articleMenuToggle fa-solid fa-bars fa-lg cursor-pointer"></i>
								<!-- 숨겨진 메뉴 -->
								<ul
									class="articleSlideMenu hidden absolute top-[15px] left-0 mt-2 w-40 bg-white border border-gray-300 rounded shadow-lg z-50">
									<li onclick="event.stopPropagation()"
										class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
										<a href="../article/writeByAI?tripId=${tripInfo.id}">글쓰기</a>
									</li>
									<li onclick="event.stopPropagation()"
										class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
										<a href="../planner/modify?tripId=${tripInfo.id}">수정하기</a>
									</li>
									<li onclick="event.stopPropagation()"
										class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
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


				<div
					class="flex justify-center items-end self-stretch flex-grow-0 flex-shrink-0  gap-2.5 px-[55px] py-1.5">
					<div
						class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[123px] relative  gap-2.5 px-2 py-[9px] border border-black">
						<select id="articleSearchKeywordType"
							class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black focus:outline-none focus:ring-0 focus:border-none">
							<option value="ALL">전체</option>
							<option value="title">제목</option>
							<option value="body">내용</option>
							<option value="tripLocation">여행 이름</option>
							<option value="tripLocation">여행 지역</option>
						</select>
					</div>
					<div
						class="flex justify-between items-center flex-grow-0 flex-shrink-0 w-[290px] h-[41px] relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
						<input id="articleSearchKeyword" type="text"
							placeholder="검색어를 입력하세요" autocomplete="off"
							class="focus:outline-none focus:border-none focus:ring-0 flex-grow " />
						<i onClick="getUIBySearchKeyword(${loginedMember.id}, 'article');"
							class="cursor-pointer fa-solid fa-magnifying-glass text-lg"></i>
					</div>
					<div onClick="toggleCaret()"
						class="sortOrder flex justify-start items-center flex-grow-0 flex-shrink-0 relative gap-[3px] cursor-pointer">
						<p
							class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">최근순</p>
						<i class="fa-solid fa-caret-down"></i>
						<i class="fa-solid fa-caret-up !hidden"></i>
					</div>
				</div>
				<div
					class="articleContainer flex flex-col justify-start items-start self-stretch flex-grow-0 flex-shrink-0  gap-2.5 p-2.5">
					<c:forEach var="article" items="${articles }" varStatus="status">
						<div onClick="showDetail(${tripInfo.id});"
							class="flex justify-start items-center self-stretch flex-grow relative gap-3 pr-[13px] py-2.5 cursor-pointer">
							<p
								class="flex-grow-0 flex-shrink-0 w-[23px] h-[23px] text-xl font-medium text-center text-black">${tripInfos.size() - status.index}</p>
							<div
								class="flex-grow-0 flex-shrink-0 w-[174px] h-[114px] relative border border-black">
								<img src="${urls[status.index] }"
									class="w-full h-full object-cover" />

							</div>
							<div
								class="flex flex-col justify-center items-start self-stretch flex-grow relative  gap-2.5 pl-2.5 pr-[27px] py-[15px]">
								<div
									class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
									<p
										class="flex-grow-0 flex-shrink-0 text-xl font-medium text-center text-black">${article.tripName}</p>
									<p
										class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${article.tripRegion}</p>
								</div>
								<p
									class="flex-grow-0 flex-shrink-0 text-[15px] font-medium text-center text-black">${article.formattedStartDate }
									~ ${article.formattedEndDate }</p>

							</div>
							<div class="relative">
								<i onclick="event.stopPropagation()"
									class="articleMenuToggle fa-solid fa-bars fa-lg cursor-pointer"></i>
								<!-- 숨겨진 메뉴 -->
								<ul
									class="articleSlideMenu hidden absolute top-[15px] left-0 mt-2 w-40 bg-white border border-gray-300 rounded shadow-lg z-50">
									<li onclick="event.stopPropagation()"
										class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
										<a href="../planner/modify?articleId=${article.id}">수정하기</a>
									</li>
									<li onclick="event.stopPropagation()"
										class="px-4 py-2 hover:bg-gray-100 cursor-pointer">
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

<div id="toast"
	class="fixed bottom-5 left-1/2 transform -translate-x-1/2 bg-black text-white text-sm px-4 py-2 rounded-md shadow-lg opacity-0 transition-opacity duration-500 z-5">
</div>
<%@ include file="../common/foot.jspf"%>