<%@page contentType="text/plain" pageEncoding="UTF-8"%><% System.out.println("running_upload_status:"+request.getSession().getAttribute("running_upload_status"));%><%=request.getSession().getAttribute("running_upload_status") %>