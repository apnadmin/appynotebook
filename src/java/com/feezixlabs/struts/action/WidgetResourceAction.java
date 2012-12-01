/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.struts.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 *
 * @author bitlooter
 */
public class WidgetResourceAction extends org.apache.struts.action.Action {
    
    /* forward name="success" path="" */
    private static final String SUCCESS = "success";
    
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
        if(request.getParameter("action").compareToIgnoreCase("add-widget-resource")==0){
            com.feezixlabs.struts.action.handler.WidgetResourceActionHandler.messagePump(request);
            return mapping.findForward("add-resource");
        }
        else
        if(request.getParameter("action").compareToIgnoreCase("upload-package")==0){
            com.feezixlabs.struts.action.handler.WidgetResourceActionHandler.messagePump(request);
            return mapping.findForward("upload-package");
        }
        else
        if(request.getParameter("action").compareToIgnoreCase("import-package")==0){
            com.feezixlabs.struts.action.handler.WidgetResourceActionHandler.messagePump(request);
            return mapping.findForward("import-package");
        }
        else{
            request.setAttribute("message",com.feezixlabs.struts.action.handler.WidgetResourceActionHandler.messagePump(request));
            return mapping.findForward("ajax-response");
        }
    }
}
