<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(request.getParameter("boardFileNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, f.board_file_no boardFileNo, f.origin_filename originFilename FROM board b INNER JOIN board_file f ON b.board_no = f.board_no WHERE b.board_no=? AND f.board_file_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setInt(2, boardFileNo);
	ResultSet rs = stmt.executeQuery();
	
	// 한번에 하나만 수정하는 거니까 arraylist (x) 필요한 값 네가지
	HashMap<String,Object> map = null;
	if(rs.next()) {
		map = new HashMap<>();
		map.put("boardNo", rs.getInt("boardNo"));
		map.put("boardTitle", rs.getString("boardTitle"));
		map.put("boardFileNo", rs.getInt("boardFileNo"));
		map.put("originFilename", rs.getString("originFilename"));
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>게시글 수정</title>
<style>
table, th, td{
border: 1px solid #000000;
	}
</style>
</head>
<body>
	<div class="container mt-3">
	<h1 style="text-align: center;">board / boardFile 수정</h1>
	<form action="<%=request.getContextPath()%>/modifyBoardAction.jsp" method="post" enctype="multipart/form-data">
		<input type="hidden" name="boardNo" value="<%=map.get("boardNo")%>">
		<input type="hidden" name="boardFileNo" value="<%=map.get("boardFileNo")%>">
	<%
		if(request.getParameter("msg") != null){
	%>
	<div class="alert alert-warning alert-dismissible fade show" style="font-size: 10pt;"><%=request.getParameter("msg")%></div>
	<%
		}
	%>
	<table  class="table">
		<tr>
			<td>boardTitle</td>
			<td>
			<textarea rows="3" cols="50" name="boardTitle" required="required"><%=map.get("boardTitle")%></textarea>
			</td>
		</tr>
		<tr>
			<th>boardFile(수정전 파일 :<%=map.get("originFilename")%>)</th>
			<td>
			<input type="file" name="boardFile">
			</td>
		</tr>
	</table>
	<button type="submit" class="btn btn-light">수정</button>
	<a href="<%=request.getContextPath()%>/boardList.jsp" class="btn btn-light">취소</a>
	</form>
	</div>
</body>
</html>