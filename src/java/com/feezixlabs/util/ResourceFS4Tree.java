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
public class ResourceFS4Tree  extends File{
    static final java.text.DateFormat dateFormat = new java.text.SimpleDateFormat("MM-dd-yyyy");
    String resourcePath;
    String env;
    com.feezixlabs.bean.Resource resource;
        // Constructor
    public ResourceFS4Tree( String name )
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

    String build(String name){
        StringBuilder buf = new StringBuilder();
        String isFolder = this.isDirectory()?",\"isFolder\":true,\"addClass\":\"phyzixlabs-resource-dir\",\"type\":\"phyzixlabs-resource-dir\"":",\"isFolder\":false,\"addClass\":\"phyzixlabs-resource-file\",\"type\":\"phyzixlabs-resource-file\"";
        buf.append("{\"title\":\""+name+"\""+isFolder+",\"children\":[");

        if(this.isDirectory()){
            String [ ] entries = list( );

            if(entries != null){
                boolean first = true;
                for( int i = 0; i < entries.length; i++ )
                {
                    ResourceFS4Tree child = new ResourceFS4Tree( getPath( )+ separatorChar + entries[ i ] );
                    buf.append((!first?",":"")+ child.build(child.getName()));
                    first = false;
                }
            }
        }
        buf.append("]}");
        return buf.toString();
    }


    public String buildTree(String userName,int widgetId,String uuid){
        StringBuilder buf = new StringBuilder();
        buf.append("{\"title\":\"Resources\",\"type\":\"phyzixlabs-resource-root\",\"addClass\":\"phyzixlabs-resource-root\",\"isFolder\":true,\"children\":[");
        String path = com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+uuid+"/resources";
        boolean first = true;
        for(com.feezixlabs.bean.Resource resource:com.feezixlabs.db.dao.WidgetResourceDAO.getResources(userName,widgetId,"dev"))
        {
            ResourceFS4Tree child = new ResourceFS4Tree( path+ separatorChar + resource.getFsName() );
            buf.append((!first?",":"")+ child.build(resource.getFileName()));
            first = false;
        }

        /*
        String [ ] entries = list( );

        boolean first = true;
        for( int i = 0; i < entries.length; i++ )
        {
            //System.out.println("path:"+getPath( )+ separatorChar + entries[ i ]);
            ResourceFS4Tree child = new ResourceFS4Tree( getPath( )+ separatorChar + entries[ i ] );
            buf.append((!first?",":"")+ child.build());
            first = false;
        }
         * */

        buf.append("]}");
        return buf.toString();
    }


    static String getMimeType(String name){
        if(name.endsWith(".html") || name.endsWith(".htm"))
            return "html";
        if(name.endsWith(".js"))
            return "js";
        if(name.endsWith(".svg"))
            return "svg";
        if(name.endsWith(".xml"))
            return "xml";               
        if(name.endsWith(".txt"))
            return "txt";
        if(name.endsWith(".css"))
            return "css";

        return "none";
    }



    String buildLazy(String name,int widgetId,String uuid,int baseDirLength){
        StringBuilder buf = new StringBuilder();
        String relativePath = this.getAbsolutePath().substring(baseDirLength+1);
        String id = widgetId+"-"+relativePath.replace("/","-").replace(".", "-");
        
        String isFolder = this.isDirectory()?",\"isFolder\":true,\"mime\":\"folder\",\"isLazy\":true,\"addClass\":\"phyzixlabs-resource-dir\",\"type\":\"phyzixlabs-resource-dir\"":",\"isFolder\":false,\"addClass\":\"phyzixlabs-resource-file\",\"type\":\"phyzixlabs-resource-file\",\"mime\":\""+getMimeType(name)+"\"";
        buf.append("{\"title\":\""+name+"\""+isFolder+",\"relPath\":\""+relativePath+"\",\"widget_id\":"+widgetId+",\"uuid\":\""+uuid+"\",\"id\":\""+id+"\",\"children\":[");

        if(/*this.isDirectory()*/false){
            String [ ] entries = list( );

            if(entries != null){
                boolean first = true;
                for( int i = 0; i < entries.length; i++ )
                {
                    ResourceFS4Tree child = new ResourceFS4Tree( getPath( )+ separatorChar + entries[ i ] );
                    buf.append((!first?",":"")+ child.build(child.getName()));
                    first = false;
                }
            }
        }
        buf.append("]}");
        return buf.toString();
    }


