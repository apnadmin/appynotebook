<%
  String action = request.getParameter("action");
  StringBuffer jsonReply = new StringBuffer();
  if (action.compareToIgnoreCase("approve-signup") == 0){
        com.feezixlabs.db.DBManager.approveSignUpRequest(new Integer(request.getParameter("id")), request.getParameter("security_token"));
        jsonReply.append("done");
  }
  else 
  if (action.compareToIgnoreCase("reject-signup") == 0){
        com.feezixlabs.db.DBManager.rejectSignUpRequest(new Integer(request.getParameter("id")), request.getParameter("security_token"));
        jsonReply.append("done");
  }
  else 
  if (action.compareToIgnoreCase("load-embed-pad") == 0){
           
           
           com.feezixlabs.bean.Pad pad = com.feezixlabs.db.dao.PadDAO.getEmbededPad(request.getParameter("embed_key"));

           if(pad != null){
               jsonReply.append("{room_id:"+pad.getRoomId()+",participant_id:"+pad.getParticipantId()+",context_id:"+pad.getContextId()+",pad_id:"+pad.getId()+",meta_data:"+pad.getConfig()+",access:["+pad.getAccessControl()+",0,"+pad.getAccess()+"],embed_key:\""+pad.getEmbedKey()+"\",elements:");
               java.util.List<com.feezixlabs.bean.Element> elements = com.feezixlabs.db.dao.ElementDAO.getEmbededElements(pad.getRoomId(),pad.getContextId(),pad.getId(), pad.getParticipantId());
               int j = 0;

               jsonReply.append("[");
               for(com.feezixlabs.bean.Element element:elements){
                    jsonReply.append((j++>0?",":"")+ "{id:"+element.getId()+",config:"+element.getConfig()+"}");
               }
               jsonReply.append("],status:\"success\"}");
          }else{
             jsonReply.append("{\"status\":\"failed\"}");
           }
    }
    else 
    if (action.compareTo("check-domain-exists") == 0){         
        
        jsonReply.append("{\"exists\":"+ (com.feezixlabs.db.dao.MiscDAO.getAccountSignUp(request.getParameter("subdomain"))>0)+"}");
    }
    else 
    if (action.compareTo("account-sign-up") == 0){
        if(com.feezixlabs.db.dao.MiscDAO.getAccountSignUp(request.getParameter("subdomain"))==0){            
        
            String stripeToken          = request.getParameter("token");
            String stripeCustomerId     = null;
            String serviceDomain        = request.getParameter("subdomain");
            String fullName             = request.getParameter("fullname");
            String emailAddress         = request.getParameter("emailaddress");
            String phone                = request.getParameter("phone");
            String organizationName     = request.getParameter("companyname");
            String serviceRegion        = request.getParameter("geozone");
            String servicePlan          = request.getParameter("service-plan");
            String paymentPlan          = request.getParameter("payment-plan");
            String paymentMethod        = request.getParameter("payment-method");

            if(stripeToken != null){
                java.util.HashMap<String,Object> customerParams = new java.util.HashMap<String, Object>();
                customerParams.put("card",stripeToken);
                customerParams.put("description", serviceDomain);
                try{
                    com.stripe.model.Customer customer = com.stripe.model.Customer.create(customerParams);
                    stripeCustomerId = customer.getId();
                }catch(com.stripe.exception.StripeException ex){

                }
            }
            String notification = "Hi "+fullName.split(" ")[0]+"! <br/> Thank you for your interest in appynote. We are happy to have you as a customer!  <br/>A service rep will contact you soon with details for setting up your new APPYnote service.";
            com.feezixlabs.db.dao.MiscDAO.addAccountSignUp(serviceDomain, fullName, emailAddress, phone, organizationName, serviceRegion, servicePlan, paymentMethod, paymentPlan, "", stripeCustomerId, stripeToken);
            com.feezixlabs.util.Utility.sendEmail(emailAddress, "APPYnote service signup confirmation", notification,true,com.feezixlabs.util.ConfigUtil.account_create_notifier,com.feezixlabs.util.ConfigUtil.account_create_notifier, com.feezixlabs.util.ConfigUtil.account_create_notifier_password);
            
            
            notification = "<b>fullName</b>:"+fullName+"<br/>"+
                           "<b>emailAddress</b>:"+emailAddress+"<br/>"+
                           "<b>phone</b>:"+phone+"<br/>"+
                           "<b>organizationName</b>:"+organizationName+"<br/>"+
                           "<b>serviceRegion</b>:"+serviceRegion+"<br/>"+
                           "<b>servicePlan</b>:"+servicePlan+"<br/>"+
                           "<b>paymentPlan</b>:"+paymentPlan+"<br/>"+
                           "<b>paymentMethod</b>:"+paymentMethod+"<br/>"+
                           "<b>serviceDomain</b>:"+serviceDomain+"<br/>";
            com.feezixlabs.util.Utility.sendEmail("ekemokai@gmail.com", "APPYnote service signup request", notification,true,com.feezixlabs.util.ConfigUtil.account_create_notifier,com.feezixlabs.util.ConfigUtil.account_create_notifier, com.feezixlabs.util.ConfigUtil.account_create_notifier_password);
            jsonReply.append("{\"status\":\"success\"}");
        }else{
            jsonReply.append("{\"status\":\"failure\",\"exists\":"+true+"}");
        }
    }
%><%=jsonReply.toString() %>