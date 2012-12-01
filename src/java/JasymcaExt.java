
import java.io.InputStream;
import java.io.PrintStream;
import java.util.List;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author bitlooter
 */
public class JasymcaExt extends Jasymca{
    public JasymcaExt(String ui){
        super(ui);
    }
    @Override
 public void start(InputStream is, PrintStream ps){
  this.is = is;
  this.ps = ps;
  try{
   String fname = JasymcaRC + ui + ".rc";
   InputStream file = getFileInputStream(fname);
   LambdaLOADFILE.readFile( file );
  }catch(Exception e){
  }
  //ps.print(welcome);
  proc.setPrintStream( ps );
  //evalLoop = new Thread(this);
  //evalLoop.start();
  run();
 }
    @Override
 public void run(){
  while(true){
   ps.print( pars.prompt() );
   try{
    proc.set_interrupt( false );
    List code = pars.compile(is, ps);
    if( code == null ){
     ps.println("");
     return;
    }
    if( proc.process_list( code, false ) == proc.EXIT){
     //ps.println("\nGoodbye.");
     return;
    }
    proc.printStack();
   }catch(Exception e){
    ps.println("\n"+e);
    proc.clearStack();
   }
  }
 }    
}
