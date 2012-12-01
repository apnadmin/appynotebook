<%-- 
    Document   : load-clb
    Created on : Jun 28, 2009, 9:26:03 PM
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
            function addResource(widgetid){
                $('#widget-id').attr('value',widgetid);
                document.resourceposter.submit();
            }
            function pageLoaded(){

                if(<%=request.getAttribute("resource-added")!=null?"true":"false" %>){                    
                    top.appletBuilder.resourceAdded(<%= ""+request.getAttribute("replyMsg") %>);
                }
            }
        </script>
    </head>
    <body onload="pageLoaded()">
            <form method="post" name="resourceposter"  action="/WidgetResourceAction.do?action=add-widget-resource" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add-widget-resource"/>
                <input type="hidden" id="widget-id" name="widgetid"/>
                <input type="hidden" id="widget-id" name="uuid"/>
                <input type="hidden" id="widget-env" name="env" value="dev"/>
                <input type="hidden" id="label" name="label" value="none"/>
                <input type="hidden" id="mimeType" name="mimeType" value="none"/>
                <input type="hidden" id="relPath" name="relPath" value=""/>
                <table>

                    <tr>
                        <td>File:</td>
                        <td><input type="file" id="data" name="data"/></td>
                    </tr>
                    <!--
                    <tr>
                        <td>Label:</td>
                        <td><input type="text" id="label" name="label"/></td>
                    </tr>
                    -->
                    <!--
                    <tr>
                        <td>MIME Type:</td>
                        <td>
                            <input type="text" id="mimeType" name="mimeType"/>
                            <select>
                                <option value="image/jpeg">jpeg</option>
                                <option value="image/png">png</option>
                                <option value="image/gif">image/jpeg</option>
                                <option value="image/tiff">image/jpeg</option>
                                <option value="image/jpeg">image/jpeg</option>
                                <option value="image/jpeg">image/jpeg</option>
                                <option value="image/jpeg">image/jpeg</option>
                                <option value="image/jpeg">image/jpeg</option>
                                <option value="image/jpeg">image/jpeg</option>
                            </select>
                        </td>
                    </tr>
                    -->
                    <tr>
                        <td>Data Type:</td>
                        <td>
                            <select id="dataType" name="dataType">
                                <option value="ascii">ASCII</option>
                                <option value="binary">BINARY</option>
                                <option value="zip">ZIP Archive</option>
                            </select>
                        </td>
                    </tr>
                </table>

            </form>
    </body>
</html>