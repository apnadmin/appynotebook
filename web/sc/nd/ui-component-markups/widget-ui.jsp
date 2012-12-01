<div id="widget-contrl-panel"  style="width:128px;position:absolute;display:none">
    <div id="widget-move-button" class="widget-app-cp-button" style="width:16px;height:16px"><img  src="<%=request.getAttribute("urlPrefix")!=null?request.getAttribute("urlPrefix"):"" %>images/widget-cp/move.png" title="Move" style="cursor:move;"/></div>
    <div id="widget-delete-button" class="widget-app-cp-button" style=""> <button id="app-cp-delete-btn">delete</button>  </div>
    <div id="widget-controlpanel-button" class="widget-app-cp-button" style="width:16px;height:16px;"> <img  src="<%=request.getAttribute("urlPrefix")!=null?request.getAttribute("urlPrefix"):"" %>images/widget-cp/control-panel.png" title="Control Panel" style="cursor:pointer;"/></div>
    <div id="widget-instance-control-panel" style="display:none"></div>    
    <div id="widget-help-button" class="widget-app-cp-button" style="margin-top: 2px;margin-bottom: 2px"><button id="app-cp-help-btn">help</button> </div>
</div>

<div id="widget-rotate-button" class="widget-app-cp-button" style="width:16px;height:16px;display:none;position:absolute"><img  src="<%=request.getAttribute("urlPrefix")!=null?request.getAttribute("urlPrefix"):"" %>images/widget-cp/rotate.png" title="Rotate" style="cursor:crosshair"/></div>
<div id="widget-scale-button" class="widget-app-cp-button" style="width:16px;height:16px;display:none;position:absolute"><img  src="<%=request.getAttribute("urlPrefix")!=null?request.getAttribute("urlPrefix"):"" %>images/widget-cp/resize.png" title="Resize" style="cursor:se-resize"/></div>

<!-- IMPORTANT: this should remain visible and block, otherwise inner html wont be visible -->
<div id="widget-markup" >
</div>

<div id="widget-class-control-panel"  style="position:absolute;display:none"></div>
