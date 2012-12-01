/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.struts.action.handler;

import javax.servlet.http.HttpServletRequest;
import com.feezixlabs.bean.Resource;
import com.feezixlabs.bean.Widget;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.File;
import java.io.Writer;
import java.io.FileNotFoundException;
import java.io.IOException;

/**
 *
 * @author bitlooter
 */
public class WidgetResourceActionHandler {
    static String getResources(HttpServletRequest request){
        StringBuffer xmlbuf = new StringBuffer();
        String env = request.getParameter("env");
        xmlbuf.append("{\n");

        java.util.List<Resource> resources = com.feezixlabs.db.dao.WidgetResourceDAO.getResources(request.getUserPrincipal().getName(),new Integer(request.getParameter("widgetid")),request.getParameter("env") );

        xmlbuf.append("page:'1',\n");
        xmlbuf.append("total:'1',\n");
        xmlbuf.append("record:'"+resources.size()+"',\n");
        //rows

        xmlbuf.append("rows:[\n");

        boolean first = true;
        for(Resource resource:resources){
            if(!first)
                xmlbuf.append(",");

            xmlbuf.append("{id:'"+resource.getFileName()+"',cell:[");
            xmlbuf.append("'"+resource.getFileName()+"',");
            xmlbuf.append("'"+resource.getLabel()+"',");
            xmlbuf.append("'"+resource.getType()+"',");
            xmlbuf.append("'"+resource.getMime()+"',");
            xmlbuf.append("'"+resource.getSize()+"',");
            xmlbuf.append("'"+resource.getCreateDate()+"',");
            xmlbuf.append("'"+resource.getLastModDate()+"',");

            if(env.compareToIgnoreCase("dev")==0||env.compareToIgnoreCase("rejected")==0)
                xmlbuf.append("'<input type=\"image\" src=\"img/del-doc.png\" onclick=\"deleteResource("+resource.getWidgetId()+",\\'"+resource.getFileName()+"\\',\\'"+request.getParameter("env") +"\\')\"/>'");
            else
                xmlbuf.append("''");

            xmlbuf.append("]}\n");
            first = false;
        }
        xmlbuf.append("]\n");
        xmlbuf.append("}\n");
        return xmlbuf.toString();
    }

    public static String getResourcesExt(HttpServletRequest request){
        StringBuffer xmlbuf = new StringBuffer();
        String env = request.getParameter("env");

        java.util.List<Resource> resources = com.feezixlabs.db.dao.WidgetResourceDAO.getResources(request.getUserPrincipal().getName(),new Integer(request.getParameter("widgetid")),request.getParameter("env") );

        xmlbuf.append("<?xml version='1.0' encoding='utf-8'?>\n");
        xmlbuf.append("<rows>");
        xmlbuf.append(" <page>1</page>");
        xmlbuf.append(" <total>1</total>");
        xmlbuf.append(" <records>"+resources.size()+"</records>");
        for(Resource resource:resources){
            String rootDir = com.feezixlabs.util.ConfigUtil.resource_directory+"/"+env+"/applet-"+resource.getWidgetId()+"/resources/"+resource.getFsName();
            xmlbuf.append(com.feezixlabs.util.ResourceFileSystem.buildGrid(rootDir, resource, env));
        }
        xmlbuf.append("</rows>\n");
        return xmlbuf.toString();
    }

