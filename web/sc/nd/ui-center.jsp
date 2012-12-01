<%--<a tabindex="0"  href="#test-menu-content" class="fg-button fg-button-icon-right ui-widget ui-state-default ui-corner-all" id="test-menu"><span class="ui-icon ui-icon-triangle-1-s"></span>flyout menu</a>--%>

<div id="colabopad-frame">
    
    <div id="participant-tabcontrol-pane" style="position: absolute;left:-130000px">
        <div id="participant-tabcontrol" style="display:none;background:url(images/misc/bg_dotted-v1.png)">

            <ul id="participant-tabcontrol-headers">
                <li class="phyzixlabs-not-portable"><a style="font-weight:bold" href="#main-home-tab"><span style="float:left" class="ui-icon ui-icon-home"></span>APP Store</a></li>
            </ul>

            <div id="participant-tabcontrol-tabs">
                <div id="main-home-tab" style="padding:0px;" class="phyzixlabs-not-portable">
                    <iframe id="appStoreHomePage"  name="appStoreHomePage" src="../../app-store/index.jsp" width="100%" height="140" scrolling="no"  frameborder="no"></iframe>
                </div>
            </div>
        </div>
    </div>
    
    <div id="hold-javascript"></div>
    <div id="application-page-screen"></div>
    <div id="page-controlpanel-holder" style="">      

    <div  style="display:none;" id="main-page-toolbar-container"> <!--class="ui-corner-all ui-widget-header" -->
            <div style="border-right:0px;border-left: 0px;border-top:0px;margin-bottom: 2px;margin-top:0px;padding:8px;padding-bottom: 5px" class="ui-widget-header">
                <ul id="main-page-toolbar" style="list-style:none;display:inline;background:none;margin-bottom: 2px" >

                    <%--if(request.isUserInRole("developer") || request.isUserInRole("sysadmin")){%>
                    <li style="display:inline">
                        <button  id="phyzixlabs-developer-menu" class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Developer" ><span class="ui-icon ui-icon-triangle-1-s"></span><img src="../widgetbuilder/img/gnome-desktop-config.png" style="float:none"/></button>
                    </li>
                    <%}--%>
                    <%--
                    <li style="display:inline" class="rootVoice {menu: 'colabopad-menu-export'}">
                        <button  class="toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Export/Print Page" ><span class="ui-icon ui-icon-triangle-1-s"></span><img src="images/toolbar/context/save-to-disk.png" style="float:none"/></button>
                    </li>
                    --%>
                    <li style="display:inline">
                        <button style="float:left" id="phyzixlabs-file-new-page-menu-button" class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary"  title="New Page"><span class="ui-icon ui-icon-triangle-1-s"></span><img src="images/toolbar/context/new-doc.png" style="float:none"/></button> 
                    </li>        

                    <%--
                    <li style="display:inline">
                        <button style="float:left" id="phyzixlabs-export-menu-button" class="toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Export/Print Page" ><span class="ui-icon ui-icon-triangle-1-s"></span><img src="images/toolbar/context/save-to-disk.png" style="float:none"/></button> 
                    </li>            
                    --%>

                    <li style="display:inline;">
                        <button style="float:left" id="phyzixlabs-export-pdf-button" onclick="ColabopadApplication.menubar.filemenu.savePageItem.action('pdf');return false;" class="toolbar-button fg-button ui-state-default ui-corner-left  ui-priority-primary" title="Export/Print PDF" ><img src="images/export-menu/pdf-16x16.png" style="float:none"/></button> 
                        <button style="float:left" id="phyzixlabs-export-png-button" onclick="ColabopadApplication.menubar.filemenu.savePageItem.action('png');return false;" class="toolbar-button fg-button ui-state-default ui-priority-primary" title="Export/Print PNG" ><img src="images/export-menu/png.png" style="float:none"/></button> 
                        <button style="float:left" id="phyzixlabs-export-svg-button" onclick="ColabopadApplication.menubar.filemenu.savePageItem.action('svg');return false;" class="toolbar-button fg-button ui-state-default ui-corner-right  ui-priority-primary" title="Export/Print SVG" ><img src="images/export-menu/svg.png" style="float:none"/></button> 
                    </li>            

                    <li style="display:inline">
                        <button style="float:left"  class="toolbar-button fg-button ui-state-default ui-corner-left ui-state-disabled" title="Undo" onclick="ColabopadApplication.undo()" id="undo_btn"  disabled><img src="images/toolbar/context/undo.png"/></button> 
                        <button style="float:left"  class="toolbar-button fg-button ui-state-default ui-corner-right ui-state-disabled" title="Redo" onclick="ColabopadApplication.redo()" id="redo_btn" disabled><img src="images/toolbar/context/redo.png"/></button> 
                    </li>




                    <li style="display:inline">
                        <button style="float:left" id="delete-page-tb-btn" class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary ui-state-disabled" title="Delete Page" id="del-pg-button" onclick="ColabopadApplication.delPage()" disabled><img src="images/toolbar/context/del-doc.png" style="float:none"/></button>
                    </li>

                    <%if(request.isUserInRole("sysadmin") || request.isUserInRole("developer") || request.isUserInRole("reviewer")){%>
                    <li style="display:inline" class="phyzixlabs-not-portable">
                        <button style="float:left"  id="phyzixlabs-developer-menu" class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Apps" ><span class="ui-icon ui-icon-triangle-1-s"></span><img src="images/toolbar/context/widgets.png" style="float:none"/></button>
                    </li>
                    <%}%>
                    <li style="display:inline">
                        <input type="text" value="#000000" class="iColorPicker writeonly" size="7" style="border:none;" id="pencolorPicker" name="pencolorPicker"/>

                        <!--<div><input id="penColor" name="penColor" class=" writeonly" type="text" value="#333399" /></div>-->

                        <select  id="penWidthCtrl" class="writeonly" name="penWidthCtrl" onchange="ColabopadApplication.setPenWidth(this.value)" title="Pen Width">
                            <option  value="1" selected>1px</option>
                            <option  value="2" >2px</option>
                            <option  value="3" >3px</option>
                            <option  value="4" >4px</option>
                            <option  value="5" >5px</option>
                            <option  value="6" >6px</option>
                            <option  value="7" >7px</option>
                            <option  value="8" >8px</option>
                            <option  value="9" >9px</option>
                            <option  value="10" >10px</option>
                            <option  value="11" >11px</option>
                            <option  value="12" >12px</option>
                            <option  value="13" >13px</option>
                            <option  value="14" >14px</option>
                            <option  value="15" >15px</option>
                            <option  value="16" >16px</option>
                            <option  value="17" >17px</option>
                            <option  value="18" >18px</option>
                            <option  value="19" >19px</option>
                            <option  value="20" >20px</option>
                        </select>

                    </li>

                    <li style="display:inline">
                        <button style="float:right"  class="toolbar-button fg-button ui-state-default ui-corner-right  ui-priority-primary ui-state-disabled" title="Next Page" id="next-pg-button" onclick="ColabopadApplication.nextPage()" disabled><img src="images/toolbar/context/go-next.png" style="float:none"/></button>
                    </li>
                    <li style="display:inline">
                        <button style="float:right"  class="toolbar-button fg-button ui-state-default ui-corner-left  ui-priority-primary ui-state-disabled" title="Previous Page" id="prev-pg-button" onclick="ColabopadApplication.prevPage()" disabled><img src="images/toolbar/context/go-previous.png" style="float:none"/></button>
                    </li>

                    <li style="display:inline">
                        <button style="float:right;display:none" id="edit-webpage-link-button"  class="toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Point to URL" ><img src="images/toolbar/context/www-browser.png" style="float:none"/></button>
                    </li>
                    <li style="display:inline">
                        <button style="float:right;display:none" id="edit-webpage-button"  class="toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Edit Page" ><img src="images/toolbar/context/edit-stock_new-html.png" style="float:none"/></button>
                    </li>
                    <li style="display:inline">
                        <button style="float:right;display:none" id="finish-edit-webpage-button"  class="toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Finished editing Page" ><img src="images/toolbar/context/gfloppy.png" style="float:none"/></button>
                    </li>
                </ul>
            </div>


        <div  id="ckeditortoolbar-container" style="padding-left:0px;margin-bottom: 2px">

        </div>


        <button id="new-workbook-btn"  class="toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="New Workbook" onclick="$('#book-dialog').dialog('open')" style="display:none;padding:0;"><img src="images/toolbar/participant/new-context.png" /></button>
    </div>
        
    </div>
    <div id="tab-content-holder"></div>
    
   <%@include file="ui-component-markups/toolbar.jsp"%>

   <%@include file="ui-component-markups/widget-ui.jsp" %>

   <%@include file="ui-component-markups/ui-holder.jsp" %>
   <div id="toolbar-hider" style="display:none"></div>
   <div id="inches_to_pixel" style="width:1in;"></div>
</div>
