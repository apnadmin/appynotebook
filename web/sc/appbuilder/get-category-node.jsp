<%-- 
    Document   : get-category-node
    Created on : Jan 2, 2011, 10:06:37 PM
    Author     : bitlooter
--%>

<%@page contentType="text/javascript" pageEncoding="UTF-8"%>
<%
    com.feezixlabs.util.Utility.request = request;
    String result = com.feezixlabs.util.Utility.buildAppletTreeLazy(request.getUserPrincipal().getName(),request.getParameter("category_id"),request.getParameter("type"));
    com.feezixlabs.util.Utility.request = null;
    //System.out.println("node:"+result);
%>
<%= "["+result+"]" %>
