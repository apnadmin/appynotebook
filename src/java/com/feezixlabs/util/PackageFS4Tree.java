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
public class PackageFS4Tree  extends File {
    public PackageFS4Tree( String name )
    {
        super( name );
    }
    
    static String buildLazy(String name,String id){
        StringBuilder buf = new StringBuilder();
        buf.append("{\"title\":\""+name+"\",\"id\":\""+id+"\",\"isFolder\":false,\"addClass\":\"phyzixlabs-system-package\",\"type\":\"phyzixlabs-system-package\"}");
        return buf.toString();
    }


    public static String buildTreeLazy(){
        StringBuilder buf = new StringBuilder();

        buf.append("[");

        boolean first = true;
        //buf.append("{\"title\":\"System\",\"id\":\"default\",\"isFolder\":false,\"addClass\":\"phyzixlabs-system-package-default\",\"type\":\"phyzixlabs-system-package\"}");
        for(com.feezixlabs.bean.AppletPackage pkg : com.feezixlabs.db.dao.AppletPackageDAO.getAppletPackages()){
            buf.append((!first?",":"")+ buildLazy(pkg.getName(),pkg.getId()));
            first = false;
        }
        buf.append("]");
        return buf.toString();
    }
}
