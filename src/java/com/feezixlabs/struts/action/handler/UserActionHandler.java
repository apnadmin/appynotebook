/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.struts.action.handler;

import javax.servlet.http.HttpServletRequest;
import com.feezixlabs.util.ConfigUtil;
import com.feezixlabs.bean.User;
import com.feezixlabs.db.dao.UserDOA;
import com.stripe.exception.StripeException;
import java.util.HashMap;
import org.apache.log4j.Logger;

/**
 *
 * @author bitlooter
 */
public class UserActionHandler {
    static Logger logger = Logger.getLogger(UserActionHandler.class.getName());
    public static final String ID_HASHER = "b4c646f2-5f09-11e1-b875-0019b958a435";


    public static com.feezixlabs.bean.User createNewUser(String name,String emailAddress,String roomLabel){

          com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(emailAddress);
          if(user != null)return user;

          //check to see if account creation is restricted to only certain domains
          if(!com.feezixlabs.util.Utility.passDomainRestriction(emailAddress))
              return null;


          user = new com.feezixlabs.bean.User();
          user.setName(name);
          user.setEmailAddress(emailAddress);
          user.setUserName(emailAddress);
          user.setRole("participant");
          user = com.feezixlabs.db.dao.UserDOA.addUser(user);

          String roomLabel1 = roomLabel != null && roomLabel.length()>0?roomLabel:"Welcome";

          if(user != null){

              String[] roles = null;
              //see if there any default roles to assign to this user
              if(com.feezixlabs.util.ConfigUtil.default_roles != null){
                  roles = com.feezixlabs.util.ConfigUtil.default_roles.split(",");
                  for(int i=0;i<roles.length;i++){
                      com.feezixlabs.db.dao.UserDOA.addUserToRole(user.getId(),roles[i]);
                  }
              }


              com.feezixlabs.bean.Room room = new com.feezixlabs.bean.Room();
              room.setTitle(roomLabel1);
              //room.setUserId(user.getId());
              room = com.feezixlabs.db.dao.RoomDAO.addRoom(user.getUserName(),room);


              if(room != null){
                  //creat default book if one has been assigned
                  String welcomeContextData = com.feezixlabs.db.dao.MiscDAO.getTextData("welcome-context").getData();
                  if(welcomeContextData.length()!= 0){
                      String[] key = welcomeContextData.split(",");
                      if(key.length == 3){
                            com.feezixlabs.bean.User superUser = com.feezixlabs.db.dao.UserDOA.getUser(key[0]);
                            com.feezixlabs.bean.Context cntx = com.feezixlabs.db.dao.ContextDAO.getContext(key[0],new Integer(key[1]),new Integer(key[2]),superUser.getId());
                            if(cntx != null){
                                com.feezixlabs.struts.action.handler.ContextActionHandler.distributeContextTo(new Integer(key[1]),new Integer(key[2]), key[0],room.getId(),user.getUserName());
                            }
                      }
                  }

                  /*
                  com.feezixlabs.bean.Participant participant = new com.feezixlabs.bean.Participant();
                  participant.setRoomId(room.getId());
                  participant.setUserId(user.getId());
                  com.feezixlabs.db.dao.ParticipantDAO.addParticipant(user.getUserName(),room.getId(),user.getId(),"room_creator");
                  room.setCreator(participant);
                  */

                  //send notification email
                  String notification = com.feezixlabs.util.ConfigUtil.account_creation_notification_email.replaceAll("\\{installation_name\\}", com.feezixlabs.util.ConfigUtil.installation_name).replaceAll("\\{participant_name\\}", user.getName()).replaceAll("\\{username\\}", user.getEmailAddress().toLowerCase()).replaceAll("\\{passwd\\}", user.getPassWord()).replaceAll("\\{installation_login_url\\}",com.feezixlabs.util.ConfigUtil.installation_login_url+room.getId());
                  com.feezixlabs.util.Utility.sendEmail(user.getEmailAddress(), com.feezixlabs.util.ConfigUtil.installation_name+" Invite",notification, true, com.feezixlabs.util.ConfigUtil.invite_notifier, com.feezixlabs.util.ConfigUtil.account_create_notifier, com.feezixlabs.util.ConfigUtil.account_create_notifier_password);
                  //send notification
                  //String notification = com.feezixlabs.util.ConfigUtil.account_creation_notification_email.replaceAll("\\{room\\}", room.getTitle()).replaceAll("\\{participant_name\\}", user.getFirstName()).replaceAll("\\{username\\}", user.getEmailAddress().toLowerCase()).replaceAll("\\{passwd\\}", user.getPassWord()).replaceAll("\\{installation_login_url\\}",com.feezixlabs.util.ConfigUtil.installation_login_url+room.getId());
                  //com.feezixlabs.util.Utility.sendEmail(user.getEmailAddress(), com.feezixlabs.util.ConfigUtil.installation_name+" Invite",notification, true, com.feezixlabs.util.ConfigUtil.invite_notifier, com.feezixlabs.util.ConfigUtil.invite_notifier, com.feezixlabs.util.ConfigUtil.invite_notifier_password);
              }
              
              //check to see if we need to load sample applets if this user is a developer
              if(com.feezixlabs.util.ConfigUtil.load_sample_applets && roles != null){
                 
                 for(int i=0;i<roles.length;i++){
                     if(roles[i].compareToIgnoreCase("developer") == 0){
                         loadDevSamples(user.getUserName());
                         break;
                     }
                 }
              }
          }else{
            //return error message
              //System.out.println("error adding user");
          }
          return user;
    }

