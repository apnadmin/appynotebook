/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import java.io.File;
import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;
import com.feezixlabs.bean.Room;
import com.feezixlabs.bean.Participant;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class ParticipantDAO {
    static Logger logger = Logger.getLogger(ParticipantDAO.class.getName());

    public static java.util.List<Participant> getParticipants(int roomId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Participant> h = new BeanListHandler(Participant.class);
            return (java.util.List<Participant>)run.query("{call sp_get_participants(?)}", h,roomId);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static Participant getParticipant(int roomId,int participantId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Participant> h = new BeanListHandler(Participant.class);
            java.util.List<Participant> result =  (java.util.List<Participant>)run.query("{call sp_get_participant(?,?)}", h,roomId,participantId);
            if(result.size()>0)return result.get(0);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static void addParticipant(String userId,int participantId,int roomId,String role){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_add_participant(?,?,?,?)}",userId,participantId,roomId,role);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }

    public static void deleteParticipant(String userId,int roomId,int participantId){
        java.io.File imgdir = new java.io.File(com.feezixlabs.util.ConfigUtil.image_upload_directory);

        //delete any images associated with this participant
        com.feezixlabs.util.FileFilter ff = new com.feezixlabs.util.FileFilter();
        ff.match = "img-"+roomId+"-"+participantId;
        java.io.File[] files = imgdir.listFiles(ff);
        for (int i=0;i<files.length;i++)
            files[i].delete();

        ff.match = "html2png-"+roomId+"-"+participantId;
        files = imgdir.listFiles(ff);
        for (int i=0;i<files.length;i++)
            files[i].delete();
        
        
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_delete_participant(?,?,?)}",userId,roomId,participantId);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }

    /***
    static void deleteParticipantImages(int reservationId,int participantId,int grantor){
        java.util.List<Context> contexts = DBManager.getContexts(reservationId, participantId, grantor);
        for(Context context:contexts){
            DBManager.deleteContextImages(grantor, participantId, context.getId(), grantor);
        }
    }

    static void deleteParticipant(int reservationId,int participantId,int grantor){
        Object[] pArgs = {reservationId,grantor};
        try{
            DBManager.deleteParticipantImages(reservationId, participantId, grantor);
            DBManager.sp_update("{ call sp_delete_vroom_participant(?,?) }", pArgs);
            //new java.io.File(DBManager.IMAGE_UPLOAD_FILE_PATH+"img-"+participantId+"-*").delete();
            //Utility.deleteFile(DBManager.IMAGE_UPLOAD_FILE_PATH+"/img-"+participantId+"-*");
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void deleteParticipant(String accessCode,int participantId,int toDel){
        Room room = DBManager.getRoom(accessCode);
        if(room.getUserId() == participantId)
            DBManager.deleteParticipant(room.getId(),participantId,toDel);
    }

    public static void makeParticipantDeveloper(int reservationId,int participantId){
        Object[] pArgs = {reservationId,participantId};
        try{
            DBManager.sp_update("{ call sp_make_developer(?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static Participant getParticipant(String accessCode,int id){

        Room room = DBManager.getRoom(accessCode);
        Object[] pArgs = {room.getId(),id};
        try{
                java.util.Vector row = (java.util.Vector)DBManager.sp_query("{ call sp_get_vroom_participant(?,?) }", pArgs,VROOM_PARTICIPANT_TABLE_MODEL);
                if(row.size()>0)
                    return (Participant)row.get(0);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }


    public static Participant getParticipant(String secureToken){

        Object[] pArgs = {secureToken};
        try{
                java.util.Vector row = (java.util.Vector)DBManager.sp_query("{ call sp_get_participant(?) }", pArgs,VROOM_PARTICIPANT_TABLE_MODEL);
                if(row.size()>0)
                    return (Participant)row.get(0);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

    public static void getReservationParticipants(Room reservation){
        Object[] pArgs = {reservation.getId()};
        try{
                //System.out.println("getting participants for id:"+reservation.getId());
                java.util.Vector rows = (java.util.Vector)DBManager.sp_query("{ call sp_get_vroom_participants(?) }", pArgs,VROOM_PARTICIPANT_TABLE_MODEL);
                reservation.setParticipants(rows);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static java.util.Vector<Participant> getParticipants(int roomId){
        Object[] pArgs = {roomId};
        try{
                return (java.util.Vector<Participant>)DBManager.sp_query("{ call sp_get_vroom_participants(?) }", pArgs,VROOM_PARTICIPANT_TABLE_MODEL);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }****/
}
