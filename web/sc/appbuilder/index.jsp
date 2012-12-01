<%-- 
    Document   : index
    Created on : Aug 20, 2009, 9:55:06 AM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%
    String tox = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName()).getDevToxonomy();
    if(tox == null || tox.length() == 0)
        com.feezixlabs.struts.action.handler.UserActionHandler.loadDevSamples(request.getUserPrincipal().getName());
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>APPYnotebook APP Builder</title>

        <link rel="icon" type="image/png" href="../../favicon.png" />

        <!--Main -->

        <!--
        <link type="text/css" href="../../js/jquery-ui-1.8.16.custom/css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
        <script type="text/javascript" src="../../js/jquery-ui-1.8.16.custom/js/jquery-1.6.2.min.js"></script>
        <script type="text/javascript" src="../../js/jquery-ui-1.8.16.custom/js/jquery-ui-1.8.16.custom.min.js"></script>
        -->
        <link type="text/css" href="../../js/jquery-ui-1.8.23.custom/css/smoothness/jquery-ui-1.8.23.custom.css" rel="stylesheet" />
        <script type="text/javascript" src="../../js/jquery-ui-1.8.23.custom/js/jquery-1.8.0.min.js"></script>
        <script type="text/javascript" src="../../js/jquery-ui-1.8.23.custom/js/jquery-ui-1.8.23.custom.min.js"></script>
        

        <link type="text/css" href="js/layout-default-latest.css" rel="stylesheet" />
        <script type="text/javascript" src="js/jquery.layout-latest.js"></script>

        <!--JQ blockui -->
        <script type="text/javascript" src="../../js/jquery-plugins/blockui/jquery.blockUI.js"></script>

        <%--
        <!--JQ Menu-->
        <script type="text/javascript" src="../../js/jquery-plugins/jquery.mbMenu/inc/jquery.metadata.js"></script>
        <script type="text/javascript" src="../../js/jquery-plugins/jquery.mbMenu/inc/mbMenu.js"></script>
        <script type="text/javascript" src="../../js/jquery-plugins/jquery.mbMenu/inc/styleswitch.js"></script>
        <script type="text/javascript" src="../../js/jquery-plugins/jquery.mbMenu/inc/jquery.hoverIntent.js"></script>
        <link rel="stylesheet" type="text/css" href="../../js/jquery-plugins/jquery.mbMenu/css/menu.css" title="styles1"  media="screen" />
        <link rel="alternate stylesheet" type="text/css" href="../../js/jquery-plugins/jquery.mbMenu/css/menu1.css" title="styles2" media="screen" />
        --%>

        <!--JQ Grid -->
        <!--
        <link rel="stylesheet" type="text/css" media="screen" href="../../js/jquery-plugins/jquery.jqGrid-3.8.2/css/ui.jqgrid.css" />
        <script src="../../js/jquery-plugins/jquery.jqGrid-3.8.2/js/i18n/grid.locale-en.js" type="text/javascript"></script>
        <script src="../../js/jquery-plugins/jquery.jqGrid-3.8.2/js/jquery.jqGrid.min.js" type="text/javascript"></script>
        -->
        <link rel="stylesheet" type="text/css" media="screen" href="../../js/jquery-plugins/jquery.jqGrid-4.4.1/css/ui.jqgrid.css" />
        <script src="../../js/jquery-plugins/jquery.jqGrid-4.4.1/js/i18n/grid.locale-en.js" type="text/javascript"></script>
        <script src="../../js/jquery-plugins/jquery.jqGrid-4.4.1/js/jquery.jqGrid.min.js" type="text/javascript"></script>
        

        <!-- JQ Tree control-->
        <!--JQ Dynatree -->
        <link href='../../js/jquery-plugins/dynatree-1.2.2/src/skin/ui.dynatree.css' rel='stylesheet' type='text/css'>
        <script src='../../js/jquery-plugins/dynatree-1.2.2/src/jquery.dynatree.js' type='text/javascript'></script>

        
        <!--JEditable -->
        <%--
        <script src='../../js/jquery-plugins/jquery.jeditable/jquery.jeditable.js' type='text/javascript'></script>
        --%>

        <!-- JQ Context --->
        <%--
        <script src='../../js/jquery-plugins/jquery.contextMenu-1.01/jquery.contextMenu.js' type='text/javascript'></script>
        <link href='../../js/jquery-plugins/jquery.contextMenu-1.01/jquery.contextMenu.css' rel='stylesheet' type='text/css'>
        --%>
        
        <link href='../../js/jquery-plugins/medialize-jQuery-contextMenu-1326fb7/src/jquery.contextMenu.css' rel='stylesheet' type='text/css'>
        <script type="text/javascript" src="../../js/jquery-plugins/medialize-jQuery-contextMenu-1326fb7/src/jquery.contextMenu.js"></script>


        <%--
        <link type="text/css" rel="stylesheet" href="../../js/jquery-plugins/jquery.rte1_2/jquery.rte.css" />
        <script type="text/javascript" src="../../js/jquery-plugins/jquery.rte1_2/jquery.rte.js"></script>
        <script type="text/javascript" src="../../js/jquery-plugins/jquery.rte1_2/jquery.rte.tb.js"></script>
        <script type="text/javascript" src="../../js/jquery-plugins/jquery.rte1_2/jquery.ocupload-1.1.4.js"></script>
        --%>
        
        <link type="text/css" rel="stylesheet" href="js/CodeMirror-2.23/lib/codemirror.css" />
        <script src="js/CodeMirror-2.23/lib/codemirror.js" type="text/javascript"></script>
        
        
        <script src="js/CodeMirror-2.23/mode/javascript/javascript.js" type="text/javascript"></script>
        <script src="js/CodeMirror-2.23/mode/css/css.js" type="text/javascript"></script>
        <script src="js/CodeMirror-2.23/mode/htmlmixed/htmlmixed.js" type="text/javascript"></script>
        <script src="js/CodeMirror-2.23/mode/xml/xml.js" type="text/javascript"></script>
        
        <script src="js/core/core.js" type="text/javascript"></script>
        <style type="text/css">
           body{ /*font: 62.5% ; margin: 10px;*/font-family:Droid Sans, Arial,"Trebuchet MS", sans-serif; line-height: 1.5;margin-top:0;padding-top:0}
           .CodeMirror {font-size:2em;border: 1px solid #eee;position:relative;float:left;background: white;}
           .CodeMirror-scroll {height:auto}
           
           .ui-layout-pane {
                padding: 0px !important;
            }           
           
           span.devWidgetListHeader{color:blue;}
           span.devWidgetListHeader span.ui-dynatree-icon
           {
                background-image: url("img/stock_folder-properties.png");                
           }


           span.pendingWidgetListHeader{color:orange;}
           span.pendingWidgetListHeader span.ui-dynatree-icon
           {
                background-image: url("img/stock_folder-properties.png");
                
           }

           span.rejectedWidgetListHeader{color:red;}
           span.rejectedWidgetListHeader span.ui-dynatree-icon
           {
                background-image: url("img/stock_folder-properties.png");

           }

           span.prodWidgetListHeader{color:lime;}
           span.prodWidgetListHeader span.ui-dynatree-icon
           {
                background-image: url("img/stock_folder-properties.png");

           }

           span.phyzixlabs-applet-category-root a
           {
                background-color: #ffffbb;
                color: maroon;
           }
           span.phyzixlabs-applet-category-root span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/home.png");
           }

           span.phyzixlabs-applet-category.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder.png");
           }
           span.phyzixlabs-applet-category.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-open.png");
           }




           span.phyzixlabs-applet-reviewqueue.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-move.png");
           }
           span.phyzixlabs-applet-reviewqueue.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-move.png");
           }
           span.phyzixlabs-applet-list-submitted.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-move.png");
           }
           span.phyzixlabs-applet-list-submitted.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-move.png");
           }
           span.phyzixlabs-applet-list-prod.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-move.png");
           }
           span.phyzixlabs-applet-list-prod.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-move.png");
           }
           span.phyzixlabs-applet-list-rejected.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-move.png");
           }
           span.phyzixlabs-applet-list-rejected.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-move.png");
           }


           


           span.phyzixlabs-resource-dir.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder.png");
           }
           span.phyzixlabs-resource-dir.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-open.png");
           }
           span.phyzixlabs-resource-root.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder.png");
           }
           span.phyzixlabs-resource-root.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-open.png");
           }


           
           span.phyzixlabs-data-instance-definition-root.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder.png");
           }
           span.phyzixlabs-data-instance-definition-root.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-open.png");
           }           
           span.phyzixlabs-data-instance-definition.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder.png");
           }
           span.phyzixlabs-data-instance-definition.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-open.png");
           }           
           
           
           span.phyzixlabs-system-applet-category.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/system-category-folder.png");
           }
           span.phyzixlabs-system-applet-category.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/system-category-folder-open.png");
           }

           span.phyzixlabs-applet  span.dynatree-icon  /* Collapsed Folder */
           {
                background-position: 0 0;
                background-image: url("img/applet-folder.png");
           }
           
           span.phyzixlabs-applet-reviewqueue-applet  span.dynatree-icon  /* Collapsed Folder */
           {
                background-position: 0 0;
                background-image: url("img/applet-folder.png");
           }           
           
           span.phyzixlabs-applet-list-submitted-applet  span.dynatree-icon  /* Collapsed Folder */
           {
                background-position: 0 0;
                background-image: url("img/applet-folder.png");
           }        
           
           span.phyzixlabs-prod-applet  span.dynatree-icon  /* Collapsed Folder */
           {
                background-position: 0 0;
                background-image: url("img/applet-folder.png");
           }           
           /*
           span.phyzixlabs-applet.dynatree-ico-ef span.dynatree-icon  /* Expanded Folder *
           {
                background-position: 0 0;
                background-image: url("img/applet-folder.png");
           }*/
           span.phyzixlabs-applet-code span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/applet.png");
           }
           
           span.phyzixlabs-system-root span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/system-admin.png");
           }
           /***
           span.phyzixlabs-system-root.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder.png");
           }
           span.phyzixlabs-system-root.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/folder-open.png");
           }
           ***/



           span.phyzixlabs-system-library-root span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/user-share.png");
           }
           span.phyzixlabs-system-package-root span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/package-root.png");
           }
           span.phyzixlabs-system-package span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/package.png");
           }
           span.phyzixlabs-system-toxonomy span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/toxonomy.png");
           }
           span.phyzixlabs-system-library-dir.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/system-category-folder.png");
           }
           span.phyzixlabs-system-library-dir.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/system-category-folder-open.png");
           }


           span.phyzixlabs-deployed-system-applet-category-root span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/bin.png");
           }
           span.phyzixlabs-deployed-system-applet-category.dynatree-ico-cf span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/system-category-folder.png");
           }
           span.phyzixlabs-deployed-system-applet-category.dynatree-ico-ef span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/system-category-folder-open.png");
           }
           span.phyzixlabs-deployed-applet span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/applet.png");
           }
           span.phyzixlabs-system-user-root span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/users.png");
           }
           span.phyzixlabs-system-settings-root span.dynatree-icon
           {
                background-position: 0 0;
                background-image: url("img/apacheconf.png");
           }




           span.widgetListHeader span.ui-dynatree-icon
           {
                background-image: url("img/stock_folder-properties.png");

           }

           span.widgetTreeHeader span.ui-dynatree-icon
           {
                background-image: url("img/gnome-desktop-config.png");

           }

           span.widgetnode span.ui-dynatree-icon
           {
                background-image: url("img/bonobo-component-browser.png");
           }
           span.devwidgetnode span.ui-dynatree-icon
           {
                background-image: url("img/bonobo-component-browser.png");
           }
           span.queuewidgetnode span.ui-dynatree-icon
           {
                background-image: url("img/bonobo-component-browser.png");
           }
           span.pendingwidgetnode span.ui-dynatree-icon
           {
                background-image: url("img/bonobo-component-browser.png");
           }
           span.rejectedwidgetnode span.ui-dynatree-icon
           {
                background-image: url("img/bonobo-component-browser.png");
           }
           span.prodwidgetnode span.ui-dynatree-icon
           {
                background-image: url("img/bonobo-component-browser.png");
           }
          .CodeMirror-line-numbers {
            width: 2.2em;
            color: #aaa;
            background-color: #eee;
            text-align: right;
            padding-right: .3em;
            font-size: 10pt;
            font-family: monospace;
            padding-top: .4em;
          }
          
             .ui-layout-north {
                background: url("../../img/bg_dotted.png")  !important;
            }         
            .ui-layout-west {
                background: url("../../img/bg_dotted.png")  !important;
            }
            .ui-layout-center {
                background: url("../../img/bg_dotted.png")  !important;
            }
        .signup-label{
            text-align:right;
            background-color:#f6f6f6;
            font-weight: bold;
        }
        </style>