    public static String getPlanInfo(HttpServletRequest request){
        com.feezixlabs.bean.Feature feature = com.feezixlabs.db.dao.MiscDAO.getFeatureMatrixEntry("price");
        java.util.List<com.feezixlabs.bean.Room> rooms = com.feezixlabs.db.dao.RoomDAO.getRooms(request.getUserPrincipal().getName());
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());

        java.util.Calendar cal = new java.util.GregorianCalendar();
        cal.setTime(new java.util.Date());
        cal.add(java.util.Calendar.DATE,com.feezixlabs.db.dao.MiscDAO.getDaysToNextBillingCycle(request.getUserPrincipal().getName()));
        java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("MM/dd/yyyy");
        
        StringBuilder buf = new StringBuilder();
        buf.append("{");
        buf.append("\"current_plan\":\""+user.getPlan()+"\",");
        buf.append("\"current_plan_status\":\""+user.getPlanStatus()+"\",");
        buf.append("\"basic_plan_price\":\""+feature.getBasicPlanLimit()+"\",");
        buf.append("\"individual_plan_price\":\""+feature.getIndividualPlanLimit()+"\",");
        buf.append("\"team_plan_price\":\""+feature.getTeamPlanLimit()+"\",");
        buf.append("\"current_team_size\":\""+user.getTeamSize()+"\",");
        buf.append("\"next_billing_cycle\":\""+format.format(cal.getTime())+"\",");
        buf.append("\"rooms\":[");


        boolean bfirst = true;
        for(com.feezixlabs.bean.Room room:rooms){
            buf.append((!bfirst?",":"")+"{\"id\":\""+room.getId()+"\",\"title\":\""+room.getTitle().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\"}");
            bfirst = false;
        }
        buf.append("]");

