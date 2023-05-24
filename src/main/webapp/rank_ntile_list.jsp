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
	
	// 1. rank
	String sql1 = "select first_name 이름, salary 연봉, rank() over(order by salary) 연봉순위 from employees";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	ResultSet rs1 = stmt1.executeQuery();
	
	ArrayList<HashMap<String, Object>> list1 = new ArrayList<>();
	while(rs1.next()){
		HashMap<String, Object> a = new HashMap<String, Object>();
		a.put("이름", rs1.getString("이름"));
		a.put("연봉", rs1.getInt("연봉"));
		a.put("연봉순위", rs1.getInt("연봉순위"));
		list1.add(a);
	}
	System.out.println(list1.size()+"<-- list.size");
	
	// 2. dense rank
	String sql2 = "select first_name 이름, salary 연봉, dense_rank() over(order by salary) 연봉순위 from employees";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	ResultSet rs2 = stmt2.executeQuery();
	
	ArrayList<HashMap<String, Object>> list2 = new ArrayList<>();
	while(rs2.next()){
		HashMap<String, Object> b = new HashMap<String, Object>();
		b.put("이름", rs2.getString("이름"));
		b.put("연봉", rs2.getInt("연봉"));
		b.put("연봉순위", rs2.getInt("연봉순위"));
		list2.add(b);
	}
	System.out.println(list2.size()+"<-- list.size");
	
	// 3. row number()
	String sql3 = "select first_name 이름, salary 연봉, row_number() over(order by salary) 연봉순위 from employees";
	PreparedStatement stmt3 = conn.prepareStatement(sql3);
	ResultSet rs3 = stmt3.executeQuery();
	
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<>();
	while(rs3.next()){
		HashMap<String, Object> c = new HashMap<String, Object>();
		c.put("이름", rs3.getString("이름"));
		c.put("연봉", rs3.getInt("연봉"));
		c.put("연봉순위", rs3.getInt("연봉순위"));
		list3.add(c);
	}
	System.out.println(list3.size()+"<-- list.size");
	
	// 4. ntile_list
	String sql4 = "select first_name 이름, salary 연봉, ntile(10) over(order by salary desc) 연봉순위 from employees";
	PreparedStatement stmt4 = conn.prepareStatement(sql4);
	ResultSet rs4 = stmt4.executeQuery();
	
	ArrayList<HashMap<String, Object>> list4 = new ArrayList<>();
	while(rs4.next()){
		HashMap<String, Object> d = new HashMap<String, Object>();
		d.put("이름", rs4.getString("이름"));
		d.put("연봉", rs4.getInt("연봉"));
		d.put("연봉순위", rs4.getInt("연봉순위"));
		list4.add(d);
	}
	System.out.println(list4.size()+"<-- list.size");

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>rank_ntile_list</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		table, td {text-align:center; table-layout: fixed;}
		.center {text-align:center;}
	</style>
</head>
<body>
<div class="row">
	<div class="col-sm-3">
		<table border="1">
				<tr class="center">
					<td colspan="3"><h3>1. rank</h3></td>
				</tr>
				<tr>
					<th>이름</th>
					<th>연봉</th>
					<th>연봉순위</th>
				</tr>
				<%
					for(HashMap<String, Object> a : list1){
				%>
						<tr>
							<td><%=(String)(a.get("이름"))%></td>
							<td><%=(Integer)(a.get("연봉"))%></td>
							<td><%=(Integer)(a.get("연봉순위"))%></td>
						</tr>
				<%
					}
				%>
			</table>
	</div>
	<div class="col-sm-3">		
			<table border="1">
				<tr class="center">
					<td colspan="3"><h3>2. dense-rank</h3></td>
				</tr>
				<tr>
					<th>이름</th>
					<th>연봉</th>
					<th>연봉순위</th>
				</tr>
				<%
					for(HashMap<String, Object> b : list2){
				%>
						<tr>
							<td><%=(String)(b.get("이름"))%></td>
							<td><%=(Integer)(b.get("연봉"))%></td>
							<td><%=(Integer)(b.get("연봉순위"))%></td>
						</tr>
				<%
					}
				%>
			</table>
	</div>
	<div class="col-sm-3">		
			<table border="1">
				<tr class="center">
					<td colspan="3"><h3>3. rownum rank</h3></td>
				</tr>
				<tr>
					<th>이름</th>
					<th>연봉</th>
					<th>연봉순위</th>
				</tr>
				<%
					for(HashMap<String, Object> c : list3){
				%>
						<tr>
							<td><%=(String)(c.get("이름"))%></td>
							<td><%=(Integer)(c.get("연봉"))%></td>
							<td><%=(Integer)(c.get("연봉순위"))%></td>
						</tr>
				<%
					}
				%>
			</table>
	</div>
	<div class="col-sm-3">		
			<table border="1">
				<tr class="center">
					<td colspan="3"><h3>4. dense-rank</h3></td>
				</tr>
				<tr>
					<th>이름</th>
					<th>연봉</th>
					<th>연봉순위</th>
				</tr>
				<%
					for(HashMap<String, Object> d : list4){
				%>
						<tr>
							<td><%=(String)(d.get("이름"))%></td>
							<td><%=(Integer)(d.get("연봉"))%></td>
							<td><%=(Integer)(d.get("연봉순위"))%></td>
						</tr>
				<%
					}
				%>
			</table>
	</div>
</div>
</body>
</html>