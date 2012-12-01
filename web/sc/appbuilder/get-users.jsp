<%@page contentType="text/xml" pageEncoding="UTF-8"%><%
        //System.out.print("page:"+request.getParameter("page")+"/"+request.getParameter("rows"));
        int xpage  = new Integer(request.getParameter("page"));
        int limit = new Integer(request.getParameter("rows"));
        int start = xpage*limit - limit;
        
        String filter = request.getParameter("filter");
        int count  = com.feezixlabs.db.dao.UserDOA.getUserCount(filter);
        int totalpages = (int)(count>0?Math.ceil(count/limit):0);

        StringBuilder xmlbuf = new StringBuilder();        

        xmlbuf.append("<?xml version='1.0' encoding='utf-8'?>\n");
        xmlbuf.append("<rows>");
        xmlbuf.append(" <page>"+xpage+"</page>");
        xmlbuf.append(" <total>"+totalpages+"</total>");
        xmlbuf.append(" <records>"+count+"</records>");
        
        for(com.feezixlabs.bean.User user : com.feezixlabs.db.dao.UserDOA.getUsers(start, limit, filter)){
            xmlbuf.append(" <row>");
            xmlbuf.append("     <cell><![CDATA["+user.getId()+"]]></cell>");
            xmlbuf.append("     <cell><![CDATA["+user.getName()+"]]></cell>");            
            xmlbuf.append("     <cell><![CDATA["+user.getEmailAddress()+"]]></cell>");            
            xmlbuf.append("     <cell><![CDATA["+com.feezixlabs.util.Utility.join(com.feezixlabs.db.dao.UserDOA.getUserRoles(user.getId()),"<br/>")+"]]></cell>");
            xmlbuf.append("     <cell><![CDATA[<button onclick=\"appletBuilder.deleteUser('"+user.getEmailAddress()+"')\">delete</button>]]></cell>");
            xmlbuf.append("</row>");
        }
        xmlbuf.append("</rows>\n");

%><%=xmlbuf.toString() %>