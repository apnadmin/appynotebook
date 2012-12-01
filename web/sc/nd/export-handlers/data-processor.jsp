<%-- 
    Document   : data-processor
    Created on : Apr 30, 2012, 6:42:12 AM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="../../../js/safe-jquery-1.6.2.min.js"></script>
        <script type="text/javascript">
            
            function sendData(room_id,data,fileName,mime,ext){
                $('input[name=room_id]').val(room_id);
                
                if(typeof fileName != "undefined")
                    $('input[name=file_name]').val(fileName);                
                if(typeof mime != "undefined")
                    $('input[name=mime]').attr("value",mime);
                if(typeof ext != "undefined")
                    $('input[name=extension]').attr("value",ext);
                
                $('#data').attr("value",data);
                document.dataposter.submit();
            }
        </script>
    </head>
    <body>
        
        <form method="post" name="dataposter" action="data.jsp">
            <input type="hidden" name="room_id"/>
            <input type="hidden" name="file_name"/>
            <input type="hidden" name="mime"/>
            <input type="hidden" name="extension"/>
            <textarea id="data" name="data"></textarea>
        </form>
    </body>
</html>
