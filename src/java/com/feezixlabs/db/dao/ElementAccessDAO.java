/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;
import com.feezixlabs.bean.ElementAccess;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class ElementAccessDAO {
   static Logger logger = Logger.getLogger(ElementAccessDAO.class.getName());
   public static java.util.List<ElementAccess> getElementAccessList(String userName,int roomId,int contextId,int padId,int grantedTo){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
                ResultSetHandler<ElementAccess> h = new BeanListHandler(ElementAccess.class);
                return  (java.util.List<ElementAccess>)run.query("{ call sp_get_element_access_list(?,?,?,?,?) }",h,userName,roomId,contextId,padId,grantedTo);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
   }


   public static ElementAccess getElementAccess(String userName,int roomId,int contextId,int padId,int id,int grantedTo){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
             ResultSetHandler<ElementAccess> h = new BeanListHandler(ElementAccess.class);
             return  ((java.util.List<ElementAccess>)run.query("{ call sp_get_element_access(?,?,?,?,?,?) }",h,userName,roomId,contextId,padId,id,grantedTo)).get(0);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
   }

   public static void addElementAccess(String userName,int roomId,int contextId,int padId,int id,int grantedTo,int access){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_add_element_access(?,?,?,?,?,?,?) }",userName,roomId,contextId,padId,id,grantedTo,access);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }

   public static void updateElementAccess(String userName,int roomId,int contextId,int padId,int id,int grantor,int grantedTo,int access){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_update_element_access(?,?,?,?,?,?,?,?) }",userName,roomId,contextId,padId,id,grantor,grantedTo,access);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }


   public static void deleteElementAccess(String userName,int roomId,int contextId,int padId,int id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_del_element_access(?,?,?,?,?) }",userName,roomId,contextId,padId,id);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }
}
