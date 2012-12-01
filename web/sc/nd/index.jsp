<%-- 
    Document   : index
    Created on : Apr 12, 2009, 8:26:17 PM
    Author     : bitlooter
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%
    String isCreator = "false";

    if(request.getParameter("action") != null && request.getParameter("action").compareToIgnoreCase("logout")==0){
        request.getSession().invalidate();
        response.sendRedirect("/");
    }
 %>

<html>
  <head>
    <title>APPYnotebook</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="icon" type="image/png" href="favicon.png" />

    
   <script type="text/javascript">
      var sessionId  = '<%=request.getSession().getId() %>';
      var my_pid = 0;
      var secure_token = "";
      var StripePublicKey = "<%=com.feezixlabs.util.ConfigUtil.stripe_public_key %>";
      <%
        String room_id = request.getParameter("room_id");
        int retryLimit = 10;
        int retries = 0;
        String landingPage = "";
        com.feezixlabs.bean.Room room = null;
        String accessCode = "";
        
        
        
        //if landing page is supplied
        String lpp = request.getSession().getAttribute("lp") != null?""+request.getSession().getAttribute("lp"): request.getParameter("lp");
        if(lpp != null){
            String[] lp = lpp.split("x");
            room_id = lp[0];
            if(lp.length>4)
                accessCode = lp[4];
            
            landingPage = "var appynoteLandingPage = {\"participant_id\":"+lp[1]+",\"context_id\":"+lp[2]+",\"page_id\":"+lp[3]+"};";
        }
        
        
        //System.out.println("lp:"+request.getSession().getAttribute("lp")+"/room_id:"+room_id);
        if(room_id == null || room_id.compareToIgnoreCase("default")==0 || !accessCode.isEmpty()){
          
          String pr = request.getSession().getAttribute("pr") != null?""+request.getSession().getAttribute("pr"): request.getParameter("pr");
          if(request.getSession().getAttribute("pr") != null)
                request.getSession().removeAttribute("pr");
            
          
          if(pr != null || !accessCode.isEmpty()){
             try{                 
                if(accessCode.isEmpty()){
                    room_id = pr.split("-")[0];
                    accessCode = pr.split("-")[1];
                }
                room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), new Integer(room_id));
                
                
                if(room == null){
                    com.feezixlabs.bean.Room roomExt = com.feezixlabs.db.dao.RoomDAO.getRoomExt(new Integer(room_id));
                    if(roomExt.getAccessControl() == 1 && roomExt.getAccessCode().compareToIgnoreCase(accessCode) == 0){                        
                        System.out.println(com.feezixlabs.struts.action.handler.UserActionHandler.addParticipant(request,request.getUserPrincipal().getName(),new Integer(room_id),true));
                        room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), new Integer(room_id)); 
                    }
                }
             }catch(Exception ex){
                 ex.printStackTrace();
             }
          }          
 
          if(room == null){
            java.util.List<com.feezixlabs.bean.Room> rooms = null;

            while(room == null && retries++ < retryLimit){
                rooms = com.feezixlabs.db.dao.RoomDAO.getRooms(request.getUserPrincipal().getName());
            }
            if(rooms != null && rooms.size()>0){
                room_id = ""+rooms.get(0).getId();
                room = rooms.get(0);
            }
          }
        }else{
            
            while(room == null && retries++ < retryLimit){
                room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), new Integer(room_id));
            }
            
            if(room == null){
              java.util.List<com.feezixlabs.bean.Room> rooms = com.feezixlabs.db.dao.RoomDAO.getRooms(request.getUserPrincipal().getName());
              if(rooms != null && rooms.size()>0){
                  room_id = ""+rooms.get(0).getId();
                  room = rooms.get(0);
              }
            }
        }

      %>
          
      var room_id = <%=room.getId() %>;
      var user_id = <%= com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName())%>;
      //var user_fullname = "<%= com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName()).getName().replaceAll("\"", "\\\"") %>";
      var room_access_code = '';
      var app_queue_url = 'dest.<%=room.getUserId()+"-"+room.getId() %>';
      var mouse_event_queue_url = 'dest.-msevnt';
      var amq = null;
      var jqready = false;
      var m_dependencies = 1;
      var isCreator= (<%=room.getUserId()%> == user_id);
      var isSysadmin = <%= request.isUserInRole("sysadmin") %>;
      var current_tree_node = null;
      var baseUrl = "<%= com.feezixlabs.util.ConfigUtil.baseUrl %>";
      var imageServiceUrl = "<%= com.feezixlabs.util.ConfigUtil.file_serving_url_prefix %>";
      var env = "<%= com.feezixlabs.util.ConfigUtil.environment %>";
      <% 
        String loadEmbededPage = request.getParameter("ep");
        if(loadEmbededPage == null)
            loadEmbededPage = request.getSession().getAttribute("ep") != null?""+request.getSession().getAttribute("ep"):null;
      %>
        <%=loadEmbededPage != null?"var load_embeded_page='"+loadEmbededPage+"';":"" %>

      function json_deref(obj){
          return obj;
      }
      var execute_scripts = false;
      var imports_loaded=0;
      var imports_requested=0;
      var imports_executed = 0;

      var page_screen_mode = <%= request.getParameter("psm") != null %>;
      <%=landingPage %>

      var text_editor_classid = "<%= com.feezixlabs.db.dao.MiscDAO.getTextData("rich-text-editor").getData() %>";
      var embeded_text_editor_classid = "<%= com.feezixlabs.db.dao.MiscDAO.getTextData("embeded-rich-text-editor-classid").getData() %>";
      var embeded_web_page_classid = "<%= com.feezixlabs.db.dao.MiscDAO.getTextData("embeded_web_page_classid").getData() %>";
    </script>
    <% 
        request.getSession().removeAttribute("lp");
        request.getSession().removeAttribute("pr");
        request.getSession().removeAttribute("room_id");
        request.getSession().removeAttribute("ao");
        request.getSession().removeAttribute("u");
        request.getSession().removeAttribute("p");
        request.getSession().removeAttribute("ep");
    %>
    <!--Main -->
    
    <%--
    <script type="text/javascript" src="js/LABjs-2.0.3/LAB.min.js"></script>
    <!--
    <link type="text/css" href="../../js/jquery-ui-1.7.2.custom/css/start/jquery-ui-1.7.2.custom.css" rel="stylesheet" />
    <script type="text/javascript" src="../../js/jquery-ui-1.7.2.custom/js/jquery-1.3.2.min.js"></script>
    <script type="text/javascript" src="../../js/jquery-ui-1.7.2.custom/js/jquery-ui-1.7.2.custom.min.js"></script>
    -->

    <!--
    <link type="text/css" href="../../js/jquery-ui-1.8.7.custom/css/start/jquery-ui-1.8.7.custom.css" rel="stylesheet" />
    <script type="text/javascript" src="../../js/jquery-ui-1.8.7.custom/js/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="../../js/jquery-ui-1.8.7.custom/js/jquery-ui-1.8.7.custom.min.js"></script>
    -->
    <!--Layout -->
    <!--<script type="text/javascript" src="../../js/jquery-plugins/layout/jquery.layout.min.js"></script>-->
    <!--<script type="text/javascript" src="../../js/jquery-plugins/jquery.layout-1.3/jquery.layout-latest.js"></script>-->
    <!-- JQ Tree control-->
    <!--
    <link href='../../js/jquery-plugins/dynatree-1.0.3/src/skin/ui.dynatree.css' rel='stylesheet' type='text/css'>
    <script src='../../js/jquery-plugins/dynatree-1.0.3/src/jquery.dynatree.min.js' type='text/javascript'></script>
    -->
    <!--
    <link href='../../js/jquery-plugins/dynatree-1.0.3/src/skin/ui.dynatree.css' rel='stylesheet' type='text/css'>
    <script src='../../js/jquery-plugins/dynatree-1.0.3/src/jquery.dynatree.js' type='text/javascript'></script>
    -->
    <!--
    <link href='../../js/jquery-plugins/dynatree-1.1.1/src/skin/ui.dynatree.css' rel='stylesheet' type='text/css'>
    <script src='../../js/jquery-plugins/dynatree-1.1.1/src/jquery.dynatree.js' type='text/javascript'></script>
    -->    
    
    <!--JQ Color --
    <script type="text/javascript" src="../../js/jquery-plugins/color.picker/ColorPicker.js"></script>
    

	<link rel="stylesheet" href="../../js/jquery-plugins/colorpicker/css/colorpicker.css" type="text/css" />
    <script type="text/javascript" src="../../js/jquery-plugins/colorpicker/js/colorpicker.js"></script>
    -->
    <!--
	
    <script type="text/javascript" src="../../js/jquery-plugins/colorpicker/js/eye.js"></script>

    <script type="text/javascript" src="../../js/jquery-plugins/colorpicker/js/utils.js"></script>
    
    <script type="text/javascript" src="../../js/jquery-plugins/colorpicker/js/layout.js?ver=1.0.2"></script>
    <link rel="stylesheet" media="screen" type="text/css" href="../../js/jquery-plugins/colorpicker/css/layout.css" />
    -->
    <!--
    <link type="text/css" rel="stylesheet" href="../../js/jquery-plugins/jquery.rte1_2/jquery.rte.css" />
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.rte1_2/jquery.rte.js"></script>
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.rte1_2/jquery.rte.tb.js"></script>
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.rte1_2/jquery.ocupload-1.1.4.js"></script>
    -->


    <!--
    <link href="jquery.svg.package-1.3.2/jquery.svg.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="jquery.svg.package-1.3.2/jquery.svg.js"></script>
    <script type="text/javascript" src="jquery.svg.package-1.3.2/jquery.svgplot.min.js"></script>
    -->
    <!--
    <link href="jquery.svg.package-1.4.0/jquery.svg.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="jquery.svg.package-1.4.0/jquery.svg.js"></script>
    <script type="text/javascript" src="jquery.svg.package-1.4.0/jquery.svgplot.min.js"></script>
    -->
    <!--
    <link href="js/jquery/jquery.svg/jquery.svg.package-1.4.2/jquery.svg.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="js/jquery/jquery.svg/jquery.svg.package-1.4.2/jquery.svg.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.svg/jquery.svg.package-1.4.2/jquery.svgplot.min.js"></script>
    -->    
    
    <!--
    <script type="text/javascript" src="js/jquery/jquery.svg.package-1.4.3/jquery.svgplot.min.js"></script>
    -->


    <!-- Image dropdown 
    <link rel="stylesheet" href="../../js/jquery-plugins/jquery-image-dropdown-2.1/msdropdown/dd.css" type="text/css" />
    
    <script type="text/javascript" src="../../js/jquery-plugins/jquery-image-dropdown-2.1/msdropdown/js/uncompressed.jquery.dd.js"></script>
    -->

    <!---
    <link href="../../js/jquery-plugins/treeTable/src/stylesheets/jquery.treeTable.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../js/jquery-plugins/treeTable/src/javascripts/jquery.treeTable.js"></script>
    -->    
    <!--
    <link rel="stylesheet" type="text/css" media="screen" href="../../js/jquery-plugins/fg-menu/theme/ui.all.css" />
    -->    
    
    <!--
    <link rel="stylesheet" type="text/css" media="screen" href="../../js/jquery-plugins/sticky/sticky.css" />
    <script src="../../js/jquery-plugins/sticky/jquery.easing.1.3.js" type="text/javascript"></script>
    <script src="../../js/jquery-plugins/sticky/stickysidebar.jquery.js" type="text/javascript"></script>
    -->
    <!--
    <script type="text/javascript" src="../../js/jquery-plugins/jquery-image-dropdown-2.1/msdropdown/js/jquery.dd.js"></script>
    -->
    <!--
    <script type="text/javascript" src="iColorPicker/js/iColorPicker.js"></script>
    -->    
    
     <!--
    <script type="text/javascript" src="../../js/prototype-debug.js"></script>
    <script type="text/javascript" src="../../amq/behaviour.js"></script>
    <script type="text/javascript" src="../../js/_amq-debug.js"></script>
    <script type="text/javascript">amq.uri='../../amq';</script>
    --> 

    <link rel='stylesheet' type='text/css' href='js/jquery/vitch-jScrollPane-ef5b8be/style/jquery.jscrollpane.css'/>
    <link rel='stylesheet' type='text/css' href='js/jquery/vitch-jScrollPane-ef5b8be/themes/lozenge/style/jquery.jscrollpane.lozenge.css'/>
    <script src="js/jquery/vitch-jScrollPane-ef5b8be/script/jquery.mousewheel.js" type="text/javascript"></script>
    <script src="js/jquery/vitch-jScrollPane-ef5b8be/script/mwheelIntent.js" type="text/javascript"></script>
    <script src="js/jquery/vitch-jScrollPane-ef5b8be/script/jquery.jscrollpane.js" type="text/javascript"></script>
    
    <link type="text/css" href="../../js/jquery-plugins/jquery.layout-1.3/rc29.15/layout-default-latest.css" rel="stylesheet" />
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.layout-1.3/rc29.15/jquery.layout-latest.js"></script>
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.layout-1.3/rc29.15/jquery.layout.callbacks-latest.js"></script>
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.layout-1.3/rc29.15/jquery.layout.resizeTabLayout-1.0.js"></script>
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.layout-1.3/rc29.15/jquery.layout.pseudoClose-1.0.js"></script>
    
    <script type="text/javascript" src="js/amq/stomple.js"></script>
    
    <script type="text/javascript" src="js/jquery/jquery.autoGrowInput/jquery.autoGrowInput.js"></script>
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.colorpicker/jquery.colorpicker.js"></script>
    
    <!--JQ Menu-->
    <link rel="stylesheet" type="text/css" href="../../js/jquery-plugins/jquery.mbMenu/css/menu.css" title="styles1"  media="screen" />
    <link rel="alternate stylesheet" type="text/css" href="../../js/jquery-plugins/jquery.mbMenu/css/menu1.css" title="styles2" media="screen" />
    
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.mbMenu/inc/jquery.metadata.js"></script>
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.mbMenu/inc/mbMenu.js"></script>
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.mbMenu/inc/styleswitch.js"></script>
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.mbMenu/inc/jquery.hoverIntent.js"></script>
    
    <!--QTip -->
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.qtip-1.0.0-rc3.custom/jquery.qtip-1.0.0-rc3.min.js"></script>
    --%>
    
    <!-- BEGINE JQUERY -->
    <!--<link type="text/css" href="../../js/jquery-ui-1.8.23.custom/css/smoothness/jquery-ui-1.8.23.custom.css" rel="stylesheet" />-->
    <link type="text/css" href="js/jquery-ui-1.9.1.custom/css/smoothness/jquery-ui-1.9.1.custom.css" rel="stylesheet" />
    
    <!--JQ Dynatree -->
    <link href='js/jquery-plugins/dynatree-1.2.2/src/skin/ui.dynatree.css' rel='stylesheet' type='text/css'>
    <!-- JQ Context -->
    <link href='js/jquery-plugins/jquery.contextMenu-1.01/jquery.contextMenu.css' rel='stylesheet' type='text/css'>
    <!-- JQ SVG -->
    <link href="js/jquery/jquery.svg.package-1.4.5/jquery.svg.css" rel="stylesheet" type="text/css">
    <!--jq grid-->
    <link rel="stylesheet" type="text/css" media="screen" href="js/jquery-plugins/jquery.jqGrid-4.4.1/css/ui.jqgrid.css" />
    <!--Filament group menus -->
    <link rel="stylesheet" type="text/css" media="screen" href="js/jquery-plugins/fg-menu/fg.menu.css" />

    <link href='js/jquery-plugins/medialize-jQuery-contextMenu-1326fb7/src/jquery.contextMenu.css' rel='stylesheet' type='text/css'>
    <!--<script type="text/javascript" src="../../js/jquery-plugins/medialize-jQuery-contextMenu-1326fb7/src/jquery.contextMenu.js"></script>-->
    
    
    <link type="text/css" href="css/notepad.css" rel="Stylesheet" />
    
    <%--
    <script type="text/javascript" src="../../js/jquery-ui-1.8.16.custom/js/jquery-1.6.2.min.js"></script>
    <script type="text/javascript" src="../../js/jquery-ui-1.8.16.custom/js/jquery-ui-1.8.16.custom.min.js"></script>

    <!--JQ blockui -->
    <script type="text/javascript" src="../../js/jquery-plugins/blockui/jquery.blockUI.js"></script>

    <!--JQ timepicker -->
    <script type="text/javascript" src="../../js/jquery-plugins/jquery-ui-timepicker-addon/jquery-ui-timepicker-addon.js"></script>

    <!--JQ Dynatree -->
    <script src='../../js/jquery-plugins/dynatree-1.2.0/src/jquery.dynatree.js' type='text/javascript'></script>  
    
    <!---JQ Context --->
    <script src='../../js/jquery-plugins/jquery.contextMenu-1.01/jquery.contextMenu.js' type='text/javascript'></script>
    <script src='../../js/jquery-plugins/jquery.contextMenu2/jquery.contextmenu.r2.js' type='text/javascript'></script>
    
    <!-- JQ SVG -->    
    <script type="text/javascript" src="../../js/jquery-plugins/jquery.svg.package-1.4.4/jquery.svg.js"></script>
    
    <!--jq grid-->    
    <script src="../../js/jquery-plugins/jquery.jqGrid-3.8.2/js/i18n/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery-plugins/jquery.jqGrid-3.8.2/js/jquery.jqGrid.min.js" type="text/javascript"></script>
    
    <!--Filament group menus -->    
    <script src="../../js/jquery-plugins/fg-menu/fg.menu.js" type="text/javascript"></script>
    
    <!--jq Scrollfollow -->
    <script src="../../js/jquery-plugins/jquery-scroll-follow-0.4.0/lib/jquery.scrollfollow.js" type="text/javascript"></script>
    
    <!--jq colorpicker -->
    <script type="text/javascript" src="../../js/jquery-plugins/colabopad.colorpicker/jquery.colabopadcolorpicker.js"></script>
    
    <!--jq json converter -->
    <script type="text/javascript" src="../../js/jquery-plugins/json-converter/jquery.json-1.3.js"></script>
    <!-- END JQUERY -->
    
    
    <script type="text/javascript" src="js/amq/amq_jquery_adapter.js"></script>
    <script type="text/javascript" src="js/amq/amq.js"></script>
    --%>
    
    

    <script type="text/javascript">
        var ColabopadApplication={ContextMenus:null,MsgHandler:null,Utility:null,PageTemplate:null};
    </script>
    <script type="text/javascript" src="js/all.js"></script>
    
    <%--
    <script type="text/javascript" src="js/core/util.js"></script>
    <script type="text/javascript" src="js/core/msg.js"></script>
    <script type="text/javascript" src="js/core/app-callback-interface.js"></script>
    <script type="text/javascript" src="js/core/context-menus.js"></script>
    <script type="text/javascript" src="js/core/templt.js"></script>
    <script type="text/javascript" src="js/core/import.js"></script>
    <script type="text/javascript" src="js/core/Widget.js"></script>
    --%>
    <script type="text/javascript" src="js/core/colabopad.js"></script>

    <!--
    <script type="text/javascript" src="https://js.stripe.com/v1"></script>
    -->
    
    <style type="text/css">

    .np-cursor-freehand{
        cursor:url(images/cursors/pencil.png), auto;
    }
    .np-cursor-freehand-bb{
        cursor:url(images/cursors/pencil-bb.png), auto;
    }

    .np-cursor-eraser{
        cursor:url(images/cursors/eraser-cursor.png), auto;
    }
    .np-cursor-text{
        cursor:text;
    }

    .np-cursor-rect{
        cursor:crosshair;
    }
    .np-cursor-circle{
        cursor:crosshair;
    }
    .np-cursor-line{
        cursor:crosshair;
    }
    .np-cursor-image{
        cursor:url(images/cursors/image-mode-cursor.png), auto;
    }

    .np-cursor-move{
        cursor:url(images/cursors/move-cursor.png), auto;
    }
    .np-cursor-fill{
        cursor:url(images/cursors/fill-cursor.png), auto;
    }
    .np-cursor-rotate{
        cursor:crosshair;
    }
    .np-cursor-pointer{
        cursor:default;
    }
    .np-cursor-resize{
        cursor:se-resize;
    }
    .np-cursor-richtext{
        cursor:url(images/cursors/rich-text-cursor.png), auto;
    }
    .dock{
		min-width:8.5in;
                margin:0px;
                padding:0px;
                
    }
    .texteditor-content {
        word-wrap:break-word;
    }
    .notepad {
		min-width:8.5in;
		/*min-height:11in;*/
		border-style:none;
		border-width:1px;
                margin-left:2px;
      }
    .notepad-text-editor {
		border-style:solid;
		border-width:1px;
                border-color: silver;
                margin:0;
                padding: 0;
      }
      .txt-inputer{border-style:dotted}

      
      button.toolbar-button {}
      button.menu-button{width:150px;vertical-align:middle}


      #participants-header {
                              list-style-type:none;
                              height:97.7%;                             
                              background:none;
                              background-color:#ffffff;
                              margin:0;
                              padding:5px;
                             }
      h3#participants-header-label {margin:0; color:black; }
      ul#participants {}

      /*#participant-treecontrol {color:black;background:none}*/
      .roomTitle {font-weight:bold}


       span.phyzixlabs-room-teamspace.dynatree-ico-cf span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/applications-other.png");
       }
       span.phyzixlabs-room-teamspace.dynatree-ico-ef span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/applications-other.png");
       }

       span.phyzixlabs-room-teamspace-binder.dynatree-ico-cf span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/aiksaurus.png");
       }
       span.phyzixlabs-room-teamspace-binder.dynatree-ico-ef span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/aiksaurus.png");
       }


       span.phyzixlabs-room-assignment-root.dynatree-ico-cf span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/stock_task-assigned-to.png");
       }
       span.phyzixlabs-room-assignment-root.dynatree-ico-ef span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/stock_task-assigned-to.png");
       }

       span.phyzixlabs-room-assignment.dynatree-ico-cf span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("../appbuilder/img/folder.png");
       }
       span.phyzixlabs-room-assignment.dynatree-ico-ef span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("../appbuilder/img/folder-open.png");
       }

       span.phyzixlabs-room-assignment-submitted.dynatree-ico-cf span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/stock_task-assigned.png");
       }
       span.phyzixlabs-room-assignment-submitted.dynatree-ico-ef span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/stock_task-assigned.png");
       }

       span.phyzixlabs-room-assignment-submission.dynatree-ico-cf span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/assignment-ungraded.png");
       }
       span.phyzixlabs-room-assignment-submission.dynatree-ico-ef span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/assignment-ungraded.png");
       }
       span.phyzixlabs-room-assignment-submission-graded.dynatree-ico-cf span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/assignment-graded.png");
       }
       span.phyzixlabs-room-assignment-submission-graded.dynatree-ico-ef span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/misc/assignment-graded.png");
       }




       span.vroomtitle span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/edutainment.png");
       }

       span.phyzixlabs-room-inactive span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/edutainment.png");
       }

       span.catalog_node span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/misc/system-file-manager.png");
       }
       span.my_catalog_node span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/misc/applications-office.png");
       }

       span.cart_node span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/misc/cart.png");
       }
       span.catalog_subject_node span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/misc/folder.png");
       }
       span.catalog_topic_node span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/misc/gnome-blog.png");
       }
       span.catalog_page_node span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/misc/alacarte.png");
       }

       span.phyzixlabs-room-root span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/misc/start-here.png");
       }



       .style a{
          color:gray;
          font-family:sans-serif;
          font-size:13px;
          text-decoration:none;
        }

       span.onlineperson a
       {
           
       }
       
       span.onlineperson span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/online_person.png");
       }
       span.onlineperson-nf span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/online_person.png");
       }

       span.creatoronlineperson a
       {
          font-style:italic;
          color:blue;
          font-weight:bold;
       }

       span.creatoronlineperson span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/online_person.png");
       }

       span.selfonlineperson a
       {
          font-style:italic;
          color:blue;
          font-weight:bold;
       }

       span.selfonlineperson span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/online_person.png");
       }

       span.onlineperson-creator-cp span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/online_person.png");
       }
       span.onlineperson-creator-cp-nf span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/online_person.png");
       }

       span.offlineperson-creator-cp span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/offline_person.png");
       }

       



       span.offlineperson a
       {
            
       }

       span.offlineperson span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/offline_person.png");
       }

       /*span.docnode a
       {

       }

       span.docnode span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/gnome-blog.png");
       }*/


       span.docnode.dynatree-ico-cf span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/work-bench/gnome-blog.png");
       }
       span.docnode.dynatree-ico-ef span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/work-bench/gnome-blog.png");
       }

       span.fdocnode.dynatree-ico-cf span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/work-bench/gnome-blog.png");
       }
       span.fdocnode.dynatree-ico-ef span.dynatree-icon
       {
            background-position: 0 0;
            background-image: url("images/work-bench/gnome-blog.png");
       }
       /*span.fdocnode a
       {

       }

       span.fdocnode span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/gnome-blog.png");
       }*/

       span.padnode a
       {

       }

       span.padnode span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/alacarte.png");
       }

       span.padnode0 a
       {

       }

       span.padnode0 span.dynatree-icon
       {
           background-position: 0 0;
            background-image: url("images/work-bench/alacarte.png");
       }
       #colabopadMenus ul li {cursor:default}
	#toolbar {
		padding: 10px 4px;
	}
        ul.dynatree-container {border:none}
        #ide-header h1 {
	text-align: center;
	margin: auto;
	font-family:Courier;	
	color: #3cb2ec;
        }
        .signup-label{
            text-align:right;
            background-color:#f6f6f6;
        }

        /* css for timepicker */
        .ui-timepicker-div .ui-widget-header { margin-bottom: 8px; }
        .ui-timepicker-div dl { text-align: left; }
        .ui-timepicker-div dl dt { height: 25px; margin-bottom: -25px; }
        .ui-timepicker-div dl dd { margin: 0 10px 10px 65px; }
        .ui-timepicker-div td { font-size: 90%; }
        .ui-tpicker-grid-label { background: none; border: none; margin: 0; padding: 0; }

    </style>




    <script language="javascript" type="text/javascript">
      /**
      function include_dom(id, env) {
         var html_doc = document.getElementsByTagName('head').item(0);
         var js = document.createElement('script');
         js.setAttribute('language', 'javascript');
         js.setAttribute('type', 'text/javascript');

         if(env != undefined)
            js.setAttribute('src', 'widgets/getwidget.jsp?id='+id+'&env='+env+'&ts='+(new Date().getTime()));
        else
            js.setAttribute('src', 'widgets/getwidget.jsp?id='+id+'&ts='+(new Date().getTime()));

         html_doc.appendChild(js);
         return false;
     }
     **/

        
    $(document).ready(function(){
        $.blockUI.defaults.applyPlatformOpacityRules = false;
        $.blockUI({css:{},overlayCSS: { backgroundColor: '#666666',opacity:.98 },theme:false,message: '<h1><img src="images/misc/busy.gif" />Loading ,please wait...<button style="visibility:hidden" id="flash-cancel-button">Cancel</button></h1> '});
        $('#flash-hider').css("display","block");

        ColabopadApplication.ContextMenus.show_bindTeamSpaceContextMenu = (<%=room.getUserId()%> == user_id);
         

          
    	  $('.fg-button').hover(
    		function(){ $(this).removeClass('ui-state-default').addClass('ui-state-focus'); },
    		function(){ $(this).removeClass('ui-state-focus').addClass('ui-state-default'); }
    	  );
          loadApp();
          //initTouch2Mouse();
            $('#flash-cancel-button').button({
                    text: false,
                    icons: {
                            primary: "ui-icon-cancel"
                    }
            }).click(function(){
                ColabopadApplication.forceReady();
            });
            setTimeout(function(){
                $('#flash-cancel-button').css("visibility","visible");
            },5000);
    });
    




    function debug(msg){
        if(ColabopadApplication.getEnv() == 'dev' && typeof phyzixlabs_database == "undefined"){
            jQuery('#debug-output').css({display:'block'}).append('<span style="background-color:black;color:yellow">debug:<span style="color:#04fd33">'+msg+'</span></span><br/>');
        }
    }

    window.log = function (msg){
        if(ColabopadApplication.getEnv() == 'dev' && typeof phyzixlabs_database == "undefined"){
            jQuery('#debug-output').css({display:'block'}).append('<span style="background-color:black;color:yellow"><span style="color:#04fd33">'+msg+'</span></span><br/>');
        }
    };

    window.applet_log = function(msg,env){
        if(env == 'dev' && typeof phyzixlabs_database == "undefined"){
            jQuery('#debug-output').css({display:'block'}).append('<span style="background-color:black;color:yellow"><span style="color:#04fd33">'+msg+'</span></span><br/>');
        }
    };

    function debug1(msg){
       // jQuery('#debug-output1').css({display:'block'}).html('<textarea readonly cols="256" rows="16">'+msg+'</textarea><br/>');
    }
    function debug2(msg){
       // jQuery('#debug-output2').css({display:'block'}).html('<textarea readonly cols="256" rows="16">'+msg+'</textarea><br/>');
    }

    function showAbout(){
        jQuery('#about-dialog').dialog("open")
    }
    function showHelp(){
        window.open('help/app-help.jsp','helpwindowx','location=no,toolbar=no,scrollbars=yes,directories=no,menubar=no,status=no,copyhistory=no,resizable=yes');
    }
    function showDevHelp(){
        window.open('help/dev/dev-help.jsp','helpwindowx','location=no,toolbar=no,scrollbars=yes,directories=no,menubar=no,status=no,copyhistory=no,resizable=yes');
    }

    function loadApp(){
        --m_dependencies;
        if(m_dependencies == 0)
            initApp(false);
    }


    function touchHandler(event)
    {
        var touches = event.changedTouches,
            first = touches[0],
            type = "";

             switch(event.type)
        {
            case "touchstart": type = "mousedown"; break;
            case "touchmove":  type="mousemove"; break;
            case "touchend":   type="mouseup"; break;
            default: return;
        }

                 //initMouseEvent(type, canBubble, cancelable, view, clickCount,
        //           screenX, screenY, clientX, clientY, ctrlKey,
        //           altKey, shiftKey, metaKey, button, relatedTarget);

        var simulatedEvent = document.createEvent("MouseEvent");
        simulatedEvent.initMouseEvent(type, true, true, window, 1,
                                  first.screenX, first.screenY,
                                  first.clientX, first.clientY, false,
                                  false, false, false, 0/*left*/, null);

                                                                                     first.target.dispatchEvent(simulatedEvent);
        event.preventDefault();
    }

    function initTouch2Mouse()
    {
        document.addEventListener("touchstart", touchHandler, true);
        document.addEventListener("touchmove", touchHandler, true);
        document.addEventListener("touchend", touchHandler, true);
        document.addEventListener("touchcancel", touchHandler, true);
    }
    </script>

