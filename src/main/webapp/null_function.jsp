<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	//oracledb
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dbuser = "gdj66";
	String dbpw = "java1234";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	
	//드라이버 로딩
	Class.forName(driver);
	System.out.println(driver);
	//DB 접속
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	// 1. nvl(값1, 값2) : 값1이 null이 아니면 값1을 반환, 값1이 null이면 값2를 반환
	String nvlSql = "select 이름, nvl(일분기, 0) 일분기 from 실적"; 
	PreparedStatement nvlStmt = conn.prepareStatement(nvlSql);
	ResultSet nvlRs = nvlStmt.executeQuery();
	ArrayList<HashMap<String, Object>> nvlList = new ArrayList<>();
	while(nvlRs.next()){
		HashMap<String, Object> n = new HashMap<String, Object>();
		n.put("이름", nvlRs.getString("이름"));
		n.put("일분기", nvlRs.getInt("일분기")); //별칭 적고 가져오기
		nvlList.add(n);
	}
	System.out.println(nvlList.size());
	
	// 2. nvl2(값1, 값2, 값3) : 값1이 null아니면 값2 반환, 값1이 null이면 값3을 반환
	String nvl2Sql = "select 이름, nvl2(일분기, 'success', 'fail') 일분기 from 실적";
	PreparedStatement nvl2Stmt = conn.prepareStatement(nvl2Sql);
	ResultSet nvl2Rs = nvl2Stmt.executeQuery();
	ArrayList<HashMap<String, Object>> nvl2List = new ArrayList<>();
	while(nvl2Rs.next()){
		HashMap<String, Object> o = new HashMap<String, Object>();
		o.put("이름", nvl2Rs.getString("이름"));
		o.put("일분기", nvl2Rs.getString("일분기"));
		nvl2List.add(o);
	}
	System.out.println(nvl2List.size());
	
	// 3. nullif(값1, 값2) : 값1과 값2가 같으면 null을 반환 (null이 아닌값이 null로 치환에 사용)
	String nullIfSql = "select 이름, nullif(사분기, 100) 사분기 from 실적";
	PreparedStatement nullIfStmt = conn.prepareStatement(nullIfSql);
	ResultSet nullIfRs = nullIfStmt.executeQuery();
	ArrayList<HashMap<String, Object>> nullIfList = new ArrayList<>();
	while(nullIfRs.next()){
		HashMap<String, Object> i = new HashMap<String, Object>();
		i.put("이름", nullIfRs.getString("이름"));
		i.put("사분기", nullIfRs.getString("사분기"));
		nullIfList.add(i);
	}
	System.out.println(nullIfList.size());
	
	// 4. coalesce(값1, 값2, 값3, .....) : 입력값 중 null아닌 첫번째값을 반환(다 null이면 null)
	String coalesceSql = "select 이름, coalesce(일분기, 이분기, 삼분기, 사분기) 전체 from 실적";
	PreparedStatement coalesceStmt = conn.prepareStatement(coalesceSql);
	ResultSet coalesceRs = coalesceStmt.executeQuery();
	ArrayList<HashMap<String, Object>> coalesceList = new ArrayList<>();
	while(coalesceRs.next()){
		HashMap<String, Object> s = new HashMap<String, Object>();
		s.put("이름", coalesceRs.getString("이름"));
		s.put("전체", coalesceRs.getString("전체"));
		coalesceList.add(s);
	}
	System.out.println(coalesceList.size());
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>null_function</title>
</head>
<body>
	<h1>nvl</h1>
	<table border="1">
		<tr>
			<td>이름</td>
			<td>일분기</td>
		</tr>
		<!-- 입력값이 null일 때 대체 값(숫자 0)을 설정 -->
		<%
			for(HashMap<String, Object> n : nvlList){
		%>
				<tr>
					<td><%=(String)n.get("이름")%></td>
					<td><%=(Integer)n.get("일분기")%></td>
				</tr>
		<%
			}
		%>
	</table>
	<h1>nvl2</h1>
	<table border="1">
		<tr>
			<td>이름</td>
			<td>일분기</td>
		</tr>
		<!-- nvl2 함수는 success, fail 문자를 반환하므로 String 명시적 형변환-->
		<%
			for(HashMap<String, Object> o : nvl2List){
		%>
				<tr>
					<td><%=(String)o.get("이름")%></td>
					<td><%=(String)o.get("일분기")%></td>
				</tr>
		<%
			}
		%>
	</table>
	<h1>nullIf</h1>
	<table border="1">
		<tr>
			<td>이름</td>
			<td>사분기</td>
		</tr>
		<!-- nullif 함수는 null(문자)를 반환하므로 String으로 명시적 형변환 -->
		<%
			for(HashMap<String, Object> i : nullIfList){
		%>
				<tr>
					<td><%=(String)i.get("이름")%></td>
					<td><%=(String)i.get("사분기")%></td>
				</tr>
		<%
			}
		%>
	</table>
	<h1>coalesce</h1>
	<table border="1">
		<tr>
			<td>이름</td>
			<td>일분기</td>
		</tr>
		<!-- coalesce 함수는 입력값이 다 null일 때 null을 반환하므로, String 명시적 형변환 -->
		<%
			for(HashMap<String, Object> s : coalesceList){
		%>
				<tr>
					<td><%=(String)s.get("이름")%></td>
					<td><%=(String)s.get("전체")%></td>
				</tr>
		<%
			}
		%>
	</table>
</body>
</html>