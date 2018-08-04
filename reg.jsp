<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registration</title>
        <script>              
        function formValidation()
        {
        	var uid = document.registration.uname;
        	var passid = document.registration.pass;
        	if(userid_validation(uid,6,12))
        	{
            	if(passid_validation(passid,6,12))
        		{
        			return true;
        		}
        	}
        	
        	return false;
        	
        }
		    function userid_validation(uid,mx,my)
				{
					var uid_len = uid.value.length;
					if (uid_len == 0 || uid_len >= my || uid_len < mx)
					{
					alert("User Name should not be empty / length be between "+mx+" to "+my);
					uid.focus();
					return false;
					}
					else{
					return true;
					}
				}

	        function passid_validation(passid,mx,my)
		        {
			        var passid_len = passid.value.length;
			        if (passid_len == 0 ||passid_len >= my || passid_len < mx)
			        {
			        alert("Password should not be empty / length be between "+mx+" to "+my);
			        passid.focus();
			        return false;
			        }
			        else{
			        return true;
			        }
		        }	
		 </script>		
    </head>
    <body onload="document.registration.fname.focus();">
        <form name='registration' method="post" action="Reg.obj?action=Reg" onsubmit="return formValidation();">
            <center>
            <h4 style="color: red;">${msg}</h4>
            <table border="1" width="30%" cellpadding="5">
                <thead>
                    <tr>
                        <th colspan="2">Registration Details</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>First Name</td>
                        <td><input type="text" name="fname" value="${fname}" /></td>
                    </tr>
                    <tr>
                        <td>Last Name</td>
                        <td><input type="text" name="lname" value="${lname}" /></td>
                    </tr>
                    <tr>
                        <td>Email</td>
                        <td><input type="text" name="email" value="${email}" /></td>
                    </tr>
                    <tr>
                        <td>User Name</td>
                        <td><input type="text" name="uname" value="${uname}" /></td>
                    </tr>
                    <tr>
                        <td>Password</td>
                        <td><input type="password" name="pass" value="" /></td>
                    </tr>
                    <tr>
                    	<td><input type="reset" value="Reset" /></td>
                        <td><input type="submit" value="Submit" /></td>
                        
                    </tr>
                    <tr>
                        <td colspan="2">Already registered!! <a href="BookMyMovie.jsp">Login Here</a></td>
                    </tr>
                </tbody>
            </table>
            </center>
        </form>
    </body>
</html>