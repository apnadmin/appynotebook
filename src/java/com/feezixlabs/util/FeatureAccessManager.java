/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.util;
import javax.servlet.http.HttpServletRequest;
import com.feezixlabs.bean.User;
import com.feezixlabs.bean.Room;
import com.feezixlabs.bean.Feature;
import com.feezixlabs.bean.FeatureUsage;

/**
 *
 * @author bitlooter
 */
public class FeatureAccessManager {

    public static String checkAccess(HttpServletRequest request){
        String featureName = request.getParameter("feature");
        if(featureName.compareTo("import") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You have exceeded the maximum number of imports per month on your account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("export") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You have exceeded the maximum number of exports per month on your account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("create binder") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You have exceeded the maximum number of binders on your account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("create page") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You have exceeded the maximum number of pages per binder for this account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("define task") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You have exceeded the maximum number of tasks for this account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("create room") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You have exceeded the maximum number of rooms for your account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("rename room") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You can't rename rooms on your account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("invite participant") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You have exceeded the maximum number of invites on your account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("use teamspace") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You don't have access to team space on your account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("access apps") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You have exceeded the maximum number of imports per month on your account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("presenter mode") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You don't have presenter mode enabled on your account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("shared whiteboard") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You have exceeded the maximum number of imports per month on your account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("page annotation") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You have exceeded the maximum number of imports per month on your account, Please upgrade your account.\"}";
        }
        else
        if(featureName.compareTo("image upload") == 0){
            if(hasAccess(featureName,request))
                return "{\"status\":\"success\"}";
            else
                return "{\"status\":\"failed\",\"msg\":\"You don't have image upload enabled on your account, Please upgrade your account.\"}";
        }
        return "";
    }

    public static String checkTeamLimit(String userName,String emailAddress,int roomId){
        com.feezixlabs.bean.User thisUser = com.feezixlabs.db.dao.UserDOA.getUser(userName);
        com.feezixlabs.bean.User participantUser = com.feezixlabs.db.dao.UserDOA.getUser(emailAddress);
        com.feezixlabs.bean.Feature feature = com.feezixlabs.db.dao.MiscDAO.getFeatureMatrixEntry("invite participant");
        int roomSize = com.feezixlabs.db.dao.ParticipantDAO.getParticipants(roomId).size();
        
        if(thisUser.getPlan().compareTo("basic") == 0){
            if((participantUser == null || participantUser.getPlan().compareTo("basic") == 0) && (roomSize>= new Integer(feature.getBasicPlanLimit())))
                return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"You have exceeded the maximum number of unpaid user invites on your account. Please upgrade your account to a team plan or advice the invitee to upgrade to at least the individual plan.\"}";
        }
        else
        if(thisUser.getPlan().compareTo("individual") == 0){
            if((participantUser == null || participantUser.getPlan().compareTo("basic") == 0) && (roomSize>= new Integer(feature.getIndividualPlanLimit())))
                return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"You have exceeded the maximum number of unpaid user invites on your account. Please upgrade your account to a team plan or advice the invitee to upgrade to at least the individual plan.\"}";                
        }
        else
        if(thisUser.getPlan().compareTo("team") == 0){
            int teamSize = thisUser.getTeamSize();
            if((participantUser == null || participantUser.getPlan().compareTo("basic") == 0) && (roomSize>= new Integer(feature.getTeamPlanLimit())+teamSize))
                return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"You have exceeded the maximum number of unpaid user invites on your account. Please go to your profile and increase team size or advice the invitee to upgrade to at least the individual plan.\"}";                
        }
        return null;
    }

