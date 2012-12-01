<%-- 
    Document   : embed-port
    Created on : Mar 16, 2011, 10:49:06 AM
    Author     : bitlooter
--%><%@page contentType="text/javascript" pageEncoding="UTF-8"%>
(function(){
  document.getElementById('dock-<%=request.getAttribute("embed_key") %>').innerHTML = '<iframe width="<%=request.getAttribute("width") %>" height="<%=Integer.parseInt(""+request.getAttribute("height")) %>" src="<%=com.feezixlabs.util.ConfigUtil.baseUrl%>/embed/?action=get_main&embed_key=<%=request.getAttribute("embed_key") %>&width=<%=request.getAttribute("width") %>&height=<%=request.getAttribute("height") %>&ts='+(new Date().getTime())+'" frameborder="0" scrolling="no"></iframe>'
})()