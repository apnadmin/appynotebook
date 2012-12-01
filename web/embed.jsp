<%-- 
    Document   : embed
    Created on : Mar 14, 2011, 6:51:23 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%--
    String isCreator = "false";
    java.util.Calendar cpYr = new java.util.GregorianCalendar();

    if(request.getParameter("action") != null && request.getParameter("action").compareToIgnoreCase("logout")==0){
        request.getSession().invalidate();
        response.sendRedirect("/index.jsp");
    }
 --%>

<html>
  <head>
    <title>Pad</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="icon" type="image/png" href="/favicon.png" />
    <script type="text/javascript" src="a1/secure_resource?r=js/LABjs-2.0.3/LAB.min.js"></script>
    <script type="text/javascript">
      var sessionId  = '<%=request.getSession().getId() %>';
      var my_pid = 0;
      var secure_token = ""
      <%

        //String[] pathInfo = request.getPathInfo().substring(1).split("/");//,<%=pathInfo[1]%
        request.setAttribute("urlPrefix","a1/secure_url_resource?r=");
      %>
      var room_id = 0;
      var user_id = 0;
      var room_access_code = '';
      var app_queue_url = '';
      var mouse_event_queue_url = 'dest.-msevnt';
      var amq = null;
      var jqready = false;
      var m_dependencies = 1;
      var isCreator= false;
      var current_tree_node = null;
      var baseUrl = "<%= com.feezixlabs.util.ConfigUtil.baseUrl %>";
      var env = "<%= com.feezixlabs.util.ConfigUtil.environment %>";
      
      var imageServiceUrl = "<%= com.feezixlabs.util.ConfigUtil.file_serving_url_prefix %>";
      var page_screen_mode = true;
    </script>


    <link type="text/css" href="/js/jquery-ui-1.9.1.custom/css/smoothness/jquery-ui-1.9.1.custom.css" rel="stylesheet" />
    <link href="a1/secure_resource?r=js/jquery/jquery.svg.package-1.4.5/jquery.svg.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" type="text/css" media="screen" href="/js/jquery-plugins/jquery.jqGrid-4.4.1/css/ui.jqgrid.css" />
    <link type="text/css" href="a1/secure_resource?r=css/notepad.css" rel="Stylesheet" />
    <link href='http://fonts.googleapis.com/css?family=Ubuntu+Condensed' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Gravitas+One|Varela' rel='stylesheet' type='text/css'>
    <!-- Bootstrap -->
    <!--
    <link href="/js/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    -->
    
    <!--JQ blockui -->
 
    <%--
    <script type="text/javascript" src="/js/jquery-ui-1.8.23.custom/js/jquery-1.6.2.min.js"></script>
    <script type="text/javascript" src="/js/jquery-ui-1.8.16.custom/js/jquery-ui-1.8.16.custom.min.js"></script>
    
    <script type="text/javascript" src="/js/jquery-plugins/blockui/jquery.blockUI.js"></script>
    
    <script type="text/javascript" src="a1/secure_resource?r=js/jquery/jquery.svg.package-1.4.4/jquery.svg.js"></script>
    <script src="/js/jquery-plugins/jquery.jqGrid-3.8.2/js/i18n/grid.locale-en.js" type="text/javascript"></script>
    <script src="/js/jquery-plugins/jquery.jqGrid-3.8.2/js/jquery.jqGrid.min.js" type="text/javascript"></script>
    --%>    
    
    
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
		width:8.5in;
                margin:0px;
                padding:0px;
    }
    .notepad {
		width:8.5in;
		height:11in;
		border-style:none/*dashed*/;
		border-width:1px;
                margin-left:2px;
      }

    </style>
    <script type="text/javascript" language="javascript">
        var ColabopadApplication={ContextMenus:null,MsgHandler:null,Utility:null,PageTemplate:null,importer:null};
    </script>
    <%--
    <script type="text/javascript" src="a1/secure_resource?r=js/core/util.js"></script>
    <script type="text/javascript" src="a1/secure_resource?r=js/core/msg.js"></script>
    <script type="text/javascript" src="a1/secure_resource?r=js/core/context-menus.js"></script>
    <script type="text/javascript" src="a1/secure_resource?r=js/core/templt.js"></script>
    <script type="text/javascript" src="a1/secure_resource?r=js/core/import.js"></script>
    <script type="text/javascript" src="a1/secure_resource?r=js/core/Widget.js"></script>
    --%>
    <script type="text/javascript" src="a1/secure_resource?r=js/all.js"></script>
    <script type="text/javascript" src="a1/secure_resource?r=js/core/colabopad.js"></script>
    <% 
        String embedCode = ("<div id=\"dock-" +request.getParameter("embed_key") +"\"></div><script type=\"text/javascript\" src=\""+com.feezixlabs.util.ConfigUtil.baseUrl+"/embed/"+request.getParameter("embed_key")+"?width="+Integer.parseInt(""+request.getParameter("width"))+"&height="+Integer.parseInt(""+request.getParameter("height")) +"\"></script>");//.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
        String fullScreenURL = "/sl/?ep="+request.getParameter("embed_key");
    %>
    <script language="javascript" type="text/javascript">

    $(document).ready(function(){
        //$.blockUI.defaults.applyPlatformOpacityRules = false;
        //$.blockUI({css:{},overlayCSS: { backgroundColor: '#666666',opacity:.98 },theme:true,message: '<h1><img src="../../img/busy.gif" />Loading ,please wait...</h1>'});
        loadApp();
        //initTouch2Mouse();
        $("#share-btn").button({
            icons: {
                primary: "ui-icon-carat-2-e-w"
            },
            text: false
        }).click(function(){
            $("#embed-code-dialog").dialog("open");
        });
        
        $("#fullscreen-btn").button({
            icons: {
                primary: "ui-icon-arrow-4-diag"
            },
            text: false
        })        
        
        
        $("#download-btn").button({
            icons: {
                primary: "ui-icon-arrowthickstop-1-s"
            },
            text: false
        }).click(function(){
            window.frames['saveAsSVGInterface'].sendSVG(ColabopadApplication.getCurrentContext().active_pad.svg_doc.toSVG());
        });        
        
 
        $("#embed-code-dialog").dialog(
        {
            autoOpen:false,
            modal:false,
            width:256,
            resizable: false
        }).siblings("div.ui-dialog-buttonpane").removeClass("ui-resizable").remove();
        
        
        /*
        var my = 'bottom left';
        var at = 'top right';        
        $('#share-btn-tip').qtip({
            content: {
                title:"Share embed code",
                text: '&lt;/script> </pre>'
            },
            style:{
                classes:'boost'
            },
            position: {
                my: my, // Use the corner...
                at: at // ...and opposite corner
            },
            show: {
                event: 'click' // Don't specify a show event...                
            },
            hide: false // Don't specify a hide event either!,
        });  */      
        //$("#share-btn").popover({"title":"Put this code on your site","placement":"top","content":"<%--=embedCode--%>"});
    });





    function debug(msg){
        if(ColabopadApplication.getEnv() == 'dev'){
            jQuery('#debug-output').css({display:'block'}).append('<span style="background-color:black;color:yellow">debug:<span style="color:#04fd33">'+msg+'</span></span><br/>');
        }
    }

    function log(msg){
        
        if(ColabopadApplication.getEnv() == 'dev'){
            jQuery('#debug-output').css({display:'block'}).append('<span style="background-color:black;color:yellow"><span style="color:#04fd33">'+msg+'</span></span><br/>');
        }
    }

    function applet_log(msg,env){
        if(env == 'dev' && ColabopadApplication.getEnv() == 'dev'){
            jQuery('#debug-output').css({display:'block'}).append('<span style="background-color:black;color:yellow"><span style="color:#04fd33">'+msg+'</span></span><br/>');
        }
    }

    function amqReady(amqq){
        loadApp();
    }

    function loadApp(){
        --m_dependencies;
        if(m_dependencies == 0)
            initApp(true,'<%=request.getParameter("embed_key")%>',<%=request.getParameter("width")%>,<%=request.getParameter("height")%>);
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

  </head>
  <body style="margin:0;padding:0px;background:none">
      <%--<script src="http://code.jquery.com/jquery-latest.js"></script>
      <script src="/js/bootstrap/js/bootstrap.min.js"></script>--%>
      <div id="debug-output" style="display:none;width:90%;border-style:solid;padding:1px;background:black;height:100px;overflow:auto"></div>
      <div class="ui-corner-bottom ui-widget-content" style="padding:0;margin:0;border-style:solid;border-width:4px;background-color:white;background-image:url(/img/sim-demo/tile4.png);background-repeat:repeat;height:<%=Integer.parseInt(request.getParameter("height"))-10 %>px;">
          <div id="embed-code-dialog" title="Embed Code" style="display:none;">
              <textarea style="width:100%;height:100%" rows="6"><%=embedCode%></textarea>
          </div> 
          
          
          <div id="embed-frame" style="height:<%=Integer.parseInt(request.getParameter("height"))-50 %>px;"><div id="tab-content-holder"></div></div>
            
          
          
           <%@include file="sc/nd/ui-component-markups/widget-ui.jsp" %>
           <%@include file="sc/nd/ui-component-markups/ui-holder.jsp" %>
           <div class="ui-corner-all" style="margin-left: 2px;margin-right: 2px;background: rgba(0,0,0,0.4) none;position:relative;z-index:10000000000;padding:3px;text-align: right">
               <div style="text-align:left;width:150px;float:left">
                   <a id="share-btn-tip" href="#"><button style="width:32px;height:32px" id="share-btn" class="btn btn-mini" title="Share code">Share code</button></a>
                   <a target="_blank" href="http://hadron.phyzixlabs.com<%=fullScreenURL%>"><button style="width:32px;height:32px" id="fullscreen-btn" class="btn btn-mini" title="Viewin full screen">View in fullscreen</button></a>
                   <button style="width:32px;height:32px" id="download-btn" class="btn btn-mini" title="Download">Download</button>
               </div>
               <div style="width:200px;float:right">
                  <a href="http://www.phyzixlabs.com" target="new window"> <img style="border:none" src="/img/phyzixlabs-embed-bk.png" alt="Powered by APPYnotebook"/></a>
               </div>
               <div style="clear:both"></div>
           </div>
      </div>
          <iframe style="position:absolute;left:-1000px" id="saveAsSVGInterface" name="saveAsSVGInterface" src="/util/submit-svg.jsp" width="0" height="0" scrolling="no"></iframe>

  </body>
</html>
