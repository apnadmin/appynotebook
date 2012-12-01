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
public class AssignmentReminderProcessor extends Thread{
    static Logger           logger               = Logger.getLogger(AssignmentReminderProcessor.class.getName());
    static final int        MILLISECONDS_PER_DAY = 86400000;    
    public static boolean   kill                 = false;
    public static boolean   processing           = false;
    
    @Override
    public void run(){
        java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("MM/dd/yyyy hh:mm a");
        java.text.SimpleDateFormat mysqlformat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
        
        while(true){
            try{
                
                if(kill)return;                
                processing = true;
                
                java.util.List<com.feezixlabs.bean.Assignment> assignments = com.feezixlabs.db.dao.AssignmentDAO.getAssignmentsWithReminder();
                logger.info("Running reminder check."+assignments.size()+" assignments would be checked.");
                for(com.feezixlabs.bean.Assignment assignment:assignments){
                    java.util.List<com.feezixlabs.bean.Participant> participants = com.feezixlabs.db.dao.ParticipantDAO.getParticipants(assignment.getRoomId());
                    //logger.info("       sending reminders to "+participants.size()+" participants.");
                    for(com.feezixlabs.bean.Participant participant:participants){
                        
                        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUserById(participant.getUserId());
                        java.util.List<com.feezixlabs.bean.AssignmentSubmission> submissions = com.feezixlabs.db.dao.AssignmentSubmissionDAO.getAssignmentSubmissions(participant.getUserName(), assignment.getRoomId(), assignment.getId());
                        if(submissions.isEmpty()){
                            //logger.info("           sending reminder to "+user.getName());
                            String dueDate = ".";
                            if(assignment.getCloseDate() != null)
                                dueDate = " due "+format.format(mysqlformat.parse(assignment.getCloseDate()))+".";

                            String notification = "Hi "+user.getName().split(" ")[0]+"! <br> This is just a friendly reminder for <b>"+assignment.getName()+"</b>"+dueDate;
                            //send reminder
                            com.feezixlabs.util.Utility.sendEmail(user.getEmailAddress(), "Reminder("+assignment.getName()+")",notification, true, com.feezixlabs.util.ConfigUtil.app_notifier, com.feezixlabs.util.ConfigUtil.app_notifier, com.feezixlabs.util.ConfigUtil.app_notifier_password);
                        }
                    }
                }
                com.feezixlabs.db.dao.AssignmentDAO.updateAssignmentsWithReminder();
                
                processing = false;
                if(kill)return;
                
                Thread.sleep(900000l);//repeat every 15 minutes
            }
            catch(Exception e){
                processing = false;
                if(kill)return;
                logger.error("",e);
            }
        }
    }
}
