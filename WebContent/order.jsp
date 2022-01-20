<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Fantasian Fits Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message

// Make connection
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

try (Connection con = DriverManager.getConnection(url, uid, pw);
    PreparedStatement pstmt = con.prepareStatement("Select customerId From customer Where customerId = "+custId))
{
    ResultSet rst = pstmt.executeQuery();
	if(!rst.next()){
		out.println("<table><tr><th>Invalid customer id. Go back to the previous page and try again.</th></tr></table>");
	}else if(productList.isEmpty()){
		out.println("<table><tr><th>No products in cart. Go back to the previous page and try again.</th></tr></table>");
	}else{
		String sql ="INSERT ordersummary(customerId, orderDate) VALUES(?,?)";
		PreparedStatement  pstmt2  = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		pstmt2.setString(1, custId);

		java.util.Date date = new java.util.Date();
    	java.sql.Date sqlDate = new java.sql.Date(date.getTime());
    	pstmt2.setDate(2, sqlDate);

		pstmt2.executeUpdate();
		ResultSet keys = pstmt2.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);

		NumberFormat currFormat = NumberFormat.getCurrencyInstance();

		////////////OrderSummaryTable Start/////////////
		out.println("<h1>Your Order Summary</h1>");
		out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
		out.println("<th>Price</th><th>Subtotal</th></tr>");
		///////////////////////////////////////////////

		double sum = 0;
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();

				/////////OrderSummaryTable Fields////////////
				out.print("<tr><td>"+product.get(0)+"</td>");
				out.print("<td>"+product.get(1)+"</td>");
				out.print("<td align=\"center\">"+product.get(3)+"</td>");
				out.print("<td align=\"right\">$"+currFormat.format(pr).replaceAll("[^0123456789.,]","")+"</td>");
				out.print("<td align=\"right\">$"+currFormat.format(pr*qty).replaceAll("[^0123456789.,]","")+"</td></tr>");
				out.println("</tr>");
				////////////////////////////////////////////

				sum = sum+pr*qty;
					
				PreparedStatement pstmt3 = con.prepareStatement("INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?,?,?,?)");
				pstmt3.setInt(1,orderId);
				pstmt3.setString(2, productId);
				pstmt3.setInt(3, qty);
				pstmt3.setDouble(4, pr);

				pstmt3.executeUpdate();
			}

			PreparedStatement pstmt6 = con.prepareStatement("UPDATE ordersummary SET totalAmount ="+sum+" Where orderId ="+orderId);
			pstmt6.executeUpdate();

			////////////OrderTotalSummary End/////////////
			out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
				+"<td align=\"right\">$"+currFormat.format(sum).replaceAll("[^0123456789.,]","")+"</td></tr>");
			out.println("</table>");
			/////////////////////////////////////////////

			String first = "";
			String last = "";
			PreparedStatement pstmt5 = con.prepareStatement("Select firstName, lastName From customer Where customerId ="+custId);
			ResultSet rst3 = pstmt5.executeQuery();
			while(rst3.next()){
				first = rst3.getString(1);
				last = rst3.getString(2);
			}
			out.println("</table><h1>Order completed. Will be shipped soon...</h1><h1>Your order reference number is: "+orderId+"</h1><h2>Shipping to customer: "+custId+" Name: "+first+" "+last+"</h2><h2><a href='index.jsp'>Return to shopping</a></h2>");	
			productList.clear();		
	}
}
catch(SQLException ex){
    out.println(ex);
}
// Save order information to database


	/*
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	*/

// Insert each item into OrderProduct table using OrderId from previous INSERT

// Update total amount for order record

// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/

// Print out order summary

// Clear cart if order placed successfully
%>
</BODY>
</HTML>

