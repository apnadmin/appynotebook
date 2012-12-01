<%-- 
    Document   : room-list
    Created on : Jan 16, 2012, 9:36:21 AM
    Author     : bitlooter
--%>
<%
    StringBuffer buf = new StringBuffer();
    java.util.List<com.feezixlabs.bean.Room> rooms = com.feezixlabs.db.dao.RoomDAO.getRooms(request.getUserPrincipal().getName());
    buf.append("<ul>");

    //if(com.feezixlabs.util.FeatureAccessManager.hasAccess("create room", request))
    buf.append("<li><a href=\"#\" onclick=\"ColabopadApplication.createRoom()\" style=\"font-weight:bold\">Create Group</a></li>");
    for(com.feezixlabs.bean.Room room:rooms){
          String turl = "./?room_id="+room.getId()+"&ts="+(new java.util.Date()).getTime();
          buf.append("<li><a href=\""+turl+"\">"+room.getTitle()+"</a></li>");
    }
    buf.append("</ul>");
%><%=buf.toString() %>


