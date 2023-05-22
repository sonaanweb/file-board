<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import ="java.sql.*"%>
<%

	/* 
	SELECT b.board_title boardTitle, f.origin_filename originFilename
	FROM board b INNER JOIN board_file f
	ON  b.board_no = f.board_no
	order by b.createdate DESC
	*/
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, f.board_file_no boardFileNo, f.origin_filename originFilename, f.save_filename saveFilename, path FROM board b INNER JOIN board_file f ON b.board_no = f.board_no order by b.createdate DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<HashMap<String,Object>> list = new ArrayList<>();
	while(rs.next()) {
		HashMap<String,Object> m = new HashMap<>();
		m.put("boardNo", rs.getInt("boardNo"));
		m.put("boardTitle", rs.getString("boardTitle"));
		m.put("boardFileNo", rs.getInt("boardFileNo"));
		m.put("originFilename", rs.getString("originFilename"));
		m.put("saveFilename", rs.getString("saveFilename")); //출력하지는 않지만 들어가야 함
		m.put("path", rs.getString("path"));
		list.add(m);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>pdf board list</title>
<style>
td{text-align: center;}
a{text-decoration: none;}
</style>
</head>
<body>
	<div class="container mt-3">
	<h1 style="text-align: center;">PDF 자료 목록</h1>
	<a href="<%=request.getContextPath()%>/addBoard.jsp" style="float: left;" class="btn btn-light">추가</a>
	<br><br>
	<table class="table">
		<tr class="table-warning">
			<td>boardTitle</td>
			<td>originFilename</td>
			<td>수정</td>
			<td>삭제</td>
		</tr>
		<%
			for(HashMap<String,Object> m : list){
		%>
			<tr>
				<td><%=(String)m.get("boardTitle")%></td>
				<td>
					<a href="<%=request.getContextPath()%>/<%=(String)m.get("path")%>/<%=(String)m.get("saveFilename")%>" download="<%=(String)m.get("saveFilename")%>">
					<%=(String)m.get("originFilename")%>
					</a>
				</td>
				<td><a href="<%=request.getContextPath()%>/modifyBoard.jsp?boardNo=<%=m.get("boardNo")%>&boardFileNo=<%=m.get("boardFileNo")%>">수정</a></td>
				<td><a href="<%=request.getContextPath()%>/removeBoardAction.jsp?boardNo=<%=m.get("boardNo")%>">삭제</a></td>
			</tr>
		<%
			}
		%>
	</table>
	</div>
</body>
</html>