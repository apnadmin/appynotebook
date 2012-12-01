        <div id="layout-west" class="ui-layout-west ui-widget ui-widget-content">
            <div class="ui-widget-header ui-corner-all" style="padding: 6px 4px;margin-bottom: 4px;"><img src="img/vmware.png"/>APP Solution Explorer</div>

            <div class="ui-widget-header ui-corner-all" style="padding:4px;padding-bottom: 4px;">
                <a href="/doc/home/index.html#app-dev" target="_blank" id="hadron-help-btn-link"><button id="hadron-help-btn" style="display:none">Help</button></a>
                <div id="applet-treecontrol"></div>
            </div>

            <%@include file="context-menus.jsp"%>

            <div style="display:none">
            <!-- Definition of New Widget dialog -->
            <div id="new-widget-dialog" title="APP Info">
                <table>
                    <tr>
                        <td style="text-align:right">Name*:</td><td><input type="text" id="widgetName"/> <input type="hidden" id="widgetId"/> <input type="hidden" id="curWidgetEnv"/></td>
                    </tr>
                    <tr>
                        <td style="text-align:right">Description:</td><td><textarea id="widgetDescription"></textarea> </td>
                    </tr>
                    <tr>
                        <td style="text-align:right">Category*:</td><td id="widgetCategory-holder"><input type="text" id="widgetCategory"/> </td>
                    </tr>
                    <tr>
                        <td style="text-align:right">Tags:</td><td><input type="text" id="widgetTags"/> </td>
                    </tr>

                    <!--
                    <tr>
                        <td style="text-align:right">Question:</td><td><textarea id="widgetQuestion"></textarea> </td>
                    </tr>
                    <tr>
                        <td style="text-align:right">Price:</td><td><input type="text" id="widgetPrice" value="0.0" /> </td>
                    </tr>
                    <tr>
                        <td style="text-align:right">Catalog Page:</td><td><input type="text" id="widgetCatalogPageIndex" value="1" /> </td>
                    </tr>
                    -->
                    <input type="hidden" id="widgetQuestion" value="" />
                    <input type="hidden" id="widgetPrice" value="0.0" />
                    <input type="hidden" id="widgetCatalogPageIndex" value="1" />
                    <tr>
                        <td style="text-align:right">Author Name*:</td><td><input type="text" id="widgetAuthorName"/> </td>
                    </tr>
                    <tr>
                        <td style="text-align:right">Author Link:</td><td><input type="text" id="widgetAuthorLink"/> </td>
                    </tr>
                    <tr>
                        <td style="text-align:right">Version:</td><td><input type="text" id="widgetVersion" value="1.0" disabled/> </td>
                    </tr>
                    <tr>
                        <td style="text-align:right">For Background Use:</td><td><input type="checkbox" id="showInMenu" /> </td>
                    </tr>                    
                </table>
            </div>



            <div id="package-widget-dialog" title="Package APPS">
                <table>
                    <tr>
                        <td>
                            For e-book:
                        </td>
                        <td>
                            <input type="checkbox" id="ebook_package_export"/>
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td valign="top">
                                <table id="package-widget-list" class="scroll" cellpadding="0" cellspacing="0"></table>
                                <div id="package-widget-list-pager" class="scroll" style="text-align:center;"></div>
                        </td>
                        <td valign="top">
                            <fieldset style="margin-bottom:4px">
                                <legend>Package Information</legend>
                                <table>
                                    <tr>
                                        <td class="signup-label">
                                            Name*:
                                        </td>
                                        <td>
                                            <input type="text" id="applet_package_name" name="applet_package_name"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="signup-label">
                                            Version:
                                        </td>
                                        <td>
                                            <input type="text" id="applet_package_version" name="applet_package_version"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="signup-label">
                                            Description:
                                        </td>
                                        <td>
                                            <textarea id="applet_package_description" name="applet_package_description"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="signup-label">
                                            License:
                                        </td>
                                        <td>
                                            <textarea id="applet_package_license" name="applet_package_license"></textarea>
                                        </td>
                                    </tr>
                                    <!--
                                    <tr>
                                        <td>
                                            For production use only
                                        </td>
                                        <td>
                                            <input type="checkbox" id="production_use_only" name="production_use_only"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Restrict to Domain
                                        </td>
                                        <td>
                                            <input type="text" id="applet_package_domain" name="applet_package_domain"/>
                                            <span style="font-size:8px;color:silver">(eg:umd.edu)</span>
                                        </td>
                                    </tr>
                                    -->
                                </table>
                            </fieldset>
                                <div id="package-widget-dependency-treecontrol"></div>
                                <table id="package-widget-dependency-list" class="scroll" cellpadding="0" cellspacing="0"></table>
                                <div id="package-widget-dependency-list-pager" class="scroll" style="text-align:center;"></div>
                        </td>
                    </tr>
                </table>
            </div>

            <div id="new-applet-resource-dialog" title="File Name">
                <input type="text" id="new-applet-resource-name" name="new-applet-resource-name"/>
            </div>
            <div id="new-applet-category-dialog" title="Category Name">
                <input type="text" id="new-applet-category-name" name="new-applet-category-name"/>
            </div>
            </div>
            
            <div id="widget-rejected-reason-dialog" title="Rejection Reason">
                <textarea id="widget-rejected-reason" cols="32" rows="10" style="width:98%"></textarea>
            </div>            
            <div id="debug-output" style="display:none;width:250px;border-style:solid;padding:3px;background:black;max-height:400px;overflow:auto"></div>
        </div>