<style type="text/css">
    .fg-button {
       outline: 0;
       /*margin:0 0 0 0;*/
       /*padding: .1em .2em;*/
       text-decoration:none !important;
       cursor:pointer;
       position: relative;
       text-align: center;
       zoom:1;
       }
	.fg-button { outline: 0;/* margin:0 4px 0 0; padding: .4em 1em;*/ text-decoration:none !important; cursor:pointer; position: relative; text-align: center; zoom: 1; }
	.fg-button .ui-icon { position: absolute; top: 50%; margin-top: -8px; left: 50%; margin-left: -8px; }

	a.fg-button { float:left; }

	/* remove extra button width in IE */
	button.fg-button { width:auto; overflow:visible; }

	.fg-button-icon-left { padding-left: 2.1em; }
	.fg-button-icon-right { padding-right: 2.1em; }
	.fg-button-icon-left .ui-icon { right: auto; left: .2em; margin-left: 0; }
	.fg-button-icon-right .ui-icon { left: auto; right: .2em; margin-left: 0; }

	.fg-button-icon-solo { display:block; width:8px; text-indent: -9999px; }	 /* solo icon buttons must have block properties for the text-indent to work */

	.fg-buttonset { /*float:left;*/ }
	.fg-buttonset .fg-button { /*float: left;*/ }
	.fg-buttonset-single .fg-button,
	.fg-buttonset-multi .fg-button { margin-right: -1px;}

	.fg-toolbar { padding: .5em; margin: 0;  }
	.fg-toolbar .fg-buttonset { margin-right:1.5em; padding-left: 1px; }
	.fg-toolbar .fg-button { font-size: 1em;  }

    #floating-toolbox-toolbar ul li {padding:0;margin:0}
    #floating-toolbox-toolbar ul li button {width:22px;text-align:center}

    img.ui-icon{
        height:16px;
        width:16px;
        position:relative;
        display:inline;
    }
