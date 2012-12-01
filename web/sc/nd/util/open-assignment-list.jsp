<%
    StringBuilder buf = new StringBuilder();
    int roomId = Integer.parseInt(request.getParameter("room_id"));
    if(request.getParameter("submission") == null){
        java.util.List<com.feezixlabs.bean.Assignment> assignments = com.feezixlabs.db.dao.AssignmentDAO.getOpenAssignments(request.getUserPrincipal().getName(), roomId);
        boolean first = true;
        buf.append("[");
        for(com.feezixlabs.bean.Assignment assignment:assignments){
           buf.append((!first?",":"")+  "{\"name\":\""+assignment.getName()+"\",\"id\":"+assignment.getId()+"}");
           first = false;
        }
        buf.append("]");
    }else{
        java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("MM/dd/yyyy h:m a");
        java.text.SimpleDateFormat mysqlformat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        int contextId = Integer.parseInt(request.getParameter("context_id"));
        int padId = Integer.parseInt(request.getParameter("pad_id"));
        java.util.List<com.feezixlabs.bean.AssignmentSubmission> assignmentSubmissions = com.feezixlabs.db.dao.AssignmentSubmissionDAO.getAssignmentSubmittedFromSource(request.getUserPrincipal().getName(), roomId,contextId, padId);
        boolean first = true;
        buf.append("[");
        for(com.feezixlabs.bean.AssignmentSubmission assignmentSubmission:assignmentSubmissions){
           buf.append((!first?",":"")+  "{\"name\":\""+ format.format(mysqlformat.parse(assignmentSubmission.getSubmitTime()))+"\",\"id\":"+assignmentSubmission.getContextId()+"}");
           first = false;
        }
        buf.append("]");
    }
%><%= buf.toString() %>