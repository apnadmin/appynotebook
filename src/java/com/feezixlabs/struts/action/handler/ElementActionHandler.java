/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.struts.action.handler;

import com.feezixlabs.bean.Room;
import com.feezixlabs.bean.Element;
import com.feezixlabs.util.ConfigUtil;

import javax.servlet.http.HttpServletRequest;
/**
 *
 * @author bitlooter
 */
public class ElementActionHandler {
    static String getElements(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int grantor = new Integer(request.getParameter("grantor"));
        int contextId = new Integer(request.getParameter("context_id"));
        int padId = new Integer(request.getParameter("pad_id"));

        com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());
        com.feezixlabs.bean.User grantorUser = com.feezixlabs.db.dao.UserDOA.getUserById(grantor);

        StringBuffer json = new StringBuffer();
        java.util.List<Element> elements = com.feezixlabs.db.dao.ElementDAO.getElements(request.getUserPrincipal().getName(),roomId,contextId,padId,grantor);
        int j = 0;

        json.append("[");
        for(Element element:elements){
            com.feezixlabs.bean.ElementAccess elementAccess = com.feezixlabs.db.dao.ElementAccessDAO.getElementAccess(grantorUser.getUserName(),roomId,contextId,padId,element.getId(),user.getId());
            json.append((j++>0?",":"")+ "{\"created_by\":"+element.getCreatedBy()+",\"create_date\":\""+element.getCreateDate()+"\",\"id\":"+element.getId()+",\"config\":"+element.getConfig()+",\"access\":["+element.getAccessControl()+",0,"+elementAccess.getAccess()+",0]}");
        }
        json.append("]");

