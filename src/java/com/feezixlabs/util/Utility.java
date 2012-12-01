/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.util;

import java.io.ByteArrayInputStream;
import org.apache.commons.mail.*;
import javax.mail.*;
import javax.servlet.http.HttpServletRequest;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import javax.xml.bind.Marshaller;

import com.colabopad.bean.widgetmenu.Menu;
import com.feezixlabs.bean.Widget;


/**
 *
 * @author bitlooter
 */
public class Utility {

    public static HttpServletRequest request;
    public static org.artofsolving.jodconverter.office.OfficeManager JODConvertOfficeManager;
    public static boolean sendEmail(String toAddress,String subject,String message,boolean html,String emailFrom,String smtpUserName,String smtpPassword){
        try{
                //get all the system info we need to send emails
                String smtpHostName = "smtp.gmail.com";
                int    smtpHostPort = 587;
                boolean supportTLS = true;


                HtmlEmail email = new HtmlEmail();

                email.setTLS(supportTLS);
                email.setHostName(smtpHostName);
                email.setSmtpPort(smtpHostPort);
                Authenticator auth = new DefaultAuthenticator(smtpUserName, smtpPassword);
                email.setAuthenticator(auth);


                email.addTo(toAddress);
                email.setFrom(emailFrom);
                email.setSubject(subject);

                if(html)
                // set the html message
                email.setHtmlMsg(message);
                else
                // set the alternative message
                email.setTextMsg(message);


                // send the email
                email.send();
                return true;
            }
           catch (Exception e){
               System.out.println("Error sending email:"+e.getMessage());
               return false;
           }
    }
    public static boolean sendParticipantEmail(com.feezixlabs.bean.Participant p,com.feezixlabs.bean.Room insertedReservation){
          /****
          String msg = "You have been invited to join \""+insertedReservation.getLabel()+"\" course session, please click on the following link for access:" +
                       "<a href=\"http://www.feezixlabs.com/auto-auth.jsp?action=jr&u="+p.getEmailAddress()+"."+p.getSecureToken()+"&p="+insertedReservation.getAccessCode()+"&pid="+p.getId()+"\">here</a>"+
                       "\n</br> <span style=\"font-weight:bold;color:red\">Remember to save this email for future access.</span>";
         
          return Utility.sendEmail(p.getEmailAddress(), "Feezix Labs invite:"+insertedReservation.getLabel(), msg,true,"invite@feezixlabs.com","invite@feezixlabs.com", "te96cher07");
           * ***/return false;
    }
    

    public static boolean notifyWidgetReviewer(int widgetid){
        String msg = "A new widget has been added to the queue for review, id:"+widgetid;
        return Utility.sendEmail("widget.reviewer@feezixlabs.com", "Widget Review Request", msg,true,"no-reply@colabopad.com","no-reply@feezixlabs.com", "Ro96admnp7");
    }

    public static boolean notifyRequestReviewer(com.feezixlabs.bean.SignUpRequest request){
        String msg = "A new signup request is awaiting review."+
                     "<br>First Name:"+request.getFirstName()+
                     "<br>Last Name:"+request.getLastName()+
                     "<br>E-mail: "+request.getEmail()+
                     "<br>Home page:"+request.getHomePage()+
                     "<br>Course:"+request.getCourse()+
                     "<br><a href=\"http://www.feezixlabs.com/actionProcessor.jsp?action=approve-signup&id="+request.getId()+"&security_token="+request.getSecurityToken()+"\">Approve</a>,"+
                     "<a href=\"http://www.feezixlabs.com/actionProcessor.jsp?action=reject-signup&id="+request.getId()+"&security_token="+request.getSecurityToken()+"\">Reject</a>";
        return Utility.sendEmail("verify@feezixlabs.com", "Sign-Up Request: "+request.getFirstName()+" "+request.getLastName(), msg,true,request.getSecurityToken()+"@feezixlabs.com","no-reply@feezixlabs.com", "Ro96admnp7");
    }

    public static boolean notifySignUpRequestRejected(com.feezixlabs.bean.SignUpRequest request){
          String msg = "Dear "+request.getFirstName()+", your request for access to Feezix Labs could not be approved.</br> We could not verify that you are an educator given the information you provided.";
         return Utility.sendEmail(request.getEmail(), "Feezix Labs SignUp Request", msg,true,"no-reply@feezixlabs.com","no-reply@feezixlabs.com", "Ro96admnp7");
    }    


    public static boolean notifyDeveloperWidgetApproved(com.feezixlabs.bean.User p,com.feezixlabs.bean.Widget widget){
        // String msg = "Dear "+p.getName()+",</br> Your submission was approved for App named:<i>" +widget.getName()+"</i>";
         //return Utility.sendEmail(p.getEmailAddress(), "Widget Approved", msg,true,"no-reply@feezixlabs.com","no-reply@feezixlabs.com", "Ro96admnp7");
         return false;
    }

    public static boolean notifyDeveloperWidgetRejected(com.feezixlabs.bean.User p,com.feezixlabs.bean.Widget widget,String reason){
         /*** String msg = "Dear "+p.getFirstName()+",</br> Your widget submission was rejected for widget named:<i>" +widget.getName()+"</i> for the following reason(s):</br>"+reason;
         return Utility.sendEmail(p.getEmailAddress(), "Widget Rejected", msg,true,"no-reply@feezixlabs.com","no-reply@feezixlabs.com", "Ro96admnp7");***/
        return false;
    }

    static Menu findAppletCategory(String categoryId,Menu parentNode){
        for(Menu category:parentNode.getMenus()){
            if(category.getId().compareToIgnoreCase(categoryId) == 0)
                return category;
            else
            {
                Menu resultNode = findAppletCategory(categoryId,category);
                if(resultNode != null)return resultNode;
            }
        }return null;
    }


    public static Menu loadWidgetMenuStructure(){
		try {
			JAXBContext jaxbContext = JAXBContext.newInstance("com.colabopad.bean.widgetmenu");
			Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
            com.feezixlabs.bean.TextData txtData = com.feezixlabs.db.dao.MiscDAO.getTextData("WIDGET_MENU_STRUCTURE");
            Object obj = unmarshaller.unmarshal(new ByteArrayInputStream(txtData.getData().getBytes("UTF-8")));
            return (Menu)(((JAXBElement)obj).getValue());
		} catch (Exception e) {
            e.printStackTrace();
		}return null;
    }