    static String saveResourceItem(HttpServletRequest request){
        String replyMsg = "{status:'failed'}";
        String env  = request.getParameter("env");
        String itemPath = request.getParameter("path");
        String resourceItemPath = "";

        Resource rs = null;//com.feezixlabs.db.dao.WidgetResourceDAO.getResource(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid")), request.getParameter("file_name"),request.getParameter("env") );
        String resourceBaseDir = com.feezixlabs.util.ConfigUtil.resource_directory+"/"+env+"/app-"+request.getParameter("uuid")+"/resources";

        if(!com.feezixlabs.db.dao.UserDOA.hasAppletActionRights(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid"))))
            return "{\"status\":\"failure\",\"msg\":\"Security Violation\"}";

        if(/*rs != null*/false){
            if(itemPath.compareTo(rs.getFileName()) == 0){
                if(rs.getType().compareTo("zip") == 0) return replyMsg;

                resourceItemPath = resourceBaseDir + "/"+rs.getFsName();
            }else{
                resourceItemPath = resourceBaseDir +"/"+ rs.getFsName()+ itemPath.substring(rs.getFileName().length());
            }
        }else{
            itemPath = request.getParameter("relPath");
            resourceItemPath = resourceBaseDir +"/"+ itemPath;
        }

        Writer writer = null;

        try
        {
            String text = request.getParameter("data");

            File file = new File(resourceItemPath);
            writer = new BufferedWriter(new FileWriter(file));
            writer.write(text);
        } catch (FileNotFoundException e)
        {
            e.printStackTrace();
        } catch (IOException e)
        {
            e.printStackTrace();
        } finally
        {
            try
            {
                if (writer != null)
                {
                    writer.close();
                }
            } catch (IOException e)
            {
                e.printStackTrace();
            }
        }
        return "{status:'success'}";
    }




    static String unpackImportedPackage(HttpServletRequest request){

        String replyMsg = "{\"status\":\"failed\"}";
        if(!request.isUserInRole("sysadmin")){
            if(!request.isUserInRole("developer") || !com.feezixlabs.util.ConfigUtil.enable_applet_import)
                return replyMsg;
        }
        
        int clbSizelimit = 100000000;
        // Check that we have a file upload request
        boolean isMultipart = org.apache.commons.fileupload.servlet.ServletFileUpload.isMultipartContent(request);
        if(isMultipart){
            try{
                // Create a factory for disk-based file items
                org.apache.commons.fileupload.FileItemFactory factory = new org.apache.commons.fileupload.disk.DiskFileItemFactory();

                ((org.apache.commons.fileupload.disk.DiskFileItemFactory)factory).setSizeThreshold(clbSizelimit);

                // Create a new file upload handler
                org.apache.commons.fileupload.servlet.ServletFileUpload upload = new org.apache.commons.fileupload.servlet.ServletFileUpload(factory);

                // Parse the request
                java.util.List /* FileItem */ items = upload.parseRequest(request);

                org.apache.commons.fileupload.FileItem rsFile = null;
                String categoryId = "";
                java.util.Iterator iter = items.iterator();
                while (iter.hasNext()) {
                    org.apache.commons.fileupload.FileItem item = (org.apache.commons.fileupload.FileItem) iter.next();
                    if (!item.isFormField()) {
                        rsFile = item;
                        break;
                    }
                    else
                    if(item.getFieldName().compareToIgnoreCase("category_id")==0)
                            categoryId = item.getString();
                }

                String packageBaseDir = com.feezixlabs.util.ConfigUtil.resource_directory+"/packages/temp";
                String fileName = java.util.UUID.randomUUID().toString();
                java.io.File file = new java.io.File(packageBaseDir+"/p-"+fileName);
                rsFile.write(file);

                String manifestPath = com.feezixlabs.util.Unzip.unpack(file.getAbsolutePath(),packageBaseDir);                
                //import into user's resources
                importAppletsFromPackage(request.getUserPrincipal().getName(),manifestPath.substring(0,manifestPath.indexOf("/manifest.xml")),categoryId);

                file.delete();

                replyMsg =  "{\"status\":\"success\"}";
                request.setAttribute("replyMsg",replyMsg);
                request.setAttribute("package-uploaded", "true");
            }
            catch(Exception ex){
                ex.printStackTrace();
            }
        }return replyMsg;
    }




    public static String importAppletsFromPackage(String userName,String packagePath,String categoryId){
        
        try{
                try
                {
                        javax.xml.bind.JAXBContext jaxbContext = javax.xml.bind.JAXBContext.newInstance("com.feezixlabs.util.appletpackage");
                        javax.xml.bind.Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();

                        Object obj = unmarshaller.unmarshal(new java.io.FileInputStream(new java.io.File(packagePath+"/manifest.xml")));

                        com.feezixlabs.util.appletpackage.Package appletPackage = (com.feezixlabs.util.appletpackage.Package)obj;

                        int userId = com.feezixlabs.db.dao.UserDOA.getUserId(userName);
                        for(com.feezixlabs.util.appletpackage.Applet applet:appletPackage.getApplets().getApplet()){
                              Widget widget = new Widget();
                              widget.setCreatorId(userId);
                              widget.setName(applet.getName());
                              widget.setDescription(applet.getDescription());
                              widget.setDevToxonomy(categoryId);
                              widget.setTags(applet.getTags());
                              widget.setPrice(0);
                              widget.setCatalogPage(0);
                              widget.setAuthorName(applet.getAuthorName());
                              widget.setAuthorLink(applet.getAuthorLink());
                              widget.setCode(org.apache.commons.io.FileUtils.readFileToString(new java.io.File(packagePath+"/app-"+applet.getId()+"/resources/code-"+applet.getCodePath()+".js")));
                              widget.setVersion(applet.getVersion());
                              widget.setId(com.feezixlabs.db.dao.WidgetDAO.addWidget(widget));
                              
                              widget = com.feezixlabs.db.dao.WidgetDAO.getWidget(widget.getId(), "dev");
                              
                              //move files
                              java.io.File appletFrom = new java.io.File(packagePath+"/app-"+applet.getId());
                              java.io.File appletTo = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+widget.getUniqueKey());

                              for(java.io.File f:appletFrom.listFiles()){
                                      if(f.isDirectory())
                                          org.apache.commons.io.FileUtils.copyDirectoryToDirectory(f, appletTo);
                                      else
                                          org.apache.commons.io.FileUtils.copyFile(f, appletTo);
                              }
                              //remove code
                              new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+widget.getUniqueKey()+"/resources/code-"+applet.getCodePath()+".js").delete();
                        }
                        return "{\"status\":\"success\"}";
                }catch(Exception ex){
                    ex.printStackTrace();
                }
        }catch(Exception ex){
            ex.printStackTrace();
        }return "{\"status\":\"failure\"}";
    }




