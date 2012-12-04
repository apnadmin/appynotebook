<%-- 
    Document   : tree
    Created on : Jan 10, 2011, 8:34:02 PM
    Author     : bitlooter
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%><%--
    int ACCESS_MODE_WRITE = 2;

    int userId = com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName());
    int currentRoomId = new Integer(request.getParameter("room_id"));
    boolean bfirst = true;
    StringBuffer buf = new StringBuffer();
    java.util.List<com.feezixlabs.bean.Room> rooms = com.feezixlabs.db.dao.RoomDAO.getRooms(request.getUserPrincipal().getName());
    for(com.feezixlabs.bean.Room room:rooms){
        String turl = "index.jsp?room_id="+room.getId()+"&ts="+(new java.util.Date()).getTime();
        if(room.getId() != currentRoomId){
            buf.append((!bfirst?",":"")+"{\"addClass\":\"phyzixlabs-room-inactive\",\"type\":\"inactive-room\",\"title\":\""+room.getTitle()+"\",\"url\":\""+turl+"\"}");
            bfirst = false;
        }
        else        
        {            
            buf.append((!bfirst?",":"")+"{\"isFolder\":true,\"addClass\":\"vroomtitle\",\"type\":\"header\",\"key\":\"room_header\",\"title\":\""+room.getTitle()+"\",\"url\":\""+turl+"\",\"children\":[");

            boolean bfirst1 = true;
            java.util.List<com.feezixlabs.bean.Participant> participants = com.feezixlabs.db.dao.ParticipantDAO.getParticipants(room.getId());
            for(com.feezixlabs.bean.Participant participant:participants){
                String nodeClass = "";
                if(userId == room.getUserId()){
                    if(participant.getUserId() == userId)
                        nodeClass = "creatoronlineperson";
                    else
                        nodeClass = "offlineperson-creator-cp";
                }else{
                    if(participant.getUserId() == userId)
                        nodeClass = "selfonlineperson";
                    else
                        nodeClass = "offlineperson";
                }
                buf.append((!bfirst1?",":"")+"{\"isFolder\":true,\"addClass\":\""+nodeClass+"\",\"key\":\"key-"+participant.getUserId()+"\",\"id\":"+participant.getUserId()+",\"title\":\""+participant.getName()+"\",\"type\":\"participant\",\"children\":[");

                
                boolean bfirst2 = true;
                java.util.List<com.feezixlabs.bean.Context> contexts = com.feezixlabs.db.dao.ContextDAO.getContexts(request.getUserPrincipal().getName(),room.getId(),participant.getUserId());
                for(com.feezixlabs.bean.Context context:contexts){
                    String nodeClass1 = participant.getUserId()==userId?"docnode":"fdocnode";

                    String title = ""+net.sf.json.JSONObject.fromObject(context.getConfig()).get("title");
                    buf.append((!bfirst2?",":"")+"{\"isFolder\":true,\"addClass\":\""+nodeClass1+"\",\"key\":\"key-"+participant.getUserId()+"-"+context.getId()+"\",\"pid\":"+participant.getUserId()+",\"id\":"+context.getId()+",\"title\":\""+title+"\",\"type\":\"context\",\"children\":[");

                    
                    boolean bfirst3 = true;
                    java.util.List<com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),room.getId(),context.getId(),participant.getUserId());
                    for(com.feezixlabs.bean.Pad pad:pads){
                        title = ""+net.sf.json.JSONObject.fromObject(pad.getConfig()).get("title");
                        boolean write_access = (context.getAccess()&ACCESS_MODE_WRITE)>0 || (pad.getAccess()&ACCESS_MODE_WRITE)>0 || (context.getAccess()&ACCESS_MODE_WRITE)>0 || (pad.getAccess()&ACCESS_MODE_WRITE)>0;
                        String nodeClass2 = write_access?"padnode":"padnode0";
                        buf.append((!bfirst3?",":"")+"{\"isFolder\":false,\"addClass\":\""+nodeClass2+"\",\"key\":\"key-"+participant.getUserId()+"-"+context.getId()+"-"+pad.getId()+"\",\"pid\":"+participant.getUserId()+",\"context_id\":"+context.getId()+",\"id\":"+pad.getId()+",\"embed_key\":\""+pad.getEmbedKey()+"\",\"title\":\""+title+"\",\"type\":\"pad\"}");
                        bfirst3 = false;
                    }
                    
                    buf.append("]}");

                    bfirst2 = false;
                }
                
                buf.append("]}");
                

                bfirst1 = false;
            }
            buf.append("]}");
        }
        bfirst = false;
    }
    //System.out.println(buf.toString());
