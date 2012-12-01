<%
String reply = "{\"status\":\"success\"}";
if(request.getUserPrincipal() != null){
     if(request.getParameter("action").compareTo("install") == 0){
        com.feezixlabs.db.dao.WidgetDAO.grantAppletAccess(Integer.parseInt(request.getParameter("applet_id")), request.getUserPrincipal().getName(), null);
     }
     else
     if(request.getParameter("action").compareTo("uninstall") == 0){
        com.feezixlabs.db.dao.WidgetDAO.revokeAppletAccess(request.getUserPrincipal().getName(), Integer.parseInt(request.getParameter("applet_id")));
     }
     else
     if(request.getParameter("action").compareTo("app-suggestion") == 0){
          String msg = request.getParameter("message");
          com.feezixlabs.util.Utility.sendEmail("ekemokai@gmail.com","App Suggestion", msg,true,"ekemokai@phyzixlabs.com","ekemokai@phyzixlabs.com", "2163689c2894");
     }
     else
     if(request.getParameter("action").compareTo("send-support") == 0){
          String msg = request.getParameter("message");
          com.feezixlabs.util.Utility.sendEmail("ekemokai@gmail.com","Support Request", msg,true,"ekemokai@phyzixlabs.com","ekemokai@phyzixlabs.com", "2163689c2894");
     }
}
%><%=reply%>