/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.struts.action.handler;
import javax.servlet.http.HttpServletRequest;
import com.feezixlabs.bean.User;
import com.feezixlabs.bean.Room;
import com.feezixlabs.bean.Participant;
import com.feezixlabs.bean.Context;
import com.feezixlabs.bean.Pad;

import com.colabopad.bean.widgetmenu.Menu;
import com.feezixlabs.bean.*;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import net.sf.json.JSONArray;
import com.feezixlabs.util.ConfigUtil;
import com.feezixlabs.util.Utility;
import java.util.List;

import org.apache.log4j.Logger;

/**
 *
 * @author bitlooter
 */
public class PadUIActionHandler {


   static Logger logger = Logger.getLogger(PadUIActionHandler.class.getName());

    static String loadRoom(HttpServletRequest request){
            int roomId = new Integer(request.getParameter("room_id"));
            StringBuffer json = new StringBuffer();

            Map roomMap = new HashMap();
            json.append("{");

            Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);
            if(room != null){

                roomMap.put("id", room.getId());
                roomMap.put("title", room.getTitle());
                roomMap.put("creator", room.getRequesterId());

                json.append("\"id\":"+room.getId()+",\"title\":\""+room.getTitle().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\",creator:"+room.getUserId());

                java.util.List<Participant> participants = com.feezixlabs.db.dao.ParticipantDAO.getParticipants(room.getId());
                int j = 0;

                ArrayList participantList = new ArrayList();
                json.append(",participants:[");
                for(Participant participant:participants){
                    Map participantMap = new HashMap();
                    participantMap.put("id", participant.getUserId());
                    participantMap.put("name", participant.getName());

                    String profilePic = org.apache.commons.codec.digest.DigestUtils.md5Hex(participant.getUserId()+UserActionHandler.ID_HASHER);
                    if(!new java.io.File(ConfigUtil.static_file_directory+"/"+profilePic).exists())
                        profilePic = "";
                    participantMap.put("photo", profilePic);

                    participantList.add(participantMap);
                    json.append((j++>0?",":"")+ "{\"id\":"+participant.getUserId()+",\"name\":\""+participant.getName().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\",\"photo\":\""+profilePic+"\"}");
                }
                roomMap.put("participants", participantList);
                json.append("]");
            }
            json.append("}");

