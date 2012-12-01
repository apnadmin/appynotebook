<%-- 
    Document   : show-package
    Created on : Jan 7, 2011, 8:17:59 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
       com.feezixlabs.bean.AppletPackage packageFound = null;
       String pkgId = request.getParameter("id");

       boolean showinstallbtn = false;
       boolean showuninstallbtn = false;
       for(com.feezixlabs.bean.AppletPackage pkg : com.feezixlabs.db.dao.AppletPackageDAO.getAppletPackages()){
           if(pkg.getId().compareToIgnoreCase(pkgId) == 0)
           {

             packageFound = pkg;
             break;
           }
       }
       if(packageFound != null){

            for(com.feezixlabs.bean.PackagedApplet applt:com.feezixlabs.db.dao.AppletPackageDAO.getPackagedApplets(packageFound.getId())){
                if(applt.getAppletId() != 0)
                   showuninstallbtn = true;
                else
                   showinstallbtn = true;
            }

            String installAllcheckBox = showinstallbtn?" <input type=\"checkbox\" onclick=\"appletBuilder.selectAppletForInstall('"+packageFound.getId()+"')\" class=\"selectallpackageapplet4install\" id=\"selectallpackageapplet4install-"+packageFound.getId()+"\"/> ":"";
            String uninstallAllcheckBox = showuninstallbtn?" <input type=\"checkbox\" onclick=\"appletBuilder.selectAppletForunInstall('"+packageFound.getId()+"')\" class=\"selectallpackageapplet4uninstall\" id=\"selectallpackageapplet4uninstall-"+packageFound.getId()+"\" /> ":"";
%>
<table>
    <tr>
        <td>
            <h4 style="font-size: 18pt"><%=packageFound.getName()%></h4>
        </td>
    </tr>
    <tr>
        <td>Default Category: <%=com.feezixlabs.util.Utility.getToxonomyHtmlSelect(packageFound.getId(),packageFound.getCategory())%></td>
    </tr>
    <%if(showinstallbtn){%>
    <tr>
        <td><%="<button id=\"install-package-"+packageFound.getId()+"\" onclick=\"appletBuilder.installPackage('"+packageFound.getId()+"')\" disabled>Install</button>"%></td>
    </tr>
    <%}%>
    <%if(showuninstallbtn){%>
    <tr>
        <td><%="<button id=\"uninstall-package-"+packageFound.getId()+"\"  onclick=\"appletBuilder.uninstallPackage('"+packageFound.getId()+"')\" disabled>UnInstall</button>"%></td>
    </tr>
    <%}%>
</table>
<table>
    <thead>
       <tr>
        <th style="text-align:left">
            Applets
        </th>
        <th style="text-align:left">
            Category
        </th>
        <th style="text-align:left">
            <%if(showinstallbtn){%>
                Install<br/>
                <%=installAllcheckBox%>
            <%}%>
        </th>
        <th style="text-align:left">
            <%if(showuninstallbtn){%>
                UnInstall<br/>
                <%=uninstallAllcheckBox%>
            <%}%>
        </th>
       </tr>
    </thead>
    <tbody>
    <%
        for(com.feezixlabs.bean.PackagedApplet applt:com.feezixlabs.db.dao.AppletPackageDAO.getPackagedApplets(packageFound.getId())){

        String id = ""+applt.getId();
        String qualifiedId = packageFound.getId()+","+id;

        String installablecheckBox = "";
        String uninstallablecheckBox = "";

        installablecheckBox =  applt.getInstalled().compareToIgnoreCase("No") ==0?  " <input type=\"checkbox\" onclick=\"appletBuilder.selectAppletForInstall('"+packageFound.getId()+"','"+id+"')\" class=\"selectpackageapplet4install\" id=\"selectpackageapplet4install-"+qualifiedId.replaceAll(",","-")+"\"/> ":"";
        uninstallablecheckBox =  applt.getInstalled().compareToIgnoreCase("Yes") ==0?  " <input type=\"checkbox\" onclick=\"appletBuilder.selectAppletForunInstall('"+packageFound.getId()+"','"+id+"')\" class=\"selectpackageapplet4uninstall\" id=\"selectpackageapplet4uninstall-"+qualifiedId.replaceAll(",","-")+"\" /> ":"";

    %>

    <tr>
        <td>
            <%= applt.getName() %>
        </td>
        <td>
            <%=com.feezixlabs.util.Utility.getToxonomyHtmlSelect(packageFound.getId()+"-"+applt.getId(),applt.getCategory())%>
        </td>
        <td>
            <%=installablecheckBox%>
        </td>
        <td>
            <%=uninstallablecheckBox%>
        </td>
    </tr>

    <%}%>
    </tbody>
</table>


<%}else{%>

<h4>Error loading package</h4>

<%}%>