%>
<%="[{\"isFolder\":true,\"isLazy\":false,\"children\":["+buf.toString()+"],\"addClass\":\"phyzixlabs-room-root\",\"key\":\"room_header_root\", \"title\":\"Your Rooms\",\"type\":\"header_root\"}]"--%>

<%
    int ACCESS_MODE_WRITE = 2;

    com.feezixlabs.util.PadSorter padSorter;
    
    int userId = com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName());
    int currentRoomId = new Integer(request.getParameter("room_id"));
    boolean bfirst = true;
    String activeRoomName = "";
    StringBuffer buf = new StringBuffer();
    java.util.List<com.feezixlabs.bean.Room> rooms = com.feezixlabs.db.dao.RoomDAO.getRooms(request.getUserPrincipal().getName());

    net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
    jsonConfig.setJavascriptCompliant(true);

    com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());

    boolean teamSpaceAccess = true;//com.feezixlabs.util.FeatureAccessManager.hasAccess("use teamspace", request);
    boolean taskAccess = true;//request.isUserInRole("sysadmin") || com.feezixlabs.util.ConfigUtil.institutional_instance || (user.getPlan() != null && user.getPlan().compareTo("basic") != 0);

    for(com.feezixlabs.bean.Room room:rooms){
        String turl = "index.jsp?room_id="+room.getId()+"&ts="+(new java.util.Date()).getTime();
        if(room.getId() != currentRoomId){
            //buf.append((!bfirst?",":"")+"{\"addClass\":\"phyzixlabs-room-inactive\",\"type\":\"inactive-room\",\"title\":\""+room.getTitle()+"\",\"url\":\""+turl+"\"}");
            bfirst = false;
        }
        else
        {
            activeRoomName = room.getTitle().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"");
            //buf.append((!bfirst?",":"")+"{\"isFolder\":true,\"addClass\":\"vroomtitle\",\"type\":\"header\",\"key\":\"room_header\",\"title\":\""+room.getTitle()+"\",\"url\":\""+turl+"\",\"children\":[");

            boolean showingTasks = false;
            if( (taskAccess) && (request.isUserInRole("educator") || request.isUserInRole("sysadmin") || room.getUserId() == userId)){
                buf.append("{\"isFolder\":true,\"addClass\":\"phyzixlabs-room-assignment-root\",\"key\":\"key-assignment-root\",\"id\":-2,\"title\":\"Tasks\",\"type\":\"assignment-root\",\"children\":[");
                java.util.List<com.feezixlabs.bean.Assignment> assignments = com.feezixlabs.db.dao.AssignmentDAO.getAssignments(request.getUserPrincipal().getName(), room.getId());

                boolean bfirstAssignment = true;
                for(com.feezixlabs.bean.Assignment assignment:assignments){
                    buf.append((!bfirstAssignment?",":"")+"{\"isFolder\":true,\"addClass\":\"phyzixlabs-room-assignment\",\"key\":\"key-assignment-"+assignment.getId()+"\",\"id\":"+assignment.getId()+",\"title\":\""+assignment.getName().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\",\"type\":\"assignment\",\"children\":[");
                    java.util.List<com.feezixlabs.bean.AssignmentSubmission> assignmentSubmmissions = com.feezixlabs.db.dao.AssignmentSubmissionDAO.getAssignmentSubmissions(request.getUserPrincipal().getName(), room.getId(),assignment.getId());
                    boolean bfirstAssignmentSubmission = true;
                    for(com.feezixlabs.bean.AssignmentSubmission assignmentSubmission:assignmentSubmmissions){
                          com.feezixlabs.bean.Context context = com.feezixlabs.db.dao.ContextDAO.getContext(request.getUserPrincipal().getName(),room.getId(),assignmentSubmission.getContextId(),assignment.getUserId());
                          com.feezixlabs.bean.User submittedByUser = com.feezixlabs.db.dao.UserDOA.getUserById(assignmentSubmission.getUserId());

                          //see if access has been assignment to user who submitted it, this indicates that it has been graded
                          com.feezixlabs.bean.Context contextGraded = com.feezixlabs.db.dao.ContextDAO.getContext(submittedByUser.getUserName(),room.getId(),assignmentSubmission.getContextId(),assignment.getUserId());
                          String addClass = "phyzixlabs-room-assignment-submission";
                          if(contextGraded != null)
                              addClass = "phyzixlabs-room-assignment-submission-graded";


                          buf.append((!bfirstAssignmentSubmission?",":"")+"{\"isFolder\":true,\"addClass\":\""+addClass+"\",\"key\":\"key-"+context.getParticipantId()+"-"+context.getId()+"\",\"user_id\":"+assignmentSubmission.getUserId()+",\"context_id\":"+context.getId()+",\"title\":\""+submittedByUser.getName().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\",\"type\":\"phyzixlabs-room-assignment-submission\",\"children\":[");
                          java.util.List<com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),room.getId(),context.getId(),context.getParticipantId());
                          boolean bfirstPad = true;
                          for(com.feezixlabs.bean.Pad pad:pads){
                            String title = net.sf.json.JSONObject.fromObject(pad.getConfig(),jsonConfig).get("title").toString().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"");
                            boolean write_access = (context.getAccess()&ACCESS_MODE_WRITE)>0 || (pad.getAccess()&ACCESS_MODE_WRITE)>0 || (context.getAccess()&ACCESS_MODE_WRITE)>0 || (pad.getAccess()&ACCESS_MODE_WRITE)>0;
                            //System.out.println("write access:"+write_access+" pad access:"+pad.getAccess());
                            
                            String nodeClass2 = write_access?"padnode":"padnode0";
                            buf.append((!bfirstPad?",":"")+"{\"isFolder\":false,\"addClass\":\""+nodeClass2+"\",\"key\":\"key-"+pad.getParticipantId()+"-"+context.getId()+"-"+pad.getId()+"\",\"pid\":"+pad.getParticipantId()+",\"context_id\":"+context.getId()+",\"id\":"+pad.getId()+",\"embed_key\":\""+pad.getEmbedKey()+"\",\"title\":\""+title+"\",\"type\":\"pad\"}");
                            bfirstPad = false;
                          }
                          buf.append("]}");

                          bfirstAssignmentSubmission = false;
                    }
                    bfirstAssignment = false;
                    buf.append("]}");
                }
                buf.append("]}");
                showingTasks = true;
            }
            

            boolean bfirst1 = true;
            if(teamSpaceAccess)
                buf.append((showingTasks?",":"")+ "{\"isFolder\":true,\"addClass\":\"phyzixlabs-room-teamspace\",\"key\":\"key-teamspace\",\"id\":-1,\"title\":\"Team Space\",\"type\":\"teamspace\",\"children\":[");
            StringBuffer  contextBuf = new StringBuffer();
            

            java.util.List<com.feezixlabs.bean.Participant> participants = com.feezixlabs.db.dao.ParticipantDAO.getParticipants(room.getId());
            for(com.feezixlabs.bean.Participant participant:participants){
                String nodeClass = "";
                if(userId == room.getUserId()){
                    if(participant.getUserId() == userId)
                        nodeClass = "creatoronlineperson";
                    else
                        nodeClass = "offlineperson-creator-cp";
                }else{
                    if(participant.getUserId() == userId)
                        nodeClass = "selfonlineperson";
                    else
                        nodeClass = "offlineperson";
                }

                contextBuf.append((!bfirst1?",":"")+"{\"isFolder\":true,\"addClass\":\""+nodeClass+"\",\"key\":\"key-"+participant.getUserId()+"\",\"id\":"+participant.getUserId()+",\"title\":\""+participant.getName().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\",\"type\":\"participant\",\"children\":[");

                boolean bfirst2 = true;
                boolean bfirstTeamSpace = true;
                java.util.List<com.feezixlabs.bean.Context> contexts = com.feezixlabs.db.dao.ContextDAO.getContexts(request.getUserPrincipal().getName(),room.getId(),participant.getUserId());
                for(com.feezixlabs.bean.Context context:contexts){
                    boolean teamSpace = false;
                    net.sf.json.JSONObject cntxJSON = net.sf.json.JSONObject.fromObject(context.getConfig(),jsonConfig);
                    if(cntxJSON.has("header") && cntxJSON.getJSONObject("header").has("is_assignment_submission"))
                    continue;

                    try{
                        teamSpace = teamSpaceAccess && (context.getParticipantId() == room.getUserId() && net.sf.json.JSONObject.fromObject(context.getConfig(),jsonConfig).get("teamspace") != null && net.sf.json.JSONObject.fromObject(context.getConfig(),jsonConfig).getBoolean("teamspace"));
                    }catch(Exception ex){}

                    String nodeClass1 = participant.getUserId()==userId?"docnode":"fdocnode";
                    String title = net.sf.json.JSONObject.fromObject(context.getConfig(),jsonConfig).get("title").toString().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"");

                    if(teamSpace)
                      buf.append((!bfirstTeamSpace?",":"")+"{\"isFolder\":true,\"addClass\":\"phyzixlabs-room-teamspace-binder\",\"key\":\"key-"+participant.getUserId()+"-"+context.getId()+"\",\"pid\":"+participant.getUserId()+",\"id\":"+context.getId()+",\"title\":\""+title+"\",\"type\":\"context\",\"children\":[");
                    else{
                        contextBuf.append((!bfirst2?",":"")+"{\"isFolder\":true,\"addClass\":\""+nodeClass1+"\",\"key\":\"key-"+participant.getUserId()+"-"+context.getId()+"\",\"pid\":"+participant.getUserId()+",\"id\":"+context.getId()+",\"title\":\""+title+"\",\"type\":\"context\",\"children\":[");
                        bfirst2 = false;    
                    }


                    boolean bfirst3 = true;
                    java.util.List<com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),room.getId(),context.getId(),participant.getUserId());
                    padSorter = new com.feezixlabs.util.PadSorter(pads.size());
                    java.util.List<com.feezixlabs.bean.Pad> sortedPads = padSorter.topo(pads);
                    com.feezixlabs.bean.Pad rootPad = new com.feezixlabs.bean.Pad();
                    //rootPad.setChildren(sortedPads);
                    //com.feezixlabs.struts.action.handler.PadActionHandler.convertToTree(rootPad, sortedPads);
                    
                    for(com.feezixlabs.bean.Pad pad:pads){
                          title = net.sf.json.JSONObject.fromObject(pad.getConfig(),jsonConfig).get("title").toString().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"");
                          boolean write_access = (context.getAccess()&ACCESS_MODE_WRITE)>0 || (pad.getAccess()&ACCESS_MODE_WRITE)>0 || (context.getAccess()&ACCESS_MODE_WRITE)>0 || (pad.getAccess()&ACCESS_MODE_WRITE)>0;
                          String nodeClass2 = write_access?"padnode":"padnode0";
                          (teamSpace?buf:contextBuf).append((!bfirst3?",":"")+"{\"isFolder\":true,\"addClass\":\""+nodeClass2+"\",\"key\":\"key-"+participant.getUserId()+"-"+context.getId()+"-"+pad.getId()+"\",\"pid\":"+participant.getUserId()+",\"context_id\":"+context.getId()+",\"id\":"+pad.getId()+",\"embed_key\":\""+pad.getEmbedKey()+"\",\"title\":\""+title+"\",\"type\":\"pad\",\"children\":[");
                          

                          ////////////////////////////////////////////////////////////////////////////////////////
                          //append any assignment submission related to this pad

                          if(userId == participant.getUserId()){
                              java.util.List<com.feezixlabs.bean.AssignmentSubmission> assignmentSubmissions = com.feezixlabs.db.dao.AssignmentSubmissionDAO.getAssignmentSubmittedFromSource(request.getUserPrincipal().getName(), room.getId(),context.getId(), pad.getId());
                              boolean bfirstAssignmentSubmission = true;
                              for(com.feezixlabs.bean.AssignmentSubmission assignmentSubmission:assignmentSubmissions){
                                  
                                  com.feezixlabs.bean.Assignment submittedToAssignment = com.feezixlabs.db.dao.AssignmentDAO.getAssignment(request.getUserPrincipal().getName(), room.getId(), assignmentSubmission.getAssignmentId());
                                  com.feezixlabs.bean.Context assignmentContext = com.feezixlabs.db.dao.ContextDAO.getContext(request.getUserPrincipal().getName(),room.getId(),assignmentSubmission.getContextId(),submittedToAssignment.getUserId());

                                  //(teamSpace?buf:contextBuf).append((!bfirstAssignmentSubmission?",":"")+ "{\"isFolder\":true,\"addClass\":\"phyzixlabs-room-assignment-submitted\",\"key\":\"key-"+assignmentContext.getParticipantId()+"-"+assignmentContext.getId()+"\",\"pid\":"+assignmentContext.getParticipantId()+",\"id\":"+assignmentContext.getId()+",\"title\":\""+submittedToAssignment.getName().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\",\"type\":\"phyzixlabs-room-assignment-submitted\",\"children\":[");
                                  (teamSpace?buf:contextBuf).append((!bfirstAssignmentSubmission?",":"")+ "{\"isFolder\":true,\"addClass\":\"phyzixlabs-room-assignment-submitted\",\"title\":\""+submittedToAssignment.getName().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\",\"type\":\"phyzixlabs-room-assignment-submitted\",\"children\":[");
                                  if(assignmentContext != null){
                                      java.util.List<com.feezixlabs.bean.Pad> assignmentPads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),room.getId(),assignmentContext.getId(),assignmentContext.getParticipantId());
                                      boolean bfirstPad = true;
                                      for(com.feezixlabs.bean.Pad assignmentPad:assignmentPads){
                                        String padTitle = net.sf.json.JSONObject.fromObject(assignmentPad.getConfig(),jsonConfig).get("title").toString().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"");
                                        boolean write_accessx = (assignmentContext.getAccess()&ACCESS_MODE_WRITE)>0 || (assignmentPad.getAccess()&ACCESS_MODE_WRITE)>0 || (assignmentContext.getAccess()&ACCESS_MODE_WRITE)>0 || (assignmentPad.getAccess()&ACCESS_MODE_WRITE)>0;
                                        String nodeClass2x = write_accessx?"padnode":"padnode0";
                                        (teamSpace?buf:contextBuf).append((!bfirstPad?",":"")+"{\"isFolder\":false,\"addClass\":\""+nodeClass2x+"\",\"key\":\"key-"+assignmentPad.getParticipantId()+"-"+assignmentContext.getId()+"-"+assignmentPad.getId()+"\",\"pid\":"+assignmentPad.getParticipantId()+",\"context_id\":"+assignmentContext.getId()+",\"id\":"+assignmentPad.getId()+",\"embed_key\":\""+assignmentPad.getEmbedKey()+"\",\"title\":\""+padTitle+"\",\"type\":\"pad\"}");
                                        bfirstPad = false;
                                      }
                                  }
                                  (teamSpace?buf:contextBuf).append("]}");
                                  bfirstAssignmentSubmission = false;
                              }
                          }
                          ////////////////////////////////////////////////////////////////////////////////////////
                          (teamSpace?buf:contextBuf).append("]}");
                          bfirst3 = false;
                    }

                      ////////////////////////////////////////////////////////////////////////////////////////
                      //append any assignment submission related to this context

                      if(userId == participant.getUserId()){
                          java.util.List<com.feezixlabs.bean.AssignmentSubmission> assignmentSubmissions = com.feezixlabs.db.dao.AssignmentSubmissionDAO.getAssignmentSubmittedFromSource(request.getUserPrincipal().getName(), room.getId(),context.getId(), 0);
                          for(com.feezixlabs.bean.AssignmentSubmission assignmentSubmission:assignmentSubmissions){
                                  
                                  com.feezixlabs.bean.Assignment submittedToAssignment = com.feezixlabs.db.dao.AssignmentDAO.getAssignment(request.getUserPrincipal().getName(), room.getId(), assignmentSubmission.getAssignmentId());
                                  com.feezixlabs.bean.User assignmentUser = com.feezixlabs.db.dao.UserDOA.getUserById(submittedToAssignment.getUserId());
                                  com.feezixlabs.bean.Context assignmentContext = com.feezixlabs.db.dao.ContextDAO.getContext(request.getUserPrincipal().getName(),room.getId(),assignmentSubmission.getContextId(),submittedToAssignment.getUserId());

                                  //(teamSpace?buf:contextBuf).append((pads.size()>0?",":"")+"{\"isFolder\":true,\"addClass\":\"phyzixlabs-room-assignment-submitted\",\"key\":\"key-"+assignmentContext.getParticipantId()+"-"+assignmentContext.getId()+"\",\"pid\":"+assignmentContext.getParticipantId()+",\"id\":"+assignmentContext.getId()+",\"title\":\""+submittedToAssignment.getName().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\",\"type\":\"phyzixlabs-room-assignment-submitted\",\"children\":[");
                                  (teamSpace?buf:contextBuf).append((pads.size()>0?",":"")+"{\"isFolder\":true,\"addClass\":\"phyzixlabs-room-assignment-submitted\",\"title\":\""+submittedToAssignment.getName().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")+"\",\"type\":\"phyzixlabs-room-assignment-submitted\",\"children\":[");
                                  if(assignmentContext != null){
                                      java.util.List<com.feezixlabs.bean.Pad> assignmentPads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),room.getId(),assignmentContext.getId(),assignmentContext.getParticipantId());
                                      boolean bfirstPad = true;
                                      for(com.feezixlabs.bean.Pad assignmentPad:assignmentPads){
                                        String padTitle = net.sf.json.JSONObject.fromObject(assignmentPad.getConfig(),jsonConfig).get("title").toString().replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"");
                                        boolean write_access = (assignmentContext.getAccess()&ACCESS_MODE_WRITE)>0 || (assignmentPad.getAccess()&ACCESS_MODE_WRITE)>0 || (assignmentContext.getAccess()&ACCESS_MODE_WRITE)>0 || (assignmentPad.getAccess()&ACCESS_MODE_WRITE)>0;
                                        String nodeClass2 = write_access?"padnode":"padnode0";
                                        (teamSpace?buf:contextBuf).append((!bfirstPad?",":"")+"{\"isFolder\":false,\"addClass\":\""+nodeClass2+"\",\"key\":\"key-"+assignmentPad.getParticipantId()+"-"+assignmentContext.getId()+"-"+assignmentPad.getId()+"\",\"pid\":"+assignmentPad.getParticipantId()+",\"context_id\":"+assignmentContext.getId()+",\"id\":"+assignmentPad.getId()+",\"embed_key\":\""+assignmentPad.getEmbedKey()+"\",\"title\":\""+padTitle+"\",\"type\":\"pad\"}");
                                        bfirstPad = false;
                                      }
                                  }
                                  (teamSpace?buf:contextBuf).append("]}");
                          }
                      }
                      ////////////////////////////////////////////////////////////////////////////////////////


                   (teamSpace?buf:contextBuf).append("]}");
                    
                    if(teamSpace)
                        bfirstTeamSpace = false;
                }

                contextBuf.append("]}");


                bfirst1 = false;
            }
            if(teamSpaceAccess){
                buf.append("]},"+contextBuf.toString());
            }else{
                buf.append(contextBuf.toString());
            }
        }
        bfirst = false;
    }
    //System.out.println(buf.toString());
%>
<%="[{\"isFolder\":true,\"isLazy\":false,\"children\":["+buf.toString()+"],\"addClass\":\"phyzixlabs-room-root\",\"key\":\"room_header_root\", \"title\":\""+activeRoomName+"\",\"type\":\"header_root\"}]"%>