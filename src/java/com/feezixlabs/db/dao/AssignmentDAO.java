/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;
import com.feezixlabs.bean.Assignment;
import org.apache.log4j.Logger;

/**
 *
 * @author bitlooter
 */
public class AssignmentDAO {
    static Logger logger = Logger.getLogger(AssignmentDAO.class.getName());
    public static int addAssignment(String userName,int roomId,String name,String openDate,String closeDate,String timeZone,int notification,String allowVersioning,int versioningLimit,String firstReminderDate,int repeatInterval,int repeatCount){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler h = new ScalarHandler("assignment_id");
            return (Integer)run.query("{call sp_add_assignment(?,?,?,?,?,?,?,?,?,?,?,?)}",h,userName,roomId,name,openDate,closeDate,timeZone,notification,allowVersioning,versioningLimit,firstReminderDate,repeatInterval,repeatCount);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return 0;
    }
    public static void updateAssignment(String userName,int roomId,int id,String name,String openDate,String closeDate,String timeZone,String allowVersioning,int versioningLimit,String firstReminderDate,int repeatInterval,int repeatCount){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_update_assignment(?,?,?,?,?,?,?,?,?,?,?,?)}",userName,roomId,id,name,openDate,closeDate,timeZone,allowVersioning,versioningLimit,firstReminderDate,repeatInterval,repeatCount);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }

    public static void archiveAssignment(String userName,int roomId,int id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_archive_assignment(?,?,?)}",userName,roomId,id);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }
    public static Assignment getAssignment(String userName,int roomId,int id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Assignment> h = new BeanListHandler(Assignment.class);

            return ((java.util.List<Assignment>)run.query("{call sp_get_assignment(?,?,?)}", h,userName,roomId,id)).get(0);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static Assignment getAssignmentIfOpen(String userName,int roomId,int id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Assignment> h = new BeanListHandler(Assignment.class);

            return ((java.util.List<Assignment>)run.query("{call sp_get_assignment_if_open(?,?,?)}", h,userName,roomId,id)).get(0);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static java.util.List<Assignment> getAssignments(String userName,int roomId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Assignment> h = new BeanListHandler(Assignment.class);

            return (java.util.List<Assignment>)run.query("{call sp_get_assignments(?,?)}", h,userName,roomId);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }
    public static java.util.List<Assignment> getAssignmentsWithReminder(){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Assignment> h = new BeanListHandler(Assignment.class);

            return (java.util.List<Assignment>)run.query("{call sp_get_assignments_with_reminder()}", h);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }
    
    public static void updateAssignmentsWithReminder(){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_update_assignments_with_reminder()}");
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }    
    
    public static java.util.List<Assignment> getOpenAssignments(String userName,int roomId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<Assignment> h = new BeanListHandler(Assignment.class);

            return (java.util.List<Assignment>)run.query("{call sp_get_open_assignments(?,?)}", h,userName,roomId);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }


    public static void deleteAssignment(String userName,int roomId,int id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_del_assignment(?,?,?)}",userName,roomId,id);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }
}
