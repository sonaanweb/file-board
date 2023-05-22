<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.oreilly.servlet.MultipartRequest" %>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "vo.*" %>
<%
	
	// 유효성 검사
	if(request.getParameter("boardNo")==null
	||request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/boardList.jsp"); //유효하지 않을 시 리스트로
		return;	
	}

	// list 삭제버튼에서 받아온 값 저장
	String boardNo = request.getParameter("boardNo");
	
	// DB) 게시글 삭제 DELETE * board file = > board_no - CASCADE (외래키) 게시글 삭제시 전체 삭제
	// 삭제에 필요한 값 board_no
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	String delSql = "DELETE FROM board WHERE board_no";
	PreparedStatement delStmt = conn.prepareStatement(delSql);
	delStmt.setString(1,boardNo);
	System.out.println(delStmt + " <--- delete board Action Stmt");
	
	int row = delStmt.executeUpdate();
	if(row > 0){ // 결과 행 0보다 크면 삭제 성공
		System.out.println("게시글이 삭제되었습니다.");
		response.sendRedirect(request.getContextPath()+"/boardList.jsp"); //삭제 성공시 리스트로 리스폰
	} else { // 실패
		System.out.println("게시글이 삭제되지 않았습니다.");
	}
%>