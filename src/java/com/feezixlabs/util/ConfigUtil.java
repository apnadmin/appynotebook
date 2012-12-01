/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.util;
import com.feezixlabs.util.Config;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;

/**
 *
 * @author bitlooter
 */
public class ConfigUtil {
    static Logger logger = Logger.getLogger(ConfigUtil.class.getName());
    public static String environment = null;
    public static String baseUrl = null;
    public static String path = null;
    

    //applet distribution security
    public static final String FOR_PRODUCTION_USE_ONLY                        = "f406fe04-1056-11e0-904b-0019b958a435";
    public static final String FOR_PRODUCTION_USE_ONLY_HASH                   = "efe48043780f6023cda2dea25cb024f1";
    
    public static final String RISTRICT_TO_DOMAIN                             = "022aa260-1057-11e0-904b-0019b958a435";
    public static final String RISTRICT_TO_DOMAIN_HASH                        = "9e8ecb504849443d82466da492ff7557";

    public static final String RESTRICT_TO_DOMAIN_FOR_PRODUCTION_USE_ONLY     = "21f250b6-1057-11e0-904b-0019b958a435";

    public static final String NO_RESTRICTIONS                                = "6c625914-1059-11e0-904b-0019b958a435";


    public static String    image_upload_directory = null;
    public static String    file_serving_url_prefix = null;
    public static String    static_file_directory = null;
    public static String    resource_directory = null;
    public static String    temp_upload_directory = null;

    public static String    timezone_list = null;

    public static String    account_creation_via_invite_notification_email  = null;
    public static String    account_creation_notification_email             = null;
    public static String    room_invite_notification_email                  = null;
    public static String    account_login_recovery_notification_email       = null;
    
    public static String    installation_name                       = null;
    public static String    installation_login_url                  = null;

    public static String    account_create_notifier                 = null;
    public static String    account_create_notifier_password        = null;

    public static String    app_notifier                            = null;
    public static String    app_notifier_password                   = null;

    public static String    invite_notifier = null;
    public static String    invite_notifier_password                = null;
    public static String    applet_deployment_policy                = null;

    public static boolean   institutional_instance                  = false;
    public static boolean   allow_user_account_creation             = true;
    public static boolean   allow_auto_login_after_signup           = false;
    public static boolean   allow_auto_signup                       = false;
    public static String    restrict_access_to_domains              = "all";
    public static String    default_roles                           = "";
    public static int       room_size_limit                         = -1;
    public static int       system_user_limit                       = -1;
    public static int       active_mq_rate                          = 100;
    public static boolean   enable_http_proxy                       = false;
    public static String    explore_and_learn_url                   = "";
    public static String    whats_new_url                           = "";
    public static boolean   enable_applet_import                    = false;
    public static boolean   load_sample_applets                     = false;
    public static boolean   enable_applet_deployment                = false;
    public static String    hadron_help_url                         = "";

    public static int       default_binder_access                   = 1;
    public static int       default_page_access                     = 3;
    public static int       default_element_access                  = 3;
    public static boolean   enable_content_importing                = true;

    public static String    stripe_public_key                       = "";
    public static String    stripe_secret_key                       = "";

    public static final int ACCESS_NONE                             = 0;
    public static final int ACCESS_READ                             = 1;
    public static final int ACCESS_WRITE                            = 2;
    public static final int ACCESS_CREATE                           = 4;
    public static final int ACCESS_DELETE                           = 8;
    public static final int ACCESS_EMBED                            = 16;

    public static java.util.HashMap<String,String> ext2mime_mapping = new java.util.HashMap();
    static Config _config = null;


