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
public class embed extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
            String action = request.getParameter("action");
            String[] pathInfo = action==null?request.getPathInfo().substring(1).split("/"):null;
            
            if(action ==null && pathInfo.length == 1){
                String width      = request.getParameter("width")!=null?request.getParameter("width"):"866";
                String height     = request.getParameter("height")!=null?request.getParameter("height"):"380";
                request.setAttribute("width", width);
                request.setAttribute("height", height);
                request.setAttribute("embed_key", pathInfo[0]);
                javax.servlet .RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/sc/nd/embed-port.jsp");
                dispatcher.include(request,response);
                /**
                javax.servlet .RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/embed.jsp?embed_key="+pathInfo[0]+"&width="+width+"&height="+height);
                dispatcher.forward(request,response);
                 ***/
            }
            else
            if(action != null && action.compareToIgnoreCase("get_main") == 0){
                String width      = request.getParameter("width")!=null?request.getParameter("width"):"866";
                String height     = request.getParameter("height")!=null?request.getParameter("height"):"380";
                String embedKey   = request.getParameter("embed_key");

                //?embed_key="+embedKey+"&width="+width+"&height="+height
                javax.servlet .RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/embed.jsp");
                //dispatcher.forward(request,response);
                response.setContentType("text/html");
                dispatcher.include(request,response);
            }
            else
            if(pathInfo[1].compareToIgnoreCase("secure_resource") == 0){
                String contentType = "text/plain";

                if(request.getParameter("r").endsWith(".js"))
                    contentType = "text/javascript";
                else
                if(request.getParameter("r").endsWith(".css"))
                    contentType = "text/css";

                response.setContentType(contentType);
                javax.servlet .RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/sc/nd/"+request.getParameter("r"));
                dispatcher.include(request,response);
            }
            else
            if(pathInfo[1].compareToIgnoreCase("secure_url_resource") == 0){
                javax.servlet .RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/sc/nd/"+request.getParameter("r"));
                dispatcher.forward(request,response);
            }
        /*
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
             TODO output your page here
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet embed</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet embed at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
            
        } finally { 
            out.close();
        }*/
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
