/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;
import com.feezixlabs.bean.Pad;
import java.util.ArrayList;
import org.apache.log4j.Logger;

/**
 *
 * @author bitlooter
 */
public class PadDAO {
    static Logger logger = Logger.getLogger(PadDAO.class.getName());
    public static int addPad(int roomId,String userName,int contextId,int parentId,int preSibling,String config,int grantor,int defaultAccess){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
            jsonConfig.setJavascriptCompliant(true);
            net.sf.json.JSONObject padJSON = net.sf.json.JSONObject.fromObject(config,jsonConfig);
            if(!padJSON.has("header") || padJSON.getJSONObject("header") == null || padJSON.getJSONObject("header").isNullObject()){
                padJSON.put("header", new java.util.HashMap());
                padJSON.getJSONObject("header").put("static_references", new java.util.ArrayList<String>());
            }else
            if(padJSON.getJSONObject("header").has("static_references"))
            {
                net.sf.json.JSONArray static_references = padJSON.getJSONObject("header").getJSONArray("static_references");
                for(int i=0;i<static_references.size();i++){
                    net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);

                    Integer refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName"));
                    if(refCount == null){
                        com.feezixlabs.db.dao.StaticReferenceDAO.addReference(static_reference.getString("fileName"));
                        com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), 1);
                    }
                    else
                        com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount.intValue()+1);
                }
            }

            ResultSetHandler h = new ScalarHandler("pad_id");
            return (Integer)run.query("{call sp_add_pad(?,?,?,?,?,?,?,?)}",h,roomId,userName,contextId,parentId,preSibling,config,grantor,defaultAccess);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return 0;
    }
    public static void updatePad(String userName,int roomId,int contextId,int padId,String config,int grantor){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_update_pad(?,?,?,?,?,?)}",userName,roomId,contextId,padId,config,grantor);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }
    
    
    public static void updatePadPreSibling(String userName,int roomId,int contextId,int padId,int preSibling){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_update_pad_pre_sibling(?,?,?,?,?)}",userName,roomId,contextId,padId,preSibling);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }    
    
    
    public static void movePad(String userName,int roomId,int contextId,int padId,int parentId,int preSibling,String childrenOnly){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_move_pad(?,?,?,?,?,?,?)}",userName,roomId,contextId,padId,parentId,preSibling,childrenOnly);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }    
    
    public static Pad getPad(String userName,int roomId,int contextId,int id,int grantor){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Pad> h = new BeanListHandler(Pad.class);
            //System.out.println("call sp_get_pad(\""+userName+"\","+roomId+","+contextId+","+id+","+grantor+")");

            return ((java.util.List<Pad>)run.query("{call sp_get_pad(?,?,?,?,?)}", h,userName,roomId,contextId,id,grantor)).get(0);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static Pad getEmbededPad(String embedKey){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Pad> h = new BeanHandler(Pad.class);

            return (Pad) run.query("call sp_get_embeded_pad(?)", h,embedKey);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static java.util.List<Pad> getPads(String userName,int roomId,int contextId,int grantor){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Pad> h = new BeanListHandler(Pad.class);

            return (java.util.List<Pad>)run.query("{call sp_get_pads(?,?,?,?)}", h,userName,roomId,contextId,grantor);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static void deletePad(String userName,int roomId,int contextId,int padId,int grantor){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
            jsonConfig.setJavascriptCompliant(true);

            com.feezixlabs.bean.Pad pad = com.feezixlabs.db.dao.PadDAO.getPad(userName, roomId, contextId,padId, grantor);
            net.sf.json.JSONObject padJSON = net.sf.json.JSONObject.fromObject(pad.getConfig(),jsonConfig);
            if(padJSON.has("header") && padJSON.getJSONObject("header") != null && !padJSON.getJSONObject("header").isNullObject() && padJSON.getJSONObject("header").has("static_references")){

                net.sf.json.JSONArray static_references = padJSON.getJSONObject("header").getJSONArray("static_references");

                for(int i=0;i<static_references.size();i++){
                    net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);
                    int refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName")).intValue()-1;
                    if(refCount == 0){
                        com.feezixlabs.db.dao.ElementDAO.deleteElementStaticContent(static_reference.getString("fileName"));
                    }
                    com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount);
                }
            }

            java.util.List<com.feezixlabs.bean.Element> elements = com.feezixlabs.db.dao.ElementDAO.getElements(userName,roomId, contextId, padId, grantor);
            for(com.feezixlabs.bean.Element element:elements){
                com.feezixlabs.db.dao.ElementDAO.deleteElement(userName,roomId,contextId, padId, element.getId(), grantor);
            }
            run.update("{call sp_del_pad(?,?,?,?,?)}",userName,roomId,contextId,padId,grantor);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }

    public static int getPadCount(String userName,int roomId,int contextId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            ResultSetHandler h = new ScalarHandler("count");
            return (Integer)run.query("{ call sp_get_pad_count(?,?,?) }",h,userName,roomId,contextId);
        }catch(Exception ex){
            logger.error("",ex);
        }return 0;
    }
}
