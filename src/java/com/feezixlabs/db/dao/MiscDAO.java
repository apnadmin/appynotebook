/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.db.dao;

import org.apache.commons.dbutils.*;
import org.apache.commons.dbutils.handlers.*;

import com.feezixlabs.bean.TextData;
import com.feezixlabs.bean.Feature;
import com.feezixlabs.bean.FeatureUsage;
import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class MiscDAO {
    static Logger logger = Logger.getLogger(MiscDAO.class.getName());
    public static TextData getTextData(String id){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {id};
        try{
                ResultSetHandler<TextData> h = new BeanHandler(TextData.class);
                return (TextData)run.query("{ call sp_get_text_data(?) }",h, pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

   public static void setTextData(String id,String data){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        Object[] pArgs = {id,data};
        try{
            run.update("{ call sp_set_text_data(?,?) }", pArgs);
        }catch(Exception ex){
            logger.error("",ex);
        }
   }

    public static java.util.List<Feature> getFeatureMatrix(){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
                ResultSetHandler<Feature> h = new BeanListHandler(Feature.class);
                return (java.util.List<Feature>)run.query("{call sp_get_feature_matrix() }",h);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

    public static Feature getFeatureMatrixEntry(String name){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
                ResultSetHandler<Feature> h = new BeanListHandler(Feature.class);
                java.util.List<Feature> matrix =  (java.util.List<Feature>)run.query("{call sp_get_feature_matrix_entry(?) }",h,name);
                if(matrix.size()>0)return matrix.get(0);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

    public static FeatureUsage getFeatureUsage(String userName, int featureId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
                ResultSetHandler<FeatureUsage> h = new BeanListHandler(FeatureUsage.class);
                java.util.List<FeatureUsage> matrix =  (java.util.List<FeatureUsage>)run.query("{call sp_get_feature_usage(?,?) }",h,userName,featureId);
                if(matrix.size()>0)return matrix.get(0);
        }catch(Exception ex){
            logger.error("",ex);
        }return null;
    }

    public static void updateFeatureUsage(String userName, int featureId,String usage){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_update_feature_usage(?,?,?) }", userName,featureId,usage);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void upgradeAccount(String userName, String plan,String stripeCustomerId,String invoiceId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_upgrade_account(?,?,?,?) }", userName,plan,stripeCustomerId,invoiceId);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void updateStripeCustomerId(String userName, String stripeCustomerId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_update_stripe_customer_id(?,?) }", userName,stripeCustomerId);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void updateStripeInvoiceId(String userName, String invoiceId){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_update_stripe_invoice_id(?,?) }", userName,invoiceId);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void updatePlan(String userName, String plan){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_update_plan(?,?) }", userName,plan);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void updatePlanStatus(String userName, String planStatus){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_update_plan_status(?,?) }", userName,planStatus);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static void updateTeamSize(String userName, int teamSize){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_update_team_size(?,?) }", userName,teamSize);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }

    public static int getDaysToNextBillingCycle(String userName){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler h = new ScalarHandler("days");

            return ((Integer)run.query("{call sp_get_days_to_next_billing_cycle(?)}", h,userName)).intValue();
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return 0;
    }
    
    public static void addAccountSignUp(String serviceDomain, 
                                        String fullName,
                                        String emailAddress,
                                        String phone,
                                        String organizationName,
                                        String serviceRegion,
                                        String servicePlan,
                                        String paymentType,
                                        String paymentPlan,
                                        String fee,
                                        String stripeCustomerId,
                                        String stripeToken){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try{
            run.update("{ call sp_add_account_signup(?,?,?,?,?,?,?,?,?,?,?,?) }", serviceDomain,fullName,emailAddress,phone,organizationName,serviceRegion,servicePlan,paymentType,paymentPlan,fee,stripeCustomerId,stripeToken);
        }catch(Exception ex){
            logger.error("",ex);
        }
    }
    
    public static int getAccountSignUp(String domain){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler h = new ScalarHandler("account");
            return ((Integer)run.query("{call sp_get_account_signup(?)}", h,domain)).intValue();
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return 0;
    }    
    
    public static String getUUID(int length){
        QueryRunner run = com.feezixlabs.db.DBManager.getDataSource();
        try
        {
            ResultSetHandler h = new ScalarHandler("uuid");
            return ((String)run.query("{call sp_get_uuid(?)}", h,length));
        }
        catch(java.lang.Exception ex) {
            logger.error("",ex);
        }return "";
    }      
}
