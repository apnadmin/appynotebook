/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.struts.action.handler;

import com.feezixlabs.bean.Context;
import javax.servlet.http.HttpServletRequest;
import com.feezixlabs.bean.Pad;
import com.feezixlabs.bean.Participant;
import com.feezixlabs.bean.User;
import com.feezixlabs.db.dao.PadDAO;
import com.feezixlabs.db.dao.UserDOA;
import com.feezixlabs.util.ConfigUtil;
import java.util.*;

/**
 *
 * @author bitlooter
 */
public class PadActionHandler {
    static String addNewPad(HttpServletRequest request){
        if(com.feezixlabs.util.FeatureAccessManager.hasAccess("create page", request)){
            int roomId = new Integer(request.getParameter("room_id"));
            int grantor = new Integer(request.getParameter("grantor"));
            int contextId = new Integer(request.getParameter("context_id"));
            int parentId = new Integer(request.getParameter("parent_id"));
            int preSibling = new Integer(request.getParameter("pre_sibling"));
            
            String config = request.getParameter("config");
            return "{id:"+com.feezixlabs.db.dao.PadDAO.addPad(roomId,request.getUserPrincipal().getName(),contextId,parentId,preSibling, config,grantor,ConfigUtil.default_page_access)+",context_id:"+contextId+"}";
        }else{
            return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"You have exceeded the maximum number of pages on this binder, Please upgrade your account for unlimited pages per binder.\"}";
        }
    }

    static void updatePad(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int grantor = new Integer(request.getParameter("grantor"));
        int contextId = new Integer(request.getParameter("context_id"));
        int padId = new Integer(request.getParameter("pad_id"));
        String config     = request.getParameter("config");
        com.feezixlabs.db.dao.PadDAO.updatePad(request.getUserPrincipal().getName(), roomId, contextId, padId, config, grantor);
    }
    
    static void updatePadPreSibling(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int preSibling = new Integer(request.getParameter("pre_sibling"));
        int contextId = new Integer(request.getParameter("context_id"));
        int padId = new Integer(request.getParameter("pad_id"));
        
        try{
            Pad rootPad = validateContext(request,roomId,contextId,padId,0,preSibling,null,true);
            if(rootPad != null)
                PadDAO.updatePadPreSibling(request.getUserPrincipal().getName(), roomId, contextId, padId,preSibling);
            else
                System.out.println("Invalid pad tree");
            
        }catch(Exception ex){
            System.out.println("Invalid pad tree");
            ex.printStackTrace();
        }
    }    
    
    //this would ensure that there are no cycles in the graph 
    //before committing changes to database
    static Pad validateContext(HttpServletRequest request,
                               int roomId,
                               int contextId,
                               int padId,
                               int parentId,
                               int preSibling,
                               String childrenOnly,
                               boolean updatePreSibling){
        int userId = UserDOA.getUserId(request.getUserPrincipal().getName());
        java.util.List<Pad> pads = PadDAO.getPads(request.getUserPrincipal().getName(), roomId, contextId,userId);
        
        if(updatePreSibling){
            //update presiblings
            for(Pad pad:pads){
                if(pad.getParentId() == padId){
                    pad.setPreSibling(preSibling);
                }
            }
        }
        else
        {
            if(childrenOnly.compareToIgnoreCase("yes") == 0){
                //update presiblings
                for(Pad pad:pads){
                    if(pad.getParentId() == padId && pad.getPreSibling() == 0){
                        pad.setPreSibling(preSibling);
                    }
                }

                for(Pad pad:pads){
                    if(pad.getParentId() == padId){
                        pad.setParentId(parentId);
                    }
                }            

            }else{
                for(Pad pad:pads){
                    if(pad.getParentId() == padId){
                        pad.setParentId(parentId);
                        pad.setPreSibling(preSibling);
                    }
                }            
            }
        }        
        return PadActionHandler.convertToTree(pads);
    }
    
