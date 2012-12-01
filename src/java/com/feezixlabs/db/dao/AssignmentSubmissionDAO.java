/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;
import com.feezixlabs.bean.AssignmentSubmission;
import org.apache.log4j.Logger;
import java.util.Date;
/**
 *
 * @author bitlooter
 */
public class AssignmentSubmissionDAO {
    static Logger logger = Logger.getLogger(AssignmentSubmissionDAO.class.getName());
    public static void addAssignmentSubmission(String userName,int roomId,int assignmentId,int contextId,int srcContextId,int srcPadId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_add_assignment_submission(?,?,?,?,?,?)}",userName,roomId,assignmentId,contextId,srcContextId,srcPadId);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }
    public static void updateAssignmentSubmission(String userName,int roomId,int id,String name,Date openDate,Date closeDate){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_update_assignment(?,?,?,?,?,?)}",userName,roomId,id,name,openDate,closeDate);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }
    public static AssignmentSubmission getAssignmentSubmission(String userName,int roomId,int srcContextId,int srcPadId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<AssignmentSubmission> h = new BeanListHandler(AssignmentSubmission.class);

            java.util.List<AssignmentSubmission> results = (java.util.List<AssignmentSubmission>)run.query("{call sp_get_assignment_submission(?,?,?,?)}", h,userName,roomId,srcContextId,srcPadId);
            if(results.size()>0)return results.get(0);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static java.util.List<AssignmentSubmission> getAssignmentSubmittedFromSource(String userName,int roomId,int srcContextId,int srcPadId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<AssignmentSubmission> h = new BeanListHandler(AssignmentSubmission.class);

            /*java.util.List<AssignmentSubmission> results = */ return(java.util.List<AssignmentSubmission>)run.query("{call sp_get_assignment_submission_from_source(?,?,?,?)}", h,userName,roomId,srcContextId,srcPadId);
            //if(results.size()>0)return results.get(0);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static java.util.List<AssignmentSubmission> getAssignmentSubmissions(String userName,int roomId,int assignmentId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler<AssignmentSubmission> h = new BeanListHandler(AssignmentSubmission.class);

            return (java.util.List<AssignmentSubmission>)run.query("{call sp_get_assignment_submissions(?,?,?)}", h,userName,roomId,assignmentId);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return null;
    }

    public static void deleteAssignmentSubmission(String userName,int roomId,int assignmentId,int contextId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            run.update("{call sp_delete_assignment_submission(?,?,?,?)}",userName,roomId,assignmentId,contextId);
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }
    }
}
