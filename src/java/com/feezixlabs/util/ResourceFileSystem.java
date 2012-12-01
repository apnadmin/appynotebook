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
public class ResourceFileSystem extends File {
    static final java.text.DateFormat dateFormat = new java.text.SimpleDateFormat("MM-dd-yyyy");
    String resourcePath;
    String env;
    com.feezixlabs.bean.Resource resource;
        // Constructor
    public ResourceFileSystem( String name )
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
        listAll( 0,"NULL",buf );
        return buf.toString();
    }

        // Recursive method to list all files in directory
    private void listAll( int depth,String parentId,StringBuffer buf)
    {
        printName( depth );
        String id = org.apache.commons.codec.digest.DigestUtils.md5Hex(this.getAbsolutePath());
        String itemPath = resource.getFileName()+getAbsolutePath().substring(resourcePath.length());
        
        buf.append("<row>");
        buf.append(" <cell><![CDATA["+id+"]]></cell>");
        buf.append(" <cell><![CDATA["+this.getName()+"]]></cell>");

        buf.append(" <cell><![CDATA[]]></cell>");
        buf.append(" <cell><![CDATA[]]></cell>");
        buf.append(" <cell><![CDATA[]]></cell>");
        buf.append(" <cell><![CDATA[]]></cell>");
        buf.append(" <cell><![CDATA[]]></cell>");
        buf.append(" <cell><![CDATA[]]></cell>");

        

        if(env.compareToIgnoreCase("dev")==0||env.compareToIgnoreCase("rejected")==0){

            String actions = "<input type=\"image\" src=\"img/del-doc.png\" onclick=\"deleteResourceItem('"+id+"',"+resource.getWidgetId()+",'"+resource.getFileName()+"','"+env +"','"+itemPath+"')\"/>";

            if(this.isDirectory()){
                /***actions += "<input type=\"image\" src=\"img/window-new.png\" onclick=\"newResourceItem("+resource.getWidgetId()+",'"+resource.getFileName()+"','"+env +"','"+itemPath+"')\"/>";***/
            }else{
                //check extension to see if this item is editable
                if(this.getName().lastIndexOf(".")>-1){
                    String ext = getName().substring(this.getName().lastIndexOf(".")+1);
                    if(ext.compareToIgnoreCase("js")==0 ||
                       ext.compareToIgnoreCase("txt")==0 ||
                       ext.compareToIgnoreCase("css")==0 ||
                       ext.compareToIgnoreCase("xml")==0||
                       ext.compareToIgnoreCase("html")==0){
                       actions += "<input type=\"image\" src=\"img/edit.png\" onclick=\"addResourceItemEditTab("+resource.getWidgetId()+",'"+resource.getFileName()+"','"+env +"','"+itemPath+"','"+getName()+"','"+ext+"')\"/>";
                    }
                }
            }
            
            buf.append(" <cell><![CDATA["+actions+"]]></cell>");
        }
        //buf.append(" <cell><![CDATA[]]></cell>");

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
                ResourceFileSystem child = new ResourceFileSystem( getPath( )+ separatorChar + entries[ i ] );
                child.resourcePath = resourcePath;
                child.resource     = resource;
                child.env          = env;
                child.listAll( depth + 1,id, buf );
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
                ResourceFileSystem  child = new ResourceFileSystem( getPath( )+ separatorChar + entries[ i ] );
                totalSize += child.size( );
            }
        }
        return totalSize;
    }

        // Simple main to list all files in current directory
    static public String buildGrid( String resourcePath,com.feezixlabs.bean.Resource resource,String env  )
    {

        ResourceFileSystem f = new ResourceFileSystem( resourcePath);
        f.resourcePath = resourcePath;
        f.resource     = resource;
        f.env          = env;

        StringBuffer buf = new StringBuffer();
        String id = resource.getFileName();

        buf.append("<row>");
        buf.append(" <cell><![CDATA["+id+"]]></cell>");
        buf.append(" <cell><![CDATA["+resource.getFileName()+"]]></cell>");

        buf.append(" <cell><![CDATA["+(resource.getLabel())+"]]></cell>");
        buf.append(" <cell><![CDATA["+(resource.getType())+"]]></cell>");
        buf.append(" <cell><![CDATA["+(resource.getMime())+"]]></cell>");
        buf.append(" <cell><![CDATA["+(resource.getSize())+"]]></cell>");
        buf.append(" <cell><![CDATA["+(resource.getCreateDate())+"]]></cell>");
        buf.append(" <cell><![CDATA["+(resource.getLastModDate())+"]]></cell>");

        if(env.compareToIgnoreCase("dev")==0||env.compareToIgnoreCase("rejected")==0){

            String actions = "<input type=\"image\" src=\"img/del-doc.png\" onclick=\"deleteResource("+resource.getWidgetId()+",'"+resource.getFileName()+"','"+env +"')\"/>";
            if(f.isDirectory()){
                /***actions += "<input type=\"image\" src=\"img/window-new.png\" onclick=\"newResourceItem("+resource.getWidgetId()+",'"+resource.getFileName()+"','"+env +"')\"/>";***/
            }else{
                //check extension to see if this item is editable
                if(resource.getFileName().lastIndexOf(".")>-1){
                    String ext = resource.getFileName().substring(resource.getFileName().lastIndexOf(".")+1);
                    if(ext.compareToIgnoreCase("js")==0 ||
                       ext.compareToIgnoreCase("txt")==0 ||
                       ext.compareToIgnoreCase("css")==0 ||
                       ext.compareToIgnoreCase("xml")==0||
                       ext.compareToIgnoreCase("html")==0){
                       actions += "<input type=\"image\" src=\"img/edit.png\" onclick=\"addResourceItemEditTab("+resource.getWidgetId()+",'"+resource.getFileName()+"','"+env +"','"+resource.getFileName()+"','"+resource.getFileName()+"','"+ext+"')\"/>";
                    }
                }
            }
            buf.append(" <cell><![CDATA["+actions+"]]></cell>");
        }
        else
            buf.append(" <cell><![CDATA[]]></cell>");


        buf.append(" <cell>0</cell>");
        buf.append(" <cell>NULL</cell>");

        
        if( f.isDirectory() )
        {

            buf.append(" <cell>false</cell>");
            buf.append(" <cell>false</cell>");
            buf.append("</row>");

            String [ ] entries = f.list( );

            for( int i = 0; i < entries.length; i++ )
            {
                ResourceFileSystem child = new ResourceFileSystem( f.getPath( )+ ResourceFileSystem.separatorChar + entries[ i ] );
                child.resourcePath = f.resourcePath;
                child.resource     = f.resource;
                child.env          = f.env;
                
                child.listAll(1,id,buf);
            }
        }
        else
        {
            buf.append(" <cell>true</cell>");
            buf.append(" <cell>false</cell>");
            buf.append("</row>");
        }
        return buf.toString();
    }
}