    static String unpackPackage(HttpServletRequest request){

        String replyMsg = "{status:'failed'}";


        int clbSizelimit = 100000000;
        // Check that we have a file upload request
        boolean isMultipart = org.apache.commons.fileupload.servlet.ServletFileUpload.isMultipartContent(request);
        if(isMultipart){
            try{
                // Create a factory for disk-based file items
                org.apache.commons.fileupload.FileItemFactory factory = new org.apache.commons.fileupload.disk.DiskFileItemFactory();

                ((org.apache.commons.fileupload.disk.DiskFileItemFactory)factory).setSizeThreshold(clbSizelimit);

                // Create a new file upload handler
                org.apache.commons.fileupload.servlet.ServletFileUpload upload = new org.apache.commons.fileupload.servlet.ServletFileUpload(factory);

                // Parse the request
                java.util.List /* FileItem */ items = upload.parseRequest(request);

                org.apache.commons.fileupload.FileItem rsFile = null;
                String action = "";
                java.util.Iterator iter = items.iterator();
                while (iter.hasNext()) {
                    org.apache.commons.fileupload.FileItem item = (org.apache.commons.fileupload.FileItem) iter.next();
                    if (!item.isFormField()) {
                        rsFile = item;
                        break;
                    }
                }
                
                String packageBaseDir = com.feezixlabs.util.ConfigUtil.resource_directory+"/packages";
                String fileName = java.util.UUID.randomUUID().toString();
                java.io.File file = new java.io.File(packageBaseDir+"/p-"+fileName);
                rsFile.write(file);

                String manifestPath = com.feezixlabs.util.Unzip.unpack(file.getAbsolutePath(),packageBaseDir);
                file.delete();


                //load package info into database
                try
                {
                    javax.xml.bind.JAXBContext jaxbContext = javax.xml.bind.JAXBContext.newInstance("com.feezixlabs.util.appletpackage");
                    javax.xml.bind.Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();

                    Object obj = unmarshaller.unmarshal(new java.io.FileInputStream(new java.io.File(manifestPath)));

                    com.feezixlabs.util.appletpackage.Package appletPackage = (com.feezixlabs.util.appletpackage.Package)((obj));
                    com.feezixlabs.db.dao.AppletPackageDAO.addAppletPackage(appletPackage.getUuid(), appletPackage.getName(), appletPackage.getDescription(),appletPackage.getVersion());


                    for(com.feezixlabs.util.appletpackage.Applet applet:appletPackage.getApplets().getApplet()){
                        com.feezixlabs.db.dao.AppletPackageDAO.addPackagedApplet(appletPackage.getUuid(), new Integer(applet.getId()), applet.getName(), applet.getDescription());
                    }
                }catch(Exception ex){
                    ex.printStackTrace();
                }

                replyMsg =  "{status:'success'}";
                request.setAttribute("replyMsg",replyMsg);
                request.setAttribute("package-uploaded", "true");
            }
            catch(Exception ex){
                ex.printStackTrace();
            }
        }return replyMsg;
    }

