/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;
import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;

import com.feezixlabs.bean.Context;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class ContextDAO {
    static Logger logger = Logger.getLogger(ContextDAO.class.getName());

    public static int addContext(String userName,int roomId,String config,int defaultAccess){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            ResultSetHandler h = new ScalarHandler("context_id");
            return (Integer)run.query("{ call sp_add_context(?,?,?,?) }",h,userName,roomId,config,defaultAccess);
        }catch(Exception ex){
            logger.error("",ex);
        }return 0;
    }

    public static void updateContext(String userName,int roomId,int contextId,String config,int grantor){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_update_context(?,?,?,?,?)}",userName,roomId,contextId,config,grantor);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }
    public static Context getContext(String userName,int roomId,int contextId, int grantor){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Context> h = new BeanListHandler(Context.class);
            java.util.List<Context> result = (java.util.List<Context>)run.query("{call sp_get_context(?,?,?,?)}", h,userName,roomId,contextId,grantor);
            if(result.size()>0)return result.get(0);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static java.util.List<Context> getContexts(String userName,int roomId, int grantor){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Context> h = new BeanListHandler(Context.class);

            return (java.util.List<Context>)run.query("call sp_get_contexts(?,?,?)", h,userName,roomId,grantor);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static void deleteContext(String userName,int roomId,int contextId,int grantor){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
           java.util.List<com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(userName,roomId, contextId, grantor);
           for(com.feezixlabs.bean.Pad pad:pads){
                com.feezixlabs.db.dao.PadDAO.deletePad(userName,roomId,contextId, pad.getId(), grantor);
           }
           run.update("call sp_del_context(?,?,?,?)",userName,roomId,contextId,grantor);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }

   public static int distributeContext(String userName,int roomId,int giveTo,int contextId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {
                          userName,
                          roomId,
                          giveTo,
                          contextId};
        try{
            ResultSetHandler h = new ScalarHandler("context_id");
            return (Integer)run.query("{ call sp_distribute_context(?,?,?,?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return -1;
   }
    public static int getContextCount(String userName,int roomId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            ResultSetHandler h = new ScalarHandler("count");
            return (Integer)run.query("{ call sp_get_context_count(?,?) }",h,userName,roomId);
        }catch(Exception ex){
            logger.error("",ex);
        }return 0;
    }

}
