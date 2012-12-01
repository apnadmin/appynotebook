<%-- 
    Document   : amq-interface
    Created on : Apr 19, 2009, 7:41:15 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

    <%--
    <script type="text/javascript" src="/collabopad/amq/amq.js"></script>
    <script type="text/javascript">amq.uri='/collabopad/amq';</script>
    --%>

    <!--
    <script type="text/javascript" src="../../amq/prototype.js"></script>
    -->
    <script type="text/javascript" src="../../../js/prototype-debug.js"></script>
    <script type="text/javascript" src="../../../amq/behaviour.js"></script>
    <script type="text/javascript" src="../../../js/_amq-debug.js?ts=1"></script>
    <script type="text/javascript">
        amq.uri='../../../amq';
        function initApp(){
           top.amqReady(amq);
        };
        initApp();
    </script>
    </head>
    <body ></body>
</html>
