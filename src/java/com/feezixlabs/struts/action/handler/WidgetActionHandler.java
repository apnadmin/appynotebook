/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.struts.action.handler;

import javax.servlet.http.HttpServletRequest;

import com.feezixlabs.bean.Widget;
import com.feezixlabs.bean.WidgetDependency;


/**
 *
 * @author bitlooter
 */
public class WidgetActionHandler {

    
    static String addWidget(HttpServletRequest request){
      String replyMsg = "{status:'failure'}";
      try{
              Widget widget = new Widget();
              widget.setCreatorId(com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName()));
              widget.setName(request.getParameter("name"));
              widget.setDescription(request.getParameter("description"));
              widget.setCategory(request.getParameter("category"));
              widget.setShowInMenu(request.getParameter("show_in_menu"));
              widget.setTags(request.getParameter("tags"));
              widget.setPrice(/*new Float(request.getParameter("price"))*/new java.text.DecimalFormat("000.00").parse(request.getParameter("price")).floatValue());
              widget.setCatalogPage(new Integer(request.getParameter("catalog_page_index")));
              widget.setAuthorName(request.getParameter("author_name"));
              widget.setAuthorLink(request.getParameter("author_link"));
              widget.setCode("");
              widget.setVersion("1.0");
              widget.setDevToxonomy(request.getParameter("dev_toxonomy"));
              widget.setId(com.feezixlabs.db.dao.WidgetDAO.addWidget(widget));

              com.feezixlabs.bean.TextData txtData = com.feezixlabs.db.dao.MiscDAO.getTextData("WIDGET_CODE_TEMPLATE");

              widget.setCode(txtData.getData().replace("#widget-id", ""+widget.getId()));

              com.feezixlabs.db.dao.WidgetDAO.saveWidgetCode(request.getUserPrincipal().getName(),widget.getId(),widget.getCode(),"dev");
                
              Widget widgetx  = com.feezixlabs.db.dao.WidgetDAO.getWidget(widget.getId(),"dev");

              //make resource directory for this applet
              new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+widgetx.getUniqueKey()+"/resources").mkdirs();

