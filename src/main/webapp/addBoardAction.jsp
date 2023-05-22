<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.oreilly.servlet.*" %><!-- cos.jar... -->
<%@ page import = "com.oreilly.servlet.multipart.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.io.*"%> <!-- 타입이 맞지 않는 업로드 된 불필요한 파일을 삭제하기 위해 불러옴 -->
<%@ page import = "java.sql.*" %>
<%

	String dir = request.getServletContext().getRealPath("/upload"); // 이 프로젝트 내 upload 파일 호출
	System.out.println(dir+"<---dir"); // sysout: C:.... 실제 경로 <---dir 
	
	int max = 10 * 1024 * 1024;
	
	// request객체를 multipartRequest의 API를 사용할 수 있도록 랩핑
	// DefaultFileRenamePolicy() 파일 중복이름 방지 -- 파일명 넘버링 처리 *후에 다른 방법으로 사용
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	// multipartRequest API를 사용하여 스트림내에서 문자값을 반환받을 수 있다
	
	//업로드 파일이 pdf가 아니면 받지 않음
	if(mRequest.getContentType("boardFile").equals("application/pdf") == false) { // 타입이 유효하지 않은 저장된 파일 삭제
		System.out.println("pdf파일이 아닙니다");
		String saveFilename = mRequest.getFilesystemName("boardFile");
		File f = new File(dir+"/"+saveFilename);
	/* dir(경로)+"\\"+ file 이름을 가져와서 (* 자바기본문법 : "\"="\\"로 표현 '/'로 표현해도 자동으로 바꿔줌 */
	
		if(f.exists()){ // pdf가 아닌게 존재한다면 delete()
			f.delete();
			System.out.println(saveFilename +"파일삭제");
		}
		response.sendRedirect(request.getContextPath()+"/addBoard.jsp");
		return;
			}
	
	// 1) input type ="text" 반환 API
	// board 테이블에 저장
	String boardTitle = mRequest.getParameter("boardTitle");
	String memberId = mRequest.getParameter("memberId");
	
	System.out.println(boardTitle + "<--boardTitle");
	System.out.println(memberId + "<--memberId");
	
	Board board = new Board(); // 저장 (1)
	board.setBoardTitle(boardTitle);
	board.setMemberId(memberId);
	
	// 2) input type = "file" 값(파일 메타 정보)반환 API(원본 파일 이름, 저장된 파일 이름, 컨텐츠 타입) 받아옴
	// board_file 테이블에 저장
	// 파일(바이너리)은 이미 (request랩핑시 15라인)에서 저장
	String type = mRequest.getContentType("boardFile"); // boardFile 받아온다. api 받는 타입 다름
	String originFilename = mRequest.getOriginalFileName("boardFile"); // 매개변수로 받은 파라미터 값으로 업로드된 파일의 원본이름 리턴
	String saveFilename = mRequest.getFilesystemName("boardFile"); // 파일의 고유이름 리턴
	
	System.out.println(type + "<--type");
	System.out.println(originFilename + "<--originFilename");
	System.out.println(saveFilename + "<--saveFilename");
	
	BoardFile boardFile = new BoardFile(); // 저장(2)
	// boardFile.setBoardNo(boardNo);
	boardFile.setType(type);
	boardFile.setOriginFilename(originFilename);
	boardFile.setSaveFilename(saveFilename);
	
	/*
		1) 쿼리
		INSERT INTO board(board_title, member_id, updatedate, createdate)
		VALUES(?,?,now(),now());
		
		2) 쿼리
		INSERT INTO board_file(board_no, origin_filename, save_filename, path, type, createdate)
		VALUES(?,?,?,?,?,now());
	*/
	/*
		INSERT쿼리 실행 후 기본키값 받아오기 JDBC API
		ResultSet keyRs = pstmt.getGeneratedKeys(); - insert 후 입력된 행의 키값을 받아오는 select
	*/
	
	// DB연동
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	
	// 1) 쿼리
	String boardSql = "INSERT INTO board(board_title, member_id, updatedate, createdate) VALUES(?,?,now(),now())";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql,PreparedStatement.RETURN_GENERATED_KEYS);
																			// insert 하면서 들어간 키값을 받을 수 있다.
	boardStmt.setString(1, boardTitle);
	boardStmt.setString(2, memberId);
	boardStmt.executeUpdate(); // board 입력 후 키값 저장
	ResultSet keyRs = boardStmt.getGeneratedKeys(); // 저장된 키값을 반환	
	int boardNo = 0;
	if(keyRs.next()) {
		boardNo = keyRs.getInt(1); //boardNo key값이 나온다
	}
	
	// 2) 쿼리
	String fileSql = "INSERT INTO board_file(board_no, origin_filename, save_filename, type, path, createdate)VALUES(?,?,?,?,'/upload',now())";
	PreparedStatement fileStmt = conn.prepareStatement(fileSql);
	fileStmt.setInt(1,boardNo); //위에서 구한 boardNo가 들어간다.
	fileStmt.setString(2, originFilename);
	fileStmt.setString(3, saveFilename);
	fileStmt.setString(4, type);
	fileStmt.executeUpdate(); // board_file 입력
	
	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
	
%>