    public static String moveResource(HttpServletRequest request){
        
        if(!com.feezixlabs.db.dao.UserDOA.hasAppletActionRights(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid"))))
            return "{\"status\":\"failure\",\"msg\":\"Security Violation\"}";
        if(!com.feezixlabs.db.dao.UserDOA.hasAppletActionRights(request.getUserPrincipal().getName(), new Integer(request.getParameter("towidgetid"))))
            return "{\"status\":\"failure\",\"msg\":\"Security Violation\"}";

        String fromRelPath  = request.getParameter("fromRelPath");
        String toRelPath  = request.getParameter("toRelPath");

        String fromBasePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+request.getParameter("uuid")+"/resources";
        String toBasePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+request.getParameter("touuid")+"/resources";

        String newRelPath = toRelPath+"/"+fromRelPath.split("/")[fromRelPath.split("/").length-1];

        java.io.File fileToMove = new java.io.File(fromBasePath+"/"+fromRelPath);
        java.io.File moveToDest = new java.io.File(toBasePath+"/"+toRelPath);//new java.io.File(newRelPath);
        java.io.File overWrite  = new java.io.File(toBasePath+"/"+newRelPath);

        //don't support overwrite
        if(moveToDest.isDirectory() && !overWrite.exists()){
            try{
                org.apache.commons.io.FileUtils.moveToDirectory(fileToMove, moveToDest, false);
                return "{\"status\":\"success\",\"relPath\":\""+newRelPath+"\"}";
            }catch(java.io.IOException ex){
                ex.printStackTrace();
            }
        }
        return "{'status':'failure'}";
    }


    public static String pasteResource(HttpServletRequest request){
        String fromRelPath  = request.getParameter("fromRelPath");
        String toRelPath  = request.getParameter("toRelPath");
        int appletId = new Integer(request.getParameter("widget_id"));

        if(!com.feezixlabs.db.dao.UserDOA.hasAppletActionRights(request.getUserPrincipal().getName(), appletId))
            return "{\"status\":\"failure\",\"msg\":\"Security Violation\"}";

        String basePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/applet-"+request.getParameter("widget_id")+"/resources";

        String newRelPath = toRelPath+"/"+fromRelPath.split("/")[fromRelPath.split("/").length-1];

        java.io.File fileToMove = new java.io.File(basePath+"/"+fromRelPath);
        java.io.File moveToDest = new java.io.File(basePath+"/"+toRelPath);//new java.io.File(newRelPath);

        //don't support overwrite
        if(moveToDest.isDirectory() && !moveToDest.exists()){
            try{
                if(fileToMove.isFile())
                    org.apache.commons.io.FileUtils.copyFileToDirectory(fileToMove, moveToDest, false);
                else
                    org.apache.commons.io.FileUtils.copyDirectoryToDirectory(fileToMove, moveToDest);

                return "{\"status\":\"success\",\"relPath\":\""+newRelPath+"\"}";
            }catch(java.io.IOException ex){
                ex.printStackTrace();
            }
        }
        return "{'status':'failure'}";
    }

    static String renameResource(HttpServletRequest request){
        String relPath  = request.getParameter("relPath");
        String mimeType = request.getParameter("mimeType");
        String oldName  = request.getParameter("oldName");
        String fileName = request.getParameter("fileName");///getFileNameSansMimeType(request.getParameter("fileName"),mimeType);
        //System.out.println("renaming "+fileName);

        if(!com.feezixlabs.db.dao.UserDOA.hasAppletActionRights(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid"))))
            return "{\"status\":\"failure\",\"msg\":\"Security Violation\"}";

        fileName = (mimeType.compareToIgnoreCase("folder") == 0)?fileName:fileName+"."+mimeType;
        int    appletId = new Integer(request.getParameter("widgetid"));
        String path = com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+request.getParameter("uuid")+"/resources";

        if(/*relPath.indexOf("/") == -1*/false){
            Resource rs = com.feezixlabs.db.dao.WidgetResourceDAO.getResource(request.getUserPrincipal().getName(), appletId,fileName,"dev");
            if(rs != null)return "{status:'failed'}";

            rs = com.feezixlabs.db.dao.WidgetResourceDAO.getResource(request.getUserPrincipal().getName(), appletId, oldName,"dev");
            rs.setFileName(fileName);
            com.feezixlabs.db.dao.WidgetResourceDAO.updateResource(request.getUserPrincipal().getName(),oldName, rs);

            return "{\"status\":\"success\",\"relPath\":\""+rs.getFsName()+"\"}";
        }else{
            java.io.File existingFile = new java.io.File(path+"/"+relPath);
            java.io.File newFile = new java.io.File(existingFile.getParentFile().getAbsolutePath()+"/"+fileName);
            if(newFile.exists())
                return "{status:'failed'}";
            
            existingFile.renameTo(newFile);
            String relativePath = newFile.getAbsolutePath().substring(path.length()+1);
            return "{\"status\":\"success\",\"relPath\":\""+relativePath+"\"}";
        }
        
    }
   static String createResource(HttpServletRequest request){
        String relPath  = request.getParameter("relPath");
        String mimeType = request.getParameter("mimeType");
        String fileName = (mimeType.compareToIgnoreCase("folder") == 0)?request.getParameter("fileName"):request.getParameter("fileName")+"."+mimeType;
        int    appletId = new Integer(request.getParameter("widgetid"));
        String path = com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+request.getParameter("uuid")+"/resources";


        if(!com.feezixlabs.db.dao.UserDOA.hasAppletActionRights(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid"))))
            return "{\"status\":\"failure\",\"msg\":\"Security Violation\"}";

        String isFolder = (mimeType.compareToIgnoreCase("folder") == 0)?",\"isFolder\":true,\"isLazy\":true,\"addClass\":\"phyzixlabs-resource-dir\",\"type\":\"phyzixlabs-resource-dir\"":",\"isFolder\":false,\"addClass\":\"phyzixlabs-resource-file\",\"type\":\"phyzixlabs-resource-file\"";
        String reply = "{\"title\":\""+fileName+"\""+isFolder+",\"relPath\":\""+relPath+"/"+"\",\"widget_id\":"+appletId+",\"uuid\":\""+request.getParameter("uuid")+"\",\"children\":[]}";



        try{
            if(/*relPath.length() == 0*/false){
                Resource rs = com.feezixlabs.db.dao.WidgetResourceDAO.getResource(request.getUserPrincipal().getName(), appletId, fileName,"dev");
                if(rs != null)return "{status:'failed'}";
                
                rs = new Resource();
                rs.setFileName(fileName);
                rs.setLabel(fileName);
                rs.setFsName(java.util.UUID.randomUUID().toString());
                rs.setMime(mimeType);
                rs.setType("ascii");
                rs.setWidgetId(appletId);
                rs.setSize(0);
                com.feezixlabs.db.dao.WidgetResourceDAO.addResource(request.getUserPrincipal().getName(), appletId, rs, "dev");

                java.io.File file = new java.io.File(path+"/"+rs.getFsName());
                if(mimeType.compareToIgnoreCase("folder") == 0)
                    file.mkdir();
                else
                    file.createNewFile();
            }else{
                
                if(mimeType.compareToIgnoreCase("folder") == 0)
                    new java.io.File(path+"/"+relPath+"/"+fileName).mkdir();
                else
                    new java.io.File(path+"/"+relPath+"/"+fileName).createNewFile();
            }
            return "{status:'success','node':"+reply+"}";
        }catch(IOException ex){
            ex.printStackTrace();
        }
        return "{status:'failed'}";
   }



    static String addResource(HttpServletRequest request){
        String env = request.getParameter("env");
        Resource rs = new Resource();
        String replyMsg = "{status:'failed'}";
        String uuid="";

        int clbSizelimit = 100000000;
        // Check that we have a file upload request
        boolean isMultipart = org.apache.commons.fileupload.servlet.ServletFileUpload.isMultipartContent(request);
        if(isMultipart){
            try{
                // Create a factory for disk-based file items
                org.apache.commons.fileupload.FileItemFactory factory = new org.apache.commons.fileupload.disk.DiskFileItemFactory();

                ((org.apache.commons.fileupload.disk.DiskFileItemFactory)factory).setSizeThreshold(clbSizelimit);

                // Create a new file upload handler
                org.apache.commons.fileupload.servlet.ServletFileUpload upload = new org.apache.commons.fileupload.servlet.ServletFileUpload(factory);

                // Parse the request
                java.util.List /* FileItem */ items = upload.parseRequest(request);

                org.apache.commons.fileupload.FileItem rsFile = null;

                java.util.Iterator iter = items.iterator();

                String relPath = "";
                while (iter.hasNext()) {
                    org.apache.commons.fileupload.FileItem item = (org.apache.commons.fileupload.FileItem) iter.next();
                    if (item.isFormField()) {
                        if(item.getFieldName().compareToIgnoreCase("label")==0)
                            rs.setLabel(item.getString());
                        else
                        if(item.getFieldName().compareToIgnoreCase("dataType")==0)
                            rs.setType(item.getString());
                        else
                        if(item.getFieldName().compareToIgnoreCase("mimeType")==0)
                            rs.setMime(item.getString());
                        else
                        if(item.getFieldName().compareToIgnoreCase("uuid")==0)
                            uuid = item.getString();                       
                        else
                        if(item.getFieldName().compareToIgnoreCase("widgetid")==0)
                            rs.setWidgetId(new Integer(item.getString()));
                        else
                        if(item.getFieldName().compareToIgnoreCase("env")==0)
                            env = item.getString();
                        else
                        if(item.getFieldName().compareToIgnoreCase("relPath")==0)
                            relPath = item.getString();
                    } else {
                        rsFile = item;
                    }
                }

                if(!com.feezixlabs.db.dao.UserDOA.hasAppletActionRights(request.getUserPrincipal().getName(), rs.getWidgetId()))
                    return "{\"status\":\"failure\",\"msg\":\"Security Violation\"}";

                if(env.compareToIgnoreCase("dev")==0||env.compareToIgnoreCase("rejected")==0){
                    String resourceBaseDir = com.feezixlabs.util.ConfigUtil.resource_directory+"/"+env+"/app-"+uuid+"/resources";
                    String fileName =  /*relPath.length()==0?java.util.UUID.randomUUID().toString():*/rsFile.getName();

                    /***
                    String mime =  "";

                    java.util.Collection<?> mimeTypes = eu.medsea.mimeutil.MimeUtil.getMimeTypes(resourceFile);
                    java.util.Iterator itr = mimeTypes.iterator();
                    while(itr.hasNext()){
                        mime = itr.next().toString();
                        break;
                    }
                    ***/
                    
                    java.io.File file = rs.getType().compareToIgnoreCase("zip")==0?new java.io.File(resourceBaseDir+"/"+fileName+"z"):new java.io.File(resourceBaseDir+"/"+(relPath.length()==0?fileName:relPath+"/"+fileName));
                    rsFile.write(file);

                    rs.setFileName(rsFile.getName());
                    rs.setFsName(fileName);
                    rs.setSize((int)rsFile.getSize());

                    if(rs.getType().compareToIgnoreCase("zip") == 0){

                        String unzipDir = "";
                        String unzipFileName = "";
                        String topMostEntryName = com.feezixlabs.util.Unzip.getTopMostEntryName(file.getAbsolutePath());

                        if(rs.getFileName().lastIndexOf(".zip")>-1)
                            unzipFileName = rs.getFileName().substring(0,rs.getFileName().lastIndexOf(".zip"));
                        else
                            unzipFileName = rs.getFileName();
                            
                        //if there is a top-most entry that is a folder and it has the same name as zip file (sans extension), then flatten directory structure
                        if(unzipFileName.compareTo(topMostEntryName) == 0){
                            unzipDir = resourceBaseDir+"/"+(relPath.length()==0?unzipFileName:relPath+"/"+unzipFileName);
                            //System.out.println("Unziping with skip");
                            com.feezixlabs.util.Unzip.unzipAndSkipBase(file.getAbsolutePath(),unzipDir);
                        }
                        else{
                            unzipDir = resourceBaseDir+"/"+(relPath.length()==0?unzipFileName:relPath+"/"+unzipFileName);
                            com.feezixlabs.util.Unzip.unzip(file.getAbsolutePath(),unzipDir);
                        }

                        rs.setFileName(unzipFileName);
                        

                        file.delete();
                    }
                    //if(relPath.length() == 0)
                    //com.feezixlabs.db.dao.WidgetResourceDAO.addResource(request.getUserPrincipal().getName(),rs.getWidgetId(), rs,env);
                 }

                replyMsg =  "{status:'success',row:{file_name:'"+rs.getFileName()+
                                        "',label:'"+rs.getLabel()+
                                        "',data_type:'"+rs.getType()+
                                        "',mime_type:'"+rs.getMime()+
                                        "',size:'"+rs.getSize()+
                                        "',create_date:'"+"New"+
                                        "',lst_mod_date:'"+"New"+

                                        (env.compareToIgnoreCase("dev")==0||env.compareToIgnoreCase("rejected")==0?(
                                        "',del_act:'<input type=\"image\" src=\"img/del-doc.png\" onclick=\"deleteLibrary(\\'"+rs.getFileName()+"\\')\"/>"):",del_act:''")+

                                        "'},widgetid:"+rs.getWidgetId()+",id:'"+rs.getFileName()+"'}";
                request.setAttribute("replyMsg",replyMsg);
                request.setAttribute("resource-added", "true");
            }
            catch(Exception ex){
                ex.printStackTrace();
            }
        }return replyMsg;
    }



    static String deleteResourceItem(HttpServletRequest request){
        String replyMsg = "{status:'failed'}";
        String env  = request.getParameter("env");
        String itemPath = request.getParameter("path");
        String resourceItemPath = "";


        if(!com.feezixlabs.db.dao.UserDOA.hasAppletActionRights(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid"))))
            return "{\"status\":\"failure\",\"msg\":\"Security Violation\"}";

        Resource rs = null;//com.feezixlabs.db.dao.WidgetResourceDAO.getResource(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid")), request.getParameter("file_name"),request.getParameter("env") );
        String resourceBaseDir = com.feezixlabs.util.ConfigUtil.resource_directory+"/"+env+"/applet-"+rs.getWidgetId()+"/resources";

        
        if(/*itemPath.compareTo(rs.getFileName()) == 0*/false){
            if(rs.getType().compareTo("zip") == 0) return replyMsg;

            resourceItemPath = resourceBaseDir + "/"+rs.getFsName();
        }else{
            resourceItemPath = resourceBaseDir +"/"+ rs.getFsName()+ itemPath.substring(rs.getFileName().length());
        }

        File f = new File(resourceItemPath);
        if(!f.isDirectory())
            f.delete();
        else{
            try{
            org.apache.commons.io.FileUtils.deleteDirectory(f);
            }catch(Exception ex){
                ex.printStackTrace();
            }
        }
        return "{status:'success'}";
    }

    static String deleteResource(HttpServletRequest request){

        if(!com.feezixlabs.db.dao.UserDOA.hasAppletActionRights(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid"))))
            return "{\"status\":\"failure\",\"msg\":\"Security Violation\"}";

        String relPath = request.getParameter("relPath");
        Resource rs = null;//com.feezixlabs.db.dao.WidgetResourceDAO.getResource(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid")), request.getParameter("fileName"),request.getParameter("env"));
        if(rs != null && relPath.compareToIgnoreCase(rs.getFsName()) == 0)
            com.feezixlabs.db.dao.WidgetResourceDAO.deleteResource(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid")), request.getParameter("fileName"),request.getParameter("env") );
        else
        {
            String resourcePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/"+request.getParameter("env")+"/app-"+request.getParameter("uuid")+"/resources/"+relPath;
            File f = new File(resourcePath);
            if(!f.isDirectory())
                f.delete();
            else
            {
                try{
                org.apache.commons.io.FileUtils.deleteDirectory(f);
                }catch(Exception ex){
                    ex.printStackTrace();
                }
            }
        }
        return "{\"status\":\"success\"}";
    }

    public static String messagePump(HttpServletRequest request){
        String action = request.getParameter("action");


        if(action.compareToIgnoreCase("create-applet-resource") == 0){
            return createResource(request);
        }
        else
        if(action.compareToIgnoreCase("rename-applet-resource") == 0){
            return renameResource(request);
        }
        else
        if(action.compareToIgnoreCase("move-applet-resource") == 0){
            return moveResource(request);
        }
        else
        if(action.compareToIgnoreCase("paste-applet-resource") == 0){
            return pasteResource(request);
        }
        else
        if(action.compareToIgnoreCase("add-widget-resource") == 0){
            return addResource(request);
        }
        else
        if(action.compareToIgnoreCase("upload-package") == 0){
            return unpackPackage(request);
        }
        else
        if(action.compareToIgnoreCase("import-package") == 0){
            return unpackImportedPackage(request);
        }
        else
        if(action.compareToIgnoreCase("save-widget-resource-item") == 0){
            return saveResourceItem(request);
        }
        else
        if(action.compareToIgnoreCase("del-widget-resource-item") == 0){
            return deleteResourceItem(request);
        }
        else
        if(action.compareToIgnoreCase("get-widget-resources") == 0){
            return getResourcesExt(request);
        }
        else
        if(action.compareToIgnoreCase("del-widget-resource") == 0){
            return deleteResource(request);
        }
        return "";
    }
}
