/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.util;
import java.io.*;
import java.util.*;

/**
 *
 * @author bitlooter
 */



public class Unzip {

  static final void copyInputStream(InputStream in, OutputStream out)
  throws IOException
  {
    byte[] buffer = new byte[1024];
    int len;

    while((len = in.read(buffer)) >= 0)
      out.write(buffer, 0, len);

    in.close();
    out.close();
  }

  public static String getTopMostEntryName(String fileName){
      try{
        org.apache.commons.compress.archivers.zip.ZipFile zipFile = new org.apache.commons.compress.archivers.zip.ZipFile(fileName);
        String dir = determineBaseDir(zipFile.getEntries());
        zipFile.close();
        return dir;
      }
      catch(Exception ex){
          
      }return "";
  }

  static String determineBaseDir(Enumeration<org.apache.commons.compress.archivers.zip.ZipArchiveEntry> entries){
        String dir = "";
        while(entries.hasMoreElements()){
            org.apache.commons.compress.archivers.zip.ZipArchiveEntry entry = entries.nextElement();
            String[] baseDir = entry.getName().split("/");
            if(!dir.equals("") && dir.compareTo(baseDir[0]) != 0)
                return "";
            else
            if(dir.equals(""))
                dir = baseDir[0];
            
        }return dir;
  }

  static String stripBaseDir(String dir,String entryName){      
        return entryName.substring(entryName.indexOf(dir)+dir.length()+1,entryName.length());
  }


  public static void unzipAndSkipBase(String fileName,String outputDir){
      try{
            org.apache.commons.compress.archivers.zip.ZipFile zipFile = new org.apache.commons.compress.archivers.zip.ZipFile(fileName);

            Enumeration<org.apache.commons.compress.archivers.zip.ZipArchiveEntry> entries = zipFile.getEntries();

            //see if there is one top-level folder
            String baseDir = determineBaseDir(zipFile.getEntries());


            while(entries.hasMoreElements()){
                org.apache.commons.compress.archivers.zip.ZipArchiveEntry entry = entries.nextElement();


                //if this is base entry, then skip it
                if(entry.isDirectory() && entry.getName().compareTo(baseDir+"/") == 0){
                    //System.out.println("Skipping base");
                    continue;
                }

                String entryOutputPath = outputDir+java.io.File.separatorChar+stripBaseDir(baseDir,entry.getName());
                //System.out.println("entry:"+entryOutputPath);
                File zipEntryFile = new File(entryOutputPath);

                //System.out.println("Entry:"+entry.getName());

                //ensure dependent directories exist
                if(entry.isDirectory()){
                    zipEntryFile.mkdirs();continue;
                }
                else
                if(zipEntryFile.getParentFile() != null)
                    zipEntryFile.getParentFile().mkdirs();

                copyInputStream(zipFile.getInputStream(entry),new BufferedOutputStream(new FileOutputStream(entryOutputPath)));
            }
            zipFile.close();
            //return baseDir;
      }
      catch(IOException ioe){
       ioe.printStackTrace();
      }//return "";
  }



  public static String unpack(String fileName,String outputDir){
      String manifestPath = "";
      try{
            org.apache.commons.compress.archivers.zip.ZipFile zipFile = new org.apache.commons.compress.archivers.zip.ZipFile(fileName);

            Enumeration<org.apache.commons.compress.archivers.zip.ZipArchiveEntry> entries = zipFile.getEntries();
            while(entries.hasMoreElements()){
                org.apache.commons.compress.archivers.zip.ZipArchiveEntry entry = entries.nextElement();

                String entryOutputPath = outputDir+java.io.File.separatorChar+entry.getName();
                File zipEntryFile = new File(entryOutputPath);

                //ensure dependent directories exist
                if(entry.isDirectory()){
                    zipEntryFile.mkdirs();continue;
                }
                else
                if(zipEntryFile.getParentFile() != null)
                    zipEntryFile.getParentFile().mkdirs();

                if(manifestPath.length()==0 && !entry.isDirectory() && entry.getName().endsWith("manifest.xml"))
                    manifestPath = entryOutputPath;

                copyInputStream(zipFile.getInputStream(entry),new BufferedOutputStream(new FileOutputStream(entryOutputPath)));
            }
            zipFile.close();
      }
      catch(IOException ioe){
       ioe.printStackTrace();
      }return manifestPath;
  }



  public static void unzip(String fileName,String outputDir){
      try{
            org.apache.commons.compress.archivers.zip.ZipFile zipFile = new org.apache.commons.compress.archivers.zip.ZipFile(fileName);
 
            Enumeration<org.apache.commons.compress.archivers.zip.ZipArchiveEntry> entries = zipFile.getEntries();            
            while(entries.hasMoreElements()){
                org.apache.commons.compress.archivers.zip.ZipArchiveEntry entry = entries.nextElement();

                String entryOutputPath = outputDir+java.io.File.separatorChar+entry.getName();
                File zipEntryFile = new File(entryOutputPath);

                //ensure dependent directories exist
                if(entry.isDirectory()){
                    zipEntryFile.mkdirs();continue;
                }
                else
                if(zipEntryFile.getParentFile() != null)
                    zipEntryFile.getParentFile().mkdirs();
                
                copyInputStream(zipFile.getInputStream(entry),new BufferedOutputStream(new FileOutputStream(entryOutputPath)));
            }
            zipFile.close();
      }
      catch(IOException ioe){
       ioe.printStackTrace();
      }
  }

}
