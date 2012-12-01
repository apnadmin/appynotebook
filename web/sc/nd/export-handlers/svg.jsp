<%-- 
    Document   : svg
    Created on : Jun 2, 2009, 9:24:11 PM
    Author     : bitlooter
--%>
<%@page contentType="image/svg+xml" pageEncoding="UTF-8"%>
<%    //make sure they have right to take this action
        if(!com.feezixlabs.util.FeatureAccessManager.hasAccess("export", request)){
            response.sendRedirect("export-error.jsp?src=svg");return;
        }
        String fileName = request.getParameter("file_name") != null && request.getParameter("file_name").length()>0? request.getParameter("file_name")+".svg":"note.svg";
        response.setHeader("Content-disposition", "attachment; filename="+fileName);
%>
<%=request.getParameter("svg")/*.replaceAll("util/getimage.jsp", com.feezixlabs.util.ConfigUtil.baseUrl+"/util/getimage.jsp")*/ %>