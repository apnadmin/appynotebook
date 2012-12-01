/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;
import com.feezixlabs.bean.PadAccess;
import org.apache.log4j.Logger;

/**
 *
 * @author bitlooter
 */
public class PadAccessDAO {
   static Logger logger = Logger.getLogger(PadAccessDAO.class.getName());
   public static java.util.List<PadAccess> getPadAccessList(String userName,int roomId,int contextId,int grantedTo){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
                ResultSetHandler<PadAccess> h = new BeanListHandler(PadAccess.class);
                return  (java.util.List<PadAccess>)run.query("{ call sp_get_pad_access_list(?,?,?,?) }",h,userName,roomId,contextId,grantedTo);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
   }


   public static PadAccess getPadAccess(String userName,int roomId,int contextId,int id,int grantedTo){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
             ResultSetHandler<PadAccess> h = new BeanHandler(PadAccess.class);
             return  (PadAccess)run.query("{ call sp_get_pad_access(?,?,?,?,?) }",h,userName,roomId,contextId,id,grantedTo);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
   }

   public static void addPadAccess(String userName,int roomId,int contextId,int id,int grantedTo,int access){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_add_pad_access(?,?,?,?,?,?) }",userName,roomId,contextId,id,grantedTo,access);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }

   public static void updatePadAccess(String userName,int roomId,int contextId,int id,int grantedTo,int access){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_update_pad_access(?,?,?,?,?,?) }",userName,roomId,contextId,id,grantedTo,access);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }


   public static void deletePadAccess(String userName,int roomId,int contextId,int id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_del_pad_access(?,?,?,?) }",userName,roomId,contextId,id);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }
}