</style>



<style>
    #participantMenu {
        background:#FFF;
        border:1px solid #444;
        display:none;
        width:150px;
    }

    #participantMenu ul, #participantMenu ul * {
        padding:0;
        margin:0;
    }

    #participantMenu ul li{
        list-style:none;
        border:1px solid #444;
        padding: 5px;
        display:block;
    }

    #participantMenu ul li:hover{
        background:#666;
        color:#FFF;
    }

    #participantMenu ul li:hover span{
        color:#FFF;
    }

    #participantMenu li:hover a{
        color:#FFF;
    }

    #participantMenu a{
        color:#000;
        font:11px Tahoma;
        font-weight:bold;
        text-decoration:none;
    }
    .hidden { position:absolute; top:0; left:-9999px; width:1px; height:1px; overflow:hidden; }
    .ui-layout-west {
        background: url("image/misc/bg_dotted.png")  !important;
    }
    .ui-layout-center {
        background: url("image/misc/bg_dotted.png")  !important;
    }
    .error-blinkable-active {text-decoration:blink;color:red}
    
     /* force a height so the tabs don't jump as content height changes */
    #participant-tabcontrol .tabs-spacer { float: left; height: 200px; }
    .tabs-bottom .ui-tabs-nav { clear: left; padding: 0 .2em .2em .2em; }
    .tabs-bottom .ui-tabs-nav li { top: auto; bottom: 0; margin: 0 .2em 1px 0; border-bottom: auto; border-top: 0; }
    .tabs-bottom .ui-tabs-nav li.ui-tabs-active { margin-top: -1px; padding-top: 1px; }    
