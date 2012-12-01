<%
  try{
        request.getSession().setAttribute("running_upload_status","running");
        request.getSession().removeAttribute("error-message");
        
        org.apache.batik.transcoder.Transcoder transcoder = new org.apache.batik.transcoder.image.PNGTranscoder();

        org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/pngtest.svg"), request.getParameter("svg"));

        /***TERRIBLE HACK***/
        String svg = request.getParameter("svg").replaceAll(" href=", " xlink:href=");
        //System.out.println("svg:"+svg);
        //Setup input
        java.io.InputStream in = new java.io.ByteArrayInputStream(svg/*replaceAll("util/getimage.jsp", com.feezixlabs.util.ConfigUtil.baseUrl+"/util/getimage.jsp")*/.getBytes("UTF-8"));
        
        String temppdf = java.util.UUID.randomUUID().toString()+".png";

        java.io.File tempfile = new java.io.File(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+temppdf);
        tempfile.createNewFile();
        java.io.InputStream is = new java.io.FileInputStream(tempfile);
        java.io.OutputStream pdfout    = new java.io.FileOutputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+temppdf));

        transcoder.addTranscodingHint(org.apache.batik.transcoder.XMLAbstractTranscoder.KEY_XML_PARSER_VALIDATING, Boolean.FALSE);
        org.apache.batik.transcoder.TranscoderOutput output = new org.apache.batik.transcoder.TranscoderOutput(pdfout);
        org.apache.batik.transcoder.TranscoderInput input = new org.apache.batik.transcoder.TranscoderInput(in);


        java.io.OutputStream o = null;
        String fileName = request.getParameter("file_name") != null && request.getParameter("file_name").length()>0? request.getParameter("file_name")+".png":"note.png";
        try {
                transcoder.transcode(input, output);
                response.setHeader("Content-disposition", "attachment; filename="+fileName);
                response.setHeader("Content-Transfer-Encoding", "binary");
                response.setHeader("Pragma", "no-cache");
                response.setHeader("Expires", "0");
                response.setContentType ("image/png;charset=utf-8");
                       
                o = response.getOutputStream();
                byte[] buf = new byte[32 * 1024]; // 32k buffer
                int nRead = 0;
                while( (nRead=is.read(buf)) != -1 ) {
                    o.write(buf, 0, nRead);
                }
        }
        catch(Exception ex){
            request.getSession().setAttribute("error-message",org.apache.commons.lang.exception.ExceptionUtils.getStackTrace(ex));
           ex.printStackTrace();
           throw ex;
        }

        finally {
            o.flush();
            o.close();
            in.close();
            pdfout.close();
            tempfile.delete();
            
            com.feezixlabs.bean.Feature feature = com.feezixlabs.db.dao.MiscDAO.getFeatureMatrixEntry("export");
            com.feezixlabs.bean.FeatureUsage featureUsage = com.feezixlabs.db.dao.MiscDAO.getFeatureUsage(request.getUserPrincipal().getName(), feature.getId());
            com.feezixlabs.db.dao.MiscDAO.updateFeatureUsage(request.getUserPrincipal().getName(), feature.getId(), ""+(Integer.parseInt(featureUsage.getUsage())+1));            
        }
        request.getSession().setAttribute("running_upload_status","done");
   }catch(Exception ex){
        request.getSession().removeAttribute("running_upload_status"); 
        
        java.util.HashMap error = new java.util.HashMap();
        error.put("src","png");
        error.put("type","exception");
        
        if(request.getSession().getAttribute("error-message") == null){            
            error.put("stack_trace",org.apache.commons.lang.exception.ExceptionUtils.getStackTrace(ex));
        }else{
            error.put("stack_trace",request.getSession().getAttribute("error-message").toString());
        }
        request.getSession().setAttribute("exception",net.sf.json.JSONObject.fromObject(error).toString());
        
        Thread.sleep(5000);//wait for client to get error condition
        response.sendRedirect(response.encodeRedirectURL("export-error.jsp"));
   }
%>