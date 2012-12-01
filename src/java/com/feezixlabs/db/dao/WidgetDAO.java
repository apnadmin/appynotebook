/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;

import com.feezixlabs.bean.Widget;
import com.feezixlabs.bean.WidgetDependency;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class WidgetDAO {
    static Logger logger = Logger.getLogger(WidgetDAO.class.getName());
    public static int addWidget(Widget widget){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {
                          widget.getCreatorId(),
                          widget.getName(),
                          widget.getDescription(),
                          widget.getCategory(),
                          widget.getTags(),
                          widget.getShowInMenu(),
                          widget.getCode(),
                          widget.getAuthorName(),
                          widget.getAuthorLink(),
                          widget.getPrice(),
                          widget.getCatalogPage(),
                          widget.getDevToxonomy()};
        try{
            ResultSetHandler h = new ScalarHandler("widget_id");
            Integer id = (Integer)run.query("{ call sp_add_widget(?,?,?,?,?,?,?,?,?,?,?,?) }",h, pArgs);
            if(id != null)return id.intValue();
        }catch(Exception ex){
            logger.error("",ex);
        }return 0;
    }


    public static int installApplet(Widget widget){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {
                          widget.getCreatorId(),
                          widget.getName(),
                          widget.getDescription(),
                          widget.getCategory(),
                          widget.getTags(),
                          widget.getShowInMenu(),
                          widget.getCode(),
                          widget.getAuthorName(),
                          widget.getAuthorLink(),
                          widget.getVersion(),
                          widget.getPrice(),
                          widget.getCatalogPage()};
        try{
            ResultSetHandler h = new ScalarHandler("widget_id");
            Integer id = (Integer)run.query("{ call sp_install_applet(?,?,?,?,?,?,?,?,?,?,?,?) }",h, pArgs);
            if(id != null)return id.intValue();
        }catch(Exception ex){
            logger.error("",ex);
        }return 0;
    }



    public static void updateWidget(Widget widget,String env){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {widget.getId(),
                          widget.getName(),
                          widget.getDescription(),
                          widget.getCategory(),
                          widget.getTags(),
                          widget.getShowInMenu(),
                          widget.getAuthorName(),
                          widget.getAuthorLink(),
                          widget.getPrice(),
                          widget.getCatalogPage(),
                          widget.getVersion(),
                          widget.getDevToxonomy(),
                          env};
        try{
            run.update("{ call sp_update_widget(?,?,?,?,?,?,?,?,?,?,?,?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }



    public static void markInstalledApplet(String packageId,int id,int appletId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {packageId,id,appletId};
        try{
            run.update("{ call sp_mark_installed_applet(?,?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }


    public static void markunInstalledApplet(String packageId,int id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {packageId,id};
        try{
            run.update("{ call sp_mark_uninstalled_applet(?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }


    public static void updateWidgetDefaultInstance(int id,int page,String instance){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {id,
                          page,
                          instance};
        try{
            run.update("{ call sp_update_widget_default_instance(?,?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void saveWidgetCode(String creatorId,int widgetid, String code,String env){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {creatorId,widgetid,code,env};
        try{
            run.update("{ call sp_save_widget_code(?,?,?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void deleteWidget(String creatorId,int widgetid,String env){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {creatorId,widgetid,env};
        try{
            Widget widgetx = getWidget(widgetid, env);
            run.update("{ call sp_del_widget(?,?,?) }", pArgs);
            Widget widget = getWidget(widgetid, env);

            if(widget==null){//only delete resources if database delete succeeded
                //delete all static content for this applet

                org.apache.commons.io.FileUtils.deleteDirectory(new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/"+env+"/app-"+widgetx.getUniqueKey()));
            }
        }catch(Exception ex){
            logger.error("",ex);
        }
    }


    public static Widget getWidget(int id,String env){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {id,env};
        try{
                ResultSetHandler<Widget> h = new BeanHandler(Widget.class);
                return (Widget)run.query("{ call sp_get_widget(?,?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

    public static Widget serveWidget(String id,String env){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {id,env};
        try{
                ResultSetHandler<Widget> h = new BeanHandler(Widget.class);
                return (Widget)run.query("{ call sp_serve_widget(?,?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }
    
    
    public static java.util.List<Widget> getWidgets(String creatorId,String env){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {creatorId,env};
        try{
                ResultSetHandler<Widget> h = new BeanListHandler(Widget.class);
                return(java.util.List<Widget>)run.query("{ call sp_get_widgets(?,?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }


    public static java.util.List<Widget> getCatalogPageWidgets(String categoryId,int page){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {categoryId,page};
        try{
                ResultSetHandler<Widget> h = new BeanListHandler(Widget.class);
                return (java.util.List<Widget>)run.query("{ call sp_get_catalog_page_widgets(?,?) }",h,pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }


    public static java.util.List<Widget> getMenuWidgets(String category){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {category};
        try{
                ResultSetHandler<Widget> h = new BeanListHandler(Widget.class);
                return(java.util.List<Widget>)run.query("{ call sp_get_menu_widgets(?) }",h,pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

    public static java.util.List<Widget> getAllDeployedApplets(){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
                ResultSetHandler<Widget> h = new BeanListHandler(Widget.class);
                return(java.util.List<Widget>)run.query("{ call sp_get_all_deployed_applets() }",h);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

    public static java.util.List<Widget> getApplets(String userName,int room_id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {userName,room_id};
        try{
                ResultSetHandler<Widget> h = new BeanListHandler(Widget.class);
                return(java.util.List<Widget>)run.query("{ call sp_get_user_applets(?,?) }",h,pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

    public static void revokeAppletAccess(String userName,int appletId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {userName,appletId};
        try{
                run.update("{ call sp_revoke_applet_access(?,?) }",pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void grantAppletAccess(int appletId,String userName,Integer room_id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {appletId,userName,room_id};
        try{
                run.update("{ call sp_grant_applet_access(?,?,?) }",pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static java.util.List<Widget> getAppletsByToxonomy(String userName,String category){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {userName,category};
        try{
                ResultSetHandler<Widget> h = new BeanListHandler(Widget.class);
                return(java.util.List<Widget>)run.query("{ call sp_get_applets_by_toxonomy(?,?) }",h,pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }


    public static Widget submitWidget(String userName,int widgetid){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {userName,widgetid};
        try{
                ResultSetHandler<Widget> h = new BeanHandler(Widget.class);
                return (Widget)run.query("{ call sp_submit_widget(?,?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }


    public static Widget reSubmitWidget(String userName,int widgetid){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {userName,widgetid};
        try{
            ResultSetHandler<Widget> h = new BeanHandler(Widget.class);
            return (Widget)run.query("{ call sp_resubmit_widget(?,?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }


    public static Widget approveWidget(int widgetid){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {widgetid};
        try{
             ResultSetHandler<Widget> h = new BeanHandler(Widget.class);
             return (Widget)run.query("{ call sp_approve_widget(?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

    public static Widget rejectWidget(int widgetid){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {widgetid};
        try{
              ResultSetHandler<Widget> h = new BeanHandler(Widget.class);
              return (Widget)run.query("{ call sp_reject_widget(?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }


    public static void withdrawWidget(String userName,int widgetid){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {userName,widgetid};
        try{
             run.update("{ call sp_withdraw_widget(?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void undeployApplet(String userName,int widgetid){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {userName,widgetid};
        try{
             run.update("{ call sp_undeploy_applet(?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }



    public static java.util.List<Widget> getOrderedWidgets(int roomId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
         Object[] pArgs = {roomId};
        try{
                ResultSetHandler<Widget> h = new BeanListHandler(Widget.class);
                return (java.util.List<Widget>)run.query("{ call sp_get_room_orders(?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }


    public static java.util.List<Widget> getOrderedWidgetsByCategory(int roomId,String category){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {roomId,category};
        try{
                ResultSetHandler<Widget> h = new BeanListHandler(Widget.class);
                return (java.util.List<Widget>)run.query("{ call sp_get_room_orders_by_category(?,?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }


    public static void addWidgetDependency(int widgetId,String dependencyId,String dependencyPath){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {widgetId,dependencyId,dependencyPath};
        try{
            run.update("{ call sp_add_widget_dependency(?,?,?) }",pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void deleteWidgetDependency(int widgetId,String dependencyId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {widgetId,dependencyId};
        try{
            run.update("{ call sp_del_widget_dependency(?,?) }",pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void deleteWidgetDependencies(int widgetId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {widgetId};
        try{
            run.update("{ call sp_del_widget_dependencies(?) }",pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }


    public static java.util.List<WidgetDependency> getWidgetDependencies(int widgetId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {widgetId};
        try{
                ResultSetHandler<Widget> h = new BeanListHandler(WidgetDependency.class);
                return(java.util.List<WidgetDependency>)run.query("{ call sp_get_widget_dependencies(?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

    public static boolean isInstalled(String userName,int appletId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {userName,appletId};
        try{
            ResultSetHandler h = new ScalarHandler("count");
            Integer id = (Integer)run.query("{ call sp_has_applet_installed(?,?) }",h, pArgs);
            if(id != null)return id.intValue()==1;
        }catch(Exception ex){
            logger.error("",ex);
        }return false;
    }
}
