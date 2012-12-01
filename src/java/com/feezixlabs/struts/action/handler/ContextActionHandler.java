/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.struts.action.handler;

import javax.servlet.http.HttpServletRequest;

import com.feezixlabs.bean.Context;
import com.feezixlabs.bean.ContextAccess;
import com.feezixlabs.util.ConfigUtil;

import org.apache.log4j.Logger;
/**
 *
 * @author bitlooter
 */
public class ContextActionHandler {

   static Logger logger = Logger.getLogger(ContextActionHandler.class.getName());

   public static String loadContextAccessGranted(HttpServletRequest request){
       int roomId = new Integer(request.getParameter("room_id"));
       int contextId = new Integer(request.getParameter("context_id"));
       int grantedTo = new Integer(request.getParameter("granted_to"));

       StringBuffer json = new StringBuffer();

        com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(),roomId);
        ContextAccess contextAccess = com.feezixlabs.db.dao.ContextAccessDAO.getContextAccess(request.getUserPrincipal().getName(),room.getId(),contextId,grantedTo);
        if(contextAccess != null){
            json.append("{\"id\":"+contextAccess.getId()+",\"access\":"+contextAccess.getAccess()+",\"pages\":[");

            java.util.List<com.feezixlabs.bean.PadAccess> padAccesses = com.feezixlabs.db.dao.PadAccessDAO.getPadAccessList(request.getUserPrincipal().getName(),room.getId(),contextAccess.getId(),grantedTo);
            int i = 0;
            for(com.feezixlabs.bean.PadAccess padAccess:padAccesses){
                json.append((i++>0?",":"")+  "{\"id\":"+padAccess.getId()+",\"access\":"+padAccess.getAccess()+"}");
            }
            json.append("]}");
        }else{
            json.append("{\"id\":"+contextId+",\"pages\":[]}");
        }
        return json.toString();
   }
   public static String loadContextACL(HttpServletRequest request){
        /*int roomId = new Integer(request.getParameter("room_id"));
        int contextId = new Integer(request.getParameter("context_id"));

        StringBuffer json = new StringBuffer();

        Context context = com.feezixlabs.db.dao.ContextDAO.getContext(request.getUserPrincipal().getName(),roomId,contextId);
        json.append("{id:"+context.getId()+",config:"+context.getConfig()+",access_control:"+context.getAccessControl()+",pages:[");

        java.util.List<com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),roomId,context.getId(),com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName()));
        int i = 0;
        for(com.feezixlabs.bean.Pad pad:pads){
            json.append((i++>0?",":"")+  "{config:"+pad.getConfig()+",id:"+pad.getId()+",access_control:"+pad.getAccessControl()+"}");
        }
        json.append("]}");
        return json.toString();*/return "";
    }

  public static String loadContextAccessGrantedList(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int grantedTo = new Integer(request.getParameter("granted_to"));

        StringBuffer json = new StringBuffer();
        json.append("[");
        java.util.List<ContextAccess> contextAccesses = com.feezixlabs.db.dao.ContextAccessDAO.getContextAccessList(request.getUserPrincipal().getName(), roomId, grantedTo);
        int j = 0;
        for(ContextAccess contextAccess:contextAccesses){

            java.util.List<com.feezixlabs.bean.PadAccess> padAccesses = com.feezixlabs.db.dao.PadAccessDAO.getPadAccessList(request.getUserPrincipal().getName(),roomId, contextAccess.getId(),grantedTo);
            int i = 0;

            json.append((j++>0?",":"")+"{\"id\":"+contextAccess.getId()+",\"access\":"+contextAccess.getAccess()+",\"pads\":[");
            for(com.feezixlabs.bean.PadAccess padAccess:padAccesses){
                json.append((i++>0?",":"")+  "{\"id\":"+padAccess.getId()+",\"access\":"+padAccess.getAccess()+",\"elements\":[");

                java.util.List<com.feezixlabs.bean.ElementAccess> elementAccesses = com.feezixlabs.db.dao.ElementAccessDAO.getElementAccessList(request.getUserPrincipal().getName(),roomId, contextAccess.getId(),padAccess.getId(),grantedTo);
                boolean bfirst = true;
                for(com.feezixlabs.bean.ElementAccess elementAccess:elementAccesses){
                    json.append((!bfirst?",":"")+  "{\"id\":"+elementAccess.getId()+",\"access\":"+elementAccess.getAccess()+"}");
                    bfirst = false;
                }
                json.append("]}");
            }
            json.append("]}");
        }
        json.append("]");
        return json.toString();
   }

   public static void takePage(HttpServletRequest request){
            String userName     = request.getUserPrincipal().getName();
            int roomId          = new Integer(request.getParameter("room_id"));
            int fromUserId      = new Integer(request.getParameter("from_user_id"));
            int contextId       = new Integer(request.getParameter("context_id"));
            int pageId          = new Integer(request.getParameter("page_id"));

            int userId = com.feezixlabs.db.dao.UserDOA.getUserId(userName);
            //int toUserId  = com.feezixlabs.db.dao.UserDOA.getUserId(toUserName);

            com.feezixlabs.bean.Context cntx = com.feezixlabs.db.dao.ContextDAO.getContext(userName, roomId, contextId,userId);
            int newContextId = com.feezixlabs.db.dao.ContextDAO.addContext(userName, roomId,cntx.getConfig(),ConfigUtil.default_binder_access);

            com.feezixlabs.bean.Pad pad = com.feezixlabs.db.dao.PadDAO.getPad(userName, roomId, contextId,pageId,fromUserId);

            net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
            jsonConfig.setJavascriptCompliant(true);

            int padId = com.feezixlabs.db.dao.PadDAO.addPad(roomId,userName, newContextId,0,0, pad.getConfig(), userId,ConfigUtil.default_page_access);

            /*update static references*/
            net.sf.json.JSONObject padJSON = net.sf.json.JSONObject.fromObject(pad.getConfig(),jsonConfig);
            if(padJSON.has("header")&& padJSON.getJSONObject("header") != null && !padJSON.getJSONObject("header").isNullObject() && padJSON.getJSONObject("header").has("static_references"))
            {
                net.sf.json.JSONArray static_references = padJSON.getJSONObject("header").getJSONArray("static_references");
                for(int i=0;i<static_references.size();i++){
                    net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);

                    Integer refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName"));
                    if(refCount == null){
                        com.feezixlabs.db.dao.StaticReferenceDAO.addReference(static_reference.getString("fileName"));
                        com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), 1);
                    }
                    else
                        com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount.intValue()+1);
                }
            }

            
            java.util.List<com.feezixlabs.bean.Element> elements = com.feezixlabs.db.dao.ElementDAO.getElements(userName, roomId, contextId, pad.getId(), fromUserId);
            for(com.feezixlabs.bean.Element e:elements){
                int elid = com.feezixlabs.db.dao.ElementDAO.addElement(userName, roomId, newContextId, padId, e.getConfig(),userId,ConfigUtil.default_element_access);

                /*update static references*/
                net.sf.json.JSONObject elementJSON = net.sf.json.JSONObject.fromObject(e.getConfig());
                if(elementJSON.has("header")&& elementJSON.getJSONObject("header") != null && !elementJSON.getJSONObject("header").isNullObject() && elementJSON.getJSONObject("header").has("static_references"))
                {
                    net.sf.json.JSONArray static_references = elementJSON.getJSONObject("header").getJSONArray("static_references");
                    for(int i=0;i<static_references.size();i++){
                        net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);
                        int refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName")).intValue()+1;
                        com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount);
                    }
                }
            }
   }

   public static void distributeContextTo(int roomId,int contextId,String userName,int toRoomId,String toUserName){
              int userId = com.feezixlabs.db.dao.UserDOA.getUserId(userName);
              int toUserId  = com.feezixlabs.db.dao.UserDOA.getUserId(toUserName);

              com.feezixlabs.bean.Context cntx = com.feezixlabs.db.dao.ContextDAO.getContext(userName, roomId, contextId,userId);
              int newContextId = com.feezixlabs.db.dao.ContextDAO.addContext(toUserName, toRoomId,cntx.getConfig(),ConfigUtil.default_binder_access);

              java.util.List<com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(userName, roomId, contextId,userId);

              net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
              jsonConfig.setJavascriptCompliant(true);

              for(com.feezixlabs.bean.Pad pad:pads){
                  int padId = com.feezixlabs.db.dao.PadDAO.addPad(toRoomId,toUserName, newContextId,pad.getParentId(),pad.getPreSibling(), pad.getConfig(), toUserId,ConfigUtil.default_page_access);

                  /*update static references*/
                  net.sf.json.JSONObject padJSON = net.sf.json.JSONObject.fromObject(pad.getConfig(),jsonConfig);
                  if(padJSON.has("header")&& padJSON.getJSONObject("header") != null && !padJSON.getJSONObject("header").isNullObject() && padJSON.getJSONObject("header").has("static_references"))
                  {
                        net.sf.json.JSONArray static_references = padJSON.getJSONObject("header").getJSONArray("static_references");
                        for(int i=0;i<static_references.size();i++){
                            net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);

                            Integer refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName"));
                            if(refCount == null){
                                com.feezixlabs.db.dao.StaticReferenceDAO.addReference(static_reference.getString("fileName"));
                                com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), 1);
                            }
                            else
                                com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount.intValue()+1);
                        }
                  }

                  java.util.List<com.feezixlabs.bean.Element> elements = com.feezixlabs.db.dao.ElementDAO.getElements(userName, roomId, contextId, pad.getId(), userId);
                  for(com.feezixlabs.bean.Element e:elements){

                      int elid = com.feezixlabs.db.dao.ElementDAO.addElement(toUserName, toRoomId, newContextId, padId, e.getConfig(),toUserId,ConfigUtil.default_element_access);

                      /*update static references*/
                      net.sf.json.JSONObject elementJSON = net.sf.json.JSONObject.fromObject(e.getConfig());
                      if(elementJSON.has("header")&& elementJSON.getJSONObject("header") != null && !elementJSON.getJSONObject("header").isNullObject() && elementJSON.getJSONObject("header").has("static_references"))
                      {
                            net.sf.json.JSONArray static_references = elementJSON.getJSONObject("header").getJSONArray("static_references");
                            for(int i=0;i<static_references.size();i++){
                                net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);
                                int refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName")).intValue()+1;
                                com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount);
                            }
                      }
                  }
              }
   }
   public static void distributeContext(int roomId,int contextId,String userName){
       int userId = com.feezixlabs.db.dao.UserDOA.getUserId(userName);
       for(com.feezixlabs.bean.Participant p:com.feezixlabs.db.dao.ParticipantDAO.getParticipants(roomId)){
           if(p.getUserId() != userId){
              int newContextId = com.feezixlabs.db.dao.ContextDAO.distributeContext(userName,roomId,p.getUserId(),contextId);
              java.util.List<com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(userName, roomId, contextId,userId);

              net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
              jsonConfig.setJavascriptCompliant(true);

              for(com.feezixlabs.bean.Pad pad:pads){
                  int padId = com.feezixlabs.db.dao.PadDAO.addPad(roomId,p.getUserName(), newContextId,pad.getParentId(),pad.getPreSibling(), pad.getConfig(), p.getUserId(),ConfigUtil.default_page_access);

                  /*update static references*/
                  net.sf.json.JSONObject padJSON = net.sf.json.JSONObject.fromObject(pad.getConfig(),jsonConfig);
                  if(padJSON.has("header")&& padJSON.getJSONObject("header") != null && !padJSON.getJSONObject("header").isNullObject() && padJSON.getJSONObject("header").has("static_references"))
                  {
                        net.sf.json.JSONArray static_references = padJSON.getJSONObject("header").getJSONArray("static_references");
                        for(int i=0;i<static_references.size();i++){
                            net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);

                            Integer refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName"));
                            if(refCount == null){
                                com.feezixlabs.db.dao.StaticReferenceDAO.addReference(static_reference.getString("fileName"));
                                com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), 1);
                            }
                            else
                                com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount.intValue()+1);
                        }
                  }

                  java.util.List<com.feezixlabs.bean.Element> elements = com.feezixlabs.db.dao.ElementDAO.getElements(userName, roomId, contextId, pad.getId(), userId);
                  for(com.feezixlabs.bean.Element e:elements){

                      int elid = com.feezixlabs.db.dao.ElementDAO.addElement(p.getUserName(), roomId, newContextId, padId, e.getConfig(), p.getUserId(),ConfigUtil.default_element_access);

                      /*update static references*/
                      net.sf.json.JSONObject elementJSON = net.sf.json.JSONObject.fromObject(e.getConfig());
                      if(elementJSON.has("header") && elementJSON.getJSONObject("header") != null && !elementJSON.getJSONObject("header").isNullObject() && elementJSON.getJSONObject("header").has("static_references"))
                      {
                            net.sf.json.JSONArray static_references = elementJSON.getJSONObject("header").getJSONArray("static_references");
                            for(int i=0;i<static_references.size();i++){
                                net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);
                                int refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName")).intValue()+1;
                                com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount);
                            }
                      }
                  }
              }
           }
       }
   }

   public static String distributeContextTo(HttpServletRequest request){
          int roomId = new Integer(request.getParameter("room_id"));
          int userId = new Integer(request.getParameter("toUser"));
          int contextId = new Integer(request.getParameter("context_id"));

          com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);
          com.feezixlabs.bean.Participant fromParticipant = com.feezixlabs.db.dao.ParticipantDAO.getParticipant(roomId,com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName()));

          com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUserById(userId);
          com.feezixlabs.bean.Participant toParticipant = com.feezixlabs.db.dao.ParticipantDAO.getParticipant(roomId, userId);

          if(fromParticipant == null || toParticipant == null)
              return "{\"status\":\"failure\", \"msg\":\"You can only distribute content to users in the same room as you.\"}";

          if((!request.isUserInRole("sysadmin") && !request.isUserInRole("educator")) && fromParticipant.getUserId() != room.getUserId())
              return "{\"status\":\"failure\", \"msg\":\"You can only distribute content to users you are the room creator.\"}";

          ContextActionHandler.distributeContextTo(roomId, contextId, request.getUserPrincipal().getName(), roomId, user.getUserName());

          return "{\"status\":\"success\"}";
   }

   public static String submitAssignment(HttpServletRequest request){
              int roomId = new Integer(request.getParameter("room_id"));
              int contextId = new Integer(request.getParameter("context_id"));
              int padId = new Integer(request.getParameter("pad_id"));
              int assignmentId = new Integer(request.getParameter("assignment_id"));
              
              boolean overrideExisting = request.getParameter("overrideExisting") != null && request.getParameter("overrideExisting").length()>0 ? Boolean.parseBoolean(request.getParameter("overrideExisting")):false;
              int overrideContextId = request.getParameter("overrideContextId") != null && request.getParameter("overrideContextId").length()>0 ? Integer.parseInt(request.getParameter("overrideContextId")):0;

              net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
              jsonConfig.setJavascriptCompliant(true);

              com.feezixlabs.bean.Assignment assignment = com.feezixlabs.db.dao.AssignmentDAO.getAssignmentIfOpen(request.getUserPrincipal().getName(), roomId, assignmentId);
              if(assignment == null){
                  return "{\"status\":\"failure\"}";
              }

              int userId = com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName());


              java.util.List<com.feezixlabs.bean.AssignmentSubmission> assignmentSubmissions = com.feezixlabs.db.dao.AssignmentSubmissionDAO.getAssignmentSubmittedFromSource(request.getUserPrincipal().getName(), roomId,contextId, padId);
              if(assignment.getAllowVersioning().compareTo("no") == 0 || assignment.getVersioningLimit()==0){
                  if(assignmentSubmissions.size()>0){
                      if(overrideExisting){
                        for(com.feezixlabs.bean.AssignmentSubmission assignmentSubmission:assignmentSubmissions){
                            if(assignmentSubmission.getContextId() == overrideContextId){
                                com.feezixlabs.db.dao.AssignmentSubmissionDAO.deleteAssignmentSubmission(request.getUserPrincipal().getName(), roomId,assignment.getId(),assignmentSubmission.getContextId());
                                com.feezixlabs.db.dao.ContextDAO.deleteContext(request.getUserPrincipal().getName(), roomId, assignmentSubmission.getContextId(), userId);
                                break;
                            }
                        }
                      }else{
                          //return "{\"status\":\"failure\",\"msg\":\"A submission already exists for this document.\"}";
                          return "{\"status\":\"failure\",\"versioning_not_allowed\":true, \"msg\":\"A submission already exists for this document, do you want to overwrite it?\"}";
                      }
                  }
              }else{
                    if(assignmentSubmissions.size()>0 && assignmentSubmissions.size()>=assignment.getVersioningLimit()){
                          if(overrideExisting){
                            for(com.feezixlabs.bean.AssignmentSubmission assignmentSubmission:assignmentSubmissions){
                                if(assignmentSubmission.getContextId() == overrideContextId){
                                    com.feezixlabs.db.dao.AssignmentSubmissionDAO.deleteAssignmentSubmission(request.getUserPrincipal().getName(), roomId,assignment.getId(),assignmentSubmission.getContextId());
                                    com.feezixlabs.db.dao.ContextDAO.deleteContext(request.getUserPrincipal().getName(), roomId, assignmentSubmission.getContextId(), userId);
                                    break;
                                }
                            }
                          }else{
                              //return "{\"status\":\"failure\",\"msg\":\"A submission already exists for this document.\"}";
                              return "{\"status\":\"failure\",\"versioning_limit_reached\":true, \"msg\":\"Submission limit reached, please select a previous submission to overwrite.\"}";
                          }
                    }
              }

              com.feezixlabs.bean.User educator = com.feezixlabs.db.dao.UserDOA.getUserById(assignment.getUserId());

              


              com.feezixlabs.bean.Context cntx = com.feezixlabs.db.dao.ContextDAO.getContext(request.getUserPrincipal().getName(), roomId, contextId,userId);

              net.sf.json.JSONObject cntxJSON = net.sf.json.JSONObject.fromObject(cntx.getConfig(),jsonConfig);
              if(!cntxJSON.has("header") || cntxJSON.getJSONObject("header") == null || cntxJSON.getJSONObject("header").isNullObject())
                cntxJSON.put("header", new java.util.HashMap());

              cntxJSON.getJSONObject("header").put("is_assignment_submission", true);
              cntxJSON.put("title",assignment.getName());

              int newContextId = com.feezixlabs.db.dao.ContextDAO.addContext(educator.getUserName(), roomId,cntxJSON.toString(),ConfigUtil.ACCESS_NONE);

              java.util.List<com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(), roomId, contextId,userId);


              boolean end = false;
              for(com.feezixlabs.bean.Pad pad:pads){
                  if(padId != 0){
                      if(pad.getId() == padId)
                            end = true;
                      else
                          continue;
                  }


                  int newpadId = com.feezixlabs.db.dao.PadDAO.addPad(roomId,educator.getUserName(), newContextId,pad.getParentId(),pad.getPreSibling(), pad.getConfig(), educator.getId(),ConfigUtil.ACCESS_NONE);

                  /*update static references*/
                  net.sf.json.JSONObject padJSON = net.sf.json.JSONObject.fromObject(pad.getConfig(),jsonConfig);
                  if(padJSON.has("header") && padJSON.getJSONObject("header") != null && !padJSON.getJSONObject("header").isNullObject() && padJSON.getJSONObject("header").has("static_references"))
                  {
                        net.sf.json.JSONArray static_references = padJSON.getJSONObject("header").getJSONArray("static_references");
                        for(int i=0;i<static_references.size();i++){
                            net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);

                            Integer refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName"));
                            if(refCount == null){
                                com.feezixlabs.db.dao.StaticReferenceDAO.addReference(static_reference.getString("fileName"));
                                com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), 1);
                            }
                            else
                                com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount.intValue()+1);
                        }
                  }


                  java.util.List<com.feezixlabs.bean.Element> elements = com.feezixlabs.db.dao.ElementDAO.getElements(request.getUserPrincipal().getName(), roomId, contextId, pad.getId(), userId);
                  for(com.feezixlabs.bean.Element e:elements){

                      int elid = com.feezixlabs.db.dao.ElementDAO.addElement(educator.getUserName(), roomId, newContextId, newpadId, e.getConfig(),educator.getId(),ConfigUtil.ACCESS_NONE);

                      /*update static references*/
                      net.sf.json.JSONObject elementJSON = net.sf.json.JSONObject.fromObject(e.getConfig());
                      if(elementJSON.has("header") && elementJSON.getJSONObject("header") != null && !elementJSON.getJSONObject("header").isNullObject() && elementJSON.getJSONObject("header").has("static_references"))
                      {
                            net.sf.json.JSONArray static_references = elementJSON.getJSONObject("header").getJSONArray("static_references");
                            for(int i=0;i<static_references.size();i++){
                                net.sf.json.JSONObject static_reference = static_references.getJSONObject(i);
                                int refCount = com.feezixlabs.db.dao.StaticReferenceDAO.getReference(static_reference.getString("fileName")).intValue()+1;
                                com.feezixlabs.db.dao.StaticReferenceDAO.updateReference(static_reference.getString("fileName"), refCount);
                            }
                      }
                  }
                  if(end)break;
              }

              com.feezixlabs.db.dao.AssignmentSubmissionDAO.addAssignmentSubmission(request.getUserPrincipal().getName(), roomId, assignmentId, newContextId, contextId, padId);
              return "{status:'success'}";
   }

   public static void systemDistributeContext(HttpServletRequest request){
       if(request.isUserInRole("sysadmin")){
           int roomId = new Integer(request.getParameter("room_id"));
           int contextId = new Integer(request.getParameter("context_id"));
           String userName = request.getUserPrincipal().getName();
           
           com.feezixlabs.db.dao.MiscDAO.setTextData("welcome-context", userName+","+roomId+","+contextId);
       }
   }

   public static String distributeContext(HttpServletRequest request){
       if(request.getParameter("toUser") != null && new Integer(request.getParameter("toUser")).intValue()>0)return distributeContextTo(request);

       /*if(request.isUserInRole("sysadmin")||request.isUserInRole("educator"))*/{
           int roomId = new Integer(request.getParameter("room_id"));
           int contextId = new Integer(request.getParameter("context_id"));           
           String userName = request.getUserPrincipal().getName();

           com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);
           com.feezixlabs.bean.Participant fromParticipant = com.feezixlabs.db.dao.ParticipantDAO.getParticipant(roomId,com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName()));

           if((!request.isUserInRole("sysadmin") && !request.isUserInRole("educator")) && fromParticipant.getUserId() != room.getUserId())
              return "{\"status\":\"failure\", \"msg\":\"You can only distribute content to users if you are the room creator or an educator.\"}";

           distributeContext(roomId,contextId,userName);
       }return "{status:'success'}";
   }

    static String addNewWorkBook(HttpServletRequest request){
        boolean teamSpace = request.getParameter("teamspace") !=null && request.getParameter("teamspace").compareTo("true")==0;
        if(com.feezixlabs.util.FeatureAccessManager.hasAccess("create binder", request) && (!teamSpace || com.feezixlabs.util.FeatureAccessManager.hasAccess("use teamspace", request))){
            int roomId = new Integer(request.getParameter("room_id"));
            String config = request.getParameter("config");
            return "{\"status\":\"success\",\"id\":"+com.feezixlabs.db.dao.ContextDAO.addContext(request.getUserPrincipal().getName(),roomId, config,ConfigUtil.default_binder_access)+"}";
        }else
        if(!com.feezixlabs.util.FeatureAccessManager.hasAccess("create binder", request))
        {
            return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"You have exceeded the maximum number of binders on your account, Please upgrade your account for unlimited binders.\"}";
        }else{
            return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"You don't have access to the teamspace feature, Please upgrade your account for unlimited access.\"}";
        }
    }
    static void updateContext(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int grantor = new Integer(request.getParameter("grantor"));
        int contextId = new Integer(request.getParameter("context_id"));
        String config     = request.getParameter("config");
        com.feezixlabs.db.dao.ContextDAO.updateContext(request.getUserPrincipal().getName(), roomId, contextId, config, grantor);
    }
    static void deleteContext(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int grantor = new Integer(request.getParameter("grantor"));
        int contextId = new Integer(request.getParameter("context_id"));
        com.feezixlabs.db.dao.ContextDAO.deleteContext(request.getUserPrincipal().getName(), roomId, contextId,grantor);
    }
    static void updateContextAccess(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int contextId = new Integer(request.getParameter("context_id"));
        int grantedTo = new Integer(request.getParameter("granted_to"));
        int accessControl = new Integer(request.getParameter("access"));
        com.feezixlabs.db.dao.ContextAccessDAO.updateContextAccess(request.getUserPrincipal().getName(), roomId, contextId, grantedTo, accessControl);
    }

     static String markAssignmentAsGraded(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int contextId = new Integer(request.getParameter("context_id"));
        int grantedTo = new Integer(request.getParameter("granted_to"));
        int userId = com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName());

        com.feezixlabs.db.dao.ContextAccessDAO.updateContextAccess(request.getUserPrincipal().getName(), roomId, contextId, grantedTo,ConfigUtil.ACCESS_READ);

        java.util.List<com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(), roomId, contextId,userId);
        for(com.feezixlabs.bean.Pad pad:pads){
          com.feezixlabs.db.dao.PadAccessDAO.updatePadAccess(request.getUserPrincipal().getName(), roomId, contextId, pad.getId(), grantedTo, ConfigUtil.ACCESS_READ);

          java.util.List<com.feezixlabs.bean.Element> elements = com.feezixlabs.db.dao.ElementDAO.getElements(request.getUserPrincipal().getName(), roomId, contextId, pad.getId(), userId);
          for(com.feezixlabs.bean.Element e:elements){
            com.feezixlabs.db.dao.ElementAccessDAO.updateElementAccess(request.getUserPrincipal().getName(), roomId, contextId, e.getPadId(), e.getId(),userId, grantedTo, ConfigUtil.ACCESS_READ);
          }
       }
       return "{\"status\":\"success\"}";
    }

    public static String messagePump(HttpServletRequest request){
        String action = request.getParameter("action");
        if(action.compareToIgnoreCase("add-context") == 0){
            return addNewWorkBook(request);
        }
        else
        if(action.compareToIgnoreCase("update-context") == 0){
            updateContext(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("del-context") == 0){
            deleteContext(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("update-context-access") == 0){
            updateContextAccess(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("get-context-acl") == 0){
            return loadContextACL(request);
        }
        else
        if(action.compareToIgnoreCase("get-context-access-list") == 0){
            return loadContextAccessGrantedList(request);
        }
        else
        if(action.compareToIgnoreCase("get-context-access") == 0){
            return loadContextAccessGranted(request);
        }
        else
        if(action.compareToIgnoreCase("distribute-context") == 0){
            return distributeContext(request);
        }
        else
        if(action.compareToIgnoreCase("distribute-context-to") == 0){
            return distributeContextTo(request);
        }
        else
        if(action.compareToIgnoreCase("sys-distribute-context") == 0){
            systemDistributeContext(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("submit-assignment") == 0){
            return submitAssignment(request);
        }
        else
        if(action.compareToIgnoreCase("mark-assignment-as-graded") == 0){
            return markAssignmentAsGraded(request);
        }
        return "";
    }
}
