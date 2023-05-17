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
	
	/* 
	  1. group by(group by절에 넣은 컬럼을 그룹화)
	  2. rollup(group by 결과에 + 전체집계 + 첫번째 컬럼집계)
	  3. cube(group by 결과에 + 전체집계 + 매개값으로 사용된 모든 컬럼집계)
	*/
	
	// 1. group by 쿼리
	
		/*
			select department_id, job_id, count(*)
			from employees
			group by department_id, job_id;
		*/
	
	String groupBySql = "select department_id, job_id, count(*) from employees group by department_id, job_id";
	PreparedStatement groupByStmt = conn.prepareStatement(groupBySql);
	System.out.println(groupByStmt);
	ResultSet groupByRs = groupByStmt.executeQuery();
	ArrayList<HashMap<String, Object>> groupByList = new ArrayList<>(); //두번째 제네릭은 생략가능
	while(groupByRs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("부서ID", groupByRs.getString("department_id"));
		m.put("부서인원", groupByRs.getString("job_id"));
		m.put("개수총합", groupByRs.getInt("count(*)"));
		groupByList.add(m);
	}
	System.out.println(groupByList);
	
	// 2. rollup 쿼리
	
		/*
			select department_id, job_id, count(*)
			from employees
			group by rollup(department_id, job_id);
		*/
		
	String rollUpSql = "select department_id, job_id, count(*) from employees group by rollup(department_id, job_id)";
	PreparedStatement rollUpStmt = conn.prepareStatement(rollUpSql);
	System.out.println(rollUpStmt);
	ResultSet rollUpRs = rollUpStmt.executeQuery();
	ArrayList<HashMap<String, Object>> rollUpList = new ArrayList<>(); //두번째 제네릭은 생략가능
	while(rollUpRs.next()){
		HashMap<String, Object> l = new HashMap<String, Object>();
		l.put("부서ID", rollUpRs.getString("department_id"));
		l.put("부서인원", rollUpRs.getString("job_id"));
		l.put("개수총합", rollUpRs.getInt("count(*)"));
		rollUpList.add(l);
	}
	System.out.println(rollUpList);
	
	// 3. cube 쿼리
	
		/*
			select department_id, job_id, count(*)
			from employees
			group by cube(department_id, job_id);
		*/
		
	String cubeSql = "select department_id, job_id, count(*) from employees group by cube(department_id, job_id)";
	PreparedStatement cubeStmt = conn.prepareStatement(cubeSql);
	System.out.println(cubeStmt);
	ResultSet cubeRs = cubeStmt.executeQuery();
	ArrayList<HashMap<String, Object>> cubeList = new ArrayList<>(); //두번째 제네릭은 생략가능
	while(cubeRs.next()){
		HashMap<String, Object> s = new HashMap<String, Object>();
		s.put("부서ID", cubeRs.getString("department_id"));
		s.put("부서인원", cubeRs.getString("job_id"));
		s.put("개수총합", cubeRs.getInt("count(*)"));
		cubeList.add(s);
	}
	System.out.println(cubeList);
	
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>group_by_function</title>
</head>
<body>
	<h1>  GROUP BY </h1>
	<table border="1">
		<tr>
			<td>부서ID</td>
			<td>부서인원</td>
			<td>개수총합</td>
		</tr>
		
			<%
				for(HashMap<String, Object> m : groupByList){
			%>
				<tr>
					<td><%=(String)(m.get("부서ID"))%></td>
					<td><%=(String)(m.get("부서인원"))%></td>
					<td><%=(Integer)(m.get("개수총합"))%></td>
				</tr>
			<%		
				}
			%>
		
	</table>
	<h1>  GROUP BY 확장 - ROLLUP </h1>
	<table border="1">
		<tr>
			<td>부서ID</td>
			<td>부서인원</td>
			<td>개수총합</td>
		</tr>
		
			<%
				for(HashMap<String, Object> l : rollUpList){
			%>
				<tr>
					<td><%=(String)(l.get("부서ID"))%></td>
					<td><%=(String)(l.get("부서인원"))%></td>
					<td><%=(Integer)(l.get("개수총합"))%></td>
				</tr>
			<%		
				}
			%>
		
	</table>
	<h1>  GROUP BY 확장 - CUBE </h1>
	<table border="1">
		<tr>
			<td>부서ID</td>
			<td>부서인원</td>
			<td>개수총합</td>
		</tr>
		
			<%
				for(HashMap<String, Object> s : cubeList){
			%>
				<tr>
					<td><%=(String)(s.get("부서ID"))%></td>
					<td><%=(String)(s.get("부서인원"))%></td>
					<td><%=(Integer)(s.get("개수총합"))%></td>
				</tr>
			<%		
				}
			%>
	</table>
	
</body>
</html>