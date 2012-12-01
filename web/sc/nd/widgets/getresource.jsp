<%
    try{

        
        String env = request.getParameter("env");
        String widget_id = request.getParameter("widgetid");
        //com.feezixlabs.bean.Resource resource = null;
        String fullFilePath = request.getParameter("file_name");
        String filePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/"+env+"/";
        String fileName = "";
        
        /***
        String[] file_parts = request.getParameter("file_name").split("/");
        if(file_parts.length==1){
            resource = com.feezixlabs.db.dao.WidgetResourceDAO.getResource(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid")), request.getParameter("file_name"),env );
            if(resource != null){
                fullFilePath = resource.getFsName();
                fileName = resource.getFileName();
            }
        }
        else{
            resource = com.feezixlabs.db.dao.WidgetResourceDAO.getResource(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid")), file_parts[0],env );
            if(resource != null){
                fullFilePath = resource.getFsName()+"/"+request.getParameter("file_name").substring(request.getParameter("file_name").indexOf("/")+1,request.getParameter("file_name").length());

            }
        }***/

        //System.out.println("requesting:"+request.getParameter("widgetid")+"/"+request.getParameter("file_name"));
        String fullResourcePath = filePath+"app-"+request.getParameter("widgetid")+"/resources/"+fullFilePath;

        //System.out.println("file-path:"+fullResourcePath);

        java.io.File resourceFile = new java.io.File(fullResourcePath);
        String mime =  null;


        java.io.InputStream defaultAppIcon = null;

        if(fullFilePath.compareTo("favicon.png") == 0 && !resourceFile.exists()){//send default icon
           defaultAppIcon = com.feezixlabs.util.ConfigUtil.class.getClassLoader().getResourceAsStream("com/feezixlabs/util/application-default-icon.png");
           mime = "image/png";
        }
        else
        if(fullFilePath.compareTo("app-store-favicon.png") == 0 && !resourceFile.exists()){//send default icon
           defaultAppIcon = com.feezixlabs.util.ConfigUtil.class.getClassLoader().getResourceAsStream("com/feezixlabs/util/application-default-icon-64x64.png");
           mime = "image/png";
        }
        

        if(/*resource != null && */resourceFile.exists() || defaultAppIcon != null){

            //System.out.println(mime+defaultAppIcon);
            if(mime == null){
                if(fileName.length() == 0)
                    fileName  = resourceFile.getName();

                String ext = "";

                if(fileName.lastIndexOf(".") != -1)
                    ext = fileName.substring(fileName.lastIndexOf("."));


                mime =  com.feezixlabs.util.ConfigUtil.ext2mime_mapping.get(ext);
                

                if(mime == null || mime.length() == 0){
                    java.util.Collection<?> mimeTypes = eu.medsea.mimeutil.MimeUtil.getMimeTypes(resourceFile);
                    java.util.Iterator itr = mimeTypes.iterator();
                    while(itr.hasNext()){
                        mime = itr.next().toString();
                        break;
                    }
                }
            }
            /***
            System.out.println(mimeTypes);

            String mime =  resource.getType().compareToIgnoreCase("zip") != 0 && resource.getMime() != null && resource.getMime() != ""?resource.getMime(): new net.sf.jmimemagic.Magic().getMagicMatch(resourceFile,true,true).getMimeType();
            
            System.out.println("USING MIME:"+mime);
            ***/
            //System.out.println(mime);
            
            response.setContentType(mime);
            //response.setHeader("Content-disposition", "attachment; filename=note.png");
            //if(resource.getType().compareToIgnoreCase("binary") == 0)
            //    response.setHeader("Content-Transfer-Encoding", "binary");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            //write to response outputstream
            //response.setHeader("Content-Length",""+ resourceFile.length());


            java.io.OutputStream o = response.getOutputStream();
            java.io.InputStream is =  null;

            if(mime.compareTo("text/html") == 0){
                is = new java.io.ByteArrayInputStream(org.apache.commons.io.FileUtils.readFileToString(resourceFile).replaceAll("phyzixlabs-local://", "/importer-"+env+"-"+widget_id+"/").replaceAll("phyzixlabs-global://", "/importer/38f60efcb83b11df9f620019b958a435-"+env+"-"+widget_id+"/").getBytes());
            }else{
                is = defaultAppIcon != null?defaultAppIcon:new java.io.FileInputStream(resourceFile);
            }
            byte[] buf = new byte[32 * 1024]; // 32k buffer
            int nRead = 0;
            while( (nRead=is.read(buf)) != -1 ) {
                o.write(buf, 0, nRead);
            }
            o.flush();
            o.close();// *important* to ensure no more jsp output
            is.close();
            
        }else{
            //System.out.println("RESOURCE NOT FOUND:"+fullResourcePath);
            }
    }catch(Exception ex){
        //ex.printStackTrace();
    }
%>