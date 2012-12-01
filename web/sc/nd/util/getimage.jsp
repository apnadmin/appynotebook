<%
    try{
        {
            String fileName = request.getParameter("file_name");
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Transfer-Encoding", "binary");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");


            String filePath = com.feezixlabs.util.ConfigUtil.image_upload_directory+"/";

            if(new java.io.File(filePath+fileName).exists()){
                //write to response outputstream
                response.setHeader("Content-Length",""+ new java.io.File(filePath+fileName).length());


                java.io.OutputStream o = response.getOutputStream();

                java.io.InputStream is = new java.io.FileInputStream(new java.io.File(filePath+fileName));
                byte[] buf = new byte[32 * 1024]; // 32k buffer
                int nRead = 0;
                while( (nRead=is.read(buf)) != -1 ) {
                    o.write(buf, 0, nRead);
                }
                o.flush();
                o.close();// *important* to ensure no more jsp output
                is.close();
            }
        }
    }catch(Exception ex){
        //ex.printStackTrace();
    }
%>