<%-- 
    Document   : get-library-node
    Created on : Jan 4, 2011, 1:31:43 AM
    Author     : bitlooter
--%>

<%@page contentType="text/javascript" pageEncoding="UTF-8"%>
<%

   String json = com.feezixlabs.util.LibraryFS4Tree.buildTreeLazy(request.getParameter("relPath"));
   //System.out.println("json:"+json);
%>
<%=json%>
