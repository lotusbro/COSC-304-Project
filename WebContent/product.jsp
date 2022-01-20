<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Fantasian Fits - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
// String productId = request.getParameter("id");

String productId = request.getParameter("id");




String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

try
(
	Connection con = DriverManager.getConnection(url, uid, pw);
)
{

	String sql = "SELECT productName, productPrice, productId, productImageURL, productImage, productDesc, categoryName  " 
	+"FROM product JOIN category ON product.categoryId = category.categoryId ";

	boolean hasId = productId != null && !productId.equals("");

	
	PreparedStatement pstmt = null;
	ResultSet rst = null;

	if(!hasId) {
		pstmt = con.prepareStatement(sql);
		rst = pstmt.executeQuery();
		out.println("<h2>All Products</h2>");
	
	}
	else {
		//out.println("<h1>name</h1>");
		//name = "'%" + name + "%'";
		sql += " WHERE productId = " + productId;

		pstmt = con.prepareStatement(sql);
		rst = pstmt.executeQuery();
		
	}

	

	
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	if (!rst.next())
	{
		out.println("Invalid product");
	}
	else {
		Integer pid = rst.getInt(3);
		String pname = rst.getString(1);
		Double pprice = rst.getDouble(2);
	
	
		String linkString = "addcart.jsp?id="+pid+"&name="+pname+"&price="+pprice;
	
		out.println("<h2>"+rst.getString(1)+"</h2>");
	
		out.println("<table class=\"table\" border=\"1\"><tr><th>Category Type: </th><td>" +
			rst.getString(7) +
			"</td></tr><tr><th>Id: </th><td>"+
			productId
			+"</td></tr><tr><th>Price:</th><td>"+
			"$" +currFormat.format(rst.getDouble(2)).replaceAll("[^0123456789.,]","")
			+"</td></tr><tr><th>Description: </th><td>"+ rst.getString(6) +
				"</td></tr>");
	
	
	
		//  Retrieve any image with a URL
		String imageLoc = rst.getString(4);
		if (imageLoc != null)
			out.println("<img src=\""+imageLoc+"\">");	
	
		// Retrieve any image stored directly in database
		String imageBinary = rst.getString(5);
		if (imageBinary != null)
			out.println("<img src=\"displayImage.jsp?id="+pid+"\">");
		out.println("</table>");
	
		out.println("<h3><a href='" + linkString + "'>Add to Cart</a></h3>");
		out.println("<h3><a href=\"listprod.jsp\">Continue Shopping</a></h3>");

	}



	pstmt.close();
} 
catch (Exception ex) 
{ 
	out.println(ex); 
}





// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping


%>

</body>
</html>

