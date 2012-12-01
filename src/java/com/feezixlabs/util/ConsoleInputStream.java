/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.feezixlabs.util;

import java.io.IOException;
import java.io.InputStream;

/**
 *
 * @author bitlooter
 */
public class ConsoleInputStream extends InputStream{
	String  text=null;
	int     idx =0;
	boolean int_flag = false;
	
	public synchronized void set_interrupt_flag( boolean flag ){
		int_flag = flag;
	}
	
	public synchronized void setText( String text ){
		try{
			while( this.text != null && 
				   idx < this.text.length() ) 
				Thread.sleep(100);
			this.text = text;
			idx = 0;
		}catch( InterruptedException e){
		}
	}	
	
	public int read() throws IOException{
		try{
			while( text == null || idx >= text.length() ){
				Thread.sleep(100);
				if( int_flag ){
					set_interrupt_flag(false);
					throw new IOException("Interrupted.");
				}
			}
			return (int)text.charAt( idx++ );
		}catch( InterruptedException e){
			return -1;
		}
	}
}