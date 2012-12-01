
import java.io.InputStream;
import java.io.PrintStream;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author bitlooter
 */
public class JasymcaInterface {
    public static Object execute(String ui,InputStream is, PrintStream ps){
        JasymcaExt jas = new JasymcaExt(ui);
        jas.start(is, ps);
        return jas;
    }
}
