<%
    try{
        request.getSession().setAttribute("running_upload_status","running");
        request.getSession().removeAttribute("error-message");
        
        //make sure they have right to take this action
        if(/*!com.feezixlabs.util.FeatureAccessManager.hasAccess("export", request)*/false){
            request.getSession().removeAttribute("running_upload_status");
            response.sendRedirect("export-error.jsp?src=pdf&type=limit");
            return;
        }
        //Object forceError = null;
        //forceError.getClass();
        
        String canvasPDF = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+java.util.UUID.randomUUID().toString()+"-svg-.pdf";
        String textPDF   = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+java.util.UUID.randomUUID().toString()+"-text-.pdf";
        String outputPDF = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+java.util.UUID.randomUUID().toString()+"-output-.pdf";
        String htmlText = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+java.util.UUID.randomUUID().toString()+"-html-.html";
        String canvasSVG = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+java.util.UUID.randomUUID().toString()+"-canvas.svg";
        //org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(canvasSVG), request.getParameter("svg"));
        int pageCount = Integer.parseInt(request.getParameter("pageCount"));
        //System.out.println("pageCount:"+pageCount);
        //String blackPDF = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/canvas.svg";
        //java.io.OutputStream o = response.getOutputStream();
        if(true)
        {
            //System.out.println("SVG Length:"+request.getParameter("svg").length());
            //org.apache.batik.transcoder.Transcoder transcoder = new org.apache.fop.svg.PDFTranscoder();
            org.apache.fop.svg.PDFTranscoder transcoder = new org.apache.fop.svg.PDFTranscoder();

             //org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/testxhtml2pdf.svg"), request.getParameter("svg"));
            // new java.io.FileWriter(com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/test.svg").write(request.getParameter("svg1"));
            transcoder.addTranscodingHint(org.apache.fop.svg.PDFTranscoder.KEY_STROKE_TEXT, false);

            //Setup input
            //java.io.InputStream in = new java.io.ByteArrayInputStream((request.getParameter("svg")).getBytes("UTF-8"));
            canvasPDF = com.feezixlabs.util.ConfigUtil.temp_upload_directory+"/"+java.util.UUID.randomUUID().toString();

            String parser = org.apache.batik.util.XMLResourceDescriptor.getXMLParserClassName();
            org.apache.batik.dom.svg.SAXSVGDocumentFactory f = new org.apache.batik.dom.svg.SAXSVGDocumentFactory(parser);            
            java.io.StringReader canvasReader = new java.io.StringReader(request.getParameter("svg").replaceAll(" href", " xlink:href"));
            org.w3c.dom.Document canvasDocument = f.createSVGDocument(null, canvasReader);
            
            
            org.w3c.dom.NodeList groups = canvasDocument.getElementsByTagName("g");
            int noteElementLength = groups.getLength();
            
            
            
            org.w3c.dom.NodeList  fobjects = canvasDocument.getElementsByTagName("foreignObject");
            for(int i=0;i<fobjects.getLength();i++){
                //canvasDocument.removeChild(fobjects.item(i).s);
                org.apache.batik.dom.svg.SVGOMElement svgEle = (org.apache.batik.dom.svg.SVGOMElement)fobjects.item(i);
                svgEle.setAttribute("style", "display:none");
                //svgEle.getParentNode().removeChild(svgEle);
            }
            
            for(int pageIndex = 0;pageIndex<pageCount;pageIndex++){


                for(int i=0;i<noteElementLength;i++){
                    org.apache.batik.dom.svg.SVGOMElement svgEle = (org.apache.batik.dom.svg.SVGOMElement)groups.item(i);
                    //System.out.println(svgEle.getAttribute("page"));
                    if(svgEle.getAttribute("page") != null && svgEle.getAttribute("page").length()>0){
                        int elePage = Integer.parseInt(svgEle.getAttribute("page"));

                        //System.out.println("styles:"+svgEle.getAttribute("style"));
                        //svgEle.getAttributeNode("style").setValue("display:block");
                        if(elePage == pageIndex+1)
                            svgEle.setAttribute("style", "display:block");
                        else
                            svgEle.setAttribute("style", "display:none");
                    }
                }

                java.io.OutputStream pdfout    = new java.io.FileOutputStream(new java.io.File(canvasPDF+"-page"+(pageIndex+1)+".pdf"));
                org.apache.batik.transcoder.TranscoderOutput output = new org.apache.batik.transcoder.TranscoderOutput(pdfout);
                org.apache.batik.transcoder.TranscoderInput input = new org.apache.batik.transcoder.TranscoderInput(canvasDocument);


                //response.setContentLength((int)tempfile.length());
                try {

                        transcoder.transcode(input, output);

                        /**
                        byte[] buf = new byte[32 * 1024]; // 32k buffer
                        int nRead = 0;
                        while( (nRead=is.read(buf)) != -1 ) {
                            o.write(buf, 0, nRead);
                        }**/
                }
                catch(Exception ex){
                   ex.printStackTrace();
                   throw ex;
                }

                finally {
                    pdfout.close();
                }

            }
            org.apache.pdfbox.util.PDFMergerUtility merger = new org.apache.pdfbox.util.PDFMergerUtility();
            for(int pageIndex = 0;pageIndex<pageCount;pageIndex++){
              merger.addSource(canvasPDF+"-page"+(pageIndex+1)+".pdf");
            }
            merger.setDestinationFileName(canvasPDF+"-svg-.pdf");
            merger.mergeDocuments();
            for(int pageIndex = 0;pageIndex<pageCount;pageIndex++)
              new java.io.File(canvasPDF+"-page"+(pageIndex+1)+".pdf").delete();
            canvasPDF = canvasPDF+"-svg-.pdf";
            /**

            **
            

            //java.io.File tempfile = new java.io.File(canvasPDF);
            //tempfile.createNewFile();
            //java.io.InputStream is = new java.io.FileInputStream(tempfile);
            java.io.OutputStream pdfout    = new java.io.FileOutputStream(new java.io.File(canvasPDF));

            org.apache.batik.transcoder.TranscoderOutput output = new org.apache.batik.transcoder.TranscoderOutput(pdfout);
            org.apache.batik.transcoder.TranscoderInput input = new org.apache.batik.transcoder.TranscoderInput(in);


            //response.setContentLength((int)tempfile.length());
            try {
                    
                    transcoder.transcode(input, output);

                    /**
                    byte[] buf = new byte[32 * 1024]; // 32k buffer
                    int nRead = 0;
                    while( (nRead=is.read(buf)) != -1 ) {
                        o.write(buf, 0, nRead);
                    }**
            }
            catch(Exception ex){
               ex.printStackTrace();
            }

            finally {
                //o.flush();
                //o.close();
                in.close();
                pdfout.close();
                //tempfile.delete();
            }*/

        }
        if(true)
        {
            StringBuffer buf = new StringBuffer();


            try{//first assume it is a well-formed html document
                javax.xml.parsers.DocumentBuilder documentBuilder = javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder();
                java.io.StringReader contentReader = new java.io.StringReader(request.getParameter("xhtml"));
                org.xml.sax.InputSource source = new org.xml.sax.InputSource(contentReader);
                documentBuilder.setEntityResolver(new com.feezixlabs.util.ClassPathEntityResolver());
                org.w3c.dom.Document xhtmlContent = documentBuilder.parse(source);
                buf.append(request.getParameter("xhtml"));
            }catch(Exception ex){
                //System.out.println("Receive bad markup");

                buf.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                buf.append("<!DOCTYPE html    PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"    \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">");
                //buf.append("<!DOCTYPE html    PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"   \"resources/schema/xhtml/xhtml-1/xhtml1-strict.dtd\">");
                buf.append("<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">");

                // put in some style
                buf.append("<head><style language='text/css'>");
                buf.append("@page {size:8.5in 11in;}");
                /***buf.append("body {word-wrap:break-word;width:"+request.getParameter("content_pixel_width")+"px;margin-left:"+request.getParameter("page_margin_left")+"in;margin-right:"+request.getParameter("page_margin_right")+"in;margin-top:"+request.getParameter("page_margin_top")+"in;margin-bottom:"+request.getParameter("page_margin_bottom")+"in} ");***/
                //buf.append("padding: 1em; text-transform: capitalize; font-family: sansserif; font-weight: normal;}");
                //buf.append("p { margin: 1em 1em 4em 3em; } p:first-letter { color: red; font-size: 150%; }");
                //buf.append("h2 { background: #5555ff; color: white; border: 10px solid black; padding: 3em; font-size: 200%; }");
                buf.append("</style></head>");

                // generate the body
                buf.append("<body>");
                buf.append(request.getParameter("xhtml"));
                buf.append("</body>");
                buf.append("</html>");
            }

            /*****
            org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(htmlText), buf.toString());
            ProcessBuilder html2pdfProcessBuilder = new ProcessBuilder("wkhtmltopdf",htmlText,textPDF);
            Process html2pdfProcess = html2pdfProcessBuilder.start();
            html2pdfProcess.waitFor();

            java.io.File pdfFile = new java.io.File(textPDF);
            int limit = 0;
            while(!pdfFile.exists() || !pdfFile.canWrite()){
                Thread.sleep(1000);
                if(++limit == 10)break;
            }
            *****/
            //ProcessBuilder pdfoverlyProcessBuilder = new ProcessBuilder("/usr/bin/pdftk",textPDF+" miltistamp "+canvasPDF+" output "+outputPDF);
            //Process pdfoverlyProcess = pdfoverlyProcessBuilder.start();
            //pdfoverlyProcess.waitFor();

            
            org.htmlcleaner.HtmlCleaner cleaner = new org.htmlcleaner.HtmlCleaner();
            org.htmlcleaner.CleanerProperties props = cleaner.getProperties();
            org.htmlcleaner.TagNode node = cleaner.clean(buf.toString());

            java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
            new org.htmlcleaner.PrettyHtmlSerializer(props).writeToStream(node, bos);
            java.io.OutputStream o = response.getOutputStream();
            org.xhtmlrenderer.pdf.ITextRenderer renderer = new org.xhtmlrenderer.pdf.ITextRenderer();
            renderer.setDocumentFromString(new String(bos.toByteArray()));
            //renderer.set
            renderer.layout();
            //renderer.createPDF(o);
            renderer.createPDF(new java.io.FileOutputStream(textPDF));
            
            /*javax.xml.parsers.DocumentBuilder documentBuilder = javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder();
            java.io.StringReader contentReader = new java.io.StringReader(buf.toString());
            org.xml.sax.InputSource source = new org.xml.sax.InputSource(contentReader);
            documentBuilder.setEntityResolver(new com.feezixlabs.util.ClassPathEntityResolver());
            org.w3c.dom.Document xhtmlContent = documentBuilder.parse(source);

            //javax.xml.transform.dom.DOMSource domSrc = new javax.xml.transform.dom.DOMSource();


            System.out.println(xhtmlContent.toString());
            renderer.setDocumentFromString(xhtmlContent.toString());*/



            //setup the svg based pdf to be overlayed on the WYSIWYG text
            java.io.FileInputStream overLayIn = new java.io.FileInputStream(new java.io.File(canvasPDF));
            org.apache.pdfbox.pdfparser.PDFParser parser = new org.apache.pdfbox.pdfparser.PDFParser(overLayIn);
            parser.parse();
            org.apache.pdfbox.pdmodel.PDDocument overlaypdf = parser.getPDDocument();
            overLayIn.close();
            

            
            //setup the text document that will host the overlay
            java.io.FileInputStream textIn = new java.io.FileInputStream(new java.io.File(textPDF));
            org.apache.pdfbox.pdfparser.PDFParser textparser = new org.apache.pdfbox.pdfparser.PDFParser(textIn);
            textparser.parse();
            org.apache.pdfbox.pdmodel.PDDocument textpdf = textparser.getPDDocument();
            textIn.close();

            //ensure they are aligned, page-wise
            int pagesToAdd = textpdf.getNumberOfPages()-overlaypdf.getNumberOfPages()>0?textpdf.getNumberOfPages()-overlaypdf.getNumberOfPages():0;

            if(pagesToAdd>0){
                for(int i=0;i<pagesToAdd;i++){
                    org.apache.pdfbox.pdmodel.PDPage pdpage = new org.apache.pdfbox.pdmodel.PDPage();
                    pdpage.setResources(new org.apache.pdfbox.pdmodel.PDResources());
                    overlaypdf.addPage(pdpage);


                    org.apache.pdfbox.pdmodel.edit.PDPageContentStream contentStream = new org.apache.pdfbox.pdmodel.edit.PDPageContentStream(overlaypdf,pdpage);
                    contentStream.setFont(org.apache.pdfbox.pdmodel.font.PDType1Font.HELVETICA, 10);
                    contentStream.beginText();
                    contentStream.moveTextPositionByAmount(0, 0);
                    contentStream.drawString("");//Overlay
                    contentStream.endText();
                    contentStream.close();
                    
                }
                //overlaypdf.save(canvasPDF);

                /**overlaypdf.close();
                
                overLayIn = new java.io.FileInputStream(new java.io.File(canvasPDF));
                parser = new org.apache.pdfbox.pdfparser.PDFParser(overLayIn);
                parser.parse();
                overlaypdf = parser.getPDDocument();
                overLayIn.close();**/
            }
            //perform overlay
            org.apache.pdfbox.Overlay overlayer = new org.apache.pdfbox.Overlay();
            overlayer.overlay(overlaypdf, textpdf);

            String fileName = request.getParameter("file_name") != null && request.getParameter("file_name").length()>0? request.getParameter("file_name")+".pdf":"note.pdf";
            
            response.setHeader("Content-disposition", "attachment; filename="+fileName);
            response.setHeader("Content-Transfer-Encoding", "binary");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            response.setContentType("application/pdf");
            
            
            try{
                java.io.OutputStream ostrm = response.getOutputStream();
                //java.io.FileOutputStream pdfout = new java.io.FileOutputStream(outputPDF);
                org.apache.pdfbox.pdfwriter.COSWriter pdfwriter = new org.apache.pdfbox.pdfwriter.COSWriter(ostrm);
                pdfwriter.write(textpdf);

                pdfwriter.close();
                //pdfout.close();

                overlaypdf.close();
                textpdf.close();
            }catch(Exception ex){
                request.getSession().setAttribute("error-message",org.apache.commons.lang.exception.ExceptionUtils.getStackTrace(ex));         
                ex.printStackTrace();
                throw ex;
            }
            
            
            new java.io.File(htmlText).delete();
            new java.io.File(canvasPDF).delete();
            new java.io.File(textPDF).delete();
            
            request.getSession().setAttribute("running_upload_status","done");
        }
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