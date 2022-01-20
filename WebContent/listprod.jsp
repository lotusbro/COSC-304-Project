<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Fantasian Fits Shop</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<h1 align="center">Search for the products you want to buy</h1>

<form method="get" action="listprod.jsp">
	<p align="center">
	<select size="1" name="categoryName">
	<option>All</option>
	<option>Weapons</option>
	<option>Armour</option>
	<option>Consumables</option>      
	</select>


<input type="text" name="productName" size="50" >
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>
<hr>

<% // Get product name to search for
String name = request.getParameter("productName");
String category = request.getParameter("categoryName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection

// Print out the ResultSet

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00


String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

try
(
	Connection con = DriverManager.getConnection(url, uid, pw);
)
{

	String sql = "SELECT productId, productName, productPrice, categoryName " 
	+"FROM product JOIN category ON product.categoryId = category.categoryId";

	boolean hasName = name != null && !name.equals("");
	boolean hasCategory = category != null && !category.equals("") && !category.equals("All");

	
	PreparedStatement pstmt = null;
	ResultSet rst = null;

	if(!hasName) {

		if (hasCategory) {
			out.println("<h2 align=\"center\">All Products in the Category " + category + "</h2>");
			category = "'" + category + "'";
			sql += " WHERE category.categoryName = " + category ;
		}
		else {
			out.println("<h2 align=\"center\">All Products</h2>");
		}
	
	}
	else {

		String name1 = name;

		name = "'%" + name + "%'";
		sql += " WHERE productName LIKE " + name;

		if (hasCategory) {
			out.println("<h2 align=\"center\">All Products Containing '"+name1+"' in the Category '" + category + "'</h2>");
			category = "'" + category + "'";
			sql += " AND category.categoryName = " + category ;
		}
		else {
			out.println("<h2 align=\"center\">All Products Containing '"+name1+"'</h2>");
		}

	
		
	}

	//out.println(sql);

	pstmt = con.prepareStatement(sql);
	rst = pstmt.executeQuery();

	
	out.println("<table class=\"table\" border=\"1\"><tr><th></th><th>Product Name</th><th>Category</th><th>Price</th>"
		+"</tr>");
	
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	while(rst.next()) {
		Integer pid = rst.getInt(1);
		String pname = rst.getString(2);
		Double pprice = rst.getDouble(3);

		if(pname.contains("'")){
			pname = pname.replace("'", "&#39;");
		}

		String linkString = "addcart.jsp?id="+pid+"&name="+pname+"&price="+pprice;
		String prodLinkString = "product.jsp?id="+pid;



		out.println("<tr><th><a href='"
			+ linkString
			+ "'>Add to Cart</a></th><th align=\"left\"><a href='" 
			+ prodLinkString 
			+ "'>" 
			+ rst.getString(2) 
			+ "</a></th>"
			+"<td>" 
			+  rst.getString(4)
			+ "</td>"
			+"<td>" 
			+ "$" +currFormat.format(rst.getDouble(3)).replaceAll("[^0123456789.,]","") 
			+ "</td>"
			+ "</tr>");

		//out.println("<tr><th><a href='" + linkString + "'>Add to Cart</a></th><td>" + rst.getString(2) + "</td>"
		//	+"<td>" + "$" +currFormat.format(rst.getDouble(3)).replaceAll("[^0123456789.,]","") + "</td>"
		//	+ "</tr>");
	}

	out.println("</table>");

	pstmt.close();
} 
catch (Exception ex) 
{ 
	out.println(ex); 
}

%>

</body>
</html>