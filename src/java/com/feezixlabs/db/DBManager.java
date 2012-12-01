/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db;

import com.feezixlabs.bean.Participant;
import com.feezixlabs.bean.Room;

import com.feezixlabs.bean.Widget;
import com.feezixlabs.bean.Resource;
import com.feezixlabs.bean.Author;
import com.feezixlabs.bean.TextData;
import com.feezixlabs.bean.Context;
import com.feezixlabs.bean.Pad;
import com.feezixlabs.bean.Element;

import com.feezixlabs.bean.ContextAccess;
import com.feezixlabs.bean.PadAccess;

import com.feezixlabs.bean.SignUpRequest;

import com.feezixlabs.bean.SqlNull;
import com.feezixlabs.bean.OutVal;
import com.feezixlabs.bean.BeanToTableModel;
import com.feezixlabs.util.Utility;
import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;
import org.apache.log4j.Logger;

/**
 *
 * @author bitlooter
 */
public class DBManager {

    static Logger logger = Logger.getLogger(DBManager.class.getName());

    private static org.apache.commons.dbutils.QueryRunner _queryRunner = null;
    private static javax.sql.DataSource _dataSource = null;
    public  static boolean              jdni_use_absolute = false;

    public static final BeanToTableModel VROOM_RESERVATION_TABLE_MODEL = new BeanToTableModel();
    public static final BeanToTableModel VROOM_PARTICIPANT_TABLE_MODEL = new BeanToTableModel();

    public static final BeanToTableModel WIDGET_TABLE_MODEL = new BeanToTableModel();
    public static final BeanToTableModel RESOURCE_TABLE_MODEL = new BeanToTableModel();
    public static final BeanToTableModel AUTHOR_TABLE_MODEL = new BeanToTableModel();
    public static final BeanToTableModel TEXT_DATA_TABLE_MODEL = new BeanToTableModel();


    public static final BeanToTableModel CONTEXT_TABLE_MODEL = new BeanToTableModel();
    public static final BeanToTableModel PAD_TABLE_MODEL = new BeanToTableModel();
    public static final BeanToTableModel ELEMENT_TABLE_MODEL = new BeanToTableModel();

    public static final BeanToTableModel CONTEXT_ACCESS_TABLE_MODEL = new BeanToTableModel();
    public static final BeanToTableModel PAD_ACCESS_TABLE_MODEL = new BeanToTableModel();

    public static final BeanToTableModel SIGNUP_REQUEST_TABLE_MODEL = new BeanToTableModel();


    //public static final String RESOURCE_FILE_PATH = "/home/bitlooter/colabopad-widget-resources";
    //public static final String IMAGE_UPLOAD_FILE_PATH = "/home/bitlooter/colabopad-img-uploads";
    //public static final String UPLOAD_FILE_TEMP_PATH = "/home/bitlooter/colabopad-tmp";