    static void movePad(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int contextId = new Integer(request.getParameter("context_id"));
        int padId = new Integer(request.getParameter("pad_id"));
        int parentId = new Integer(request.getParameter("parent_id"));
        int preSibling = new Integer(request.getParameter("pre_sibling"));
        String childrenOnly     = request.getParameter("children_only") != null?request.getParameter("children_only"):"no";
        
        
        try
        {
            Pad rootPad = validateContext(request,roomId,contextId,padId,parentId,preSibling,childrenOnly,false);
            if(rootPad != null)        
                PadDAO.movePad(request.getUserPrincipal().getName(), roomId, contextId, padId,parentId,preSibling, childrenOnly);
            else
                System.out.println("Invalid pad tree");
        }catch(Exception ex){
            System.out.println("Invalid pad tree");
            ex.printStackTrace();
        }
    }    
    
    static void deletePad(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int grantor = new Integer(request.getParameter("grantor"));
        int contextId = new Integer(request.getParameter("context_id"));
        int padId = new Integer(request.getParameter("pad_id"));
        PadDAO.deletePad(request.getUserPrincipal().getName(), roomId, contextId, padId,grantor);
    }

    static void updatePadAccess(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int contextId = new Integer(request.getParameter("context_id"));
        int padId = new Integer(request.getParameter("pad_id"));
        int grantedTo = new Integer(request.getParameter("granted_to"));
        int accessControl = new Integer(request.getParameter("access"));
        com.feezixlabs.db.dao.PadAccessDAO.updatePadAccess(request.getUserPrincipal().getName(), roomId, contextId, padId, grantedTo,accessControl);
    }

    public static Pad convertToTree(List<Pad> pads){        
        java.util.List<com.feezixlabs.bean.Pad> sortedPads = com.feezixlabs.util.PadSorter.topo(pads);
        java.util.Collections.reverse(sortedPads);
        Pad  rootPad = sortedPads.remove(0);
        PadActionHandler.convertToTree(rootPad, sortedPads,0);
        return rootPad;
    }
    
    public static void convertToTree(Pad curPad,List<Pad> pads,int startIndex){
        //Pad curPad = pads.remove(0);
        
        for(int i=startIndex;i<pads.size();i++){
            Pad pad = pads.get(i);
            if(pad.getParentId() == curPad.getId()){
                //System.out.println("Adding child item:"+pad.getId());
                curPad.getChildren().add(pad);
                pad.setParent(curPad);
                convertToTree(pad,pads,i+1);
            }          
        }
        
        java.util.List<Pad> sortedPads = com.feezixlabs.util.PadSorter.topo_siblings(curPad.getChildren());
        java.util.Collections.reverse(sortedPads);
        sortedPads.remove(0);
        curPad.setChildren(sortedPads);
        //sort siblings
        /*for(int i=0;i<curPad.getChildren().size();i++){
            Pad childPad = curPad.getChildren().get(i);
            for(int j=i+1;j<curPad.getChildren().size();j++){
                if(childPad.getId() == curPad.getChildren().get(j).getPreSibling()){
                    curPad.getChildren().add(i+1, curPad.getChildren().remove(j));
                    break;
                }
            }
        }*/
        
        //item with no preceding sibling is the first item
        //if(curPad.getChildren().size()>1)
        //    curPad.getChildren().add(0, curPad.getChildren().remove(curPad.getChildren().size()-1));
    }
    
