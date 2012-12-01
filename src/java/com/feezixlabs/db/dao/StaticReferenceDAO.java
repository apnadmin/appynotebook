/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;

import com.feezixlabs.bean.Element;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class StaticReferenceDAO {
   static Logger logger = Logger.getLogger(StaticReferenceDAO.class.getName());
   public static Integer getReference(String fileName){

        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler h = new ScalarHandler("reference_count");
            return (Integer)run.query("{call sp_get_static_reference(?)}", h,fileName);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
   }

   public static void addReference(String fileName){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_add_static_reference(?) }",fileName);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }


   public static void updateReference(String fileName,int refCount){

        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
         try{
            run.update("{ call sp_update_static_reference(?,?) }",fileName,refCount);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }
}