        return json.toString();
    }
    
    static String getElement(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int grantor = new Integer(request.getParameter("grantor"));
        int contextId = new Integer(request.getParameter("context_id"));
        int padId = new Integer(request.getParameter("pad_id"));
        int elementId = new Integer(request.getParameter("element_id"));

        StringBuilder json = new StringBuilder();
        Element element = com.feezixlabs.db.dao.ElementDAO.getElement(request.getUserPrincipal().getName(),roomId,contextId,padId,elementId,grantor);
            ///com.feezixlabs.bean.ElementAccess elementAccess = com.feezixlabs.db.dao.ElementAccessDAO.getElementAccess(grantorUser.getUserName(),roomId,contextId,padId,element.getId(),user.getId());
        json.append("{\"created_by\":"+element.getCreatedBy()+",\"create_date\":\""+element.getCreateDate()+"\",\"id\":"+element.getId()+",\"config\":"+element.getConfig()+",\"access\":["+element.getAccessControl()+",0,"+element.getAccess()+",0]}");

        return json.toString();
    }
    
    static String addElement(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int grantor = new Integer(request.getParameter("grantor"));
        int contextId = new Integer(request.getParameter("context_id"));
        int padId = new Integer(request.getParameter("pad_id"));
        String config = request.getParameter("config");

        System.out.println("access1:"+request.getParameter("access"));
        int elementId = com.feezixlabs.db.dao.ElementDAO.addElement(request.getUserPrincipal().getName(),roomId,contextId,padId,config,grantor,com.feezixlabs.util.ConfigUtil.ACCESS_NONE);
        
        //apply access control
        updateInstanceAccess(request,roomId,contextId,padId,elementId,grantor,true);
        
        return "{id:"+elementId+"}";
    }

    static void updateInstanceAccess(HttpServletRequest request,int roomId,int contextId,int padId,int id,int grantor,boolean applyDefault){
        //setup access control
        int[][] access = new int[0][0];
        if(request.getParameter("access") != null && request.getParameter("access").compareTo("-1") != 0){
            System.out.println("access2:"+request.getParameter("access"));
            try{
                //first assume it is global
                int globalAccess = Integer.parseInt(request.getParameter("access"));
                access = new int[1][2];
                access[0][0] = 0;
                access[0][1] = globalAccess;
            }catch(Exception ex){
                
                System.out.println("access3:"+request.getParameter("access"));
                
                net.sf.json.JSONArray accessList = net.sf.json.JSONArray.fromObject(request.getParameter("access"));
                
                if(accessList.size()>0){
                    access = new int[accessList.size()][2];

                    for(int i=0;i<accessList.size();i++){
                        access[i][0] = accessList.getJSONObject(i).getInt("user_id");
                        access[i][1] = accessList.getJSONObject(i).getInt("access");
                    }
                }else{
                    access[0][0] = 0;
                    access[0][1] = ConfigUtil.default_element_access;                    
                }
            }
        }else
        if(applyDefault)
        {//apply default access
                access = new int[1][2];
                access[0][0] = 0;
                access[0][1] = ConfigUtil.default_element_access;
        }

        //update access
        for(int i=0;i<access.length;i++)
            com.feezixlabs.db.dao.ElementAccessDAO.updateElementAccess(request.getUserPrincipal().getName(), roomId, contextId, padId,id,grantor,access[i][0],access[i][1]);
    }

    static void updateElement(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int grantor = new Integer(request.getParameter("grantor"));
        int contextId = new Integer(request.getParameter("context_id"));
        int padId = new Integer(request.getParameter("pad_id"));
        int id = new Integer(request.getParameter("id"));
        String config = request.getParameter("config");
        com.feezixlabs.db.dao.ElementDAO.updateElement(request.getUserPrincipal().getName(),roomId,contextId,padId,id,config,grantor);

        updateInstanceAccess(request,roomId,contextId,padId,id,grantor,false);
    }
    static void updateElementAccess(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int contextId = new Integer(request.getParameter("context_id"));
        int padId = new Integer(request.getParameter("pad_id"));
        int elementId = new Integer(request.getParameter("element_id"));
        int grantor = new Integer(request.getParameter("grantor"));
        int grantedTo = new Integer(request.getParameter("granted_to"));
        int accessControl = new Integer(request.getParameter("access"));
        com.feezixlabs.db.dao.ElementAccessDAO.updateElementAccess(request.getUserPrincipal().getName(), roomId, contextId, padId,elementId,grantor, grantedTo,accessControl);
    }
    static String deleteElement(HttpServletRequest request){
        int roomId = new Integer(request.getParameter("room_id"));
        int grantor = new Integer(request.getParameter("grantor"));
        int contextId = new Integer(request.getParameter("context_id"));
        int padId = new Integer(request.getParameter("pad_id"));
        int id = new Integer(request.getParameter("id"));
        return "{id:"+com.feezixlabs.db.dao.ElementDAO.deleteElement(request.getUserPrincipal().getName(),roomId,contextId,padId,id,grantor)+"}";
    }

    public static String messagePump(HttpServletRequest request){
        String action = request.getParameter("action");
        if(action.compareToIgnoreCase("get-elements") == 0){
            return getElements(request);
        }
        else
        if(action.compareToIgnoreCase("get-element") == 0){
            return getElement(request);
        }        
        else
        if(action.compareToIgnoreCase("add-element") == 0){
            return addElement(request);
        }
        else
        if(action.compareToIgnoreCase("update-element") == 0){
            updateElement(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("delete-element") == 0){
            return deleteElement(request);
        }
        else
        if(action.compareToIgnoreCase("update-element-access") == 0){
            updateElementAccess(request);
            return "{status:'success'}";
        }
        else
        if(action.compareToIgnoreCase("update-instance-access") == 0){
            int roomId = new Integer(request.getParameter("room_id"));
            int contextId = new Integer(request.getParameter("context_id"));
            int padId = new Integer(request.getParameter("pad_id"));
            int elementId = new Integer(request.getParameter("element_id"));
            int grantor = new Integer(request.getParameter("grantor"));
            updateInstanceAccess(request,roomId,contextId,padId,elementId,grantor,false);
            return "{status:'success'}";
        }
        return "";
    }
}
