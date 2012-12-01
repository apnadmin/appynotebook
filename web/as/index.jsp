<%-- 
    Document   : index
    Created on : May 14, 2012, 11:31:12 AM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Demo Signup</title>
	<link type="text/css" href="../js/jquery-ui-1.8.16.custom/css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
	<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-1.6.2.min.js"></script>
	<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-ui-1.8.16.custom.min.js"></script>
        
        <%//preserve original intent       
        if(request.getSession().getAttribute("lp") == null)
            request.getSession().setAttribute("lp",request.getParameter("lp"));
        if(request.getSession().getAttribute("pr") == null)
            request.getSession().setAttribute("pr",request.getParameter("pr"));
        if(request.getSession().getAttribute("room_id") == null)
            request.getSession().setAttribute("room_id",request.getParameter("room_id"));      
        if(request.getSession().getAttribute("ep") == null)
            request.getSession().setAttribute("ep",request.getParameter("ep"));         
        %>        
        <!--JQ blockui -->
        <script type="text/javascript" src="../js/jquery-plugins/blockui/jquery.blockUI.js"></script>        
        <script type="text/javascript">
        $(function(){
            $.blockUI({css:{},overlayCSS: { backgroundColor: '#666666',opacity:.2 },theme:true,message: '<h1 style="font-size:1.8em"><img src="../img/busy.gif" />Signing in,please wait...</h1>' });

            $.ajax({
                type:'POST',                
                url:'/UserAction.do?action=auto-create-new-user',
                success:function(data){
                    $.unblockUI();

                    var jsonobj = eval('('+data+')');

                    if(jsonobj.status=='success'){
                        
                        //alert(jsonobj.username+","+jsonobj.password);
                        if(typeof jsonobj.username != "undefined"){
                            $("#username").val(jsonobj.username);
                            $("#password").val(jsonobj.password);
                            document.autoauthform.submit();
                        }else{
                            alert('Thank you for submitting a sign-up request.\n Please check your e-mail for access information.');
                        }
                        //window.location = 'ou';
                        //window.location = 'ou?u='+jsonobj.username+"&p="+jsonobj.password;

                        //
                        //window.location = 'sc/nd/index.jsp';
                    }else{
                        if(typeof jsonobj.msg != "undefined"){
                            alert(jsonobj.msg);
                        }else
                        alert('There was a problem processing your request,please try again.\nIf problem persist, please contact support.\nmessage:'+jsonobj.msg);
                    }
                }
            });
        });
        </script>        
        <style type="text/css">
         html, body {
                margin: 0;	/* Remove body margin/padding */
                padding: 0;
                overflow: hidden;	/* Remove scroll bars on browser window */
                font-size: 80%;
                font-family: Verdana, Arial, sans-serif;
          }
        </style>
    </head>
    <body style="background:url(../img/bg_dotted.png)">
           <form method="get" name="autoauthform" action="../ou">
             <input type="hidden" name="username" id="username"/>
             <input type="hidden" name="password" id="password"/>
           </form>
    </body>
</html>
