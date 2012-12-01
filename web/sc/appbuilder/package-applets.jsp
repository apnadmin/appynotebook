<%

    try{
            request.getSession().setAttribute("running_package_status","running");
            request.getSession().removeAttribute("error-message");        

            String baseDir = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory).getParent();
            //save dependencies first
            if(request.getParameter("lines") != null && !request.getParameter("lines").isEmpty())
                com.feezixlabs.struts.action.handler.WidgetActionHandler.setWidgetDependencySet(request);

            //Object u = null;u.getClass();
            //create work id
            String workId     = java.util.UUID.randomUUID().toString();
            String workingDir = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+"package-"+workId;

            String outputFileName = outputFileName = request.getParameter("zipfile_name") != null && !request.getParameter("zipfile_name").isEmpty()?request.getParameter("zipfile_name"):"appynotebook";
            //generate package manifest and copy resource to working directory
            StringBuilder buf = new StringBuilder();
            String[] appletids = request.getParameter("widgets") != null && !request.getParameter("widgets").isEmpty()?request.getParameter("widgets").split("#"):new String[0];
            String packageName = request.getParameter("applet_package_name") != null?request.getParameter("applet_package_name"):"";
            String packageVersion = request.getParameter("applet_package_version") != null?request.getParameter("applet_package_version"):"";
            String packageDesc = request.getParameter("applet_package_description") != null?request.getParameter("applet_package_description"):"";
            String packageLicense  = request.getParameter("applet_package_license") != null?request.getParameter("applet_package_license"):"";
            String packageDomain  = request.getParameter("applet_package_domain") != null?request.getParameter("applet_package_domain"):"";
            String packageForProdOnly  = request.getParameter("production_use_only") != null?request.getParameter("production_use_only"):"";
            
            String ebookPackage  = request.getParameter("ebook_package_export") != null && !request.getParameter("ebook_package_export").isEmpty()?request.getParameter("ebook_package_export"):"no";
            String contentOnly  = request.getParameter("content_only") != null && !request.getParameter("content_only").isEmpty()?request.getParameter("content_only"):"no";
            String binders = request.getParameter("binders") != null?request.getParameter("binders"):"";
            
            //String zipFileName  = request.getParameter("zipfile_name") != null && !request.getParameter("zipfile_name").isEmpty()?request.getParameter("zipfile_name"):"appynotebook";
            workId  = request.getParameter("zipfile_uuid") != null && !request.getParameter("zipfile_uuid").isEmpty()?request.getParameter("zipfile_uuid"):workId;
            
            
            
            if(!binders.isEmpty()){
                workingDir = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+"ebook-"+workId;
                new java.io.File(workingDir).mkdirs();                
                
                if(contentOnly.compareTo("no") == 0){                    

                    org.apache.commons.io.FileUtils.copyDirectoryToDirectory( new java.io.File(baseDir+"/portable-appynotebook"), new java.io.File(workingDir));
                    new java.io.File(workingDir+"/portable-appynotebook").renameTo(new java.io.File(workingDir+"/"+outputFileName));
                    workingDir = workingDir+"/"+outputFileName+"/p/nd/apps";
                }
                else
                {
                    workingDir = workingDir+"/ebook/apps";                    
                    new java.io.File(workingDir).mkdirs();
                }
            }
            else
            {            
                //create working directory
                java.io.File workingDirFile = new java.io.File(workingDir);
                workingDirFile.mkdirs();
            }            

            //String installationKey = "";
            //if(packageDomain.length() == 0 && packageForProdOnly.compareToIgnoreCase("false") == 0)
            //    installationKey = com.feezixlabs.util.ConfigUtil.NO_RESTRICTIONS;
            java.util.Map packageRoot = new java.util.HashMap();
            packageRoot.put("name",packageName);
            packageRoot.put("version",packageVersion);
            packageRoot.put("description",packageDesc);
            packageRoot.put("license",packageLicense);
            packageRoot.put("uuid",workId);
            java.util.List appList = new java.util.ArrayList();
            packageRoot.put("applets",appList);

            buf.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
            buf.append("<ns1:package  xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:ns1='http://xml.netbeans.org/schema/applet-package' xsi:schemaLocation='http://xml.netbeans.org/schema/applet-package file:/home/bitlooter/development/java/feezixlabs/src/java/com/feezixlabs/util/applet-package.xsd'>\n");
            buf.append(" <ns1:name>"+packageName+"</ns1:name>\n");
            buf.append(" <ns1:version>"+packageVersion+"</ns1:version>\n");
            buf.append(" <ns1:description>"+packageDesc+"</ns1:description>\n");
            buf.append(" <ns1:license>"+packageLicense+"</ns1:license>\n");
            buf.append(" <ns1:uuid>"+workId+"</ns1:uuid>\n");
            buf.append(" <ns1:applets>\n");
            for(int i=0;i<appletids.length;i++){
                com.feezixlabs.bean.Widget applet = com.feezixlabs.db.dao.WidgetDAO.getWidget(new Integer(appletids[i]),"dev");
                buf.append("  <ns1:applet>\n");
                buf.append("   <ns1:id>"+applet.getUniqueKey()+"</ns1:id>\n");
                buf.append("   <ns1:name>"+applet.getName()+"</ns1:name>\n");
                buf.append("   <ns1:description>"+applet.getDescription()+"</ns1:description>\n");
                buf.append("   <ns1:iconPath>"+applet.getIconId()+"</ns1:iconPath>\n");
                buf.append("   <ns1:version>"+applet.getVersion()+"</ns1:version>\n");
                buf.append("   <ns1:authorName>"+applet.getAuthorName()+"</ns1:authorName>\n");
                buf.append("   <ns1:authorLink>"+applet.getAuthorLink()+"</ns1:authorLink>\n");
                buf.append("   <ns1:categoryId>"+applet.getCategory()+"</ns1:categoryId>\n");
                buf.append("   <ns1:tags>"+applet.getTags()+"</ns1:tags>\n");
                buf.append("   <ns1:createDate>"+applet.getCreateDate()+"</ns1:createDate>\n");
                buf.append("   <ns1:lastModifiedDate>"+applet.getLastModDate()+"</ns1:lastModifiedDate>\n");
                buf.append("   <ns1:showInMenu>"+applet.getShowInMenu()+"</ns1:showInMenu>\n");
                buf.append("   <ns1:codePath>"+workId+"</ns1:codePath>\n");

                //process resources
                buf.append("   <ns1:resources>\n");
                buf.append("   </ns1:resources>\n");
                
                java.util.Map app = new java.util.HashMap();
                app.put("id",applet.getUniqueKey());
                app.put("name",applet.getName());
                app.put("description",applet.getDescription());
                app.put("version",applet.getVersion());
                app.put("authorName",applet.getAuthorName());
                app.put("authorLink",applet.getAuthorLink());
                app.put("categoryId",applet.getCategory());
                app.put("tags",applet.getTags());
                app.put("createDate",applet.getCreateDate().getTime());
                app.put("lastModifiedDate",applet.getLastModDate().getTime());
                app.put("showInMenu",applet.getShowInMenu());
                appList.add(app);

                //process any dependencies for this applet
                java.util.List<com.feezixlabs.bean.WidgetDependency> dependencies = com.feezixlabs.db.dao.WidgetDAO.getWidgetDependencies(new Integer(appletids[i]));
                if(dependencies.size()>0){

                    //create dependency directory
                    java.io.File workingDirFileDependencies = new java.io.File(workingDir+"/app-"+applet.getUniqueKey()+"/dependencies");
                    workingDirFileDependencies.mkdir();


                    StringBuilder depBuff = new StringBuilder();

                    for(com.feezixlabs.bean.WidgetDependency dependency:dependencies){
                        //copy dependency
                        java.io.File dependencyFileFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/library/"+dependency.getDependencyPath());
                        if(dependencyFileFrom.isFile()){
                            depBuff.append("    <ns1:resource>\n");
                            depBuff.append("     <ns1:fileName>"+dependency.getDependencyPath()+"</ns1:fileName>\n");
                            depBuff.append("    </ns1:resource>\n");

                            java.io.File dependencyFileTo = new java.io.File(workingDir+"/app-"+applet.getUniqueKey()+"/dependencies/"+dependency.getDependencyPath()).getParentFile();
                            org.apache.commons.io.FileUtils.copyFileToDirectory(dependencyFileFrom, dependencyFileTo);
                        }
                    }
                    if(depBuff.length()>0){
                        buf.append("   <ns1:dependencies>\n");
                        buf.append(depBuff.toString());
                        buf.append("   </ns1:dependencies>\n");
                    }
                }
                //now copy the resources to working directory
                java.io.File appletResourcesDir = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+applet.getUniqueKey()+"/resources");
                java.io.File workingDirFileResource = new java.io.File(workingDir+"/app-"+applet.getUniqueKey());
                org.apache.commons.io.FileUtils.copyDirectoryToDirectory(appletResourcesDir, workingDirFileResource);

                //write applet code
                java.io.File codeFile = new java.io.File(workingDir+"/app-"+applet.getUniqueKey()+"/resources/code-"+workId+".js");
                org.apache.commons.io.FileUtils.writeStringToFile(codeFile, applet.getCode());

                if(ebookPackage.compareTo("yes") == 0 || !binders.isEmpty()){

                    StringBuilder codebuf = new StringBuilder();
                    codebuf.append("ts="+new java.util.Date().getTime()+"; (function(){newApplet = new Widget('prod',"+applet.getId()+",'"+applet.getUniqueKey()+"','"+applet.getName()+"',");
                    codebuf.append(applet.getCode()+"); newApplet.impl.init();})();");   

                    java.io.File appCodeFile = new java.io.File(workingDir+"/app-"+applet.getUniqueKey()+"/resources/app.js");
                    org.apache.commons.io.FileUtils.writeStringToFile(appCodeFile, codebuf.toString());     

                    //walk directory and append dynamic import callback to javascript files    
                    String[] exts = {"js"};
                    java.util.Iterator itr = org.apache.commons.io.FileUtils.listFiles(new java.io.File(workingDir+"/app-"+applet.getUniqueKey()+"/resources"), exts, true).iterator();
                    while(itr.hasNext()){
                        java.io.File jsFile = (java.io.File)itr.next();

                        String importPath = jsFile.getAbsolutePath().substring(workingDir.length());

                        StringBuilder jsSrc = new StringBuilder();
                        jsSrc.append(org.apache.commons.io.FileUtils.readFileToString(jsFile));

                        jsSrc.append("\n if(typeof ColabopadApplication != \"undefined\")ColabopadApplication.importer.import_ready('"+importPath+"');");
                        org.apache.commons.io.FileUtils.writeStringToFile(jsFile, jsSrc.toString());  
                    }
                }

                buf.append("  </ns1:applet>\n");
            }
            buf.append(" </ns1:applets>\n");
            buf.append("</ns1:package>");


           if(!binders.isEmpty()){
               
                java.io.File manifesFile = new java.io.File(workingDir+"/manifest-"+workId+".js");
                org.apache.commons.io.FileUtils.writeStringToFile(manifesFile, net.sf.json.JSONObject.fromObject(packageRoot).toString());
               
                if(contentOnly.compareTo("no") == 0){                    
               
                    java.io.File installedPackages = new java.io.File(workingDir+"/installed-packages.js");

                    net.sf.json.JSONArray packages = net.sf.json.JSONArray.fromObject(org.apache.commons.io.FileUtils.readFileToString(installedPackages));
                    packages.add("manifest-"+workId+".js");

                    //save package, this would be used for discovering installed packages
                    org.apache.commons.io.FileUtils.writeStringToFile(installedPackages, packages.toString()); 
                }
            }else{
                //write out manifest
                java.io.File manifesFile = new java.io.File(workingDir+"/manifest.xml");
                org.apache.commons.io.FileUtils.writeStringToFile(manifesFile, buf.toString());

                manifesFile = new java.io.File(ebookPackage.compareTo("no") == 0?workingDir+"/manifest.js":workingDir+"/manifest-"+workId+".js");
                org.apache.commons.io.FileUtils.writeStringToFile(manifesFile, net.sf.json.JSONObject.fromObject(packageRoot).toString());
            }
            
            
            
            
            java.io.File zipFile = null;
            if(!binders.isEmpty()){
                
                if(contentOnly.compareTo("no") == 0){
                    

                    //write content of binders
                    String eBook = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+"ebook-"+workId+"/"+outputFileName+"/p/nd/e-books/pack-"+workId+".js";
                    org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(eBook), net.sf.json.JSONArray.fromObject(com.feezixlabs.struts.action.handler.PadUIActionHandler.getBinders(request)).toString());

                    //write default to library
                    java.io.File eBookLibrary = new java.io.File(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+"ebook-"+workId+"/"+outputFileName+"/p/nd/e-books/appynotebook-library.js");
                    net.sf.json.JSONArray appynotebooklibrary = net.sf.json.JSONArray.fromObject(org.apache.commons.io.FileUtils.readFileToString(eBookLibrary));
                    appynotebooklibrary.add("pack-"+workId+".js");

                    org.apache.commons.io.FileUtils.writeStringToFile(eBookLibrary, appynotebooklibrary.toString());

                    //write unique key for this package
                    java.io.File packageIdFile = new java.io.File(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+"ebook-"+workId+"/"+outputFileName+"/p/nd/uuid.txt");
                    org.apache.commons.io.FileUtils.writeStringToFile(packageIdFile, workId);

                    String folderToZip = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+"ebook-"+workId+"/"+outputFileName;
                    //zip everything up
                    com.feezixlabs.util.ZipDir.zipDir(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+"ebook-"+workId,folderToZip+".zip", folderToZip);

                    zipFile = new java.io.File(folderToZip+".zip");
                }else{
                    outputFileName = "ebook";
                    //write content of binders
                    String eBook = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+"ebook-"+workId+"/ebook/pack-"+workId+".js";
                    org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(eBook), net.sf.json.JSONArray.fromObject(com.feezixlabs.struts.action.handler.PadUIActionHandler.getBinders(request)).toString());

                    String folderToZip = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+"ebook-"+workId+"/ebook";
                    //zip everything up
                    com.feezixlabs.util.ZipDir.zipDir(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+"ebook-"+workId,folderToZip+".zip", folderToZip);

                    zipFile = new java.io.File(folderToZip+".zip");                    
                }               
                
            }else{
                outputFileName = "package-"+workId;
                //zip everything up
                com.feezixlabs.util.ZipDir.zipDir(com.feezixlabs.util.ConfigUtil.temp_upload_directory,workingDir+".zip", workingDir);
                
                //delete working directory
                org.apache.commons.io.FileUtils.deleteDirectory(new java.io.File(workingDir));
                
                zipFile = new java.io.File(workingDir+".zip");                
            }
            //set response content
            response.setHeader("Content-disposition", "attachment; filename="+outputFileName+".zip");
            //response.setHeader("Content-disposition", "attachment; filename="+packageName.replaceAll(" ", "_") +".zip");
            response.setHeader("Content-Transfer-Encoding", "binary");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            response.setHeader("Content-Length",""+ zipFile.length());
            response.setContentType("application/zip");

            
            
            //write zip file output stream
            java.io.OutputStream o = response.getOutputStream();

            java.io.InputStream is = new java.io.FileInputStream(zipFile);
            byte[] buff = new byte[32 * 1024]; // 32k buffer
            int nRead = 0;
            while( (nRead=is.read(buff)) != -1 ) {
                o.write(buff, 0, nRead);
            }
            
            o.flush();
            //delete zip file
            zipFile.delete();
            
            if(!binders.isEmpty()){
                workingDir = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+"ebook-"+workId;
                org.apache.commons.io.FileUtils.deleteDirectory(new java.io.File(workingDir));
            }
            
            request.getSession().setAttribute("running_package_status","done");
       }catch(Exception ex){
            request.getSession().removeAttribute("running_package_status"); 

            //ex.printStackTrace();
            java.util.HashMap error = new java.util.HashMap();
            error.put("type","exception");

            if(request.getSession().getAttribute("error-message") == null){            
                error.put("stack_trace",org.apache.commons.lang.exception.ExceptionUtils.getStackTrace(ex));
            }else{
                error.put("stack_trace",request.getSession().getAttribute("error-message").toString());
            }
            request.getSession().setAttribute("exception",net.sf.json.JSONObject.fromObject(error).toString());

            Thread.sleep(5000);//wait for client to get error condition
            response.sendRedirect(response.encodeRedirectURL("package-error.jsp"));           
       }
%>