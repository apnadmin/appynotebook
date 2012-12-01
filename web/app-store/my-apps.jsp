<%-- 
    Document   : my-apps
    Created on : Dec 7, 2011, 12:17:36 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    StringBuilder buf= new StringBuilder();
    //System.out.println("categoryId:"+categoryId);
    java.util.List<com.feezixlabs.bean.Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getApplets(request.getUserPrincipal().getName(),0);

    int rowCount  = 0;
    int rowLength = 3;

if(widgets.size()>0){
    buf.append("<table class=\"apps ui-corner-all\" style=\"border:none\">");

    for(com.feezixlabs.bean.Widget widget:widgets){
        if(rowCount == 0)
            buf.append("<tr>");

        buf.append("<td>");
        buf.append("  <div  class=\"app-bk-panel\">");
        buf.append("    <div  class=\"app-icon-panel\">");
        buf.append("        <a href=\"#\" onclick=\"app_store_app.showAppPage("+widget.getId()+")\"><img src=\"geticon.jsp?widgetid="+widget.getId()+"&file_name=app-store-favicon.png&env=prod\" style=\"border:none;width:64px;height:64px\"/></a>");
        buf.append("    </div>");

        buf.append("    <div  class=\"app-desc\">");
        buf.append("        <span style=\"overflow:hidden;font-weight:bold;white-space:nowrap;font-family:arial\">"+widget.getName()+"</span><br/>");
        buf.append("        <span style=\"overflow:hidden;white-space:nowrap;color:gray;font-size:.7em\">"+widget.getAuthorName().toUpperCase()+"</span>");
        buf.append("        <div style=\"padding-top:.5em;line-height:1em;height:3em;overflow:hidden;font-size:.8em;font-family:arial\">"+widget.getDescription()+"</div>");

        //if(request.getUserPrincipal() != null && com.feezixlabs.db.dao.WidgetDAO.isInstalled(request.getUserPrincipal().getName(), widget.getId()))
            buf.append("        <button style=\"font-size:.7em\" class=\"installed-applet-button\" value=\""+widget.getId()+"\" onclick=\"app_store_app.unInstall(this,"+widget.getId()+")\" >UNINSTALL</button>");
        /*else
        if(request.getUserPrincipal() != null)
            buf.append("        <button style=\"font-size:.7em\" class=\"install-applet-button\" value=\""+widget.getId()+"\" >INSTALL</button>");
        */
        buf.append("    </div>");
        buf.append("  </div>");
        buf.append("</td>");

        if(++rowCount == rowLength){
            buf.append("</tr>");
            rowCount = 0;
        }
     }
    if(rowCount>0){//not even
        for(int i=rowCount;i<rowLength;i++){
            buf.append("<td>");
            buf.append("  <div  class=\"app-bk-panel\">");
            buf.append("    <div class=\"app-icon-panel\"></div>");
            buf.append("    <div class=\"app-desc\" style=\"background:none\"></div>");
            buf.append("  </div>");
            buf.append("</td>");
        }
        buf.append("</tr>");
    }
    buf.append("</table>");
}
%><%= buf.toString() %>


