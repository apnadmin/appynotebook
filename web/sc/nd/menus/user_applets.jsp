<%-- 
    Document   : user_applets
    Created on : Nov 17, 2011, 12:00:07 AM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    StringBuilder buf= new StringBuilder();
    String userName = request.getUserPrincipal().getName();
    int room_id = Integer.parseInt(request.getParameter("room_id"));
    int retryLimit = 10;
    int retries = 0;

    java.util.List<com.feezixlabs.bean.Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getApplets(userName, room_id);

    while(widgets == null  && retries++ < retryLimit ){
        widgets = com.feezixlabs.db.dao.WidgetDAO.getApplets(userName, room_id);
    }



    int rowCount  = 0;
    int rowLength = 5;

    java.util.List appList = new java.util.ArrayList();
    
    buf.append("<table>");

    for(com.feezixlabs.bean.Widget widget:widgets){
        if(rowCount == 0)
            buf.append("<tr>");

        buf.append("<td style=\"border-style:none;vertical-align:top;text-align:center\"><div style=\"height:64px;overflow:hidden\"><button class=\"applet-button\" title=\""+widget.getName()+"\" value=\""+widget.getUniqueKey()+"\" ><img src=\"widgets/getresource.jsp?widgetid="+/*widget.getId()*/widget.getUniqueKey()+"&file_name=favicon.png&env=prod\" style=\"border:none;width:16px;height:16px\"/></button><br><span>"+widget.getName()+"</span></div></td>");

        if(++rowCount == rowLength){
            buf.append("</tr>");
            rowCount = 0;
        }
        java.util.Map app = new java.util.HashMap();
        app.put("id",widget.getUniqueKey());
        app.put("name",widget.getName());
        app.put("description",widget.getDescription());
        app.put("showInMenu",widget.getShowInMenu());
        appList.add(app);        
     }
    buf.append("</table>");
%><%= net.sf.json.JSONArray.fromObject(appList).toString() %>

