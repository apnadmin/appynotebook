/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.util;

/**
 *
 * @author bitlooter
 */
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ZipDir
{
    static String baseDir = "";
    public static void zipDir(String baseDir,String zipFileName, String dir){
        ZipDir.baseDir = baseDir;
        ZipDir.zipDir(zipFileName,dir);
    }

    private static void zipDir(String zipFileName, String dir)
    {
        File dirObj = new File(dir);
        if(!dirObj.isDirectory())
        {
            //System.err.println(dir + " is not a directory");
            System.exit(1);
        }

        try
        {

            ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipFileName));

            //System.out.println("Creating : " + zipFileName);

            addDir(dirObj, out);
            // Complete the ZIP file
            out.close();


        }
        catch (IOException e)
        {
            e.printStackTrace();
            System.exit(1);
        }

    }

    private static void addDir(File dirObj, ZipOutputStream out) throws IOException
    {
        File[] files = dirObj.listFiles();
        byte[] tmpBuf = new byte[1024];
        int baseDirLength = ZipDir.baseDir.length();
        
        for (int i=0; i<files.length; i++)
        {
            if(files[i].isDirectory())
            {
                addDir(files[i], out);
                continue;
            }

            FileInputStream in = new FileInputStream(files[i].getAbsolutePath());
            //System.out.println(" Adding: " + files[i].getAbsolutePath());

            String entryName = files[i].getAbsolutePath().substring(baseDirLength+1);
            out.putNextEntry(new ZipEntry(/*files[i].getAbsolutePath()*/entryName));

            // Transfer from the file to the ZIP file
            int len;
            while((len = in.read(tmpBuf)) > 0)
            {
                out.write(tmpBuf, 0, len);
            }

            // Complete the entry
            out.closeEntry();
            in.close();
        }
    }

    public static void main(String[] args)
    {

        if (args.length < 1)
        {
            //System.err.println("Usage: <zip file name> <Complete path to directory>");
        }
        else
        {
            zipDir(args[0], args[1]);
        }
    }
} 
