/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.struts.action.handler;
import javax.servlet.http.HttpServletRequest;
import com.feezixlabs.util.ConfigUtil;
/**
 *
 * @author bitlooter
 */
public class RoomActionHandler {
    static String updateRoomName(HttpServletRequest request){
        if(!com.feezixlabs.util.FeatureAccessManager.hasAccess("rename room", request))
            return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"Please upgrade your account to rename your room.\"}";

        int roomId = Integer.parseInt(request.getParameter("room_id"));
        String roomName = request.getParameter("room_name");
        if(roomName == null || roomName.length()==0)
            return "{\"status\":\"failure\",\"msg\":\"Please provide a room name\"}";

        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);

        if(room != null && room.getUserId() == user.getId()){
            room.setTitle(roomName);
            com.feezixlabs.db.dao.RoomDAO.updateRoomName(room);
            return "{\"status\":\"success\"}";
        }else{
            return "{\"status\":\"failure\",\"msg\":\"You don't have a right to rename this room.\"}";
        }
    }
    
    static String updateRoomAccess(HttpServletRequest request){
        if(!com.feezixlabs.util.FeatureAccessManager.hasAccess("rename room", request))
            return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"Please upgrade your account to alter access to this room.\"}";

        int roomId = Integer.parseInt(request.getParameter("room_id"));
        int accessControl = Integer.parseInt(request.getParameter("access"));
        

        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);

        if(room != null && room.getUserId() == user.getId()){            
            room.setAccessControl(accessControl);
            com.feezixlabs.db.dao.RoomDAO.updateRoomAccess(request.getUserPrincipal().getName(),room);
            return "{\"status\":\"success\"}";
        }else{
            return "{\"status\":\"failure\",\"msg\":\"You don't have a right to alter access on this room.\"}";
        }
    }    
    
    static String updateRoomAccessCode(HttpServletRequest request){
        if(!com.feezixlabs.util.FeatureAccessManager.hasAccess("rename room", request))
            return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"Please upgrade your account to alter access to this room.\"}";

        int roomId = Integer.parseInt(request.getParameter("room_id"));

        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);

        if(room != null && room.getUserId() == user.getId()){
            String newAccessCode = com.feezixlabs.db.dao.RoomDAO.updateRoomAccessCode(request.getUserPrincipal().getName(),room);
            return "{\"status\":\"success\",\"accessCode\":\""+newAccessCode+"\"}";
        }else{
            return "{\"status\":\"failure\",\"msg\":\"You don't have a right to alter access on this room.\"}";
        }
    }        
    
    
    static String getRoomAccess(HttpServletRequest request){
        if(!com.feezixlabs.util.FeatureAccessManager.hasAccess("rename room", request))
            return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"Please upgrade your account to alter access to this room.\"}";

        int roomId = Integer.parseInt(request.getParameter("room_id"));

        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);

        if(room != null && room.getUserId() == user.getId()){
            
            return "{\"status\":\"success\",\"accessCode\":\""+room.getAccessCode()+"\",\"accessControl\":"+room.getAccessControl()+"}";
        }else{
            return "{\"status\":\"failure\",\"msg\":\"You don't have a right to alter access on this room.\"}";
        }
    }       
    
    public static String messagePump(HttpServletRequest request){
        String action = request.getParameter("action");
        if(action.compareToIgnoreCase("get-rooms") == 0){
            java.util.List<com.feezixlabs.bean.Room> rooms = com.feezixlabs.db.dao.RoomDAO.getRooms(request.getUserPrincipal().getName());
            int userId = com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName());
            
            StringBuffer xmlbuf = new StringBuffer();
            xmlbuf.append("{\n");

            xmlbuf.append("page:'1',\n");
            xmlbuf.append("total:'1',\n");
            xmlbuf.append("record:'"+rooms.size()+"',\n");

            //rows
            xmlbuf.append("rows:[\n");
            boolean first = true;
            int i=0;
            for(com.feezixlabs.bean.Room room:rooms){
                if(!first)
                    xmlbuf.append(",");

                xmlbuf.append("{id:'"+room.getId()+"',cell:["+(++i)+",");                
                xmlbuf.append("'<span style=\"cursor:pointer\">"+room.getTitle()+"</span>',");

                if(userId == room.getUserId())//only allow delete if they created the room
                    xmlbuf.append("'<input type=\"image\" src=\"images/misc/del-doc.png\" onclick=\"deleteRoom("+room.getId()+")\"/>'");
                else
                    xmlbuf.append("''");

                //xmlbuf.append("'"+room.getId()+"',");
                xmlbuf.append("]}\n");
                first = false;
            }
            xmlbuf.append("]\n");
            xmlbuf.append("}\n");
            return xmlbuf.toString();
        }
        else
        if(action.compareToIgnoreCase("get-rooms-json") == 0){
            java.util.List<com.feezixlabs.bean.Room> rooms = com.feezixlabs.db.dao.RoomDAO.getRooms(request.getUserPrincipal().getName());
            int userId = com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName());

            StringBuilder xmlbuf = new StringBuilder();
            xmlbuf.append("{rooms:[\n");
            boolean first = true;
            for(com.feezixlabs.bean.Room room:rooms){
                if(!first)
                    xmlbuf.append(",");

                xmlbuf.append("{\"id\":\""+room.getId()+"\",\"title\":\""+room.getTitle()+"\",");

                if(userId == room.getUserId())//only allow delete if they created the room
                    xmlbuf.append("\"deletable\":true");
                else
                    xmlbuf.append("\"deletable\":false");

                //xmlbuf.append("'"+room.getId()+"',");
                xmlbuf.append("}\n");
                first = false;
            }
            xmlbuf.append("]}\n");
            return xmlbuf.toString();
        }
        else
        if( action.compareToIgnoreCase("create-room") == 0 ){

            if(!com.feezixlabs.util.FeatureAccessManager.hasAccess("create room", request))
                return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"Please upgrade your account to create a room.\"}";

            
            if(request.isUserInRole("sysadmin")||request.isUserInRole("educator")||request.isUserInRole("room_creator")){
                com.feezixlabs.bean.Room room = new com.feezixlabs.bean.Room();
                room.setTitle(request.getParameter("roomLabel"));
                room = com.feezixlabs.db.dao.RoomDAO.addRoom(request.getUserPrincipal().getName(), room);

                if(room != null)
                    return "{\"status\":\"success\",\"room_id\":\""+room.getId()+"\"}";
                else
                    return "{\"status\":\"failed\"}";
            }
        }
        else
        if( action.compareToIgnoreCase("invite-participant") == 0 ){
            if(!com.feezixlabs.util.FeatureAccessManager.hasAccess("invite participant", request))
                return "{\"status\":\"failed\",\"limit\":true,\"msg\":\"Please upgrade your account to add additional invites.\"}";


            int roomId = new Integer(request.getParameter("room_id"));
            int participantId = new Integer(request.getParameter("participant_id"));

            com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);
            int userId = com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName());

            if(room.getUserId() == userId){
                  com.feezixlabs.bean.Participant p = com.feezixlabs.db.dao.ParticipantDAO.getParticipant(roomId,participantId);
                  if(p != null){
                      com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(p.getUserName());

                      //send notification email
                      String notification = com.feezixlabs.util.ConfigUtil.account_creation_via_invite_notification_email.replaceAll("\\{installation_name\\}", com.feezixlabs.util.ConfigUtil.installation_name).replaceAll("\\{participant_name\\}", p.getName()).replaceAll("\\{username\\}", p.getUserName().toLowerCase()).replaceAll("\\{passwd\\}", user.getPassWord())
                              .replaceAll("\\{installation_login_url\\}",com.feezixlabs.util.ConfigUtil.installation_login_url+room.getId())
                              .replaceAll("\\{room\\}",room.getTitle());

                      com.feezixlabs.util.Utility.sendEmail(user.getEmailAddress(), com.feezixlabs.util.ConfigUtil.installation_name+" Invite",notification, true, com.feezixlabs.util.ConfigUtil.invite_notifier, com.feezixlabs.util.ConfigUtil.invite_notifier, com.feezixlabs.util.ConfigUtil.invite_notifier_password);
                      return "{\"status\":\"success\"}";
                }
            }
            return "{\"status\":\"failed\"}";
        }
        else
        if( action.compareToIgnoreCase("update-room-name") == 0 ){
            return updateRoomName(request);
        }
        else
        if( action.compareToIgnoreCase("update-room-access") == 0 ){
            return updateRoomAccess(request);
        }
        else
        if( action.compareToIgnoreCase("update-room-access-code") == 0 ){
            return updateRoomAccessCode(request);
        }
        else
        if( action.compareToIgnoreCase("get-room-access") == 0 ){
            return getRoomAccess(request);
        }        
        return "";
    }
}
