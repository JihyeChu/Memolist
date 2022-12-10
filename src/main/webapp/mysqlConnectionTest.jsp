<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>mysql에 연결하기</title>
</head>
<body>

<%
	Connection conn = null;
	
	try{
//		mysql 드라이버 클래스를 읽어온다.
		Class.forName("com.mysql.jdbc.Driver"); // 5.x 사용자
		// Class.forName("com.mysql.cj.dbc.Driver"); // 8.x 사용자
		// mysql에 연결한다.
		// DriverManager 클래스의 getConnection(url, user, password) 메소드로 mysql에 연결한다.
		// url에 사용할 mysql이 설치된 경로와 데이터베이스 이름을 적는다.
		// localhost는 mysql이 설치된 컴퓨터가 현재 사용중인 컴퓨터임을 의미한다.
		// 3306은 mysql이 컴퓨터와 통신할 때 사용하는 포트 번호를 의미한다. => 오라클 1521을 사용한다.
		String url = "jdbc:mysql://localhost:3306/java_am?useUnicode=true&characterEncoding=UTF-8"; // 5.x 사용자
		// String url = "jdbc:mysql://localhost:3306/java_am?serverTimezone=UTC"; // 8.x 사용자
		conn = DriverManager.getConnection(url, "root", "0000");
		out.println("연결성공: " + conn + "<br/>");
	}catch(ClassNotFoundException e){
		out.println("드라이버 클래스가 없습니다.");
	}catch(SQLException e){
		out.println("데이터베이스 접속 정보가 올바르지 않습니다.");
	}finally{
		if(conn != null){
			try{
				conn.close();
			}catch(SQLException e){
				
			}
		}
	}
%>

</body>
</html>
















