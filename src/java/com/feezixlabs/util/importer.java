/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.util;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author bitlooter
 */
public class importer extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    protected void writeJSImport(String path,HttpServletRequest request,HttpServletResponse response){
        try{
            String[] files = request.getParameter("files").split(",");
            long outputSize = 0;
            for(int i=0;i<files.length;i++){
               outputSize += new java.io.File(path+"/"+files[i]).length();
            }
            

            String l = request.getParameter("callback")!=null?"\nColabopadApplication.importer.import_ready('/importer"+request.getPathInfo()+"?"+request.getQueryString()+"');":"";
            response.setContentType("text/javascript");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            response.setHeader("Content-Length",""+outputSize+l.length());


            java.io.OutputStream o = response.getOutputStream();
            for(int i=0;i<files.length;i++){
                //System.out.println(path+"/"+files[i]);
                java.io.InputStream is = new java.io.FileInputStream(path+"/"+files[i]);
                byte[] buf = new byte[32 * 1024]; // 32k buffer
                int nRead = 0;
                while( (nRead=is.read(buf)) != -1 ) {
                    o.write(buf, 0, nRead);
                }
                is.close();
            }
            //append triggers callback
            if(l.length()>0){
                byte[] lb = l.getBytes();
                o.write(lb);
            }
            o.flush();
            o.close();// *important* to ensure no more jsp output

        }catch(IOException ex){
            ex.printStackTrace();
        }
    }



    protected void writeImport(String importFileName,HttpServletRequest request,HttpServletResponse response,String rmime,String widgetId,String env){
        try{
            String mime =  rmime;
            java.io.File importFile = new java.io.File(importFileName);

            if(!importFile.exists()){
                return;
            }

            String ext = "";
            if(importFileName.lastIndexOf(".") != -1){
                ext = importFileName.substring(importFileName.lastIndexOf("."),importFileName.length());
                mime = com.feezixlabs.util.ConfigUtil.ext2mime_mapping.get(ext);
            }

            if(mime == null)
            {
                java.util.Collection<?> mimeTypes = eu.medsea.mimeutil.MimeUtil.getMimeTypes(importFile);
                java.util.Iterator itr = mimeTypes.iterator();
                while(itr.hasNext()){
                    mime = itr.next().toString();
                    break;
                }
            }
           /*
            if(rmime == null || rmime.equals("")){
                //get file extension
                String ext = "";
                if(importFileName.lastIndexOf(".") != -1)
                    ext = importFileName.substring(importFileName.lastIndexOf(".")+1,importFileName.length());

                mime = com.feezixlabs.util.ConfigUtil.ext2mime_mapping.get(ext);

                if(mime == null && ext.compareTo("css") == 0)
                    mime = "text/css";
                else
                if(mime == null && ext.compareTo("js") == 0)
                    mime = "text/javascript";
                else
                if(mime == null)
                {
                    java.util.Collection<?> mimeTypes = eu.medsea.mimeutil.MimeUtil.getMimeTypes(importFile);
                    java.util.Iterator itr = mimeTypes.iterator();
                    while(itr.hasNext()){
                        mime = itr.next().toString();
                        break;
                    }
                }
            }else{
                if(rmime.compareTo("js") == 0)
                    mime = "text/javascript";
                else
                if(rmime.compareTo("css") == 0)
                    mime = "text/css";
                else
                if(rmime.compareTo("xml") == 0)
                    mime = "text/xml";
                else
                if(rmime.compareTo("html") == 0)
                    mime = "text/html";
                else
                if(rmime.compareTo("svg") == 0)
                    mime = "image/svg+xml";
                else
                if(rmime.compareTo("txt") == 0)
                    mime = "text/plain";
                else
                    mime = rmime;
            }
            *
            */
            //System.out.println("mime:"+mime);
            String l = mime.compareTo("text/javascript")==0 && request.getParameter("callback")!=null?"\nColabopadApplication.importer.import_ready('/importer"+request.getPathInfo()/*+"?"+request.getQueryString()*/+"');":"";


            String script_execution_check = "";
            String skip_script_execution = "";
            if(false && mime.compareTo("text/javascript")==0){
                if(request.getParameter("index").compareTo("0")==0)
                    script_execution_check = "start_script_execution"+request.getParameter("ts")+" :\n if(!execute_scripts){\nif(++imports_loaded==imports_requested){\nexecute_scripts=true;\nfor(var i=0;i<1;i++){\nbreak start_script_execution"+request.getParameter("ts")+";}\n}else{for(var i=0;i<1;i++){\nbreak skip_script_execution;}}};";
                else
                    script_execution_check = "if(!execute_scripts){\nif(++imports_loaded==imports_requested){execute_scripts=true;for(var i=0;i<1;i++){\nbreak start_script_execution"+request.getParameter("ts")+";}}else{for(var i=0;i<1;i++){\nbreak skip_script_execution;}}}";
                skip_script_execution = "if(++imports_executed==imports_loaded){execute_scripts=false;imports_loaded=0;imports_requested=0;for(var i=0;i<1;i++){\nbreak skip_script_execution;}}";
            }
            //if(mime.compareTo("text/javascript")==0){
                response.setContentType(mime+"; charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
            //}else
            //response.setContentType(mime);

            //response.setHeader("Pragma", "no-cache");
            //response.setHeader("Expires", "0");
            //response.setHeader("Content-Length",""+importFile.length()+l.length());


            java.io.OutputStream o = response.getOutputStream();

            //System.out.println("importing file:"+importFile);
            java.io.InputStream is = null;

            if(false && mime.compareTo("text/html") == 0){
                is = new java.io.ByteArrayInputStream(org.apache.commons.io.FileUtils.readFileToString(importFile).replaceAll("phyzixlabs-local://", "/importer-"+env+"-"+widgetId+"/").replaceAll("phyzixlabs-global://", "/importer/38f60efcb83b11df9f620019b958a435-"+env+"-"+widgetId+"/").getBytes());
            }else{
                is = new java.io.FileInputStream(importFile);
            }


            byte[] buf = new byte[32 * 1024]; // 32k buffer
            int nRead = 0;


            if(script_execution_check.length()>0){
                byte[] lb = script_execution_check.getBytes();
                o.write(lb);
            }

            while( (nRead=is.read(buf)) != -1 ) {
                o.write(buf, 0, nRead);
            }
            //append triggers callback
            if(l.length()>0){
                byte[] lb = l.getBytes();
                o.write(lb);
            }
            if(skip_script_execution.length()>0){
                byte[] lb = skip_script_execution.getBytes();
                o.write(lb);
            }
            
            //o.flush();
            //o.close();// *important* to ensure no more jsp output
            //is.close();
        }catch(IOException ex){
            ex.printStackTrace();
        }
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        //response.setContentType("text/html;charset=UTF-8");
        //PrintWriter out = response.getWriter();

        String[] pathInfo = request.getPathInfo().substring(1).split("/");

        //request for import from library
        if(pathInfo[0].startsWith("38f60efcb83b11df9f620019b958a435")){
            //System.out.println("REQUEST URL:"+request.getRequestURL()+"?"+request.getQueryString());
            String env = pathInfo[0].split("-")[1];
            String widgetId = pathInfo[0].split("-")[2];

            //depending on the state            
            if(env.compareTo("dev") != 0 && env.compareTo("rejected") != 0){

                String dependencyPath = com.feezixlabs.util.ConfigUtil.resource_directory+"/"+env+"/app-"+widgetId+"/dependencies";


                if(request.getParameter("files") != null &&request.getParameter("mime") != null && request.getParameter("mime").compareTo("js")==0){
                    writeJSImport(dependencyPath,request,response);
                }else{
                         //create url for file system access
                    for(int i=1;i<pathInfo.length;i++)
                        dependencyPath += "/"+pathInfo[i];

                    //if file doesn't exist assume the applet is referencing local library
                    if(!new java.io.File(dependencyPath).exists()){
                        dependencyPath = com.feezixlabs.util.ConfigUtil.resource_directory+"/library";
                        for(int i=1;i<pathInfo.length;i++)
                            dependencyPath += "/"+pathInfo[i];
                    }
                    writeImport(dependencyPath,request,response,request.getParameter("mime"),null,null);
                 }
            }
            else
            {
                String libraryFilePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/library";

                if(request.getParameter("files") != null &&request.getParameter("mime") != null && request.getParameter("mime").compareTo("js")==0){
                    writeJSImport(libraryFilePath,request,response);
                }else{
                    //create url for file system access
                    for(int i=1;i<pathInfo.length;i++)
                        libraryFilePath += "/"+pathInfo[i];

                    writeImport(libraryFilePath,request,response,request.getParameter("mime"),null,null);
                }
            }
        }else{//request for import from widget resources

            String env = pathInfo[0].split("-")[0];
            String widgetId = pathInfo[0].split("-")[1];


            //String env = request.getParameter("env");
            //com.feezixlabs.bean.Resource resource = null;//com.feezixlabs.db.dao.WidgetResourceDAO.getResource(request.getUserPrincipal().getName(), new Integer(/*request.getParameter("widgetid")*/widgetId), pathInfo[1],env );
            String libraryFilePath = "";

            //if(resource != null)
            //    libraryFilePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/"+env+"/applet-"+resource.getWidgetId()+"/resources/"+resource.getFsName();
            //else
            libraryFilePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/"+env+"/app-"+widgetId+"/resources";//+pathInfo[1];


            if(request.getParameter("files") != null &&request.getParameter("mime") != null && request.getParameter("mime").compareTo("js")==0){
                writeJSImport(libraryFilePath,request,response);
            }else{
                //create path for file system access
                for(int i=1;i<pathInfo.length;i++)
                    libraryFilePath += "/"+pathInfo[i];

                writeImport(libraryFilePath,request,response,request.getParameter("mime"),widgetId,env);
            }
        }


        try {
            /* TODO output your page here
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet importer</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet importer at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
            */
        } finally { 
            //out.close();
        }
    }

    @Override
    public void init(){
        try{
        super.init();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        //System.out.println("STARTING CLIENT FILE IMPORTER SERVLET");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