</style>


<!---->
<script type="text/javascript">

    var ddmenu = false;
	jQuery(function(){
		//all hover and click logic for buttons
		jQuery(".fg-button:not(.ui-state-disabled)")
		.hover(
			function(){
				jQuery(this).addClass("ui-state-hover");
			},
			function(){
				jQuery(this).removeClass("ui-state-hover");
			}
		)
		.mousedown(function(){
				jQuery(this).parents('.fg-buttonset-single:first').find(".fg-button.ui-state-active").removeClass("ui-state-active");
				if( jQuery(this).is('.ui-state-active.fg-button-toggleable, .fg-buttonset-multi .ui-state-active') ){ jQuery(this).removeClass("ui-state-active"); }
				else { jQuery(this).addClass("ui-state-active"); }
		})
		.mouseup(function(){
			if(! jQuery(this).is('.fg-button-toggleable, .fg-buttonset-single .fg-button,  .fg-buttonset-multi .fg-button') ){
				jQuery(this).removeClass("ui-state-active");
			}
		});

        jQuery('#colabopadMenus li').hover(
			function(){
				//$(this).addClass("ui-state-hover");
                jQuery(this).css("color","blue");
			},
			function(){
				//$(this).removeClass("ui-state-hover");
                jQuery(this).css("color","black");
			}
		);
	});