    public static List buildAssignmentSubmissionNodes(int roomId,User user,Participant participant,Context context,Pad pad){
        List submittedAssignmentNodes = new ArrayList();  
        if(participant == null || user.getId() == participant.getUserId()){
            java.util.List<com.feezixlabs.bean.AssignmentSubmission> assignmentSubmissions = com.feezixlabs.db.dao.AssignmentSubmissionDAO.getAssignmentSubmittedFromSource(user.getUserName(), roomId,context.getId(), pad!=null?pad.getId():0);

            
            for(com.feezixlabs.bean.AssignmentSubmission assignmentSubmission:assignmentSubmissions){
                
                com.feezixlabs.bean.Assignment submittedToAssignment = com.feezixlabs.db.dao.AssignmentDAO.getAssignment(user.getUserName(), roomId, assignmentSubmission.getAssignmentId());
                com.feezixlabs.bean.Context assignmentContext = com.feezixlabs.db.dao.ContextDAO.getContext(user.getUserName(),roomId,assignmentSubmission.getContextId(),submittedToAssignment.getUserId());
                
                Map submittedAssignmentNode = new HashMap();
                submittedAssignmentNode.put("title",submittedToAssignment.getName());
                submittedAssignmentNode.put("isFolder","true");
                submittedAssignmentNode.put("addClass","phyzixlabs-room-assignment-submitted");
                submittedAssignmentNode.put("type","phyzixlabs-room-assignment-submitted");
                              
                if(assignmentContext != null){
                    java.util.List<com.feezixlabs.bean.Pad> assignmentPads = com.feezixlabs.db.dao.PadDAO.getPads(user.getUserName(),roomId,assignmentContext.getId(),assignmentContext.getParticipantId());
                    submittedAssignmentNode.put("children",buildPadTree(roomId,user,participant,assignmentContext,convertToTree(assignmentPads)));
                }else{
                    submittedAssignmentNode.put("children",new ArrayList());
                }
                submittedAssignmentNodes.add(submittedAssignmentNode);
            }
        }return submittedAssignmentNodes;
    }
    
    public static Map buildPadTreeNode(int roomId,User user,Participant participant,Context context,Pad pad){
        int ACCESS_MODE_WRITE = 2;
        net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
        jsonConfig.setJavascriptCompliant(true);   
        
        Map node = new HashMap();
        String padTitle = net.sf.json.JSONObject.fromObject(pad.getConfig(),jsonConfig).getString("title");//.toString();//.replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"");
        boolean write_access = (context.getAccess()&ACCESS_MODE_WRITE)>0 || (pad.getAccess()&ACCESS_MODE_WRITE)>0 || (context.getAccess()&ACCESS_MODE_WRITE)>0 || (pad.getAccess()&ACCESS_MODE_WRITE)>0;
        String nodeClass = write_access?"padnode":"padnode0";        
        
        node.put("title",padTitle);
        node.put("isFolder","true");
        node.put("addClass",nodeClass);
        
        if(participant != null)
            node.put("key","key-"+participant.getUserId()+"-"+context.getId()+"-"+pad.getId());
        else
            node.put("key","key-"+user.getId()+"-"+context.getId()+"-"+pad.getId());
        
        node.put("pid",participant !=null?participant.getUserId():user.getId());
        node.put("context_id",context.getId());
        node.put("id",pad.getId());
        node.put("embed_key",pad.getEmbedKey());
        node.put("type","pad");
        
        List childPads = buildPadTree(roomId,user,participant,context,pad);
        ////////////////////////////////////////////////////////////////////////////////////////
        //append any assignment submission related to this pad        
        childPads.addAll(buildAssignmentSubmissionNodes(roomId,user,participant,context,pad));
        node.put("children",childPads);
        return node;
    }
    
    public static List buildPadTree(int roomId,User user,Participant participant,Context context,Pad pad){
        List childNodes = new ArrayList();
        for(Pad childPad:pad.getChildren()){
            childNodes.add(buildPadTreeNode(roomId,user,participant,context,childPad));
        }
        return childNodes;
    }
    
    
    public static Pad findPad(Pad pad,int id){
        if(pad.getId() == id)return pad;        
        
        for(Pad childPad:pad.getChildren()){
            Pad retPad = findPad(childPad,id);
            
            if(retPad != null)
                return retPad;
        }return null;
    }
    
    public static String messagePump(HttpServletRequest request){
        String action = request.getParameter("action");
        if(action.compareToIgnoreCase("add-pad") == 0){
            return addNewPad(request);
        }
        else
        if(action.compareToIgnoreCase("update-pad") == 0){
            updatePad(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("update-pad-pre-sibling") == 0){
            updatePadPreSibling(request);
            return "{status:'success'}";
        }        
        else
        if(action.compareToIgnoreCase("move-pad") == 0){
            movePad(request);
            return "{status:'success'}";
        }        
        else
        if(action.compareToIgnoreCase("del-pad") == 0){
            deletePad(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("update-pad-access") == 0){
            updatePadAccess(request);
            return "{status:'success'}";
        }return "";
    }
}
