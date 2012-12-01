/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.util;
import java.io.*;
import com.feezixlabs.util.appletpackage.Package;
import com.feezixlabs.util.appletpackage.Applet;
/**
 *
 * @author bitlooter
 */
public class PackageFileSystem  extends File
{
    static final java.text.DateFormat dateFormat = new java.text.SimpleDateFormat("MM-dd-yyyy");
    static Package _package = null;
    String appletName;

    // Constructor
    public PackageFileSystem( String name)
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

        String name = depth == 0?PackageFileSystem._package.getName():this.appletName;
        String checkBox = "";
        if(true){
            checkBox = " <input type=\"checkbox\" onclick=\"selectAppletForInstall(["+(qualifiedParentId.length()>0?"'"+qualifiedParentId.replaceAll(",", "','")+"'":"")+"],'"+id+"')\" class=\"selectpackageapplet\" id=\"selectpackageapplet-"+qualifiedId.replaceAll(",","-")+"\" name=\"selectpackageapplet-"+id+"\"/> ";
        }

        buf.append("<row>");
        buf.append(" <cell><![CDATA["+id+"]]></cell>");
        buf.append(" <cell><![CDATA["+checkBox+name+"]]></cell>");
        buf.append(" <cell><![CDATA["+(this.size())+"]]></cell>");

        int library_path_length = (com.feezixlabs.util.ConfigUtil.resource_directory+"/packages").length()+1;

        buf.append(" <cell><![CDATA["+(this.getAbsolutePath().substring(library_path_length))+"]]></cell>");

        if(depth == 0 ){
            buf.append(" <cell><![CDATA["+dateFormat.format(new java.util.Date(this.lastModified()))+"]]></cell>");


            if( true){
                buf.append(" <cell><![CDATA[<button onclick=\"deletePackage('"+qualifiedId+"')\">Remove</button> <button onclick=\"installPackage('"+qualifiedId+"')\">Install</button>]]></cell>");
            }
            else
            if(/*(FileSystem.processing_flag & FileSystem.SHOW_CHECKBOX)>0*/false){
                buf.append(" <cell><![CDATA[<input type=\"checkbox\" onclick=\"selectLibraryEntry(["+qualifiedId+"])\" class=\"selectlibraryentry\" id=\"selectlibraryentry-"+id+"\"/>]]></cell>");
            }
            else
            {
                buf.append(" <cell><![CDATA[]]></cell>");
            }
        }
        else{

            buf.append(" <cell><![CDATA[]]></cell>");
            if(/*(FileSystem.processing_flag & FileSystem.SHOW_CHECKBOX)>0*/false){
                buf.append(" <cell><![CDATA[<input type=\"checkbox\" onclick=\"selectLibraryEntry(["+qualifiedId+"])\" class=\"selectlibraryentry\" id=\"selectlibraryentry-"+id+"\"/>]]></cell>");
            }else{
                buf.append(" <cell><![CDATA[]]></cell>");
            }
        }

        buf.append(" <cell>"+depth+"</cell>");
        buf.append(" <cell>"+parentId+"</cell>");


