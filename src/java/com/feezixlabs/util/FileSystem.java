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
public class FileSystem extends File
{
    static final java.text.DateFormat dateFormat = new java.text.SimpleDateFormat("MM-dd-yyyy");
        // Constructor
    
    
    
    public FileSystem( String name)
    {
        super( name );
    }

        // Output file name with indentation
    public void printName( int depth)
    {
       // for( int i = 0; i < depth; i++ )
        //    System.out.print( "\t" );
       // System.out.println( getName( ) );
    }

        // Public driver to list all files in directory
    public String listAll( )
    {
        StringBuffer buf = new StringBuffer();
        listAll( 0,"NULL",buf,"" );
        return buf.toString();
    }

        // Recursive method to list all files in directory
    private void listAll( int depth,String parentId,StringBuffer buf,String qualifiedParentId )
    {
        printName( depth );
        String id = (depth==0)?this.getName():org.apache.commons.codec.digest.DigestUtils.md5Hex(this.getAbsolutePath());
        String qualifiedId = qualifiedParentId.length()>0?qualifiedParentId+","+id:id;


        String checkBox =  " <input type=\"checkbox\" onclick=\"appletBuilder.selectLibraryEntry(["+(qualifiedParentId.length()>0?"'"+qualifiedParentId.replaceAll(",", "','")+"'":"")+"],'"+id+"')\" class=\"selectlibraryentry\" id=\"selectlibraryentry-"+qualifiedId.replaceAll(",","-")+"\" name=\"selectlibraryentry-"+id+"\" disabled/> ";
        

        buf.append("<row>");
        buf.append(" <cell><![CDATA["+id+"]]></cell>");
        buf.append(" <cell><![CDATA["+checkBox+this.getName()+"]]></cell>");
        buf.append(" <cell><![CDATA["+(this.size())+"]]></cell>");

        int library_path_length = (com.feezixlabs.util.ConfigUtil.resource_directory+"/library").length()+1;

        buf.append(" <cell><![CDATA["+(this.getAbsolutePath().substring(library_path_length))+"]]></cell>");
        
        if(depth == 0 ){
            buf.append(" <cell><![CDATA["+dateFormat.format(new java.util.Date(this.lastModified()))+"]]></cell>");
            buf.append(" <cell><![CDATA[]]></cell>");
        }
        else{
            buf.append(" <cell><![CDATA[]]></cell>");
            buf.append(" <cell><![CDATA[]]></cell>");
        }

        buf.append(" <cell>"+depth+"</cell>");
        buf.append(" <cell>"+parentId+"</cell>");

        if( isDirectory( ) )
        {
            buf.append(" <cell>false</cell>");
            buf.append(" <cell>false</cell>");
            buf.append("</row>");

            String [ ] entries = list( );

            for( int i = 0; i < entries.length; i++ )
            {
                FileSystem child = new FileSystem( getPath( )+ separatorChar + entries[ i ] );
                child.listAll( depth + 1,id, buf,qualifiedId);
            }
        }
        else
        {
            buf.append(" <cell>true</cell>");
            buf.append(" <cell>false</cell>");
            buf.append("</row>");
        }
    }

    public long size( )
    {
        long totalSize = length( );

        if( isDirectory( ) )
        {
            String [ ] entries = list( );
            for( int i = 0; i < entries.length; i++ )
            {
                FileSystem  child = new FileSystem( getPath( )+ separatorChar + entries[ i ] );
                totalSize += child.size( );
            }
        }
        return totalSize;
    }

        // Simple main to list all files in current directory
    static public String buildGrid( String rootDir)
    {
        FileSystem f = new FileSystem( rootDir );

        String [ ] entries = f.list( );

        StringBuffer buf = new StringBuffer();
        for( int i = 0; i < entries.length; i++ )
        {
            FileSystem child = new FileSystem( f.getPath( )+ separatorChar + entries[ i ] );
            child.listAll( 0,"NULL", buf,"" );
        }

        return buf.toString();
        //System.out.println( "Total bytes: " + f.size( ) );
    }
}