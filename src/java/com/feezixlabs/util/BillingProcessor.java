/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.feezixlabs.util;

import org.apache.log4j.Logger;

/**
 *
 * @author bitlooter
 */
public class BillingProcessor extends Thread{
    static Logger           logger                    = Logger.getLogger(BillingProcessor.class.getName());
    static final int        MILLISECONDS_PER_DAY      = 86400000;    
    public static boolean   kill                      = false;
    public static boolean   processing                = false;
    
    @Override
    public void run(){
        while(true){
            try{
                
                if(kill)return;                
                processing = true;
                
                java.util.List<com.feezixlabs.bean.User> users = com.feezixlabs.db.dao.UserDOA.getAccountsReceivable();
                logger.info("Running accounts receivable check."+users.size()+" accounts will be checked.");
                com.feezixlabs.bean.Feature feature = com.feezixlabs.db.dao.MiscDAO.getFeatureMatrixEntry("price");
                double price = 0;
                
                for(com.feezixlabs.bean.User user:users){
                    
                    String plan = user.getPlan();
                    if(user.getPlanStatus().compareTo("active") == 0 || user.getPlanStatus().compareTo("downgrade-to-basic-for-nonpayment") == 0){
                        if(plan.compareTo("individual") == 0){
                            price = Double.parseDouble(feature.getIndividualPlanLimit());
                        }
                        else
                        if(plan.compareTo("team") == 0){
                            price = Double.parseDouble(feature.getTeamPlanLimit())*user.getTeamSize();
                        }
                    }
                    else
                    if(user.getPlanStatus().startsWith("downgrade-to-team")){
                        int newTeamSize = Integer.parseInt(user.getPlanStatus().split("\\(")[1].split("\\)")[0]);
                        com.feezixlabs.db.dao.MiscDAO.updateTeamSize(user.getUserName(), newTeamSize);
                        price = Double.parseDouble(feature.getTeamPlanLimit())*newTeamSize;
                    }
                    else
                    if(user.getPlanStatus().compareTo("downgrade-to-individual") == 0){
                        com.feezixlabs.db.dao.MiscDAO.updatePlan(user.getUserName(), "individual");   
                        plan = "individual";
                        price = Double.parseDouble(feature.getIndividualPlanLimit());
                    }
                    else
                    if(user.getPlanStatus().compareTo("downgrade-to-basic") == 0){
                        com.feezixlabs.db.dao.MiscDAO.updatePlan(user.getUserName(), "basic"); 
                        plan = "basic";
                    }
                    
                    com.feezixlabs.db.dao.MiscDAO.updatePlanStatus(user.getUserName(), "active");
                    
                    if(price>0){
                        java.util.HashMap<String,Object> chargeParams = new java.util.HashMap<String, Object>();
                        chargeParams.put("description", "APPYNote service charge for '"+plan+"' plan");
                        chargeParams.put("currency", "usd");
                        chargeParams.put("customer", user.getStripeCustomerId());
                        chargeParams.put("amount", (int)price*100);
                        try{
                            com.stripe.model.Charge response = com.stripe.model.Charge.create(chargeParams);                            
                            com.feezixlabs.db.dao.MiscDAO.updateStripeInvoiceId(user.getUserName(), response.getId());                            
                        }catch(com.stripe.exception.StripeException ex){
                            logger.error("",ex);
                            if(com.feezixlabs.db.dao.MiscDAO.getDaysToNextBillingCycle(user.getUserName()) > -14){
                                com.feezixlabs.db.dao.MiscDAO.updatePlanStatus(user.getUserName(), "downgrade-to-basic-for-nonpayment");
                                String notification = "Hi "+user.getName().split(" ")[0]+", <br/> we tried billing your current card but failed, please update your payment information. <br/> <b>We'll try again, have a nice day!</b><br/> Exception:<i>"+ex.getMessage()+"</i>";
                                com.feezixlabs.util.Utility.sendEmail(user.getEmailAddress(), "Billing Error",notification, true, com.feezixlabs.util.ConfigUtil.app_notifier, com.feezixlabs.util.ConfigUtil.app_notifier, com.feezixlabs.util.ConfigUtil.app_notifier_password);
                            }else{
                                //downgrade takes effect for non payment
                                com.feezixlabs.db.dao.MiscDAO.updatePlan(user.getUserName(), "basic"); 
                                com.feezixlabs.db.dao.MiscDAO.updatePlanStatus(user.getUserName(), "active");
                            }
                        }
                    }
                }
                
                processing = false;
                if(kill)return;
                
                Thread.sleep(86400000l);//repeat every day 86400000l
            }
            catch(Exception e){
                processing = false;
                if(kill)return;
                logger.error("",e);
            }
        }        
    }    
}
