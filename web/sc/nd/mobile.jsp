<%-- 
    Document   : mobile
    Created on : Nov 25, 2009, 7:39:12 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Colabopad Touch Screen Remote Interface</title>
        <link rel="icon" type="image/png" href="favicon.png" />

        <script type="text/javascript">
          var sessionId  = '<%=request.getSession().getId() %>';
          var my_pid = <%=request.getSession().getAttribute("pid") %>;
          var app_queue_url = 'dest.<%=(""+request.getSession().getAttribute("p")).replaceAll("-",".") %>';
          var mouse_event_queue_url = 'dest.<%=(""+request.getSession().getAttribute("p")).replaceAll("-",".") %>-msevnt';
          var amq = null;
          var jqready = false;
          var pen_down = false;
        </script>

        <link type="text/css" href="../../js/jquery-ui-1.7.1.custom/css/start/jquery-ui-1.7.1.custom.css" rel="stylesheet" />
        <script type="text/javascript" src="../../js/jquery-ui-1.7.1.custom/js/jquery-1.3.2.min.js"></script>
        <script type="text/javascript" src="../../js/jquery-ui-1.7.1.custom/js/jquery-ui-1.7.1.custom.min.js"></script>

        <script language="javascript">
            var ColabopadApplication={ContextMenus:null,MsgHandler:null,Utility:null,PageTemplate:null};

            $(document).ready(function(){
                //attach mouse event handlers
                $('#remote-tablet-emulator').mousedown(function(event){
                    
                    pen_down = true;
                    var p = {pageX:event.pageX,pageY:event.pageY};
                    ColabopadApplication.MsgHandler.sendMessage({to:mouse_event_queue_url,message:{sender_id:'emulator',type:'mouse-down',p:p}});
                });
                
                $('#remote-tablet-emulator').mousemove(function(event){
                    if(pen_down){
                        alert('moved')
                        var p = {pageX:event.pageX,pageY:event.pageY};
                        ColabopadApplication.MsgHandler.sendMessage({to:mouse_event_queue_url,message:{sender_id:'emulator',type:'mouse-move',p:p}});
                    }
                });

                $('#remote-tablet-emulator').mouseup(function(event){
                    pen_down = false;
                    var p = {pageX:event.pageX,pageY:event.pageY};
                    ColabopadApplication.MsgHandler.sendMessage({to:mouse_event_queue_url,message:{sender_id:'emulator',type:'mouse-up',p:p}});
                });

                $('#remote-tablet-emulator').mouseleave(function(event){

                });
            });

            function amqReady(amqq)
            {
                amq = amqq;
                //if(jqready)
                var listener ={
                            id:'colabopad-mouse-listener',
                            destination:mouse_event_queue_url,
                            rcvMessage:appMsgListener
                          };
                ColabopadApplication.MsgHandler.registerListener(listener);
            }

            function appMsgListener(message){
                if(message.sender_id=='emulator')return;
                if(message.type == 'sign-on'){
                    
                    ColabopadApplication.MsgHandler.sendMessage({to:mouse_event_queue_url,message:{sender_id:'emulator',type:'sign-on-ack'}});
                }
                else
                if(message.type == 'screen-size'){

                }
            }
        </script>
        <script type="text/javascript" src="../../js/jquery-plugins/json-converter/jquery.json-1.3.js"></script>
        <script type="text/javascript" src="js/msg.js"></script>
    </head>
    <body>
        <div id="remote-tablet-emulator" style="width:500px;height:500px;border-style:solid;border-width:1px">

        </div>
        <iframe id="amqInterface" src="amq-interface.jsp" width="0" height="0" scrolling="no"></iframe>
    </body>
</html>
