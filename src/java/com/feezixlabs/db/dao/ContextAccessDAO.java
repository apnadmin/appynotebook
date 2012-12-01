/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;
import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;

import com.feezixlabs.bean.ContextAccess;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class ContextAccessDAO {
    static Logger logger = Logger.getLogger(ContextAccessDAO.class.getName());

  public static java.util.List<ContextAccess> getContextAccessList(String userName,int roomId,int grantedTo){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
                ResultSetHandler<ContextAccess> h = new BeanListHandler(ContextAccess.class);
                return (java.util.List<ContextAccess>)run.query("{ call sp_get_context_access_list(?,?,?) }", h,userName,roomId,grantedTo);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
   }

   public static ContextAccess getContextAccess(String userName,int roomId,int contextId,int grantedTo){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            ResultSetHandler<ContextAccess> h = new BeanHandler(ContextAccess.class);
            return (ContextAccess)run.query("{ call sp_get_context_access(?,?,?,?) }", h,userName,roomId,contextId,grantedTo);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
   }

   public static void addContextAccess(String userName,int roomId,int contextId,int grantedTo,int access){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_add_context_access(?,?,?,?,?) }", userName,roomId,contextId,grantedTo,access);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }

   public static void updateContextAccess(String userName,int roomId,int id,int grantedTo,int access){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_update_context_access(?,?,?,?,?) }", userName,roomId,id,grantedTo,access);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }


   public static void deleteContextAccess(String userName,int roomId,int id,int grantedTo){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_del_context_access(?,?,?,?) }", userName,roomId,id,grantedTo);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }

}