    static{
        String[][] rsvColDef={{"res_id","id","integer"},
                              {"title","label","string"},
                              {"create_date","createDate","date"},
                              {"access_code","accessCode","string"},
                              {"amq_topic_uri","topicUri","string"},
                              {"requester_id","requesterId","integer"},
                              {"requester_secure_token","requesterSecureToken","string"},
                              {"creator_id","creatorId","integer"}};
       VROOM_RESERVATION_TABLE_MODEL.setColDefinitions(rsvColDef);
       VROOM_RESERVATION_TABLE_MODEL.setBeanType(Room.class);

       String[][] patColDef  ={{"res_id","reservationId","integer"},
                               {"participant_id","id","integer"},
                               {"first_name","firstName","string"},
                               {"last_name","lastName","string"},
                               {"email_addr","emailAddress","string"},
                               {"secure_token","secureToken","string"}};
       VROOM_PARTICIPANT_TABLE_MODEL.setColDefinitions(patColDef);
       VROOM_PARTICIPANT_TABLE_MODEL.setBeanType(Participant.class);



       String[][] widgetColDef  ={                                  
                                  {"id","id","integer"},
                                  {"creator_id","creatorId","string"},
                                  {"name","name","string"},
                                  {"description","description","string"},
                                  {"category","category","string"},
                                  {"tags","tags","string"},
                                  {"icon_res_id","iconId","integer"},
                                  {"code","code","string"},
                                  {"status","status","string"},
                                  {"version","version","string"},
                                  {"author_name","authorName","string"},
                                  {"author_link","authorLink","string"},
                                  {"show_in_menu","showInMenu","string"},
                                  {"default_instance","defaultInstance","string"},
                                  {"question","question","string"},
                                  {"price","price","float"},
                                  {"catalog_page_index","catalogPage","integer"}};
       WIDGET_TABLE_MODEL.setColDefinitions(widgetColDef);
       WIDGET_TABLE_MODEL.setBeanType(Widget.class);

       String[][] resourceColDef  ={                                    
                                    {"widget_id","widgetId","integer"},
                                    {"file_name","fileName","string"},
                                    {"label","label","string"},
                                    {"fs_name","fsName","string"},
                                    {"type","type","string"},
                                    {"mime","mime","string"},
                                    {"size","size","integer"},
                                    {"create_date","createDate","date"},
                                    {"last_mod_date","lastModDate","date"}};
       RESOURCE_TABLE_MODEL.setColDefinitions(resourceColDef);
       RESOURCE_TABLE_MODEL.setBeanType(Resource.class);

       String[][] authorColDef  ={{"id","id","integer"},
                                  {"name","name","string"},
                                  {"link","link","string"},
                                  {"thumbnail_res_id","thumbnailId","integer"}};
       AUTHOR_TABLE_MODEL.setColDefinitions(authorColDef);
       AUTHOR_TABLE_MODEL.setBeanType(Author.class);

       String[][] textColDef  ={{"id","id","String"},
                                {"descp","description","string"},
                                {"data","data","string"}};
       TEXT_DATA_TABLE_MODEL.setColDefinitions(textColDef);
       TEXT_DATA_TABLE_MODEL.setBeanType(TextData.class);

       String[][] contextColDef  ={{"room_id","roomId","integer"},
                                  {"participant_id","participantId","integer"},
                                  {"id","id","integer"},
                                  {"access_control","accessControl","integer"},
                                  {"access","access","integer"},
                                  {"config","config","string"}};
       CONTEXT_TABLE_MODEL.setColDefinitions(contextColDef);
       CONTEXT_TABLE_MODEL.setBeanType(Context.class);

        String[][] padColDef  ={{"room_id","roomId","integer"},
                                {"participant_id","participantId","integer"},
                                {"context_id","contextId","integer"},
                                {"id","id","integer"},
                                {"access_control","accessControl","integer"},
                                {"access","access","integer"},
                                {"config","config","string"}};
       PAD_TABLE_MODEL.setColDefinitions(padColDef);
       PAD_TABLE_MODEL.setBeanType(Pad.class);

       String[][] elementColDef  ={{"room_id","roomId","integer"},
                                   {"participant_id","participantId","integer"},
                                   {"context_id","contextId","integer"},
                                   {"pad_id","padId","integer"},
                                   {"id","id","integer"},
                                   {"config","config","string"}};
       ELEMENT_TABLE_MODEL.setColDefinitions(elementColDef);
       ELEMENT_TABLE_MODEL.setBeanType(Element.class);


       String[][] contextAccessColDef  ={{"room_id","roomId","integer"},
                                         {"participant_id","participantId","integer"},
                                         {"id","id","integer"},
                                         {"access","access","integer"},
                                         {"granted_to","grantedTo","integer"}};
       CONTEXT_ACCESS_TABLE_MODEL.setColDefinitions(contextAccessColDef);
       CONTEXT_ACCESS_TABLE_MODEL.setBeanType(ContextAccess.class);

        String[][] padAccessColDef  ={{"room_id","roomId","integer"},
                                      {"participant_id","participantId","integer"},
                                      {"context_id","contextId","integer"},
                                      {"id","id","integer"},
                                      {"access","access","integer"},
                                      {"granted_to","grantedTo","integer"}};
       PAD_ACCESS_TABLE_MODEL.setColDefinitions(padAccessColDef);
       PAD_ACCESS_TABLE_MODEL.setBeanType(PadAccess.class);


        String[][] signUpRequestColDef  =
                                      {{"id","id","integer"},
                                      {"first_name","firstName","string"},
                                      {"last_name","lastName","string"},
                                      {"email","email","string"},
                                      {"home_page","homePage","string"},
                                      {"course","course","string"},
                                      {"request_date","requestDate","date"},
                                      {"security_tk","securityToken","string"}};
       SIGNUP_REQUEST_TABLE_MODEL.setColDefinitions(signUpRequestColDef);
       SIGNUP_REQUEST_TABLE_MODEL.setBeanType(SignUpRequest.class);
    }


