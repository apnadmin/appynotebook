<%-- 
    Document   : file-uploader
    Created on : Jan 31, 2012, 10:06:39 AM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%



  int clbSizelimit = 1000000;
  final String fileName = java.util.UUID.randomUUID().toString();
  String profilePic = "";
  String fileDisplayName = "";
  int elementId = 0;
  String fileType = "";
  int pageCount = 0;
  int width =0;
  int height = 0;
  StringBuffer docText = null;
  StringBuffer static_references = null;
  boolean doConversion = false;
  String from = "";
  boolean upgradeNeeded = false;
  String page_dimensions = "";
  
  if(request.getParameter("action")!=null&& request.getParameter("action").compareToIgnoreCase("upload-file")==0)
  {

    
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
                if(item.getFieldName().compareToIgnoreCase("file_name")==0){
                //    fileName = item.getString();
                }
                else
                if(item.getFieldName().compareToIgnoreCase("element_id")==0 && item.toString().length()>0)
                    elementId = Integer.parseInt(item.toString());
                else
                if(item.getFieldName().compareToIgnoreCase("file_type")==0)
                    fileType = item.getString();
                else
                if(item.getFieldName().compareToIgnoreCase("do_conversion")==0){
                    if(item.getString() != null && item.getString().compareTo("yes") == 0)
                            doConversion = true;
                }
                else
                if(item.getFieldName().compareToIgnoreCase("room_id")==0){
                    request.setAttribute("room_id", item.getString());
                }
                else
                if(item.getFieldName().compareToIgnoreCase("page_dimensions")==0){
                    page_dimensions =  item.getString();
                }                
                else
                if(item.getFieldName().compareToIgnoreCase("from")==0)
                    from = item.getString();
            } else {
                rsFile = item;
                fileDisplayName = item.getName();
                int lif = fileDisplayName.lastIndexOf(".");
                if(lif != -1 &&lif+1<fileDisplayName.length()){
                    String ext = fileDisplayName.substring(lif+1);
                    if(ext.compareToIgnoreCase("ppt") == 0 ||
                       ext.compareToIgnoreCase("pptx") == 0 ||
                       ext.compareToIgnoreCase("pptm") == 0 ||
                       ext.compareToIgnoreCase("potx") == 0 ||
                       ext.compareToIgnoreCase("potm") == 0 ||
                       ext.compareToIgnoreCase("pdf") == 0 ||
                       ext.compareToIgnoreCase("doc") == 0 ||
                       ext.compareToIgnoreCase("dotx") == 0 ||
                       ext.compareToIgnoreCase("dotm") == 0 ||
                       ext.compareToIgnoreCase("docm") == 0 ||
                       ext.compareToIgnoreCase("docx") == 0){
                        fileDisplayName = fileDisplayName.substring(0,lif);
                    }
                }
            }
        }
        String staticFilePath = com.feezixlabs.util.ConfigUtil.static_file_directory;
        String workerFilePath = com.feezixlabs.util.ConfigUtil.static_file_directory+"/work";
        java.io.File file = new java.io.File(workerFilePath+"/"+fileName);
        rsFile.write(file);

        /*
        java.util.Collection<?> mimeTypes = eu.medsea.mimeutil.MimeUtil.getMimeTypes(filePath+fileName);
        java.util.Iterator itr = mimeTypes.iterator();


        while(itr.hasNext()){
            String mime = itr.next().toString();
            System.out.println("MIME:"+mime+" "+fileDisplayName.substring(fileDisplayName.lastIndexOf(".")));
        }
        */

       
    //make sure they have right to take this action
    if(!com.feezixlabs.util.ConfigUtil.enable_content_importing || !com.feezixlabs.util.FeatureAccessManager.hasAccess("import", request)){
        upgradeNeeded = true;
    }else{        
        if(doConversion && (fileType.compareToIgnoreCase("powerpoint") == 0 || fileType.compareToIgnoreCase("pdf") == 0)){
            
            
            java.io.File pdfFile =  new java.io.File(workerFilePath+"/"+fileName+".pdf");
            if(fileType.compareToIgnoreCase("powerpoint") == 0){
                //convert
                org.artofsolving.jodconverter.OfficeDocumentConverter converter = new org.artofsolving.jodconverter.OfficeDocumentConverter(com.feezixlabs.util.Utility.JODConvertOfficeManager);
                converter.convert(file, pdfFile);
            }else{
                org.apache.commons.io.FileUtils.moveFile(file, pdfFile);
            }

            //org.apache.pdfbox.pdmodel.PDDocument pdfDocument = org.apache.pdfbox.pdmodel.PDDocument.load(pdfFile);
            //pageCount = pdfDocument.getNumberOfPages();
            //pdfDocument.close();

            //int width = Integer.parseInt(page_dimensions.split("x")[0]);
            java.io.File extractDir = new java.io.File(workerFilePath+"/"+fileName+"-pages");extractDir.mkdirs();            
            Runtime r = Runtime.getRuntime();
            Process p = r.exec("convert -resize "+page_dimensions+" "+workerFilePath+"/"+fileName+".pdf "+workerFilePath+"/"+fileName+"-pages/"+fileName+".png");
            p.waitFor();
            pageCount = extractDir.list().length;
            
            //System.out.println("Files extracted:"+extractDir.list().length);
            
            //System.out.println("PAGE COUNTer:"+pageCount);
            //String[] args = {"-imageType","png","-outputPrefix",staticFilePath+"/"+fileName,workerFilePath+"/"+fileName+".pdf"};
            //org.apache.pdfbox.PDFToImage.main(args);

            for(int i=0;i<pageCount;i++){
                String imageFileName = fileName+"-"+(i)+".png";
                org.apache.commons.io.FileUtils.moveFile(new java.io.File(workerFilePath+"/"+fileName+"-pages/"+imageFileName), new java.io.File(staticFilePath+"/"+imageFileName));
                com.feezixlabs.db.dao.StaticReferenceDAO.addReference(imageFileName);
            }
            if(pageCount>0){
                java.awt.image.BufferedImage img = null;
                try {
                    img = javax.imageio.ImageIO.read(new java.io.File(staticFilePath+"/"+fileName+"-0.png"));
                    width = img.getWidth();
                    height = img.getHeight();
                } catch (Exception e) {}
            }
            if(pdfFile.exists())pdfFile.delete();
            if(file.exists())file.delete();
            extractDir.delete();
        }
        else
        if(doConversion && fileType.compareToIgnoreCase("data") == 0){
            
        }
        else
        if(doConversion && fileType.compareToIgnoreCase("ms-excel") == 0){
            java.io.File csvFile =  new java.io.File(staticFilePath+"/"+fileName+".csv");
            //convert
            org.artofsolving.jodconverter.OfficeDocumentConverter converter = new org.artofsolving.jodconverter.OfficeDocumentConverter(com.feezixlabs.util.Utility.JODConvertOfficeManager);
            converter.convert(file, csvFile);

            docText = new StringBuffer();
            docText.append(org.apache.commons.io.FileUtils.readFileToString(new java.io.File(staticFilePath+"/"+fileName+".csv")));

            //delete excel
            new java.io.File(staticFilePath+"/"+fileName+".csv").delete();
            new java.io.File(staticFilePath+"/"+fileName).delete();            
        }
        else
        if(doConversion && fileType.compareToIgnoreCase("ms-word") == 0){
            
            java.io.File htmlFile =  new java.io.File(workerFilePath+"/"+fileName+".html");
            //convert
            org.artofsolving.jodconverter.OfficeDocumentConverter converter = new org.artofsolving.jodconverter.OfficeDocumentConverter(com.feezixlabs.util.Utility.JODConvertOfficeManager);
            converter.convert(file, htmlFile);


            
            String[] imageFiles = new java.io.File(workerFilePath).list(
            new java.io.FilenameFilter() {
                //@Override
                public boolean accept(java.io.File file, String name) {
                     return name.startsWith(fileName);
                    //throw new UnsupportedOperationException("Not supported yet.");
                }
            });

            static_references = new StringBuffer();
            static_references.append("[");
            boolean first = true;
            for(int i=0;i<imageFiles.length;i++){
                if(fileName.compareTo(imageFiles[i]) != 0 && imageFiles[i].compareTo(fileName+".html") != 0){
                    static_references.append((!first?",":"")+"{\"fileName\":\""+imageFiles[i]+"\"}");
                    //System.out.println(imageFiles[i]);
                    first = false;
                }
                //move to static directory
                org.apache.commons.io.FileUtils.moveFile(new java.io.File(workerFilePath+"/"+imageFiles[i]), new java.io.File(staticFilePath+"/"+imageFiles[i]));
            }
            static_references.append("]");

            docText = new StringBuffer();
            docText.append(org.apache.commons.io.FileUtils.readFileToString(new java.io.File(staticFilePath+"/"+fileName+".html")));

            //delete html
            new java.io.File(staticFilePath+"/"+fileName+".html").delete();
            new java.io.File(staticFilePath+"/"+fileName).delete();
        }
        else
        if(!doConversion)
        {
              profilePic = org.apache.commons.codec.digest.DigestUtils.md5Hex(com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName())+com.feezixlabs.struts.action.handler.UserActionHandler.ID_HASHER);
              new java.io.File(staticFilePath+"/"+profilePic).delete();

              //move to static directory
              org.apache.commons.io.FileUtils.moveFile(new java.io.File(workerFilePath+"/"+fileName), new java.io.File(staticFilePath+"/"+profilePic));
        }
    
    
    
            com.feezixlabs.bean.Feature feature = com.feezixlabs.db.dao.MiscDAO.getFeatureMatrixEntry("import");
            if(doConversion){
                com.feezixlabs.bean.FeatureUsage featureUsage = com.feezixlabs.db.dao.MiscDAO.getFeatureUsage(request.getUserPrincipal().getName(), feature.getId());
                com.feezixlabs.db.dao.MiscDAO.updateFeatureUsage(request.getUserPrincipal().getName(), feature.getId(), ""+(Integer.parseInt(featureUsage.getUsage())+1));
            }    
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
            function uploadImage(room_id){
                $('input[name=room_id]').val(room_id);
                document.fileposter.submit();
            }
            function imageURL(){
                return document.getElementById("uploaded_image").value;
            }
            function pageLoaded(){
                if(<%=request.getParameter("action")!=null&& request.getParameter("action").compareToIgnoreCase("upload-file")==0?"true":"false" %>){
                    var type = "<%=fileType %>";
                    if(type == "ms-word" && <%= doConversion%>){
                        $("#html_document_holder img").each(function(){
                           var absoluteUrl = top.ColabopadApplication.getFileServiceUrl($(this).attr("src"));
                           $(this).attr("src",absoluteUrl);
                        });
                    }
                    <% 
                        StringBuffer buf = new StringBuffer();
                        buf.append("{");
                        buf.append("\"from\":\""+from+"\",");
                        buf.append("\"docType\":\""+fileType+"\",");
                        buf.append("\"displayName\":\""+fileDisplayName+"\",");                        
                        buf.append("\"fsFileName\":\""+(profilePic.length()==0?fileName:profilePic)+"\",");
                        buf.append("\"pageCount\":"+pageCount+",");
                        buf.append("\"imgWidth\":"+width+",");
                        buf.append("\"imgHeight\":"+height+",");
                        buf.append("\"doc_text\":$(\"#html_document_holder\").html(),");
                        if(static_references != null)
                        buf.append("\"static_references\":\""+static_references.toString()+"\",");
                        buf.append("\"upgradeNeeded\":"+upgradeNeeded+"");
                        buf.append("}");
                    %>
                     top.ColabopadApplication.onUploadDone(<%=buf.toString()%>);
                    //top.ColabopadApplication.onUploadDone("<%=from %>","<%=fileType %>","<%=fileDisplayName %>","<%=profilePic.length()==0?fileName:profilePic %>",<%=pageCount %>,<%=width %>,<%=height %>,$("#html_document_holder").html(),<%=static_references != null?static_references.toString():"undefined" %>,<%= upgradeNeeded %>);
                    $("#html_document_holder").empty();
                }
            }
        </script>
    </head>
    <body style="padding:0;margin:0" onload="pageLoaded()">
        <form method="post" name="fileposter"  action="file-uploader.jsp?action=upload-file" enctype="multipart/form-data">
            <input type="hidden" name="file_name"/>
            <input type="hidden" name="do_conversion"/>
            <input type="hidden" name="from"/>
            <input type="hidden" name="room_id"/>
            <input type="hidden" name="page_dimensions"/>
            
            <table>
                <tr>
                    <td style="text-align:right">
                        Upload:
                    </td>
                    <td>
                        <input type="file" id="uploaded_file" name="uploaded_file"/>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">
                        <span class="file-type-options">Type:</span>
                    </td>
                    <td>
                        <select  class="file-type-options"  style="display:inline" name="file_type">
                            <option value="powerpoint">powerpoint</option>
                            <option value="pdf">pdf</option>
                            <option value="ms-word">ms-word</option>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
        <div id="html_document_holder" style="display:none"><%=docText!=null?docText.toString():"" %></div>

    </body>
</html>