        if(depth <1 && isDirectory( ))
        {

            buf.append(" <cell>false</cell>");
            buf.append(" <cell>false</cell>");
            buf.append("</row>");

            for(Applet applet: PackageFileSystem._package.getApplets().getApplet()){
                PackageFileSystem child = new PackageFileSystem( this.getAbsolutePath()+ separatorChar + "applet-"+applet.getId() );
                child.appletName = applet.getName();
                child.listAll( depth + 1,id, buf,qualifiedId);
            }

            /*
            String [ ] entries = list( );

            for( int i = 0; i < entries.length; i++ )
            {
                PackageFileSystem child = new PackageFileSystem( getPath( )+ separatorChar + entries[ i ] );
                if(child.isDirectory()){
                    child.appletName =
                    child.listAll( depth + 1,id, buf,qualifiedId);
                }
            }*/
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
                PackageFileSystem  child = new PackageFileSystem( getPath( )+ separatorChar + entries[ i ] );
                totalSize += child.size( );
            }
        }
        return totalSize;
    }

        // Simple main to list all files in current directory
    static public String buildGrid( String rootDir)
    {
        PackageFileSystem f = new PackageFileSystem( rootDir );

        String [ ] entries = f.list( );

        StringBuffer buf = new StringBuffer();
        for( int i = 0; i < entries.length; i++ )
        {
            PackageFileSystem child = new PackageFileSystem( f.getPath( )+ separatorChar + entries[ i ] );
            
            try{
                javax.xml.bind.JAXBContext jaxbContext = javax.xml.bind.JAXBContext.newInstance("com.feezixlabs.util.appletpackage");
                javax.xml.bind.Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();

                Object obj = unmarshaller.unmarshal(new java.io.FileInputStream(new java.io.File(child.getAbsoluteFile()+"/manifest.xml")));

                Package appletPackage = (Package)((/*(javax.xml.bind.JAXBElement)*/obj)/*.getValue()*/);
                PackageFileSystem._package = appletPackage;

                child.listAll( 0,"NULL", buf,"" );
            }catch(Exception ex){
                ex.printStackTrace();
            }
        }        
        return buf.toString();
    }


         // Recursive method to list all files in directory
    private static void addApplet(com.feezixlabs.bean.AppletPackage pkg,com.feezixlabs.bean.PackagedApplet applet,StringBuilder buf)
    {
        String id = ""+applet.getId();
        String qualifiedId = pkg.getId()+","+id;

        String name = applet.getName();
        String installablecheckBox = "";
        String uninstallablecheckBox = "";

        installablecheckBox =  applet.getInstalled().compareToIgnoreCase("No") ==0?  " <input type=\"checkbox\" onclick=\"selectAppletForInstall('"+pkg.getId()+"','"+id+"')\" class=\"selectpackageapplet4install\" id=\"selectpackageapplet4install-"+qualifiedId.replaceAll(",","-")+"\"/> ":"";
        uninstallablecheckBox =  applet.getInstalled().compareToIgnoreCase("Yes") ==0?  " <input type=\"checkbox\" onclick=\"selectAppletForunInstall('"+pkg.getId()+"','"+id+"')\" class=\"selectpackageapplet4uninstall\" id=\"selectpackageapplet4uninstall-"+qualifiedId.replaceAll(",","-")+"\" /> ":"";
        

        buf.append("<row>");
        buf.append(" <cell><![CDATA["+id+"]]></cell>");
        buf.append(" <cell><![CDATA["+name+"]]></cell>");
        buf.append(" <cell><![CDATA["+Utility.getToxonomyHtmlSelect(pkg.getId()+"-"+applet.getId(),applet.getCategory())+"]]></cell>");
        buf.append(" <cell><![CDATA["+installablecheckBox+"]]></cell>");
        buf.append(" <cell><![CDATA["+uninstallablecheckBox+"]]></cell>");
        buf.append(" <cell><![CDATA[]]></cell>");

        buf.append(" <cell>1</cell>");
        buf.append(" <cell>"+pkg.getId()+"</cell>");

        buf.append(" <cell>true</cell>");
        buf.append(" <cell>false</cell>");
        buf.append("</row>");
    }


    private static void addPackage(com.feezixlabs.bean.AppletPackage pkg,StringBuilder buf )
    {
        
        String id = pkg.getId();
        String qualifiedId = id;

        String name = pkg.getName();
        String checkBox = "";

        checkBox = "";//" <input type=\"checkbox\" onclick=\"selectAppletForInstall([],'"+id+"')\" class=\"selectpackageapplet\" id=\"selectpackageapplet-"+qualifiedId.replaceAll(",","-")+"\" name=\"selectpackageapplet-"+id+"\"/> ";
        boolean showinstallbtn = false;
        boolean showuninstallbtn = false;
        for(com.feezixlabs.bean.PackagedApplet applt:com.feezixlabs.db.dao.AppletPackageDAO.getPackagedApplets(pkg.getId())){
            if(applt.getAppletId() != 0)
               showuninstallbtn = true;
            else
               showinstallbtn = true;
        }


        String installAllcheckBox = showinstallbtn?" <input type=\"checkbox\" onclick=\"selectAppletForInstall('"+pkg.getId()+"')\" class=\"selectallpackageapplet4install\" id=\"selectallpackageapplet4install-"+id+"\"/> ":"";
        String uninstallAllcheckBox = showuninstallbtn?" <input type=\"checkbox\" onclick=\"selectAppletForunInstall('"+pkg.getId()+"')\" class=\"selectallpackageapplet4uninstall\" id=\"selectallpackageapplet4uninstall-"+id+"\" /> ":"";

        buf.append("<row>");
        buf.append(" <cell><![CDATA["+id+"]]></cell>");
        buf.append(" <cell><![CDATA["+checkBox+"<b>"+name+"</b>]]></cell>");
        buf.append(" <cell><![CDATA[<b>Default Category:</b><br/>"+Utility.getToxonomyHtmlSelect(pkg.getId(),pkg.getCategory())+"]]></cell>");
        buf.append(" <cell><![CDATA[<button id=\"install-package-"+pkg.getId()+"\" onclick=\"installPackage('"+qualifiedId+"')\" disabled>Install <br/>Selection</button> <br/>"+installAllcheckBox+"]]></cell>");
        buf.append(" <cell><![CDATA[<button id=\"uninstall-package-"+pkg.getId()+"\"  onclick=\"uninstallPackage('"+qualifiedId+"')\" disabled>UnInstall <br/>Selection</button> <br/>"+uninstallAllcheckBox+"]]></cell>");
        buf.append(" <cell><![CDATA[<button onclick=\"deletePackage('"+qualifiedId+"')\">Remove <br/>Package</button>]]></cell>");

        buf.append(" <cell>0</cell>");
        buf.append(" <cell>NULL</cell>");


        buf.append(" <cell>false</cell>");
        buf.append(" <cell>false</cell>");
        buf.append("</row>");

        /*
        buf.append("<row>");
        buf.append(" <cell><![CDATA[]]></cell>");
        buf.append(" <cell><![CDATA[]]></cell>");
        buf.append(" <cell><![CDATA["+Utility.getToxonomyHtmlSelect(pkg.getId()+"-"+pkg.getId(),pkg.getCategory())+"]]></cell>");
        buf.append(" <cell><![CDATA["+checkBox+"]]></cell>");
        buf.append(" <cell><![CDATA["+uninstallAllcheckBox+"]]></cell>");
        buf.append(" <cell><![CDATA[]]></cell>");

        buf.append(" <cell>1</cell>");
        buf.append(" <cell>"+pkg.getId()+"</cell>");

        buf.append(" <cell>true</cell>");
        buf.append(" <cell>false</cell>");
        buf.append("</row>");         
         */
        for(com.feezixlabs.bean.PackagedApplet applt:com.feezixlabs.db.dao.AppletPackageDAO.getPackagedApplets(pkg.getId())){
            addApplet(pkg,applt,buf);
        }
    }

    public static String build()
    {
        StringBuilder buf = new StringBuilder();
        for(com.feezixlabs.bean.AppletPackage pkg : com.feezixlabs.db.dao.AppletPackageDAO.getAppletPackages()){
            addPackage(pkg,buf);
        }
        return buf.toString();
    }
}