    public static Menu loadAppletMenuStructure(String data){
        try
        {
            if(data != null){
                JAXBContext jaxbContext = JAXBContext.newInstance("com.colabopad.bean.widgetmenu");
                Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
                Object obj = unmarshaller.unmarshal(new ByteArrayInputStream(data.getBytes("UTF-8")));
                return (Menu)(((JAXBElement)obj).getValue());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }return null;
    }

    public static String appletMenuStructureToXML(JAXBElement menu){
        try
        {
            JAXBContext jaxbContext = JAXBContext.newInstance("com.colabopad.bean.widgetmenu");
            Marshaller marshaller = jaxbContext.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);

            org.apache.commons.io.output.ByteArrayOutputStream bo = new org.apache.commons.io.output.ByteArrayOutputStream();

            marshaller.marshal(menu, bo);
            return bo.toString("UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
        }return "";
    }

    static Menu moveAppletCategoryFrom(String parentId,String categoryId,Menu menu){

        for(Menu submenu:menu.getMenus()){
            if(submenu.getId().compareToIgnoreCase(categoryId) == 0){
                menu.getMenus().remove(submenu);
                return submenu;
            }else{
                Menu category = moveAppletCategoryFrom(parentId,categoryId,submenu);
                if(category != null)return category;
            }
        }return null;
        /*
        if(menu.getId().compareToIgnoreCase(parentId) == 0){
            for(Menu submenu:menu.getMenus()){
                if(submenu.getId().compareToIgnoreCase(categoryId) == 0){
                    menu.getMenus().remove(submenu);
                    return submenu;
                }
            }
        }else{
            for(Menu submenu:menu.getMenus()){
                Menu category = moveAppletCategoryFrom(parentId,categoryId,submenu);
                if(category != null)return category;
            }
        }return null;*/
    }
    static Menu moveAppletCategoryTo(String parentId,Menu category,Menu menu){
        if(menu.getId().compareToIgnoreCase(parentId) == 0){
            menu.getMenus().add(category);
            return menu;
        }else{
            for(Menu submenu:menu.getMenus()){
                Menu parent = moveAppletCategoryTo(parentId,category,submenu);
                if(parent != null)return parent;
            }
        }return null;
    }
    public static String moveAppletCategory(String parentId,String categoryId,String newParentId){
        com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName());
        Menu menu = loadAppletMenuStructure(us.getDevToxonomy());

        moveAppletCategoryTo(newParentId,moveAppletCategoryFrom(parentId,categoryId,menu),menu);
        com.colabopad.bean.widgetmenu.ObjectFactory factory=new com.colabopad.bean.widgetmenu.ObjectFactory();
        return appletMenuStructureToXML(factory.createMenu(menu));
    }


    static boolean addAppletCategory(String parentId,String category,String categoryId,Menu menu){
        if(menu.getId().compareToIgnoreCase(parentId) == 0)
        {
            com.colabopad.bean.widgetmenu.ObjectFactory factory=new com.colabopad.bean.widgetmenu.ObjectFactory();
            Menu newCategory = (Menu)factory.createMenu();
            newCategory.setId(categoryId);
            newCategory.setTitle(category);
            menu.getMenus().add(newCategory);
            return true;
        }else{
            for(Menu submenu:menu.getMenus()){
                if(addAppletCategory(parentId,category,categoryId,submenu))
                    return true;
            }
        }return false;
    }
    public static String addCategory(String parentId,String category,String categoryId,String data){
        Menu menu = null;
        com.colabopad.bean.widgetmenu.ObjectFactory factory=new com.colabopad.bean.widgetmenu.ObjectFactory();
        if(data == null || data.length()==0){            
            menu = (Menu)factory.createMenu();
            menu.setId("default");
            menu.setTitle("default");
        }else{
            menu = loadAppletMenuStructure(data);
        }
        addAppletCategory(parentId,category,categoryId,menu);
        //unmarshall and send to database        
        return appletMenuStructureToXML(factory.createMenu(menu));
    }






    static boolean updateAppletCategory(String category,String categoryId,Menu menu){
        if(menu.getId().compareToIgnoreCase(categoryId) == 0)
        {
            menu.setTitle(category);
            return true;
        }else{
            for(Menu submenu:menu.getMenus()){
                if(updateAppletCategory(category,categoryId,submenu))
                    return true;
            }
        }return false;
    }
    public static String updateCategory(String category,String categoryId,String data){
        Menu menu = null;
        com.colabopad.bean.widgetmenu.ObjectFactory factory=new com.colabopad.bean.widgetmenu.ObjectFactory();
        if(data != null){
            menu = loadAppletMenuStructure(data);        
            updateAppletCategory(category,categoryId,menu);
            //unmarshall and send to database
            return appletMenuStructureToXML(factory.createMenu(menu));
        }return null;
    }



    static boolean deleteAppletCategory(String categoryId,Menu menu){

        for(Menu submenu:menu.getMenus()){
            if(submenu.getId().compareToIgnoreCase(categoryId)==0)
            {
                menu.getMenus().remove(submenu);
                return true;
            }
            else
            if(deleteAppletCategory(categoryId,submenu)){
                return true;
            }
        }
        return false;
    }
    public static String deleteCategory(String categoryId,String data){
        Menu menu = null;
        com.colabopad.bean.widgetmenu.ObjectFactory factory=new com.colabopad.bean.widgetmenu.ObjectFactory();
        if(data != null){
            menu = loadAppletMenuStructure(data);
            deleteAppletCategory(categoryId,menu);
            //unmarshall and send to database
            return appletMenuStructureToXML(factory.createMenu(menu));
        }return null;
    }

    public static void updateCategoryApplets(String parentId,Menu node){
        for(Widget applet:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(request.getUserPrincipal().getName(),node.getId())){
            applet.setDevToxonomy(parentId);
            com.feezixlabs.db.dao.WidgetDAO.updateWidget(applet, "dev");
        }
        for(Menu subnode:node.getMenus())
            updateCategoryApplets(parentId,subnode);
    }
    public static void updateCategoryApplets(String parentId,String categoryId,String data){
        if(data != null){  
            updateCategoryApplets(parentId,Utility.findAppletCategory(categoryId,loadAppletMenuStructure(data)));
        }
    }





    static String buildAppletTreeLazy(com.colabopad.bean.widgetmenu.Menu menu,String attr){
        StringBuilder buf = new StringBuilder();
        buf.append("{\"title\":\""+menu.getTitle()+"\""+attr+",\"isLazy\":true,\"id\":\""+menu.getId()+"\",\"isFolder\":true}");
        return buf.toString();
    }

    public static String buildAppletTreeLazy(){
        com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName());
        Menu menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();
        Menu userMenu = null;
        if(us != null)
          userMenu = loadAppletMenuStructure(us.getDevToxonomy());


        String nodeClass = ",\"type\":\"phyzixlabs-system-applet-category\",\"addClass\":\"phyzixlabs-system-applet-category\"";

