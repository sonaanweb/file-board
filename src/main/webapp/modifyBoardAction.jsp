<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.oreilly.servlet.MultipartRequest" %>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "vo.*" %>
<%
	// board title은 무조건 수정
	
	String dir = request.getServletContext().getRealPath("/upload"); // 이 프로젝트 내 upload 파일 호출
	System.out.println(dir+"<---dir"); // sysout: C:.... 실제 경로 <---dir 
	
	int max = 10 * 1024 * 1024; // 10MB
	
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy()); // DefaultFileRenamePolicy 중복제거 메서드
	//System.out.println(mRequest.getOriginalFileName("boardFile")+ "<---boardFile");
	//mRequest.getOriginalFileName("boardFile") 값이 null이면 board테이블에 title만 수정
	
	// 값 저장
	String msg = "";
	int boardNo = Integer.parseInt(mRequest.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(mRequest.getParameter("boardFileNo"));	
	
	// 1) board_title 수정 ----------------------------------------------------------------------------------------
	
	String boardTitle = mRequest.getParameter("boardTitle"); 
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	String boardSql = "UPDATE board SET board_title = ? WHERE board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setString(1, boardTitle);
	boardStmt.setInt(2, boardNo);
	int boardRow = boardStmt.executeUpdate();
	
//----------------------------------------------------------------------------------------------------------------

	// 2) 이전 boardFile 삭제, 새로운 boardFile추가 테이블을 수정 

	if(mRequest.getOriginalFileName("boardFile") != null) {
		// 수정할 파일이 있으면
		// pdf 파일 유효성 검사, pdf가 아니면 새로 업로드 한 파일 삭제 delete
		if(mRequest.getContentType("boardFile").equals("application/pdf") == false) {
			System.out.println("PDF파일이 아닙니다");
			String saveFilename = mRequest.getFilesystemName("boardFile");
			File f = new File(dir+"/"+saveFilename);
			if(f.exists()) {
				f.delete();
				System.out.println(saveFilename+"파일삭제");
				msg = URLEncoder.encode("PDF파일만 업로드 가능합니다.","utf-8");
				response.sendRedirect(request.getContextPath()+"/modifyBoard.jsp?boardNo="+boardNo+"&msg="+msg+"&boardFileNo="+boardFileNo);
			return;}
		} else { 
			// PDF파일이면  
			// 1) 이전 파일(saveFilename) 삭제
			// 2) db수정(update)
			String type = mRequest.getContentType("boardFile");
			String originFilename = mRequest.getOriginalFileName("boardFile");
			String saveFilename = mRequest.getFilesystemName("boardFile");
			
			BoardFile boardFile = new BoardFile();
			boardFile.setBoardFileNo(boardFileNo);
			boardFile.setType(type);
			boardFile.setOriginFilename(originFilename);
			boardFile.setSaveFilename(saveFilename);
			
			// 1) 이전파일 삭제
			String saveFilenameSql = "SELECT save_filename FROM board_file WHERE board_file_no=?";
			PreparedStatement saveFilenameStmt = conn.prepareStatement(saveFilenameSql);
			saveFilenameStmt.setInt(1, boardFile.getBoardFileNo());
			ResultSet saveFilenameRs = saveFilenameStmt.executeQuery();
			String preSaveFilename = "";
			if(saveFilenameRs.next()) {
				preSaveFilename = saveFilenameRs.getString("save_filename");
			}
			File f = new File(dir+"/"+preSaveFilename);
			if(f.exists()) {
				f.delete();
			}
			
	// 3) 수정된 파일의 정보로 db를 수정 ----------------------------------------------------------------------------------
	/*
		UPDATE board_file 
		SET origin_filename=?, save_filename=? 
		WHERE board_file_no=?
	*/
	String boardFileSql = "UPDATE board_file SET origin_filename=?, save_filename=? WHERE board_file_no=?";
	PreparedStatement boardFileStmt = conn.prepareStatement(boardFileSql);
	boardFileStmt.setString(1, boardFile.getOriginFilename());
	boardFileStmt.setString(2, boardFile.getSaveFilename());
	boardFileStmt.setInt(3, boardFile.getBoardFileNo());
	int boardFileRow = boardFileStmt.executeUpdate();
	}
}
	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
%>