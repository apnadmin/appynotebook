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
public class imageImporter extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //response.setContentType("text/html;charset=UTF-8");
        //PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet imageImporter</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet imageImporter at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
            */

            String fileName = request.getParameter("file_name");
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Transfer-Encoding", "binary");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");


            String filePath = com.feezixlabs.util.ConfigUtil.static_file_directory+"/";
            java.io.File outputFile = new java.io.File(filePath+fileName);
            if(!outputFile.exists())
                outputFile = new java.io.File(filePath+"/defaults/image-not-found.png");
            
            if(/*new java.io.File(filePath+fileName).exists()*/true){
                //write to response outputstream
                response.setHeader("Content-Length",""+ outputFile.length());


                java.io.OutputStream o = response.getOutputStream();

                java.io.InputStream is = new java.io.FileInputStream(outputFile);
                byte[] buf = new byte[32 * 1024]; // 32k buffer
                int nRead = 0;
                while( (nRead=is.read(buf)) != -1 ) {
                    o.write(buf, 0, nRead);
                }
                o.flush();
                o.close();// *important* to ensure no more jsp output
                is.close();
            }
        } finally { 
            //out.close();
        }
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
