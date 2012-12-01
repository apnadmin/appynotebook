<%
  try{
        request.getSession().setAttribute("running_upload_status","running");
        request.getSession().removeAttribute("error-message");
       //make sure they have right to take this action
        if(!com.feezixlabs.util.FeatureAccessManager.hasAccess("export", request)){
            request.getSession().removeAttribute("running_upload_status");
            response.sendRedirect("export-error.jsp?src=png&type=limit");
            return;
        }

        
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

    /*
    String filePath = "/home/bitlooter/colabopad-tmp";
    String sid = request.getSession().getId();
    String svg = request.getParameter("svg");

    new java.io.File(filePath+"/page-"+sid+".svg").createNewFile();
    //write svg file
    java.io.FileOutputStream os = new java.io.FileOutputStream(filePath+"/page-"+sid+".svg");
    os.write(svg.getBytes());
    os.close();

    //convert to png
    String[] command = {"convert",filePath+"/page-"+sid+".svg",filePath+"/note-"+sid+".png"};
    {
        final Process process = Runtime.getRuntime().exec(command);
        int returnCode = process.waitFor();
    }

    //write to response outputstream
    response.setHeader("Content-Length",""+ new java.io.File(filePath+"/note-"+sid+".png").length());
    java.io.OutputStream o = response.getOutputStream();
    java.io.InputStream is = new java.io.FileInputStream(new java.io.File(filePath+"/note-"+sid+".png"));
    byte[] buf = new byte[32 * 1024]; // 32k buffer
    int nRead = 0;
    while( (nRead=is.read(buf)) != -1 ) {
        o.write(buf, 0, nRead);
    }
    o.flush();
    o.close();// *important* to ensure no more jsp output

    new java.io.File(filePath+"/page-"+sid+".svg").delete();
    new java.io.File(filePath+"/note-"+sid+".png").delete();

    /*
    String[] delcommand = {"rm",filePath+"/note-"+sid+".*"};
    {
        final Process process = Runtime.getRuntime().exec(delcommand);
        int returnCode = process.waitFor();
    }
    */
   }catch(Exception ex){
            request.getSession().removeAttribute("running_upload_status");  
            if(request.getSession().getAttribute("error-message") == null)
                request.getSession().setAttribute("error-message",org.apache.commons.lang.exception.ExceptionUtils.getStackTrace(ex));
            response.sendRedirect(response.encodeRedirectURL("export-error.jsp?src=png&type=exception"));
            return;
   }
%>