            return json.toString();
            //return JSONArray.fromObject(roomMap).toString();
    }

    static String getElements(HttpServletRequest request,int roomId,int grantor,int contextId,int padId){

        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.User grantorUser = com.feezixlabs.db.dao.UserDOA.getUserById(grantor);

        StringBuffer json = new StringBuffer();
        java.util.List<Element> elements = com.feezixlabs.db.dao.ElementDAO.getElements(request.getUserPrincipal().getName(),roomId,contextId,padId,grantor);
        int j = 0;

        json.append("[");
        for(Element element:elements){
            com.feezixlabs.bean.ElementAccess elementAccess = com.feezixlabs.db.dao.ElementAccessDAO.getElementAccess(grantorUser.getUserName(),roomId,contextId,padId,element.getId(),user.getId());
            json.append((j++>0?",":"")+ "{\"created_by\":user_id,\"create_date\":\""+element.getCreateDate()+"\",\"id\":"+element.getId()+",\"config\":"+element.getConfig()+",\"access\":["+element.getAccessControl()+",0,"+elementAccess.getAccess()+",0]}\n");
        }
        json.append("]");

        return json.toString();
    }    
    
    static String getBinder(HttpServletRequest request){
            int roomId = new Integer(request.getParameter("room_id"));
            int grantor = new Integer(request.getParameter("grantor"));
            int contextId = new Integer(request.getParameter("context_id"));

            com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
            
            StringBuilder json = new StringBuilder();
            boolean first = true;

            
            Context context = com.feezixlabs.db.dao.ContextDAO.getContext(request.getUserPrincipal().getName(), roomId, contextId, grantor);

            java.util.List<Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),roomId,context.getId(),grantor);
            int i = 0;
            
            json.append("{\"created_by\":user_id,\"create_date\":\""+context.getCreateDate()+"\",\"meta_data\":"+context.getConfig()+",\"id\":"+(new java.util.Date().getTime())+",\"access\":["+context.getAccessControl()+",0,3,0],\"pads\":[");
            for(Pad pad:pads){
                
                json.append((i++>0?",":"")+  "{\"created_by\":user_id,\"create_date\":\""+pad.getCreateDate()+"\",\"meta_data\":"+pad.getConfig()+",\"id\":"+pad.getId()+",\"access\":["+pad.getAccessControl()+",0,3,0],\"embed_key\":\""+pad.getEmbedKey()+"\",\"elements\":"+getElements(request,roomId,grantor,contextId,pad.getId())+"}\n");
            }
            json.append("]}");
            
            return json.toString();        
    }
    
    
    public static List getBinders(HttpServletRequest request){
            int roomId       = new Integer(request.getParameter("room_id"));
            String[] binders = request.getParameter("binders").split("#");
            
            net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
            jsonConfig.setJavascriptCompliant(true);            
            
            List binderList = new ArrayList();
            
            com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
            
            long baseId = new java.util.Date().getTime();
            for(int i=0;i<binders.length;i++){
                Context context = com.feezixlabs.db.dao.ContextDAO.getContext(request.getUserPrincipal().getName(), roomId, new Integer(binders[i]), user.getId());
                Map binder = new HashMap();
                binder.put("created_by", "0");
                binder.put("create_date", context.getCreateDate());
                binder.put("meta_data", net.sf.json.JSONObject.fromObject(context.getConfig(),jsonConfig));
                
                binder.put("id", baseId+i);
                int[] access = {context.getAccessControl(),0,3,0};
                binder.put("access", access);
                
                List padList = new ArrayList();
                binder.put("pads", padList);
                
                java.util.List<Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),roomId,context.getId(),user.getId());
                
                
                for(Pad pad:pads){
                    Map page = new HashMap();
                    page.put("created_by", "0");
                    page.put("create_date", pad.getCreateDate());
                    page.put("meta_data", net.sf.json.JSONObject.fromObject(pad.getConfig(),jsonConfig));
                    page.put("id", pad.getId());
                    page.put("parent_id",pad.getParentId());
                    page.put("pre_sibling",pad.getPreSibling());
                    
                    int[] paccess = {pad.getAccessControl(),0,3,0};
                    page.put("access", paccess);
                    
                    List elementList = new ArrayList();
                    page.put("elements", elementList);
                    padList.add(page);
                    
                    
                    java.util.List<Element> elements = com.feezixlabs.db.dao.ElementDAO.getElements(request.getUserPrincipal().getName(),roomId,pad.getContextId(),pad.getId(),user.getId());

                    for(Element element:elements){
                        //com.feezixlabs.bean.ElementAccess elementAccess = com.feezixlabs.db.dao.ElementAccessDAO.getElementAccess(grantorUser.getUserName(),roomId,contextId,padId,element.getId(),user.getId());
                        Map ele = new HashMap();
                        ele.put("created_by", "0");
                        ele.put("create_date", element.getCreateDate());
                        ele.put("config", net.sf.json.JSONObject.fromObject(element.getConfig(),jsonConfig));
                        ele.put("id", element.getId());
                        int[] eaccess = {element.getAccessControl(),0,3,0};
                        ele.put("access", eaccess);                        
                        elementList.add(ele);
                    }                
                }
                binderList.add(binder);
            }
            return binderList;        
    }    

    
    
    static String loadWorkBench(HttpServletRequest request){
            int roomId = new Integer(request.getParameter("room_id"));
            Room room = null;

            
            for(int i=0;i<10;i++){
               room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);
               if(room != null)break;
               else{
                    try{
                        Thread.currentThread().wait(1000);
                   }catch(Exception ex){}
                }
            }
            java.util.List<Participant> participants = com.feezixlabs.db.dao.ParticipantDAO.getParticipants(room.getId());
            com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
            
            StringBuilder json = new StringBuilder();

            ArrayList participantList = new ArrayList();
            json.append("[");

            boolean first = true;
            for(Participant participant:participants){
                HashMap participantMap = new HashMap();
                participantMap.put("id", participant.getUserId());

                ArrayList contextList = new ArrayList();
                
                json.append(!first?",{":"{");
                json.append("\"id\":"+participant.getUserId()+",\"contexts\":[");
                java.util.List<Context> contexts = com.feezixlabs.db.dao.ContextDAO.getContexts(request.getUserPrincipal().getName(),room.getId(),participant.getUserId());
                int j = 0;
                for(Context context:contexts){
                    HashMap contextMap = new HashMap();
                    contextMap.put("meta_data", context.getConfig());
                    contextMap.put("id", context.getId());

                    java.util.List<Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),room.getId(),context.getId(),participant.getUserId());
                    int i = 0;
                    com.feezixlabs.bean.ContextAccess cntxAccess = com.feezixlabs.db.dao.ContextAccessDAO.getContextAccess(participant.getUserName(),room.getId(),context.getId(),user.getId());
                    json.append((j++>0?",":"")+"{\"created_by\":"+context.getCreatedBy()+",\"create_date\":\""+context.getCreateDate()+"\",\"meta_data\":"+context.getConfig()+",\"id\":"+context.getId()+",\"access\":["+context.getAccessControl()+",0,"+cntxAccess.getAccess()+",0],\"pads\":[");
                    for(Pad pad:pads){
                        com.feezixlabs.bean.PadAccess padAccess = com.feezixlabs.db.dao.PadAccessDAO.getPadAccess(participant.getUserName(),room.getId(),context.getId(),pad.getId(),user.getId());
                        json.append((i++>0?",":"")+  "{\"created_by\":"+pad.getCreatedBy()+",\"create_date\":\""+pad.getCreateDate()+"\",\"meta_data\":"+pad.getConfig()+",\"id\":"+pad.getId()+",\"access\":["+pad.getAccessControl()+",0,"+padAccess.getAccess()+",0],\"embed_key\":\""+pad.getEmbedKey()+"\"}");
                    }
                    json.append("]}");
                }
                json.append("]}");

                first = false;
            }
            json.append("]");
            return json.toString();
    }


  public static String loadAccessControlList(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int grantedTo = new Integer(request.getParameter("granted_to"));

        StringBuffer json = new StringBuffer();
        json.append("[");
        java.util.List<ContextAccess> contextAccesses = com.feezixlabs.db.dao.ContextAccessDAO.getContextAccessList(request.getUserPrincipal().getName(), roomId, grantedTo);
        int j = 0;
        for(ContextAccess contextAccess:contextAccesses){

            java.util.List<com.feezixlabs.bean.PadAccess> padAccesses = com.feezixlabs.db.dao.PadAccessDAO.getPadAccessList(request.getUserPrincipal().getName(),roomId, contextAccess.getId(),grantedTo);
            int i = 0;

            json.append((j++>0?",":"")+"{id:"+contextAccess.getId()+",access:["+contextAccess.getAccess()+"],pages:[");
            for(com.feezixlabs.bean.PadAccess padAccess:padAccesses){
                json.append((i++>0?",":"")+  "{id:"+padAccess.getId()+",access:["+padAccess.getAccess()+"],elements:[");

                java.util.List<com.feezixlabs.bean.ElementAccess> elementAccesses = com.feezixlabs.db.dao.ElementAccessDAO.getElementAccessList(request.getUserPrincipal().getName(),roomId, contextAccess.getId(),padAccess.getId(),grantedTo);
                boolean bfirst = true;
                for(com.feezixlabs.bean.ElementAccess elementAccess:elementAccesses){
                    json.append((!bfirst?",":"")+  "{id:"+elementAccess.getId()+",access:["+elementAccess.getAccess()+"]}");
                    bfirst = false;
                }
                json.append("]}");
            }
            json.append("]}");
        }
        json.append("]");
        return json.toString();
   }


    static String grantAppletAccess(HttpServletRequest request){
        String userName = request.getUserPrincipal().getName();
        int appletId = Integer.parseInt(request.getParameter("applet_id"));
        int roomId = request.getParameter("to_room") != null?Integer.parseInt(request.getParameter("to_room")):null;

        com.feezixlabs.db.dao.WidgetDAO.grantAppletAccess(appletId, userName, roomId);
        return "{\"status\":\"success\"}";
    }

    static String revokeAppletAccess(HttpServletRequest request){
        String userName = request.getUserPrincipal().getName();
        com.feezixlabs.db.dao.WidgetDAO.revokeAppletAccess(userName,Integer.parseInt(request.getParameter("applet_id")));
        return "{\"status\":\"success\"}";
    }

    static String notifyUserFromApp(HttpServletRequest request){
        int userId = Integer.parseInt(request.getParameter("user_id"));
        String appName = request.getParameter("app_name");
        String msg = request.getParameter("message");

        User user = com.feezixlabs.db.dao.UserDOA.getUserById(userId);

        Utility.sendEmail(user.getEmailAddress(), "app-notification-("+appName+")", msg,true,ConfigUtil.app_notifier,ConfigUtil.app_notifier, ConfigUtil.app_notifier_password);
        return "{\"status\":\"success\"}";
    }

    static String addAssignment(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);

        if(room == null || room.getUserId() != user.getId())
            return "{\"status\":\"failure\",\"msg\":\"You don't have a right to add tasks for this room.\"}";
        
        
        if(!com.feezixlabs.util.FeatureAccessManager.hasAccess("define task", request)){
            return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"You have exceeded the maximum number of tasks for this account, Please upgrade your account for unlimited task definitions.\"}";
        }
        
        
        String title = request.getParameter("title");
        String timeZone = request.getParameter("timeZone");

        java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("MM/dd/yyyy hh:mm a");
        java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("h:m");
        java.text.SimpleDateFormat mysqlformat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        try{
            String firstReminder    = request.getParameter("firstReminder") != null && request.getParameter("firstReminder").length()>0? mysqlformat.format(format.parse(request.getParameter("firstReminder"))):null;
            int repeatIntervalDays  = request.getParameter("repeatIntervalDays") != null && request.getParameter("repeatIntervalDays").length()>0?Integer.parseInt(request.getParameter("repeatIntervalDays").trim()):0;
            String repeatInterval   = request.getParameter("repeatInterval") !=null && request.getParameter("repeatInterval").length()>0? request.getParameter("repeatInterval"):"00:00";
            int repeatIntervalCount = request.getParameter("repeatIntervalCount") != null && request.getParameter("repeatIntervalCount").length()>0?Integer.parseInt(request.getParameter("repeatIntervalCount").trim()):0;

            String allowVersioning   = request.getParameter("allowVersioning") !=null && request.getParameter("allowVersioning").compareTo("yes")==0? "yes":"no";
            int versioningLimit = request.getParameter("versioningLimit") != null && request.getParameter("versioningLimit").length()>0?Integer.parseInt(request.getParameter("versioningLimit")):-1;

            int h =  Integer.parseInt(repeatInterval.split(":")[0].trim());
            int m =  Integer.parseInt(repeatInterval.split(":")[1].trim());
            int intervalInMinutes = (repeatIntervalDays*24*60)+(h*60)+m;

            String endNotificationTime    = null;

            if(firstReminder != null){
                java.util.Calendar endReminderCalender = new java.util.GregorianCalendar();
                endReminderCalender.setTime(mysqlformat.parse(firstReminder));

                //endReminderCalender.add(java.util.Calendar.MINUTE, (int)(intervalInMinutes*repeatIntervalCount));
                /*endNotificationTime*/firstReminder    = mysqlformat.format(endReminderCalender.getTime());
            }

            //register notification for this assignment
            int notificationId = 0;//com.feezixlabs.db.dao.NotificationDAO.addNotification(firstReminder, endNotificationTime, timeZone, intervalInMinutes, repeatIntervalCount, "","","email");

            String openTime = request.getParameter("openTime") != null && request.getParameter("openTime").length()>0?mysqlformat.format(format.parse(request.getParameter("openTime"))):null;
            String closeTime = request.getParameter("closeTime") != null && request.getParameter("closeTime").length()>0?mysqlformat.format(format.parse(request.getParameter("closeTime"))):null;
            int assignmentId = com.feezixlabs.db.dao.AssignmentDAO.addAssignment(request.getUserPrincipal().getName(), roomId,title, openTime, closeTime,timeZone,notificationId,allowVersioning,versioningLimit,firstReminder,intervalInMinutes,repeatIntervalCount);

            //System.out.println(openTime+"\n"+closeTime+"\n"+endNotificationTime);
            return "{\"status\":\"success\",\"id\":"+assignmentId+"}";
        }catch(Exception ex){
            logger.error("",ex);
        }

        return "{\"status\":\"failure\"}";
    }

    static String getAssignment(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int id = new Integer(request.getParameter("assignment_id"));
        com.feezixlabs.bean.Assignment assignment = com.feezixlabs.db.dao.AssignmentDAO.getAssignment(request.getUserPrincipal().getName(), roomId, id);
        //com.feezixlabs.bean.Notification notification = com.feezixlabs.db.dao.NotificationDAO.getNotification(assignment.getNotificationId());

        java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("MM/dd/yyyy hh:mm a");
        java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("h:m");
        java.text.SimpleDateFormat mysqlformat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        try{
            StringBuffer reply = new StringBuffer();
            reply.append("{\"title\":\""+assignment.getName().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\",");
            reply.append("\"timeZone\":\""+assignment.getTimeZone()+"\",");
            reply.append("\"openTime\":\""+ (assignment.getOpenDate()==null?"":format.format(mysqlformat.parse(assignment.getOpenDate())))+"\",");
            reply.append("\"closeTime\":\""+(assignment.getCloseDate()==null?"":format.format(mysqlformat.parse(assignment.getCloseDate())))+"\",");
            //reply.append("\"firstReminder\":\""+(notification.getStartTime()!=null?format.format(mysqlformat.parse(notification.getStartTime())):"")+"\",");
            reply.append("\"firstReminder\":\""+(assignment.getFirstReminderDate() != null?format.format(mysqlformat.parse(assignment.getFirstReminderDate())):"")+"\",");
            
            //int days = (int)Math.floor(notification.getRepeatInterval()/1440);
            //int hours = (int)Math.floor( (notification.getRepeatInterval()%1440)/60 );
            //int minutes = (int)((notification.getRepeatInterval()%1440)%60);
            int days = (int)Math.floor(assignment.getReminderRepeatInterval()/1440);
            int hours = (int)Math.floor( (assignment.getReminderRepeatInterval()%1440)/60 );
            int minutes = (int)((assignment.getReminderRepeatInterval()%1440)%60);
            
            String h = hours<10?"0"+hours:""+hours;
            String m = minutes<10?"0"+minutes:""+minutes;

            reply.append("\"repeatIntervalDays\":"+days+",");
            reply.append("\"repeatInterval\":\""+(((h+":"+m).compareTo("00:00") != 0)?(h+":"+m):"")+"\",");
            reply.append("\"allowVersioning\":\""+assignment.getAllowVersioning()+"\",");
            reply.append("\"versioningLimit\":"+assignment.getVersioningLimit()+",");
            //reply.append("\"repeatIntervalCount\":"+notification.getRepeatIntervalCount()+"}");
            reply.append("\"repeatIntervalCount\":"+assignment.getReminderRepeatCount()+"}");
            return reply.toString();
        }catch(Exception ex){
            logger.error("",ex);
        }return "{\"status\":\"failure\"}";
    }

    static String updateAssignment(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        
        
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);

        if(room == null || room.getUserId() != user.getId())
            return "{\"status\":\"failure\",\"msg\":\"You don't have a right to alter tasks for this room.\"}";
        
        
        int id = new Integer(request.getParameter("assignment_id"));
        String title = request.getParameter("title");
        String timeZone = request.getParameter("timeZone");

        String allowVersioning   = request.getParameter("allowVersioning") !=null && request.getParameter("allowVersioning").compareTo("yes")==0? "yes":"no";
        int versioningLimit = request.getParameter("versioningLimit") != null && request.getParameter("versioningLimit").length()>0?Integer.parseInt(request.getParameter("versioningLimit")):-1;


        java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("MM/dd/yyyy hh:mm a");
        java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("h:m");
        java.text.SimpleDateFormat mysqlformat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");


        try{
            String openTime = request.getParameter("openTime") != null && request.getParameter("openTime").length()>0?mysqlformat.format(format.parse(request.getParameter("openTime"))):null;
            String closeTime = request.getParameter("closeTime") != null && request.getParameter("closeTime").length()>0?mysqlformat.format(format.parse(request.getParameter("closeTime"))):null;

            

            String firstReminder = request.getParameter("firstReminder") != null && request.getParameter("firstReminder").length()>0? mysqlformat.format(format.parse(request.getParameter("firstReminder"))):null;
            int repeatIntervalDays  = request.getParameter("repeatIntervalDays") != null && request.getParameter("repeatIntervalDays").length()>0?Integer.parseInt(request.getParameter("repeatIntervalDays").trim()):0;
            String repeatInterval = request.getParameter("repeatInterval") !=null && request.getParameter("repeatInterval").length()>0?request.getParameter("repeatInterval"):"00:00";
            int repeatIntervalCount = request.getParameter("repeatIntervalCount") != null && request.getParameter("repeatIntervalCount").length()>0?Integer.parseInt(request.getParameter("repeatIntervalCount").trim()):0;


            int h =  Integer.parseInt(repeatInterval.split(":")[0].trim());
            int m =  Integer.parseInt(repeatInterval.split(":")[1].trim());
            int intervalInMinutes = (repeatIntervalDays*24*60)+(h*60)+m;

            String endNotificationTime    =  null;

            if(firstReminder != null){
                java.util.Calendar endReminderCalender = new java.util.GregorianCalendar();
                endReminderCalender.setTime(mysqlformat.parse(firstReminder));

                //endReminderCalender.add(java.util.Calendar.MINUTE, (int)(intervalInMinutes*repeatIntervalCount));
                /*endNotificationTime*/firstReminder    = mysqlformat.format(endReminderCalender.getTime());
            }

            //com.feezixlabs.bean.Notification notification = com.feezixlabs.db.dao.NotificationDAO.getNotification(id);
            //register notification for this assignment
            //com.feezixlabs.db.dao.NotificationDAO.updateNotification(notification.getId(),firstReminder, endNotificationTime, timeZone, intervalInMinutes, repeatIntervalCount);
            com.feezixlabs.db.dao.AssignmentDAO.updateAssignment(request.getUserPrincipal().getName(), roomId,id,title, openTime, closeTime,timeZone,allowVersioning,versioningLimit,firstReminder,intervalInMinutes, repeatIntervalCount);
            
            
            return "{\"status\":\"success\"}";
        }catch(Exception ex){
            logger.error("",ex);
        }
        return "{\"status\":\"failure\"}";
    }

     static String archiveAssignment(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        
        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);

        if(room == null || room.getUserId() != user.getId())
            return "{\"status\":\"failure\",\"msg\":\"You don't have a right to archive tasks for this room.\"}";
        
        
        int id = new Integer(request.getParameter("assignment_id"));
        com.feezixlabs.db.dao.AssignmentDAO.archiveAssignment(request.getUserPrincipal().getName(), roomId,id);
        return "{\"status\":\"success\"}";
    }

    public static String messagePump(HttpServletRequest request){
        String action = request.getParameter("action");
        if(action.compareToIgnoreCase("load-room") == 0){
            return loadRoom(request);
        }
        else
        if(action.compareToIgnoreCase("load-workbench") == 0){
            return loadWorkBench(request);
        }
        else
        if(action.compareToIgnoreCase("load-access-control-list") == 0){
            return loadAccessControlList(request);
        }
        else
        if(action.compareToIgnoreCase("get-text-data") == 0){
            return com.feezixlabs.db.dao.MiscDAO.getTextData(request.getParameter("id")).getData();
        }
        else
        if(action.compareToIgnoreCase("grant-applet-access") == 0){
            return grantAppletAccess(request);
        }
        else
        if(action.compareToIgnoreCase("revoke-applet-access") == 0){
            return revokeAppletAccess(request);
        }
        else
        if(action.compareToIgnoreCase("notify-user-from-app") == 0){
            return notifyUserFromApp(request);
        }
        else
        if(action.compareToIgnoreCase("add-assignment") == 0){
            return addAssignment(request);
        }
        else
        if(action.compareToIgnoreCase("get-assignment") == 0){
            return getAssignment(request);
        }
        else
        if(action.compareToIgnoreCase("update-assignment") == 0){
            return updateAssignment(request);
        }
        else
        if(action.compareToIgnoreCase("archive-assignment") == 0){
            return archiveAssignment(request);
        }
        else
        if(action.compareToIgnoreCase("check-feature-access") == 0){
            return com.feezixlabs.util.FeatureAccessManager.checkAccess(request);
        }
        else
        if(action.compareToIgnoreCase("get-binder") == 0){
            return getBinder(request);
        }
        else
        if(action.compareToIgnoreCase("get-binders") == 0){
            return net.sf.json.JSONArray.fromObject(getBinders(request)).toString();
        }
        return "";
    }
}
