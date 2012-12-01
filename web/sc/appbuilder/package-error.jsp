<%-- 
    Document   : package-error
    Created on : Oct 25, 2012, 6:12:42 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="../../../js/safe-jquery-1.6.2.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                //top.ColabopadApplication.onPackageError("<%= request.getParameter("src") %>","<%= request.getParameter("type") %>",$('#stack-trace').html());       
            });
        </script>
    </head>
    <body>
        <h1>Hello World!</h1>
        <div id="stack-trace">
            <%= ""+request.getSession().getAttribute("error-message")%>
            <%-- request.getSession().removeAttribute("error-message");--%>
        </div>
    </body>
</html>
