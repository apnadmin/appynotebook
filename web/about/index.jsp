<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" >
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
        <meta http-equiv="Content-Language" content="en-us" />
        <title>About APPYnote</title>
        <link rel="stylesheet" href="../css/style-1.css" type="text/css" media="screen" />

        <link type="text/css" href="../js/jquery-ui-1.8.16.custom/css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
        <script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-1.6.2.min.js"></script>
        <script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-ui-1.8.16.custom.min.js"></script>
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
                        }
                    });
              },
              showHomeTab:function(){
                    $.ajax({
                        type:'POST',
                        url:'new-apps.jsp',
                        success:function(data){
                          $('#new-apps-applet-holder').empty().html(data);
                          $( ".install-applet-button" ).button();
                          $( ".installed-applet-button" ).button();
                        }
                    });
              },
              initCategoryPage:function(){
                  $('#tabs-4').empty();
                    $.ajax({
                        type:'POST',
                        url:'categories.jsp',
                        success:function(data){
                          $('#tabs-4').html(data);
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
                        }
                    });
              }
              ,
              sendAppSuggestion:function(){
                    $.blockUI();
                    $.ajax({
                        type:'POST',
                        url:'action.jsp',
                        data:{"action":"app-suggestion","message":$('#app-suggestion-textfield').val()},
                        success:function(data){
                            $.unblockUI();
                            $('#app-suggestion-textfield').val('Thank you! Your suggestion is appreciated and would be seriously considered.');
                        }
                    });
              }
            };
            $(function() {

            });
	</script>
    </head>
    <body id="" class="info-body">
        <div class="body-wrapper">
            <div class="header">
                <div class="header-container">
                    <a class="header-logo left" href="/">APPYnote</a>
                    <div class="main-menu">
                        <div class="login">
                            </div></div><div class="clear"></div></div></div><div class="body-content-wrapper"><div class="content-multi radius-all"><div class="sidebar"><ul class="sidebar-tabs"><li class="radius-topleft sidebar-item selected"><a href="/about/">About</a></li><li class="border-top sidebar-item "><a href="/terms/">Terms</a></li><li class="border-top sidebar-item "><a href="/privacy/">Privacy Policy</a></li></ul></div><div class="mainbar has-sidebar"><div class="about-body"><h2 id="about">About APPYnote</h2>
                           <h2 id="team">Meet the Team</h2>
                            <ul class="team-members">
                                <!--
                                <li>
                                    <span class="member-container"><img src="/static/images/team/wade.png" width="140" alt="Wade" height="140" title="Wade" /><h4>Wade Roberts</h4></span>
                                </li>
                                -->
                                
                                <li>
                                    <a href="http://twitter.com/twitlooter" class="member-container"><img src="../img/ceo.png" width="140" alt="Edmond" height="140" title="Edmond" /><h4>Edmond Kemokai</h4></a>
                                </li>
                            </ul>
                            <h2 id="support">Support</h2><p>

                                If you have any questions, please send us an email:
                                <div style="padding:4px;width:400px;" class="ui-widget-header ui-corner-all">
                                    <textarea id="app-suggestion-textfield"  style="width:100%" rows="8" ></textarea>
                                    <div style="text-align:right">
                                        <button id="app-suggestion-btn" onclick="app_store_app.sendAppSuggestion()">Submit</button>
                                    </div>
                                </div>
                            </p><h2 id="contact">Contact Us</h2><p>
                                Email: <a href="mailto:info@APPYnote.com">info@APPYnote.com</a><br />
                                Phone: 862-234-0473
                            </p>
                            <ul class="social-networks">
                                <li><a class="facebook" href="http://www.facebook.com/APPYnote">Find us on Facebook</a>
                                </li>
                                <li><a class="twitter" href="http://www.twitter.com/twitlooter">Follow us on Twitter</a></li>
                            </ul>
                        </div></div><div class="clear"></div></div></div><div class="body-wrapper-end"></div></div><div id="footer"><span class="footer-item"><a href="/about/">About</a></span> <span class="footer-item"><a href="/terms/">Terms</a></span> <span class="footer-item"><a href="/privacy/">Privacy</a></span> <span class="footer-item"></span> <span class="footer-item"><span title="a17700a595 i-816fe4e2">&copy; 2011</span> APPYnote.</span></div><div id="notify-container"></div>
    </body>
</html>