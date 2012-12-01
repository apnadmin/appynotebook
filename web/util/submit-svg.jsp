<%-- 
    Document   : submit-svg
    Created on : Oct 4, 2012, 8:39:46 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="../js/safe-jquery-1.6.2.min.js"></script>
        <script type="text/javascript">
            
            function sendSVG(svg,fileName){
                //$('input[name=file_name]').val(fileName);
                $("#svg_dom").html(svg);
                $("#svg_dom").find("foreignObject").remove();
                
                //$('#svg').attr("value",svg);
                $('#svg').attr("value",$("#svg_dom").html());
                document.svgposter.submit();
            }
        </script>
    </head>
    <body>
        
        <form method="post" name="svgposter" action="download-svg.jsp">
            <input type="hidden" name="file_name"/>
            <textarea id="svg" name="svg"></textarea>
        </form>
        <div id="svg_dom">

        </div>        
    </body>
</html>
