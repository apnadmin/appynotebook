<%-- 
    Document   : auto-auth
    Created on : Apr 20, 2009, 9:51:17 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
    </head>
    <body>
        <h1>Signing in, please wait</h1>
        <%       
        if(request.getSession().getAttribute("u") == null)
            request.getSession().setAttribute("u", request.getParameter("username"));
        
        if(request.getSession().getAttribute("p") == null)
            request.getSession().setAttribute("p", request.getParameter("password"));  
        
        if(request.getSession().getAttribute("oa") == null)
            request.getSession().setAttribute("oa", "true");
        
        if(request.getSession().getAttribute("lp") == null)
            request.getSession().setAttribute("lp",request.getParameter("lp"));
        
        if(request.getSession().getAttribute("pr") == null)
            request.getSession().setAttribute("pr",request.getParameter("pr"));
        
        if(request.getSession().getAttribute("room_id") == null)
            request.getSession().setAttribute("room_id",request.getParameter("room_id"));
        
        if(request.getSession().getAttribute("ep") == null)
            request.getSession().setAttribute("ep",request.getParameter("ep"));        
        //System.out.println("redirecting for auto login: username="+request.getParameter("username")+" password="+request.getSession().getAttribute("u"));
        response.sendRedirect("../sc/nd/");
        //if(request.getParameter("mobile") == null)
        //    response.sendRedirect("../sc/?action=onlogin");
        //else
        //    response.sendRedirect("sc/nd/mobile.jsp");
       %>
    </body>
</html>