    public static void init(){
        try{
            /*
            javax.naming.Context initContext = new javax.naming.InitialContext();
            javax.naming.Context envContext  = (javax.naming.Context)initContext.lookup("java:/comp/env");
            DBManager._dataSource = (javax.sql.DataSource)envContext.lookup("jdbc/feezixlabsDB");
            */
            javax.naming.Context initContext = new javax.naming.InitialContext();
            DBManager._dataSource = (javax.sql.DataSource)initContext.lookup("java:comp/env/jdbc/appynotebookDB");
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static QueryRunner getDataSource(){
        QueryRunner run = new QueryRunner(DBManager._dataSource);

        try{
                run.update("select 1");
        }catch(Exception ex){
            //logger.error("",ex);
        }
        return run;
    }

    private static void sp_update(String spSqlStatement,Object spArgs[])throws Exception{
       java.sql.CallableStatement statement = null;
       java.sql.Connection con = null;
       try
       {
          con = DBManager._dataSource.getConnection();
          statement = con.prepareCall(spSqlStatement);
          int argLength = spArgs.length;
          for(int j=0;j<argLength;j++){
              if(spArgs[j] instanceof SqlNull)
                   statement.setNull(j+1,((SqlNull)spArgs[j]).getType());
              else
              if( spArgs[j] instanceof String)
                statement.setString(j+1,(String)spArgs[j]);
              else
              if( spArgs[j] instanceof Integer)
                statement.setInt(j+1,(Integer)spArgs[j]);
              else
              if( spArgs[j] instanceof Float)
                statement.setFloat(j+1,(Float)spArgs[j]);
              else
              if( spArgs[j] instanceof Double)
                statement.setDouble(j+1,(Double)spArgs[j]);
              else
              if( spArgs[j] instanceof java.util.Date)
                statement.setDate(j+1,(new java.sql.Date( ((java.util.Date)spArgs[j]).getTime()  )));
              else
              if( spArgs[j] instanceof Boolean)
                statement.setBoolean(j+1,(Boolean)spArgs[j]);
              else
              if( spArgs[j] instanceof OutVal){
                  statement.setNull(j+1,((OutVal)spArgs[j]).getDataType());
                  statement.registerOutParameter(j+1, ((OutVal)spArgs[j]).getDataType() );
              }
          }
          statement.executeUpdate();

          //process out parameters
          for(int j=0;j<argLength;j++){
              if( spArgs[j] instanceof OutVal){
                  spArgs[j] = statement.getObject(j+1);
              }
          }
       }
       catch(Exception ex){
           throw ex;
       }
       finally{
           try{
               statement.close();
               con.close();
           }
           catch(Exception e){

           }
       }
    }

      private static java.util.Collection sp_query(String spSqlStatement,Object[] spArgs,BeanToTableModel colModel)throws Exception{
        java.util.Vector table = new java.util.Vector();
        java.sql.CallableStatement statement = null;
        java.sql.ResultSet rs;
        java.sql.Connection con = null;

        try{
            con = DBManager._dataSource.getConnection();
             statement = con.prepareCall(spSqlStatement);
             int argLength = spArgs.length;
             for(int j=0;j<argLength;j++){
                 
              if(spArgs[j] instanceof SqlNull)  
                   statement.setNull(j+1,((SqlNull)spArgs[j]).getType());
              else
              if( spArgs[j] instanceof String)
                statement.setString(j+1,(String)spArgs[j]);
              else
              if( spArgs[j] instanceof Integer)
                statement.setInt(j+1,(Integer)spArgs[j]);
              else
              if( spArgs[j] instanceof Float)
                statement.setFloat(j+1,(Float)spArgs[j]);
              else
              if( spArgs[j] instanceof Double)
                statement.setDouble(j+1,(Double)spArgs[j]); 
              else
              if( spArgs[j] instanceof java.util.Date)
                statement.setDate(j+1,(new java.sql.Date( ((java.util.Date)spArgs[j]).getTime()  )));
              else
              if( spArgs[j] instanceof Boolean)
                statement.setBoolean(j+1,(Boolean)spArgs[j]);     
              else
              if( spArgs[j] instanceof OutVal){
                  statement.setNull(j+1,((OutVal)spArgs[j]).getDataType());
                  statement.registerOutParameter(j+1, ((OutVal)spArgs[j]).getDataType() );
              }
             }
             rs = statement.executeQuery(); 
             
             while(rs.next()){
                 Object rowBean = colModel.getBeanType().newInstance();

                  for(int i = 0; i<colModel.getColDefinitions().length; i++){

                     try{
                         if(colModel.getColDefinitions()[i][2].compareTo("string") == 0){
                             org.apache.commons.beanutils.PropertyUtils.setProperty(rowBean, colModel.getColDefinitions()[i][1], rs.getString(colModel.getColDefinitions()[i][0]));
                         }
                         else
                         if(colModel.getColDefinitions()[i][2].compareTo("integer") == 0){
                             org.apache.commons.beanutils.PropertyUtils.setProperty(rowBean, colModel.getColDefinitions()[i][1], rs.getInt(colModel.getColDefinitions()[i][0]));
                         }
                         else
                         if(colModel.getColDefinitions()[i][2].compareTo("date") == 0){
                             org.apache.commons.beanutils.PropertyUtils.setProperty(rowBean, colModel.getColDefinitions()[i][1], rs.getDate(colModel.getColDefinitions()[i][0]));
                         }
                         else
                         if(colModel.getColDefinitions()[i][2].compareTo("float") == 0){
                             org.apache.commons.beanutils.PropertyUtils.setProperty(rowBean, colModel.getColDefinitions()[i][1], rs.getFloat(colModel.getColDefinitions()[i][0]));
                         }
                         else
                         if(colModel.getColDefinitions()[i][2].compareTo("double") == 0){
                             org.apache.commons.beanutils.PropertyUtils.setProperty(rowBean, colModel.getColDefinitions()[i][1], rs.getDouble(colModel.getColDefinitions()[i][0]));
                         }
                         else
                         if(colModel.getColDefinitions()[i][2].compareTo("boolean") == 0){
                             org.apache.commons.beanutils.PropertyUtils.setProperty(rowBean, colModel.getColDefinitions()[i][1], rs.getBoolean(colModel.getColDefinitions()[i][0]));
                         }
                     }catch(Exception ex){}
                  }
                 table.add(rowBean);
             }

             //process out parameters
             for(int j=0;j<argLength;j++){
                  if( spArgs[j] instanceof OutVal){
                      spArgs[j] = statement.getObject(j+1);
                  }
             }
        }catch(Exception e){
              throw e;
        }
        finally{
             try{
                  statement.close();
                  con.close();
                }catch(Exception e){
                }
        } return table;
    }










   





















   public static SignUpRequest queueSignUpRequest(String email,String firstName,String lastName,String courseTitle,String homePage){
        Object[] pArgs = {email,
                          firstName,
                          lastName,
                          courseTitle,
                          homePage};
        try{
            java.util.Vector row = (java.util.Vector)DBManager.sp_query("{ call sp_queue_signup_request(?,?,?,?,?) }", pArgs,SIGNUP_REQUEST_TABLE_MODEL);
            if(row!=null && row.size()==1)
                return (SignUpRequest)row.get(0);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
   }

   public static java.util.Vector<SignUpRequest> getSignUpRequestQueue(){
        try{
                Object[] pArgs = {};
                return  (java.util.Vector)DBManager.sp_query("{ call sp_get_signup_request_queue() }", pArgs,SIGNUP_REQUEST_TABLE_MODEL);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
   }

   public static SignUpRequest getSignUpRequest(int id,String securityToken){
        Object[] pArgs = {id,
                          securityToken};
        try{
            java.util.Vector row = (java.util.Vector)DBManager.sp_query("{ call sp_get_signup_request(?,?) }", pArgs,SIGNUP_REQUEST_TABLE_MODEL);
            if(row!=null && row.size()==1)
                return (SignUpRequest)row.get(0);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
   }

   public static void deleteSignUpRequest(int id,String securityToken){
        Object[] pArgs = {id,
                          securityToken};
        try{
            DBManager.sp_update("{ call sp_delete_signup_request(?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }


   public static void approveSignUpRequest(int id,String securityToken){
        SignUpRequest request = DBManager.getSignUpRequest(id,securityToken);
        /*****
        if(request != null){
            com.feezixlabs.bean.Participant newParticipant = new com.feezixlabs.bean.Participant();
            newParticipant.setFirstName(request.getFirstName());
            newParticipant.setLastName(request.getLastName());
            newParticipant.setEmailAddress(request.getEmail());

            com.feezixlabs.bean.Room newReservation = new com.feezixlabs.bean.Room();
            newReservation.setParticipants(new java.util.Vector<com.feezixlabs.bean.Participant>());
            newReservation.setLabel(request.getCourse());
            newReservation.setCreator(newParticipant);

            newReservation = com.colabopad.db.DBManager.addReservation(newReservation);
            newParticipant = newReservation.getParticipants().get(0);

            //remove request
            DBManager.deleteSignUpRequest(id, securityToken);
        }
         *****/
   }

   public static void rejectSignUpRequest(int id,String securityToken){
        SignUpRequest request = DBManager.getSignUpRequest(id,securityToken);

        if(request != null){
            //remove request
            DBManager.deleteSignUpRequest(id, securityToken);

            com.feezixlabs.util.Utility.notifySignUpRequestRejected(request);
        }
   }
}


