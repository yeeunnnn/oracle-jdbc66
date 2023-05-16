<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dbuser = "hr";
	String dbpw = "java1234";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	String sql = null;
	/*
		select --5
		department_id 부서ID,
		count(*) 부서인원,
		sum(salary) 급여합계,
		round(avg(salary)) 급여평균,
		max(salary) 최대급여,
		min(salary) 최소급여
		from employees --1
		where department_id is not null --2
		-- where절은 group by 절보다 실행순서가 우선
		--> group by 집계(함수)결과에 대한 조건을 필터링할 수 없다.
		-- 그래서 group by 집계(함수) 결과를 필터링하는 조건절이 또 필요하다 --> having
		group by department_id --3
		having count(*) > 1 --4
		order by count(*) desc; --6
	*/
	sql = "select department_id 부서ID, count(*) 부서인원, sum(salary) 급여합계, round(avg(salary)) 급여평균, max(salary) 최대급여, min(salary) 최소급여 from employees where department_id is not null group by department_id having count(*) > 1 order by count(*) desc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<>(); //두번째 제네릭은 생략가능
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("부서ID", rs.getInt("부서ID"));
		m.put("부서인원", rs.getInt("부서인원"));
		m.put("급여합계", rs.getInt("급여합계"));
		m.put("급여평균", rs.getInt("급여평균"));
		m.put("최대급여", rs.getInt("최대급여"));
		m.put("최소급여", rs.getInt("최소급여"));
		list.add(m);
	}
	
	System.out.println(list);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employees table GROUP BY Test</title>
</head>
<body>
	<table border="1">
		<tr>
			<td>부서ID</td>
			<td>부서인원</td>
			<td>급여합계</td>
			<td>급여평균</td>
			<td>최대급여</td>
			<td>최소급여</td>
		</tr>
		
			<%
				for(HashMap<String, Object> m : list){
			%>
				<tr>
					<td><%=(Integer)(m.get("부서ID"))%></td>
					<td><%=(Integer)(m.get("부서인원"))%></td>
					<td><%=(Integer)(m.get("급여합계"))%></td>
					<td><%=(Integer)(m.get("급여평균"))%></td>
					<td><%=(Integer)(m.get("최대급여"))%></td>
					<td><%=(Integer)(m.get("최소급여"))%></td>
				</tr>
			<%		
				}
			%>
		
	</table>
</body>
</html>