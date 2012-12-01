<%-- 
    Document   : get-resource-node
    Created on : Jan 2, 2011, 7:24:44 PM
    Author     : bitlooter
--%><%@page contentType="text/plain" pageEncoding="UTF-8"%>
<%=com.feezixlabs.util.ResourceFS4Tree.buildTreeLazy(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid")),request.getParameter("uuid"), request.getParameter("relPath")) %>