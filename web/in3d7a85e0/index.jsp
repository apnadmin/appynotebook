<%@page contentType="text/html" pageEncoding="UTF-8"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="icon" type="image/png" href="favicon.png" />

	<link type="text/css" href="../js/jquery-ui-1.8.16.custom/css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
	<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-1.6.2.min.js"></script>
	<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-ui-1.8.16.custom.min.js"></script>


        <script type="text/javascript">
            $(function(){
                $("#username").val("appynote4yc@example.com");
                $("#password").val("80c4f404");
                document.autoauthform.submit();
            });
        </script>
    </head>
    <body style="background:url(../img/bg_dotted.png)">
           <form method="get" name="autoauthform" action="../ou">
             <input type="hidden" name="username" id="username"/>
             <input type="hidden" name="password" id="password"/>
           </form> 
    </body>
</html>
