<%@page contentType="text/plain" pageEncoding="UTF-8"%><% 
String exceptionObj = "{}";
String statusMsg    = "";

if(request.getSession().getAttribute("running_package_status") == null){
    if(request.getSession().getAttribute("exception") != null){
        statusMsg = "error";
        exceptionObj = ""+request.getSession().getAttribute("exception");
        request.getSession().removeAttribute("exception");
    }else{
        statusMsg = "done";
    }
}else{
    statusMsg = ""+request.getSession().getAttribute("running_package_status");
}
    System.out.println("status:"+statusMsg);
%>
<%= "checkAbort({\"status\":\""+statusMsg+"\",\"error\":"+exceptionObj+"});" %>