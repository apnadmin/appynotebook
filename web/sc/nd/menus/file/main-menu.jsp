<%-- 
    Document   : main-menu
    Created on : Jul 11, 2009, 11:06:11 AM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="colabopad-menu-file" class="menu">
    <a action="colabopad.menubar.filemenu.newWorkbookMenuItem.action()" img="new-work-book.png" >New Workbook</a>

    <!--
    <a menu="colabopad-menu-file-new-page" img="new-doc.png" >New Page</a>
    -->
	<a action="colabopad.menubar.filemenu.openFileItem.action()" >Open Workbook File...</a>
	<a menu="colabopad-menu-file-save-as" >Save As...</a>
	<a rel="separator"></a>
	<a action="" >Exit</a>
</div>

<div id="colabopad-menu-help" class="menu">
    <a action="showHelp()" img="images/misc/gnochm.png" >Help <span style="text-decoration:underline">C</span>ontents</a>

    <%if(request.isUserInRole("developer") || request.isUserInRole("reviewer")){%>
        
    <%}%>

    <a action="showAbout()" img="images/misc/gtk-info.png" ><span style="text-decoration:underline">A</span>bout</a>
</div>







<div id="colabopad-menu-dev-widget" class="menu">
    <!-- if this user is a developer make their widgets available -->
    <%if(request.isUserInRole("developer") || request.isUserInRole("reviewer")){%>
        <a img="../widgetbuilder/img/stock_folder-properties.png" menu="colabopad-menu-applet-dev-default" style="">Applets</a>
        <!--
        <a img="../widgetbuilder/img/stock_folder-properties.png" menu="colabopad-menu-widget-pendingWidgets" style="font-weight:bold;color:orange">Your Widgets Pending Approval</a>
        <a img="../widgetbuilder/img/stock_folder-properties.png" menu="colabopad-menu-widget-rejectedWidgets" style="font-weight:bold;color:red">Your Rejected Widgets</a>
        <a img="../widgetbuilder/img/stock_folder-properties.png" menu="colabopad-menu-widget-aprWidgets" style="font-weight:bold;color:lime">Your Approved Widgets</a>
        -->
        <a action="showDevHelp()" img="images/gnochm.png" ><span style="text-decoration:underline">D</span>eveloper Help</a>
    <%}%>

    <%--if(request.isUserInRole("reviewer")){%>
        <a img="../widgetbuilder/img/stock_folder-properties.png" menu="colabopad-menu-widget-widgetReviewQueue" style="font-weight:bold;color:orange">Widget Review Queue</a>
    <%}--%>
</div>

<%if(request.isUserInRole("developer") || request.isUserInRole("reviewer")){%>
    <!--
    <div id="colabopad-menu-widget-ydWidgets" class="menu">
        <%--
           java.util.List<com.feezixlabs.bean.Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getWidgets(request.getUserPrincipal().getName(),"dev");
           for(com.feezixlabs.bean.Widget widget:widgets){
        %>
        <a action="ColabopadApplication.newWidget(<%=widget.getId() %>,'dev')" ><%=widget.getName() %></a>
        <%}--%>

    </div>
    -->
        <%
            com.feezixlabs.util.Utility.request = request;
        %>
        <%=com.feezixlabs.util.Utility.buildDevAppletMenu() %>
        <%
            com.feezixlabs.util.Utility.request = null;
        %>

        <!--
    <div id="colabopad-menu-widget-pendingWidgets" class="menu">
        <%
           java.util.List<com.feezixlabs.bean.Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getWidgets(request.getUserPrincipal().getName(),"queue");
           for(com.feezixlabs.bean.Widget widget:widgets){
        %>
        <a action="ColabopadApplication.newWidget(<%=widget.getId() %>,'queue')" ><%=widget.getName() %></a>
        <%}%>
    </div>
    <div id="colabopad-menu-widget-rejectedWidgets" class="menu">
        <%
           widgets = com.feezixlabs.db.dao.WidgetDAO.getWidgets(request.getUserPrincipal().getName(),"rejected");
           for(com.feezixlabs.bean.Widget widget:widgets){
        %>
        <a action="ColabopadApplication.newWidget(<%=widget.getId() %>,'rejected')" ><%=widget.getName() %></a>
        <%}%>
    </div>
    <div id="colabopad-menu-widget-aprWidgets" class="menu">
        <%
           widgets = com.feezixlabs.db.dao.WidgetDAO.getWidgets(request.getUserPrincipal().getName(),"prod");
           for(com.feezixlabs.bean.Widget widget:widgets){
        %>
        <a action="ColabopadApplication.newWidget(<%=widget.getId() %>,'prod')" ><%=widget.getName() %></a>
        <%}%>
    </div>
        -->
<%}%>

<%--if(request.isUserInRole("reviewer")){%>
    <div id="colabopad-menu-widget-widgetReviewQueue" class="menu">
        <%
           java.util.List<com.feezixlabs.bean.Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getWidgets("","queue");
           for(com.feezixlabs.bean.Widget widget:widgets){
        %>
        <a action="ColabopadApplication.newWidget(<%=widget.getId() %>,'queue')" ><%=widget.getName() %></a>
    <%}%>
    </div>
<%}--%>

