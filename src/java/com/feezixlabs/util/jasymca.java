/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.feezixlabs.util;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author bitlooter
 */
public class jasymca extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ui = "Octave";
        if(request.getParameter("ui") != null && "Maxima".compareTo(request.getParameter("ui")) == 0)
            ui = "Maxima";
        response.setContentType("text/plain;charset=UTF-8");
        //net.sf.json.JSONObject.
        try{
            com.feezixlabs.util.ConsoleInputStream in  = new com.feezixlabs.util.ConsoleInputStream();
            java.io.PrintStream outx = new java.io.PrintStream(response.getOutputStream());
            
            String semiCol = ui.compareTo("Maxima") == 0?";":"";
            
            in.setText(request.getParameter("cmd")+semiCol+"\n"+"exit"+semiCol+"\n");
            
            Object jas = Class.forName("JasymcaInterface").getMethod("execute",String.class,java.io.InputStream.class,java.io.PrintStream.class).invoke(null,ui,in,outx);
            
            //System.out.println("executed command:"+request.getParameter("cmd"));
            
            //Thread.sleep(5000);
        }catch(Exception ex){
            ex.printStackTrace();
        }
        /*
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /*
             * TODO output your page here. You may use following sample code.
             *
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet jasymca</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet jasymca at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        } finally {            
            out.close();
        }*/
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
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
     * Handles the HTTP
     * <code>POST</code> method.
     *
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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}





/*
class ConsoleOutputStream extends OutputStream{
	JTextArea   ta;
	int 	   max_outTextlength=10000;
	int 	   outTextlength=0;
	

	public ConsoleOutputStream( JTextArea ta ){
		this.ta = ta;
	}
	
	public synchronized void write(byte[] b,
                  int off,
                  int len) throws IOException{
                String s = new String(b, off, len);
		outTextlength += s.length();
		if(outTextlength > max_outTextlength){
			String t = ta.getText();
			t = t.substring(t.length()*3/4);
			outTextlength = t.length() + s.length();
			ta.setText(t);
		}
		ta.append( s );
		ta.setCaretPosition( ta.getDocument().getLength() );
	}
	
	public void write(byte[] b) throws IOException{
		write(b, 0, b.length);
	}
	
	public void write(int b) throws IOException{
		write( new byte[] { (byte)b } );
	}
}*/
