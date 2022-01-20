<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Fantasian Fits Order List</title>
</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection

// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

try
(
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt =con.createStatement();
)
{
	String sql = "SELECT orderId, orderDate, A.customerId, firstName, lastName," 
	+" totalAmount FROM ordersummary as A JOIN customer as B ON A.customerId "
	+"= B.customerId";

	String sql2 = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?";

	PreparedStatement pstmt = con.prepareStatement(sql2);

	ResultSet rst = stmt.executeQuery(sql);
	out.println("<table border=\"1\"><tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th>"
		+"<th>Customer Name</th><th>Total Amount</th></tr>");
	
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	while(rst.next()) {
		String orderId = rst.getString(1);

		out.println("<tr><td>" + orderId + "</td>" 
			+"<td>" + rst.getString(2) + "</td>" 
			+"<td>" + rst.getString(3) + "</td>"
			+"<td>" + rst.getString(4) + " " + rst.getString(5) + "</td>"
			+"<td>" + "$" +currFormat.format(rst.getDouble(6)).replaceAll("[^0123456789.,]","") + "</td>"
			+ "</tr>");

		out.println("<tr align=\"right\"><td colspan=\"5\"><table border=\"1\">" 
			+"<th>Product Id</th> <th>Quantity</th> <th>Price</th>");

		pstmt.setString(1, orderId);
		ResultSet products = pstmt.executeQuery();

		while(products.next()){
			
			out.println("<tr><td>" + products.getString(1) + "</td>" 
				+"<td>" + products.getString(2) + "</td>" 
				+"<td>" + "$" + currFormat.format(products.getDouble(3)).replaceAll("[^0123456789.,]","") 
					+ "</td>"
				+ "</tr>");
		}

		out.println("</table></td></tr>");


	}
	out.println("</table>");
} 
catch (Exception ex) 
{ 
	out.println(ex); 
}

%>

</body>
</html>

