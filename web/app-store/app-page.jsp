<%-- 
    Document   : app-page
    Created on : Dec 11, 2011, 12:14:52 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    StringBuilder buf= new StringBuilder();
    //System.out.println("categoryId:"+categoryId);
    com.feezixlabs.bean.Widget widget = com.feezixlabs.db.dao.WidgetDAO.getWidget(Integer.parseInt(request.getParameter("applet_id")), "prod");

    if(widget != null){
        buf.append("<div  style=\"width:750px;color:#3cb2ec;\">");
        buf.append("  <div style=\"width:250px;height:128px;overflow:hidden;float:left\">");
        buf.append("    <div style=\"width:70px;float:left;\">");
        buf.append("        <img src=\"geticon.jsp?widgetid="+widget.getId()+"&file_name=app-store-favicon.png&env=prod\" style=\"border:none;width:64px;height:64px\"/>");
        buf.append("    </div>");

        buf.append("    <div style=\"width:128px;float:left;text-align:left;\">");
        buf.append("        <span style=\"overflow:hidden;font-weight:bold;white-space:nowrap;font-family:arial\">"+widget.getName()+"</span><br/>");
        buf.append("        <span style=\"overflow:hidden;white-space:nowrap;color:gray;font-size:.7em\">"+widget.getAuthorName().toUpperCase()+"</span>");
        //buf.append("        <div style=\"padding-top:.5em;line-height:1em;height:3em;overflow:hidden;font-size:.8em;font-family:arial\">"+widget.getDescription()+"</div>");

        buf.append("            <span>");
        if(request.getUserPrincipal() != null && com.feezixlabs.db.dao.WidgetDAO.isInstalled(request.getUserPrincipal().getName(), widget.getId()))
            buf.append("            <button style=\"font-size:.7em\" class=\"installed-applet-button\" value=\""+widget.getId()+"\"  disabled>INSTALLED</button>");
        else
        if(request.getUserPrincipal() != null)
            buf.append("            <button style=\"font-size:.7em\" class=\"install-applet-button\" value=\""+widget.getId()+"\"  onclick=\"app_store_app.install(this,"+widget.getId()+")\" >INSTALL</button>");
        buf.append("            </span>");

        buf.append("    </div>");
        buf.append("  </div>");

        buf.append("  <div style=\"width:400px;overflow:hidden;float:left\">");
        buf.append("    <h3>Description</h3>");
        buf.append("    <pre>");
        buf.append(       widget.getDescription());
        buf.append("    </pre>");
        buf.append("  </div><div style=\"clear:both\"></div>");
        buf.append("</div>");
    }
%><%= buf.toString() %>

