<%
    //out.println("first page");
    if ((session.getAttribute("userid") == null) || (session.getAttribute("userid") == "")) {
%>
You are not logged in<br/>
<a href="BookMyMovie.jsp">Please Login</a>
<%} else {
%>
Congratulations ! <%=session.getAttribute("userid")%> your booking has been successful !


<% String listOfSelectedSeats=(String)request.getAttribute("listOfSelectedSeats"); %>

Booking confirm for Seat Number(s) : <%=listOfSelectedSeats%>

<a href='logout.jsp'>Log out</a>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Booking Successful</title>
</head>
<body>

</body>
<%
    }
%>