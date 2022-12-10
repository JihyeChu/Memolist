<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.tjoeun.memoList.DBUtil"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출첵</title>
<style type="text/css">
	a{
		color: gray;
		text-decoration: none;
	}
	a:hover{
		color: black;
		text-decoration: none;
	}
	span{
		font-weight: bold;
	}
</style>
</head>
<body>

	<!-- 입력 화면 설계 -->
	<form action="memoInsert.jsp" method="post">
		<table width="1000" align="center" border="1" cellpadding="5" cellspacing="0">
			<tr>
				<th colspan="3">출첵 게시판</th>
			</tr>
			<tr>
				<th width="100">이름</th>
				<th width="100">비밀번호</th>
				<th width="800">메모</th>
			</tr>
			<tr>
				<td align="center">
					<input type="text" name="name" style="width:90%; height:25px;" />
				</td>
				<td align="center">
					<input type="password" name="password" style="width:90%; height:25px;"/>
				</td>
				<td align="center">
					<input type="text" name="memo" style="width:92%; height:25px;"/>
					<input type="submit" value="저장" style="height:30px;"/>
				</td>
			</tr>
		</table>
	</form>
	<!-- 입력 화면 설계 끝 -->
	<br/>
	<hr size="3" color="gray"/>	
	<br/>
	<!-- 테이블에 저장된 글 목록 전체를 글 번호(idx)의 내림차순(최신글 부터)으로 얻어온다. -->

<%
//	페이지 작업에 사용할 8개의 변수를 선언한다. => 계산에 의한 값을 가져야하는 변수는 0으로 초기화 한다.
	int pageSize = 10; // 한 페이지에 표시한 글 개수
	int totalCount = 0; // 테이블에 저장된 전체 글 개수
	int totalPage = 0; // 전체 페이지 개수
	int currentPage = 1; // 현재 브라우저에 표시되는 페이지 번호
	int startNo = 0; // 현재 브라우저에 표시되는 글의 시작 인덱스 번호 => mysql은 index가 0부터 시작한다.
	int endNo = 0; // 현재 브라우저에 표시되는 글의 마지막 인덱스 번호
	int startPage = 0; // 페이지 이동 하이퍼링크 또는 버튼에 표시될 시작 페이지 번호
	int endPage = 0; // 페이지 이동 하이퍼링크 또는 버튼에 표시될 마지막 페이지 번호
	
	Connection conn = DBUtil.getMysqlConnection();
	
//	1.=================================================================================

//	totalCount 변수에 테이블에 저장된 전체 글의 개수를 얻어와서 지정한다.
	String sql = "select count(*) from memolist";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	ResultSet rs = pstmt.executeQuery();
//	테이블에 저장된 글이 있으면 저장된 글의 개수를 얻어와 ResultSet 객체에 저장하고 테이블에 글이 없으면
//	0을 ResultSet 객체에 저장하므로 ResultSet 객체 저장되는 데이터가 무조건 있기 때문에 물어보는 동작을
//	할 필요가 없다.
	rs.next();
	totalCount = rs.getInt(1);
//	out.println("테이블에 저장된 전체 글의 개수: " + totalCount + "개<br/>");	

//	totalPage 변수에 전체 페이지 개수를 계산해 저장한다.
	totalPage = (totalCount-1) / pageSize + 1;
//	out.println("전체 페이지 개수: " + totalPage + "개<br/>");

//	2.=================================================================================

//	이전 페이지에서 넘어오는 브라우저에 표시할 페이지 번호를 받는다.
//	게시판(memoList2.jsp)이 최초로 실행될 때 이전 페이지가 존재하지 않기 때문에 넘어오는 currentPage가
//	존재하지 않는다. => 넘어오는 값이 없으므로 null 이다.
//	memoInsert.jsp에서 memoList2.jsp가 호출될 때 currentPage를 넘겨주지 않기 때문에 역시 null 이다.
//	null을 parseInt() 메소드를 실행하면 NumberFormatException이 발생되기 때문에 현재 브라우저에 표시할
//	페이지 번호를 받을 때 예외 처리를 해야한다.
//	정상적인 currentPage가 넘어오면 넘어온 currentPage를 숫자로 바꿔 currentPage 변수에 저장하고 그렇지
//	않으면 초기값으로 지정한 1을 유지하게 하면된다.
	try{
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		// 현재 화면에 표시할 페이지 번호는 전체 페이지 개수보다 클 수 없으므로 화면에 표시할 페이지 번호가
		// 전체 페이지 개수보다 큰 값이 넘어왔을 때 현재 페이지 번호를 전체 페이지 개수로 수정한다.
		currentPage = currentPage > totalPage ? totalPage : currentPage;
	}catch(NumberFormatException e){ }

