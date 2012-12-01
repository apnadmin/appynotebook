<%if(request.isUserInRole("sysadmin") || request.isUserInRole("developer") || request.isUserInRole("reviewer")){%>
<%--= com.feezixlabs.util.Utility.buildWidgetMenu() --%>
<%}%>

<div id="colabopad-menu-file-new-page" class="menu" style="display:none">
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('text-editor')" img="page-templates/defaults/icons/text-writer.png" >Text Document</a>
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('web-page')" img="page-templates/defaults/icons/stock_new-html.png" >Web page</a>
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('default')" img="page-templates/defaults/icons/stripe-32.png" >Notebook</a>
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('graph-paper')"  img="page-templates/defaults/icons/graph-32.png">Graph Paper</a>
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('plain-sheet')"  img="page-templates/defaults/icons/plain-32.png">Plain Sheet</a>
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('black-board')"  img="page-templates/defaults/icons/blackboard-32.png">Black Board</a>
    <!--<a menu="colabopad-menu-file-new-custom-page"  img="page-templates/defaults/icons/blank.png">Custom Page</a>-->
</div>

<!--
<div id="colabopad-menu-file-new-custom-page" class="menu">
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('usa')" img="page-templates/custom/icons/usa-icon.png" >USA</a>
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('linux')" img="page-templates/custom/icons/linux-icon.png" >Linux</a>
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('mit')"  img="page-templates/custom/icons/mit-icon.png">MIT</a>
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('njit')"  img="page-templates/custom/icons/njit-icon.png">NJIT</a>
    <%--
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('checkers')"  img="page-templates/custom/icons/checkers-icon.png">Checkers Board</a>
    <a action="colabopad.menubar.filemenu.newPageMenuItem.action('chess')"  img="page-templates/custom/icons/chess-icon.png">Chess Board</a>
    --%>
</div>
-->
<div id="colabopad-menu-export" class="menu" style="display:none">
    <%--
    <a menu="colabopad-menu-page-save-as">Current Page</a>
    <a menu="colabopad-menu-book-save-as">Current Book</a>
    --%>
    
    <a action="colabopad.menubar.filemenu.savePageItem.action('pdf')"  img="images/export-menu/pdf.png">PDF File</a>
    <a action="colabopad.menubar.filemenu.savePageItem.action('png')" img="images/export-menu/png.png">PNG File</a>
    <a action="colabopad.menubar.filemenu.savePageItem.action('svg')"  img="images/export-menu/svg.png">SVG File</a>
    
</div>


<%--
    <div id="colabopad-menu-page-save-as" class="menu">
        <a action="colabopad.menubar.filemenu.savePageItem.action('pdf')"  img="images/export-menu/pdf.png">PDF File</a>
        <a action="colabopad.menubar.filemenu.savePageItem.action('png')" img="images/export-menu/png.png">PNG File</a>
        <a action="colabopad.menubar.filemenu.savePageItem.action('svg')"  img="images/export-menu/svg.png">SVG File</a>
    </div>

    <div id="colabopad-menu-book-save-as" class="menu">
        <a action="colabopad.menubar.filemenu.saveBookItem.action('pdf')"  img="images/export-menu/pdf.png">PDF File</a>
        <a action="colabopad.menubar.filemenu.saveBookItem.action('png')" img="images/export-menu/png.png">PNG File</a>
        <a action="colabopad.menubar.filemenu.saveBookItem.action('svg')"  img="images/export-menu/svg.png">SVG File</a>
    </div>
--%>
