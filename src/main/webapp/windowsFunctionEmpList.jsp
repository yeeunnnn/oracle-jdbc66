<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dbuser = "hr";
	String dbpw = "java1234";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	//드라이버 로딩
	Class.forName(driver);
	System.out.println(driver);
	//DB 접속
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	/* 불러올 글
		-- 분석함수 이용해 단일값 세개 추가
		select employee_id, last_name,salary,
		    round(avg(salary) over()) 전체급여평균,
		    sum(salary) over() 전체급여합계,
		    count(*) over() 전체사원수
		from employees;
	*/
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10; // 글이 10개씩 보여지도록
	int beginRow = (currentPage - 1) * rowPerPage + 1;
	int endRow = beginRow + (rowPerPage - 1);
	// 끝 글이 10이 아닐때 남은 값을 출력하도록 lastPage 설정
	String totalRowSql = "select count(*) from employees";
	PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
	ResultSet totalRowRs = totalRowStmt.executeQuery();
	
	int totalRow = 0;
	if(totalRowRs.next()){
		totalRow = totalRowRs.getInt("count(*)");
	}
	
	if(endRow > totalRow){
		endRow = totalRow;
	}
	
	String windowsSql = "select 번호, 사원ID, 이름, 연봉, 전체급여평균, 전체급여합계, 전체사원수 from (select rownum 번호, employee_id 사원ID, last_name 이름, salary 연봉, round(avg(salary) over()) 전체급여평균, sum(salary) over() 전체급여합계, count(*) over() 전체사원수 from employees) where 번호 between ? and ? ";
	PreparedStatement windowsStmt = conn.prepareStatement(windowsSql);
	windowsStmt.setInt(1, beginRow);
	windowsStmt.setInt(2, endRow);
	ResultSet windowsRs = windowsStmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(windowsRs.next()){
		HashMap<String, Object> l = new HashMap<String, Object>();
		l.put("번호", windowsRs.getInt("번호"));
		l.put("사원ID", windowsRs.getInt("사원ID"));
		l.put("이름", windowsRs.getString("이름"));
		l.put("연봉", windowsRs.getInt("연봉"));
		l.put("전체급여평균", windowsRs.getInt("전체급여평균"));
		l.put("전체급여합계", windowsRs.getInt("전체급여합계"));
		l.put("전체사원수", windowsRs.getInt("전체사원수"));
		list.add(l);
	}
	System.out.println(list.size()+"<-- list.size");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>windowsFunctionEmpList.jsp</title>
</head>
<body>
	<h1>windowsFunction</h1>
	<table border="1">
		<tr>
			<th>번호</th>
			<th>사원ID</th>
			<th>이름</th>
			<th>연봉</th>
			<th>전체급여평균</th>
			<th>전체급여합계</th>
			<th>전체사원수</th>
		</tr>
		<%
			for(HashMap<String, Object> l : list){
		%>
				<tr>
					<td><%=(Integer)(l.get("번호"))%></td>
					<td><%=(Integer)(l.get("사원ID"))%></td>
					<td><%=(String)(l.get("이름"))%></td>
					<td><%=(Integer)(l.get("연봉"))%></td>
					<td><%=(Integer)(l.get("전체급여평균"))%></td>
					<td><%=(Integer)(l.get("전체급여합계"))%></td>
					<td><%=(Integer)(l.get("전체사원수"))%></td>
				</tr>
		<%
			}
		%>
		</table>
		<%
			// 하단 ['이전' 1 2 3 4 5 6 7 8 9 10 '다음'] 네비게이션 페이징
			int pagePerPage = 10; // 1~10, 21~30, ... 한 줄에 나오는 행의 수
			// ex. 실제는 23p인데 30p가 나오지 않도록 조건을 설정
			int lastPage = totalRow / pagePerPage;
			if(totalRow%rowPerPage != 0){
				lastPage = lastPage + 1;
			}
			int minPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1; // 하단 페이징 제일 작은 값
			int maxPage = minPage + (pagePerPage - 1); // 하단 페이징 제일 큰 값
			
			if(maxPage > lastPage){
				maxPage = lastPage;
			}
			
			if(minPage > 1){
		%>
			<a href="<%=request.getContextPath()%>/windowsFunctionEmpList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>
		<%
			} for(int i=minPage; i<=maxPage; i=i+1){
				if(i == currentPage){
		%>
				<span><%=i%></span>&nbsp; <!-- 클릭한 숫자가 현재페이지와 같을 때 태그가 없도록 -->
		<%			
				} else {
		%>
				<a href="<%=request.getContextPath()%>/windowsFunctionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;
		<%			
				}
			}
			if(maxPage != lastPage){
		%>
			<a href ="<%=request.getContextPath()%>/windowsFunctionEmpList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
		<%		
			}
		%>	

</body>
</html>