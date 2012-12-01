<%

  try
  {

      StringBuffer buf = new StringBuffer();
      buf.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
      buf.append("<!DOCTYPE html    PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"    \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">");
      //buf.append("<!DOCTYPE html    PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"   \"resources/schema/xhtml/xhtml-1/xhtml1-strict.dtd\">");
      buf.append("<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">");
      buf.append("  <head><title></title>");

      //buf.append("  <style language=\"text/css\">");
      //buf.append("      body { background-color: none; ");
      //buf.append("  </style>");

      buf.append("</head>");

      buf.append("<body>"+request.getParameter("html")+"</body></html>");
      int width = new Double(request.getParameter("width")).intValue();
      //String filePath = com.feezixlabs.db.DBManager.UPLOAD_FILE_TEMP_PATH+"/html-"+java.util.UUID.randomUUID().toString()+".svg";


      String filePath = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/html-"+java.util.UUID.randomUUID().toString()+".xhtml";
      String imgfilePath = com.feezixlabs.util.ConfigUtil.image_upload_directory+"/html2png-"+request.getParameter("id")+".png";
      String svgfilePath = com.feezixlabs.util.ConfigUtil.image_upload_directory+"/html2svg-"+request.getParameter("id")+".svg";

      
      //System.out.println("Data:"+request.getParameter("html"));

      
      //java.io.FileWriter outFile = new java.io.FileWriter(filePath);
      //java.io.PrintWriter htmlout = new java.io.PrintWriter(outFile);
      //htmlout.println(buf.toString());
      //htmlout.close();

      
      if(false)
      {
        java.awt.image.BufferedImage imgbuff = null;//org.xhtmlrenderer.simple.Graphics2DRenderer.renderToImageAutoSize(filePath,width,java.awt.image.BufferedImage.TYPE_4BYTE_ABGR_PRE);
        org.xhtmlrenderer.simple.Graphics2DRenderer g2r = new org.xhtmlrenderer.simple.Graphics2DRenderer();
        g2r.setDocument(filePath);
        java.awt.Dimension dim = new java.awt.Dimension(width, 1000);

        // do layout with temp buffer
        java.awt.image.BufferedImage buff = new java.awt.image.BufferedImage((int) dim.getWidth(), (int) dim.getHeight(), java.awt.image.BufferedImage.TYPE_4BYTE_ABGR_PRE);
        java.awt.Graphics2D g = (java.awt.Graphics2D) buff.getGraphics();
        g2r.layout(g, new java.awt.Dimension(width, 1000));
        g.dispose();

        // get size
        java.awt.Rectangle rect = g2r.getMinimumSize();

        // render into real buffer
        imgbuff = new java.awt.image.BufferedImage((int) rect.getWidth(), (int) rect.getHeight(), java.awt.image.BufferedImage.TYPE_4BYTE_ABGR_PRE);
        g = (java.awt.Graphics2D) imgbuff.getGraphics();
        g2r.getPanel().setOpaque(false);//                .setBackground(java.awt.Color.ORANGE);
        g2r.render(g);
        g.dispose();

        javax.imageio.ImageIO.write(imgbuff, "png", new java.io.File(imgfilePath));
        new java.io.File(filePath).delete();
      }

      if(true)
      {
           javax.xml.parsers.DocumentBuilder documentBuilder = javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder();
           org.w3c.dom.Document svgDocument = documentBuilder.newDocument();

           /////////////////////////////Cleanup HTML////////////////////////////////////////////////////////////
           org.htmlcleaner.HtmlCleaner cleaner = new org.htmlcleaner.HtmlCleaner();
           org.htmlcleaner.CleanerProperties props = cleaner.getProperties();
           org.htmlcleaner.TagNode node = cleaner.clean(buf.toString());

           java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
           new org.htmlcleaner.PrettyHtmlSerializer(props).writeToStream(node, bos);
           /////////////////////////////////////////////////////////////////////////////////////////////////////

           
           java.io.StringReader contentReader = new java.io.StringReader(new String(bos.toByteArray()));
           org.xml.sax.InputSource source = new org.xml.sax.InputSource(contentReader);
           documentBuilder.setEntityResolver(new com.feezixlabs.util.ClassPathEntityResolver());
           org.w3c.dom.Document xhtmlContent = documentBuilder.parse(source);

           org.xhtmlrenderer.simple.Graphics2DRenderer renderer = new org.xhtmlrenderer.simple.Graphics2DRenderer();
           renderer.setDocument(xhtmlContent,"");

           //Used to work around a limitation in SVGGraphics2D
           java.awt.image.BufferedImage image = new java.awt.image.BufferedImage(width,1000,
                                                   java.awt.image.BufferedImage.TYPE_4BYTE_ABGR_PRE);
            java.awt.Graphics2D g = (java.awt.Graphics2D) image.getGraphics();
            g = (java.awt.Graphics2D) image.getGraphics();
            renderer.getPanel().setOpaque(false);//                .setBackground(java.awt.Color.ORANGE);
            renderer.render(g);
            g.dispose();

           java.awt.Graphics2D layoutGraphics = (java.awt.Graphics2D)image.getGraphics();
           // Create an instance of the SVG Generator
           org.apache.batik.svggen.SVGGeneratorContext ctx = org.apache.batik.svggen.SVGGeneratorContext.createDefault(svgDocument);
           ctx.setEmbeddedFontsOn(true);
           ctx.setPrecision(12);
           org.apache.batik.svggen.SVGGraphics2D svgGenerator = new org.apache.batik.svggen.SVGGraphics2D(ctx,false);
           renderer.layout(layoutGraphics,new java.awt.Dimension(width,1000));
           renderer.render(svgGenerator);

           // Finally, stream out SVG to the browser
           svgGenerator.stream(svgfilePath);
           java.io.File outFile = new java.io.File(svgfilePath);
           String svgData = org.apache.commons.io.FileUtils.readFileToString(outFile);
           outFile.delete();
           //response.setContentType("image/svg+xml");
           response.setContentType("text/plain");
           //java.io.Writer browserOutput = response.getWriter();
           //svgGenerator.stream(browserOutput, true);

          
           java.util.Map map = new java.util.HashMap();
           map.put("width",new Integer(image.getWidth()));
           map.put("height",new Integer(image.getWidth()));
           map.put("data",new String(svgData));
           out.print(net.sf.json.JSONObject.fromObject(map));


           //out.print("{width:\""+image.getWidth()+"\",height:\""+image.getHeight()+"\",data:\""+svgData+"\"}");
           //

           //response.setContentType("text/plain");
           //out.print("{width:"+imgbuff.getWidth()+",height:"+imgbuff.getHeight()+"}");
      }


      if(false)
      {
        response.setContentType("text/plain");
        //out.print("{width:"+imgbuff.getWidth()+",height:"+imgbuff.getHeight()+"}");
      }      
  }
  catch (java.io.IOException e){
    e.printStackTrace();
  }
%>