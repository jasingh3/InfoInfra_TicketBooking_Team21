<%@ page import="java.sql.*" %>
<%
    //out.println("first page");
    if ((session.getAttribute("userid") == null) || (session.getAttribute("userid") == "")) {
%>
You are not logged in<br/>
<a href="BookMyMovie.jsp">Please Login</a>
<%} 
    else {
%>

<h3>	List of all users and their reservations </h3> you have log in as  <%=session.getAttribute("userid")%>

<a href='logout.jsp'>Log out</a>

<form name='Reports All Users' method="post">
<center>
<table border="2">
 <thead>
                              
   <tr>
       <th>User ID</th>
	   <th>First Name</th>
	   <th>Last Name</th>
	   <th>Email Id</th>
       <th>Ticket No.</th>
   </tr>
   </thead>
   <%
   try
   {
	   Class.forName("COM.ibm.db2os390.sqlj.jdbc.DB2SQLJDriver");
		Connection con = DriverManager.getConnection("jdbc:db2://PUND15661.corp.capgemini.com:50001/RESERVDB","db2admin","db2@dmin");
		
		String query = "Select A.USER_ID, B.FNAME, B.LNAME, B.EMAIL, A.SEAT_NO FROM TICKET_BOOKING A, USERS B where A.USER_ID = B.USER_ID";
		PreparedStatement ps = con.prepareStatement(query);
		ResultSet rs = ps.executeQuery();
		while(rs.next())
       {
   %>
			<tr>
			<td><%=rs.getString("USER_ID") %></td>
			<td><%=rs.getString("FNAME") %></td>
			<td><%=rs.getString("LNAME") %></td>
			<td><%=rs.getString("EMAIL") %></td>
			<td><%=rs.getInt("SEAT_NO") %></td>
			</tr>

   <%
       }
   %>
   </table>
   <%
        rs.close();
        
        con.close();
   }
   catch(Exception e)
   {
        e.printStackTrace();
   }
   %>
   </center>
</form>

<%
    }
%>