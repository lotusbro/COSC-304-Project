<!DOCTYPE html>
<html>
<head>
</head>
<body>


<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%
String prodName = request.getParameter("pname");

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

try
(
	Connection con = DriverManager.getConnection(url, uid, pw);
)
{
	String sql = "DELETE FROM product WHERE productName = '"+prodName+"'";
	PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.execute();

} 
catch (Exception ex) 
{ 
	out.println(ex); 
}
%>
<h1>Product has been deleted.</h1>
<h2><a href="admin.jsp">Back to Admin Portal</a></h2>
<h2><a href="listprod.jsp">Browse All Products</a></h2>