/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.struts.action.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.feezixlabs.bean.Widget;
import com.feezixlabs.bean.Resource;

import com.feezixlabs.util.Utility;

/**
 *
 * @author bitlooter
 */
public class WidgetIDEActionHandler {


    public static String submitWidget(HttpServletRequest request){
        if(!request.isUserInRole("sysadmin")  && !request.isUserInRole("developer"))return "{\"status\":\"failure\",\"msg\":\"Unauthorized action\"}";
        /**if(!request.isUserInRole("sysadmin") && !com.feezixlabs.util.ConfigUtil.enable_applet_deployment)return "{\"status\":\"failure\",\"msg\":\"Unauthorized action\"}";**/
       
        try{
                int widgetid = new Integer(request.getParameter("widgetid"));
                Widget widget  = com.feezixlabs.db.dao.WidgetDAO.submitWidget(request.getUserPrincipal().getName(),widgetid);
                //widget = com.feezixlabs.db.dao.WidgetDAO.getWidget(widgetid,"queue");
                
                if(widget.getStatus().compareToIgnoreCase("SUCCESS") == 0){
                    //copy applet resources to production folder
                    java.io.File appletFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+widget.getUniqueKey());
                    java.io.File appletTo = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue");


                    java.io.File existingAppletFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/app-"+widget.getUniqueKey());
                    if(existingAppletFrom.exists())
                        org.apache.commons.io.FileUtils.deleteDirectory(existingAppletFrom);

                    org.apache.commons.io.FileUtils.copyDirectoryToDirectory(appletFrom, appletTo);

                    //create dependency directory
                    new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/app-"+widget.getUniqueKey()+"/dependencies").mkdir();

                    //copy dependencies
                    java.util.List<com.feezixlabs.bean.WidgetDependency> dependencies = com.feezixlabs.db.dao.WidgetDAO.getWidgetDependencies(widgetid);
                    for(com.feezixlabs.bean.WidgetDependency dependency:dependencies){
                          //copy dependency
                          java.io.File dependencyFileFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/library/"+dependency.getDependencyPath());
                          if(dependencyFileFrom.isFile()){
                              java.io.File dependencyFileTo = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/app-"+widget.getUniqueKey()+"/dependencies/"+dependency.getDependencyPath()).getParentFile();
                              org.apache.commons.io.FileUtils.copyFileToDirectory(dependencyFileFrom, dependencyFileTo);
                          }
                      }
                    /*
                    java.util.List<com.feezixlabs.bean.Resource> resources = com.feezixlabs.db.dao.WidgetResourceDAO.getResources(request.getUserPrincipal().getName(),widgetid,"dev");
                    for(com.feezixlabs.bean.Resource resource:resources){
                        java.io.OutputStream o = new java.io.FileOutputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/"+resource.getFsName()));
                        java.io.InputStream is = new java.io.FileInputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/"+resource.getFsName()));
                        byte[] buf = new byte[32 * 1024]; // 32k buffer
                        int nRead = 0;
                        while( (nRead=is.read(buf)) != -1 ) {
                            o.write(buf, 0, nRead);
                        }
                        o.flush();
                        o.close();
                    }

                     */
                    //submit email to reviewer
                    if(com.feezixlabs.util.ConfigUtil.applet_deployment_policy.compareToIgnoreCase("passthrough") != 0)
                        com.feezixlabs.util.Utility.notifyWidgetReviewer(widget.getId());

                        return "{status:'success',widget:{id:"+widget.getId()+
                                                            ",name:'"+widget.getName()+
                                                            "',description:'"+widget.getDescription()+
                                                            "',version:'"+widget.getVersion()+
                                                            "',author_name:'"+widget.getAuthorName()+
                                                            "',author_link:'"+widget.getAuthorLink()+
                                                            "',category:'"+widget.getCategory()+
                                                            "',tags:'"+widget.getTags()+
                                                            "',price:'"+widget.getPrice()+
                                                            "',catalog_page_index:'"+widget.getCatalogPage()+
                                                            "',version:'"+widget.getVersion()+"'}}";
                }
                else
                if(widget.getStatus().compareToIgnoreCase("IN-PROCESS") == 0){
                        return "{status:'failed',msg:'This widget is already in review, please revoke last submission if you want to re-submit'}";
                }
        }catch(Exception ex){
            ex.printStackTrace();
        }return "{status:'failure'}";
    }


    public static String reSubmitWidget(HttpServletRequest request){
        
        if(!request.isUserInRole("sysadmin")  && !request.isUserInRole("developer"))return "{\"status\":\"failure\",\"msg\":\"Unauthorized action\"}";
        //if(!request.isUserInRole("sysadmin")  && !com.feezixlabs.util.ConfigUtil.enable_applet_deployment)return "{\"status\":\"failure\",\"msg\":\"Unauthorized action\"}";


        try{
                int widgetid = new Integer(request.getParameter("widgetid"));
                java.util.List<com.feezixlabs.bean.Resource> resources = com.feezixlabs.db.dao.WidgetResourceDAO.getResources(request.getUserPrincipal().getName(),widgetid,"rejected");

                Widget widget = com.feezixlabs.db.dao.WidgetDAO.reSubmitWidget(request.getUserPrincipal().getName(),widgetid);
                //widget = com.feezixlabs.db.dao.WidgetDAO.getWidget(widgetid,"queue");
                
                if(widget.getStatus().compareToIgnoreCase("SUCCESS") == 0){

                    //copy applet resources to staging queue folder
                    java.io.File appletFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/rejected/app-"+widget.getUniqueKey());
                    java.io.File appletTo = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue");

                    java.io.File existingAppletFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/app-"+widget.getUniqueKey());
                    if(existingAppletFrom.exists())
                        org.apache.commons.io.FileUtils.deleteDirectory(existingAppletFrom);

                    org.apache.commons.io.FileUtils.moveDirectoryToDirectory(appletFrom, appletTo,false);

                    //create dependency directory
                    //new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/app-"+widget.getUniqueKey()+"/dependencies").mkdir();

                    //copy dependencies
                    java.util.List<com.feezixlabs.bean.WidgetDependency> dependencies = com.feezixlabs.db.dao.WidgetDAO.getWidgetDependencies(widgetid);
                    for(com.feezixlabs.bean.WidgetDependency dependency:dependencies){
                          //copy dependency
                          java.io.File dependencyFileFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/library/"+dependency.getDependencyPath());
                          if(dependencyFileFrom.isFile()){
                              java.io.File dependencyFileTo = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/app-"+widget.getUniqueKey()+"/dependencies/"+dependency.getDependencyPath()).getParentFile();
                              org.apache.commons.io.FileUtils.copyFileToDirectory(dependencyFileFrom, dependencyFileTo);
                          }
                      }

                    /*
                    //move file system resources to production folder
                    for(com.feezixlabs.bean.Resource resource:resources){
                        java.io.OutputStream o = new java.io.FileOutputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/"+resource.getFsName()));
                        java.io.InputStream is = new java.io.FileInputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/rejected/"+resource.getFsName()));
                        byte[] buf = new byte[32 * 1024]; // 32k buffer
                        int nRead = 0;
                        while( (nRead=is.read(buf)) != -1 ) {
                            o.write(buf, 0, nRead);
                        }
                        o.flush();
                        o.close();
                        new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/rejected/"+resource.getFsName()).delete();
                    }**/
                    //submit email to reviewer
                    if(com.feezixlabs.util.ConfigUtil.applet_deployment_policy.compareToIgnoreCase("passthrough") != 0)
                            com.feezixlabs.util.Utility.notifyWidgetReviewer(widget.getId());

                    return "{status:'success',widget:{id:"+widget.getId()+
                                                            ",name:'"+widget.getName()+
                                                            "',description:'"+widget.getDescription()+
                                                            "',version:'"+widget.getVersion()+
                                                            "',author_name:'"+widget.getAuthorName()+
                                                            "',author_link:'"+widget.getAuthorLink()+
                                                            "',category:'"+widget.getCategory()+
                                                            "',tags:'"+widget.getTags()+
                                                            "',price:'"+widget.getPrice()+
                                                            "',catalog_page_index:'"+widget.getCatalogPage()+
                                                            "',version:'"+widget.getVersion()+"'}}";
                }
                else
                if(widget.getStatus().compareToIgnoreCase("IN-PROCESS") == 0){
                        return "{status:'failed',msg:'This widget is already in review, please revoke last submission if you want to re-submit'}";
                }
        }catch(Exception ex){
            ex.printStackTrace();
        }return "{status:'failure'}";
    }


    public static String approveWidget(HttpServletRequest request){
        if(!request.isUserInRole("sysadmin")  && !request.isUserInRole("reviewer"))return "{\"status\":\"failure\",\"msg\":\"Unauthorized action\"}";
        //if(!request.isUserInRole("sysadmin") && !com.feezixlabs.util.ConfigUtil.enable_applet_deployment)return "{\"status\":\"failure\",\"msg\":\"Unauthorized action\"}";
        try{
                int widgetid = new Integer(request.getParameter("widgetid"));
                Widget widget  = com.feezixlabs.db.dao.WidgetDAO.approveWidget(widgetid);
                widget = com.feezixlabs.db.dao.WidgetDAO.getWidget(widgetid,"prod");
                
                if(widget.getStatus().compareToIgnoreCase("APPROVED") == 0){

                    //copy applet resources to production
                    java.io.File appletFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/app-"+widget.getUniqueKey());
                    java.io.File appletTo = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/prod");

                    java.io.File existingAppletFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/prod/app-"+widget.getUniqueKey());
                    if(existingAppletFrom.exists())
                        org.apache.commons.io.FileUtils.deleteDirectory(existingAppletFrom);

                    org.apache.commons.io.FileUtils.moveDirectoryToDirectory(appletFrom, appletTo,false);
                    /*
                    //move file system resources to production folder
                    java.util.List<com.feezixlabs.bean.Resource> resources = com.feezixlabs.db.dao.WidgetResourceDAO.getResources(request.getUserPrincipal().getName(),widgetid,"prod");
                    for(com.feezixlabs.bean.Resource resource:resources){
                        java.io.OutputStream o = new java.io.FileOutputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/prod/"+resource.getFsName()));
                        java.io.InputStream is = new java.io.FileInputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/"+resource.getFsName()));
                        byte[] buf = new byte[32 * 1024]; // 32k buffer
                        int nRead = 0;
                        while( (nRead=is.read(buf)) != -1 ) {
                            o.write(buf, 0, nRead);
                        }
                        o.flush();
                        o.close();
                        new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/"+resource.getFsName()).delete();
                    }*/

                    //submit email to developer
                    
                    if(com.feezixlabs.util.ConfigUtil.applet_deployment_policy.compareToIgnoreCase("passthrough") != 0){
                        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUserById(widget.getCreatorId());
                        com.feezixlabs.util.Utility.notifyDeveloperWidgetApproved(user, widget);
                    }
                    return "{status:'success'}";
                }
        }catch(Exception ex){
            ex.printStackTrace();
        }return "{status:'failure'}";
    }

    public static String rejectWidget(HttpServletRequest request){
        if(!request.isUserInRole("sysadmin")  && !request.isUserInRole("reviewer"))return "{\"status\":\"failure\",\"msg\":\"Unauthorized action\"}";

        try{
                int widgetid = new Integer(request.getParameter("widgetid"));
                Widget widget  = com.feezixlabs.db.dao.WidgetDAO.rejectWidget(widgetid);
                widget = com.feezixlabs.db.dao.WidgetDAO.getWidget(widgetid,"rejected");
                if(widget.getStatus().compareToIgnoreCase("REJECTED") == 0){

                    //copy applet resources to rejection state
                    java.io.File appletFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/app-"+widget.getUniqueKey());
                    java.io.File appletTo = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/rejected");

                    java.io.File existingAppletFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/rejected/app-"+widget.getUniqueKey());
                    if(existingAppletFrom.exists())
                        org.apache.commons.io.FileUtils.deleteDirectory(existingAppletFrom);

                    //disable this now
                    org.apache.commons.io.FileUtils.deleteDirectory(appletFrom);
                    /***org.apache.commons.io.FileUtils.moveDirectoryToDirectory(appletFrom, appletTo,false);**/

                    /*
                    //move file system resources to production folder
                    java.util.List<com.feezixlabs.bean.Resource> resources = com.feezixlabs.db.dao.WidgetResourceDAO.getResources(request.getUserPrincipal().getName(),widgetid,"rejected");
                    for(com.feezixlabs.bean.Resource resource:resources){
                        java.io.OutputStream o = new java.io.FileOutputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/rejected/"+resource.getFsName()));
                        java.io.InputStream is = new java.io.FileInputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/"+resource.getFsName()));
                        byte[] buf = new byte[32 * 1024]; // 32k buffer
                        int nRead = 0;
                        while( (nRead=is.read(buf)) != -1 ) {
                            o.write(buf, 0, nRead);
                        }
                        o.flush();
                        o.close();
                        new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/"+resource.getFsName()).delete();
                    }*/

                    
                    //submit email to developer
                    if(com.feezixlabs.util.ConfigUtil.applet_deployment_policy.compareToIgnoreCase("passthrough") != 0){
                        com.feezixlabs.bean.User developer = com.feezixlabs.db.dao.UserDOA.getUserById(widget.getCreatorId());
                        Utility.notifyDeveloperWidgetRejected(developer, widget,request.getParameter("reason"));
                    }
                    return "{status:'success'}";
                }
                
        }catch(Exception ex){
            ex.printStackTrace();
        }return "{status:'failure'}";
    }



    public static String installAppletsFromPackage(HttpServletRequest request){
        if(!request.isUserInRole("sysadmin"))return "{\"status\":\"failure\"}";
        try{
                String packageId = request.getParameter("package_id");
                try
                {
                    javax.xml.bind.JAXBContext jaxbContext = javax.xml.bind.JAXBContext.newInstance("com.feezixlabs.util.appletpackage");
                    javax.xml.bind.Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();

                    Object obj = unmarshaller.unmarshal(new java.io.FileInputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/packages/package-"+packageId+"/manifest.xml")));

                    com.feezixlabs.util.appletpackage.Package appletPackage = (com.feezixlabs.util.appletpackage.Package)obj;

                    String[] lines = request.getParameter("lines").split("\n");
                    for(int i=0;i<lines.length;i++){
                        String[] line = lines[i].split(",");
                        for(com.feezixlabs.util.appletpackage.Applet applet:appletPackage.getApplets().getApplet()){
                            if(applet.getId().compareToIgnoreCase(line[0]) == 0){

                                  Widget widget = new Widget();
                                  widget.setCreatorId(com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName()));
                                  widget.setName(applet.getName());
                                  widget.setDescription(applet.getDescription());
                                  widget.setCategory(line[1]);
                                  widget.setTags(applet.getTags());
                                  widget.setPrice(0);
                                  widget.setCatalogPage(0);
                                  widget.setAuthorName(applet.getAuthorName());
                                  widget.setAuthorLink(applet.getAuthorLink());
                                  widget.setCode(org.apache.commons.io.FileUtils.readFileToString(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/packages/package-"+packageId+"/app-"+applet.getId()+"/resources/code-"+packageId+".js")));
                                  widget.setVersion(applet.getVersion());

                                  //replace dev environment code
                                  //widget.getCode().replace("53d66824-f1ad-102c-a54b-0019b958a435", "96ff4292-f1ad-102c-a54b-0019b958a435");

                                  widget.setId(com.feezixlabs.db.dao.WidgetDAO.installApplet(widget));

                                  //add resources
                                  /***for(com.feezixlabs.util.appletpackage.Resource res:applet.getResources().getResource()){
                                      Resource resource = new Resource();
                                      resource.setFileName(res.getFileName());
                                      resource.setFsName(res.getFsName());
                                      resource.setLabel(res.getLabel());
                                      resource.setType(res.getType());
                                      resource.setMime(res.getMime());
                                      resource.setWidgetId(widget.getId());
                                      //resource.setCreateDate(res.getCreateDate().toGregorianCalendar().getTime());
                                      //resource.setLastModDate(res.getLastModifiedDate().toGregorianCalendar().getTime());
                                      com.feezixlabs.db.dao.WidgetResourceDAO.addResource(request.getUserPrincipal().getName(),widget.getId(), resource, "prod");
                                  }***/

                                  //move files
                                  java.io.File appletFrom = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/packages/package-"+packageId+"/app-"+applet.getId());
                                  java.io.File appletTo = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/prod/app-"+widget.getUniqueKey());

                                  for(java.io.File f:appletFrom.listFiles()){
                                      if(f.isDirectory())
                                          org.apache.commons.io.FileUtils.copyDirectoryToDirectory(f, appletTo);
                                      else
                                          org.apache.commons.io.FileUtils.copyFile(f, appletTo);
                                  }
                                  com.feezixlabs.db.dao.WidgetDAO.markInstalledApplet(packageId,new Integer(applet.getId()),widget.getId());
                            }
                        }
                    }
                }catch(Exception ex){
                    ex.printStackTrace();
                }
        }catch(Exception ex){
            ex.printStackTrace();
        }return "{status:'failure'}";
    }




    public static String uninstallAppletsFromPackage(HttpServletRequest request){
        if(request.isUserInRole("sysadmin")){
            try{
                    String packageId = request.getParameter("package_id");
                    String[] appletIds = request.getParameter("ids").split("\n");
                    for(int i=0;i<appletIds.length;i++){
                        for(com.feezixlabs.bean.PackagedApplet applt:com.feezixlabs.db.dao.AppletPackageDAO.getPackagedApplets(packageId)){
                            if(appletIds[i].compareToIgnoreCase(""+applt.getId()) == 0){
                                undeployApplet(request.getUserPrincipal().getName(),applt.getAppletId());
                                com.feezixlabs.db.dao.WidgetDAO.markunInstalledApplet(packageId,new Integer(appletIds[i]));
                            }
                        }
                    }
                    return "{\"status\":\"success\"}";
            }catch(Exception ex){
                ex.printStackTrace();
            }
        }return "{\"status\":\"failure\"}";
    }



    public static String withdrawWidget(HttpServletRequest request){
        if(!request.isUserInRole("sysadmin")  && !request.isUserInRole("developer"))return "{\"status\":\"failure\",\"msg\":\"Unauthorized action\"}";
        try{
                int widgetid = new Integer(request.getParameter("widgetid"));
                //java.util.List<com.feezixlabs.bean.Resource> resources = com.feezixlabs.db.dao.WidgetResourceDAO.getResources(request.getUserPrincipal().getName(),widgetid,"queue");
                com.feezixlabs.db.dao.WidgetDAO.withdrawWidget(request.getUserPrincipal().getName(),widgetid);

                
                Widget widget  = com.feezixlabs.db.dao.WidgetDAO.getWidget(widgetid,"dev");
                
                //remove from queue
                org.apache.commons.io.FileUtils.deleteDirectory(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/app-"+widget.getUniqueKey()));
                /*
                for(com.feezixlabs.bean.Resource resource:resources){
                    new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/queue/"+resource.getFsName()).delete();
                }
                */
        }catch(Exception ex){
            ex.printStackTrace();
        }return "{\"status\":\"success\"}";
    }


    public static void undeployApplet(String userName,int widgetid) throws Exception{
        //if(!request.isUserInRole("sysadmin")  && !request.isUserInRole("developer"))return "{\"status\":\"failure\",\"msg\":\"Unauthorized action\"}";
        Widget widget  = com.feezixlabs.db.dao.WidgetDAO.getWidget(widgetid,"prod");

        com.feezixlabs.db.dao.WidgetDAO.undeployApplet(userName,widgetid);
        //remove from prod
        org.apache.commons.io.FileUtils.deleteDirectory(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/prod/app-"+widget.getUniqueKey()));
    }


    public static void undeployApplets(HttpServletRequest request){
        try{
              if(request.isUserInRole("sysadmin") /*|| request.isUserInRole("developer")*/){
                    if(request.getParameter("type").compareToIgnoreCase("phyzixlabs-deployed-applet") == 0){

                        int widgetid = new Integer(request.getParameter("id"));
                        undeployApplet(request.getUserPrincipal().getName(),widgetid);
                        /*
                        String[] ids = request.getParameter("ids").split(",");
                        for(int i=0;i<ids.length;i++){
                            int widgetid = new Integer(ids[i]);
                            undeployApplet(request.getUserPrincipal().getName(),widgetid);
                        }*/
                    }
                }
        }catch(Exception ex){
            ex.printStackTrace();
        }
    }




    public static String deleteFromLibrary(HttpServletRequest request){
        if(!request.isUserInRole("sysadmin"))return "{\"status\":\"failure\"}";
        try
        {
            String filePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/library/"+request.getParameter("lib");
            java.io.File file = new java.io.File(filePath);
            if(!file.isDirectory())
                file.delete();
            else
                org.apache.commons.io.FileUtils.deleteDirectory(file);
            return "{\"status\":\"success\"}";
        }
        catch(java.io.IOException ioex){

        }
        return "{\"status\":\"failure\"}";
    }


    public static String getLibraries(HttpServletRequest request){
        
        StringBuffer xmlbuf = new StringBuffer();
        String env = "library";
        
        xmlbuf.append("<?xml version='1.0' encoding='utf-8'?>\n");
        xmlbuf.append("<rows>");
        xmlbuf.append(" <page>1</page>");
        xmlbuf.append(" <total>1</total>");
        xmlbuf.append(" <records>1</records>");
        xmlbuf.append(com.feezixlabs.util.FileSystem.buildGrid(com.feezixlabs.util.ConfigUtil.resource_directory+"/"+env));
        xmlbuf.append("</rows>\n");
        return xmlbuf.toString();
    }


    public static String getUsers(HttpServletRequest request){
        int page  = new Integer(request.getParameter("page"));
        int limit = new Integer(request.getParameter("rows"));
        int start = page*limit - limit;
        
        String filter = request.getParameter("filter");
        int count  = com.feezixlabs.db.dao.UserDOA.getUserCount(filter);
        int totalpages = (int)(count>0?Math.ceil(count/limit):0);

        StringBuilder xmlbuf = new StringBuilder();        

        xmlbuf.append("<?xml version='1.0' encoding='utf-8'?>\n");
        xmlbuf.append("<rows>");
        xmlbuf.append(" <page>"+page+"</page>");
        xmlbuf.append(" <total>"+totalpages+"</total>");
        xmlbuf.append(" <records>"+count+"</records>");
        
        for(com.feezixlabs.bean.User user : com.feezixlabs.db.dao.UserDOA.getUsers(start, limit, filter)){
            xmlbuf.append(" <row>");
            xmlbuf.append("     <cell><![CDATA["+user.getId()+"]]></cell>");
            xmlbuf.append("     <cell><![CDATA["+user.getName()+"]]></cell>");
            xmlbuf.append("     <cell><![CDATA["+user.getEmailAddress()+"]]></cell>");
            xmlbuf.append("     <cell><![CDATA["+com.feezixlabs.util.Utility.join(com.feezixlabs.db.dao.UserDOA.getUserRoles(user.getId()),",")+"]]></cell>");
            xmlbuf.append("</row>");
        }
        xmlbuf.append("</rows>\n");
        return xmlbuf.toString();
    }





    public static String deletePackage(HttpServletRequest request){
        try
        {
            if(request.isUserInRole("sysadmin")){
                com.feezixlabs.db.dao.AppletPackageDAO.deleteAppletPackage(request.getParameter("id"));
                String filePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/packages/package-"+request.getParameter("id");
                org.apache.commons.io.FileUtils.deleteDirectory(new java.io.File(filePath));
            }
        }
        catch(java.io.IOException ioex){

        }
        return "{status:'success'}";
    }



    public static String getPackages(HttpServletRequest request){

        StringBuffer xmlbuf = new StringBuffer();
        String env = "library";

        xmlbuf.append("<?xml version='1.0' encoding='utf-8'?>\n");
        xmlbuf.append("<rows>");
        xmlbuf.append(" <page>1</page>");
        xmlbuf.append(" <total>1</total>");
        xmlbuf.append(" <records>1</records>");
        xmlbuf.append(com.feezixlabs.util.PackageFileSystem.build());
        xmlbuf.append("</rows>\n");
        return xmlbuf.toString();
    }


    public static String moveCategory(HttpServletRequest request){
        String categoryId     = request.getParameter("category_id");
        String parentId       = request.getParameter("parent_id");
        String newParentId    = request.getParameter("to_parent_id");;

        com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName());
        if(us == null)
            us = new com.feezixlabs.bean.UserSettings();

        Utility.request = request;
        us.setDevToxonomy(Utility.moveAppletCategory(parentId, categoryId, newParentId));
        Utility.request = null;

        com.feezixlabs.db.dao.UserDOA.updateUserSettings(request.getUserPrincipal().getName(), us);
        return "{'status':'success','category_id':'"+categoryId+"'}";
    }





    public static String deleteCategory(HttpServletRequest request){
        String parentId     = request.getParameter("parent_id");
        String categoryId = request.getParameter("category_id");

        com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName());
        if(us != null){
            Utility.request = request;
            Utility.updateCategoryApplets(parentId, categoryId, us.getDevToxonomy());
            us.setDevToxonomy(Utility.deleteCategory(categoryId, us.getDevToxonomy()));

            com.feezixlabs.db.dao.UserDOA.updateUserSettings(request.getUserPrincipal().getName(), us);
            Utility.request = null;
        }
        return "{\"status\":\"success\"}";
    }


    public static String addCategory(HttpServletRequest request){
        String category     = request.getParameter("category");
        String parentId     = request.getParameter("parent_id");
        String categoryId   = java.util.UUID.randomUUID().toString();

        com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName());
        if(us == null)
            us = new com.feezixlabs.bean.UserSettings();

        us.setDevToxonomy(Utility.addCategory(parentId, category, categoryId, us.getDevToxonomy()));

        com.feezixlabs.db.dao.UserDOA.updateUserSettings(request.getUserPrincipal().getName(), us);
        return "{'status':'success','category_id':'"+categoryId+"'}";
    }


    public static String updateCategory(HttpServletRequest request){
        String category     = request.getParameter("category");
        String categoryId = request.getParameter("id");

        com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName());
        if(us == null)
            us = new com.feezixlabs.bean.UserSettings();

        us.setDevToxonomy(Utility.updateCategory(category, categoryId, us.getDevToxonomy()));

        com.feezixlabs.db.dao.UserDOA.updateUserSettings(request.getUserPrincipal().getName(), us);
        return "{'status':'success','category_id':'"+categoryId+"'}";
    }

    public static String loadPackages(HttpServletRequest request){
        StringBuilder buf = new StringBuilder();
        buf.append("[");
        boolean nfirst = true;
        for(com.feezixlabs.bean.AppletPackage pkg : com.feezixlabs.db.dao.AppletPackageDAO.getAppletPackages()){
            buf.append((!nfirst?",":"")+ "{id:'"+pkg.getId()+"',selected4install:false,selected4uninstall:false,applets:[");

            boolean bfirst = true;
            for(com.feezixlabs.bean.PackagedApplet applt:com.feezixlabs.db.dao.AppletPackageDAO.getPackagedApplets(pkg.getId())){
                buf.append( (!bfirst?",":"")+ "{id:'"+applt.getId()+"',category:'"+applt.getCategory()+"',selected4install:false,selected4uninstall:false}");
                bfirst = false;
            }
            buf.append("]}");
            nfirst = false;
        }
        buf.append("]");
        return buf.toString();
    }



    public static String loadPackage(HttpServletRequest request){
        StringBuilder buf = new StringBuilder();
        String id = request.getParameter("id");


        for(com.feezixlabs.bean.AppletPackage pkg : com.feezixlabs.db.dao.AppletPackageDAO.getAppletPackages()){

            if(pkg.getId().compareToIgnoreCase(id) == 0){
                buf.append("{id:'"+pkg.getId()+"',selected4install:false,selected4uninstall:false,applets:[");

                boolean bfirst = true;
                for(com.feezixlabs.bean.PackagedApplet applt:com.feezixlabs.db.dao.AppletPackageDAO.getPackagedApplets(pkg.getId())){
                    buf.append( (!bfirst?",":"")+ "{id:'"+applt.getId()+"',category:'"+applt.getCategory()+"',selected4install:false,selected4uninstall:false}");
                    bfirst = false;
                }
                buf.append("]}");
                return buf.toString();
            }
        }

        return buf.toString();
    }


    public static String getWidgetTable(HttpServletRequest request){
        StringBuilder xmlbuf = new StringBuilder();        
        java.util.List<com.feezixlabs.bean.Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getWidgets(request.getUserPrincipal().getName(),request.getParameter("env"));

        xmlbuf.append("<?xml version='1.0' encoding='utf-8'?>\n");
        xmlbuf.append("<rows>");
        xmlbuf.append(" <page>1</page>");
        xmlbuf.append(" <total>1</total>");
        xmlbuf.append(" <records>1</records>");

        for(com.feezixlabs.bean.Widget widget:widgets){
            xmlbuf.append("<row>");
            xmlbuf.append(" <cell><![CDATA["+widget.getId()+"]]></cell>");
            xmlbuf.append(" <cell><![CDATA[]]></cell>");            
            xmlbuf.append(" <cell><![CDATA[ <input type=\"checkbox\" class=\"app-package-checkbox\" value=\""+widget.getId()+"\" onclick=\" if(typeof appletBuilder != 'undefined') appletBuilder.selectWidgetForPackaging('"+widget.getId()+"')\"/> "+widget.getName()+"]]></cell>");
            xmlbuf.append("</row>");
        }
        xmlbuf.append("</rows>\n");
        return xmlbuf.toString();
    }

    public static String addToLibrary(HttpServletRequest request){


        String env = "library";
        
        String replyMsg = "{status:'failed'}";

        if(!request.isUserInRole("sysadmin"))return replyMsg;

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
                String isZip = "";
                while (iter.hasNext()) {
                    org.apache.commons.fileupload.FileItem item = (org.apache.commons.fileupload.FileItem) iter.next();
                    if (item.isFormField()) {
                        if(item.getFieldName().compareToIgnoreCase("isZip")==0)
                            isZip = item.getString();
                    } else {
                        rsFile = item;
                    }
                }

                


                if(true/*env.compareToIgnoreCase("dev")==0||env.compareToIgnoreCase("rejected")==0*/){
                    String libraryBaseDir = com.feezixlabs.util.ConfigUtil.resource_directory+"/library";
                    String fileName = rsFile.getName();//java.util.UUID.randomUUID().toString();
                    java.io.File file = new java.io.File(libraryBaseDir+"/"+fileName);
                    rsFile.write(file);

                    String unzipDir = "";
                    String unzipFileName = "";
                    String topMostEntryName = com.feezixlabs.util.Unzip.getTopMostEntryName(libraryBaseDir+"/"+fileName);
                    
                    if(rsFile.getName().lastIndexOf(".zip")>-1)
                        unzipFileName = rsFile.getName().substring(0,rsFile.getName().lastIndexOf(".zip"));
                    else
                        unzipFileName = rsFile.getName();

                    //if there is a top-most entry that is a folder and it has the same name as zip file (sans extension), then flatten directory structure
                    if(unzipFileName.compareTo(topMostEntryName) == 0)
                        unzipDir = libraryBaseDir;
                    else
                        unzipDir = libraryBaseDir+"/"+unzipFileName;

                    //new java.io.File(unzipDir).mkdir();
                    if(isZip.compareToIgnoreCase("on")==0){
                        com.feezixlabs.util.Unzip.unzip(libraryBaseDir+"/"+fileName,unzipDir);
                        file.delete();
                    }
                    //com.colabopad.db.dao.WidgetResourceDAO.addResource(request.getUserPrincipal().getName(),rs.getWidgetId(), rs,env);
                 }

                replyMsg =  "{status:'success'}";
                request.setAttribute("replyMsg",replyMsg);
                request.setAttribute("library-added", "true");
            }
            catch(Exception ex){
                ex.printStackTrace();
            }
        }return replyMsg;
    }



    public static String messagePump(HttpServletRequest request, HttpServletResponse response){
        String action = request.getParameter("action");

        if(action == null || action.compareToIgnoreCase("add-to-library") == 0){
            return addToLibrary(request);
        }
        else
        if(action.compareToIgnoreCase("del-from-library") == 0){
            return deleteFromLibrary(request);
        }
        else
        if(action.compareToIgnoreCase("del-package") == 0){
            return deletePackage(request);
        }
        else
        if(action.compareToIgnoreCase("get-widget-libs") == 0){
            return getLibraries(request);
        }
        else
        if(action.compareToIgnoreCase("submit-widget") == 0){

            if(com.feezixlabs.util.ConfigUtil.applet_deployment_policy.compareToIgnoreCase("passthrough") == 0){
                submitWidget(request);
                return approveWidget(request);
            }else
            return submitWidget(request);
        }
        else
        if(action.compareToIgnoreCase("resubmit-widget") == 0){
            return reSubmitWidget(request);
        }
        else
        if(action.compareToIgnoreCase("approve-widget") == 0){
            return approveWidget(request);
        }
        else
        if(action.compareToIgnoreCase("reject-widget") == 0){
            return rejectWidget(request);
        }
        else
        if(action.compareToIgnoreCase("withdraw-widget") == 0){
            withdrawWidget(request);
            return "{status:'success',widgetid:"+request.getParameter("widgetid")+"}";
        }
        else
        if(action.compareToIgnoreCase("undeploy-applets") == 0){
            undeployApplets(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("get-widget-menu-structure") == 0){
            return com.feezixlabs.db.dao.MiscDAO.getTextData("WIDGET_MENU_STRUCTURE").getData();
        }
        else
        if(action.compareToIgnoreCase("set-widget-menu-structure") == 0){
            if(request.isUserInRole("reviewer")){
                com.feezixlabs.db.dao.MiscDAO.setTextData("WIDGET_MENU_STRUCTURE",request.getParameter("data").trim());
                com.feezixlabs.util.Utility.buildWidgetMenu();
                return "{status:'success'}";
            }
           return  "{status:'failure'}";
        }
        else
        if(action.compareToIgnoreCase("get-widget-menu-structure-html") == 0){
            return com.feezixlabs.util.Utility.buildWidgetMenuStructure();
        }
        else
        if(action.compareToIgnoreCase("get-widget-table") == 0){            
            return getWidgetTable(request);
        }
        else
        if(action.compareToIgnoreCase("load-packages") == 0){
            return loadPackages(request);
        }
        else
        if(action.compareToIgnoreCase("load-package") == 0){
            return loadPackage(request);
        }
        else
        if(action.compareToIgnoreCase("load-package-tree") == 0){
            return com.feezixlabs.util.PackageFS4Tree.buildTreeLazy();
        }
        else
        if(action.compareToIgnoreCase("install-applets") == 0){
            return installAppletsFromPackage(request);
        }
        else
        if(action.compareToIgnoreCase("uninstall-applets") == 0){
            return uninstallAppletsFromPackage(request);
        }
        else
        if(action.compareToIgnoreCase("add-applet-category") == 0){
            return addCategory(request);
        }
        else
        if(action.compareToIgnoreCase("del-applet-category") == 0){
            return deleteCategory(request);
        }
        else
        if(action.compareToIgnoreCase("update-applet-category") == 0){
            return updateCategory(request);
        }
        else
        if(action.compareToIgnoreCase("move-applet-category") == 0){
            return moveCategory(request);
        }
        else
        if(action.compareToIgnoreCase("get-system-users") == 0){
            return getUsers(request);
        }
        else
        if(action.compareToIgnoreCase("save-system-settings") == 0){
            if(request.isUserInRole("sysadmin") || request.isUserInRole("superuser"))
                 com.feezixlabs.util.ConfigUtil.update(request);
            return  "{\"status\":\"success\"}";
        }
       return "{status:'not-processed'}";
    }

}
