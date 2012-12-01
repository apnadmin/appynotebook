<%-- 
    Document   : download-svg
    Created on : Oct 4, 2012, 8:37:08 PM
    Author     : bitlooter
--%>
<%@page contentType="image/svg+xml" pageEncoding="UTF-8"%>
<%
        String fileName = request.getParameter("file_name") != null && request.getParameter("file_name").length()>0? request.getParameter("file_name")+".svg":"note.svg";
        response.setHeader("Content-disposition", "attachment; filename="+fileName);
%>
<%=request.getParameter("svg").trim() %>