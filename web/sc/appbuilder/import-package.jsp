<%-- 
    Document   : import-package
    Created on : Jan 19, 2011, 12:26:31 PM
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

        <script type="text/javascript">
            
            function importPackage(){
                document.packageimportposter.submit();
            }
            function pageLoaded(){

                if(<%=request.getAttribute("package-uploaded")!=null?"true":"false" %>){
                    top.appletBuilder.packageImported(<%= ""+request.getAttribute("replyMsg") %>);
                }
            }
        </script>
    </head>
    <body onload="pageLoaded()">
            <form method="post" name="packageimportposter"  action="/WidgetResourceAction.do?action=import-package" enctype="multipart/form-data">
                <input type="hidden" name="action" value="import-package"/>
                <input type="hidden" name="category_id" id="category_id" value=""/>
                <table>
                    <tr>
                        <td>Package File:</td>
                        <td><input type="file" id="package" name="package"/></td>
                    </tr>
                </table>
            </form>
    </body>
</html>