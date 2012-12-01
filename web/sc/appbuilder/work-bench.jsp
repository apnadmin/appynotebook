<%-- 
    Document   : work-bench
    Created on : Dec 29, 2010, 2:21:43 PM
    Author     : bitlooter
--%>

<%@page contentType="text/javascript" pageEncoding="UTF-8"%>
<%
    com.feezixlabs.util.Utility.request = request;
    StringBuilder buf = new StringBuilder();
    //buf.append("{");
    buf.append("[");
    buf.append("{\"title\":\"Home\",\"id\":\"default\",\"addClass\":\"phyzixlabs-applet-category-root\",\"type\":\"phyzixlabs-applet-category-root\",\"isFolder\":true,\"children\":"+com.feezixlabs.util.Utility.buildAppletTreeLazy()/*getDefaultAppletTree(request)*/+"}");
    buf.append("]");
    //buf.append("}");
    com.feezixlabs.util.Utility.request = null;
    //if(request.isUserInRole("sysadmin"))
    //System.out.println("result:"+buf.toString());
%>
<%=buf.toString()%>