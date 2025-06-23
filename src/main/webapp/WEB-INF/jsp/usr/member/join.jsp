<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<c:set var="pageTitle" value="JOIN PAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<script>
	function checkUserIdDuplicate(el) {
		$('.checkIdDup-msg').empty();

		const form = $(el).closest('form').get(0);

		$.get('../member/getLoginIdDup', {
			loginId : form.loginId.value
		}, function(data) {
			if (data.success) {
				$('.checkEmptyMsg').html(
						'<div class="text-green-500">' + data.msg + '</div>')
				validLoginId = data.data1;
			} else {
				$('.checkEmptyMsg').html(
						'<div class="text-red-500">' + data.msg + '</div>')
				validLoginId = '';
			}
		}, 'json');

	}

	function checkUserIdEmpty(el) {
		$('.checkIdDup-msg').empty();

		const form = $(el).closest('form').get(0);
		const value = el.value;
		const msg = el.placeholder;

		if (value.length == 0) {
			console.log("실행됨2");
			$('.checkEmptyMsg')
					.html(
							'<div class="text-red-500">' + msg
									+ '가 입력되지 않았습니다. </div>')
		}

	}

	const checkLoginIdDupDebounced = _.debounce(checkUserIdDuplicate, 600);
</script>

<div
	class="flex flex-col justify-center items-center w-screen h-screen overflow-hidden gap-2.5 px-[9px] py-[7px] bg-white border border-[#0f0000]">
	<div class="flex rounded-[10px] border border-black bg-white" style="box-shadow: 4px 4px 4px 0 rgba(0, 0, 0, 0.25);">
		

		

	</div>
</div>

<%@ include file="../common/foot.jspf"%>