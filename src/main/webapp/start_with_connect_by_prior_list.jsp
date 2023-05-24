<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*"%>
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
	
	String sql = "select level, lpad(' ', level-1) || first_name 이름, manager_id 매니저, sys_connect_by_path(first_name, '-') 계층 from employees start with manager_id is null connect by prior employee_id = manager_id";
	//sys_connect_by_path: 루트부터 노드까지 열 값의 경로를 반환
	//is null connect by prior
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String, Object> a = new HashMap<>();
		a.put("level", rs.getInt("level"));
		a.put("이름", rs.getString("이름"));
		a.put("매니저", rs.getString("매니저"));
		a.put("계층", rs.getString("계층"));
		list.add(a);
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>start_with_connect_by_prior_list</title>
</head>
<body>
	<table border="1">
		<tr class="center">
			<td colspan="4"><h3>start_with_connect_by_prior_list</h3></td>
		</tr>
		<tr>
			<th>level</th>
			<th>이름</th>
			<th>매니저</th>
			<th>계층구조</th>
		</tr>
		<%
			for(HashMap<String, Object> a : list){
		%>
				<tr>
					<td><%=(Integer)(a.get("level"))%></td>
					<td><%=(String)(a.get("이름"))%></td>
					<td><%=(String)(a.get("매니저"))%></td>
					<td><%=(String)(a.get("계층"))%></td>
				</tr>
		<%
			}
		%>
	</table>
</body>
</html>