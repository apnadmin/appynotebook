    <div id="main-view" style="border-style:none;margin: 0;padding: 0">
        <div id="left-sidebar-panel" style="width:350px;margin-right:4px;float:left;margin-bottom: 0">
             <%@include  file="left-panel.jsp"%>
        </div>
        <button id="expand-sidebar-button" style="display:none;float:left;width:32px;height:32px;">Open side panel</button>
        <div id="ui_center_pane" class="ui-widget-content"  style="float:right;margin:0;padding: 0px;">
            <%@include  file="ui-center.jsp"%>
        </div>
        <div style="clear:both"></div>
    </div>
    <div style="clear:both"></div>

    <!--IMPORTANT THAT THIS STAYS OUT OF THE LAYOUT -->
    <%@include file="ui-component-markups/context-menus.jsp" %>
    <%@include file="ui-component-markups/dialogs.jsp" %>

    <iframe style="position:absolute;left:-1000px" id="packageInterface" name="packageInterface" src="../appbuilder/package.jsp" width="0" height="0" scrolling="no"></iframe>
    <iframe style="position:absolute;left:-1000px" id="saveAsSVGInterface" name="saveAsSVGInterface" src="" width="0" height="0" scrolling="no"></iframe>
    <iframe style="position:absolute;left:-1000px" id="saveAsPNGInterface" name="saveAsPNGInterface" src="" width="0" height="0" scrolling="no"></iframe>
    <iframe style="position:absolute;left:-1000px" id="saveAsPDFInterface" name="saveAsPDFInterface" src="" width="0" height="0" scrolling="no"></iframe>
    <iframe style="position:absolute;left:-1000px" id="saveAsDataInterface" name="saveAsDataInterface" src="" width="0" height="0" scrolling="no"></iframe>