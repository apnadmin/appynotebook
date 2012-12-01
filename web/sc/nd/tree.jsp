<%-- 
    Document   : tree
    Created on : Jan 10, 2011, 8:34:02 PM
    Author     : bitlooter
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int ACCESS_MODE_WRITE = 2;

    
    int userId = com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName());
    int currentRoomId = new Integer(request.getParameter("room_id"));
    String activeRoomName = "";
    
    java.util.List<com.feezixlabs.bean.Room> rooms = com.feezixlabs.db.dao.RoomDAO.getRooms(request.getUserPrincipal().getName());

    net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
    jsonConfig.setJavascriptCompliant(true);

    com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());

    boolean teamSpaceAccess = true;//com.feezixlabs.util.FeatureAccessManager.hasAccess("use teamspace", request);
    boolean taskAccess = true;//request.isUserInRole("sysadmin") || com.feezixlabs.util.ConfigUtil.institutional_instance || (user.getPlan() != null && user.getPlan().compareTo("basic") != 0);

    java.util.List roomNodeList = new java.util.ArrayList();    
    java.util.Map  roomNode = null;
    java.util.List roomNodeChildren = null;
    
    for(com.feezixlabs.bean.Room room:rooms){
        if(room.getId() == currentRoomId){
            activeRoomName = room.getTitle();//.replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"");
            
            roomNode = new java.util.HashMap();
            roomNode.put("isFolder","true");
            roomNode.put("addClass","phyzixlabs-room-root");
            roomNode.put("type","header_root");
            roomNode.put("key","room_header_root");
            roomNode.put("title",activeRoomName);
            roomNodeChildren = new java.util.ArrayList();
            roomNode.put("children",roomNodeChildren);

            if( (taskAccess) && (request.isUserInRole("educator") || request.isUserInRole("sysadmin") || room.getUserId() == userId)){
                
                java.util.Map taskQueueRootNode = new java.util.HashMap();
                taskQueueRootNode.put("isFolder","true");
                taskQueueRootNode.put("addClass","phyzixlabs-room-assignment-root");
                taskQueueRootNode.put("key","key-assignment-root");
                taskQueueRootNode.put("id","-2");
                taskQueueRootNode.put("title","Tasks");
                taskQueueRootNode.put("type","assignment-root");
                
                
                java.util.List taskQueueNodeList = new java.util.ArrayList();
                taskQueueRootNode.put("children",taskQueueNodeList);
                
                java.util.List<com.feezixlabs.bean.Assignment> assignments = com.feezixlabs.db.dao.AssignmentDAO.getAssignments(request.getUserPrincipal().getName(), room.getId());

                for(com.feezixlabs.bean.Assignment assignment:assignments){
                    java.util.Map taskQueueNode = new java.util.HashMap();
                    taskQueueNode.put("isFolder","true");
                    taskQueueNode.put("addClass","phyzixlabs-room-assignment");
                    taskQueueNode.put("key","key-assignment-"+assignment.getId());
                    taskQueueNode.put("id",assignment.getId());
                    taskQueueNode.put("title",assignment.getName());
                    taskQueueNode.put("type","assignment");        
                    
                    java.util.List assignmentSubmissionNodeList = new java.util.ArrayList();
                    taskQueueNode.put("children",assignmentSubmissionNodeList);
                    
                    java.util.List<com.feezixlabs.bean.AssignmentSubmission> assignmentSubmmissions = com.feezixlabs.db.dao.AssignmentSubmissionDAO.getAssignmentSubmissions(request.getUserPrincipal().getName(), room.getId(),assignment.getId());
                    for(com.feezixlabs.bean.AssignmentSubmission assignmentSubmission:assignmentSubmmissions){
                          com.feezixlabs.bean.Context context = com.feezixlabs.db.dao.ContextDAO.getContext(request.getUserPrincipal().getName(),room.getId(),assignmentSubmission.getContextId(),assignment.getUserId());
                          com.feezixlabs.bean.User submittedByUser = com.feezixlabs.db.dao.UserDOA.getUserById(assignmentSubmission.getUserId());

                          //see if access has been assignment to user who submitted it, this indicates that it has been graded
                          com.feezixlabs.bean.Context contextGraded = com.feezixlabs.db.dao.ContextDAO.getContext(submittedByUser.getUserName(),room.getId(),assignmentSubmission.getContextId(),assignment.getUserId());
                          String addClass = "phyzixlabs-room-assignment-submission";
                          if(contextGraded != null)
                              addClass = "phyzixlabs-room-assignment-submission-graded";

                          java.util.Map assignmentSubmissionNode = new java.util.HashMap();
                          assignmentSubmissionNode.put("title",submittedByUser.getName());
                          assignmentSubmissionNode.put("isFolder","true");
                          assignmentSubmissionNode.put("addClass",addClass);
                          assignmentSubmissionNode.put("type","phyzixlabs-room-assignment-submission");
                          assignmentSubmissionNode.put("key","key-"+context.getParticipantId()+"-"+context.getId());
                          assignmentSubmissionNode.put("user_id",assignmentSubmission.getUserId());
                          assignmentSubmissionNode.put("context_id",context.getId());
                          
                          java.util.List<com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),room.getId(),context.getId(),context.getParticipantId());
                          assignmentSubmissionNode.put("children",
                            com.feezixlabs.struts.action.handler.PadActionHandler.buildPadTree(room.getId(), user, null, context,com.feezixlabs.struts.action.handler.PadActionHandler.convertToTree(pads))
                          );                          
                          assignmentSubmissionNodeList.add(assignmentSubmissionNode);
                    }
                }
                roomNodeChildren.add(taskQueueRootNode);
            }
            
            java.util.Map teamSpaceNode;
            java.util.List teamSpaceBinders = null;
            if(teamSpaceAccess){
                teamSpaceNode = new java.util.HashMap();
                teamSpaceNode.put("isFolder","true");
                teamSpaceNode.put("addClass","phyzixlabs-room-teamspace");
                teamSpaceNode.put("key","key-teamspace");                
                teamSpaceNode.put("title","Team Space");
                teamSpaceNode.put("type","teamspace");
                teamSpaceNode.put("id","-1");    
                teamSpaceBinders = new java.util.ArrayList();
                teamSpaceNode.put("children",teamSpaceBinders);
                roomNodeChildren.add(teamSpaceNode);
            }
            
            java.util.List participantNodeList = new java.util.ArrayList();
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

                java.util.Map participantNode = new java.util.HashMap();
                participantNode.put("isFolder","true");
                participantNode.put("addClass",nodeClass);
                participantNode.put("key","key-"+participant.getUserId());                
                participantNode.put("title",participant.getName());
                participantNode.put("type","participant");
                participantNode.put("id",participant.getUserId());
                java.util.List participantNodeChildren = new java.util.ArrayList();
                participantNode.put("children",participantNodeChildren);

                
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
                    String title = net.sf.json.JSONObject.fromObject(context.getConfig(),jsonConfig).get("title").toString();//.replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"");

                    java.util.List contextNodeChildren = new java.util.ArrayList();
                    java.util.Map contextNode = new java.util.HashMap();
                    contextNode.put("id",context.getId());
                    contextNode.put("isFolder","true");
                    contextNode.put("type","context");
                    contextNode.put("title",title);
                    if(teamSpace)
                        contextNode.put("addClass","phyzixlabs-room-teamspace-binder");
                    else
                        contextNode.put("addClass",nodeClass1);
                    
                    contextNode.put("pid",participant.getUserId());
                    contextNode.put("key","key-"+participant.getUserId()+"-"+context.getId());

                    java.util.List<com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),room.getId(),context.getId(),participant.getUserId());
                    
                    contextNodeChildren =  com.feezixlabs.struts.action.handler.PadActionHandler.buildPadTree(room.getId(), user, participant, context,com.feezixlabs.struts.action.handler.PadActionHandler.convertToTree(pads));
                    
                    
                    if(teamSpace){
                        teamSpaceBinders.add(contextNode);
                    }else{
                        ////////////////////////////////////////////////////////////////////////////////////////
                        //append any assignment submission related to this context
                        contextNodeChildren.addAll(com.feezixlabs.struts.action.handler.PadActionHandler.buildAssignmentSubmissionNodes(room.getId(),user,participant,context,null));
                        participantNodeChildren.add(contextNode);
                    }    
                    contextNode.put("children",contextNodeChildren);
                }
                roomNodeChildren.add(participantNode);
            }
        }
    }
%>
<%="["+net.sf.json.JSONObject.fromObject(roomNode).toString()+"]"%>