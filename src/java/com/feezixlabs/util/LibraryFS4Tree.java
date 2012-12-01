/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.util;
import java.io.*;
/**
 *
 * @author bitlooter
 */
public class LibraryFS4Tree   extends File{

    public LibraryFS4Tree( String name )
    {
        super( name );
    }
    String buildLazy(String name,int baseDirLength){
        StringBuilder buf = new StringBuilder();
        String relativePath = this.getAbsolutePath().substring(baseDirLength+1);
        String isFolder = this.isDirectory()?",\"isFolder\":true,\"isLazy\":true,\"addClass\":\"phyzixlabs-system-library-dir\",\"type\":\"phyzixlabs-system-library-dir\"":",\"isFolder\":false,\"addClass\":\"phyzixlabs-system-library-file\",\"type\":\"phyzixlabs-system-library-file\"";
        buf.append("{\"title\":\""+name+"\""+isFolder+",\"relPath\":\""+relativePath+"\",\"children\":[");

        buf.append("]}");
        return buf.toString();
    }


    public static String buildTreeLazy(String fromPath){
        StringBuilder buf = new StringBuilder();
        buf.append("[");

        String basePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/library";
        int baseDirLength = basePath.length();

        LibraryFS4Tree dir = fromPath.length()==0?new LibraryFS4Tree( basePath): new LibraryFS4Tree( basePath+ separatorChar + fromPath );

        String [ ] entries = dir.list( );

        boolean first = true;
        for( int i = 0; i < entries.length; i++ )
        {
            LibraryFS4Tree child = new LibraryFS4Tree( dir.getPath( )+ separatorChar + entries[ i ] );
            buf.append((!first?",":"")+ child.buildLazy(child.getName(),baseDirLength));
            first = false;
        }
        //buf.append("]}");
        buf.append("]");
        return buf.toString();
    }
}
