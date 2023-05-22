<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>add board + file</title><!-- 파일 선택할 수 있는 폼 -->
<style type="text/css">
</style>
</head>
<body>
	<div class="container mt-3">
	<h1 style="text-align: center;">자료 업로드</h1><!-- enctype = multipart/form-data & post방식 -->
	<form action="<%=request.getContextPath()%>/addBoardAction.jsp" method="post" enctype="multipart/form-data">
		<table class="table">
			<!-- 자료 업로드 제목 -->
			<tr>
				<th>boardTitle</th>
				<td><!-- required : 폼 공백일 시 submit(X) -->
					<textarea rows="3" cols="50" name="boardTitle" required="required"></textarea>
				</td>
			</tr>
			
			<!-- 로그인 사용자 아이디 -->
			<%
				//String memberId = session.getAttribute("loginMemberId");
				String memberId = "test";
			%>
			<tr>
				<th>memberId</th>
				<td>
					<input type="text" name="memberId" value="<%=memberId%>" readonly="readonly">
				</td>
			</tr>
			
			<!--  -->
			<tr>
				<th>boardFile</th><!-- vo -->
				<td>
					<input type="file" name="boardFile" required="required">
				</td>
			</tr>
		</table>
		<button type="submit" class="btn btn-light">업로드</button>
		<a href="<%=request.getContextPath()%>/boardList.jsp" class="btn btn-light">취소</a>
	</form>
	</div>
</body>
</html>