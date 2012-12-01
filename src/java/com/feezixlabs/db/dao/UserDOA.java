/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;
import com.feezixlabs.bean.User;
import com.feezixlabs.bean.UserSettings;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class UserDOA {
    static Logger logger = Logger.getLogger(UserDOA.class.getName());
    public static User addUser(User user){

        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<User> h = new BeanHandler(User.class);
            Object[] pArgs = {user.getUserName(),user.getName(),user.getRole()};
            return run.query("{call sp_add_user(?,?,?)}", h,pArgs);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }
    public static void updateUser(User user){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("call sp_update_user(?,?)",user.getUserName(),user.getPassWord());
        }
        catch(java.lang.Exception ex) {
           logger.error("",ex);
        }
    }

    public static void updateUserFullName(User user){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("call sp_update_user_fullname(?,?)",user.getUserName(),user.getName());
        }
        catch(java.lang.Exception ex) {
           logger.error("",ex);
        }
    }

    public static void updateUserPassword(User user){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("call sp_update_user_password(?,?)",user.getUserName(),user.getPassWord());
        }
        catch(java.lang.Exception ex) {
           logger.error("",ex);
        }
    }

    
    public static boolean updateUserEmail(String userName,String emailAddress){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("call sp_update_user_email(?,?)",userName,emailAddress);
            return true;
        }
        catch(java.lang.Exception ex) {
           logger.error("",ex);
        }return false;
    }    
    
    public static User getUser(String emailAddress){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<User> h = new BeanHandler(User.class);

            return run.query("call sp_get_user(?)", h,emailAddress);
        }
        catch(java.lang.Exception ex) {
           logger.error("",ex);
        }return null;
    }
    public static User getUserById(int userId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<User> h = new BeanHandler(User.class);

            return run.query("call sp_get_user_by_id(?)", h,userId);
        }
        catch(java.lang.Exception ex) {
           logger.error("",ex);
        }return null;
    }

    public static java.util.List<User> getUsers(int start,int pagesize,String filter){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<User> h = new BeanListHandler(User.class);
            Object[] pArgs = {start,pagesize,filter};
            return (java.util.List<User>)run.query("call sp_get_users(?,?,?)", h,pArgs);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }
    
    public static java.util.List<User> getAccountsReceivable(){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<User> h = new BeanListHandler(User.class);            
            return (java.util.List<User>)run.query("call sp_get_accounts_receivable()", h);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }    
    
    public static java.util.List<String> getUserRoles(int userId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {

            ResultSetHandler h = new ColumnListHandler();

            return (java.util.List<String>)run.query("call sp_get_user_roles(?)", h,userId);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }
    public static java.util.List<String> getRoles(){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {

            ResultSetHandler h = new ColumnListHandler();

            return (java.util.List<String>)run.query("call sp_get_roles()", h);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }
    public static void addUserToRole(int userId,String role){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            Object[] args = {userId,role};
            run.update("call sp_add_user_to_role(?,?)",args);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }
    public static void delUserFromRole(int userId,String role){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            Object[] args = {userId,role};
            run.update("call sp_del_user_from_role(?,?)",args);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }

    public static int getUserCount(String filter){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler h = new ScalarHandler("count");

            return ((Long)run.query("call sp_get_user_count(?)", h,filter)).intValue();
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return 0;
    }


    public static int getUserId(String userName){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler h = new ScalarHandler("user_id");

            return (Integer)run.query("call sp_get_user_id(?)", h,userName);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return 0;
    }

    public static boolean hasAppletActionRights(String userName,int appletId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler h = new ScalarHandler("count");
            return (Integer)run.query("call sp_has_applet_access(?,?)", h,userName,appletId)>0;
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return false;
    }

    public static void deleteUser(String userName){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("call sp_delete_user(?)",userName);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }



    public static void addUserSettings(String userName,UserSettings userSettings){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<UserSettings> h = new BeanHandler(UserSettings.class);
            Object[] pArgs = {userName,userSettings.getDevToxonomy()};
            run.update("{call sp_add_user_settings(?,?)}", h,pArgs);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }
    public static void updateUserSettings(String userName,UserSettings userSettings){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("call sp_update_user_settings(?,?)",userName,userSettings.getDevToxonomy());
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }
    public static UserSettings getUserSettings(String emailAddress){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<UserSettings> h = new BeanHandler(UserSettings.class);

            return run.query("call sp_get_user_settings(?)", h,emailAddress);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }
    
    public static void updateStatus(String userName, String status){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_update_user_status(?,?) }", userName,status);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }    
}
