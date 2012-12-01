<%-- 
    Document   : add-users
    Created on : Jan 10, 2011, 7:07:20 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="../../js/jquery-ui-1.7.1.custom/js/jquery-1.3.2.min.js"></script>


        <!--
        <link type="text/css" href="../../js/jquery-ui-1.7.1.custom/css/start/jquery-ui-1.7.1.custom.css" rel="stylesheet" />
        <script type="text/javascript" src="../../js/jquery-ui-1.7.1.custom/js/jquery-1.3.2.min.js"></script>
        <script type="text/javascript" src="../../js/jquery-ui-1.7.1.custom/js/jquery-ui-1.7.1.custom.min.js"></script>
        -->

        <script type="text/javascript">
            function pageLoaded(){
                if(<%=request.getAttribute("users-loaded")!=null?"true":"false" %>){
                    
                    if(top.appletBuilder != undefined)
                        top.appletBuilder.usersLoaded(<%= ""+request.getAttribute("replyMsg") %>);
                    else
                        top.ColabopadApplication.usersLoaded(<%= ""+request.getAttribute("replyMsg") %>);
                }
            }
        </script>
        <style type="text/css">
        .signup-label{
            font-size:80%;
            text-align:right;
            background-color:#f6f6f6;
        }
        </style>
    </head>
    <body onload="pageLoaded()">
            <form method="post" name="userdataposter"  action="/UserAction.do?action=load-users" enctype="multipart/form-data">
                <input type="hidden" name="action" value="load-users"/>
                <input type="hidden" name="room_id" id="room_id"/>
                <table>
                    <tr>
                        <td class="signup-label">Delimiter:</td>
                        <td><input type="text" id="delimiter" name="delimiter" size="4" value=","/></td>
                    </tr>
                    <tr>
                        <td class="signup-label">Quote:</td>
                        <td><input type="text" id="quote" name="quote" size="4" value=""/></td>
                    </tr>
                    <tr>
                        <td class="signup-label">Skip Rows:</td>
                        <td><input type="text" id="skip" name="skip" size="4" value="0"/></td>
                    </tr>
                    <tr>
                        <td class="signup-label">CSV File:</td>
                        <td><input type="file" id="data" name="data"/></td>
                    </tr>
                </table>
            </form>
    </body>
</html>