        if(user.getStripeCustomerId() != null){
            try{
                com.stripe.model.Customer customer = com.stripe.model.Customer.retrieve(user.getStripeCustomerId());
                buf.append(",\"card_info\":{");
                buf.append("\"last4\":\""+customer.getActiveCard().getLast4()+"\",");
                buf.append("\"expr_month\":\""+customer.getActiveCard().getExpMonth()+"\",");
                buf.append("\"expr_yr\":\""+customer.getActiveCard().getExpYear()+"\",");
                buf.append("\"type\":\""+customer.getActiveCard().getType()+"\"");
                buf.append("}");
            }catch(com.stripe.exception.StripeException ex){

            }
        }
        buf.append("}");
        return buf.toString();
    }

    public static String cancelCurrentPlan(HttpServletRequest request){
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        if(user.getPlan() != null  && user.getPlan().compareTo("basic") != 0)
            com.feezixlabs.db.dao.MiscDAO.updatePlanStatus(request.getUserPrincipal().getName(), "pending-downgrade-to-basic");
        return "{\"status\":\"success\"}";
    }
    
    public static String grantDeveloperRoleToUser(HttpServletRequest request){
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        
        //if(request.isUserInRole("sysadmin")){
        //    com.feezixlabs.db.dao.UserDOA.addUserToRole(user.getId(), role);
        //}
        com.feezixlabs.db.dao.UserDOA.addUserToRole(user.getId(), "developer");
        return "{\"status\":\"success\"}";
    }    
    
    public static String updatePaymentInformation(HttpServletRequest request){
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        String token = request.getParameter("token");
        if(token != null){
            java.util.HashMap<String,Object> customerParams = new java.util.HashMap<String, Object>();
            customerParams.put("card",token);
            customerParams.put("description", user.getId());
            try{
                com.stripe.model.Customer customer = com.stripe.model.Customer.create(customerParams);
                String customerId = customer.getId();
                com.feezixlabs.db.dao.MiscDAO.updateStripeCustomerId(request.getUserPrincipal().getName(), customerId);
            }catch(com.stripe.exception.StripeException ex){
                logger.error("",ex);
                return "{\"status\":\"failure\",\"msg\":\"An unexpected error occured processing credit card. exception:"+ex.getMessage()+"\"}";
            }
        }return "{\"status\":\"success\",\"msg\":\"Your payment information was successfully updated.\"}";
    }

    public static String changeToIndividualPlan(HttpServletRequest request){
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.Feature feature = com.feezixlabs.db.dao.MiscDAO.getFeatureMatrixEntry("price");
        
        String customerId = user.getStripeCustomerId();
        String token = request.getParameter("token");
        if(token != null){
            java.util.HashMap<String,Object> customerParams = new java.util.HashMap<String, Object>();
            customerParams.put("card",token);
            customerParams.put("description", user.getId());
            try{
                com.stripe.model.Customer customer = com.stripe.model.Customer.create(customerParams);
                customerId = customer.getId();
                com.feezixlabs.db.dao.MiscDAO.updateStripeCustomerId(request.getUserPrincipal().getName(), customerId);
            }catch(com.stripe.exception.StripeException ex){
                logger.error("",ex);
                return "{\"status\":\"failure\",\"msg\":\"An unexpected error occured processing credit card. exception:"+ex.getMessage()+"\"}";
            }
        }  
        
        double price  = 0;
        double individual_plan_price            = Double.parseDouble(feature.getIndividualPlanLimit());
        
        if(user.getPlan() != null  && user.getPlan().compareTo("individual") == 0/* && user.getPlanStatus().compareTo("active") == 0*/){
            com.feezixlabs.db.dao.MiscDAO.updatePlanStatus(request.getUserPrincipal().getName(), "active");
            return "{\"status\":\"success\",\"msg\":\"Your 'individual' plan has been reinstated to active status.\"}";        
            //return "{\"status\":\"failure\",\"msg\":\"You already have an active 'individual' plan.\"}";
        }
        else
        if(user.getPlan() != null && user.getPlan().compareTo("basic") == 0/*  && (user.getPlan().compareTo("team") != 0 || user.getPlanStatus().compareTo("active") != 0)*/){
            price = individual_plan_price;
            //return "{\"status\":\"failure\",\"msg\":\"Please go to your profile and upgrade your account.\"}";
        }
        else
        if(user.getPlan() != null && user.getPlan().compareTo("team") == 0){
             com.feezixlabs.db.dao.MiscDAO.updatePlanStatus(request.getUserPrincipal().getName(), "pending-downgrade-to-individual");
             return "{\"status\":\"success\",\"msg\":\"Your plan downgrade from the 'team' plan to the 'individual' plan has been noted and would take effect at the start of your next billing cycle.\"}";
        }
        
        java.util.HashMap<String,Object> chargeParams = new java.util.HashMap<String, Object>();
        chargeParams.put("description", "APPYNote service charge for 'individual' plan");
        chargeParams.put("currency", "usd");
        chargeParams.put("customer", customerId);
        chargeParams.put("amount", (int)price*100);
        try{
            com.stripe.model.Charge response = com.stripe.model.Charge.create(chargeParams);
            com.feezixlabs.db.dao.MiscDAO.updatePlan(request.getUserPrincipal().getName(), "individual");
            com.feezixlabs.db.dao.MiscDAO.updatePlanStatus(request.getUserPrincipal().getName(), "active");
            com.feezixlabs.db.dao.MiscDAO.updateStripeInvoiceId(request.getUserPrincipal().getName(), response.getId());
            com.feezixlabs.db.dao.MiscDAO.updateTeamSize(request.getUserPrincipal().getName(), 0);
            return "{\"status\":\"success\",\"msg\":\"Your account has been upgraded to the 'individual' plan.\"}";
        }catch(com.stripe.exception.StripeException ex){
            logger.error("",ex);
            return "{\"status\":\"failure\",\"msg\":\"An unexpected error occured. Exception:"+ex.getMessage()+"\"}";
        }
    }

    public static String changeToTeamPlan(HttpServletRequest request){
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.Feature feature = com.feezixlabs.db.dao.MiscDAO.getFeatureMatrixEntry("price");


        int teamSize = Integer.parseInt(request.getParameter("teamSize"));
        String customerId = user.getStripeCustomerId();

        
        //if(user.getPlan() != null  && user.getPlan().compareTo("team") == 0/* && user.getPlanStatus().compareTo("active") == 0*/)
        //    return "{\"status\":\"failure\",\"msg\":\"You already have an active team plan.\"}";
        //else
        //if(user.getPlan() != null && user.getPlan().compareTo("basic") != 0  && (user.getPlan().compareTo("individual") != 0 || user.getPlanStatus().compareTo("active") != 0))
        //   return "{\"status\":\"failure\",\"msg\":\"Please go to your profile and upgrade your account.\"}";


        if(teamSize<2)
            return "{\"status\":\"failure\",\"msg\":\"Team size must be at least 2.\"}";
        
        double individual_plan_price            = Double.parseDouble(feature.getIndividualPlanLimit());
        double team_plan_price                  = Double.parseDouble(feature.getTeamPlanLimit());
        int    days_to_next_billing_cycle       = com.feezixlabs.db.dao.MiscDAO.getDaysToNextBillingCycle(request.getUserPrincipal().getName());
        double individual_plan_per_day_charge   = individual_plan_price/30;
        double team_plan_per_day_charge         = team_plan_price/30;
        double discount                         = 0;
        double price                            = 0;
        
        
        String token = request.getParameter("token");
        if(token != null){
            java.util.HashMap<String,Object> customerParams = new java.util.HashMap<String, Object>();
            customerParams.put("card",token);
            customerParams.put("description", user.getId());
            try{
                com.stripe.model.Customer customer = com.stripe.model.Customer.create(customerParams);
                customerId = customer.getId();
                com.feezixlabs.db.dao.MiscDAO.updateStripeCustomerId(request.getUserPrincipal().getName(), customerId);
            }catch(com.stripe.exception.StripeException ex){
                logger.error("",ex);
                return "{\"status\":\"failure\",\"msg\":\"An unexpected error occured processing credit card. exception:"+ex.getMessage()+"\"}";
            }
        }        
        
        
        if(user.getPlan() != null  && user.getPlan().compareTo("team") == 0){
            int teamdiff = teamSize-user.getTeamSize();
            
            if(teamdiff>0){//increase team size
                discount = ((30 - days_to_next_billing_cycle) * team_plan_per_day_charge)*teamdiff;
                price = Math.round((team_plan_price*teamdiff)-discount);
            }
            else
            if(teamdiff<0){//decrease team size, do nothing right now just update status                
                com.feezixlabs.db.dao.MiscDAO.updatePlanStatus(request.getUserPrincipal().getName(), "pending-downgrade-to-team("+teamdiff+")");
                return "{\"status\":\"success\",\"msg\":\"Your team size reduction has been noted and would take effect at the start of your next billing cycle.\"}";
            }
            else
            if(token == null)//no change in size or payment information just update status to active
            {
                com.feezixlabs.db.dao.MiscDAO.updatePlanStatus(request.getUserPrincipal().getName(), "active");
                return "{\"status\":\"success\",\"msg\":\"Your 'team' plan has been reinstated to active status.\"}";
            }
            else{
                return "{\"status\":\"success\",\"msg\":\"Your payment information was successfully updated.\"}";
            }
        }
        else
        if(user.getPlan() != null  && user.getPlan().compareTo("individual") == 0){
            discount = individual_plan_per_day_charge * days_to_next_billing_cycle;
            price = Math.round((team_plan_price*teamSize)-discount);
        }


        java.util.HashMap<String,Object> chargeParams = new java.util.HashMap<String, Object>();
        chargeParams.put("description", "APPYNote service charge for 'team' plan");
        chargeParams.put("currency", "usd");
        chargeParams.put("customer", customerId);
        chargeParams.put("amount", (int)price*100);
        try{
            com.stripe.model.Charge response = com.stripe.model.Charge.create(chargeParams);
            com.feezixlabs.db.dao.MiscDAO.updatePlan(request.getUserPrincipal().getName(), "team");
            com.feezixlabs.db.dao.MiscDAO.updatePlanStatus(request.getUserPrincipal().getName(), "active");
            com.feezixlabs.db.dao.MiscDAO.updateStripeInvoiceId(request.getUserPrincipal().getName(), response.getId());
            com.feezixlabs.db.dao.MiscDAO.updateTeamSize(request.getUserPrincipal().getName(), teamSize);
            return "{\"status\":\"success\",\"msg\":\"Your account has been upgraded to 'team' plan.\"}";
        }catch(com.stripe.exception.StripeException ex){
            logger.error("",ex);
            return "{\"status\":\"failure\",\"msg\":\"An unexpected error occured processing payment. exception:"+ex.getMessage()+"\"}";
        }
    }
    
    public static String upgradeAccount(HttpServletRequest request){
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.Feature feature = com.feezixlabs.db.dao.MiscDAO.getFeatureMatrixEntry("price");

        String plan  = request.getParameter("plan");
        String token = request.getParameter("token");
        int teamSize = 1;
        String customerId = user.getStripeCustomerId();

        if(user.getPlan() != null  /*&& user.getPlanStatus().compareTo("active") == 0*/ && user.getPlan().compareTo(plan) == 0)
            return "{\"status\":\"failure\",\"msg\":\"You already have an active '"+plan+"' plan.\"}";

        if(plan.compareTo("basic") != 0){

            if(customerId == null || token != null){
                java.util.HashMap<String,Object> customerParams = new java.util.HashMap<String, Object>();
                customerParams.put("card",token);
                customerParams.put("description", user.getId());
                try{
                    com.stripe.model.Customer customer = com.stripe.model.Customer.create(customerParams);
                    customerId = customer.getId();
                }catch(com.stripe.exception.StripeException ex){
                    logger.error("",ex);
                    return "{\"status\":\"failure\",\"msg\":\"An unexpected error occured processing credit card. exception:"+ex.getMessage()+"\"}";
                }
            }

            java.util.HashMap<String,Object> chargeParams = new java.util.HashMap<String, Object>();
            chargeParams.put("description", "APPYNote service charge for '"+plan+"' plan");
            chargeParams.put("currency", "usd");
            chargeParams.put("customer", customerId);

            double price = 0;
            if(plan.compareTo("individual") == 0){
                price = Double.parseDouble(feature.getIndividualPlanLimit());
            }
            else{
                teamSize = Integer.parseInt(request.getParameter("teamSize"));
                if(teamSize<2)
                    return "{\"status\":\"failure\",\"msg\":\"Team size must be at least 2.\"}";
                price = Double.parseDouble(feature.getTeamPlanLimit())*teamSize;
            }
            chargeParams.put("amount", (int)price*100);
            try{
                com.stripe.model.Charge response = com.stripe.model.Charge.create(chargeParams);
                com.feezixlabs.db.dao.MiscDAO.upgradeAccount(request.getUserPrincipal().getName(), plan, customerId, response.getId());
                com.feezixlabs.db.dao.MiscDAO.updateTeamSize(request.getUserPrincipal().getName(), teamSize);
                return "{\"status\":\"success\",\"msg\":\"Your account has been upgraded to '"+plan+"' plan.\"}";
            }catch(com.stripe.exception.StripeException ex){
                logger.error("",ex);
                return "{\"status\":\"failure\",\"msg\":\"An unexpected error occured processing payment. exception:"+ex.getMessage()+"\"}";
            }
        }else{
            return "{\"status\":\"failure\",\"msg\":\"The plan you attempted to upgrade to is not valid.\"}";
        }
    }

    public static void loadDevSamples(String userName){
         //first create the requisite category
         com.feezixlabs.bean.UserSettings us = new com.feezixlabs.bean.UserSettings();
         us.setDevToxonomy(com.feezixlabs.util.Utility.addCategory("default","Samples","sample.package", us.getDevToxonomy()));
         com.feezixlabs.db.dao.UserDOA.updateUserSettings(userName, us);

         String samplePackagePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/packages/system/samples";
         //import applets into sample category
         com.feezixlabs.struts.action.handler.WidgetResourceActionHandler.importAppletsFromPackage(userName,samplePackagePath,"sample.package");
    }

    public static com.feezixlabs.bean.User createNewUser(HttpServletRequest request){
          return createNewUser(request.getParameter("name"),
                               request.getParameter("emailAddress"),
                               request.getParameter("roomLabel"));
    }

    public static String sendUserPassword(HttpServletRequest request){
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getParameter("emailAddress"));
        if(user != null)
        {
          //get default room
          com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRooms(user.getEmailAddress()).get(0);

          //send notification email
          String notification = com.feezixlabs.util.ConfigUtil.account_login_recovery_notification_email.replaceAll("\\{participant_name\\}", user.getName()).replaceAll("\\{username\\}", user.getEmailAddress().toLowerCase()).replaceAll("\\{passwd\\}", user.getPassWord()).replaceAll("\\{installation_login_url\\}",com.feezixlabs.util.ConfigUtil.installation_login_url+room.getId());
          com.feezixlabs.util.Utility.sendEmail(user.getEmailAddress(), com.feezixlabs.util.ConfigUtil.installation_name+" Login Recovery",notification, true, com.feezixlabs.util.ConfigUtil.invite_notifier, com.feezixlabs.util.ConfigUtil.account_create_notifier, com.feezixlabs.util.ConfigUtil.account_create_notifier_password);
          return "{\"status\":\"success\"}";
        }return "{\"status\":\"failed\"}";
    }

    public static String addParticipant(HttpServletRequest request,String emailAddress,int roomId,boolean system){

            com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoomExt(roomId);
            int userId = com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName());
            
            //make sure any room limits are enforced
            if(com.feezixlabs.util.ConfigUtil.room_size_limit != -1){
                if(com.feezixlabs.util.ConfigUtil.room_size_limit<=com.feezixlabs.db.dao.ParticipantDAO.getParticipants(roomId).size())
                    return "{\"status\":\"failed\",\"msg\":\"Number of participants exceeds limit\"}";
            }
            
            //enforce plan limitation
            if(!request.isUserInRole("sysadmin") && !ConfigUtil.institutional_instance){
                String error = com.feezixlabs.util.FeatureAccessManager.checkTeamLimit(request.getUserPrincipal().getName(), emailAddress, roomId);
                if(error != null)return error;
            }
          

            if(room != null && (system || room.getUserId() == userId))//only room creator can add a participant
            {
                int participantId = com.feezixlabs.db.dao.UserDOA.getUserId(emailAddress);
                com.feezixlabs.db.dao.ParticipantDAO.addParticipant(request.getUserPrincipal().getName(),participantId,roomId,"participant");
                
                com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(emailAddress);
                String notification = com.feezixlabs.util.ConfigUtil.account_creation_via_invite_notification_email.replaceAll("\\{installation_name\\}", com.feezixlabs.util.ConfigUtil.installation_name).replaceAll("\\{participant_name\\}",user.getName()).replaceAll("\\{username\\}", user.getUserName().toLowerCase()).replaceAll("\\{passwd\\}", user.getPassWord())
                              .replaceAll("\\{installation_login_url\\}",com.feezixlabs.util.ConfigUtil.installation_login_url+room.getId())
                              .replaceAll("\\{room\\}",room.getTitle());

                com.feezixlabs.util.Utility.sendEmail(user.getEmailAddress(), com.feezixlabs.util.ConfigUtil.installation_name+" Invite",notification, true, com.feezixlabs.util.ConfigUtil.invite_notifier, com.feezixlabs.util.ConfigUtil.invite_notifier, com.feezixlabs.util.ConfigUtil.invite_notifier_password);
                return "{\"status\":\"success\",\"id\":"+participantId+"}";
            }return "{\"status\":\"failure\"}";
    }

    public static String deleteParticipant(HttpServletRequest request){
        int room_id = new Integer(request.getParameter("room_id"));
        com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), room_id);
        int userId = com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName());
        
        if(room != null && room.getUserId() == userId)//only room creator can delete a participant
        {
            int participantId = new Integer(request.getParameter("participant_id"));
            com.feezixlabs.db.dao.ParticipantDAO.deleteParticipant(request.getUserPrincipal().getName(), room_id,participantId);
            return "{status:'success'}";
        }return "{status:'failure'}";
    }



    public static String loadUsers(HttpServletRequest request){

        String replyMsg = "{\"status\":\"failed\"}";

        if(!request.isUserInRole("sysadmin") && !request.isUserInRole("educator"))return replyMsg;

        int clbSizelimit = 1000000;
        // Check that we have a file upload request
        boolean isMultipart = org.apache.commons.fileupload.servlet.ServletFileUpload.isMultipartContent(request);
        if(isMultipart){
            try{
                // Create a factory for disk-based file items
                org.apache.commons.fileupload.FileItemFactory factory = new org.apache.commons.fileupload.disk.DiskFileItemFactory();

                ((org.apache.commons.fileupload.disk.DiskFileItemFactory)factory).setSizeThreshold(clbSizelimit);

                // Create a new file upload handler
                org.apache.commons.fileupload.servlet.ServletFileUpload upload = new org.apache.commons.fileupload.servlet.ServletFileUpload(factory);

                // Parse the request
                java.util.List /* FileItem */ items = upload.parseRequest(request);

                org.apache.commons.fileupload.FileItem rsFile = null;

                java.util.Iterator iter = items.iterator();


                char delimiter = ',';
                char quote     = 0;
                int  skip      = 0;
                int  roomId    = 0;
                String userName = request.getUserPrincipal().getName();
                
                while (iter.hasNext()) {
                    org.apache.commons.fileupload.FileItem item = (org.apache.commons.fileupload.FileItem) iter.next();
                    if (item.isFormField()) {
                        if(item.getFieldName().compareToIgnoreCase("delimiter")==0 && item.getString().length()>0){
                           delimiter = item.getString().charAt(0);
                        }
                        else
                        if(item.getFieldName().compareToIgnoreCase("quote")==0 && item.getString().length()>0){
                            quote = item.getString().charAt(0);
                        }
                        else
                        if(item.getFieldName().compareToIgnoreCase("skip")==0 && item.getString().length()>0){
                            skip = new Integer(item.getString());
                        }
                        else
                        if(item.getFieldName().compareToIgnoreCase("room_id")==0 && item.getString().length()>0){
                            roomId = new Integer(item.getString());
                        }
                    } else {
                        rsFile = item;
                    }
                }
                
                String libraryBaseDir = com.feezixlabs.util.ConfigUtil.temp_upload_directory;
                String fileName = rsFile.getName();
                java.io.File file = new java.io.File(libraryBaseDir+"/"+fileName);
                rsFile.write(file);

                au.com.bytecode.opencsv.CSVReader reader = new au.com.bytecode.opencsv.CSVReader(new java.io.FileReader(file),delimiter,quote,skip);

                replyMsg =  "{status:'success'}";
                String [] nextLine;
                while ((nextLine = reader.readNext()) != null) {
                    // nextLine[] is an array of values from the line
                    //System.out.println(nextLine[0] +" "+ nextLine[1] +" "+ nextLine[2]);
                    com.feezixlabs.bean.User user = createNewUser(nextLine[0],nextLine[1],"Welcome");

                    //check to see if this is from a room
                    if(roomId != 0 && user!=null){
                        String response =  addParticipant(request,user.getEmailAddress(),roomId,false);
                        net.sf.json.JSONObject responseJSON = net.sf.json.JSONObject.fromObject(response);
                        if(responseJSON.getString("status").compareTo("success") != 0 && responseJSON.has("limit")){
                            replyMsg = response;break;
                        }
                    }
                }                
                file.delete();                
                request.setAttribute("replyMsg",replyMsg);
                request.setAttribute("users-loaded", "true");
            }
            catch(Exception ex){
                ex.printStackTrace();
            }
        }return replyMsg;
    }


    public static String deleteUser(HttpServletRequest request){
        if(!request.isUserInRole("sysadmin"))return "{\"status\":\"failure\",\"msg\":\"unauthorized action\"}";

        String userName = request.getParameter("userName");
        int    userId   = com.feezixlabs.db.dao.UserDOA.getUserId(userName);
        String env      = "dev";
        
        //delete any content related to this user
        java.util.List<com.feezixlabs.bean.Room>rooms = com.feezixlabs.db.dao.RoomDAO.getRooms(userName);
        for(com.feezixlabs.bean.Room room:rooms){
            java.util.List<com.feezixlabs.bean.Context>contexts = com.feezixlabs.db.dao.ContextDAO.getContexts(userName, room.getId(),userId);
            for(com.feezixlabs.bean.Context context:contexts){
                com.feezixlabs.db.dao.ContextDAO.deleteContext(userName,room.getId(), context.getId(), userId);
            }
        }

        //delete all developer related resources
        java.util.List<com.feezixlabs.bean.Widget>widgets = com.feezixlabs.db.dao.WidgetDAO.getWidgets(userName,env);
        for(com.feezixlabs.bean.Widget w:widgets){
            com.feezixlabs.db.dao.WidgetDAO.deleteWidget(userName,w.getId(),env);
        }
        
        //do database level delete
        com.feezixlabs.db.dao.UserDOA.deleteUser(userName);
        return "{\"status\":\"success\"}";
    }

    public static String getUserProfile(HttpServletRequest request){
        User user = UserDOA.getUser(request.getUserPrincipal().getName());
        String profilePic = org.apache.commons.codec.digest.DigestUtils.md5Hex(user.getId()+UserActionHandler.ID_HASHER);
        if(!new java.io.File(ConfigUtil.static_file_directory+"/"+profilePic).exists())
            profilePic = "";
        return "{\"full_name\":\""+user.getName().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\",\"photo\":\""+profilePic+"\"}";
    }

    public static String getUserStatus(HttpServletRequest request){
        User user = UserDOA.getUser(request.getUserPrincipal().getName());
        return "{\"status\":\""+user.getStatus()+"\"}";
    }    
    
    public static String updateUserProfileFullName(HttpServletRequest request){
        String fullName = request.getParameter("fullName");
        if(fullName == null || fullName.length()==0)
            return "{\"status\":\"failure\",\"msg\":\"Please provide your name\"}";

        User user = UserDOA.getUser(request.getUserPrincipal().getName());
        user.setName(fullName);
        UserDOA.updateUserFullName(user);
        return "{\"status\":\"success\"}";
    }

    public static String updateUserProfilePassword(HttpServletRequest request){
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        User user = UserDOA.getUser(request.getUserPrincipal().getName());
        if(user.getPassWord().compareTo(currentPassword) != 0)
            return "{\"status\":\"failure\",\"msg\":\"Password supplied is incorrect.\"}";

        if(newPassword == null || newPassword.length()<5)
            return "{\"status\":\"failure\",\"msg\":\"Password supplied is invalid, password must be at least 5 characters long.\"}";

        user.setPassWord(newPassword);
        UserDOA.updateUserPassword(user);
        return "{\"status\":\"success\"}";
    }


    public static String updateUserProfileEmail(HttpServletRequest request){
        String emailAddress = request.getParameter("emailAddress");        
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        if(UserDOA.updateUserEmail(request.getUserPrincipal().getName(),emailAddress)){
            
            if(user.getStatus().compareTo("active-auto-user") == 0)
                UserDOA.updateStatus(emailAddress, "active");
            sendUserPassword(request);
            request.getSession().invalidate();
            return "{\"status\":\"success\"}";
        }else{            
            return "{\"status\":\"failure\",\"msg\":\"There was a problem changing your login email. \\n Make sure you entered an email that isn't already in use.\"}";
        }
    }    
    
    
    public static String messagePump(HttpServletRequest request)
    {
        String action = request.getParameter("action");
        
        if(action.compareToIgnoreCase("add-participant") == 0){            
            int roomId = new Integer(request.getParameter("room_id"));
            com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getParameter("emailAddress"));
            if(user == null){
                user = createNewUser(request);
                if(user != null)
                    return addParticipant(request,user.getEmailAddress(),roomId,false);
            }else
                return addParticipant(request,user.getEmailAddress(),roomId,false);
        }
        else
        if(action.compareToIgnoreCase("del-participant") == 0){
            return deleteParticipant(request);
        }
        else
        if(action.compareToIgnoreCase("create-new-user") == 0 || action.compareToIgnoreCase("auto-create-new-user") == 0){

          if(!request.isUserInRole("sysadmin") && !request.isUserInRole("educator")){
              if(!com.feezixlabs.util.ConfigUtil.allow_user_account_creation)
                  return "{\"status\":\"failed\",\"msg\":\"User Created Accounts Not Allowed\"}";
          }

          String emailAddress = request.getParameter("emailAddress") != null?request.getParameter("emailAddress"):"";
          String fullName     = request.getParameter("name")!=null?request.getParameter("name"):"";
          String roomLabel    = request.getParameter("roomLabel")!=null?request.getParameter("roomLabel"):"";
          
          if(com.feezixlabs.util.ConfigUtil.allow_auto_signup && action.compareToIgnoreCase("auto-create-new-user") == 0){
              emailAddress = com.feezixlabs.db.dao.MiscDAO.getUUID(12)+"@appynote.com";
              fullName     = "Your name here.";
              roomLabel    = "My virtual room";
          }
          
          if(emailAddress.isEmpty() || fullName.isEmpty() || roomLabel.isEmpty())
              return "{\"status\":\"failed\",\"msg\":\"Please enter all required fields.\"}";
          
          //check to see if account creation is restricted to only certain domains
          if(!com.feezixlabs.util.Utility.passDomainRestriction(emailAddress))
              return "{\"status\":\"failed\",\"msg\":\"User E-mail domain not recognized\"}";

          com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(emailAddress);
          if(user != null){
              return "{\"status\":\"failure\",\"msg\":\"A user already exists with the supplied email address.\"}";
          }          
          
          //first ensure user doesn't already exist
          if(com.feezixlabs.util.ConfigUtil.allow_auto_signup && action.compareToIgnoreCase("auto-create-new-user") == 0){              
              user = createNewUser(fullName,emailAddress,roomLabel);
              com.feezixlabs.db.dao.UserDOA.updateStatus(emailAddress, "active-auto-user");
          }
          else
              user = createNewUser(request);
          
          
          if(com.feezixlabs.util.ConfigUtil.allow_auto_login_after_signup){
            request.getSession().setAttribute("signup-username",user.getUserName());
            request.getSession().setAttribute("signup-password",user.getPassWord());          
          
            return "{\"status\":\"success\",\"username\":\""+user.getUserName()+"\",\"password\":\""+user.getPassWord()+"\"}";
          }else{
            return "{\"status\":\"success\"}";  
          }
          /*
          if(user != null){
              //get default room
              com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRooms(user.getEmailAddress()).get(0);

              //send notification email
              String notification = com.feezixlabs.util.ConfigUtil.account_creation_notification_email.replaceAll("\\{installation_name\\}", com.feezixlabs.util.ConfigUtil.installation_name).replaceAll("\\{participant_name\\}", user.getFirstName()).replaceAll("\\{username\\}", user.getEmailAddress().toLowerCase()).replaceAll("\\{passwd\\}", user.getPassWord()).replaceAll("\\{installation_login_url\\}",com.feezixlabs.util.ConfigUtil.installation_login_url+room.getId());
              com.feezixlabs.util.Utility.sendEmail(user.getEmailAddress(), com.feezixlabs.util.ConfigUtil.installation_name+" Invite",notification, true, com.feezixlabs.util.ConfigUtil.invite_notifier, com.feezixlabs.util.ConfigUtil.account_create_notifier, com.feezixlabs.util.ConfigUtil.account_create_notifier_password);
              return "{\"status\":\"success\"}";
          }*/
        }
        else
        if(action.compareToIgnoreCase("admin-update-user-role") == 0){

            if(!request.isUserInRole("sysadmin"))
                return "{\"status\":\"failure\"}";

            //add new user if necessary
            com.feezixlabs.bean.User user = createNewUser(request);
            if(user != null){
                String[] roles = request.getParameter("roles").split("\n");

                //determine if there are roles to remove
                for(String str:com.feezixlabs.db.dao.UserDOA.getUserRoles(user.getId())){
                    for(int i=0;i<roles.length;i++){
                        if(str.compareTo(roles[i]) == 0)continue;
                    }
                    if(str.compareTo("participant")  != 0)//don't remove default role
                        com.feezixlabs.db.dao.UserDOA.delUserFromRole(user.getId(), str);
                }

                //add any new roles
                for(int i=0;i<roles.length;i++){
                    if(roles[i].compareTo("participant")  != 0)//don't add default role
                        com.feezixlabs.db.dao.UserDOA.addUserToRole(user.getId(), roles[i]);
                }
                return "{\"status\":\"success\"}";
            }
        }
        else
        if(action.compareToIgnoreCase("load-users") == 0){
            return loadUsers(request);
        }
        else
        if(action.compareToIgnoreCase("recover-password") == 0){
            return sendUserPassword(request);
        }
        else
        if(action.compareToIgnoreCase("delete-user") == 0){
            return deleteUser(request);
        }
        else
        if(action.compareToIgnoreCase("get-user-profile") == 0){
            return getUserProfile(request);
        }
        else
        if(action.compareToIgnoreCase("get-user-status") == 0){
            return getUserStatus(request);
        }        
        else
        if(action.compareToIgnoreCase("update-user-profile-fullname") == 0){
            return updateUserProfileFullName(request);
        }
        else
        if(action.compareToIgnoreCase("update-user-profile-password") == 0){
            return updateUserProfilePassword(request);
        }
        else
        if(action.compareToIgnoreCase("update-user-profile-email") == 0){
            return updateUserProfileEmail(request);
        }        
        else
        if(action.compareToIgnoreCase("upgrade-account") == 0){
            return upgradeAccount(request);
        }
        else
        if(action.compareToIgnoreCase("get-plan-info") == 0){
            return getPlanInfo(request);
        }
        else
        if(action.compareToIgnoreCase("cancel-plan") == 0){
            return UserActionHandler.cancelCurrentPlan(request);
        }
        else
        if(action.compareToIgnoreCase("change-to-team-plan") == 0){
            return UserActionHandler.changeToTeamPlan(request);
        }
        else
        if(action.compareToIgnoreCase("change-to-individual-plan") == 0){
            return UserActionHandler.changeToIndividualPlan(request);
        }
        else
        if(action.compareToIgnoreCase("change-to-change-payment-info-plan") == 0){
            return UserActionHandler.updatePaymentInformation(request);
        }
        else
        if(action.compareToIgnoreCase("grant-developer-role") == 0){
            return UserActionHandler.grantDeveloperRoleToUser(request);
        }        
        return "{\"status\":\"failed\"}";
    }
}
