<%
    //out.println("first page");
    if ((session.getAttribute("userid") == null) || (session.getAttribute("userid") == "")) {
%>
You are not logged in<br/>
<a href="BookMyMovie.jsp">Please Login</a>
<%} else {
%>
Welcome to BookMyMovie  <%=session.getAttribute("userid")%>
<a href='logout.jsp'>Log out</a>

<script type="text/javascript" src="jquery-3.1.1.min.js"></script>
<script>
        $(function () {
            var settings = {
                rows: 5,
                cols: 20,
                rowCssPrefix: 'row-',
                colCssPrefix: 'col-',
                seatWidth: 35,
                seatHeight: 35,
                seatCss: 'seat',
                selectedSeatCss: 'selectedSeat',
				selectingSeatCss: 'selectingSeat'
            };

             function init(reservedSeat) {
                var str = [], seatNo, className;
                for (i = 0; i < settings.rows; i++) {
                    for (j = 0; j < settings.cols; j++) {
                        seatNo = (i + j* settings.rows + 1);
                        className = settings.seatCss + ' ' + settings.rowCssPrefix + i.toString() + ' ' + settings.colCssPrefix + j.toString();
						//	alert(reservedSeat);
                         if ($.isArray(reservedSeat) && $.inArray(seatNo, reservedSeat) != -1) {
                            
                            className += ' ' + settings.selectedSeatCss;
                        }
                        str.push('<li class="' + className + '"' +
                                  'style="top:' + (i * settings.seatHeight).toString() + 'px;left:' + (j * settings.seatWidth).toString() + 'px">' +
                                  '<a title="' + seatNo + '">' + seatNo + '</a>' +
                                  '</li>');
                    }
                }
                $('#place').html(str.join(''));
            };

            //case I: Show from starting
            //init();

            //Case II: If already booked
          
            var bookedSeats = $("#selectedSeats").val();
            var tempBookedSeats = bookedSeats.substring(1,bookedSeats.length-1);
            var listBookedSeats = new Array();
                listBookedSeats = tempBookedSeats.split(",");
            for(a in listBookedSeats){
            	listBookedSeats[a] = parseInt(listBookedSeats[a],10);
                }    
            init(listBookedSeats);


            $('.' + settings.seatCss).click(function () {
			if ($(this).hasClass(settings.selectedSeatCss)){
				alert('This seat is already reserved');
			}
			else{
                $(this).toggleClass(settings.selectingSeatCss);
				}
            });
/*
            $('#btnShow').click(function () {
                var str = [];
                $.each($('#place li.' + settings.selectedSeatCss + ' a, #place li.'+ settings.selectingSeatCss + ' a'), function (index, value) {
                    str.push($(this).attr('title'));
                });
                alert(str.join(','));
            });
*/
            $('#btnShowNew').click(function () {
                var str =[], item;
                $.each($('#place li.' + settings.selectingSeatCss + ' a'), function (index, value) {
                    item = $(this).attr('title');                   
                    str.push(item); 
					                 
                    $("#hidden_array").val(str);
                                
                });
                //Check for Maximum Ticket count as 4
                //alert (listBookedSeats);
                var totalTicketsForUser = 0; 
                var tempBookTickets = 0;
                tempBookTickets = $("#countUserTicket").val();
                totalTicketsForUser = parseInt(str.length) + parseInt(tempBookTickets);
                //alert (totalTicketsForUser);
               // alert(str);
                if(str.length<1){
                	alert('Please Select atleast 1 seat for Booking');
                	return false;
                }
                else if(str.length>4){
                	alert('Seat selection Exceed -- You cannot select more than 4 seats !!!');
                	return false;
                }
                else if(totalTicketsForUser > 4){
                	alert('Maximum numbers of tickets per user is 4 !! You have booked '+tempBookTickets+' ticket(s) previously');
                	return false;    
                }    
            }
            );
        });
    
    </script>
<link rel="stylesheet" type="text/css" href="bookTicket.css"/>
        <body onload="intit();">
        <center>
          <form name='SelectSeats' method="post" action="SelectedSeats.obj?action=SelectedSeats">
        
        <h2> Choose seats by clicking the corresponding seat(s) :</h2>
    <div id="holder"> 
		<ul  id="place">
        </ul>    
	</div>
	
	<div>
	<ul id="seatDescription">
		<li style="background:url('images/available_seat_img.GIF') no-repeat scroll 0 0 transparent;">Available Seat</li>
		<li style="background:url('images/booked_seat_img.GIF') no-repeat scroll 0 0 transparent;">Booked Seat</li>
		<li style="background:url('images/selected_seat_img.GIF') no-repeat scroll 0 0 transparent;">Selected Seat</li>
	</ul>	
	</div>
	
        <div style="clear:both;width:100%">
        <input type="hidden" id="hidden_array" name="hiddenArray" />
        <input type="hidden" id="selectedSeats" value="${selectedSeats}" />
        <input type="hidden" id="countUserTicket" value="${countUserTicket}" />
		<input type="submit" id="btnShowNew" value="Book Tickets" />
		    
        </div>
        </form>
        </center>
       </body>
       
<%
    }
%>