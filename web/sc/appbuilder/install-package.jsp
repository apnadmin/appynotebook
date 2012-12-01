<%-- 
    Document   : install-package
    Created on : Dec 21, 2010, 9:23:03 PM
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
            function uploadPackage(){
                document.packageposter.submit();
            }
            function pageLoaded(){

                if(<%=request.getAttribute("package-uploaded")!=null?"true":"false" %>){
                    top.appletBuilder.packageUploaded(<%= ""+request.getAttribute("replyMsg") %>);
                }
            }
        </script>
    </head>
    <body onload="pageLoaded()">
            <form method="post" name="packageposter"  action="/WidgetResourceAction.do?action=upload-package" enctype="multipart/form-data">
                <input type="hidden" name="action" value="upload-package"/>
                <table>
                    <tr>
                        <td>Package File:</td>
                        <td><input type="file" id="package" name="package"/></td>
                    </tr>
                </table>
            </form>
    </body>
</html>