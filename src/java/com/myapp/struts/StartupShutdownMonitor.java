/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.myapp.struts;
import org.apache.struts.action.PlugIn;
import org.apache.struts.action.ActionServlet;
import org.apache.struts.config.ModuleConfig;
import javax.servlet.ServletException;
/**
 *
 * @author bitlooter
 */
public class StartupShutdownMonitor implements PlugIn{
    public static com.feezixlabs.util.BillingProcessor billProcessorThread                = null;
    public static com.feezixlabs.util.AssignmentReminderProcessor assignmentReminderProcessorThread  = null;
    public void destroy() {
        if(com.feezixlabs.util.ConfigUtil.enable_content_importing){
            com.feezixlabs.util.Utility.JODConvertOfficeManager.stop();
        }
        assignmentReminderProcessorThread.kill = true;
        billProcessorThread.kill               = true;
        
        if(billProcessorThread != null){
            while(billProcessorThread.processing){
                try{
                    Thread.sleep(5000);
                }catch(Exception ex){
                    break;
                }
            }
        }
        
        
        while(assignmentReminderProcessorThread.processing){
            try{
                Thread.sleep(5000);
            }catch(Exception ex){
                break;
            }
        }
        
    }
    public void init(ActionServlet actionServlet, ModuleConfig config)throws ServletException {
        eu.medsea.mimeutil.MimeUtil.registerMimeDetector("eu.medsea.mimeutil.detector.MagicMimeMimeDetector");

        //do some initialization
        com.feezixlabs.util.ConfigUtil.environment = actionServlet.getInitParameter("environment");
        String configPath = actionServlet.getInitParameter(com.feezixlabs.util.ConfigUtil.environment+".configfile.location");
        com.feezixlabs.util.ConfigUtil.path = configPath+"/"+com.feezixlabs.util.ConfigUtil.environment+".feezixlabs.config.xml";
        
        com.feezixlabs.util.ConfigUtil.load();
        com.feezixlabs.util.ConfigUtil.load_ext2mime_mapping(configPath+"/ext2mime-mapping.xml");
        
        com.feezixlabs.db.DBManager.init();

        if(com.feezixlabs.util.ConfigUtil.enable_content_importing){
            com.feezixlabs.util.Utility.JODConvertOfficeManager = new org.artofsolving.jodconverter.office.DefaultOfficeManagerConfiguration().buildOfficeManager();
            com.feezixlabs.util.Utility.JODConvertOfficeManager.start();
        }
        com.stripe.Stripe.apiKey = actionServlet.getInitParameter(com.feezixlabs.util.ConfigUtil.environment+".stripe.public.key");
        
        com.feezixlabs.util.ConfigUtil.stripe_public_key  = actionServlet.getInitParameter(com.feezixlabs.util.ConfigUtil.environment+".stripe.public.key");
        com.feezixlabs.util.ConfigUtil.stripe_secret_key  = actionServlet.getInitParameter(com.feezixlabs.util.ConfigUtil.environment+".stripe.secret.key");
        
        //start thread to send out assignment reminders
        assignmentReminderProcessorThread = new com.feezixlabs.util.AssignmentReminderProcessor();
        assignmentReminderProcessorThread.start();
        
        if(!com.feezixlabs.util.ConfigUtil.institutional_instance){
            billProcessorThread = new com.feezixlabs.util.BillingProcessor();
            billProcessorThread.start();
        }
    }
}
