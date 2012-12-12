<div id="application-left-navigation-panel" style="padding-top: 0px;overflow: hidden">
    
    
        <!--<div class="ui-widget-header ui-corner-all" style="padding: 6px 4px;margin-bottom: 4px;"><img src="images/work-bench/vmware.png"/> <span style="vertical-align:top">Work Explorer</span> <div style="clear:both"></div></div>-->
        <div style="padding:4px;border-bottom: 0;"  class="ui-widget-header">
            <a target="_blank" href="http://www.appynotebook.com" id="powered-by-button" style="display:none;text-decoration:none;vertical-align:bottom"><span style="text-shadow: 0 1px 0 rgba(204, 204, 204, 0.8);font-family: 'Ubuntu Condensed', sans-serif, cursive;color:#808080;text-decoration:none">Powered by APPYnotebook</span><a/>
            <button id="view-rooms-btn" style="display:none">Your Rooms</button>
            <button id="add-participant-btn" style="display:none">Add Participant</button>
            <%if(request.isUserInRole("developer") || request.isUserInRole("reviewer") || request.isUserInRole("sysadmin")){%>
            <a href="../appbuilder" target="_blank"><button id="applet-builder" style="display:none">App Builder & System Tools</button></a>
            <%}%>
            <button id="sign-out-btn" style="display:none">Sign-Out</button>
            <button id="user-settings-btn" style="display:none">Your Settings</button>
            <button id="package-ebook-btn" style="display:none">Package e-book</button>
            
            
            <a href="/doc/home/index.html#workspace" target="_blank"><button id="workspace-help-button" style="display:none;float:right;">Help</button></a> 
            
            
            <button id="collapse-sidebar-button" style="display:none;float:right;">Close Panel</button>
            <button id="new-binder-button" style="display:none;float:right;">New Binder</button>
            <div style="clear:both"></div>
        </div>
    
    
    <div class="ui-widget-header ui-corner-bottom" style="padding:4px;padding-bottom: 4px;padding-top: 2px">
        <div id="participant-treecontrol-scrollpane" class="ui-widget-content" style="margin-top:4px;overflow-y:auto;overflow-x: hidden;"><div id="participant-treecontrol" style=""></div></div>
    </div>
    <div class="ui-widget-content ui-corner-all" id="user-applet-holder" style="padding:4px;margin-top: 4px;">
        <div style="text-align:center;padding:2px;margin-bottom:4px" class="ui-corner-all ui-widget-header" id="user-applet-holder-header">APPS <%--<a href="/app-store/?fr=t" target="_blank"><button id="add-new-btn" style="float:right;">Add a new App</button></a>--%>
            
            
                <button id="add-new-btn" style="float:right;display:none">Add a new App</button>
                <button id="refresh-apps-btn" style="float:right;display:none">Refresh</button>
                <button id="bummy-panel-btn" style="float:right;display:none">&nbsp;</button>
            
            
            <div style="clear:both"></div>
        </div>
        <div id="app-panel" style="clear:both;overflow-y: auto;overflow-x: hidden"></div>
    </div>    

        <div id="log-viewer-dialog" title="log viewer" style="display:none">    
            <div id="debug-output"  style="border-style:solid;padding:3px;background:black;"></div>
        </div>
</div>
