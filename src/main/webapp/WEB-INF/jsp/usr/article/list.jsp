<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<c:set var="pageTitle" value="ARTICLE LIST"></c:set>
<%@ include file="../common/head.jspf"%>
<script>
	function showDetail() {
		window.location.href = "detail?articleId=1";
	}

	function searchByKeyWord() {
		const filter = $('#filterSelect').val();
		const keyword = $('#keywordInput').val().trim();

		if (keyword.length == 0) {
			alert("검색어를 입력해주세요");
			return;
		}

		$.ajax({
			url : 'searchKeyword',
			method : 'GET',
			data : {
				filter : filter,
				keyword : keyword
			},
			success : function(data) {
				console.log(data);
			},
			error : function() {
				alert('검색 중 오류가 발생했습니다.');
			}
		});
	}
</script>


<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<div
		class="flex flex-col justify-start items-start self-stretch flex-grow-0 flex-shrink-0 h-[138px] relative overflow-hidden gap-2.5 px-2.5 bg-[#aedff7] border-b border-black">
		<div
			class="self-stretch flex-grow-0 flex-shrink-0 h-[138px] relative overflow-hidden">
			<div
				class="flex justify-center items-center w-[1008px] h-[138px] absolute left-[346px] top-0 gap-2.5 border-0 border-[#f00]">
				<img src="/images/로고.png"
					class="flex-grow-0 flex-shrink-0 w-[138px] h-[138px] object-cover" />
				<div
					class="flex justify-start items-start self-stretch flex-grow relative overflow-hidden gap-2.5 p-2.5">
					<p
						class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">숙박</p>
					<p
						class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">맛집</p>
					<p
						class="self-stretch flex-grow w-[127.33px] h-[118px] text-xl font-medium text-center text-black">명소</p>
				</div>
				<div
					class="flex justify-center items-center self-stretch flex-grow-0 flex-shrink-0 w-[428px] relative">
					<p
						class="flex-grow w-[159px] h-14 text-xl font-medium text-center text-black">내
						여행</p>
					<p
						class="flex-grow w-[159px] h-14 text-xl font-medium text-center text-black">계획
						작성</p>
					<img src="프로필-아이콘.png"
						class="flex-grow-0 flex-shrink-0 w-[110px] h-[110px] object-cover" />
				</div>
			</div>
		</div>
	</div>
	<div
		class="flex justify-start items-end flex-grow-0 flex-shrink-0 overflow-hidden gap-[19px] px-[17px]">

		<select name="searchKeyword" id="filterSelect"
			class="px-2 py-[9px] border border-black text-[15px] font-medium text-black">
			<option value="All" selected>전체</option>
			<option value="title">제목</option>
			<option value="region">지역</option>
			<option value="author">작성자</option>
			<option value="body">내용</option>
		</select>

		<div
			class="flex justify-start items-center flex-grow-0 flex-shrink-0 w-[290px] h-9 relative gap-2.5 px-2.5 py-[7px] rounded-[15px] bg-white border border-black">
			<input type="text" name="keyword" id="keywordInput"
				class="w-full focus:outline-none focus:ring-0 focus:border-none" autocomplete="off"/>
			<i onClick="searchByKeyWord();"
				class="fa-solid fa-magnifying-glass cursor-pointer"></i>
		</div>
	</div>
	<div
		class="flex flex-wrap justify-center items-start flex-grow w-[1084px] overflow-auto gap-[13px] py-2.5">
		<div onClick="showDetail();"
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black cursor-pointer">
			<img src="image-24.png"
				class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div
				class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울
					나들이</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p
				class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행
				본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수:
					2000</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수:
					2000</p>
				<img src="image.png"
					class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png"
					class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png"
				class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div
				class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울
					나들이</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p
				class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행
				본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수:
					2000</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수:
					2000</p>
				<img src="image.png"
					class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png"
					class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png"
				class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div
				class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울
					나들이</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p
				class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행
				본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수:
					2000</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수:
					2000</p>
				<img src="image.png"
					class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png"
					class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png"
				class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div
				class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울
					나들이</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p
				class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행
				본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수:
					2000</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수:
					2000</p>
				<img src="image.png"
					class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png"
					class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png"
				class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div
				class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울
					나들이</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p
				class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행
				본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수:
					2000</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수:
					2000</p>
				<img src="image.png"
					class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png"
					class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png"
				class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div
				class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울
					나들이</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p
				class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행
				본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수:
					2000</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수:
					2000</p>
				<img src="image.png"
					class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png"
					class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png"
				class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div
				class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울
					나들이</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p
				class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행
				본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수:
					2000</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수:
					2000</p>
				<img src="image.png"
					class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png"
					class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png"
				class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div
				class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울
					나들이</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p
				class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행
				본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수:
					2000</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수:
					2000</p>
				<img src="image.png"
					class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png"
					class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
		<div
			class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black">
			<img src="image-24.png"
				class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
			<div
				class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
				<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">서울
					나들이</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">서울</p>
			</div>
			<p
				class="flex-grow-0 flex-shrink-0 w-[151px] h-[46px] text-[10px] text-center text-black">여행
				본문 글 첫번째 줄 내용</p>
			<div
				class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수:
					2000</p>
				<p
					class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">추천수:
					2000</p>
				<img src="image.png"
					class="flex-grow-0 flex-shrink-0 w-3.5 h-3 object-cover" />
				<img src="image-28.png"
					class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
			</div>
		</div>
	</div>
</div>

<%@ include file="../common/foot.jspf"%>