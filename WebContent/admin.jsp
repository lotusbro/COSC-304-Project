<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%@ include file="../auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// Print out total order amount by day
String sql = "select year(orderDate), month(orderDate), day(orderDate), SUM(totalAmount) FROM OrderSummary GROUP BY year(orderDate), month(orderDate), day(orderDate)";

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try 
{	
	out.println("<h3>Administrator Sales Report by Day</h3>");
	
	getConnection();
	ResultSet rst = con.createStatement().executeQuery(sql);		
	out.println("<table class=\"table\" border=\"1\">");
	out.println("<tr><th>Order Date</th><th>Total Order Amount</th>");	

	while (rst.next())
	{
		out.println("<tr><td>"+rst.getString(1)+"-"+rst.getString(2)+"-"+rst.getString(3)+"</td><td>"+"$"+currFormat.format(rst.getDouble(3)).replaceAll("[^0123456789.,]","")+"</td></tr>");
	}
	out.println("</table>");		
}
catch (SQLException ex) 
{ 	out.println(ex); 
}
finally
{	
	closeConnection();	
}
%>

<form method="get" action="allCustomer.jsp">
	<input type="submit" name="customers" value="List all Customers">
</form>
<form method="get" action="listorder.jsp">
	<input type="submit" name="orders" value="List all Oders">
</form>

<h4><p style="font-size:20px">Create a New Product</p></h4>

<form method="post" action="createProduct.jsp">
	<input type="text" name="pname" placeholder="Product Name">
	<input type="text" name="price" placeholder="Product Price">
	<input type="number" name="category" placeholder="Product Category">
	<input type="text" name="desc" placeholder="Product Description">
	<input type="submit" name="product" value="Add Product">
</form>

<h5><p style="font-size:20px">Update a Product</p></h5>
<form method="post" action="updateProduct.jsp">
	<input type="text" name="pname" placeholder="Product Name">
	<input type="text" name="price" placeholder="Product Price">
	<input type="number" name="category" placeholder="Product Category">
	<input type="text" name="desc" placeholder="Product Description">
	<input type="submit" name="update" value="Update">
</form>

<h6><p style="font-size:20px">Delete a Product</p></h6>
<form method="post" action="deleteProduct.jsp">
	<input type="text" name="pname" placeholder="Product Name">
	<input type="submit" name="delete" value="Delete">
</form>

</body>
</html>