/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;

import com.feezixlabs.bean.Element;
import net.sf.json.JSONException;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class ElementDAO {
   static Logger logger = Logger.getLogger(ElementDAO.class.getName());
   public static java.util.List<Element> getElements(String userName,int roomId,int contextId,int padId,int grantor){

        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Element> h = new BeanListHandler(Element.class);

            return (java.util.List<Element>)run.query("{call sp_get_elements(?,?,?,?,?)}", h,userName,roomId,contextId,padId,grantor);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
   }

   public static Element getElement(String userName,int roomId,int contextId,int padId,int id,int grantor){

        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Element> h = new BeanListHandler(Element.class);
            //System.out.println("call sp_get_element(\""+userName+"\","+roomId+","+contextId+","+padId+","+id+","+grantor+")");
            return ((java.util.List<Element>)run.query("{call sp_get_element(?,?,?,?,?,?)}", h,userName,roomId,contextId,padId,id,grantor)).get(0);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
   }

   public static java.util.List<Element> getEmbededElements(int roomId,int contextId,int padId,int grantor){

        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Element> h = new BeanListHandler(Element.class);

            return (java.util.List<Element>)run.query("{call sp_get_embeded_elements(?,?,?,?)}", h,roomId,contextId,padId,grantor);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
   }

   public static int addElement(String userName,int roomId,int contextId,int padId,String config,int grantor,int defaultAccess){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
            jsonConfig.setJavascriptCompliant(true);
            
            
            net.sf.json.JSONObject elementJSON = net.sf.json.JSONObject.fromObject(config.replaceAll("NaN","null"),jsonConfig);
            String type = elementJSON.getString("type");
            
            if(!elementJSON.has("header") || elementJSON.getJSONObject("header") == null || elementJSON.getJSONObject("header").isNullObject()){
                elementJSON.put("header", new java.util.HashMap());
            }else
            if(elementJSON.getJSONObject("header").has("static_references"))
            {
                net.sf.json.JSONArray static_references = elementJSON.getJSONObject("header").getJSONArray("static_references");
                for(int i=0;i<static_references.size();i++){
                    net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);

                    //System.out.println("looking for:"+static_reference.getString("fileName"));
                    int refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName")).intValue()+1;
                    com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount);
                }
            }
            ResultSetHandler h = new ScalarHandler("element_id");
            return (Integer)run.query("{ call sp_add_element(?,?,?,?,?,?,?) }",h,userName,roomId,contextId,padId,elementJSON.toString(),grantor,defaultAccess);
        }catch(Exception ex){
            logger.error("",ex);
        }return 0;
   }


   public static void updateElement(String userName,int roomId,int contextId,int padId,int id,String config,int grantor){

        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
         try{
            run.update("{ call sp_update_element(?,?,?,?,?,?,?) }",userName,roomId,contextId,padId,id,config,grantor);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }

   static void deleteElementImage(int userId,int roomId,int contextId,int padId,int id,int grantor){
       java.io.File f = new java.io.File(com.feezixlabs.util.ConfigUtil.image_upload_directory+"/img-"+roomId+"-"+userId+"-"+contextId+"-"+padId+"-"+id);
       if(f.exists())
        f.delete();

       f = new java.io.File(com.feezixlabs.util.ConfigUtil.image_upload_directory+"/html2png-"+roomId+"-"+userId+"-"+contextId+"-"+padId+"-"+id+".png");
       if(f.exists())
        f.delete();
   }

   static void deleteElementStaticContent(String name){
       java.io.File f = new java.io.File(com.feezixlabs.util.ConfigUtil.static_file_directory+"/"+name);
       if(f.exists())
        f.delete();
   }

   public static int deleteElement(String userName,int roomId,int contextId,int padId,int id,int grantor){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
            jsonConfig.setJavascriptCompliant(true);
            com.feezixlabs.bean.Element element = com.feezixlabs.db.dao.ElementDAO.getElement(userName, roomId, contextId, padId, id, grantor);
            net.sf.json.JSONObject elementJSON = net.sf.json.JSONObject.fromObject(element.getConfig().replaceAll("NaN","null"),jsonConfig);
            if(elementJSON.has("header")&& elementJSON.getJSONObject("header") != null && !elementJSON.getJSONObject("header").isNullObject() &&  elementJSON.getJSONObject("header").has("static_references")){

                net.sf.json.JSONArray static_references = elementJSON.getJSONObject("header").getJSONArray("static_references");

                for(int i=0;i<static_references.size();i++){
                    net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);
                    int refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName")).intValue()-1;
                    if(refCount == 0){
                        deleteElementStaticContent(static_reference.getString("fileName"));
                    }
                    com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount);
                }
            }

            //deleteElementImage(com.feezixlabs.db.dao.UserDOA.getUserId(userName),roomId,contextId, padId, id, grantor);
            ResultSetHandler h = new ScalarHandler("last_insert_id");
            Integer nextInsertId = (Integer)run.query("{ call sp_del_element(?,?,?,?,?,?) }",h,userName,roomId,contextId,padId,id,grantor);
            if(nextInsertId == null)return 0;
            return nextInsertId.intValue();            
        }catch(Exception ex){
            logger.error("",ex);
        }return 0;
   }
}
