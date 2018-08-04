package com.Reservation;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * Servlet implementation class Registeration
 */
public class Registeration extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Registeration() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		RequestDispatcher rd = null;

		String action = request.getParameter("action");
		//Registration
		if(action.equalsIgnoreCase("Reg")){
			String id=request.getParameter("uname");
			String pwd=request.getParameter("pass");
			String fname=request.getParameter("fname");
			String lname=request.getParameter("lname");
			String email=request.getParameter("email");

			try {
				Class.forName("COM.ibm.db2os390.sqlj.jdbc.DB2SQLJDriver");
				Connection con = DriverManager.getConnection("jdbc:db2://PUND15661.corp.capgemini.com:50001/RESERVDB","db2admin","db2@dmin");
				//Check If username already exist	

				String chkUserName = "select user_id from users where user_id = ?";
				PreparedStatement ps = con.prepareStatement(chkUserName);
				ps.setString(1, id);
				ResultSet rs = ps.executeQuery();
				if(rs.next()){
					request.setAttribute("msg", "User "+id+"  already exist");
					request.setAttribute("uname",id);
					//request.setAttribute("pass",pwd);
					request.setAttribute("fname",fname);
					request.setAttribute("lname",lname);
					request.setAttribute("email",email);					
					rd = request.getRequestDispatcher("reg.jsp");
					rd.forward(request,response);
				}
				// Insert the Registration Entry into DB
				else{
					PreparedStatement pst;
					pst=con.prepareStatement("insert into users(user_id,password,fname,lname,email,usertype) VALUES (?, ?, ?, ?, ?, ?)");
					pst.setString(1,id);
					pst.setString(2,pwd);
					pst.setString(3,fname);
					pst.setString(4,lname);
					pst.setString(5,email);
					pst.setString(6,"USER");

					int i= pst.executeUpdate();
					pst.clearParameters();
					if(i>0){					
						response.sendRedirect("Welcome.jsp");
					}else{
						response.sendRedirect("BookMyMovie.jsp");
					}

				}
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		//lOGIN
		if(action.equalsIgnoreCase("Login"))	{

			String id=request.getParameter("uname");
			String pwd=request.getParameter("pass");
			List<String> selectedSeats = new ArrayList<String>();
			int countUserTicket = 0;

			try {
				Class.forName("COM.ibm.db2os390.sqlj.jdbc.DB2SQLJDriver");
				Connection con = DriverManager.getConnection("jdbc:db2://PUND15661.corp.capgemini.com:50001/RESERVDB","db2admin","db2@dmin");
				PreparedStatement st;
				st= con.prepareStatement("select password,usertype from USERS where user_id= ?");
				st.setString(1,id);
				ResultSet rsGetUser=st.executeQuery();
				
				if(rsGetUser.next())
				{
					if(rsGetUser.getString("password").equals(pwd))
					{
						session.setAttribute("userid", id);

						if(rsGetUser.getString("usertype").equalsIgnoreCase("USER")){

							//fetch the booked ticket details
							
							Statement st1 = con.createStatement();
							ResultSet rsBookedTickets = st1.executeQuery("SELECT SEAT_NO FROM TICKET_BOOKING WHERE SEAT_AVAILABILITY = 1");

							while(rsBookedTickets.next()){
								selectedSeats.add(rsBookedTickets.getString("SEAT_NO"));
							}



							//Fetch the number of ticket booked by user
							st= con.prepareStatement("SELECT COUNT(SEAT_NO) AS countUserTicket FROM TICKET_BOOKING WHERE SEAT_AVAILABILITY = 1 AND USER_ID = ?");
							st.setString(1,id);
							ResultSet rsCountUserTickets = st.executeQuery();
							if(rsCountUserTickets.next()){

								countUserTicket = rsCountUserTickets.getInt("countUserTicket");
								System.out.println("Count User Tickets :::"+countUserTicket);
							}

							request.setAttribute("selectedSeats",selectedSeats);
							request.setAttribute("countUserTicket",countUserTicket);
							rd = request.getRequestDispatcher("SelectSeats.jsp");
							rd.forward(request, response);
							//response.sendRedirect("FirstPage.jsp");
						}

						else if(rsGetUser.getString("usertype").equalsIgnoreCase("ADMIN")){
							response.sendRedirect("ReportsAllUsers.jsp");
						}
					}
					else
					{
						request.setAttribute("msg", "UserId/Password is incorrect Please enter valid credentials. ");				
						rd = request.getRequestDispatcher("BookMyMovie.jsp");
						rd.forward(request,response);
						
					}

				}
				else
				{
					request.setAttribute("msg", "UserId/Password is incorrect Please enter valid credentials. ");				
					rd = request.getRequestDispatcher("BookMyMovie.jsp");
					rd.forward(request,response);
					
				}
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		//Select Seats
		if(action.equalsIgnoreCase("SelectedSeats")){
			try {
				String userid = session.getAttribute("userid").toString();
				String selectedSeats[] = request.getParameterValues("hiddenArray");
				String listOfSelectedSeats[] = selectedSeats[0].split(",");
				String seatsBooked = "";
				System.out.println(userid+"Value of Selected seats "+listOfSelectedSeats.toString());

				if(listOfSelectedSeats.length > 0){

					Class.forName("COM.ibm.db2os390.sqlj.jdbc.DB2SQLJDriver");
					Connection con = DriverManager.getConnection("jdbc:db2://PUND15661.corp.capgemini.com:50001/RESERVDB","db2admin","db2@dmin");

					int noOfRowsInserted= 0;
					PreparedStatement pst;
					for(int i =0; i<listOfSelectedSeats.length; i++){
						pst=con.prepareStatement("insert into Ticket_Booking(Seat_No,Seat_Availability,User_id) VALUES (?, ?, ?)");
						pst.setString(1,listOfSelectedSeats[i]);
						pst.setInt(2, 1); // Set is booked i.e 1 = booked
						pst.setString(3,userid);

						seatsBooked = seatsBooked+", "+listOfSelectedSeats[i];
						
						noOfRowsInserted = pst.executeUpdate() + noOfRowsInserted;
						pst.clearParameters();
					}


					if(noOfRowsInserted>0){	
						seatsBooked = seatsBooked.substring(1);
						System.out.println(userid+"Value of Selected seats "+seatsBooked);
						request.setAttribute("listOfSelectedSeats",seatsBooked);
						session.setAttribute("userid", userid);
						rd = request.getRequestDispatcher("BookingSuccessful.jsp");
						rd.forward(request, response);
						//response.sendRedirect("BookingSuccessful.jsp");
					}else{
						response.sendRedirect("BookMyMovie.jsp");
					}
				}
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}	
}
