/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;

import com.feezixlabs.bean.Resource;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class WidgetResourceDAO {
    static Logger logger = Logger.getLogger(WidgetResourceDAO.class.getName());
    public static int addResource(String userName,int widgetId,Resource resource,String env){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {
                          userName,
                          widgetId,
                          resource.getFileName(),
                          resource.getLabel(),
                          resource.getFsName(),
                          resource.getType(),
                          resource.getMime(),
                          resource.getSize(),
                          env};
        try{
            ResultSetHandler h = new ScalarHandler("resource_id");
            Integer id = (Integer)run.query("{ call sp_add_resource(?,?,?,?,?,?,?,?,?) }",h, pArgs);
            if(id != null)return id.intValue();
        }catch(Exception ex){
            logger.error("",ex);
        }return 0;
    }

    public static void updateResource(String userName,String oldName,Resource resource){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {
                          userName,
                          resource.getWidgetId(),
                          oldName,
                          resource.getFileName(),
                          resource.getLabel(),
                          resource.getType(),
                          resource.getMime()};
        try{
            run.update("{ call sp_update_resource(?,?,?,?,?,?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }


    public static java.util.List<Resource> getResources(String userName,int widgetId,String env){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {userName,widgetId,env};
        try{
                ResultSetHandler<Resource> h = new BeanListHandler(Resource.class);
                return(java.util.List<Resource>)run.query("{ call sp_get_resources(?,?,?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }


    public static Resource getResource(String userName,int widgetId,String file_name,String env){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {userName,widgetId,file_name,env};
        try{
                ResultSetHandler<Resource> h = new BeanHandler(Resource.class);
                return(Resource)run.query("{ call sp_get_resource(?,?,?,?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

    public static void deleteResource(String userName,int widgetid,String file_name,String env){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {userName,widgetid,file_name,env};
        try{
            Resource resource = getResource(userName,widgetid, file_name,env);
            java.io.File file = new java.io.File(com.feezixlabs.util.ConfigUtil.resource_directory+"/"+env+"/applet-"+resource.getWidgetId()+"/resources/"+resource.getFsName());

            if(!file.isDirectory())
                file.delete();
            else
                org.apache.commons.io.FileUtils.deleteDirectory(file);


            run.update("{ call sp_del_resource(?,?,?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

}
