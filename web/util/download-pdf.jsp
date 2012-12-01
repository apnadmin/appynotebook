<%
  try{
        request.getSession().setAttribute("running_upload_status","running");
        request.getSession().removeAttribute("error-message");
        
        //make sure they have right to take this action
        if(/*!com.feezixlabs.util.FeatureAccessManager.hasAccess("export", request)*/false){
            request.getSession().removeAttribute("running_upload_status");
            response.sendRedirect("export-error.jsp?src=pdf&type=limit");return;
        }
        
        
        //Object forceError = null;
        //forceError.getClass();        
        
        //org.apache.batik.transcoder.Transcoder transcoder = new org.apache.fop.svg.PDFTranscoder();
        org.apache.fop.svg.PDFTranscoder transcoder = new org.apache.fop.svg.PDFTranscoder();
        /*try {
            org.apache.avalon.framework.configuration.DefaultConfigurationBuilder cfgBuilder = new org.apache.avalon.framework.configuration.DefaultConfigurationBuilder();
            org.apache.avalon.framework.configuration.Configuration cfg = cfgBuilder.buildFromFile(new java.io.File("/home/bitlooter/development/java/feezixlabs/web/WEB-INF/pdf-renderer-cfg.xml"));
            org.apache.avalon.framework.container.ContainerUtil.configure(transcoder, cfg);
        } catch (Exception e) {
            throw new org.apache.batik.transcoder.TranscoderException(e);
        }
        
        final int dpi = 300;
        transcoder.addTranscodingHint(org.apache.batik.transcoder.image.ImageTranscoder.KEY_PIXEL_UNIT_TO_MILLIMETER, 
                new Float((float)(25.4 / dpi))); 
        transcoder.addTranscodingHint(org.apache.batik.transcoder.XMLAbstractTranscoder.KEY_XML_PARSER_VALIDATING, Boolean.FALSE);
        transcoder.addTranscodingHint(org.apache.fop.svg.PDFTranscoder.KEY_STROKE_TEXT, Boolean.FALSE);
        */
        //transcoder.addTranscodingHint(org.apache.batik.transcoder.XMLAbstractTranscoder.KEY_XML_PARSER_VALIDATING, Boolean.FALSE);

        //org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/test1.svg"), request.getParameter("svg"));
        //String canvasSVG = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/canvas.svg";
        //org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(canvasSVG), request.getParameter("svg"));

        //Setup input
        java.io.InputStream in = new java.io.ByteArrayInputStream(request.getParameter("svg").replaceAll(" href=", " xlink:href=")/*.replaceAll("util/getimage.jsp", com.feezixlabs.util.ConfigUtil.baseUrl+"/util/getimage.jsp")*/.getBytes("UTF-8"));
        
        String temppdf = java.util.UUID.randomUUID().toString()+".pdf";

        java.io.File tempfile = new java.io.File(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+temppdf);
        tempfile.createNewFile();
        java.io.InputStream is = new java.io.FileInputStream(tempfile);
        java.io.OutputStream pdfout    = new java.io.FileOutputStream(new java.io.File(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+temppdf));

        org.apache.batik.transcoder.TranscoderOutput output = new org.apache.batik.transcoder.TranscoderOutput(pdfout);
        org.apache.batik.transcoder.TranscoderInput input = new org.apache.batik.transcoder.TranscoderInput(in);

        java.io.OutputStream o = null;
        String fileName = request.getParameter("file_name") != null && request.getParameter("file_name").length()>0? request.getParameter("file_name")+".pdf":"note.pdf";
        try {
                transcoder.transcode(input, output);
                response.setHeader("Content-disposition", "attachment; filename="+fileName);
                response.setHeader("Content-Transfer-Encoding", "binary");
                response.setHeader("Pragma", "no-cache");
                response.setHeader("Expires", "0");
                response.setContentType("application/pdf");

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
        }
        request.getSession().setAttribute("running_upload_status","done");
   }catch(Exception ex){
        request.getSession().removeAttribute("running_upload_status"); 
        
        java.util.HashMap error = new java.util.HashMap();
        error.put("src","pdf");
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