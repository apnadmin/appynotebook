<%-- 
    Document   : get-review-node
    Created on : Nov 21, 2011, 4:06:29 PM
    Author     : bitlooter
--%>
<%@page contentType="text/javascript" pageEncoding="UTF-8"%>
<% 
    com.feezixlabs.util.Utility.request = request;
    String result = com.feezixlabs.util.Utility.buildAppletTreeLazy(request.getUserPrincipal().getName(),request.getParameter("type"));
    com.feezixlabs.util.Utility.request = null;
    //System.out.println("node:"+result);
%>
<%= "["+result+"]" %>
