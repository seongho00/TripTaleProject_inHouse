<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<c:set var="pageTitle" value="ARTICLE LIST"></c:set>
<%@ include file="../common/head.jspf"%>
<script>
	function showDetail(articleId) {
		window.location.href = "detail?articleId=" + articleId;
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
			success : function(response) {
				const articles = response.articles;
				const articleImages = response.articleImages;
				renderArticles(articles, articleImages);
			},
			error : function() {
				alert('검색 중 오류가 발생했습니다.');
			}
		});
	}
	
	function renderArticles(articles , articleImages) {
		const container = $('.articleContainer');
		container.empty(); // 기존 목록 제거

		if (articles.length === 0) {
			container.append('<p class="text-center w-full text-gray-500">검색 결과가 없습니다.</p>');
			return;
		}

		articles.forEach((article, index) => {
			
			const articleImg = articleImages[index];
			console.log(articleImg);
			const html = `
				<div onclick="showDetail(\${article.id});"
					class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black cursor-pointer">
					<img src="\${articleImg}"
						class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
					<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
						<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">\${article.title}</p>
						<p class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">\${article.extra__tripRegion}</p>
					</div>
					<p class="flex-grow-0 flex-shrink-0 w-[200px] h-[46px] text-[10px] text-center text-black overflow-hidden">\${article.body }</p>
					<div class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
						<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수: \${article.hitCount}</p>
						<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">좋아요: \${article.extra__likeCount}</p>
						<i class="flex-grow-0 fa-solid fa-heart text-red-500"></i>
						<img src="image-28.png" class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
						<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">작성자: \${article.extra__name }</p>
					</div>
				</div>
			`;

			container.append(html);
		});
	}
</script>


<div
	class="flex flex-col justify-start items-center w-screen h-screen overflow-hidden gap-2.5 bg-white border border-[#0f0000]">
	<%@ include file="../common/header_blue.jspf"%>
	<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 overflow-hidden gap-[19px] px-[17px]">

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
			<input type="text" name="keyword" id="keywordInput" class="w-full focus:outline-none focus:ring-0 focus:border-none"
				autocomplete="off" />
			<i onClick="searchByKeyWord();" class="fa-solid fa-magnifying-glass cursor-pointer"></i>
		</div>
	</div>
	<div
		class="articleContainer flex flex-wrap justify-center items-start flex-grow mx-auto grid grid-cols-4  overflow-auto gap-[13px] py-2.5">
		<c:forEach var="article" items="${articles }" varStatus="status">

			<div onClick="showDetail(${article.id});"
				class="flex flex-col justify-center items-center flex-grow-0 flex-shrink-0 w-[243px] relative overflow-hidden gap-2.5 px-5 py-[11px] border border-black cursor-pointer">
				<img src="${articleImages.get(status.index) }"
					class="self-stretch flex-grow-0 flex-shrink-0 h-[135.09px] object-cover" />
				<div class="flex justify-start items-end flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 pr-[7px]">
					<p class="flex-grow-0 flex-shrink-0 text-xl text-center text-black">${article.title }</p>
					<p class="flex-grow-0 flex-shrink-0 text-[15px] text-center text-black">${article.extra__tripRegion}</p>
				</div>
				<p class="flex-grow-0 flex-shrink-0 w-[200px] h-[46px] text-[10px] text-center text-black overflow-hidden">${article.body }</p>
				<div
					class="flex justify-center items-center flex-grow-0 flex-shrink-0 relative overflow-hidden gap-2.5 px-[26px] py-[5px]">
					<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">조회수: ${article.hitCount }</p>
					<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">좋아요:
						${article.extra__likeCount }</p>
					<i class="flex-grow-0 fa-solid fa-heart text-red-500"></i>
					<img src="image-28.png" class="flex-grow-0 flex-shrink-0 w-[13px] h-[13px] object-cover" />
					<p class="flex-grow-0 flex-shrink-0 text-[8px] font-medium text-center text-black">작성자: ${article.extra__name }</p>
				</div>
			</div>
		</c:forEach>


	</div>
</div>

<%@ include file="../common/foot.jspf"%>