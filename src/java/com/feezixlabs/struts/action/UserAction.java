/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.struts.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;

/**
 *
 * @author bitlooter
 */
public class UserAction extends org.apache.struts.action.Action {    
    /**
     * This is the action called from the Struts framework.
     * @param mapping The ActionMapping used to select this instance.
     * @param form The optional ActionForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     * @throws java.lang.Exception
     * @return
     */
    @Override
    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        if(request.getParameter("action").compareToIgnoreCase("load-users")==0){
            com.feezixlabs.struts.action.handler.UserActionHandler.messagePump(request);
            return mapping.findForward("load-users");
        }else{
            request.setAttribute("message",com.feezixlabs.struts.action.handler.UserActionHandler.messagePump(request));
            return mapping.findForward("ajax-response");
        }
    }
}
