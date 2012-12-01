<!-- Definition of context menu -->
<div style="display:none">
<ul id="dev-widget-menu" class="contextMenu">
    <li class="edit"><a href="#edit">Edit Info</a></li>
    <%if(com.feezixlabs.util.ConfigUtil.enable_applet_deployment || request.isUserInRole("sysadmin")){%>
    <li class="submit"><a href="#submit">Deploy</a></li>
    <%}%>    
    <li class="delete"><a href="#delete">Delete</a></li>
</ul>

<ul id="queue-widget-menu" class="contextMenu">
    <%if(request.isUserInRole("reviewer") || request.isUserInRole("sysadmin")){%>
        <li class="approve"><a href="#approve">Approve</a></li>
        <li class="reject"><a href="#reject">Reject</a></li>
    <%}%>
</ul>

<ul id="pending-widget-menu" class="contextMenu">
    <li class="withdraw"><a href="#withdraw">Withdraw</a></li>
</ul>

<ul id="rejected-widget-menu" class="contextMenu">
    <li class="edit"><a href="#edit">Edit Info</a></li>
    <li class="submit"><a href="#resubmit">Resubmit</a></li>
    <li class="delete"><a href="#delete">Cancel Submit</a></li>
</ul>

<ul id="prod-widget-menu" class="contextMenu">
    <li class="delete"><a href="#delete">Undeploy</a></li>
</ul>

<ul id="phyzixlabs-data-instance-definition-root" class="contextMenu">
    <li class="new_data_definition"><a href="#new_data_definition">Define New Data Instance</a></li>
</ul>
<ul id="phyzixlabs-data-instance-definition" class="contextMenu">
    <li class="rename"><a href="#rename">Rename</a></li>
    <li class="delete"><a href="#rename">Delete</a></li>
</ul>


<ul id="phyzixlabs-resource-root-menu" class="contextMenu">
    <li class="add_resource"><a href="#add_resource">Add File/Folder</a></li>
    <li class="new_folder"><a href="#new_folder">New Folder</a></li>
    <li class="new_js_file"><a href="#new_js_file">New JS File</a></li>
    <li class="new_html_file"><a href="#new_html_file">New Html File</a></li>
    <li class="new_css_file"><a href="#new_css_file">New Css File</a></li>
    <!--
    <li class="new_xml_file"><a href="#new_xml_file">New XML File</a></li>
    -->
    <li class="new_txt_file"><a href="#new_txt_file">New Text File</a></li>
</ul>
<ul id="phyzixlabs-resource-dir-menu" class="contextMenu">    
    <li class="add_resource"><a href="#add_resource">Add File/Folder</a></li>
    <li class="new_folder"><a href="#new_folder">New Folder</a></li>
    <li class="new_js_file"><a href="#new_js_file">New JS File</a></li>
    <li class="new_html_file"><a href="#new_html_file">New Html File</a></li>
    <li class="new_css_file"><a href="#new_css_file">New Css File</a></li>
    <li class="delete"><a href="#delete">Delete</a></li>
    <!--
    <li class="new_xml_file"><a href="#new_xml_file">New XML File</a></li>
    -->
    <li class="new_txt_file"><a href="#new_txt_file">New Text File</a></li>
    <li class="rename"><a href="#rename">Rename</a></li>
</ul>

<ul id="phyzixlabs-resource-file-menu" class="contextMenu">    
    <li class="rename"><a href="#rename">Rename</a></li>
    <li class="delete"><a href="#delete">Delete</a></li>
</ul>


<ul id="phyzixlabs-system-library-root-menu" class="contextMenu">
    <%if(request.isUserInRole("sysadmin")){%>
    <li class="add"><a href="#add">Add To Library</a></li>
    <%}%>
</ul>
<ul id="phyzixlabs-system-library-dir-menu" class="contextMenu">
    <%if(request.isUserInRole("sysadmin")){%>
    <li class="delete"><a href="#delete">Delete</a></li>
    <%}%>
</ul>

<ul id="phyzixlabs-system-library-file-menu" class="contextMenu">
    <%if(request.isUserInRole("sysadmin")){%>
    <li class="delete"><a href="#delete">Delete</a></li>
    <%}%>
</ul>


<ul id="phyzixlabs-system-package-root-menu" class="contextMenu">
    <li class="add"><a href="#add">Add Package</a></li>
</ul>
<ul id="phyzixlabs-system-package-menu" class="contextMenu">
    <li class="delete"><a href="#delete">Delete</a></li>
</ul>


<ul id="phyzixlabs-applet-category-root-menu" class="contextMenu">
    <li class="new_category"><a href="#new_category">New APP Category</a></li>
    <li class="new_applet"><a href="#new_applet">New APP</a></li>
    <li class="new_package"><a href="#new_package">Create Package</a></li>
    <%if(com.feezixlabs.util.ConfigUtil.enable_applet_import || request.isUserInRole("sysadmin")){%>
    <li class="import_package"><a href="#import_package">Import APP Package</a></li>
    <%}%>
</ul>
<ul id="phyzixlabs-applet-category-menu" class="contextMenu">
    <li class="new_category"><a href="#new_category">New APP Category</a></li>
    <li class="new_applet"><a href="#new_applet">New APP</a></li>
    <%if(com.feezixlabs.util.ConfigUtil.enable_applet_import || request.isUserInRole("sysadmin")){%>
    <li class="import_package"><a href="#import_package">Import APP Package</a></li>
    <%}%>
    <li class="rename"><a href="#rename">Rename</a></li>
    <li class="delete"><a href="#delete">Delete</a></li>
</ul>
<ul id="phyzixlabs-system-applet-category-menu" class="contextMenu">
    <li class="new_applet"><a href="#new_applet">New APP</a></li>
    <%if(com.feezixlabs.util.ConfigUtil.enable_applet_import || request.isUserInRole("sysadmin")){%>
    <li class="import_package"><a href="#import_package">Import APP Package</a></li>
    <%}%>
</ul>

<ul id="phyzixlabs-deployed-applet-menu" class="contextMenu">
    <li class="undeploy"><a href="#undeploy">Undeploy</a></li>
</ul>
</div>