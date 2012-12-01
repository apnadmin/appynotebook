<%-- 
    Document   : get-deployed-category-node
    Created on : Jan 9, 2011, 12:33:49 AM
    Author     : bitlooter
--%>

<%@page contentType="text/javascript" pageEncoding="UTF-8"%>
<%
    String result = com.feezixlabs.util.Utility.buildAppletBinTreeLazy(request.getUserPrincipal().getName(),request.getParameter("category_id"),request.getParameter("type"));
    //System.out.println("node:"+result);
%>
<%= "["+result+"]" %>

