/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;
import com.feezixlabs.bean.Room;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class RoomDAO {
    static Logger logger = Logger.getLogger(RoomDAO.class.getName());

    public static Room addRoom(String userName,Room room){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Room> h = new BeanHandler(Room.class);
            return run.query("{call sp_add_room(?,?)}", h,userName, room.getTitle());
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }
    public static void updateRoomName(Room room){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
           run.update("call sp_update_room_title(?,?,?)",room.getUserId(),room.getId(),room.getTitle());
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }
    public static void updateRoomAccess(String userName,Room room){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
           run.update("call sp_update_room_access(?,?,?)",userName,room.getId(),room.getAccessControl());
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }    
    
    public static String updateRoomAccessCode(String userName,Room room){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            
           ResultSetHandler h = new ScalarHandler("access_code");
           return (String)run.query("call sp_update_room_access_code(?,?)",h,userName,room.getId());
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return "";
    }     
    
    public static java.util.List<Room> getRooms(String userName){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Room> h = new BeanListHandler(Room.class);
            Object[] args = {userName};
            return (java.util.List<Room>)run.query("{call sp_get_rooms(?)}", h,args);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static java.util.List<Room> getRoomsOwnedBy(String userName){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Room> h = new BeanListHandler(Room.class);
            Object[] args = {userName};
            return (java.util.List<Room>)run.query("{call sp_get_rooms_owned_by(?)}", h,args);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static Room getRoom(String userName,int roomId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Room> h = new BeanHandler(Room.class);
            Object[] args = {userName,roomId};
            return (Room)run.query("{call sp_get_room(?,?)}", h,args);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static Room getRoomExt(int roomId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Room> h = new BeanHandler(Room.class);
            Object[] args = {roomId};
            return (Room)run.query("{call sp_get_room_ext(?)}", h,args);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }    
    
    
    public static void deleteRoom(Room room){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            //run.update("call sp_delete_user(?)",user.getUserName());
        }
        catch(java.lang.Exception ex) {

        }
    }
}