//	3.=================================================================================

//	startNo 변수에 현재 화면에 표시될 글의 시작 인덱스 번호를 계산한다.
//	mysql은 select sql 명령을 실행했을 때 맨 처음 나오는 글의 인덱스가 0부터 시작되고 oracle은 1부터 시작한다.
	startNo = (currentPage-1) * pageSize;
//	mysql은 limit를 사용하면 되기 때문에 endNo를 계산할 필요가 없지만 oracle은 limit가 없기 때문에 endNo를
//	계산해야 한다.
	endNo = startNo + pageSize - 1;
//	마지막 페이지에 표시되는 글의 개수는 반드시 표시할 글의 개수(pageSize)만큼 표시되지 않는다.
//	한 페이지에 표시할 마지막 글의 인덱스는 전체글의 개수보다 커지면 안되므로 마지막 글의 인덱스 번호가 전체글의
//	개수보다 커지면 전체 글의 개수로 마지막 글의 인덱스 번호를 수정한다.
	endNo = endNo > totalCount ? totalCount : endNo;

//	4.=================================================================================
	
	sql = "select * from memolist order by idx desc limit ?, ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, startNo);
	pstmt.setInt(2, pageSize);
	rs = pstmt.executeQuery();
%>

	<table width="1200" align="center" border="1" cellpadding="5" cellspacing="0">
		<tr>
			<th width="80">글번호</th>
			<th width="80">이름</th>
			<th width="840">메모</th>
			<th width="120">작성일</th>
			<th width="80">ip</th>
		</tr>
		<tr>
			<td colspan="5" align="right">
				<%=totalCount%>개(<%=currentPage%>/<%=totalPage%>)Page
			</td>
		</tr>
<%
	if(rs.next()){
		SimpleDateFormat sdf = new SimpleDateFormat("yyy-MM-dd(E)");
		do {
%>
		<tr>
			<td><%=rs.getInt("idx")%></td>
			<td><%=rs.getString("name")%></td>
			<td><%=rs.getString("memo")%></td>
			<td><%=sdf.format(rs.getTimestamp("writeDate"))%></td>
			<td><%=rs.getString("ip") %></td>
		</tr>
<%
		}while(rs.next());
	} else {
%>
	<tr>
		<td colspan="5">
			<marquee>테이블에 저장된 글이 없습니다.</marquee>
		</td>
	</tr>
<%
	}
%>

		<!--  첫 페이지 부터 마지막 페이지까지 이동할 수 있는 하이퍼링크 또는 버튼을 만든다. -->
		<tr>
			<td colspan="5">
<%
	for(int i=1; i<=totalPage; i++){
		if(currentPage == i){
%>
			<!-- <span>[<%=i%>]</span> -->
			<%-- <input type="button" value="<%=i%>" disabled/> --%>
			<button type="button" disabled><%=i %></button>
<%
		}else{
%>
			<!-- <a href="?currentPage=<%=i%>">[<%=i%>]</a> -->
			<%-- <input type="button" value="<%=i%>" onclick="location.href='?currentPage=<%=i%>'"/> --%>
			<button type="button" onclick="location.href='?currentPage=<%=i%>'" ><%=i %></button>
<%
		}
	}
%>
			</td>
		</tr>
		
		<tr>
			<td colspan="5">
<%
	for(int i=1; i<=totalPage; i++){
		if(currentPage == i){
			out.println("<button type='button' disabled>" + i + "</button>");
%>
			
<%
		}else{
			out.println("<button type='button' onclick='location.href=\"?currentPage=" + i + "\"'>" + i + "</button>");
%>		
			
<%
		}
	}
%>
			</td>
		</tr>
		
		

	</table>

</body>
</html>





