<!--
<style type="text/css">
    .fg-button {
       outline: 0;
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
        .signup-label{            
            text-align:right;
            background-color:#f6f6f6;
        }
        ul.dynatree-container {border:none}
</style>
-->
        <script type="text/javascript">

            var widgetaction = "new";
            menu_editor_init = false;
            var rejecteddtnode = null;
            var uninitialized_editors = [];
            var open_resources = [];
            var widgets_for_packaging = {};
            var current_widget_to_package = null;
            var selected_widgets_for_packaging = [];
            var available_packages = [];
            var current_package    = null;
            var current_tree_node = null;
            var open_pkg_tabs=[];
            var selected_context_menu_action = null;
            var help_url = "<%=com.feezixlabs.util.ConfigUtil.hadron_help_url %>";

            $(document).ready(function(){
                  appletBuilder.jqInit();
            });


            function log(msg){
                {
                    jQuery('#debug-output').css({display:'block'}).append('<span style="background-color:black;color:yellow"><span style="color:#04fd33">'+msg+'</span></span><br/>');
                }
            }
        </script>
    <style type="text/css">
        html, body {
                margin: 0;			/* Remove body margin/padding */
                padding: 0;
                overflow: hidden;	/* Remove scroll bars on browser window */
                font-size: 75%;
        }
        /*Splitter style */


        #LeftPane {
                /* optional, initial splitbar position */
                overflow: auto;
        }
        /*
         * Right-side element of the splitter.
        */

        #RightPane {
                padding: 2px;
                overflow: auto;
        }
        #layout-center {
                padding: 2px;
                margin:0px;
                overflow: auto;
        }
        .ui-tabs-nav li {position: relative;}
        .ui-tabs-selected a span {padding-right: 10px;}
        .ui-tabs-close {display: none;position: absolute;top: 3px;right: 0px;z-index: 800;width: 16px;height: 14px;font-size: 10px; font-style: normal;cursor: pointer;}
        .ui-tabs-selected .ui-tabs-close {display: block;}
        .ui-layout-west .ui-jqgrid tr.jqgrow td {padding:0px; border-bottom: 0px none;}
        .rotate
            {
                /* for Safari */
                -webkit-transform: rotate(-90deg);

                /* for Firefox */
                -moz-transform: rotate(-90deg);

                /* for Internet Explorer */
                filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
            }
         #tabs li .ui-icon-close { float: left; margin: 0.4em 0.2em 0 0; cursor: pointer; }
         ul.dynatree-container {border:none}
         
    </style>

    </head>
    <body>
        <div id="layout-north" class="ui-layout-north ui-widget-header" >
            <div id="tabs"  class="jqgtabs" style="border:none">
                    <ul>
                        
                        <li><a href="#home-tab">Home</a></li>
                        
                        <!--
                        <li><a href="#tabs-packages">Packages</a></li>
                        -->
                    </ul>
                    <!--
                    <div id="tabs-packages">
                        <table id="applet-package-list" class="scroll" cellpadding="0" cellspacing="0"></table>
                        <div id="applet-package-list-pager" class="scroll" style="text-align:center;"></div>
                    </div>
                    -->
                    <div id="home-tab" style="padding:0"></div>                    
            </div>            
            
        </div>
        <%@include  file="ui-left.jsp" %>
        <%@include  file="ui-center.jsp" %>
        <iframe id="packageInterface" name="packageInterface" src="package.jsp" width="0" height="0" scrolling="no"></iframe>
    </body>
</html>
