<%-- 
    Document   : getwidget
    Created on : Aug 24, 2009, 9:42:55 PM
    Author     : bitlooter
--%>
<%@page contentType="text/javascript" pageEncoding="UTF-8"%>
<%
    String env = request.getParameter("env")!=null?request.getParameter("env"):"prod";
    com.feezixlabs.bean.Widget widget = null;
    widget = com.feezixlabs.db.dao.WidgetDAO.serveWidget(request.getParameter("id"),request.getParameter("env")!=null?request.getParameter("env"):"prod" );
    
    /*
    try{
        widget = com.feezixlabs.db.dao.WidgetDAO.getWidget( new Integer(request.getParameter("id")),request.getParameter("env")!=null?request.getParameter("env"):"prod" );
    }catch(Exception ex){
        widget = com.feezixlabs.db.dao.WidgetDAO.serveWidget(request.getParameter("id"),request.getParameter("env")!=null?request.getParameter("env"):"prod" );
    }
    
    
    System.out.println("using id:"+request.getParameter("id")+" name:"+widget.getName()+" env:"+request.getParameter("env"));
 *  */
    StringBuilder buf = new StringBuilder();
    buf.append("ts="+new java.util.Date().getTime()+"; (function(){newApplet = new Widget('"+env+"',"+widget.getId()+",'"+widget.getUniqueKey()+"','"+widget.getName()+"',");
    buf.append(widget.getCode()+"); newApplet.impl.init();})();");
%>
<%=buf.toString() %>