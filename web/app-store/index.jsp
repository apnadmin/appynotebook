<%-- 
    Document   : index
    Created on : Dec 7, 2011, 11:43:09 AM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>App Store</title>

        <link rel="stylesheet" href="../css/blueprint/screen.css" type="text/css" media="screen, projection">
        <link rel="stylesheet" href="../css/blueprint/print.css" type="text/css" media="print">

        <link type="text/css" href="jquery-ui-1.8.18.custom/css/redmond/jquery-ui-1.8.18.custom.css" rel="stylesheet" />
        <script type="text/javascript" src="jquery-ui-1.8.18.custom/js/jquery-1.7.1.min.js"></script>
        <script type="text/javascript" src="jquery-ui-1.8.18.custom/js/jquery-ui-1.8.18.custom.min.js"></script>

        <link rel="stylesheet" type="text/css" media="screen" href="../js/jquery-plugins/fg-menu/fg.menu.css" />
        <script src="../js/jquery-plugins/fg-menu/fg.menu.js" type="text/javascript"></script>        
        
        <script type="text/javascript" src="../js/jquery-plugins/blockui/jquery.blockUI.js"></script>
	<script>
            var app_store_app ={
              install:function(el,applet_id,disable){
                  if(confirm("Are you sure you want to install this app?")){
                    $.blockUI();
                    $.ajax({
                        type:'POST',
                        url:'action.jsp',
                        data:{"action":"install","applet_id":applet_id},
                        success:function(data){
                          $.unblockUI();
                          $(el).parent().html('<button style="font-size:.7em" class="installed-applet-button" value="'+applet_id+'" disabled>INSTALLED</button>').find('button').button();
                          if(top.ColabopadApplication != "undefined")
                              top.ColabopadApplication.refreshApps();
                        }
                    });
                  }
              },
              unInstall:function(el,applet_id){
                  if(confirm("Are you sure you want to uninstall this app?")){
                    $.blockUI();
                    $.ajax({
                        type:'POST',
                        url:'action.jsp',
                        data:{"action":"uninstall","applet_id":applet_id},
                        success:function(data){
                          $.unblockUI();
                          app_store_app.showMyApps();
                           if(top.ColabopadApplication != "undefined")
                              top.ColabopadApplication.refreshApps();                         
                        }
                    });
                  }
              },
              showAppPage:function(applet_id){
                    $.ajax({
                        type:'POST',
                        url:'app-page.jsp',
                        data:{"applet_id":applet_id},
                        success:function(data){
                          $('#tabs').tabs("add","#tabs-app-page","xx");
                          //alert();
                          
                          $('#tabs').tabs("select","#tabs-app-page");
                          //alert($('.ui-tabs-selected:last').html());
                          $('.ui-tabs-selected').remove();
                          
                          $('#tabs-app-page').html(data);
                          $( ".install-applet-button" ).button();
                          $( ".installed-applet-button" ).button();
                          app_store_app.decoratePanels();
                        }
                    });
              },
              decoratePanels:function(){
                  $('.app-desc').addClass("ui-widget-header ui-corner-all");
                  $('table.apps td').addClass("ui-widget-content");
              },
              showHomeTab:function(){
                    $.ajax({
                        type:'POST',
                        url:'new-apps.jsp',
                        success:function(data){
                          $('#new-apps-applet-holder').empty().html(data);
                          $( ".install-applet-button" ).button();
                          $( ".installed-applet-button" ).button();
                          $("#suggest-app-button").button().click(function(){
                              $('#app-idea-dialog').dialog("open");
                          });
                          app_store_app.decoratePanels();
                                    //$('#app-suggestion-btn').button();
                                
                          if($('#developer-role-button').length>0){
                                $('#developer-role-button').button().click(function(){

                                $.blockUI();
                                $.ajax({
                                        type:'POST',                                            
                                        url:'/UserAction.do?action=grant-developer-role',
                                        success:function(data){
                                            $('#developer-role-button').remove();
                                            $.unblockUI();
                                            alert('You now have developer access, \nplease refresh your window and click the developer tool button \nto access the dev environment.');
                                        }
                                    });
                                });
                          }             
                          
                        }
                    });
              },
              initCategoryPage:function(){
                  $('#tabs-4').empty();
                    $.ajax({
                        type:'POST',
                        url:'categories.jsp',
                        success:function(data){
                          $('#tabs-4').css("padding-left","4px").html(data);
                          app_store_app.decoratePanels();
                          $( "#app-category-anchor" ).menu({content: $('#app-category-structure-holder').css("display","none").html(),
                                                           width:230,  
                                                           maxHeight:360,
                                                           displayInline:true,
                                                           defaultItemClickCallBack:"app_store_app.showCategory(0)",
                                                           directionV:true,
                                                           backLink:false,
                                                           crumbDefaultText: ' '});       
                          $( "#app-category-anchor" ).css("display","none");                             
                          app_store_app.showCategory(0);
                        }
                    });
              },
              showCategory:function(id){
                    //alert(id)
                    $.ajax({
                        type:'POST',
                        url:'category-apps.jsp?category_id='+id,
                        success:function(data){
                            $('#app-category-applet-holder').empty().html(data);
                            $( ".install-applet-button" ).button();
                            $( ".installed-applet-button" ).button();
                            app_store_app.decoratePanels();
                            
                        }
                    });
              },
              showApps:function(){
                    //alert('apps')
                    $.ajax({
                        type:'POST',
                        url:'apps.jsp',
                        success:function(data){
                            $('#apps-applet-holder').empty().html(data);
                            $( ".install-applet-button" ).button();
                            $( ".installed-applet-button" ).button();
                            app_store_app.decoratePanels();
                        }
                    });
              },
              showMyApps:function(){
                    //alert('myapps')
                    $.ajax({
                        type:'POST',
                        url:'my-apps.jsp',
                        success:function(data){
                            $('#myapps-applet-holder').empty().html(data);
                            $( ".install-applet-button" ).button();
                            $( ".installed-applet-button" ).button();
                            app_store_app.decoratePanels();
                        }
                    });
              }
              ,
              sendAppSuggestion:function(){
                    if($('#app-suggestion-textfield').val() == ''){
                        $('#app-idea-dialog').dialog("close");return;
                    }
                    $.blockUI();
                    $.ajax({
                        type:'POST',
                        url:'action.jsp',
                        data:{"action":"app-suggestion","message":$('#app-suggestion-textfield').val()},
                        success:function(data){
                            $.unblockUI();
                            $('#app-suggestion-textfield').val('Thank you! Your suggestion is appreciated and would be seriously considered.');
                            setTimeout(function(){
                                $('#app-idea-dialog').dialog("close");
                            },3000);
                        }
                    });
              }
            };
            $(function() {
                    $( "#tabs" ).tabs({
                            /*ajaxOptions: {
                                    error: function( xhr, status, index, anchor ) {
                                            $( anchor.hash ).html(
                                                    "Couldn't load this tab. We'll try to fix this as soon as possible. " +
                                                    "If this wouldn't be a demo." );
                                    }
                            },*/
                            create:function(){
                                $( "#tabs" ).css({"border-style":"none","background":"none","margin":"0","padding":"0"}).removeClass("ui-corner-all");
                                //$('#main-container').height($(document).height()-100).css({"padding":"0"});
                                $('#inner-main-container').addClass("ui-widget-content")/*.height($(document).height()-168)*/.css({"background-color":"white",
                                                                                                                               "padding":"0",
                                                                                                                               "min-height":$(document).height()-168+"px"});
                                $( "#tabs > ul" ).removeClass("ui-corner-all").css({"background":"none", "border-top":"0","border-left":"0","border-right":"0","border-bottom":"0"});
                                
                                <% if(request.getParameter("fr") != null) {%>
                                $( "#tabs" ).tabs("select","tabs-3");
                                <%}%>
                                
                                //$('#app-store-page-footer').css({"margin-top":"105px"});
                            },
                            show:function(event,ui){
                                if(typeof $( "#app-category-anchor" ) != "undefined")
                                    $( ".positionHelper" ).remove();
                                
                                if($('#tabs-app-page').length >0 && ui.panel.id != 'tabs-app-page')
                                    $('#tabs').tabs("remove",$('#tabs').tabs("length")-1);

                                if(ui.panel.id == 'tabs-1')
                                    app_store_app.showHomeTab();
                                else
                                if(ui.panel.id == 'tabs-4')
                                    app_store_app.initCategoryPage();
                                else
                                if(ui.panel.id == 'tabs-2')
                                    app_store_app.showApps();
                                else
                                if(ui.panel.id == 'tabs-3')
                                    app_store_app.showMyApps();
                            }
                    });// 0.872* 
                    var content_height =$(document).height()-$("#app-store-page-footer").height()-$("#page-header").height()-12;
                    $('#page-middle').height(content_height);//background:url(img/bg_dotted.png) class="ui-corner-all ui-widget-content"
                    
                    $('#app-idea-dialog').dialog({
                        autoOpen: false,
                        width: 350,                        
                        modal:false,
                        open:function(){
                          $('#app-suggestion-textfield').val("");  
                        },
                        buttons: {                                
                                "Cancel": function() {
                                    $(this).dialog("close");
                                },
                                "Submit": function() {
                                    //$(this).dialog("close");
                                    app_store_app.sendAppSuggestion();
                                }                                
                            }
                     }).siblings('div.ui-dialog-titlebar').remove();
                     
                     <% if(request.getParameter("width") != null){%>
                     $('body').css("width",(<%=request.getParameter("width")%>-15)+'px');
                     <%}%>
            });
	</script>
        <style>
            /*body {margin-left:auto;margin-right:auto;margin-top: 1px;width:1070px} style="background-color: #b0aca4;background-image:url(../img/bg_dotted.png);" */
            body {
                background:url(../../img/bg_dotted-v1.png);
                padding:3px;
                margin:2px;
                padding-top: 5px;
            }
            #page-middle {
                background-color:white;
                padding:0;
                margin:0;
                /*width:1100px;*/
                color:white;
                margin-left:auto;
                margin-right:auto
            }
            div.app-desc{
                width:160px;
                height:120px;
                float:right;
                text-align:left;
            }
            div.app-bk-panel{
                height:128px;
                overflow:hidden;
                padding: 2px;
            }
            div.app-icon-panel{
                width:64px;
                float:left;
            }
            table.apps {                
                border-spacing:4px;
                border-collapse:separate;
                color:#3cb2ec;
                border-style: solid;
                border-width:1px;
                margin-top: 2px;
            }

            table.apps td{
                background:url(../../img/bg_dotted-v1.png)!important;
                padding: 1px;
                vertical-align:top;
                text-align:left;
            }
            div.app-desc/*app-bk-panel*/{/*background-color:silver;*/padding: 4px; }
            
            a {color:#275a71}
            a:hover {color:#275a71}
            a:active{color:#275a71}
            a:visited{color:#275a71}
        </style>
    </head>
    <body style="margin-left:auto;margin-right:auto;text-align: center;">
      <div style="margin-left:auto;margin-right:auto;" class="ui-widget-content ui-corner-top">
        <div id="page-header" class="ui-widget-header ui-corner-top" style="padding:0;margin:0;margin-top:0px;margin-bottom:2px;">
            <div style="text-align: left;padding:15px;font-weight: bold;font-size: 2em">
                <img src="../../img/app-store-logo.png" style=""/> <span style="color:#e06f13">APP</span> <span style="color:#3cb2ec">Store</span>
            </div>
        </div>

        <div id="page-middle">
            <div id="tabs">
                    <ul>
                        <li><a href="#tabs-1"><span style="float:left;vertical-align: middle" class="ui-icon ui-icon-home"></span>Home</a></li>

                        <li><a href="#tabs-2"><span style="float:left;vertical-align: middle" class="ui-icon ui-icon-star"></span>APPS</a></li>

                        <% if(request.getUserPrincipal() != null){%>
                        <li><a href="#tabs-3"><span style="float:left;vertical-align: middle" class="ui-icon ui-icon-heart"></span>My APPS</a></li>
                        <%}%>
                        <li><a href="#tabs-4"><span style="float:left;vertical-align: middle" class="ui-icon ui-icon-folder-collapsed"></span>Categories</a></li>
                    </ul>
                    <div id="tabs-1" style="padding: 2px;">


                        <div id="new-apps-applet-holder"></div>
                        <div style="clear:both"></div>
                    </div>

                    <div id="tabs-2" style="padding: 2px;">
                        <div id="apps-applet-holder"></div>  
                        <div style="clear:both"></div>
                    </div>
                    <% if(request.getUserPrincipal() != null){%>
                    <div id="tabs-3" style="padding: 2px;">
                        <div id="myapps-applet-holder"></div>
                        <div style="clear:both"></div>
                    </div>
                    <%}%>
                    <div id="tabs-4" style="padding: 2px;">
                        <a href="#" id="app-category-structure-target"></a>
                        <div id="app-category-structure-holder" style="float:left;width:300px;text-align: left"><%= com.feezixlabs.util.Utility.buildAppletTaxonomyMenu(false) %></div>
                        <div id="app-category-applet-holder" style="float:right;width:750px;text-align: left"></div>
                        <div style="clear:both"></div>
                    </div>
            </div>
        </div>
        <div id="app-idea-dialog" style="display:none">
                <textarea id="app-suggestion-textfield" rows="8" style="width:95%" ></textarea>           
        </div> 
        </div>
    </body>
</html>
