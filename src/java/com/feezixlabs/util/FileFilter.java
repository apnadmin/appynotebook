/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.util;

/**
 *
 * @author bitlooter
 */
public class FileFilter implements java.io.FilenameFilter{
    public String match = "";
    public boolean accept(java.io.File file, String name) {
        return name.startsWith(match);
        //throw new UnsupportedOperationException("Not supported yet.");
    }
}
