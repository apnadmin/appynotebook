/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;
import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class AppletPackageDAO {
    static Logger logger = Logger.getLogger(AppletPackageDAO.class.getName());
    public static void addAppletPackage(String id,String name,String description,String version){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {id,name,description,version};
        try{
            run.update("{ call sp_add_package(?,?,?,?) }",pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }
    public static java.util.List<com.feezixlabs.bean.AppletPackage> getAppletPackages(){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {};
        try{
                ResultSetHandler<com.feezixlabs.bean.AppletPackage> h = new BeanListHandler(com.feezixlabs.bean.AppletPackage.class);
                return(java.util.List<com.feezixlabs.bean.AppletPackage>)run.query("{ call sp_get_packages() }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }
    public static void deleteAppletPackage(String id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {id};
        try{
            run.update("{ call sp_delete_applet_package(?) }",pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void addPackagedApplet(String packageId,int id,String name,String description){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {packageId,id,name,description};
        try{
            run.update("{ call sp_add_packaged_applet(?,?,?,?) }",pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }
    public static java.util.List<com.feezixlabs.bean.PackagedApplet> getPackagedApplets(String packageId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {packageId};
        try{
                ResultSetHandler<com.feezixlabs.bean.PackagedApplet> h = new BeanListHandler(com.feezixlabs.bean.PackagedApplet.class);
                return(java.util.List<com.feezixlabs.bean.PackagedApplet>)run.query("{ call sp_get_packaged_applets(?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }
}
