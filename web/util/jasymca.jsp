<% 
        String ui = "Octave";
        if(request.getParameter("ui") != null && "Maxima".compareTo(request.getParameter("ui")) == 0)
            ui = "Maxima";
        
        //net.sf.json.JSONObject.
        try{
            com.feezixlabs.util.ConsoleInputStream in  = new com.feezixlabs.util.ConsoleInputStream();
            java.io.PrintStream outx = new java.io.PrintStream(response.getOutputStream());
            in.setText(request.getParameter("cmd")+"\n"+"exit"+"\n");
            
            Object jas = Class.forName("JasymcaInterface").getMethod("execute",String.class,java.io.InputStream.class,java.io.PrintStream.class).invoke(null,ui,in,outx);
            
            //System.out.println("executed command:"+request.getParameter("cmd"));
            
            //Thread.sleep(5000);
        }catch(Exception ex){
            ex.printStackTrace();
        }
%>