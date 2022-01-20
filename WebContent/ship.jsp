<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Fantasian Fits Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// TODO: Get order id
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";
	
	String orderId = request.getParameter("orderId");
	boolean order = false;
	try (Connection con = DriverManager.getConnection(url, uid, pw);
		PreparedStatement pstmt = con.prepareStatement("Select orderId FROM orderproduct WHERE orderId = "+orderId))
	{
		con.setAutoCommit(false);
		ResultSet rst = pstmt.executeQuery();
		if(!rst.next()){
			out.println("<table><tr><th>Invalid order id. Go back to the previous page and try again.</th></tr></table>");
		}else if(rst.next()){
			String sql = "Select O.productId , O.quantity, I.quantity From productinventory as I JOIN orderproduct as O ON O.productId = I.productId Where warehouseId=1 AND O.orderId="+orderId;
			PreparedStatement pstmt2 = con.prepareStatement(sql);
			ResultSet rst2 = pstmt2.executeQuery();
			while(rst2.next()){
				int prodId = rst2.getInt(1);
				int oInv = rst2.getInt(2);
				int wInv = rst2.getInt(3);
				int newInv = wInv-oInv;
				if(oInv>wInv){
					out.println("<table><tr><th>Shipment not done. Insufficient inventory for product id: "+prodId+"</th></tr></table>");
					order = false;
					con.rollback();
					break;
				}else if(wInv>=oInv){
					out.println("<table><tr><th>Ordered product: "+prodId+" Qty: "+oInv+" Previous inventory: "+wInv+" New inventory: "+newInv+"</th></tr></table>");
					order = true;
					PreparedStatement pstmt4 = con.prepareStatement("UPDATE productinventory SET quantity = "+newInv+" Where productId="+prodId);
					pstmt4.executeUpdate();
					con.commit();
				}	
			}
			if(order){
				out.println("<h2>Shipment successfully processed.</h2>");
				PreparedStatement pstmt3 =  con.prepareStatement("INSERT INTO shipment (shipmentDate,  warehouseId) VALUES (?,1)");
				java.util.Date date = new java.util.Date();
				java.sql.Date sqlDate = new java.sql.Date(date.getTime());
				pstmt3.setDate(1, sqlDate);
				pstmt3.executeUpdate();
				con.commit();			
			}
		}
		con.setAutoCommit(true);
	}catch(SQLException ex){
		out.println(ex);
		con.rollback();
	}

          
	// TODO: Check if valid order id
	
	// TODO: Start a transaction (turn-off auto-commit)
	
	// TODO: Retrieve all items in order with given id
	// TODO: Create a new shipment record.
	// TODO: For each item verify sufficient quantity available in warehouse 1.
	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
	
	// TODO: Auto-commit should be turned back on
%>                       				

<h2><a href="index.jsp">Back to Main Page</a></h2>

</body>
</html>
