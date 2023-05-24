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
	
	// inner join과 결과가 같은 exists. oracle에서 join이 발생한다.
	// 1. exists
	String existsSql = "select e.employee_id 직원ID, e.first_name 직원이름 from employees e where exists (select * from departments d where d.department_id = e.department_id)";
	PreparedStatement existsStmt = conn.prepareStatement(existsSql);
	ResultSet existsRs = existsStmt.executeQuery();
	ArrayList<HashMap<String, Object>> list1 = new ArrayList<>();
	while(existsRs.next()){
		HashMap<String, Object> a = new HashMap<>();
		a.put("직원ID", existsRs.getInt("직원ID"));
		a.put("직원이름", existsRs.getString("직원이름"));
		list1.add(a);
	}
	// 2. not exists
	// 행을 필터링 해서 참, 거짓을 분별하는 where절
	String notExistsSql = "select e.employee_id 직원ID, e.first_name 직원이름 from employees e where not exists (select * from departments d where d.department_id = e.department_id)";
	PreparedStatement notExistsStmt = conn.prepareStatement(notExistsSql);
	ResultSet notExistsRs = notExistsStmt.executeQuery();
	ArrayList<HashMap<String, Object>> list2 = new ArrayList<>();
	while(notExistsRs.next()){
		HashMap<String, Object> b = new HashMap<>();
		b.put("직원ID", notExistsRs.getInt("직원ID"));
		b.put("직원이름", notExistsRs.getString("직원이름"));
		list2.add(b);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>exists_not_exists_list</title>
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
	<div class="col-sm-6">
		<table border="1">
				<tr class="center">
					<td colspan="3"><h3>1. rank</h3></td>
				</tr>
				<tr>
					<th>직원ID</th>
					<th>직원이름</th>
				</tr>
				<%
					for(HashMap<String, Object> a : list1){
				%>
						<tr>
							<td><%=(Integer)(a.get("직원ID"))%></td>
							<td><%=(String)(a.get("직원이름"))%></td>
						</tr>
				<%
					}
				%>
			</table>
	</div>
	<div class="col-sm-6">		
			<table border="1">
				<tr class="center">
					<td colspan="3"><h3>2. dense-rank</h3></td>
				</tr>
				<tr>
					<th>직원ID</th>
					<th>직원이름</th>
				</tr>
				<%
					for(HashMap<String, Object> b : list2){
				%>
						<tr>
							<td><%=(Integer)(b.get("직원ID"))%></td>
							<td><%=(String)(b.get("직원이름"))%></td>
						</tr>
				<%
					}
				%>
			</table>
	</div>
</div>	
</body>
</html>