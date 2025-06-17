<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="관광사진" />
<%@ include file="../common/head.jspf"%>

${article.id}
<c:forEach var="img" items="${articleImages}">
  <img src="${img}" alt="게시글 이미지" style="width: 300px; height: auto;" />
</c:forEach>

<%@ include file="../common/foot.jspf"%>