        StringBuilder buf= new StringBuilder();
        if(menu != null){
            boolean first = true;
            buf.append("[");
            //build system toxonomy tree
            for(com.colabopad.bean.widgetmenu.Menu submenu:menu.getMenus()){
                buf.append((!first?",":"")+buildAppletTreeLazy(submenu,nodeClass));
                first = false;
            }
            //build user toxonomy tree
            nodeClass = ",\"type\":\"phyzixlabs-applet-category\",\"addClass\":\"phyzixlabs-applet-category\"";
            if(userMenu != null){
                for(Menu submenu:userMenu.getMenus()){
                    buf.append((!first?",":"")+buildAppletTreeLazy(submenu,nodeClass));
                    first = false;
                }
            }

            /***
            for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(null)){
                com.feezixlabs.util.ResourceFS4Tree rs = new com.feezixlabs.util.ResourceFS4Tree(com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/applet-"+applet.getId()+"/resources");
                buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet\",\"type\":\"phyzixlabs-applet\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"env\":\"dev\",\"children\":[{\"title\":\"applet\",\"addClass\":\"devwidgetnode\",\"type\":\"wnode\",\"env\":\"dev\",\"key\":\"dev"+applet.getId()+"\",\"widget_id\":\""+applet.getId()+"\"},"+rs.buildTree(Utility.request.getUserPrincipal().getName(),applet.getId())+"]}");
                first = false;
            }*
             */
            for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(Utility.request.getUserPrincipal().getName(),null)){
                buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet\",\"type\":\"phyzixlabs-applet\",\"isLazy\":false,\"toxonomy_id\":\"default\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\",\"env\":\"dev\",\"children\":[{\"title\":\"APP\",\"realTitle\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet-code\",\"type\":\"phyzixlabs-applet-code\",\"env\":\"dev\",\"key\":\"dev"+applet.getId()+"\",\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\"},{\"title\":\"Resources\",\"isLazy\":true,\"widget_id\":"+applet.getId()+",\"uuid\":\""+applet.getUniqueKey()+"\",\"relPath\":\"\",\"type\":\"phyzixlabs-resource-root\",\"addClass\":\"phyzixlabs-resource-root\",\"isFolder\":true,\"children\":[]}]}");
                first = false;
            }
            
            if(Utility.request.isUserInRole("sysadmin") || Utility.request.isUserInRole("developer") || Utility.request.isUserInRole("reviewer")){
                String prpStr = (!first?",":"");
                if(Utility.request.isUserInRole("reviewer")){
                    buf.append(prpStr+"{\"title\":\"App Review Queue\",\"isLazy\":true,\"relPath\":\"\",\"key\":\"phyzixlabs-applet-reviewqueue\",\"type\":\"phyzixlabs-applet-reviewqueue\",\"addClass\":\"phyzixlabs-applet-reviewqueue\",\"isFolder\":true}");
                    first = false;
                }
                prpStr = (!first?",":"");

                buf.append(prpStr+"{\"title\":\"Pending Apps\",\"isLazy\":true,\"relPath\":\"\",\"key\":\"phyzixlabs-applet-list-submitted\",\"type\":\"phyzixlabs-applet-list-submitted\",\"addClass\":\"phyzixlabs-applet-list-submitted\",\"isFolder\":true}");
                //buf.append(",{\"title\":\"Apps Rejected\",\"isLazy\":true,\"relPath\":\"\",\"type\":\"phyzixlabs-applet-list-rejected\",\"addClass\":\"phyzixlabs-applet-list-rejected\",\"isFolder\":true}");
                buf.append(",{\"title\":\"Apps Deployed\",\"isLazy\":true,\"relPath\":\"\",\"key\":\"phyzixlabs-applet-list-prod\",\"type\":\"phyzixlabs-applet-list-prod\",\"addClass\":\"phyzixlabs-applet-list-prod\",\"isFolder\":true}");

                buf.append(",{\"title\":\"System Admin\",\"isLazy\":false,\"relPath\":\"\",\"type\":\"phyzixlabs-system-root\",\"addClass\":\"phyzixlabs-system-root\",\"isFolder\":true,\"children\":[");
                buf.append("{\"title\":\"Library\",\"isLazy\":true,\"relPath\":\"\",\"type\":\"phyzixlabs-system-library-root\",\"addClass\":\"phyzixlabs-system-library-root\",\"isFolder\":true}");//,\"children\":["+LibraryFS4Tree.buildTreeLazy("")+"]

                if(Utility.request.isUserInRole("sysadmin")){
                    buf.append(",{\"title\":\"App Taxonomy\",\"type\":\"phyzixlabs-system-toxonomy\",\"addClass\":\"phyzixlabs-system-toxonomy\",\"isFolder\":false}");
                    buf.append(",{\"title\":\"Packages\",\"isLazy\":true,\"type\":\"phyzixlabs-system-package-root\",\"addClass\":\"phyzixlabs-system-package-root\",\"isFolder\":true}");
                    buf.append(",{\"title\":\"Bin\",\"isLazy\":true,\"type\":\"phyzixlabs-deployed-system-applet-category-root\",\"addClass\":\"phyzixlabs-deployed-system-applet-category-root\",\"isFolder\":true}");
                    buf.append(",{\"title\":\"Users\",\"type\":\"phyzixlabs-system-user-root\",\"addClass\":\"phyzixlabs-system-user-root\",\"isFolder\":false}");
                    buf.append(",{\"title\":\"System Settings\",\"type\":\"phyzixlabs-system-settings-root\",\"addClass\":\"phyzixlabs-system-settings-root\",\"isFolder\":false}");
                }
                buf.append("]}");
            }
            buf.append("]");
        }return buf.toString();
    }

    public static String buildAppletTreeLazy(String userName,String categoryId,String type){
        StringBuilder buf = new StringBuilder();
        boolean first = true;
        String nodeClass = ",\"type\":\"phyzixlabs-system-applet-category\",\"addClass\":\"phyzixlabs-system-applet-category\"";
        Menu category = null;
        if(type.compareToIgnoreCase("phyzixlabs-system-applet-category") == 0){
            category = findAppletCategory(categoryId,Utility.loadWidgetMenuStructure());
            for(Menu submenu:category.getMenus()){
                buf.append((!first?",":"")+buildAppletTreeLazy(submenu,nodeClass));
                first = false;
            }
        }
        else
        if(type.compareToIgnoreCase("phyzixlabs-applet-category") == 0)
        {
            com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(userName);
            nodeClass = ",\"type\":\"phyzixlabs-applet-category\",\"addClass\":\"phyzixlabs-applet-category\"";
            category = findAppletCategory(categoryId,Utility.loadAppletMenuStructure(us.getDevToxonomy()));

            for(Menu submenu:category.getMenus()){
                buf.append((!first?",":"")+buildAppletTreeLazy(submenu,nodeClass));
                first = false;
            }
        }
        for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(Utility.request.getUserPrincipal().getName(),category.getId())){
            buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet\",\"type\":\"phyzixlabs-applet\",\"toxonomy_id\":\""+category.getId()+"\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\",\"env\":\"dev\",\"children\":[{\"title\":\"APP\",\"realTitle\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet-code\",\"type\":\"phyzixlabs-applet-code\",\"env\":\"dev\",\"key\":\"dev"+applet.getId()+"\",\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\"},{\"title\":\"Resources\",\"isLazy\":true,\"widget_id\":"+applet.getId()+",\"uuid\":\""+applet.getUniqueKey()+"\",\"relPath\":\"\",\"type\":\"phyzixlabs-resource-root\",\"addClass\":\"phyzixlabs-resource-root\",\"isFolder\":true,\"children\":[]}]}");
            first = false;
        }
        return buf.toString();
    }

    public static String buildAppletTreeLazy(String userName,String type){
        StringBuilder buf = new StringBuilder();
        boolean first = true;

        if(type.compareToIgnoreCase("phyzixlabs-applet-reviewqueue") == 0 && (Utility.request.isUserInRole("sysadmin") || Utility.request.isUserInRole("reviewer"))){
            for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getWidgets("","queue")){
                buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet-reviewqueue-applet\",\"type\":\"phyzixlabs-applet-reviewqueue-applet\",\"toxonomy_id\":\""+applet.getDevToxonomy()+"\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\",\"env\":\"dev\",\"children\":[{\"title\":\"APP\",\"realTitle\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet-code\",\"type\":\"phyzixlabs-applet-reviewqueue-applet-code\",\"env\":\"queue\",\"key\":\"queue"+applet.getId()+"\",\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\"},{\"title\":\"Resources\",\"isLazy\":true,\"widget_id\":"+applet.getId()+",\"uuid\":\""+applet.getUniqueKey()+"\",\"relPath\":\"\",\"type\":\"phyzixlabs-resource-root\",\"addClass\":\"phyzixlabs-resource-root\",\"isFolder\":true,\"children\":[]}]}");
                first = false;
            }
        }
        else
        if(type.compareToIgnoreCase("phyzixlabs-applet-list-submitted") == 0)
        {
            for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getWidgets(userName,"queue")){
                //buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet\",\"type\":\"phyzixlabs-applet-list-submitted-applet\",\"toxonomy_id\":\""+applet.getDevToxonomy()+"\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"env\":\"dev\",\"children\":[{\"title\":\"app\",\"realTitle\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet-code\",\"type\":\"phyzixlabs-applet-list-submitted-applet-code\",\"env\":\"queue\",\"key\":\"queue"+applet.getId()+"\",\"widget_id\":\""+applet.getId()+"\"},{\"title\":\"Resources\",\"isLazy\":true,\"widget_id\":"+applet.getId()+",\"relPath\":\"\",\"type\":\"phyzixlabs-applet-list-submitted-resource-root\",\"addClass\":\"phyzixlabs-resource-root\",\"isFolder\":true,\"children\":[]}]}");
                buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet-list-submitted-applet\",\"type\":\"phyzixlabs-applet-list-submitted-applet\",\"toxonomy_id\":\""+applet.getDevToxonomy()+"\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\",\"env\":\"queue\",\"children\":[]}");

                first = false;
            }
        }
        else
        if(type.compareToIgnoreCase("phyzixlabs-applet-list-rejected") == 0)
        {
            for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getWidgets(userName,"rejected")){
                //buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet\",\"type\":\"phyzixlabs-applet-list-rejected-applet\",\"toxonomy_id\":\""+applet.getDevToxonomy()+"\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"env\":\"rejected\",\"children\":[{\"title\":\"applet\",\"realTitle\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet-code\",\"type\":\"phyzixlabs-applet-code\",\"env\":\"rejected\",\"key\":\"rejected"+applet.getId()+"\",\"widget_id\":\""+applet.getId()+"\"},{\"title\":\"Resources\",\"isLazy\":true,\"widget_id\":"+applet.getId()+",\"relPath\":\"\",\"type\":\"phyzixlabs-resource-root\",\"addClass\":\"phyzixlabs-resource-root\",\"isFolder\":true,\"children\":[]}]}");
                buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet\",\"type\":\"phyzixlabs-applet-list-rejected-applet\",\"toxonomy_id\":\""+applet.getDevToxonomy()+"\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\",\"env\":\"rejected\",\"children\":[]}");
                first = false;
            }
        }
        else
        if(type.compareToIgnoreCase("phyzixlabs-applet-list-prod") == 0)
        {
            for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getWidgets(userName,"prod")){
                //buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet\",\"type\":\"phyzixlabs-applet-list-prod-applet\",\"toxonomy_id\":\""+applet.getDevToxonomy()+"\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"env\":\"prod\",\"children\":[{\"title\":\"applet\",\"realTitle\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet-code\",\"type\":\"phyzixlabs-applet-list-prod-applet-code\",\"env\":\"dev\",\"key\":\"prod"+applet.getId()+"\",\"widget_id\":\""+applet.getId()+"\"},{\"title\":\"Resources\",\"isLazy\":true,\"widget_id\":"+applet.getId()+",\"relPath\":\"\",\"type\":\"phyzixlabs-applet-list-prod-resource-root\",\"addClass\":\"phyzixlabs-resource-root\",\"isFolder\":true,\"children\":[]}]}");
                buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-prod-applet\",\"type\":\"phyzixlabs-applet-list-prod-applet\",\"toxonomy_id\":\""+applet.getDevToxonomy()+"\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\",\"env\":\"prod\",\"children\":[]}");
                first = false;
            }
        }      
        return buf.toString();
    }










    public static String buildAppletBinTreeLazy(){
        
        Menu menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();


        String nodeClass = ",\"type\":\"phyzixlabs-deployed-system-applet-category\",\"addClass\":\"phyzixlabs-deployed-system-applet-category\"";

        StringBuilder buf= new StringBuilder();
        if(menu != null){
            boolean first = true;
            buf.append("[");
            //build system toxonomy tree
            for(com.colabopad.bean.widgetmenu.Menu submenu:menu.getMenus()){
                buf.append((!first?",":"")+buildAppletBinTreeLazy(submenu,nodeClass));
                first = false;
            }
            buf.append("]");
        }return buf.toString();
    }

    static String buildAppletBinTreeLazy(com.colabopad.bean.widgetmenu.Menu menu,String attr){
        StringBuilder buf = new StringBuilder();
        buf.append("{\"title\":\""+menu.getTitle()+"\""+attr+",\"isLazy\":true,\"id\":\""+menu.getId()+"\",\"isFolder\":true,\"children\":[");

        buf.append("]}");

        return buf.toString();
    }
    public static String buildAppletBinTreeLazy(String userName,String categoryId,String type){
        StringBuilder buf = new StringBuilder();
        boolean first = true;
        String nodeClass = ",\"type\":\"phyzixlabs-deployed-system-applet-category\",\"addClass\":\"phyzixlabs-deployed-system-applet-category\"";
        Menu category = null;
        if(type.compareToIgnoreCase("phyzixlabs-deployed-system-applet-category") == 0){
            category = findAppletCategory(categoryId,Utility.loadWidgetMenuStructure());
            for(Menu submenu:category.getMenus()){
                buf.append((!first?",":"")+buildAppletBinTreeLazy(submenu,nodeClass));
                first = false;
            }
        
            for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getMenuWidgets(category.getId())){
                buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-deployed-applet\",\"type\":\"phyzixlabs-deployed-applet\",\"toxonomy_id\":\""+category.getId()+"\",\"isFolder\":false,\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\",\"id\":\""+applet.getId()+"\",\"env\":\"prod\"}");
                first = false;
            }
        }
        else
        if(type.compareToIgnoreCase("phyzixlabs-deployed-system-applet-category-root") == 0){
            Menu menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();
            for(Menu submenu:menu.getMenus()){
                buf.append((!first?",":"")+buildAppletBinTreeLazy(submenu,nodeClass));
                first = false;
            }
        }
        return buf.toString();
    }





    static String buildAppletTree(com.colabopad.bean.widgetmenu.Menu menu,String attr){
        StringBuilder buf = new StringBuilder();
        buf.append("{\"title\":\""+menu.getTitle()+"\""+attr+",\"id\":\""+menu.getId()+"\",\"isFolder\":true,\"children\":[");

        /**
        buf.append("<div id=\"colabopad-menu-widget-"+menu.getId()+"\" class=\"menu\">");

        java.util.List<com.feezixlabs.bean.Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getMenuWidgets(menu.getId());
        for(com.feezixlabs.bean.Widget widget:widgets){
            buf.append("<a menu=\"colabopad-menu-widget-"+widget.getId()+"-bag\" img=\"widgets/getresource.jsp?widgetid="+widget.getId()+"&file_name=favicon.png&env=prod\">"+widget.getName()+"</a>");
        }
        **/

        boolean first = true;
        for(com.colabopad.bean.widgetmenu.Menu submenu:menu.getMenus()){
            buf.append((!first?",":"")+buildAppletTree(submenu,attr));
            first = false;
        }

        /*
            for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(menu.getId())){
                com.feezixlabs.util.ResourceFS4Tree rs = new com.feezixlabs.util.ResourceFS4Tree(com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/applet-"+applet.getId()+"/resources");
                buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet\",\"type\":\"phyzixlabs-applet\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"env\":\"dev\",\"children\":[{\"title\":\"applet\",\"addClass\":\"devwidgetnode\",\"type\":\"wnode\",\"env\":\"dev\",\"key\":\"dev"+applet.getId()+"\",\"widget_id\":\""+applet.getId()+"\"},"+rs.buildTree(Utility.request.getUserPrincipal().getName(),applet.getId())+"]}");
                first = false;
            }        */

        for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(Utility.request.getUserPrincipal().getName(),menu.getId())){
            buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet\",\"type\":\"phyzixlabs-applet\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\",\"env\":\"dev\",\"children\":[{\"title\":\"applet\",\"addClass\":\"devwidgetnode\",\"type\":\"wnode\",\"env\":\"dev\",\"key\":\"dev"+applet.getId()+"\",\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\"},{\"title\":\"Resources\",\"isLazy\":true,\"widget_id\":"+applet.getId()+",\"uuid\":\""+applet.getUniqueKey()+"\",\"relPath\":\"\",\"type\":\"phyzixlabs-resource-root\",\"addClass\":\"phyzixlabs-resource-root\",\"isFolder\":true,\"children\":[]}]}");
            first = false;
        }

        //buf.append("</div>");

        /**
        for(com.feezixlabs.bean.Widget widget:widgets){
            //buf.append("<div id=\"colabopad-menu-widget-"+widget.getId()+"-bag\" class=\"menu\" >");
            //buf.append("   <a action=\"ColabopadApplication.newWidget("+widget.getId()+",'prod')\"  img=\"images/misc/launch.png\">Launch</a>");
            //buf.append("   <a action=\"ColabopadApplication.showWidgetHelp("+widget.getId()+",'prod')\"  img=\"images/misc/gnochm.png\">Help</a>");
            //buf.append("</div>");
        }
        **/
        buf.append("]}");

        return buf.toString();
    }

    static String buildAppletTree(){
        com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName());
        Menu menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();
        Menu userMenu = null;
        if(us != null)
          userMenu = loadAppletMenuStructure(us.getDevToxonomy());


        String nodeClass = ",\"type\":\"phyzixlabs-system-applet-category\",\"addClass\":\"phyzixlabs-system-applet-category\"";

        StringBuilder buf= new StringBuilder();
        if(menu != null){            
            boolean first = true;
            //buf.append("[");
            //build system toxonomy tree
            for(com.colabopad.bean.widgetmenu.Menu submenu:menu.getMenus()){
                buf.append((!first?",":"")+buildAppletTree(submenu,nodeClass));
                first = false;
            }
            //build user toxonomy tree
            nodeClass = ",\"type\":\"phyzixlabs-applet-category\",\"addClass\":\"phyzixlabs-applet-category\"";
            if(userMenu != null){
                for(Menu submenu:userMenu.getMenus()){
                    buf.append((!first?",":"")+buildAppletTree(submenu,nodeClass));
                    first = false;
                }
            }

            /***
            for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(null)){
                com.feezixlabs.util.ResourceFS4Tree rs = new com.feezixlabs.util.ResourceFS4Tree(com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/applet-"+applet.getId()+"/resources");
                buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet\",\"type\":\"phyzixlabs-applet\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"env\":\"dev\",\"children\":[{\"title\":\"applet\",\"addClass\":\"devwidgetnode\",\"type\":\"wnode\",\"env\":\"dev\",\"key\":\"dev"+applet.getId()+"\",\"widget_id\":\""+applet.getId()+"\"},"+rs.buildTree(Utility.request.getUserPrincipal().getName(),applet.getId())+"]}");
                first = false;
            }*
             */
            for(com.feezixlabs.bean.Widget applet:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(Utility.request.getUserPrincipal().getName(),null)){
                buf.append((!first?",":"")+"{\"title\":\""+applet.getName()+"\",\"addClass\":\"phyzixlabs-applet\",\"type\":\"phyzixlabs-applet\",\"isFolder\":true,\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\",\"env\":\"dev\",\"children\":[{\"title\":\"APP\",\"addClass\":\"phyzixlabs-applet-code\",\"type\":\"wnode\",\"env\":\"dev\",\"key\":\"dev"+applet.getId()+"\",\"widget_id\":\""+applet.getId()+"\",\"uuid\":\""+applet.getUniqueKey()+"\"},{\"title\":\"Resources\",\"isLazy\":true,\"widget_id\":"+applet.getId()+",\"uuid\":\""+applet.getUniqueKey()+"\",\"relPath\":\"\",\"type\":\"phyzixlabs-resource-root\",\"addClass\":\"phyzixlabs-resource-root\",\"isFolder\":true,\"children\":[]}]}");
                first = false;
            }


        }return buf.toString();
    }

    public static String getDefaultAppletTree(HttpServletRequest request){
        Utility.request = request;
        String reply = buildAppletTree();
        Utility.request = null;
        return reply;
    }


    public static String buildWidgetMenu(){
        Menu menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();
        StringBuffer buf= new StringBuffer();
        if(menu != null){

            buf.append("<div id=\"phyzixlabs-menu-widget-default\" class=\"menu\">");

            for(Menu submenu:menu.getMenus()){
                buf.append("<a menu=\"phyzixlabs-menu-widget-"+submenu.getId()+"\">"+submenu.getTitle()+"</a>");
            }
            buf.append("</div>");
            for(Menu submenu:menu.getMenus())
                buildWidgetMenu(submenu,buf);
        }return buf.toString();
    }


    static String buildWidgetMenu(com.colabopad.bean.widgetmenu.Menu menu,StringBuffer buf){
        buf.append("<div id=\"phyzixlabs-menu-widget-"+menu.getId()+"\" class=\"menu\">");

        java.util.List<com.feezixlabs.bean.Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getMenuWidgets(menu.getId());
        for(com.feezixlabs.bean.Widget widget:widgets){
            buf.append("<a menu=\"phyzixlabs-menu-widget-"+widget.getId()+"-bag\" img=\"widgets/getresource.jsp?widgetid="+widget.getId()+"&file_name=favicon.png&env=prod\">"+widget.getName()+"</a>");
        }

        for(com.colabopad.bean.widgetmenu.Menu submenu:menu.getMenus()){
            buf.append("<a menu=\"phyzixlabs-menu-widget-"+submenu.getId()+"\">"+submenu.getTitle()+"</a>");
        }
        buf.append("</div>");

        for(com.feezixlabs.bean.Widget widget:widgets){
            buf.append("<div id=\"phyzixlabs-menu-widget-"+widget.getId()+"-bag\" class=\"menu\" >");
            buf.append("   <a action=\"ColabopadApplication.newWidget("+widget.getId()+",'prod')\"  img=\"images/misc/launch.png\">Run</a>");
            buf.append("   <a action=\"ColabopadApplication.showWidgetHelp("+widget.getId()+",'prod')\"  img=\"images/misc/gnochm.png\">Help</a>");
            buf.append("</div>");
        }

        for(com.colabopad.bean.widgetmenu.Menu submenu:menu.getMenus()){
            buildWidgetMenu(submenu,buf);
        }
        return buf.toString();
    }







    public static String buildDevAppletMenu(){
        StringBuilder buf= new StringBuilder();
        Menu menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();
        if(menu != null){

            buf.append("<div id=\"colabopad-menu-applet-dev-default\" class=\"menu\">");
                for(Menu submenu:menu.getMenus()){
                    buf.append("<a menu=\"colabopad-menu-applet-dev-"+submenu.getId()+"\">"+submenu.getTitle()+"</a>");
                }
            
            
            com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName());
            Menu userMenu = null;
            if(us != null)
                userMenu = loadAppletMenuStructure(us.getDevToxonomy());
            
             if(userMenu != null){
                for(Menu category:userMenu.getMenus()){
                    buf.append("<a menu=\"colabopad-menu-applet-dev-"+category.getId()+"\">"+category.getTitle()+"</a>");
                }
             }

             for(Widget widget:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(Utility.request.getUserPrincipal().getName(),null)){
                buf.append("<a action=\"ColabopadApplication.newWidget("+widget.getId()+",'dev')\" img=\"widgets/getresource.jsp?widgetid="+widget.getId()+"&file_name=favicon.png&env=dev\">"+widget.getName()+"</a>");
             }
             buf.append("</div>");

            for(Menu category:menu.getMenus())
                buildDevAppletMenu(category,buf);

            if(userMenu != null){
                for(Menu category:userMenu.getMenus()){
                    buildDevAppletMenu(category,buf);
                }
            }


        }return buf.toString();
    }


    static String buildDevAppletMenu(com.colabopad.bean.widgetmenu.Menu menu,StringBuilder buf){
        buf.append("<div id=\"colabopad-menu-applet-dev-"+menu.getId()+"\" class=\"menu\">");

        java.util.List<Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(Utility.request.getUserPrincipal().getName(),menu.getId());
        for(Widget widget:widgets){
            buf.append("<a action=\"ColabopadApplication.newWidget("+widget.getId()+",'dev')\" img=\"widgets/getresource.jsp?widgetid="+widget.getId()+"&file_name=favicon.png&env=dev\">"+widget.getName()+"</a>");
        }

        for(Menu submenu:menu.getMenus()){
            buf.append("<a menu=\"colabopad-menu-applet-dev-"+submenu.getId()+"\">"+submenu.getTitle()+"</a>");
        }
        buf.append("</div>");

        /*
        for(Widget widget:widgets){
            buf.append("<div id=\"colabopad-menu-applet-dev-"+widget.getId()+"-bag\" class=\"menu\" >");
            buf.append("   <a action=\"ColabopadApplication.newWidget("+widget.getId()+",'dev')\"  img=\"images/misc/launch.png\">Run</a>");
            buf.append("   <a action=\"ColabopadApplication.showWidgetHelp("+widget.getId()+",'dev')\"  img=\"images/misc/gnochm.png\">Help</a>");
            buf.append("</div>");
        }*/

        for(Menu submenu:menu.getMenus()){
            buildDevAppletMenu(submenu,buf);
        }
        return buf.toString();
    }



    public static String buildDevAppletMenu2(){
        StringBuilder buf= new StringBuilder();
        Menu menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();
        for(int i=0;i<10;i++){
           menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();
           if(menu != null)break;
           else{
                try{
                    Thread.currentThread().wait(1000);
               }catch(Exception ex){}
            }
        }

        if(menu != null){

            buf.append("<ul>");
            for(Menu submenu:menu.getMenus()){
                buf.append("<li><a href=\"#\">"+submenu.getTitle()+"</a>"+buildDevAppletMenu2(submenu)+"</li>");
            }

            com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName());
            Menu userMenu = Utility.loadAppletMenuStructure(us.getDevToxonomy());
            if(userMenu != null){
                for(Menu submenu:userMenu.getMenus()){
                    buf.append("<li><a href=\"#\">"+submenu.getTitle()+"</a>"+buildDevAppletMenu2(submenu)+"</li>");
                }
            }

            for(Widget widget:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(Utility.request.getUserPrincipal().getName(),null)){
                buf.append("<li><a href=\"#\" onclick=\"ColabopadApplication.newWidget('"+widget.getUniqueKey()+"','dev')\"><img src=\"widgets/getresource.jsp?widgetid="+widget.getUniqueKey()+"&file_name=favicon.png&env=dev\" style=\"border:none\"/>"+widget.getName()+"</a></li>");
            }
            buf.append("</ul>");
            
        }return buf.toString();
    }

    static String buildDevAppletMenu2(com.colabopad.bean.widgetmenu.Menu menu){
        StringBuilder buf= new StringBuilder();
        java.util.List<Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(Utility.request.getUserPrincipal().getName(),menu.getId());
        buf.append("<ul>");
        for(Menu submenu:menu.getMenus()){
            buf.append("<li><a href=\"#\">"+submenu.getTitle()+"</a>"+buildDevAppletMenu2(submenu)+"</li>");
        }
        for(Widget widget:widgets){
            buf.append("<li><a href=\"#\" onclick=\"ColabopadApplication.newWidget('"+widget.getUniqueKey()+"','dev')\"><img src=\"widgets/getresource.jsp?widgetid="+widget.getUniqueKey()+"&file_name=favicon.png&env=dev\" style=\"border:none\"/>"+widget.getName()+"</a></li>");
        }
        buf.append("</ul>");
        return buf.toString();
    }



    public static String buildDeployedApplet(boolean skipHeader){
        StringBuilder buf= new StringBuilder();
        Menu menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();
        if(menu != null){
            if(!skipHeader)
            buf.append("<ul>");
            for(Menu submenu:menu.getMenus()){
                buf.append("<li><a href=\"#\">"+submenu.getTitle()+"</a>"+buildDeployedApplet(submenu)+"</li>");
            }

            /*
            com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName());
            Menu userMenu = Utility.loadAppletMenuStructure(us.getDevToxonomy());
            if(userMenu != null){
                for(Menu submenu:userMenu.getMenus()){
                    buf.append("<li><a href=\"#\">"+submenu.getTitle()+"</a>"+buildDeployedApplet(submenu)+"</li>");
                }
            }*/

            /**
            for(Widget widget:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(Utility.request.getUserPrincipal().getName(),null)){
                buf.append("<li><a href=\"#\"><img src=\"widgets/getresource.jsp?widgetid="+widget.getId()+"&file_name=favicon.png&env=dev\"/>"+widget.getName()+"</a></li>");
            }**/
            if(!skipHeader)
            buf.append("</ul>");

        }return buf.toString();
    }

    static String buildDeployedApplet(com.colabopad.bean.widgetmenu.Menu menu){
        StringBuilder buf= new StringBuilder();
        java.util.List<Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getMenuWidgets(menu.getId());
        buf.append("<ul>");
        for(Menu submenu:menu.getMenus()){
            buf.append("<li><a href=\"#\">"+submenu.getTitle()+"</a>"+buildDeployedApplet(submenu)+"</li>");
        }
        for(Widget widget:widgets){
            buf.append("<li><a href=\"#\"><img src=\"widgets/getresource.jsp?widgetid="+widget.getId()+"&file_name=favicon.png&env=prod\" style=\"border:none\"/>"+widget.getName()+"</a>");
            buf.append("    <ul>");
            buf.append("        <li><a href=\"#\" onclick=\"ColabopadApplication.newWidget("+widget.getId()+",'prod')\"><img src=\"images/misc/launch.png\" style=\"border:none\"/>Run</a></li>");
            buf.append("        <li><a href=\"#\" onclick=\"ColabopadApplication.showWidgetHelp("+widget.getId()+",'prod')\"><img src=\"images/misc/gnochm.png\" style=\"border:none\"/>Help</a></li>");
            buf.append("    </ul>");
            buf.append("</li>");
            //buf.append("<li><a href=\"#\"><img src=\"widgets/getresource.jsp?widgetid="+widget.getId()+"&file_name=favicon.png&env=dev\"/>"+widget.getName()+"</a></li>");
        }
        buf.append("</ul>");
        return buf.toString();
    }


    ////////////////////////////////////////////////////For App Store Category//////////////////////////////////////////////
    public static String buildAppletTaxonomyMenu(boolean skipHeader){
        StringBuilder buf= new StringBuilder();
        Menu menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();
        if(menu != null){
            if(!skipHeader)
            buf.append("<ul id=\"app-category-structure\">");
            for(Menu submenu:menu.getMenus()){
                buf.append("<li><a href=\"#\" onclick=\"app_store_app.showCategory('"+submenu.getId()+"')\">"+submenu.getTitle()+"</a>"+buildAppletTaxonomyMenu(submenu)+"</li>");
            }

            /*
            com.feezixlabs.bean.UserSettings us = com.feezixlabs.db.dao.UserDOA.getUserSettings(request.getUserPrincipal().getName());
            Menu userMenu = Utility.loadAppletMenuStructure(us.getDevToxonomy());
            if(userMenu != null){
                for(Menu submenu:userMenu.getMenus()){
                    buf.append("<li><a href=\"#\">"+submenu.getTitle()+"</a>"+buildDeployedApplet(submenu)+"</li>");
                }
            }*/

            /**
            for(Widget widget:com.feezixlabs.db.dao.WidgetDAO.getAppletsByToxonomy(Utility.request.getUserPrincipal().getName(),null)){
                buf.append("<li><a href=\"#\"><img src=\"widgets/getresource.jsp?widgetid="+widget.getId()+"&file_name=favicon.png&env=dev\"/>"+widget.getName()+"</a></li>");
            }**/
            if(!skipHeader)
            buf.append("</ul>");

        }return buf.toString();
    }

    static String buildAppletTaxonomyMenu(com.colabopad.bean.widgetmenu.Menu menu){
        StringBuilder buf= new StringBuilder();
        
        buf.append("<ul>");
        for(Menu submenu:menu.getMenus()){
            buf.append("<li><a href=\"#\" onclick=\"app_store_app.showCategory('"+submenu.getId()+"')\">"+submenu.getTitle()+"</a>"+buildAppletTaxonomyMenu(submenu)+"</li>");
        }
        /**
         java.util.List<Widget> widgets = com.feezixlabs.db.dao.WidgetDAO.getMenuWidgets(menu.getId());
        for(Widget widget:widgets){
            buf.append("<li><a href=\"#\"><img src=\"widgets/getresource.jsp?widgetid="+widget.getId()+"&file_name=favicon.png&env=prod\" style=\"border:none\"/>"+widget.getName()+"</a>");
            buf.append("    <ul>");
            buf.append("        <li><a href=\"#\" onclick=\"ColabopadApplication.newWidget("+widget.getId()+",'prod')\"><img src=\"images/misc/launch.png\" style=\"border:none\"/>Run</a></li>");
            buf.append("        <li><a href=\"#\" onclick=\"ColabopadApplication.showWidgetHelp("+widget.getId()+",'prod')\"><img src=\"images/misc/gnochm.png\" style=\"border:none\"/>Help</a></li>");
            buf.append("    </ul>");
            buf.append("</li>");
            //buf.append("<li><a href=\"#\"><img src=\"widgets/getresource.jsp?widgetid="+widget.getId()+"&file_name=favicon.png&env=dev\"/>"+widget.getName()+"</a></li>");
        }**/
        buf.append("</ul>");
        return buf.toString();
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    public static String buildWidgetMenuStructure(){
        Menu menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();
        if(menu != null){
            StringBuffer buf= new StringBuffer();
            buf.append("<select id=\"widgetCategory\">");
                buildWidgetMenuStructure(menu,buf,"");
            buf.append("</select>");
            return buf.toString();
        }return "";
    }
    static void buildWidgetMenuStructure(com.colabopad.bean.widgetmenu.Menu menu,StringBuffer buf,String indentation){
        buf.append("<option value=\""+menu.getId()+"\">"+indentation+menu.getTitle()+"</option>");
        if(menu.getMenus().size()>0){
            buf.append("<optgroup label=\"\">");
            for(com.colabopad.bean.widgetmenu.Menu submenu:menu.getMenus()){
                //buf.append("<option>"+submenu.getTitle()+"</option>");
                buildWidgetMenuStructure(submenu,buf,indentation+"-");
            }
            buf.append("</optgroup>");
        }
    }


    public static String buildAppletMenuStructure(String id,String val){
        Menu menu = com.feezixlabs.util.Utility.loadWidgetMenuStructure();
        if(menu != null){
            StringBuffer buf= new StringBuffer();
            buf.append("<select id=\"appletCategory-"+id+"\" >");
                buf.append("  <option value=\"\">Select</option>");
                for(com.colabopad.bean.widgetmenu.Menu submenu:menu.getMenus()){
                    buildAppletMenuStructure(submenu,buf,"",val);
                }
            buf.append("</select>");
            return buf.toString();
        }return "";
    }
    static void buildAppletMenuStructure(com.colabopad.bean.widgetmenu.Menu menu,StringBuffer buf,String indentation,String val){
        String selected = menu.getId().compareToIgnoreCase(val)==0?"selected":"";
        buf.append("<option value=\""+menu.getId()+"\" "+selected+">"+indentation+menu.getTitle()+"</option>");
        if(menu.getMenus().size()>0){
            buf.append("<optgroup label=\"\">");
            for(com.colabopad.bean.widgetmenu.Menu submenu:menu.getMenus()){
                //buf.append("<option>"+submenu.getTitle()+"</option>");
                buildAppletMenuStructure(submenu,buf,indentation+"-",val);
            }
            buf.append("</optgroup>");
        }
    }


    public static String getToxonomyHtmlSelect(String id,String val){
        return Utility.buildAppletMenuStructure(id,val);
    }


    public static String getMimeType(String name){
        if(name.endsWith(".html") || name.endsWith(".htm"))
            return "text/html";
        if(name.endsWith(".js"))
            return "text/javascript";
        if(name.endsWith(".svg"))
            return "image/svg+xml";
        if(name.endsWith(".xml"))
            return "text/xml";
        if(name.endsWith(".txt"))
            return "text/plain";
        if(name.endsWith(".css"))
            return "text/css";
        if(name.endsWith(".jpg") || name.endsWith(".jpeg"))
            return "image/jpeg";
        if(name.endsWith(".png"))
            return "image/png";
        if(name.endsWith(".gif"))
            return "image/gif";
        if(name.endsWith(".bmp"))
            return "image/bmp";
        if(name.endsWith(".pdf"))
            return "application/pdf";
        if(name.endsWith(".mp3"))
            return "audio/mpeg3";
        return "none";
    }

    public static String join(Object[] str,String delimiter){
        boolean first = true;
        StringBuilder b = new StringBuilder();
        for(int i=0;i<str.length;i++){
            b.append((!first?delimiter:"")+str[i]);
            first = false;
        }return b.toString();
    }
    public static String join(java.util.List<String> str,String delimiter){
        boolean first = true;
        StringBuilder b = new StringBuilder();
        for(String s:str){
            b.append((!first?delimiter:"")+s);
            first = false;
        }return b.toString();
    }
    public static boolean passDomainRestriction(String emailAddress){
          if(emailAddress != null){
              if(com.feezixlabs.util.ConfigUtil.restrict_access_to_domains != null && com.feezixlabs.util.ConfigUtil.restrict_access_to_domains.compareToIgnoreCase("all") != 0){
                  String[] domains = com.feezixlabs.util.ConfigUtil.restrict_access_to_domains.split(",");
                  String emailDomain = emailAddress.split("@")[1].toLowerCase();

                  for(int i=0;i<domains.length;i++){
                      if(emailDomain.endsWith(domains[i].toLowerCase())){
                          return true;
                      }
                  }return false;
              }return true;
        }return false;
    }

    /*
    public static String buildWidgetMenu(com.colabopad.bean.widgetmenu.Menu menu,StringBuffer buf){
        buf.append("<div id=\"colabopad-menu-widget-"+menu.getId()+"\" class=\"menu\">");

        java.util.List<com.colabopad.bean.Widget> widgets = com.colabopad.db.DBManager.getMenuWidgets(menu.getId());        
        for(com.colabopad.bean.Widget widget:widgets){
            buf.append("<a action=\"colabopadApplication.newWidget("+widget.getId()+",'prod')\"  img=\"widgets/getresource.jsp?widgetid="+widget.getId()+"&file_name=favicon.png&env=prod\">"+widget.getName()+"</a>");
        }
        
        for(com.colabopad.bean.widgetmenu.Menu submenu:menu.getMenus()){
            buf.append("<a menu=\"colabopad-menu-widget-"+submenu.getId()+"\">"+submenu.getTitle()+"</a>");
        }
        buf.append("</div>");

        for(com.colabopad.bean.widgetmenu.Menu submenu:menu.getMenus()){
            Utility.buildWidgetMenu(submenu,buf);
        }
        return buf.toString();
    }*/
    
    public static String escapeForJSON(String text){
        return text.replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"");
    }
}
