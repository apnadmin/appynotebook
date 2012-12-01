<%-- 
    Document   : access-control
    Created on : Jan 18, 2012, 3:17:53 PM
    Author     : bitlooter
--%><%

        int padId = 0;
        int contextId = 0;
        try{
            padId = new Integer(request.getParameter("pad_id"));
            contextId = new Integer(request.getParameter("context_id"));
        }catch(Exception ex){/*return;*/}

        
        int roomId = new Integer(request.getParameter("room_id"));
        com.feezixlabs.bean.Room room = com.feezixlabs.db.dao.RoomDAO.getRoom(request.getUserPrincipal().getName(), roomId);
        int userId = com.feezixlabs.db.dao.UserDOA.getUserId(request.getUserPrincipal().getName());

        StringBuffer buf = new StringBuffer();
        java.util.List< com.feezixlabs.bean.Context> contexts = com.feezixlabs.db.dao.ContextDAO.getContexts(request.getUserPrincipal().getName(),room.getId(),userId);

        net.sf.json.JsonConfig jsonConfig = new net.sf.json.JsonConfig();
        jsonConfig.setJavascriptCompliant(true);

        buf.append("<?xml version='1.0' encoding='utf-8'?>\n");
        buf.append("<rows>");
        buf.append("<page>1</page>");
        buf.append("<total>1</total>");
        buf.append("<records>1</records>");

        //Helper for selecting all items
        if(contexts.size()>0 && false){
            buf.append("<row>");
            buf.append(" <cell>all</cell>");

            buf.append(" <cell><![CDATA[ALL]]></cell>");
            buf.append(" <cell><![CDATA[<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-read-all-checkbox\" value=\"read\"/>]]></cell>");
            buf.append(" <cell><![CDATA[<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-write-all-checkbox\" value=\"write\"/>]]></cell>");
            buf.append(" <cell><![CDATA[]]></cell>");
            buf.append(" <cell><![CDATA[]]></cell>");
            buf.append(" <cell><![CDATA[]]></cell>");


            buf.append(" <cell>0</cell>");
            buf.append(" <cell><![CDATA[NULL]]></cell>");

            buf.append(" <cell>true</cell>");
            buf.append(" <cell>false</cell>");
            buf.append("</row>");
        }
        
        for( com.feezixlabs.bean.Context context:contexts){
            java.util.List< com.feezixlabs.bean.Pad> pads = com.feezixlabs.db.dao.PadDAO.getPads(request.getUserPrincipal().getName(),room.getId(),context.getId(),userId);


            String readOnChange = "onchange=\"ColabopadApplication.setContextAccess("+context.getId()+",'read',$(this).attr('checked'))\"";
            String writeOnChange = "onchange=\"ColabopadApplication.setContextAccess("+context.getId()+",'write',$(this).attr('checked'))\"";

            buf.append("<row>");
            buf.append(" <cell>"+context.getId()+"</cell>");

            buf.append(" <cell><![CDATA["+net.sf.json.JSONObject.fromObject(context.getConfig(),jsonConfig).getString("title")+"]]></cell>");
            
            String contextReadCheckbox = "<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-read-checkbox-"+context.getId()+"\" value=\"read\" "+readOnChange+"/>";
            String contextWriteChecbox = "<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-write-checkbox-"+context.getId()+"\" value=\"write\" "+writeOnChange+"/>";
            buf.append(" <cell><![CDATA["+contextReadCheckbox+"]]></cell>");
            buf.append(" <cell><![CDATA["+contextWriteChecbox+"]]></cell>");
            buf.append(" <cell><![CDATA[]]></cell>");
            buf.append(" <cell><![CDATA[]]></cell>");
            buf.append(" <cell><![CDATA[]]></cell>");
            

            buf.append(" <cell>0</cell>");
            buf.append(" <cell><![CDATA[NULL]]></cell>");

            buf.append(" <cell>"+(pads.size()==0)+"</cell>");
            buf.append(" <cell>false</cell>");
            buf.append("</row>");


            
            //Helper for selecting all items
            if(pads.size()>0 && false){
                buf.append("<row>");
                buf.append(" <cell>all-"+(context.getId())+"</cell>");

                buf.append(" <cell><![CDATA[ALL]]></cell>");
                buf.append(" <cell><![CDATA[<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-read-all-checkbox-"+(context.getId())+"\" value=\"read\"/>]]></cell>");
                buf.append(" <cell><![CDATA[<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-write-all-checkbox-"+(context.getId())+"\" value=\"write\"/>]]></cell>");
                buf.append(" <cell><![CDATA[]]></cell>");
                buf.append(" <cell><![CDATA[]]></cell>");
                buf.append(" <cell><![CDATA[]]></cell>");

                buf.append(" <cell>1</cell>");
                buf.append(" <cell>"+context.getId()+"</cell>");

                buf.append(" <cell>true</cell>");
                buf.append(" <cell>false</cell>");
                buf.append("</row>");
            }

            //json.append((j++>0?",":"")+"{meta_data:"+context.getConfig()+",id:"+context.getId()+",access:["+context.getAccessControl()+",0,"+context.getAccess()+"],pads:[");
            for( com.feezixlabs.bean.Pad pad:pads){
                //json.append((i++>0?",":"")+  "{meta_data:"+pad.getConfig()+",id:"+pad.getId()+",access:["+pad.getAccessControl()+",0,"+pad.getAccess()+"],embed_key:\""+pad.getEmbedKey()+"\"}");

                //this mean to allow access edit of data elements only for active page
                boolean activePage = true;//contextId == context.getId() && padId == pad.getId();
                java.util.List< com.feezixlabs.bean.Element> elements = com.feezixlabs.db.dao.ElementDAO.getElements(request.getUserPrincipal().getName(),roomId,context.getId(),pad.getId(),userId);

                readOnChange = "onchange=\"ColabopadApplication.setPadAccess("+context.getId()+","+pad.getId()+",'read',$(this).attr('checked'))\"";
                writeOnChange = "onchange=\"ColabopadApplication.setPadAccess("+context.getId()+","+pad.getId()+",'write',$(this).attr('checked'))\"";
                String embedOnChange = "onchange=\"ColabopadApplication.setPadAccess("+context.getId()+","+pad.getId()+",'embed',$(this).attr('checked'))\"";

                buf.append("<row>");
                buf.append(" <cell>"+(context.getId()+"-"+pad.getId())+"</cell>");

                buf.append(" <cell><![CDATA["+net.sf.json.JSONObject.fromObject(pad.getConfig(),jsonConfig).getString("title")+"]]></cell>");
                buf.append(" <cell><![CDATA[<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-read-checkbox-"+(context.getId()+"-"+pad.getId())+"\" value=\"read\" "+readOnChange+" />]]></cell>");
                buf.append(" <cell><![CDATA[<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-write-checkbox-"+(context.getId()+"-"+pad.getId())+"\" value=\"write\" "+writeOnChange+" />]]></cell>");
                buf.append(" <cell><![CDATA[]]></cell>");
                buf.append(" <cell><![CDATA[]]></cell>");
                buf.append(" <cell><![CDATA[<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-embed-checkbox-"+(context.getId()+"-"+pad.getId())+"\" value=\"embed\" "+embedOnChange+" />]]></cell>");
                
                buf.append(" <cell>1</cell>");
                buf.append(" <cell>"+context.getId()+"</cell>");

                buf.append(" <cell>"+(elements.size()==0 || !activePage)+"</cell>");
                buf.append(" <cell>false</cell>");
                buf.append("</row>");

                if(!activePage)continue;
                
                //Helper for selecting all items
                if(elements.size()>0 && false){
                    buf.append("<row>");
                    buf.append(" <cell>all-"+(context.getId()+"-"+pad.getId())+"</cell>");

                    buf.append(" <cell><![CDATA[ALL]]></cell>");
                    buf.append(" <cell><![CDATA[<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-read-all-checkbox-"+(context.getId()+"-"+pad.getId())+"\" value=\"read\"/>]]></cell>");
                    buf.append(" <cell><![CDATA[<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-write-all-checkbox-"+(context.getId()+"-"+pad.getId())+"\" value=\"write\"/>]]></cell>");
                    buf.append(" <cell><![CDATA[]]></cell>");
                    buf.append(" <cell><![CDATA[]]></cell>");
                    buf.append(" <cell><![CDATA[]]></cell>");

                    buf.append(" <cell>2</cell>");
                    buf.append(" <cell>"+(context.getId()+"-"+pad.getId())+"</cell>");

                    buf.append(" <cell>true</cell>");
                    buf.append(" <cell>false</cell>");
                    buf.append("</row>");
                }

                //System.out.println("elements:"+elements.size());
                //if(false)
                for( com.feezixlabs.bean.Element element:elements){
                    //json.append((j++>0?",":"")+ "{id:"+element.getId()+",config:"+element.getConfig()+",access:["+element.getAccessControl()+",0,"+element.getAccess()+"]}");

                    readOnChange = "onchange=\"ColabopadApplication.setElementAccess("+context.getId()+","+pad.getId()+","+element.getId()+",'read',$(this).attr('checked'))\"";
                    writeOnChange = "onchange=\"ColabopadApplication.setElementAccess("+context.getId()+","+pad.getId()+","+element.getId()+",'write',$(this).attr('checked'))\"";

                    buf.append("<row>");
                    buf.append(" <cell>"+(context.getId()+"-"+pad.getId()+"-"+element.getId())+"</cell>");
                    
                    String title = "Unknown";
                    try{
                        if(net.sf.json.JSONObject.fromObject(element.getConfig(),jsonConfig).has("header")){
                            if(net.sf.json.JSONObject.fromObject(element.getConfig(),jsonConfig).getJSONObject("header").has("label"))
                                title = "<span style=\"font-weight:bold\">"+net.sf.json.JSONObject.fromObject(element.getConfig(),jsonConfig).getJSONObject("header").getString("label")+"</span>";
                        }
                        if(title.compareTo("Unknown") == 0)
                            title = net.sf.json.JSONObject.fromObject(element.getConfig(),jsonConfig).getString("type");
                    }
                    catch(Exception ex){}

                    buf.append(" <cell><![CDATA["+title+"]]></cell>");
                    buf.append(" <cell><![CDATA[<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-read-checkbox-"+(context.getId()+"-"+pad.getId()+"-"+element.getId())+"\" value=\"read\" "+readOnChange+" />]]></cell>");
                    buf.append(" <cell><![CDATA[<input class=\"acl-checkbox\" type=\"checkbox\" id=\"acl-write-checkbox-"+(context.getId()+"-"+pad.getId()+"-"+element.getId())+"\" value=\"write\" "+writeOnChange+" />]]></cell>");
                    buf.append(" <cell><![CDATA[]]></cell>");
                    buf.append(" <cell><![CDATA[]]></cell>");
                    buf.append(" <cell><![CDATA[]]></cell>");
                    
                    buf.append(" <cell>2</cell>");
                    buf.append(" <cell>"+(context.getId()+"-"+pad.getId())+"</cell>");

                    buf.append(" <cell>true</cell>");
                    buf.append(" <cell>false</cell>");
                    buf.append("</row>");
                }
            }
        }
        buf.append("</rows>");
%><%=buf.toString() %>