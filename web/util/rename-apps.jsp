<%-- 
    Document   : rename-apps
    Created on : Oct 19, 2012, 10:20:56 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
<%-- 
    //com.feezixlabs.bean.User me = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
    java.util.List<com.feezixlabs.bean.Widget> appLists = com.feezixlabs.db.dao.WidgetDAO.getWidgets(request.getUserPrincipal().getName(),"dev");
    for(com.feezixlabs.bean.Widget app:appLists){
        new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/applet-"+app.getId()).renameTo(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+app.getUniqueKey()));
    }
    
    appLists = com.feezixlabs.db.dao.WidgetDAO.getWidgets(request.getUserPrincipal().getName(),"prod");
    for(com.feezixlabs.bean.Widget app:appLists){
        new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/prod/applet-"+app.getId()).renameTo(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/prod/app-"+app.getUniqueKey()));
    }           
--%>