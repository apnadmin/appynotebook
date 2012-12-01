<%@page contentType="text/xml" pageEncoding="UTF-8"%><%
        StringBuffer xmlbuf = new StringBuffer();
        String env = "library";

        xmlbuf.append("<?xml version='1.0' encoding='utf-8'?>\n");
        xmlbuf.append("<rows>");
        xmlbuf.append(" <page>1</page>");
        xmlbuf.append(" <total>0</total>");
        xmlbuf.append(" <records>0</records>");
        xmlbuf.append("</rows>\n");
        String result = request.getParameter("load") != null?com.feezixlabs.struts.action.handler.WidgetIDEActionHandler.getLibraries(request):xmlbuf.toString();
        
%><%= result%>