    static boolean setProperty(String id,String val){
        if(id == null || val == null)return false;

        try
        {
            /*
            if(id.compareToIgnoreCase("environment")==0){
                ConfigUtil.environment = val;
                return true;
            }
            else*/
            if(id.compareToIgnoreCase("baseUrl")==0 && val.length()>0){
                ConfigUtil.baseUrl = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("file_serving_url_prefix")==0 && val.length()>0){
                ConfigUtil.file_serving_url_prefix = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("image_upload_directory")==0 && val.length()>0){
                ConfigUtil.image_upload_directory = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("enable_content_importing")==0 && val.length()>0){
                ConfigUtil.enable_content_importing = Boolean.parseBoolean(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("static_file_directory")==0 && val.length()>0){
                ConfigUtil.static_file_directory = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("resource_directory")==0 && val.length()>0){
                ConfigUtil.resource_directory = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("temp_upload_directory")==0 && val.length()>0){
                ConfigUtil.temp_upload_directory = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("account_creation_via_invite_notification_email")==0 && val.length()>0){
                ConfigUtil.account_creation_via_invite_notification_email = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("account_creation_notification_email")==0 && val.length()>0){
                ConfigUtil.account_creation_notification_email = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("account_login_recovery_notification_email")==0 && val.length()>0){
                ConfigUtil.account_login_recovery_notification_email = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("room_invite_notification_email")==0 && val.length()>0){
                ConfigUtil.room_invite_notification_email = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("installation_name")==0 && val.length()>0){
                ConfigUtil.installation_name = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("installation_login_url")==0 && val.length()>0){
                ConfigUtil.installation_login_url = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("timezone_list")==0 && val.length()>0){
                ConfigUtil.timezone_list = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("account_create_notifier")==0 && val.length()>0){
                ConfigUtil.account_create_notifier = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("account_create_notifier_password")==0 && val.length()>0){
                ConfigUtil.account_create_notifier_password = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("app_notifier")==0 && val.length()>0){
                ConfigUtil.app_notifier = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("app_notifier_password")==0 && val.length()>0){
                ConfigUtil.app_notifier_password = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("invite_notifier")==0 && val.length()>0){
                ConfigUtil.invite_notifier = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("invite_notifier_password")==0 && val.length()>0){
                ConfigUtil.invite_notifier_password = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("applet_deployment_policy")==0 && val.length()>0){
                ConfigUtil.applet_deployment_policy = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("allow_user_account_creation")==0 && val.length()>0){
                ConfigUtil.allow_user_account_creation = Boolean.parseBoolean(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("allow_auto_login_after_signup")==0 && val.length()>0){
                ConfigUtil.allow_auto_login_after_signup = Boolean.parseBoolean(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("allow_auto_signup")==0 && val.length()>0){
                ConfigUtil.allow_auto_signup = Boolean.parseBoolean(val);
                return true;
            }              
            else
            if(id.compareToIgnoreCase("restrict_access_to_domains")==0 && val.length()>0){
                ConfigUtil.restrict_access_to_domains = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("default_roles")==0){
                ConfigUtil.default_roles = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("default_binder_access")==0 && val.length()>0){
                ConfigUtil.default_binder_access = new Integer(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("default_page_access")==0 && val.length()>0){
                ConfigUtil.default_page_access = new Integer(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("default_element_access")==0 && val.length()>0){
                ConfigUtil.default_element_access = new Integer(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("institutional_instance")==0 && val.length()>0){
                ConfigUtil.institutional_instance = Boolean.parseBoolean(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("room_size_limit")==0 && val.length()>0){
                ConfigUtil.room_size_limit = new Integer(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("system_user_limit")==0 && val.length()>0){
                ConfigUtil.system_user_limit = new Integer(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("enable_http_proxy")==0 && val.length()>0){
                ConfigUtil.enable_http_proxy = Boolean.parseBoolean(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("explore_and_learn_url")==0 && val.length()>0){
                ConfigUtil.explore_and_learn_url = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("whats_new_url")==0 && val.length()>0){
                ConfigUtil.whats_new_url = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("enable_applet_import")==0 && val.length()>0){
                ConfigUtil.enable_applet_import = Boolean.parseBoolean(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("load_sample_applets")==0 && val.length()>0){
                ConfigUtil.load_sample_applets = Boolean.parseBoolean(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("enable_applet_deployment")==0 && val.length()>0){
                ConfigUtil.enable_applet_deployment = Boolean.parseBoolean(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("hadron_help_url")==0 && val.length()>0){
                ConfigUtil.hadron_help_url = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("active_mq_rate")==0 && val.length()>0){
                ConfigUtil.active_mq_rate = new Integer(val);
                return true;
            }
            else
            if(id.compareToIgnoreCase("stripe_public_key")==0 && val.length()>0){
                ConfigUtil.stripe_public_key = val;
                return true;
            }
            else
            if(id.compareToIgnoreCase("stripe_secret_key")==0 && val.length()>0){
                ConfigUtil.stripe_secret_key = val;
                return true;
            }
        }
        catch(Exception ex){
            logger.error("",ex);
        }

        return false;
    }

    public static void load(){
		try {
			javax.xml.bind.JAXBContext jaxbContext = javax.xml.bind.JAXBContext.newInstance("com.feezixlabs.util");
			javax.xml.bind.Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();

                        Object obj = unmarshaller.unmarshal(new java.io.FileInputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.path)));

                        //System.out.println("type:"+obj.getClass().getName());
                        ConfigUtil._config = (Config)((/*(javax.xml.bind.JAXBElement)*/obj)/*.getValue()*/);

                        //load properties
                        for (com.feezixlabs.util.PropertyType property:ConfigUtil._config.getProperty()){
                            ConfigUtil.setProperty(property.getId(), property.getValue());
                        }

		} catch (Exception e) {
                    logger.error("",e);
		}
    }



    public static void load_ext2mime_mapping(String path){
		try {
			javax.xml.bind.JAXBContext jaxbContext = javax.xml.bind.JAXBContext.newInstance("com.feezixlabs.util");
			javax.xml.bind.Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();

                        //if(new java.io.File(path).exists())
                        //    System.out.println("config file located");

                        Object obj = unmarshaller.unmarshal(new java.io.FileInputStream(new java.io.File(path)));

                        //System.out.println("type:"+obj.getClass().getName());
                        Config config = (Config)((/*(javax.xml.bind.JAXBElement)*/obj)/*.getValue()*/);

                        //load properties
                        for (com.feezixlabs.util.PropertyType property:config.getProperty()){
                            ConfigUtil.ext2mime_mapping.put(property.getId(),property.getValue());
                        }
		} catch (Exception e) {
                    logger.error("",e);
		}
    }

    public static void update(HttpServletRequest request){
        //load properties
        for (com.feezixlabs.util.PropertyType property:ConfigUtil._config.getProperty()){
            if(ConfigUtil.setProperty(property.getId(),request.getParameter(property.getId())))
                property.setValue(request.getParameter(property.getId()));
        }
        
        try{
            javax.xml.bind.JAXBContext jaxbContext = javax.xml.bind.JAXBContext.newInstance("com.feezixlabs.util");
            javax.xml.bind.Marshaller marshaller = jaxbContext.createMarshaller();
            marshaller.setProperty(javax.xml.bind.Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);

            com.feezixlabs.util.ObjectFactory factory = new com.feezixlabs.util.ObjectFactory();

            org.apache.commons.io.output.ByteArrayOutputStream bo = new org.apache.commons.io.output.ByteArrayOutputStream();

            marshaller.marshal(ConfigUtil._config, bo);
            org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(ConfigUtil.path), bo.toString("UTF-8"));
        }catch(Exception ex){
            logger.error("",ex);
        }
    }
}
