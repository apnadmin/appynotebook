<%-- 
    Document   : developer-menu
    Created on : Jan 5, 2011, 6:55:01 PM
    Author     : bitlooter
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%if(request.isUserInRole("sysadmin") || request.isUserInRole("developer") || request.isUserInRole("reviewer")){%><%com.feezixlabs.util.Utility.request = request;%><%=com.feezixlabs.util.Utility.buildDevAppletMenu2() %><%com.feezixlabs.util.Utility.request = null;%><%}%><%--if(request.isUserInRole("sysadmin") || request.isUserInRole("developer") || request.isUserInRole("reviewer")){%>
<ul class="ui-corner-all">
    <%com.feezixlabs.util.Utility.request = request;%>
    <li><a href="#" style="font-weight: bold">Your Applets</a> <%=com.feezixlabs.util.Utility.buildDevAppletMenu2() %></li>
    <%=com.feezixlabs.util.Utility.buildDeployedApplet(true) %>
    <%com.feezixlabs.util.Utility.request = null;%>
        <li>&nbsp;</li>
        <li>&nbsp;</li>
        <li>&nbsp;</li>
        <li>&nbsp;</li>
        <li>&nbsp;</li>
        <li>&nbsp;</li>
        <li>&nbsp;</li>
        <li>&nbsp;</li>
        <li>&nbsp;</li>
        <li>&nbsp;</li>
        <li>&nbsp;</li>
</ul>
<%}else{%>
<%=com.feezixlabs.util.Utility.buildDeployedApplet(false) %>
<%}--%>