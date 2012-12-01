<%-- 
    Document   : image-uploader
    Created on : Dec 9, 2009, 3:54:38 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%



  String fileName = "";
  boolean upgradeNeeded = false;
  if(request.getParameter("action")!=null&& request.getParameter("action").compareToIgnoreCase("upload-image")==0)
  {

   

            int clbSizelimit = 1000000;

            // Check that we have a file upload request
            boolean isMultipart = org.apache.commons.fileupload.servlet.ServletFileUpload.isMultipartContent(request);
            if(isMultipart){

                // Create a factory for disk-based file items
                org.apache.commons.fileupload.FileItemFactory factory = new org.apache.commons.fileupload.disk.DiskFileItemFactory();

                ((org.apache.commons.fileupload.disk.DiskFileItemFactory)factory).setSizeThreshold(clbSizelimit);

                // Create a new file upload handler
                org.apache.commons.fileupload.servlet.ServletFileUpload upload = new org.apache.commons.fileupload.servlet.ServletFileUpload(factory);

                // Parse the request
                java.util.List /* FileItem */ items = upload.parseRequest(request);

                org.apache.commons.fileupload.FileItem rsFile = null;

                java.util.Iterator iter = items.iterator();
                while (iter.hasNext()) {
                    org.apache.commons.fileupload.FileItem item = (org.apache.commons.fileupload.FileItem) iter.next();
                    if (item.isFormField()) {
                        if(item.getFieldName().compareToIgnoreCase("file-name")==0)
                            fileName = item.getString();
                        else
                        if(item.getFieldName().compareToIgnoreCase("room_id")==0)
                            request.setAttribute("room_id",item.getString());
                                                                
                    } else {
                        rsFile = item;
                    }
                }
                
                //make sure they have right to take this action
                if(com.feezixlabs.util.FeatureAccessManager.hasAccess("image upload", request)){
                    fileName = java.util.UUID.randomUUID().toString();
                    String filePath = com.feezixlabs.util.ConfigUtil.static_file_directory+"/";
                    java.io.File file = new java.io.File(filePath+fileName);
                    rsFile.write(file);

                    com.feezixlabs.db.dao.StaticReferenceDAO.addReference(fileName);
                }
                else{
                    upgradeNeeded = true;
                    rsFile.delete();
                }
            }
  }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <script type="text/javascript" src="../../../js/safe-jquery-1.6.2.min.js"></script>
        <script type="text/javascript">
            function uploadImage(){
                document.imgposter.submit();
            }
            function imageURL(){
                return document.getElementById("uploaded_image").value;
            }
            function pageLoaded(){
                if(<%=request.getParameter("action")!=null&& request.getParameter("action").compareToIgnoreCase("upload-image")==0?"true":"false" %>){
                    top.ColabopadApplication.addUploadedImage("<%= fileName%>",<%=upgradeNeeded%>);
                }
            }
        </script>
    </head>
    <body style="padding:0;margin:0" onload="pageLoaded()">
        <form method="post" name="imgposter"  action="image-uploader.jsp?action=upload-image" enctype="multipart/form-data">
            <input type="hidden" name="file-name"/>
            <input type="hidden" name="room_id"/>
            <input type="file" id="uploaded_image" name="uploaded_image"/><br/>
        </form>
    </body>
</html>
