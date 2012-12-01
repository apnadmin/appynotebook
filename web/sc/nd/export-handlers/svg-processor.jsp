<%-- 
    Document   : svg-poster
    Created on : Jun 3, 2009, 9:00:04 AM
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
            
            function sendSVG(room_id,fileName,svg,type){//alert('svg poster:'+svg)
                $('input[name=room_id]').val(room_id);
                $('input[name=file_name]').val(fileName);
                
                if(type != undefined)
                    $('#type').attr("value",type);
                
                $("#svg_dom").html(svg);                
                $("#svg_dom").find("foreignObject").remove();               
                
                //$('#svg').attr("value",svg);
                
                $('#svg').attr("value",$("#svg_dom").html());
                document.svgposter.submit();
            }
        </script>
    </head>
    <body>
        
        <form method="post" name="svgposter" action="svg.jsp">
            <input type="hidden" name="room_id"/>
            <input type="hidden" name="file_name"/>
            <textarea id="svg" name="svg"></textarea>
        </form>

        <!--
        <form method="post" name="svgposter" action="http://<%=request.getServerName() %>/colabopad/svg-to-svg.php">
            <textarea id="svg" name="svg"></textarea>
        </form>
        -->
        <div id="svg_dom">

        </div>         
    </body>
</html>