    public static String buildTreeLazy(String userName,int widgetId,String uuid,String fromPath){
        StringBuilder buf = new StringBuilder();
        buf.append("[");
        //buf.append("{\"title\":\"Resources\",\"isLazy\":true,\"type\":\"phyzixlabs-resource-root\",\"addClass\":\"phyzixlabs-resource-root\",\"isFolder\":true,\"children\":[");
        String basePath = com.feezixlabs.util.ConfigUtil.resource_directory+"/dev/app-"+uuid+"/resources";
        int baseDirLength = basePath.length();
        ResourceFS4Tree startDir = null;
        if(fromPath.length() == 0){
            startDir =  new ResourceFS4Tree( basePath );
            /*
            boolean first = true;
            for(com.feezixlabs.bean.Resource resource:com.feezixlabs.db.dao.WidgetResourceDAO.getResources(userName,widgetId,"dev"))
            {
                ResourceFS4Tree child = new ResourceFS4Tree( basePath+ separatorChar + resource.getFsName() );
                buf.append((!first?",":"")+ child.buildLazy(resource.getFileName(),widgetId,baseDirLength));
                first = false;
            }*/
        }else{
                //ResourceFS4Tree dir = new ResourceFS4Tree( basePath+ separatorChar + fromPath );
            startDir = new ResourceFS4Tree( basePath+ separatorChar + fromPath );
                
        }

        String [ ] entries = startDir.list( );

        if(entries != null){
            boolean first = true;
            for( int i = 0; i < entries.length; i++ )
            {
                ResourceFS4Tree child = new ResourceFS4Tree( startDir.getPath( )+ separatorChar + entries[ i ] );
                buf.append((!first?",":"")+ child.buildLazy(child.getName(),widgetId,uuid,baseDirLength));
                first = false;
            }
        }
        //buf.append("]}");
        buf.append("]");
        return buf.toString();
    }




        // Recursive method to list all files in directory
    private void listAll( int depth,String parentId,StringBuffer buf)
    {
        String id = org.apache.commons.codec.digest.DigestUtils.md5Hex(this.getAbsolutePath());
        String itemPath = resource.getFileName()+getAbsolutePath().substring(resourcePath.length());


        /***
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
                /***actions += "<input type=\"image\" src=\"img/window-new.png\" onclick=\"newResourceItem("+resource.getWidgetId()+",'"+resource.getFileName()+"','"+env +"','"+itemPath+"')\"/>";***
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
                ResourceFS4Tree child = new ResourceFS4Tree( getPath( )+ separatorChar + entries[ i ] );
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
        }**/
    }

    public long size( )
    {
        long totalSize = length( );

        if( isDirectory( ) )
        {
            String [ ] entries = list( );
            if(entries != null){
                for( int i = 0; i < entries.length; i++ )
                {
                    ResourceFileSystem  child = new ResourceFileSystem( getPath( )+ separatorChar + entries[ i ] );
                    totalSize += child.size( );
                }
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

            if(entries != null){
                for( int i = 0; i < entries.length; i++ )
                {
                    ResourceFS4Tree child = new ResourceFS4Tree( f.getPath( )+ ResourceFileSystem.separatorChar + entries[ i ] );
                    child.resourcePath = f.resourcePath;
                    child.resource     = f.resource;
                    child.env          = f.env;

                    child.listAll(1,id,buf);
                }
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