    public static boolean hasAccess(String featureName,HttpServletRequest request){
        if(request.isUserInRole("sysadmin") || ConfigUtil.institutional_instance)return true;

        int roomId= new Integer(request.getParameter("room_id")!=null?request.getParameter("room_id"):""+request.getAttribute("room_id"));
        User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());

        Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(),roomId);
        User roomOwner = com.feezixlabs.db.dao.UserDOA.getUserById(room.getUserId());

        Feature feature = com.feezixlabs.db.dao.MiscDAO.getFeatureMatrixEntry(featureName);
        FeatureUsage featureUsage = com.feezixlabs.db.dao.MiscDAO.getFeatureUsage(request.getUserPrincipal().getName(), feature.getId());
        

        if(featureName.compareTo("import") == 0){
            if(  (user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("basic") != 0) || (roomOwner.getPlan() != null && roomOwner.getPlanStatus().compareTo("inactive") != 0 && roomOwner.getPlan().compareTo("team") == 0) )return true;

            //enforce limit
            return new Integer(featureUsage.getUsage())< new Integer(feature.getBasicPlanLimit());
        }
        else
        if(featureName.compareTo("export") == 0){
            if(  (user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("basic") != 0) || (roomOwner.getPlan() != null && roomOwner.getPlanStatus().compareTo("inactive") != 0 && roomOwner.getPlan().compareTo("team") == 0) )return true;

            //enforce limit
            return new Integer(featureUsage.getUsage())< new Integer(feature.getBasicPlanLimit());
        }
        else
        if(featureName.compareTo("create binder") == 0){
            if(  (user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("basic") != 0) || (roomOwner.getPlan() != null && roomOwner.getPlanStatus().compareTo("inactive") != 0 && roomOwner.getPlan().compareTo("team") == 0) )return true;

            int binderUsage = com.feezixlabs.db.dao.ContextDAO.getContextCount(request.getUserPrincipal().getName(), roomId);
            //enforce limit
            return binderUsage < new Integer(feature.getBasicPlanLimit());
        }
        else
        if(featureName.compareTo("create page") == 0){
            if(  (user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("basic") != 0) || (roomOwner.getPlan() != null && roomOwner.getPlanStatus().compareTo("inactive") != 0 && roomOwner.getPlan().compareTo("team") == 0) )return true;

            int contextId = new Integer(request.getParameter("context_id"));

            int binderPageUsage = com.feezixlabs.db.dao.PadDAO.getPadCount(request.getUserPrincipal().getName(), roomId,contextId);
            //enforce limit
            return binderPageUsage < new Integer(feature.getBasicPlanLimit());
        }
        else
        if(featureName.compareTo("define task") == 0){
        
            int taskCount = com.feezixlabs.db.dao.AssignmentDAO.getAssignments(request.getUserPrincipal().getName(), roomId).size();
            
            if(user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("individual") == 0)
                return true;//taskCount< new Integer(feature.getIndividualPlanLimit());
            else
            if(user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("team") == 0)
                return true;
            //else                
            //if(roomOwner.getPlan() != null && roomOwner.getPlanStatus().compareTo("inactive") != 0 && roomOwner.getPlan().compareTo("team") == 0)
            //    return true/*new Integer(featureUsage.getUsage())< new Integer(feature.getTeamPlanLimit())*/;
            else
            if(user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("basic") == 0)
                return taskCount< new Integer(feature.getBasicPlanLimit());
                
            //N/A to basic plan holders
            return false;
        }
        else
        if(featureName.compareTo("create room") == 0){
            if(user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("individual") == 0)
                return new Integer(featureUsage.getUsage())< new Integer(feature.getIndividualPlanLimit());
            else
            if(user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("team") == 0)
                return new Integer(featureUsage.getUsage())< new Integer(feature.getTeamPlanLimit());
            //else
            //if(roomOwner.getPlan() != null && roomOwner.getPlanStatus().compareTo("inactive") != 0 && roomOwner.getPlan().compareTo("team") == 0)
            //    return new Integer(featureUsage.getUsage())< new Integer(feature.getTeamPlanLimit());

            //N/A to basic plan holders
            return false;
        }
        else
        if(featureName.compareTo("rename room") == 0){
            return (user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("basic") != 0);
        }
        else
        if(featureName.compareTo("invite participant") == 0){
            /*if(user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("individual") == 0)
                return new Integer(featureUsage.getUsage())< new Integer(feature.getIndividualPlanLimit());
            else
            if(user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("team") == 0)
                return true/*new Integer(featureUsage.getUsage())< new Integer(feature.getIndividualPlanLimit())*;
            else
                return new Integer(featureUsage.getUsage())< new Integer(feature.getBasicPlanLimit());*/
        }
        else
        if(featureName.compareTo("use teamspace") == 0){
            return (user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("basic") != 0);
        }
        else
        if(featureName.compareTo("access apps") == 0){
            return true;
        }
        else
        if(featureName.compareTo("presenter mode") == 0){
            return (user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("team") == 0);
        }
        else
        if(featureName.compareTo("shared whiteboard") == 0){
            return true;
        }
        else
        if(featureName.compareTo("page annotation") == 0){
            return true;
        }
        else
        if(featureName.compareTo("image upload") == 0){
            return (user.getPlan() != null && user.getPlanStatus().compareTo("inactive") != 0 && user.getPlan().compareTo("basic") != 0);
        }
        return false;
    }
}
