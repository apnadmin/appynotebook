<%-- 
    Document   : index
    Created on : May 6, 2012, 12:03:10 PM
    Author     : bitlooter
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <%//preserve original intent
        if(request.getSession().getAttribute("u") == null)
            request.getSession().setAttribute("u", request.getParameter("username"));
        
        if(request.getSession().getAttribute("p") == null)
            request.getSession().setAttribute("p", request.getParameter("password"));
        
        if(request.getSession().getAttribute("lp") == null)
            request.getSession().setAttribute("lp",request.getParameter("lp"));
        
        if(request.getSession().getAttribute("pr") == null)
            request.getSession().setAttribute("pr",request.getParameter("pr"));
        
        if(request.getSession().getAttribute("room_id") == null)
            request.getSession().setAttribute("room_id",request.getParameter("room_id"));  

        if(request.getSession().getAttribute("ep") == null)
            request.getSession().setAttribute("ep",request.getParameter("ep"));                     
        %>        
        <%             
            response.sendRedirect("../sc/nd/");
        %>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
