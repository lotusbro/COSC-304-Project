<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// Print Customer information
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

String sql2 = "select customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password FROM Customer";

try 
{	
	out.println("<h3>Listing All Customers</h3>");
	
	getConnection();
	PreparedStatement pstmt = con.prepareStatement(sql2);
	ResultSet rst = pstmt.executeQuery();
	
	while (rst.next())
	{
		out.println("<table class=\"table\" border=\"1\">");
		out.println("<tr><th>Id:</th><td>"+rst.getString(1)+"</td>");	
		out.println("<td>"+rst.getString(2)+"</td>");
		out.println("<td>"+rst.getString(3)+"</td>");
		out.println("<td>"+rst.getString(4)+"</td>");
		out.println("<td>"+rst.getString(5)+"</td>");
		out.println("<td>"+rst.getString(6)+"</td>");
		out.println("<td>"+rst.getString(7)+"</td>");
		out.println("<td>"+rst.getString(8)+"</td>");
		out.println("<td>"+rst.getString(9)+"</td>");
		out.println("<td>"+rst.getString(10)+"</td>");
		out.println("<th>User id:</th><td>"+rst.getString(11)+"</td></tr>");		
		out.println("</table>");
	}
}
catch (SQLException ex) 
{ 	out.println(ex); 
}
finally
{	
	closeConnection();	
}
%>
<h2><a href="admin.jsp">Back to Admin Portal</a></h2>

</body>
</html>

