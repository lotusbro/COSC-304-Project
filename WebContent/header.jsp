
<H1 align="center"><font face="cursive" color="#3399FF"><a href="index.jsp">Fantasian Fits</a></font></H1> 
<hr>

<h2 align="center">
    <a href="login.jsp">Login  |</a>
    <a href="listprod.jsp">Begin Shopping  |</a>
    <a href="listorder.jsp">List All Orders  |</a>
    <a href="customer.jsp">Customer Info  |</a>
    <a href="admin.jsp">Administrators  |</a>
    <a href="logout.jsp">Log out</a></h2>

<%
String userName = (String) session.getAttribute("authenticatedUser");
if (userName != null)
        out.println("<td align=\"center\">Signed in as: "+userName+"</td>");	
%>

<hr>