              return "{status:'success',widgetid:"+widget.getId()+"}";
      }
      catch(Exception ex){
          ex.printStackTrace();
      }return replyMsg;
    }

    public static String getWidget(HttpServletRequest request){
        Widget widget = com.feezixlabs.db.dao.WidgetDAO.getWidget(new Integer(request.getParameter("widgetid")),request.getParameter("env"));

        return "{status:'success',widget:{id:"+widget.getId()+
                                                    ",name:'"+widget.getName()+
                                                    "',description:'"+widget.getDescription()+
                                                    "',version:'"+widget.getVersion()+
                                                    "',author_name:'"+widget.getAuthorName()+
                                                    "',author_link:'"+widget.getAuthorLink()+
                                                    "',category:'"+widget.getCategory()+
                                                    "',tags:'"+widget.getTags()+
                                                    "',show_in_menu:'"+widget.getShowInMenu()+
                                                    "',price:'"+widget.getPrice()+
                                                    "',catalog_page_index:'"+widget.getCatalogPage()+
                                                    "',version:'"+widget.getVersion()+"'}}";
    }

    public static void updateWidget(HttpServletRequest request){
        try{
              Widget widget = new Widget();
              widget.setId(new Integer(request.getParameter("widgetid")));
              widget.setName(request.getParameter("name"));
              widget.setDescription(request.getParameter("description"));
              widget.setCategory(request.getParameter("category"));
              widget.setShowInMenu(request.getParameter("show_in_menu"));
              widget.setTags(request.getParameter("tags"));              
              widget.setPrice(/*new Float(request.getParameter("price"))*/new java.text.DecimalFormat("000.00").parse(request.getParameter("price")).floatValue());
              widget.setCatalogPage(new Integer(request.getParameter("catalog_page_index")));
              widget.setAuthorName(request.getParameter("author_name"));
              widget.setAuthorLink(request.getParameter("author_link"));
              widget.setCode("");
              widget.setVersion(request.getParameter("version"));
              widget.setDevToxonomy(request.getParameter("dev_toxonomy"));
              com.feezixlabs.db.dao.WidgetDAO.updateWidget(widget,request.getParameter("env"));
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
    }


    public static void moveApplet(HttpServletRequest request){
        try{
              Widget widget = com.feezixlabs.db.dao.WidgetDAO.getWidget(new Integer(request.getParameter("widgetid")),request.getParameter("env"));
              widget.setDevToxonomy(request.getParameter("dev_toxonomy"));
              com.feezixlabs.db.dao.WidgetDAO.updateWidget(widget,request.getParameter("env"));
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
    }

    static void deleteWidget(HttpServletRequest request){
        com.feezixlabs.db.dao.WidgetDAO.deleteWidget(request.getUserPrincipal().getName(), new Integer(request.getParameter("widgetid")),request.getParameter("env"));
    }

    static void saveWidgetCode(HttpServletRequest request){
        com.feezixlabs.db.dao.WidgetDAO.saveWidgetCode(request.getUserPrincipal().getName(),new Integer(request.getParameter("widgetid")), request.getParameter("code").trim(),request.getParameter("env"));
    }
    static String getWidgetCode(HttpServletRequest request){
        Widget widget = com.feezixlabs.db.dao.WidgetDAO.getWidget( new Integer(request.getParameter("widgetid")),request.getParameter("env"));
        return ""+widget.getCode();        
    }


    static String addWidgetDependency(int widget_id,String dependency_id,String dependency_path){
      String replyMsg = "{status:'failure'}";
      try{
              com.feezixlabs.db.dao.WidgetDAO.addWidgetDependency(widget_id, dependency_id, dependency_path);
              return "{status:'success'}";
      }
      catch(Exception ex){
          ex.printStackTrace();
      }return replyMsg;
    }


    static String deleteWidgetDependency(HttpServletRequest request){
      String replyMsg = "{status:'failure'}";
      try{
              int widget_id = new Integer(request.getParameter("widget_id"));
              String dependency_id = request.getParameter("dependency_id");

              com.feezixlabs.db.dao.WidgetDAO.deleteWidgetDependency(widget_id, dependency_id);

              return "{status:'success'}";
      }
      catch(Exception ex){
          ex.printStackTrace();
      }return replyMsg;
    }


    public static String getWidgetDependencies(int widget_id){
        java.util.List<WidgetDependency> widgetdependencies = com.feezixlabs.db.dao.WidgetDAO.getWidgetDependencies(widget_id);
        StringBuffer json = new StringBuffer();
        boolean first = true;
        json.append("{status:'success',widget_id:"+widget_id+",dependencies:[");
        
        for(WidgetDependency dep:widgetdependencies){
            if(first){
                json.append("{dependency_id:'"+dep.getDependencyId()+"',dependency_path:'"+dep.getDependencyPath()+"'}");
                first = false;
            }
            else
                json.append(",{dependency_id:'"+dep.getDependencyId()+"',dependency_path:'"+dep.getDependencyPath()+"'}");
        }
        json.append("]}");
        return json.toString();
    }


    public static String getWidgetDependencySet(HttpServletRequest request){
        String[] ids = request.getParameter("ids").split(",");
        StringBuilder json = new StringBuilder();
        boolean first = true;
        json.append("[");

        for(int i=0;i<ids.length;i++){
             if(first){
                 first = false;
                json.append(getWidgetDependencies(new Integer(ids[i])));
            }
            else
                json.append(","+getWidgetDependencies(new Integer(ids[i])));
        }
        json.append("]");
        return json.toString();
    }

    public static void setWidgetDependencySet(HttpServletRequest request){
        String[] dependencies = request.getParameter("lines").split("#");
        int cur_widget_id = 0;
        
        for(int i=0;i<dependencies.length;i++){
            String[] dependency = dependencies[i].split(",");

            if(dependency.length > 1){
                if(cur_widget_id != new Integer(dependency[0])){
                    cur_widget_id = new Integer(dependency[0]);
                    //clear out any existing dependencies for this widget
                    com.feezixlabs.db.dao.WidgetDAO.deleteWidgetDependencies(cur_widget_id);
                }
                addWidgetDependency(cur_widget_id,dependency[1],dependency[2]/*.substring(library_path_length+1)*/);
            }else{
                com.feezixlabs.db.dao.WidgetDAO.deleteWidgetDependencies(new Integer(dependency[0]));
            }
        }
    }

    public static String messagePump(HttpServletRequest request){
        String action = request.getParameter("action");
        if(action.compareToIgnoreCase("add-widget") == 0){
            return addWidget(request);
        }
        else
        if(action.compareToIgnoreCase("get-widget") == 0){
            return getWidget(request);
        }
        else
        if(action.compareToIgnoreCase("update-widget-info") == 0){
            updateWidget(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("move-applet") == 0){
            moveApplet(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("del-widget") == 0){
            deleteWidget(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("save-widget-code") == 0){
            saveWidgetCode(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("get-widget-code") == 0){
            return getWidgetCode(request);
        }
        else
        if(action.compareToIgnoreCase("add-widget-dependency") == 0){
            //return addWidgetDependency(request);
        }
        else
        if(action.compareToIgnoreCase("del-widget-dependency") == 0){
            return deleteWidgetDependency(request);
        }
        else
        if(action.compareToIgnoreCase("get-widget-dependencies") == 0){
            return getWidgetDependencies(new Integer(request.getParameter("widget_id")));
        }
        else
        if(action.compareToIgnoreCase("get-widget-dependency-set") == 0){
            return getWidgetDependencySet(request);
        }
        else
        if(action.compareToIgnoreCase("set-widget-dependency-set") == 0){
            setWidgetDependencySet(request);
            return "{status:'success'}";
        }
        return "{status:'no-action-taken'}";
    }
}
