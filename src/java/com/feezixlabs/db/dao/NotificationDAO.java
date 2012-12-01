/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;
import com.feezixlabs.bean.Notification;
import org.apache.log4j.Logger;

/**
 *
 * @author bitlooter
 */
public class NotificationDAO {
    static Logger logger = Logger.getLogger(NotificationDAO.class.getName());
    public static int addNotification(String startTime,String endTime,String timeZone,long repeatInterval,int repeatIntervalCount,String variableDefinitions,String message,String messagingMedium){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler h = new ScalarHandler("notification_id");
            return (Integer)run.query("{call sp_add_notification(?,?,?,?,?,?,?,?)}",h,startTime,endTime,timeZone,repeatInterval,repeatIntervalCount,variableDefinitions,message,messagingMedium);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return 0;
    } 

    public static void updateNotification(int id,String startTime,String endTime,String timeZone,long repeatInterval,int repeatIntervalCount){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_update_notification(?,?,?,?,?,?)}",id,startTime,endTime,timeZone,repeatInterval,repeatIntervalCount);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }

    public static java.util.List<Notification> pollNotifications(){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Notification> h = new BeanListHandler(Notification.class);

            return (java.util.List<Notification>)run.query("{call sp_poll_notifications()}", h);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static Notification getNotification(int id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Notification> h = new BeanListHandler(Notification.class);

            return ((java.util.List<Notification>)run.query("{call sp_get_notification(?)}", h,id)).get(0);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }
}
