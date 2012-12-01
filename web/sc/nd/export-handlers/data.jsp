<%-- 
    Document   : svg
    Created on : Jun 2, 2009, 9:24:11 PM
    Author     : bitlooter
--%>
<%    //make sure they have right to take this action
        if(!com.feezixlabs.util.FeatureAccessManager.hasAccess("export", request)){
            response.sendRedirect("export-error.jsp?src=data");return;
        }
        String fileExtension    = request.getParameter("extension") != null && request.getParameter("extension").length()>0?request.getParameter("extension"):"csv";
        String fileName         = (request.getParameter("file_name") != null && request.getParameter("file_name").length()>0? request.getParameter("file_name"):"data")+"."+fileExtension;
        String fileType         = request.getParameter("mime") != null && request.getParameter("mime").length()>0?request.getParameter("mime"):"text/csv";
        
        response.setHeader("Content-disposition", "attachment; filename="+fileName);
        response.setHeader("Content-Transfer-Encoding", "base64");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        response.setContentType(fileType);
%>
<%=request.getParameter("data")/*.replaceAll("util/getimage.jsp", com.feezixlabs.util.ConfigUtil.baseUrl+"/util/getimage.jsp")*/ %>