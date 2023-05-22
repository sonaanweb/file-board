<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션 유효성 검사
	// 세션에서 지정한 loginmemberid 얻어 와 검사
	if(session.getAttribute("loginMemberId") !=null) { // 로그인 성공했으면 home으로 이동
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
</style>
<title>로그인</title>
</head>
<body>
		<%
			if(session.getAttribute("loginMemberId") == null) { 
		%>	
	<br>
	<h2 style="text-align: center">로그인</h2>
	<!-- login 유효 / 무효 알림 메세지 -------------------------->
	<div>
		<%
			if(request.getParameter("msg") != null){
		%>
			<div><%=request.getParameter("msg")%></div>
		<%
			}
		%>
	</div>
	<!-------------------------------------------------------->
	<form action="<%=request.getContextPath()%>/loginAction.jsp" method="post">
		<table id="table">
			<tr>
				<td>아이디</td>
				<td><input type="text" name="memberId"></td>
			</tr>	
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name="memberPw"></td>
			</tr>	
		</table>
	<br>
		<button type="submit">로그인</button>
	</form>
		<%
			}
		%>
	<br>
</body>
</html>