


<div id="floating-toolbox-toolbar" style="padding: 2px;width:44px;display:none;" class="fg-buttonset fg-buttonset-single">

        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary ui-state-active" title="Select,Move" onclick="ColabopadApplication.setPenMode('pointer')"><img src="images/toolbar/context/pointer.png"/></button>
        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Activate APPS for Drag & Drop" onclick="ColabopadApplication.setPenMode('move')"><img src="images/toolbar/context/move-pen-mode.png"/></button>
        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Write" onclick="ColabopadApplication.setPenMode('freehand')"><img src="images/toolbar/context/pen.png"/></button>
        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Draw Line" onclick="ColabopadApplication.setPenMode('line')"><img src="images/toolbar/context/line.png"/></button>
        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Draw Rectangle" onclick="ColabopadApplication.setPenMode('rect')"><img src="images/toolbar/context/rect.png"/></button>
        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Draw Circle" onclick="ColabopadApplication.setPenMode('circle')"><img src="images/toolbar/context/circle.png"/></button>
        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Fill Shape" onclick="ColabopadApplication.setPenMode('fill')"><img src="images/toolbar/context/fill.png"/></button>
        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Erase" onclick="ColabopadApplication.setPenMode('eraser')"><img src="images/toolbar/context/eraser.png"/></button>
        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Rotate items" onclick="ColabopadApplication.setPenMode('rotate')"><img src="images/toolbar/context/rotate.png"/></button>
        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Resize" onclick="ColabopadApplication.setPenMode('resize')"><img src="images/toolbar/context/resize-2d.png"/></button>
        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Type Text" onclick="ColabopadApplication.setPenMode('text')"><img src="images/toolbar/context/text.png"/></button>
        
        <button  class="phyzixlabs-not-portable writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Text Editor" onclick="ColabopadApplication.showTextEditor('<%= com.feezixlabs.db.dao.MiscDAO.getTextData("rich-text-editor").getData() %>','prod')"><img src="images/toolbar/context/text-writer.png"/></button>
        <button  class="writeonly toolbar-button fg-button ui-state-default ui-corner-all  ui-priority-primary" title="Insert Image" onclick="ColabopadApplication.setPenMode('image')"><img src="images/toolbar/context/pen-mode-image.png"/></button>
</div>
<div id="phyzixlabs-export-menu" style="display:none">
    <ul>
        <li  style="vertical-align: middle"><a onclick="ColabopadApplication.menubar.filemenu.savePageItem.action('pdf');return false;" href="#"><img src="images/export-menu/pdf.png" style="width:16px;height:16px"/> PDF File</a></li>
        <li class="phyzixlabs-not-portable"><a onclick="ColabopadApplication.menubar.filemenu.savePageItem.action('png');return false;" href="#"><img src="images/export-menu/png.png" style="width:16px;height:16px"/> PNG File</a></li>
        <li><a onclick="ColabopadApplication.menubar.filemenu.savePageItem.action('svg');return false;" href="#"><img src="images/export-menu/svg.png" style="width:16px;height:16px"/> SVG File</a></li>
    </ul>    
</div>        
        
<div id="phyzixlabs-file-new-page-menu" style="display:none">
    <ul>
        <li><a onclick="ColabopadApplication.menubar.filemenu.newPageMenuItem.action('text-editor');return true;" href="#"><img src="page-templates/defaults/icons/text-writer.png" style="width:16px;height:16px"/> Text Document</a></li>
        <li><a onclick="ColabopadApplication.menubar.filemenu.newPageMenuItem.action('web-page');return true;" href="#"><img src="page-templates/defaults/icons/stock_new-html.png" style="width:16px;height:16px"/> Web page</a></li>
        <li><a onclick="ColabopadApplication.menubar.filemenu.newPageMenuItem.action('default');return true;" href="#"><img src="page-templates/defaults/icons/stripe-32.png" style="width:16px;height:16px"/> Notebook</a></li>
        <li><a onclick="ColabopadApplication.menubar.filemenu.newPageMenuItem.action('graph-paper');return true;" href="#"><img src="page-templates/defaults/icons/graph-32.png" style="width:16px;height:16px"/> Graph Paper</a></li>
        <li><a onclick="ColabopadApplication.menubar.filemenu.newPageMenuItem.action('plain-sheet');return true;" href="#"><img src="page-templates/defaults/icons/plain-32.png" style="width:16px;height:16px"/> Plain Sheet</a></li>
        <li><a onclick="ColabopadApplication.menubar.filemenu.newPageMenuItem.action('black-board');return true;" href="#"><img src="page-templates/defaults/icons/blackboard-32.png" style="width:16px;height:16px"/> Black Board</a></li>
    </ul>
</div>        
        
<div id="content-view-scrollpane"></div>