</script>


    <script type="text/javascript">



        var room_count = 0;
        function validate(){
            if($('#roomLabel').attr("value") != ''){
                return true;
            }
            alert('Please fill-out all required fields')
            return false;
        }
        function launchDevIDE(){
            window.open('../appbuilder/index.jsp','devpadwindowx','location=no,toolbar=no,directories=no,menubar=no,status=no,copyhistory=no,resizable=yes');
        }

        function openRoom(room_id){
            window.location.href = 'index.jsp?room_id='+room_id,'notepadwindow'+room_id+'&ts'+new Date().getTime();
            //window.open('index.jsp?room_id='+room_id,'notepadwindow'+room_id,'location=no,toolbar=no,directories=no,menubar=no,status=no,copyhistory=no,resizable=yes');
        }
    </script>
</head>
<% 
    String bodyStyle = "background: url(images/misc/bg_dotted.png);margin:0;padding:0;overflow:hidden";
    if(request.getParameter("psm") != null)
        bodyStyle = "padding:0;margin:0;background:none";

%>
  <body style="<%=bodyStyle%>">
      <div id="main-overlay" class="ui-widget-overlay" style="border-style:none;margin:0;padding:0">
          <div id="flash-hider" style="display:none;border-style:none;margin:0;padding:0">
                <%@include  file="base-page.jsp" %>
                
                <div id="application-footer" class="ui-widget-header ui-corner-bottom" style="display:none;text-align:center;margin:3px;padding-top: 10px;height:20px">
                    <a href="http://www.appynote.com/dev" target="_blank">developers</a> | <a href="../../terms/" target="_blank">terms</a> | <a href="../../privacy/" target="_blank">privacy</a>  &copy; <script type="text/javascript">document.write(new Date().getFullYear());</script> APPYnotebook Software
                </div>
          </div>
      </div>
  </body>
</html>
