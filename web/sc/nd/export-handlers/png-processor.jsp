<%-- 
    Document   : svg-png-poster
    Created on : Jun 28, 2009, 1:01:41 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="../../../js/safe-jquery-1.6.2.min.js"></script>
        <script type="text/javascript">

            function sendSVG(room_id,fileName,svg,imagedata){
                $('input[name=room_id]').val(room_id);
                $('input[name=file_name]').val(fileName);
                
                $("#svg_dom").html(svg);
                $("#svg_dom svg").attr("xmlns:xlink","http://www.w3.org/1999/xlink");
                $("#svg_dom").find("foreignObject").remove();
                $('#svg').attr("value",$("#svg_dom").html());
                //$('#imagedata').attr("value",imagedata);
                document.svgposter.submit();
                startProgressCheck();
                //http://<%=request.getServerName() %>/colabopad/svg-to-png.php
            }
            function startProgressCheck(){
                var checkCount =0;
                var checkTimer = setInterval(function(){
                        if(checkCount > 60){
                            clearInterval(checkTimer);
                            top.ColabopadApplication.onExportComplete();
                            return;
                        }
                        $.ajax({
                            type:'POST',
                            data:{},
                            url:'export-status.jsp',
                            success:function(data){
                                if(data == "done" || data == "null"){
                                    clearInterval(checkTimer);
                                    top.ColabopadApplication.onExportComplete();
                                }
                            }
                        });
                    },1000);                
            }            
        </script>
    </head>
    <body>
        <h1>Hello World!</h1>
        <!--
        <form method="post" name="svgposter" action="png.jsp">
            <textarea id="svg" name="svg"></textarea>
        </form>
        -->
        <form method="post" name="svgposter" action="png.jsp">
            <input type="hidden" name="room_id"/>
            <input type="hidden" name="file_name"/>
            <input type="hidden" id="imagedata" name="imagedata">
            <textarea id="svg" name="svg"></textarea>
        </form>
        <div id="svg_dom">

        </div>
    </body>
</html>
