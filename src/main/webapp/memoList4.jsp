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
	
	.button {
		background-color: #4CAF50; /* Green */ /* 배경색 */
		border: none;	/* 테두리 => 선두께 선종류 선색상 */
		color: white; /* 글자색 */
		padding: 5px;	/* 안여백 */
		text-align: center;	/* 텍스트 정렬 */
		text-decoration: none; /* 밑줄 */
		display: inline-block; /* 같은 줄에 나타나게 한다. */
		font-size: 16px; /* 텍스트 크기 */
		margin: 4px 2px; /* 바깥여백 */
		transition-duration: 0.4s; /* 애니메이션 재생시간 */
		cursor: pointer; /* 마우스 포인터 모양 */
		width: 70px;
		height: 40px;
	}

	.button1 {
		background-color: white; 
		color: black; 
		border: 2px solid #4CAF50;
	}

	.button1:hover {
		background-color: #4CAF50;
		color: white;
	}
	
	.button2 {
		background-color: #008CBA;
		color: white; 
		border: 2px solid #008CBA;
		cursor: not-allowed;
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
	int pageSize = 10; 
	int totalCount = 0; 
	int totalPage = 0; 
	int currentPage = 1; 
	int startNo = 0;
	int endNo = 0; 
	int startPage = 0; 
	int endPage = 0; 

//=================================================================================
	
//	페이지당 표시할 글의 개수를 받아 pageSize 변수에 저장한다.
//	게시판이 최초로 실행될 때 이전 페이지가 없으므로 넘어오는 pageSize 값이 null이고 보기 버튼
//	이외의 다른 버튼이 클릭되면 pageSize가 넘어오지 않기 때문에 null이 된다. => 예외 처리를 한다.
	try{
		pageSize = Integer.parseInt(request.getParameter("pageSize"));
//		화면에 표시할 글의 개수가 정상적으로 넘어왔으므로 화면에 표시할 글의 개수를 세션에 저장한다.
		session.setAttribute("pageSize", pageSize + "");
	}catch(NumberFormatException e){
//		이전 페이지에서 넘어오는 pageSize가 null이면 세션에 저장해둔 pageSize를 얻어와서 화면에 표시할
//		글의 개수를 지정한다.
//		브라우저가 최초로 실행될 때 세션이 만들어지기 떄문에 브라우저가 최초로 실행되면 이전 페이지에서
//		넘어오는 pageSize도 null이고 세션에 저장된 pageSize도 null 이다.
		String temp = (String)session.getAttribute("pageSize");
		if(temp != null){
			pageSize = Integer.parseInt(temp);
		}
	}

	
//=================================================================================

	Connection conn = DBUtil.getMysqlConnection();
	String sql = "select count(*) from memolist";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	ResultSet rs = pstmt.executeQuery();
	
	rs.next();
	totalCount = rs.getInt(1);

	totalPage = (totalCount-1) / pageSize + 1;

//	2.=================================================================================

	try{
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		currentPage = currentPage > totalPage ? totalPage : currentPage;
	}catch(NumberFormatException e){ }

//	3.=================================================================================

	startNo = (currentPage-1) * pageSize;

	endNo = startNo + pageSize - 1;

	endNo = endNo > totalCount ? totalCount : endNo;

//	4.=================================================================================
	
	sql = "select * from memolist order by idx desc limit ?, ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, startNo);
	pstmt.setInt(2, pageSize);
	rs = pstmt.executeQuery();
%>

	<table width="1300" align="center" border="1" cellpadding="5" cellspacing="0">
		<tr>
			<th width="80">글번호</th>
			<th width="80">이름</th>
			<th width="840">메모</th>
			<th width="120">작성일</th>
			<th width="80">ip</th>
			<th width="100">&nbsp;</th>
		</tr>
		<tr>
			<td colspan="3">
				<form action="?" mehtod="post">
					페이지당 표시할 글의 개수를 선택하세요.
					<select name="pageSize" style="width:50px; height: 25px">
						<option>3</option>
						<option>5</option>
						<option selected="selected">10</option>
						<option>15</option>
						<option>20</option>
					</select>
					<input type="submit" value="보기"/>
				</form>
			</td>
			
			<td colspan="3" align="right">
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
		
			<!-- 수정, 삭제 버튼 추가 -->
			<td align="center">
				<button type="button" 
					onclick="location.href='memoUpdate.jsp?idx=<%=rs.getInt("idx")%>&currentPage=<%=currentPage%>'">수정</button>
				<button type="button" onclick="location.href='memoDelete.jsp?idx=<%=rs.getInt("idx")%>&currentPage=<%=currentPage%>'">삭제</button>
			</td>
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

		<tr>
			<td colspan="5" align="center">
<%
	startPage = (currentPage-1) / 10 * 10 + 1;
	endPage = startPage + 9;
	endPage = endPage > totalPage ? totalPage : endPage;

	if(currentPage > 1){
%>		
	<button class="button button1" type="button" title="첫 페이지로 이동합니다." onclick="location.href='?currentPage=1'">처음</button>
<%	
	}else{
%>
	<button class="button button2" type="button" title="이미 첫 페이지입니다." disabled="disabled">처음</button>
<%		
	}
%>
<%
//	10페이지 앞으로
	if(startPage > 1){
%>
	<button class="button button1" type="button" title="이전 10 페이지로 이동합니다." onclick="location.href='?currentPage=<%=startPage-1%>'">이전</button>
<%
	}else{
%>
	<button class="button button2" type="button" title="이미 첫 10 페이지 입니다." disabled="disabled">이전</button>
<%	
	}

	for(int i=startPage; i<=endPage; i++){
		if(currentPage == i){
%>
			<button class="button button2" type="button" disabled><%=i %></button>
<%
		}else{
%>
			<button class="button button1" type="button" onclick="location.href='?currentPage=<%=i%>'" ><%=i %></button>
<%
		}
	}

	if(endPage < totalPage){
%>
		<button class="button button1" type="button" title="다음 10 페이지로 이동합니다." onclick="location.href='?currentPage=<%=endPage+1%>'">다음</button>
<%	
	}else{
%>
		<button class="button button2" type="button" title="이미 마지막 10 페이지입니다." disabled="disabled">다음</button>
<%	
	}
%>
<%
//	마지막으로
	if(currentPage < totalPage){
%>
		<button class="button button1" type="button" title="마지막 페이지로 이동합니다." onclick="location.href='?currentPage=<%=totalPage%>'">마지막</button>
<%
	}else{
%>
		<button class="button button2" type="button" title="이미 마지막 페이지입니다." disabled="disabled">마지막</button>
<%	
	}
%>	
			</td>
		</tr>
	
	</table>

</body>
</html>





















