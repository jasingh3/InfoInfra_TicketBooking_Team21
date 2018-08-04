<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Book My Movies</title>
    </head>
    <body>
        <form method="post" action="login.obj?action=Login">
            <center>
            <h4 style="color: red;">${msg}</h4>
            <table border="1" width="30%" cellpadding="3">
                <thead>
                    <tr>	
                        <th colspan="2">Login Here</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>User Name</td>
                        <td><input type="text" name="uname" value="" /></td>
                    </tr>
                    <tr>
                        <td>Password</td>
                        <td><input type="password" name="pass" value="" /></td>
                    </tr>
                    <tr>
                    	<td></td>
                        <td><input type="submit" value="Login" /></td>
                        
                    </tr>
                    <tr>
                        <td colspan="2">Not Registered ! <a href="reg.jsp">Register Here.</a></td>
                    </tr>
                </tbody>
            </table>
            </center>
        </form>
      
    </body>
</html>
