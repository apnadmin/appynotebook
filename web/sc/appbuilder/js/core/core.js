/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

var appletBuilder = {
            currentNode:null,
            widgets_for_packaging:[],
            current_widget_to_package:null,
            selected_widgets_for_packaging:[],
            body_height:$("body").height(),            
            ACCESS_MODE:{NONE:0,READ:1,WRITE:2,CREATE:4,DELETE:8,EMBED:16},
            jqInit:function(){
                    var _this = this;
                    this.body_height=$("body").height();

                    this.setUpContextMenuBindings();
                    //$(window).bind("beforeunload",function(){
                    //    $('.ui-icon-close').click();
                    //});
                    
                    $.ajax({           
                        url:'start-page.jsp',
                        success:function(data){
                            $(data).appendTo("#home-content-tab");
                        }
                    });                     
                    
                    //$('#hadron-help-btn-link').attr("href",help_url);
                    
                    $.blockUI.defaults.applyPlatformOpacityRules = false;
                    $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.98},theme:true,message: '<h1><img src="../../img/busy.gif" />Loading ,please wait...</h1>'});
                    var appLayout = $('body').layout({applyDefaultStyles: true,west__size:'auto',west__minSize:350});
                    appLayout.sizePane("north",70);
                    
                    appLayout.center = $('#layout-center');
                    $('#layout-north').css({"margin":"0","padding":"2px"});
                    _this.appLayout = appLayout;
                    
                    
                    
                    var $tabs = $('#tabs').tabs({
                     tabTemplate: "<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close'>Remove Tab</span></li>",
                    select:function(event, ui){
                        if(appletBuilder.currentTab){
                            appletBuilder.currentTab.VerticalScroll = $(appLayout.center).scrollTop();
                            appletBuilder.currentTab.HorizontalScroll = $(appLayout.center).scrollLeft();
                            //alert("scroll left:"+appletBuilder.currentTab.VerticalScroll);
                            
                            $("#editor-holder-"+appletBuilder.currentTab.tabid).css("display","none");
                        }
                        $("#editor-holder-"+ui.panel.tabid).css("display","block");
                        if(typeof ui.panel.VerticalScroll != "undefined"){
                            $(appLayout.center).scrollTop(ui.panel.VerticalScroll);
                            $(appLayout.center).scrollLeft(ui.panel.HorizontalScroll);
                        }
                        $("#home-content-tab").css("display","none");
                        if(appletBuilder.currentTab && typeof appletBuilder.currentTab.panel != "undefined")
                            appletBuilder.currentTab.panel.css("display","none");
                        
                        if(typeof ui.panel.panel != "undefined")
                            $(ui.panel.panel).css("display","block");
                        else
                        if(ui.index == 0){
                            $("#home-content-tab").css("display","block");
                        }
                        
                        appletBuilder.currentTab = ui.panel;
                        
                    },
                    load:function(event, ui){
                        //alert(ui.index);
                        if(ui.index==0){
                            //alert($("body").height());
                            //$('#home-container').css({"min-height":($("body").height()-100)+"px"});
                        }
                    },
                    create:function(){
                        //$('#tabs').removeAttr("width");
                    },
		    add: function(event, ui) {
                        //select newely opened tab
                        //$(this).tabs('select',ui.index);
                        //load function to close tab
                        //appletBuilder.removetab($(this), ui.index);
                       //reset tab template
                       var uipanel = ui.panel;
                       $tabs.tabs("option","tabTemplate","<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close'>Remove Tab</span></li>");
                        
                        
                                                
                        if(appletBuilder.makeEditorArgs != null && 
                            (appletBuilder.makeEditorArgs.actype == 'phyzixlabs-resource-file'
                            || appletBuilder.makeEditorArgs.actype == 'phyzixlabs-applet-code'
                            || appletBuilder.makeEditorArgs.actype == 'phyzixlabs-system-toxonomy')){

                            
                            //$( ui.panel ).css({"padding":"2px"}).append(appletBuilder.makeEditorArgs.uipanel);
                            $( ui.panel ).css({"padding":"2px"}).append(appletBuilder.makeEditorArgs.toolbar);
                            $("#editor-holder").append(appletBuilder.makeEditorArgs.uipanel);
                            ui.panel.tabid = appletBuilder.makeEditorArgs.tabId;
                            
                            var pclick = {tabId:new String(appletBuilder.makeEditorArgs.tabId),
                                    acType:new String(appletBuilder.makeEditorArgs.actype)};

                            var editor = appletBuilder.makeEditor(appletBuilder.makeEditorArgs.type, appletBuilder.makeEditorArgs.tabId+'-editor');
                            
                            var callBack = function(){
                                 $( "#save-"+appletBuilder.makeEditorArgs.tabId ).button({
                                        icons: {
                                            primary: "ui-icon-disk"
                                        },
                                        text: true
                                    }).click(function(){
                                        
                                        if(pclick.acType == 'phyzixlabs-resource-file')
                                            appletBuilder.saveResourceItem(pclick.tabId,editor);
                                        else
                                        if(pclick.acType == 'phyzixlabs-applet-code')
                                            appletBuilder.saveAppletCode(pclick.tabId,editor);
                                        else
                                        if(pclick.acType == 'phyzixlabs-system-toxonomy')
                                            appletBuilder.saveAppletToxonomy(pclick.tabId,editor);
                                        
                                        return false;
                                    });                                    
                                    
                                    appletBuilder.initEditorData(editor,appletBuilder.makeEditorArgs.data,appletBuilder.makeEditorArgs.url);

                                    $tabs.tabs('select',ui.index);

                                    var rs = {id:appletBuilder.makeEditorArgs.tabId,
                                            param:appletBuilder.makeEditorArgs.data,
                                            editor:editor
                                            };
                                    open_resources.push(rs);
                                    

                                    var tabContentId = "editor-holder-"+appletBuilder.makeEditorArgs.tabId;
                                    $( "#remove-"+rs.id ).click(function() {
                                            if(editor.contentModified && !confirm("There are unsaved changes in this file, are you sure you want to close it?"))
                                                return;

                                            var index = $( "li", $tabs ).index( $( this ).parent() );
                                            $tabs.tabs( "remove", index );
                                            
                                            
                                            
                                            for(var i=0;i<open_resources.length;i++){
                                                var resource_editor = open_resources[i];
                                                if(resource_editor.id == rs.id){
                                                    open_resources.splice(i,1);
                                                    break;
                                                }
                                            }
                                            $("#"+tabContentId).remove();
                                    });
                                    appletBuilder.makeEditorArgs = null;
                            }                            
                            callBack();
                            
                            //$('.CodeMirror-scroll').css("width",$( ui.panel).width());
                            //alert(.width())
                            //$('#tabs').css("width",$(editor).width());
                        }else
                        if(appletBuilder.makePkgTabArgs != null){
                               $(ui.panel).css({"margin":"0","padding":0});
                               var pkg = {id:appletBuilder.makePkgTabArgs.id};
                                //$('#appletCategory-'+current_package.id).onchange(appletBuilder.setPackageCategory('"+current_package.id+"')");
                                
                                var tabContentId = appletBuilder.makePkgTabArgs.tabId+"-content";
                                $( "#remove-"+appletBuilder.makePkgTabArgs.tabId ).click(function() {
                                        var index = $( "li", $tabs ).index( $( this ).parent() );
                                        $tabs.tabs( "remove", index );

                                        for(var i=0;i<open_pkg_tabs.length;i++){
                                            var resource_editor = open_pkg_tabs[i];
                                            if(resource_editor.id == pkg.id){
                                                open_pkg_tabs.splice(i,1);
                                                break;
                                            }
                                        }
                                        for(i=0;i<available_packages.length;i++){
                                           if(available_packages[i].id == pkg.id){
                                               available_packages.splice(i,1);
                                               break;
                                           }
                                       }
                                   $("#"+tabContentId).remove();
                                });

                                appletBuilder.makePkgTabArgs = null;
                                $.ajax({
                                    type:'POST',
                                    data:{"id":pkg.id},
                                    url:'show-package.jsp',
                                    success:function(data){
                                        //current_package.panel = ui.panel;
                                        
                                        //$( ui.panel ).append(data);
                                        $("<div id=\""+tabContentId+"\"></div>").appendTo("#phyzixlabs-system-package-tab");
                                        ui.panel.panel = $("#phyzixlabs-system-package-tab div:last-child");
                                        
                                        current_package.panel = ui.panel.panel;
                                        $(ui.panel.panel).html(data);
                                        $tabs.tabs('select',ui.index);
                                    }
                                }); 
                        }
                        else
                        if(appletBuilder.nodeClicked == "phyzixlabs-system-user-root"){
                            $(ui.panel).css({"margin":"0","padding":0});
                            $( "#remove-phyzixlabs-system-user-root" ).click(function() {
                                  var index = $( "li", $tabs ).index( $( this ).parent() );
                                  $tabs.tabs( "remove", index );
                                  appletBuilder.userManagerTabOpen = false;
                                  $("#phyzixlabs-system-user-tab").empty();
                            });
                            
                            $.ajax({
                                type:'POST',
                                url:'manage-users.jsp',
                                success:function(data){
                                    //$( ui.panel ).append(data);
                                    uipanel.panel = $("#phyzixlabs-system-user-tab");
                                    $(uipanel.panel).html(data);
                                    $tabs.tabs('select',ui.index);
                                    appletBuilder.loadUsers();
                                }
                            });
                        }
                        else
                        if(appletBuilder.nodeClicked == "phyzixlabs-system-settings-root"){
                            $(ui.panel).css({"margin":"0","padding":0});
                            $( "#remove-phyzixlabs-system-settings-root" ).click(function() {
                                  var index = $( "li", $tabs ).index( $( this ).parent() );
                                  $tabs.tabs( "remove", index );
                                  appletBuilder.systemManagerTabOpen = false;
                                  $("#phyzixlabs-system-settings-tab").empty();
                            });
                            
                            $.ajax({
                                type:'POST',
                                url:'system-settings.jsp',
                                success:function(data){
                                    //$( ui.panel ).append(data);
                                    //alert(data)
                                    ui.panel.panel = $("#phyzixlabs-system-settings-tab");
                                    $("#phyzixlabs-system-settings-tab").html(data);
                                    $tabs.tabs('select',ui.index);                                    
                                }
                            });
                        }
                        else{
                            //$tabs.tabs('select',ui.index);
                        }
		    },
		    show: function(event, ui) {
                        appletBuilder.currentTab = ui.panel;
                        return;
                        //_this.appLayout.resizeAll("north");
                        /*if(ui.index == 0){
                            if(typeof appletBuilder.default_tab_width == "undefined")
                                appletBuilder.default_tab_width = $('#tabs').css("width");
                            else
                            if($("#width-marker").width() > appletBuilder.default_tab_width)
                                appletBuilder.default_tab_width = $('#width-marker').css("width");
                            
                            $('#tabs').css("width",appletBuilder.default_tab_width);
                        }else{                        
                            for(var i=0;i<open_resources.length;i++){
                                    var resource_editor = open_resources[i];
                                    if($(ui.panel).find("#"+resource_editor.id+"-editor").length>0){
                                        $('#tabs').css("width",$(resource_editor.editor.getScrollerElement()).width()+6);
                                        //alert($(resource_editor.editor.getScrollerElement()).width());
                                    }else{
                                        //alert(resource_editor.id)
                                    }
                            }        
                        }*/
                        //load function to close selected tabs
                        //appletBuilder.removetab($(this), ui.index);
		    }
                });





                    $("#applet-treecontrol").dynatree({
                          imagePath: "./",
                          rootVisible:false,
                          minExpandLevel:2,
                          initAjax: {url: "work-bench.jsp"},
                          onActivate: function(dtnode) {
                              
                          },
                          onDeactivate: function(dtnode) {

                          },
                          onRender:function(dtnode,el){
                              //log('render:'+$(el).attr('class')+' type:'+dtnode.data.type)
                              //appletBuilder.doContextMenuBinding(dtnode.data.type,el.getElementsByTagName('a')[0])
                          },
                          onClick: function(dtnode, event) {
                            // Eat keyboard events, while a menu is open
                            //if( $(".contextMenu:visible").length > 0 )
                            //  return false;


                            if(dtnode.data.type == 'phyzixlabs-resource-file'
                               || dtnode.data.type == 'phyzixlabs-applet-code'
                               || dtnode.data.type == 'phyzixlabs-system-toxonomy'){
                                    appletBuilder.openEditor(dtnode);
                             }
                             else
                             if(dtnode.data.type == 'phyzixlabs-system-package'){
                                appletBuilder.openPackageTab(dtnode);
                             }                   
                             else
                             if(dtnode.data.type == 'phyzixlabs-system-user-root'){
                                appletBuilder.openUserTab(dtnode);
                             }
                             else
                             if(dtnode.data.type == 'phyzixlabs-system-settings-root'){
                                appletBuilder.openSystemTab(dtnode);
                             }
                             return true;
                          },
                          onKeydown: function(dtnode, event) {
                            // Eat keyboard events, when a menu is open
                            if( $(".contextMenu:visible").length > 0 )
                              return false;

                            /*switch( event.which ) {

                                    // Open context menu on [Space] key (simulate right click)
                                    case 32: // [Space]
                                      $(dtnode.span).trigger("mousedown", {
                                        preventDefault: true,
                                        button: 2
                                        })
                                      .trigger("mouseup", {
                                        preventDefault: true,
                                        pageX: dtnode.span.offsetLeft,
                                        pageY: dtnode.span.offsetTop,
                                        button: 2
                                        });
                                      return false;

                                    // Handle Ctrl-C, -X and -V
                                    case 67:
                                      if( event.ctrlKey ) { // Ctrl-C
                                        copyPaste("copy", dtnode);
                                        return false;
                                      }
                                      break;
                                    case 86:
                                      if( event.ctrlKey ) { // Ctrl-V
                                        copyPaste("paste", dtnode);
                                        return false;
                                      }
                                      break;
                                    case 88:
                                      if( event.ctrlKey ) { // Ctrl-X
                                        copyPaste("cut", dtnode);
                                        return false;
                                      }
                                      break;
                            }*/
                          }/*,
                          onExpand:function(status,dtnode){
                            //appletBuilder.bindAllContextMenus();
                          }*/,
                          onPostInit:function(isReloading, isError){
                              // Add context menu handler to tree nodes
                              $.unblockUI();
                          },
                          onLazyRead:function(node){
                              var data = null;
                              var url  = null;
                              if(node.data.type == 'phyzixlabs-resource-dir' || node.data.type == 'phyzixlabs-resource-root' || node.data.type == 'phyzixlabs-applet-reviewqueue-resource-root'){
                                  //alert(node.data.uuid+"/"+node.data.relPath)
                                  data = {"widgetid": node.data.widget_id,
                                          "uuid": node.data.uuid,
                                          "relPath":node.data.relPath,
                                          "mode": "all",
                                          "type": node.data.type 
                                          };
                                  url = 'get-resource-node.jsp';
                              }
                              else
                              if(node.data.type == 'phyzixlabs-applet-category' || node.data.type == 'phyzixlabs-system-applet-category'){
                                  //alert(node.data.id)
                                  data = {
                                          "category_id":node.data.id,
                                          "type":node.data.type,
                                          "mode": "all"
                                         };
                                  url = 'get-category-node.jsp';
                              }
                              else
                              if(node.data.type == 'phyzixlabs-applet-reviewqueue'){
                                  //alert(node.data.id)
                                  data = {
                                          "category_id":node.data.id,
                                          "type":node.data.type,
                                          "mode": "all"
                                         };
                                  url = 'get-review-node.jsp';
                              }
                              else
                              if(node.data.type == 'phyzixlabs-applet-list-submitted'){
                                  //alert(node.data.id)
                                  data = {
                                          "category_id":node.data.id,
                                          "type":node.data.type,
                                          "mode": "all"
                                         };
                                  url = 'get-review-node.jsp';
                              }
                              else
                              if(node.data.type == 'phyzixlabs-applet-list-rejected'){
                                  //alert(node.data.id)
                                  data = {
                                          "category_id":node.data.id,
                                          "type":node.data.type,
                                          "mode": "all"
                                         };
                                  url = 'get-review-node.jsp';
                              }
                              else
                              if(node.data.type == 'phyzixlabs-applet-list-prod'){
                                  //alert(node.data.id)
                                  data = {
                                          "category_id":node.data.id,
                                          "type":node.data.type,
                                          "mode": "all"
                                         };
                                  url = 'get-review-node.jsp';
                              }
                              else
                              if(node.data.type == 'phyzixlabs-deployed-system-applet-category-root'||node.data.type == 'phyzixlabs-deployed-system-applet-category'){
                                  //alert(node.data.id)

                                  if( typeof(node.data.id) != "undefined"){
                                      data = {
                                              "category_id":node.data.id,
                                              "type":node.data.type,
                                              "mode": "all"
                                             };
                                  }else{
                                      data = {
                                              "type":node.data.type,
                                              "mode": "all"
                                             };
                                  }

                                  url = 'get-deployed-category-node.jsp';
                              }else
                              if(node.data.type == 'phyzixlabs-system-library-root' || node.data.type == 'phyzixlabs-system-library-dir'){
                                  //alert(node.data.relPath)
                                  data = {
                                          "mode": "all",
                                          "relPath":node.data.relPath
                                         };
                                  url = 'get-library-node.jsp';
                              }else
                              if(node.data.type == 'phyzixlabs-system-package-root'){
                                  //alert(node.data.relPath)
                                  data = {
                                          "mode": "all"
                                         };
                                  url = '/WidgetIDEAction.do?action=load-package-tree';
                              }
                              node.appendAjax({url:url,
                                   data: data,
                                   // (Optional) use JSONP to allow cross-site-requests
                                   // (must be supported by the server):
        //                         dataType: "jsonp",
                                   success: function(node) {
                                       
                                       // Called after nodes have been created and the waiting icon was removed.
                                       // 'this' is the options for this Ajax request
                                       },
                                   error: function(node, XMLHttpRequest, textStatus, errorThrown) {
                                       
                                       // Called on error, after error icon was created.
                                       },
                                   cache: false // Append random '_' argument to url to prevent caching.
                              });
                          },
                          dnd:
                              {

                              onDragStart: function(node) {
                                /** This function MUST be defined to enable dragging for the tree.
                                 *  Return false to cancel dragging of node.
                                 */
                                //logMsg("tree.onDragStart(%o)", node);
                                //return true;
                                //alert('alert')
                                
                                if(node.data.type == 'phyzixlabs-resource-dir' ||node.data.type == 'phyzixlabs-resource-file' || node.data.type == 'phyzixlabs-applet-category' || node.data.type == 'phyzixlabs-applet'){
                                    //log('draging...')
                                    return true;
                                }
                                else
                                    return false;
                                  //log('draging...')
                                  return true;
                              },
                              onDragStop: function(node) {
                                // This function is optional.
                                //logMsg("tree.onDragStop(%o)", node);
                              },
                              autoExpandMS: 1000,
                              preventVoidMoves: true, // Prevent dropping nodes 'before self', etc.
                              onDragEnter: function(node, sourceNode) {
                                /** sourceNode may be null for non-dynatree droppables.
                                 *  Return false to disallow dropping on node. In this case
                                 *  onDragOver and onDragLeave are not called.
                                 *  Return 'over', 'before, or 'after' to force a hitMode.
                                 *  Return ['before', 'after'] to restrict available hitModes.
                                 *  Any other return value will calc the hitMode from the cursor position.
                                 */
                                //logMsg("tree.onDragEnter(%o, %o)", node, sourceNode);
                                // Prevent dropping a parent below it's own child
                        //                if(node.isDescendantOf(sourceNode))
                        //                    return false;
                                // Prevent dropping a parent below another parent (only sort
                                // nodes under the same parent)
                        //                if(node.parent !== sourceNode.parent)
                        //                    return false;
                        //              if(node === sourceNode)
                        //                  return false;
                                // Don't allow dropping *over* a node (would create a child)
                        //        return ["before", "after"];
                                
                                if(node.data.type == 'phyzixlabs-resource-dir'){
                                    //return (sourceNode.data.type == 'phyzixlabs-resource-dir' || sourceNode.data.type == 'phyzixlabs-resource-file')
                                    if(sourceNode.data.type == 'phyzixlabs-resource-dir' || sourceNode.data.type == 'phyzixlabs-resource-file')
                                    {                                      
                                      return ["over"];
                                    }
                                }
                                else
                                if(node.data.type == 'phyzixlabs-resource-root'){
                                    //return (sourceNode.data.type == 'phyzixlabs-resource-dir' || sourceNode.data.type == 'phyzixlabs-resource-file');
                                    if(sourceNode.data.type == 'phyzixlabs-resource-dir' || sourceNode.data.type == 'phyzixlabs-resource-file')
                                    {
                                      return ["over"];
                                    }
                                }
                                else
                                if(node.data.type == 'phyzixlabs-applet-category'){
                                   // return (sourceNode.data.type == 'phyzixlabs-applet' || sourceNode.data.type == 'phyzixlabs-applet-category');
                                    if(sourceNode.data.type == 'phyzixlabs-applet' || sourceNode.data.type == 'phyzixlabs-applet-category')
                                    {
                                      return ["over"];
                                    }
                                }
                                else
                                if(node.data.type == 'phyzixlabs-system-applet-category'){                                   
                                    if(sourceNode.data.type == 'phyzixlabs-applet')
                                    {
                                      return ["over"];
                                    }
                                }
                                return false;
                              },
                              onDragOver: function(node, sourceNode, hitMode) {
                                /** Return false to disallow dropping this node.
                                 *
                                 */
                                //logMsg("tree.onDragOver(%o, %o, %o)", node, sourceNode, hitMode);
                                // Prohibit creating childs in non-folders (only sorting allowed)
                        //        if( !node.isFolder && hitMode == "over" )
                        //          return "after";
                              },
                              onDrop: function(node, sourceNode, hitMode, ui, draggable) {
                                /** This function MUST be defined to enable dropping of items on
                                 * the tree.
                                 */
                                
                                //logMsg("tree.onDrop(%o, %o, %s)", node, sourceNode, hitMode);
                                sourceNode.move(node, hitMode);
                                // expand the drop target
                                node.expand(true);

                                if(sourceNode.data.type == 'phyzixlabs-applet-category'){
                                    $.ajax({
                                        type:'POST',
                                        data:{category_id:sourceNode.data.id,to_parent_id:node.data.id},
                                        url:'/WidgetIDEAction.do?action=move-applet-category',
                                        success:function(data){

                                        }
                                    });
                                }
                                else
                                if(sourceNode.data.type == 'phyzixlabs-applet'){
                                     $.ajax({
                                        type:'POST',
                                        data:{widgetid:sourceNode.data.widget_id,env:sourceNode.data.env,dev_toxonomy:node.data.id},
                                        url:'/WidgetAction.do?action=move-applet',
                                        success:function(data){

                                            reply = eval('('+data+')');
                                        }
                                    });
                                }
                                else
                                if(sourceNode.data.type == 'phyzixlabs-resource-file' || sourceNode.data.type == 'phyzixlabs-resource-dir'){
                                     $.ajax({
                                        type:'POST',
                                        data:{widgetid:sourceNode.data.widget_id,towidgetid:node.data.widget_id,uuid:sourceNode.data.uuid,touuid:node.data.uuid,fromRelPath:sourceNode.data.relPath,toRelPath:node.data.relPath,env:sourceNode.data.env},
                                        url:'/WidgetResourceAction.do?action=move-applet-resource',
                                        success:function(data){
                                            
                                            reply = eval('('+data+')');
                                            if(reply.status == 'success'){
                                                sourceNode.data.relPath = reply.relPath;
                                                sourceNode.data.widget_id = node.data.widget_id;
                                            }
                                        }
                                    });
                                }
                              },
                              onDragLeave: function(node, sourceNode) {
                                /** Always called if onDragEnter was called.
                                 */
                                //logMsg("tree.onDragLeave(%o, %o)", node, sourceNode);
                              }
                          }
                 });


                  $('#new-widget-dialog').dialog({
                        autoOpen: false,
                        width: 450,
                        height:320,
                        buttons: {
                            "Ok": function() {

                                    if(appletBuilder.validateAddWidget()){

                                        var dtnode = $(this).data("dtnode");
                                        $('#new-widget-dialog').dialog("close");

                                        var part = widgetaction=='add-widget'?'Adding <span style="font-weight:bold;font-style:italic;color:gray">'+$('#widgetName').attr('value')+'</span>':'Saving <span style="font-weight:bold;font-style:italic;color:gray">'+$('#widgetName').attr('value')+'</span>';

                                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" />'+part+',please wait...</h1>'});

                                        $.ajax({
                                            type:'POST',
                                            data:
                                                {
                                                  widgetid:$('#widgetId').attr('value'),
                                                  name:$('#widgetName').attr('value'),
                                                  description:$('#widgetDescription').attr('value'),
                                                  category:$('#widgetCategory').attr('value'),
                                                  show_in_menu:$('#showInMenu').is(':checked')?'No':'Yes',
                                                  tags:$('#widgetTags').attr('value'),
                                                  price:$('#widgetPrice').attr('value'),
                                                  catalog_page_index:$('#widgetCatalogPageIndex').attr('value'),
                                                  author_name:$('#widgetAuthorName').attr('value'),
                                                  author_link:$('#widgetAuthorLink').attr('value'),
                                                  version:$('#widgetVersion').attr('value'),
                                                  env:$('#curWidgetEnv').attr("value"),
                                                  dev_toxonomy: (widgetaction=='add-widget')?dtnode.data.id:dtnode.data.toxonomy_id
                                                },
                                            url:'/WidgetAction.do?action='+widgetaction,
                                            success:function(data){
                                                $.unblockUI();
                                                var reply = eval('('+data+')');

                                                if(widgetaction=='add-widget'){
                                                    if(reply.status=='failed'){
                                                        alert('There was a problem creating App');
                                                    }else{

                                                       //dtnode.reloadChildren();
                                                       
                                                       var appletNode = {isFolder:true,addClass:'phyzixlabs-applet',key:'rootdev'+reply.widgetid,widget_id:reply.widgetid,title:$('#widgetName').attr('value'),env:'dev',type:'phyzixlabs-applet'};
                                                       var appletCodeNode = {isFolder:false,addClass:'phyzixlabs-applet-code',key:'dev'+reply.widgetid,widget_id:reply.widgetid,title:'APP',realTitle:$('#widgetName').attr('value'),env:'dev',type:'phyzixlabs-applet-code'};
                                                       var appletResourceNode  = {isFolder:true,addClass:'phyzixlabs-resource-root',widget_id:reply.widgetid,isLazy:true,title:'Resources',relPath:'',type:'phyzixlabs-resource-root'};
                                                       
                                                       var newNode = dtnode.addChild(appletNode);
                                                       newNode.addChild(appletCodeNode).activate();
                                                       newNode.addChild(appletResourceNode);

                                                        $('#widgetCategory').val('2f659fd0-12e8-11e0-a792-0019b958a435');
                                                       //$("#applet-treecontrol").dynatree("getTree").getNodeByKey(appletCodeNode.key).activate();
                                                    }
                                                }else{
                                                    $('#widgetCategory').val('2f659fd0-12e8-11e0-a792-0019b958a435');
                                                    dtnode.data.title = $('#widgetName').attr('value');
                                                    dtnode.render();
                                                   //widgetNode = $("#widget-treecontrol").dynatree('getTree').getNodeByKey(reply.widgetid);
                                                }
                                            }
                                        });
                                    }
                            },
                            "Cancel": function() {
                                $('#new-widget-dialog').dialog("close");
                            }
                        }
                  });



                    $('#back-end-error-dialog').dialog({
                            autoOpen: false,
                            width: 750,
                            modal:true
                      });     


                  /*  */
    
                  
     


                  /*
                  $("#widget-lib-list").jqGrid({url:'get-libraries.jsp',
                      datatype: "xml",
                      postData:{widgetid:0,env:'dev'},
                      treeGrid: true,
                      treeGridModel: 'adjacency',
                      ExpandColumn : 'file_name',
                      colNames:['id','File Name','Size (bytes)','Path','Date', ''],
                      colModel:[
                                 {name:'id',index:'id', width:1,hidden:true,key:true},
                                 {name:'file_name',index:'file_name', width:256},
                                 {name:'size',index:'size', width:128, align:"right"},
                                 {name:'path',index:'path', width:0,hidden:true},
                                 {name:'create_date',index:'create_date', width:80,align:"right"},
                                 {name:'del_act',index:'del_act', width:150, sortable:false}],
                      rowNum:-1,
                      rowList:[],
                      pager: $('#widget-lib-list-pager'),
                      sortname: 'id',
                      viewrecords: true,
                      autowidth: true,
                      sortorder: "desc",
                      caption:"Library"}).navGrid('#widget-lib-list-pager',{edit:false,add:false,del:false});
                      */





                  $('#add-lib-dialog').dialog({
                        autoOpen: false,
                        width: 450,
                        height:128,
                        buttons: {
                            "Ok": function() {
                                current_tree_node = $(this).data("dtnode");
                                $('#add-lib-dialog').dialog("close");
                                //colabopad.clbDialog = true;
                                //window.frames['loadCLBInterface'].loadCLB();
                                //var dtnode = $("#widget-treecontrol").dynatree("getActiveNode");
                                //$('#addLibraryInterface').contents().find('[name=widgetid]').attr("value",dtnode.data.widget_id);
                                //$('#addLibraryInterface').contents().find('[name=env]').attr("value",dtnode.data.env);
                                $('#addLibraryInterface').contents().find('[name=libraryposter]').submit();
                            },
                            "Cancel": function() {
                                $('#add-lib-dialog').dialog("close");
                            }
                        }
                  });

                  /***
                  $('#add-lib-btn').click(function(){
                      $('#add-lib-dialog').dialog("open");
                  });**/






                  $("#widget-resource-list").jqGrid({url:'get-resources.jsp',///WidgetResourceAction.do?action=get-widget-resources
                              datatype: "xml",
                              postData:{widgetid:0,env:'dev'},
                              treeGrid: true,
                              treeGridModel: 'adjacency',
                              ExpandColumn : 'file_name',
                              colNames:['id', 'File Name','Label','Data Type', 'MIME Type','Size (bytes)','Creation Date','Last Modification Date','...'],
                              colModel:[
                                         {name:'id',index:'id', width:1,hidden:true,key:true},
                                         {name:'file_name',index:'file_name', width:90},
                                         {name:'label',index:'label', width:55},
                                         {name:'data_type',index:'data_type', width:100},
                                         {name:'mime_type',index:'mime_type', width:80, align:"right"},
                                         {name:'size',index:'size', width:80, align:"right"},
                                         {name:'create_date',index:'create_date', width:80,align:"right"},
                                         {name:'lst_mod_date',index:'lst_mod_date', width:150, sortable:false},
                                         {name:'del_act',index:'del_act', width:150, sortable:false}],
                              rowNum:-1,
                              rowList:[],
                              /*imgpath: gridimgpath,*/
                              pager: $('#widget-resource-list-pager'),
                              sortname: 'id',
                              viewrecords: true,
                              autowidth: true,
                              sortorder: "desc",
                              caption:"Resources"}).navGrid('#widget-resource-list-pager',{edit:false,add:false,del:false});



                  $('#add-resource-dialog').dialog({
                        autoOpen: false,
                        width: 450,
                        height:250,
                        buttons: {
                            "Add": function() {
                                current_tree_node = $(this).data("dtnode");
                                $('#add-resource-dialog').dialog("close");
                                //colabopad.clbDialog = true;
                                //window.frames['loadCLBInterface'].loadCLB();
                                var dtnode = $(this).data("dtnode");//$("#widget-treecontrol").dynatree("getActiveNode");
                                $('#addResourceInterface').contents().find('[name=widgetid]').attr("value",dtnode.data.widget_id);
                                $('#addResourceInterface').contents().find('[name=uuid]').attr("value",dtnode.data.uuid);
                                $('#addResourceInterface').contents().find('[name=relPath]').attr("value",dtnode.data.relPath);
                                //$('#addResourceInterface').contents().find('[name=env]').attr("value",dtnode.data.env);
                                $('#addResourceInterface').contents().find('[name=resourceposter]').submit();
                            },
                            "Cancel": function() {
                                $('#add-resource-dialog').dialog("close");
                            }
                        }
                  });

                  /*
                  $("#applet-package-list").jqGrid({url:'get-packages.jsp',
                      datatype: "xml",
                      postData:{},
                      treeGrid: true,
                      treeGridModel: 'adjacency',
                      ExpandColumn : 'name',
                      colNames:['id','','', '','', ''],
                      colModel:[
                                 {name:'id',index:'id', width:1,hidden:true,key:true},
                                 {name:'name',index:'name', width:256, sortable:false},
                                 {name:'category',index:'category', align:"center",hidden:false, sortable:false},
                                 {name:'install',index:'install',align:"center", hidden:false, sortable:false},
                                 {name:'uninstall',index:'uninstall',align:"center",hidden:false, sortable:false},
                                 {name:'del_act',index:'del_act', width:150, sortable:false}],
                      rowNum:-1,
                      rowList:[],
                      loadComplete:function(data){
                            $.ajax({
                                type:'POST',
                                url:'/WidgetIDEAction.do?action=load-packages',
                                success:function(data){
                                    available_packages = eval('('+data+')');
                                    for(var i=0;i<available_packages.length;i++){
                                        $('#appletCategory-'+available_packages[i].id).attr("onchange","appletBuilder.setPackageCategory('"+available_packages[i].id+"')");
                                        //alert( '#appletCategory-'+available_packages[i].id)
                                        //$('#appletCategory-'+available_packages[i].id).change(function(){
                                        //    alert('test')
                                        //});
                                    }
                                }
                            });
                      },
                      pager: $('#applet-package-list-pager'),
                      sortname: 'id',
                      viewrecords: true,
                      height:'auto',
                      autowidth: true,
                      sortorder: "desc",
                      caption:"Available Packages"}).navGrid('#applet-package-list-pager',{edit:false,add:false,del:false,search:false});
                      */
                  $('#upload-package-dialog').dialog({
                        autoOpen: false,
                        width: 450,
                        height:150,
                        buttons: {
                            "Upload": function() {
                                current_tree_node = $(this).data("dtnode");
                                $('#upload-package-dialog').dialog("close");
                                $('#uploadPackageInterface').contents().find('[name=packageposter]').submit();
                            },
                            "Cancel": function() {
                                $('#upload-package-dialog').dialog("close");
                            }
                        }
                  });

                  $('#import-package-dialog').dialog({
                        autoOpen: false,
                        width: 450,
                        height:150,
                        buttons: {
                            "Import": function() {
                                var dtnode = $(this).data("dtnode");
                                current_tree_node = $(this).data("dtnode");
                                $('#import-package-dialog').dialog("close");
                                $('#importPackageInterface').contents().find('[name=category_id]').attr("value",dtnode.data.id);
                                $('#importPackageInterface').contents().find('[name=packageimportposter]').submit();
                            },
                            "Cancel": function() {
                                $('#import-package-dialog').dialog("close");
                            }
                        }
                  });


                  $('#widget-rejected-reason-dialog').dialog({
                        autoOpen: false,
                        width:450,
                        height:250,
                        buttons: {
                            "Ok": function() {
                                $('#widget-rejected-reason-dialog').dialog("close");

                                $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" /> Please wait...</h1>'});
                                $.ajax({
                                    type:'POST',
                                    data:{widgetid:_this.currentNode.data.widget_id,env:_this.currentNode.data.env,reason:$('#widget-rejected-reason').attr("value")},
                                    url:'/WidgetIDEAction.do?action=reject-widget',
                                    success:function(data){
                                        $.unblockUI();
                                        _this.currentNode.remove();
                                        
                                        /*
                                        rootNode = $("#widget-treecontrol").dynatree('getTree').getNodeByKey('rejectedWidgetHeaderNode');
                                        newnode = {isFolder:false,addClass:'rejectedwidgetnode',key:'rejected'+rejecteddtnode.data.widget_id,widget_id:rejecteddtnode.data.widget_id,title:rejecteddtnode.data.title,env:'rejected',type:'wnode'};
                                        rootNode.append(newnode);
                                        appletBuilder.bindRejectedWidgetContextMenu();

                                        rejecteddtnode.remove();
                                         $("#widget-resource-list").setGridParam({postData:{widgetid:rejecteddtnode.data.widget_id,env:rejecteddtnode.data.env}}).trigger("reloadGrid");
                                         code_editor.setCode('');
                                        */
                                    }
                                });
                            },
                            "Cancel": function() {
                                $('#widget-rejected-reason-dialog').dialog("close");
                            }
                        }
                  });

                  $('#package-widget-dialog').dialog({
                        autoOpen: false,
                        width: 800,
                        height:500,
                        buttons: {
                            "Package": function() {
                                $('#package-widget-dialog').dialog("close");
                                if($('#applet_package_name').val() != ''){
                                    var lines = [];
                                    for(var i=0;i<_this.widgets_for_packaging.length;i++){
                                        var widget = _this.widgets_for_packaging[i];
                                        for(var j=0;j<widget.dependencies.length;j++){
                                            var line = widget.widget_id+','+widget.dependencies[j].dependency_id+','+widget.dependencies[j].dependency_path;
                                            //alert('line:'+line)
                                            lines.push(line);
                                        }
                                        //no dependency
                                        if(widget.dependencies.length == 0)
                                            lines.push(widget.widget_id);
                                    }


                                    //get selected packages
                                    var package_candidates = [];
                                    for(i=0;i<_this.selected_widgets_for_packaging.length;i++)
                                        package_candidates.push(_this.selected_widgets_for_packaging[i].widget_id);


                                    $.blockUI({css:{},overlayCSS: { backgroundColor: '#666666',opacity:.2 },theme:true,message: '<h1><img src="../../img/busy.gif" />Creating package,please wait...</h1>'});
                                    window.frames['packageInterface'].package_applets(package_candidates.join('#'),lines.join('#'),
                                    $('#applet_package_name').val(),
                                    $('#applet_package_version').val(),
                                    $('#applet_package_description').val(),
                                    $('#applet_package_license').val(),
                                    $('#applet_package_domain').val(),
                                    null,
                                    $('#ebook_package_export').is(':checked')?"yes":"no");

                                }else{
                                    alert('Please provide a name for the package.')
                                }
                            },
                            "Cancel": function() {
                                $('#package-widget-dialog').dialog("close");
                            }
                        }
                  });

                  $("#package-widget-list").jqGrid({url:'get-widgets.jsp',
                      datatype: "xml",
                      postData:{widgetid:0,env:'dev'},
                      colNames:['','Select','Select apps for packaging...'],
                      colModel:[
                                 {name:'id',index:'id', width:1,hidden:true,key:true},
                                 {name:'del_act',index:'del_act', width:25, sortable:false,hidden:true},
                                 {name:'name',index:'name', width:246,align:'left'}
                                 ],
                      rowNum:-1,
                      rowList:[],
                      pager: $('#package-widget-list-pager'),
                      sortname: 'id',
                      viewrecords: false,
                      pgbuttons:false,
                      pginput:false,
                      autowidth: true,
                      height:296,
                      sortorder: "desc",
                      loadComplete:function(data){
                            $('.selectlibraryentry').attr("disabled","disabled");
                            var ids = $("#package-widget-list").getDataIDs().join(',');
                            //alert(ids)
                            if(ids.length>0){
                                $.ajax({
                                    type:'POST',
                                    data:{
                                          ids:ids
                                        },
                                    url:'/WidgetAction.do?action=get-widget-dependency-set',
                                    success:function(data){
                                        //alert(data)
                                        _this.widgets_for_packaging = eval('('+data+')');
                                        //alert(widgets_for_packaging.length)
                                    }
                                });
                            }
                      },
                      onSelectRow:function(rowid){
                        $('.selectlibraryentry').removeAttr("disabled");
                        for(var i=0;i<_this.widgets_for_packaging.length;i++){
                            if(_this.widgets_for_packaging[i].widget_id == rowid){
                                _this.current_widget_to_package = _this.widgets_for_packaging[i];
                                break;
                            }
                        }

                        //clear
                        $("#package-widget-dependency-list").resetSelection();
                        $('.selectlibraryentry').removeAttr("checked");

                        //set new selection
                        var deps = _this.current_widget_to_package.dependencies;
                        for(i=0;i<deps.length;i++){
                            $('input[name=selectlibraryentry-'+deps[i].dependency_id+']').attr("checked","checked");
                        }
                      },
                      caption:"Available Apps"}).navGrid('#package-widget-list-pager',{edit:false,add:false,del:false,search:false});


                  $("#package-widget-dependency-list").jqGrid({url:'get-libraries.jsp',
                  datatype: "xml",
                  postData:{widgetid:0,env:'dev'},
                  treeGrid: true,
                  treeGridModel: 'adjacency',
                  ExpandColumn : 'file_name',
                  colNames:['id','Select dependencies you wish to include...','Path', 'Size (bytes)','Date', ''],
                  colModel:[
                             {name:'id',index:'id', width:1,hidden:true,key:true},
                             {name:'file_name',index:'file_name', width:500,align:'left'},
                             {name:'size',index:'size', width:0, align:"right",hidden:true},
                             {name:'path',index:'path', width:0,hidden:true},
                             {name:'create_date',index:'create_date', width:80,align:"right",hidden:true},
                             {name:'del_act',index:'del_act', width:25, sortable:false,hidden:true}],
                  rowNum:-1,
                  rowList:[],
                  pager: $('#package-widget-dependency-list-pager'),
                  sortname: 'id',
                  viewrecords: false,
                  pgbuttons:false,
                  pginput:false,
                  autowidth: true,
                  height:110,
                  sortorder: "desc",
                  caption:"Available Dependencies"}).navGrid('#package-widget-dependency-list-pager',{edit:false,add:false,del:false,search:false});

                  /*
                  $('#new-widget-btn').click(function(){

                  });
                  */
                  /*
                  $('#add-resource-btn').click(function(){
                      $('#add-resource-dialog').dialog("open");
                  });*/

                  /*
                  $('#upload-package-btn').click(function(){
                      $('#upload-package-dialog').dialog("open");
                  });
                  */

                  /*
                  $('#package-widget-btn').click(function(){
                      $('#package-widget-dialog').dialog("open");
                      select_widgets_for_packaging = [];
                      $("#package-widget-list").trigger("reloadGrid");
                      $("#package-widget-dependency-list").trigger("reloadGrid");
                  });
                  */

                  /***
                  $('#save-widget-code-btn').click(function(){
                        $.blockUI({css:{},overlayCSS: { backgroundColor: '#666666',opacity:.2 },theme:true,message: '<h1><img src="../../img/busy.gif" />Saving widget code,pleasing wait...</h1>'});
                        $.ajax({
                            type:'POST',
                            data:{
                                  widgetid:$('#widgetCodeWidgetId').attr('value'),
                                  code:code_editor.getCode(),
                                  env:$('#widgetCodeEnv').attr('value')
                                },
                            url:'/WidgetAction.do?action=save-widget-code',
                            success:function(data){
                                $.unblockUI();
                            }
                        });
                  });
                  ***/


                $.ajax({
                    type:'POST',
                    data:{},
                    url:'/WidgetIDEAction.do?action=get-widget-menu-structure-html',
                    success:function(data){
                        $('#widgetCategory-holder').html(data);
                    }
                });


                  $('#new-applet-resource-dialog').dialog({
                        autoOpen: false,
                        width: 256,
                        height:128,
                        buttons: {
                            "Create": function() {
                                if(appletBuilder.validateFileName($('#new-applet-resource-name').val())){
                                    $('#new-applet-resource-dialog').dialog("close");
                                    if(selected_context_menu_action != 'rename')
                                        appletBuilder.newResource($('#new-applet-resource-name').val(),$(this).data("dtnode"));
                                    else
                                        appletBuilder.renameResource($('#new-applet-resource-name').val(),$(this).data("dtnode"));
                                    selected_context_menu_action = '';
                                }
                            },
                            "Cancel": function() {
                                $('#new-applet-resource-dialog').dialog("close");
                                selected_context_menu_action = '';
                            }
                        }
                  });
                  $('#new-applet-category-dialog').dialog({
                        autoOpen: false,
                        width: 256,
                        height:128,
                        buttons: {
                            "Create": function() {
                                if($('#new-applet-category-name').val() != ''){
                                    $('#new-applet-category-dialog').dialog("close");
                                    
                                    if(selected_context_menu_action != 'rename')
                                        appletBuilder.newCategory($('#new-applet-category-name').val(),$(this).data("dtnode"));
                                    else
                                        appletBuilder.updateCategory($('#new-applet-category-name').val(),$(this).data("dtnode"));
                                    selected_context_menu_action = '';
                                }else{
                                    alert('Please enter a category name')
                                }
                            },
                            "Cancel": function() {
                                selected_context_menu_action = '';
                                $('#new-applet-category-dialog').dialog("close");
                                
                            }
                        }
                  });


                  $('#load-users-dialog').dialog({
                        autoOpen: false,
                        modal:true,
                        width: 420,
                        height:236,
                        buttons: {
                            "Load": function() {
                                $('#load-users-dialog').dialog("close");

                                $('#sysloadUsersInterface').contents().find('[name=userdataposter]').submit();
                            },
                            "Cancel": function() {
                                $('#load-users-dialog').dialog("close");
                            }
                        }
                  });

                  $('#hadron-help-btn').css("display","inline").button({
			text: false,
			icons: {
				primary: "ui-icon-help"
			}
		})/*.click(function(){
                    appletBuilder.showDevHelp();
                  })*/;
            },
            echeck:function (str) {

		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)
		if (str.indexOf(at)==-1){
		   alert("Invalid E-mail Address")
		   return false
		}

		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		   alert("Invalid E-mail Address")
		   return false
		}

		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
		    alert("Invalid E-mail Address")
		    return false
		}

		 if (str.indexOf(at,(lat+1))!=-1){
		    alert("Invalid E-mail Address")
		    return false
		 }

		 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		    alert("Invalid E-mail Address")
		    return false
		 }

		 if (str.indexOf(dot,(lat+2))==-1){
		    alert("Invalid E-mail Address")
		    return false
		 }

		 if (str.indexOf(" ")!=-1){
		    alert("Invalid E-mail Address")
		    return false
		 }

 		 return true
	},
            removetab :function(tabselector, index) {
                $(".removetab").click(function(){
                    $(tabselector).tabs('remove',index);
                });
            },
            initEditorData:function(editor,data,url){
                //alert(url);
                $.ajax({
                    type:'POST',
                    data:data,
                    dataType:'text',
                    url:url,
                    success:function(data){
                        
                        //$('#widgetCodeEditor').attr("value",data);
                        //alert(data);
                        editor.setValue(data);
                        editor.contentModified = false;
                        //$('#tabs').css("width",$(editor.getScrollerElement()).width()+6);
                        //$("#widget-resource-list").setGridParam({postData:{widgetid:dtnode.data.widget_id,env:dtnode.data.env}}).trigger("reloadGrid");

                        //$('#widgetCodeWidgetId').attr('value',dtnode.data.widget_id);
                        //$('#widgetCodeEnv').attr('value',dtnode.data.env);
                    }
                });
            },
            systemManagerTabOpen:false,
            openSystemTab:function(dtnode){
                if(appletBuilder.systemManagerTabOpen){
                    $('#tabs').tabs('select','#phyzixlabs-system-settings-root');
                    return;
                }

                appletBuilder.nodeClicked = "phyzixlabs-system-settings-root";
                appletBuilder.systemManagerTabOpen = true;
                var tabId = 'phyzixlabs-system-settings-root';
                $('#tabs').tabs("option","tabTemplate","<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close' id='remove-"+tabId+"'>Remove Tab</span></li>");
                $("#tabs").tabs( 'add' ,'#'+tabId ,'System Settings');
            },
            userManagerTabOpen:false,
            openUserTab:function(dtnode){
                if(appletBuilder.userManagerTabOpen){
                    $('#tabs').tabs('select','#phyzixlabs-system-user-root');
                    return;
                }

                appletBuilder.nodeClicked = "phyzixlabs-system-user-root";
                appletBuilder.userManagerTabOpen = true;
                var tabId = 'phyzixlabs-system-user-root';
                $('#tabs').tabs("option","tabTemplate","<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close' id='remove-"+tabId+"'>Remove Tab</span></li>");
                $("#tabs").tabs( 'add' ,'#'+tabId ,'System Users');
            },
            makeEditorArgs:null,
            buildEditor:function(tabId,tabTitle,type,data,url,actype){

                for(var i=0;i<open_resources.length;i++){
                    var resource_editor = open_resources[i];
                    if(resource_editor.id == tabId){
                        $('#tabs').tabs('select',tabId);
                        return;
                    }
                }
                if($("#editor-holder-"+tabId).length>0)
                    $("#editor-holder-"+tabId).remove();
                
                var uipanel = '<div style="background: white;margin-top: 0" id="editor-holder-'+tabId+'"><textarea id="'+tabId+'-editor" ></textarea><div style="clear:both"></div></div>';
                appletBuilder.makeEditorArgs = {actype:actype,tabId:tabId,type:type,data:data,url:url,uipanel:uipanel,toolbar:'<button id="save-'+tabId+'">Save</button>'};
                /*editor = appletBuilder.makeEditor(type, tabId+'-editor', function(){
                    appletBuilder.initEditorData(editor,data,url);
                    $("#tabs").tabs('select',index-1);
                });*/
                //set a custom tab template
                $('#tabs').tabs("option","tabTemplate","<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close' id='remove-"+tabId+"'>Remove Tab</span></li>");
                $("#tabs").tabs( 'add' ,'#'+tabId , tabTitle).tabs('length');
            },
            makePkgTabArgs:null,
            openPackageTab:function(dtnode){

                appletBuilder.makeEditorArgs = null;
                var tabId = 'phyzixlabs-system-package-'+dtnode.data.id;
                for(var i=0;i<open_pkg_tabs.length;i++){
                    if(open_pkg_tabs[i].id == dtnode.data.id){
                        current_package = open_pkg_tabs[i].pkg;
                        //select this tab
                        $('#tabs').tabs('select',tabId);
                        return;
                    }
                }


                $.ajax({
                    type:'POST',
                    data:{"id":dtnode.data.id},
                    url:'/WidgetIDEAction.do?action=load-package',
                    success:function(data){
                        current_package = eval('('+data+')');
                        available_packages.push(current_package);                        

                        appletBuilder.makePkgTabArgs = {id:dtnode.data.id,tabId:tabId,pkg:current_package};
                        open_pkg_tabs.push({id:dtnode.data.id,tabId:tabId});
                        $('#tabs').tabs("option","tabTemplate","<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close' id='remove-"+tabId+"'>Remove Tab</span></li>");
                        $("#tabs").tabs( 'add' ,'#'+tabId , dtnode.data.title);
                    }
                });
            },
            openEditor:function(dtnode){
                
                var tabId = null;
                var data  = null;
                var url   = null;
                if(dtnode.data.type == 'phyzixlabs-applet-code'){
                    tabId = 'phyzixlabs-applet-code'+dtnode.data.widget_id;
                    data  = {widgetid:dtnode.data.widget_id,env:dtnode.data.env,action:'get-widget-code'};
                    url   = '/WidgetAction.do';                    
                    appletBuilder.buildEditor(tabId,dtnode.data.realTitle,'js',data, url,'phyzixlabs-applet-code');
                }
                else
                if(dtnode.data.type == 'phyzixlabs-system-toxonomy'){
                    tabId = 'phyzixlabs-system-toxonomy';
                    data  = {action:'get-widget-menu-structure'};
                    url   = '/WidgetIDEAction.do';
                    appletBuilder.buildEditor(tabId,'Toxonomy','xml',data, url,'phyzixlabs-system-toxonomy');
                }
                else
                if(dtnode.data.type == 'phyzixlabs-resource-file' && dtnode.data.mime != 'none'){
                    tabId = 'phyzixlabs-resource-file'+dtnode.data.id;
                    data  = {widgetid:dtnode.data.widget_id,uuid:dtnode.data.uuid,env:'dev',relPath:dtnode.data.relPath};
                    url   = appletBuilder.get_content_url(dtnode.data.widget_id,'dev',dtnode.data.relPath,dtnode.data.mime,dtnode.data.uuid);
                    appletBuilder.buildEditor(tabId,dtnode.data.title,dtnode.data.mime,data, url,'phyzixlabs-resource-file');
                }
            },
            validateFileName:function(name){
               // if(name.length == 0)return false;
               // if(isAlpha(name[0])
               return true;
            },
            validateAddWidget:function (){
                if(
                    $('#widgetName').attr("value") != '' 
                        && $('#widgetAuthorName').attr("value") != ''
                        && $('#widgetCategory').attr("value") != ''
                        && $('#widgetCategory').attr("value") != '2f659fd0-12e8-11e0-a792-0019b958a435'

                    ){
                    return true;
                }
                alert('Please fill-out all required fields')
                return false;
            },

            get_content_url:function (widget_id,env,path,type,uuid){
                return '/importer/'+env+'-'+uuid+'/'+path+'?widgetid='+widget_id+'&env='+env+'&ts='+(new Date().getTime())+'&mime='+type+'&foredit=true';
            },

            initializeEditor:function (event,ui){

                for(var i=0;i<open_resources.length;i++){
                    var editor = open_resources[i];
                    //alert('init:'+editor.tabindex+","+editor.init)
                    if(editor.tabindex == ui.index && editor.init==false){
                        editor.init = true;
                        editor.editor=makeEditor(editor.args[4],editor.id,function(){
                            appletBuilder.loadResourceItemData(editor.args[0],editor.args[1],editor.args[2],editor.args[3],editor.args[4],editor.editor);
                        })
                        return;
                    }
                }
                //
            },

            replaceAll:function (txt, replace, with_this) {
              return txt.replace(new RegExp(replace, 'g'),with_this);
            },

            editWidget:function (dtnode){
                 $('#widgetId').attr('value',dtnode.data.widget_id);
                 $('#curWidgetEnv').attr('value',dtnode.data.env);

                 widgetaction = "update-widget-info";
                 $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" />Getting widget info,pleasing wait...</h1>'});
                 $.ajax({
                    type:'POST',
                    data:{widgetid:dtnode.data.widget_id,env:dtnode.data.env},
                    url:'/WidgetAction.do?action=get-widget',
                    success:function(data){
                        $.unblockUI();
                        reply = eval('('+data+')');
                        $('#widgetName').attr('value',reply.widget.name);
                        $('#widgetDescription').attr('value',reply.widget.description);
                        $('#widgetCategory').attr('value',reply.widget.category);
                        
                        if(reply.widget.show_in_menu == 'No')
                            $('#showInMenu').attr('checked','checked');
                        else
                            $('#showInMenu').removeAttr('checked');
                        
                        $('#widgetTags').attr('value',reply.widget.tags);
                        $('#widgetAuthorName').attr('value',reply.widget.author_name);
                        $('#widgetAuthorLink').attr('value',reply.widget.author_link);
                        $('#widgetVersion').attr('value',reply.widget.version);
                        $('#widgetVersion').removeAttr('disabled');

                        $('#widgetPrice').attr('value',reply.widget.price);
                        $('#widgetCatalogPageIndex').attr('value',reply.widget.catalog_page_index);


                        $('#new-widget-dialog').data("dtnode",dtnode).dialog("open");
                    }
                });
            },

            deleteWidget:function (dtnode){
                  
                  if(confirm('Are you sure you want to delete this applet?')){
                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" />Deleting widget,pleasing wait...</h1>'});
                        $.ajax({
                            type:'POST',
                            data:{widgetid:dtnode.data.widget_id,env:dtnode.data.env},
                            url:'/WidgetAction.do?action=del-widget',
                            success:function(data){
                                $.unblockUI();
                                var jsonobj = eval('('+data+')');
                                if(jsonobj.status=='success'){
                                   dtnode.remove();

                                }else{
                                    alert('There was a problem removing widget,please try again.\nIf problem persist, please contact support@colabopad.com');
                                }
                            }
                        });
                    }
            },


            undeployApplet:function (dtnode){
                  if(confirm('Are you sure you want to undeploy this App?')){
                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" />Undeploying applet,pleasing wait...</h1>'});
                        $.ajax({
                            type:'POST',
                            data:{type:dtnode.data.type,id:dtnode.data.id,env:dtnode.data.env},
                            url:'/WidgetIDEAction.do?action=undeploy-applets',
                            success:function(data){
                                $.unblockUI();
                                var jsonobj = eval('('+data+')');
                                if(jsonobj.status=='success'){
                                   dtnode.remove();

                                   /*
                                   $('#save-widget-code-btn').attr("disabled", "disabled");
                                   code_editor.setCode('');
                                   $("#widget-resource-list").setGridParam({postData:{widgetid:dtnode.data.widget_id,env:dtnode.data.env}}).trigger("reloadGrid");
                                    */
                                }else{
                                    alert('There was a problem removing applet,please try again.\nIf problem persist, please contact support.');
                                }
                            }
                        });
                    }
            },

            submitWidget:function (dtnode){
                 $('#widgetId').attr('value',dtnode.data.widget_id);
                 widgetaction = "submit-widget-info";
                 $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" />pleasing wait...</h1>'});
                 $.ajax({
                    type:'POST',
                    data:{widgetid:dtnode.data.widget_id},
                    url:'/WidgetIDEAction.do?action=submit-widget',
                    success:function(data){
                        $.unblockUI();
                        reply = eval('('+data+')');
                        if(reply.status == 'failed'){
                            alert(reply.msg);
                        }else{
                            /**
                            rootNode = $("#widget-treecontrol").dynatree('getTree').getNodeByKey('pendingWidgetHeaderNode');
                            newnode = {isFolder:false,addClass:'pendingwidgetnode',key:'pending'+dtnode.data.widget_id,widget_id:dtnode.data.widget_id,title:dtnode.data.title,env:'queue',type:'wnode'};
                            rootNode.append(newnode);
                            appletBuilder.bindPendingWidgetContextMenu();

                            /*
                            <%if(request.isUserInRole("reviewer")){%>

                            rootNode = $("#widget-treecontrol").dynatree('getTree').getNodeByKey('queueWidgetHeaderNode');
                            newnode = {isFolder:false,addClass:'queuewidgetnode',key:'queue'+dtnode.data.widget_id,widget_id:dtnode.data.widget_id,title:dtnode.data.title,env:'queue',type:'wnode'};
                            rootNode.append(newnode);
                            appletBuilder.bindQueueWidgetContextMenu();
                            /*<%}%>
                            
                            $('#save-widget-code-btn').attr("disabled", "disabled");
                            code_editor.setCode('');
                            $("#widget-resource-list").setGridParam({postData:{widgetid:dtnode.data.widget_id,env:dtnode.data.env}}).trigger("reloadGrid");
                            */
                        }
                    }
                });
            },


            reSubmitWidget:function (dtnode){
                 $('#widgetId').attr('value',dtnode.data.widget_id);
                 widgetaction = "resubmit-widget-info";
                 $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" />pleasing wait...</h1>'});
                 $.ajax({
                    type:'POST',
                    data:{widgetid:dtnode.data.widget_id},
                    url:'/WidgetIDEAction.do?action=resubmit-widget',
                    success:function(data){
                        $.unblockUI();
                        reply = eval('('+data+')');
                        if(reply.status == 'failed'){
                            alert(reply.msg);
                        }else{
                            dtnode.remove();
                            rootNode = $("#widget-treecontrol").dynatree('getTree').getNodeByKey('pendingWidgetHeaderNode');
                            newnode = {isFolder:false,addClass:'pendingwidgetnode',key:'pending'+dtnode.data.widget_id,widget_id:dtnode.data.widget_id,title:dtnode.data.title,env:'queue',type:'wnode'};
                            rootNode.append(newnode);
                            appletBuilder.bindPendingWidgetContextMenu();

                            $('#save-widget-code-btn').attr("disabled", "disabled");
                            //code_editor.setCode('');
                            //$("#widget-resource-list").setGridParam({postData:{widgetid:dtnode.data.widget_id,env:dtnode.data.env}}).trigger("reloadGrid");
                        }
                    }
                });
            },
            approveWidget:function (dtnode){
                this.currentNode = dtnode;
                // $('#widgetId').attr('value',dtnode.data.key);
                 var widgetaction = "approve-widget";
                 $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" />pleasing wait...</h1>'});
                 $.ajax({
                    type:'POST',
                    data:{widgetid:dtnode.data.widget_id},
                    url:'/WidgetIDEAction.do?action=approve-widget',
                    success:function(data){
                        $.unblockUI();
                        var reply = eval('('+data+')');
                        if(reply.status == 'failed'){
                            alert(reply.msg);
                        }else{
                            dtnode.remove();
                            //var rootNode = $("#widget-treecontrol").dynatree('getTree').getNodeByKey('phyzixlabs-applet-list-prod');
                            //var newnode = {isFolder:false,addClass:'prodwidgetnode',key:'prod'+dtnode.data.widget_id,widget_id:dtnode.data.widget_id,title:dtnode.data.title,env:'prod',type:'wnode'};
                            //rootNode.append(newnode);
                            //appletBuilder.bindProdWidgetContextMenu();

                            //$('#save-widget-code-btn').attr("disabled", "disabled");
                            //code_editor.setCode('');
                            //$("#widget-resource-list").setGridParam({postData:{widgetid:dtnode.data.widget_id,env:dtnode.data.env}}).trigger("reloadGrid");
                        }
                    }
                });
            },
            rejectWidget:function (dtnode){
                this.currentNode = dtnode;
                $('#widget-rejected-reason-dialog').dialog("open");
            },
            newApplet:function(dtnode){
              $('#widgetName').attr('value','');
              $('#widgetDescription').attr('value','');
              $('#widgetCategory').attr('value','');
              $('#widgetTags').attr('value','');
              $('#widgetPrice').attr('value','0.00');
              $('#widgetCatalogPageIndex').attr('value','0');
              $('#widgetAuthorName').attr('value','');
              $('#widgetAuthorLink').attr('value','');
              $('#widgetVersion').attr('value','1.0');
              $('#widgetVersion').removeAttr('disabled');
              $('#widgetVersion').attr('disabled','disabled');
              widgetaction = "add-widget";
              $('#new-widget-dialog').data("dtnode",dtnode).dialog("open");
            },
            js_traverse:function(o,parent_reference,property_references,level) {
                var type = typeof o 
                if (type == "object") {
                    var empty = true;
                    for (var key in o) {
                        //print("key: ", key)
                        this.js_traverse(o[key],parent_reference+"."+key,property_references,level+1);
                        empty = false;
                    }
                    if(empty){
                        property_references.push({"property_reference":parent_reference+((o instanceof Array)?"[*]":"."),"value":""});
                    }
                } else {
                    //print(o)
                    property_references.push({"property_reference":parent_reference,"value":o});
                    //log(parent_reference+":"+o)
                }
            },
            newPackage:function(dtnode){
              this.select_widgets_for_packaging = [];
              $('#package-widget-dialog').dialog("open");
              $("#package-widget-dependency-list").setGridParam({postData:{load:true}}).trigger("reloadGrid");
            },
            updateCategory:function(name,dtnode){
                $.ajax({
                    type:'POST',
                    data:{
                          category:name,
                          id:dtnode.data.id
                        },
                    url:'/WidgetIDEAction.do?action=update-applet-category',
                    success:function(data){
                        var reply =eval('('+data+')');
                        //newNode.data.id = reply.category_id;
                        dtnode.data.title = name;
                        dtnode.render();//reloadChildren();
                    }
                });
            },
            moveAppletNodesToRoot:function(root,node){
                var children = node.getChildren();
                if(children != null){
                    for(var i=0;i<children.length;i++){
                        if(children[i].data.type == 'phyzixlabs-applet'){
                            children[i].move(root);
                        }
                        else
                        if(children[i].data.type == 'phyzixlabs-applet-category'){
                            appletBuilder.moveAppletNodesToRoot(root, children[i]);
                        }
                    }
                }
            },
            deleteCategory:function(dtnode){
                if(confirm('Are you sure you want to delete this category?\nNote: deleting category does not delete containing Apps')){
                    $.ajax({
                        type:'POST',
                        data:{
                              parent_id:dtnode.parent.data.id,
                              category_id:dtnode.data.id
                            },
                        url:'/WidgetIDEAction.do?action=del-applet-category',
                        success:function(data){
                            var reply =eval('('+data+')');
                            //newNode.data.id = reply.category_id;
                            //$("#applet-treecontrol").dynatree('getTree').reload();
                            var parent = dtnode.parent;
                            //move all child applet nodes to root
                            appletBuilder.moveAppletNodesToRoot($("#applet-treecontrol").dynatree('getTree').getRoot().getChildren()[0],dtnode);
                            dtnode.remove();
                            //parent.reloadChildren();
                        }
                    });
                }
            },
            newCategory:function(name,dtnode){
                //
                $.ajax({
                    type:'POST',
                    data:{
                          category:name,
                          parent_id:dtnode.data.id
                        },
                    url:'/WidgetIDEAction.do?action=add-applet-category',
                    success:function(data){
                        var reply =eval('('+data+')');
                        //newNode.data.id = reply.category_id;
                        var newNode = dtnode.addChild({id:reply.category_id,title:name,isLazy:true,isFolder:true,addClass:'phyzixlabs-applet-category',type:'phyzixlabs-applet-category'});
                        //dtnode.reloadChildren();
                    }
                });
            },
            withdrawWidget:function (dtnode){
                if(confirm('Are you sure you want to withdraw this App submission?')){
                 widgetaction = "withdraw-widget";
                 $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" />pleasing wait...</h1>'});
                 $.ajax({
                    type:'POST',
                    data:{widgetid:dtnode.data.widget_id},
                    url:'/WidgetIDEAction.do?action=withdraw-widget',
                    success:function(data){
                        $.unblockUI();
                        reply = eval('('+data+')');
                        if(reply.status == 'failed'){
                            alert(reply.msg);
                        }else{
                            dtnode.remove();
                            $('#save-widget-code-btn').attr("disabled", "disabled");
                            //code_editor.setCode('');
                            //$("#widget-resource-list").setGridParam({postData:{widgetid:dtnode.data.widget_id,env:dtnode.data.env}}).trigger("reloadGrid");
                        }
                    }
                });
                }
            },
            showDevHelp:function(){                
                window.open(help_url,'helpwindowx','location=no,toolbar=no,scrollbars=yes,directories=no,menubar=no,status=no,copyhistory=no,resizable=yes');
            },
            // --- Implement Cut/Copy/Paste --------------------------------------------
            clipboardNode : null,
            pasteMode : null,

            copyPaste:function (action, dtnode) {
                switch( action ) {
                case "cut":
                case "copy":
                  appletBuilder.clipboardNode = dtnode;
                  appletBuilder.pasteMode = action;
                  break;
                case "paste":
                  if( !appletBuilder.clipboardNode ) {
                    alert("Clipoard is empty.");
                    break;
                  }
                  if( appletBuilder.pasteMode == "cut" ) {
                    // Cut mode: check for recursion and remove source
                    var isRecursive = false;
                    var cb = appletBuilder.clipboardNode.toDict(true, function(dict){
                      // If one of the source nodes is the target, we must not move
                      if( dict.key == dtnode.data.key )
                        isRecursive = true;
                    });
                    if( isRecursive ) {
                      alert("Cannot move a node to a sub node.");
                      return;
                    }
                    dtnode.append(cb);
                    appletBuilder.clipboardNode.remove();
                  } else {
                    // Copy mode: prevent duplicate keys:
                        cb = appletBuilder.clipboardNode.toDict(true, function(dict){
                      dict.title = "Copy of " + dict.title;
                      delete dict.key; // Remove key, so a new one will be created
                    });
                    dtnode.append(cb);
                  }
                  appletBuilder.clipboardNode = pasteMode = null;
                  break;
                default:
                  alert("Unhandled clipboard action '" + action + "'");
                }
              },
              installPackage:function(id){
                  var defaultcategory = $('#appletCategory-'+id).val();
                  var applets = [];

                  var cur_pkg = null;
                  for(var i=0;i<available_packages.length;i++){
                       if(available_packages[i].id == id){
                               cur_pkg = available_packages[i];
                               for(var j=0;j<available_packages[i].applets.length;j++){
                                   if(available_packages[i].applets[j].selected4install){
                                       var category = $('#appletCategory-'+id+'-'+available_packages[i].applets[j].id).val();
                                       category = category == ''?defaultcategory:category;
                                       if(category == ''){
                                           alert('Please either select a default category or a category for each applet.')
                                           return;
                                       }
                                       applets.push(available_packages[i].applets[j].id+','+category);
                                   }
                               }break;
                        }
                   }
                   $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" /> Installing,please wait...</h1>'});
                    $.ajax({
                        type:'POST',
                        data:{
                              lines:applets.join('\n'),
                              package_id:id
                            },
                        url:'/WidgetIDEAction.do?action=install-applets',
                        success:function(data){
                            $.unblockUI();
                                $.ajax({
                                    type:'POST',
                                    data:{"id":id},
                                    url:'show-package.jsp',
                                    success:function(data){
                                        $( cur_pkg.panel ).html(data);
                                    }
                                });
                        }
                    });
              },
              uninstallPackage:function(id){

                  var applets = [];
                  var cur_pkg = null;
                  for(var i=0;i<available_packages.length;i++){
                       if(available_packages[i].id == id){
                               cur_pkg = available_packages[i];
                               for(var j=0;j<available_packages[i].applets.length;j++){
                                   if(available_packages[i].applets[j].selected4uninstall){
                                       applets.push(available_packages[i].applets[j].id);
                                   }
                               }break;
                        }
                   }
                    $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" />Uninstalling,please wait...</h1>'});
                    $.ajax({
                        type:'POST',
                        data:{
                              ids:applets.join('\n'),
                              package_id:id
                            },
                        url:'/WidgetIDEAction.do?action=uninstall-applets',
                        success:function(data){
                            $.unblockUI();
                            $.ajax({
                                    type:'POST',
                                    data:{"id":id},
                                    url:'show-package.jsp',
                                    success:function(data){
                                        $( cur_pkg.panel ).html(data);
                                    }
                            });
                        }
                    });
              },
              setPackageCategory:function(package_id){
                    /*var category = $('#appletCategory-'+package_id).val();
                    $('[id |= "appletCategory-'+package_id+'"]').each(function(index){

                        //skip the item that was clicked
                        if(index == 0)return true;

                        $(this).val(category);
                    });*/
              },
              selectAppletForInstall:function(package_id,id){
                   var enabledInstallBtn = false;
                   if(id){
                       for(var i=0;i<available_packages.length;i++){
                           if(available_packages[i].id == package_id){

                               var selectall = true;
                               for(var j=0;j<available_packages[i].applets.length;j++){

                                   if(available_packages[i].applets[j].id == id){
                                       available_packages[i].applets[j].selected4install = !available_packages[i].applets[j].selected4install;
                                   }
                                   if(!available_packages[i].applets[j].selected4install)
                                       selectall = false;
                                   else
                                       enabledInstallBtn = true;
                               }
                               available_packages[i].selected4install = selectall;
                               var elid = 'selectallpackageapplet4install-'+package_id;
                               //alert(elid+selectall)
                               if(!selectall){
                                 $('#'+elid).removeAttr('checked');
                               }else{
                                 $('#'+elid).attr('checked','checked');
                               }break;
                           }
                       }
                   }else{
                       for(i=0;i<available_packages.length;i++){
                           if(available_packages[i].id == package_id){
                               available_packages[i].selected4install = !available_packages[i].selected4install;

                               for(j=0;j<available_packages[i].applets.length;j++){
                                   elid = 'selectpackageapplet4install-'+package_id+'-'+available_packages[i].applets[j].id;

                                   //alert(elid+available_packages[i].selected4install)
                                   if(available_packages[i].selected4install){
                                       $('#'+elid).attr('checked','checked');
                                       available_packages[i].applets[j].selected4install = true;
                                   }else{
                                       $('#'+elid).removeAttr('checked');
                                       available_packages[i].applets[j].selected4install = false;
                                   }
                               }
                               enabledInstallBtn = available_packages[i].selected4install;
                               break;
                           }
                       }
                   }

                   if(enabledInstallBtn)
                        $('#install-package-'+package_id).removeAttr("disabled");
                    else
                        $('#install-package-'+package_id).attr("disabled","disabled");
              },
              selectAppletForunInstall:function(package_id,id){
                   var enabledInstallBtn = false;
                   if(id){
                       for(var i=0;i<available_packages.length;i++){
                           if(available_packages[i].id == package_id){

                               var selectall = true;
                               for(var j=0;j<available_packages[i].applets.length;j++){

                                   if(available_packages[i].applets[j].id == id){
                                       available_packages[i].applets[j].selected4uninstall = !available_packages[i].applets[j].selected4uninstall;
                                   }
                                   if(!available_packages[i].applets[j].selected4uninstall)
                                       selectall = false;
                                   else
                                       enabledInstallBtn = true;
                               }
                               available_packages[i].selected4uninstall = selectall;
                               var elid = 'selectallpackageapplet4uninstall-'+package_id;
                               //alert(elid+selectall)
                               if(!selectall){
                                 $('#'+elid).removeAttr('checked');
                               }else{
                                 $('#'+elid).attr('checked','checked');
                               }break;
                           }
                       }
                   }else{
                       for(i=0;i<available_packages.length;i++){
                           if(available_packages[i].id == package_id){
                               available_packages[i].selected4uninstall = !available_packages[i].selected4uninstall;

                               for(j=0;j<available_packages[i].applets.length;j++){
                                   elid = 'selectpackageapplet4uninstall-'+package_id+'-'+available_packages[i].applets[j].id;

                                   //alert(elid+available_packages[i].selected4install)
                                   if(available_packages[i].selected4uninstall){
                                       $('#'+elid).attr('checked','checked');
                                       available_packages[i].applets[j].selected4uninstall = true;
                                   }else{
                                       $('#'+elid).removeAttr('checked');
                                       available_packages[i].applets[j].selected4uninstall = false;
                                   }
                               }enabledInstallBtn = available_packages[i].selected4uninstall;
                               break;
                           }
                       }
                   }

                   if(enabledInstallBtn)
                        $('#uninstall-package-'+package_id).removeAttr("disabled");
                    else
                        $('#uninstall-package-'+package_id).attr("disabled","disabled");
              },
              selectLibraryEntry:function(ids,id){
                    var deps = current_widget_to_package.dependencies;

                    var found = false;
                    for(var i=0;i<deps.length;i++){
                        if(deps[i].dependency_id == id ){
                            //remove it
                            deps.splice(i,1);

                            found = true;
                            break;
                        }
                    }

                    var qualifiedId = (ids.length>0?(ids.join('-')+'-'+id):id);
                    if(!found){

                        var row = $("#package-widget-dependency-list").getRowData(id);
                        deps.push({dependency_id:id,dependency_path:row.path});

                        //select all child items
                        $('[id |= "selectlibraryentry-'+qualifiedId+'"]').each(function(index){

                            //skip the item that was clicked
                            if(index == 0)return true;

                            //only select items not already selected
                            if($(this).attr('checked') != true){

                                $(this).attr('checked','checked');

                                //add this item as a dependency
                                var elname = $(this).attr('name');
                                var dependency_id = elname.split('-')[1];
                                row = $("#package-widget-dependency-list").getRowData(dependency_id);
                                deps.push({dependency_id:dependency_id,dependency_path:row.path});
                            }
                        });

                    }else{//this means it is checked, remove it..toggling state

                        //remove all child items
                        $('[id |= "selectlibraryentry-'+qualifiedId+'"]').each(function(index){

                            //skip the item that was clicked
                            if(index == 0)return true;


                            //only uncheck items already checked
                            if($(this).attr('checked')){
                                $(this).removeAttr('checked');

                                //remove this item from list of dependencies
                                var elname = $(this).attr('name');
                                var dependency_id = elname.split('-')[1];
                                for(i=0;i<deps.length;i++){
                                    if(deps[i].dependency_id == dependency_id ){
                                        //remove it
                                        deps.splice(i,1);
                                        break;
                                    }
                                }
                            }
                        });

                        //uncheck all parent items since select all isn't true anymore... at least one child item is unchecked
                        for(var j=0;j<ids.length;j++){
                            for(i=0;i<deps.length;i++){
                                if(deps[i].dependency_id == ids[j] ){
                                    //remove it
                                    deps.splice(i,1);
                                    $('input[name=selectlibraryentry-'+ids[j]+']').removeAttr('checked');
                                    i=deps.length;
                                }
                            }
                        }
                    }
              },
              selectWidgetForPackaging:function(id){
                  //if selected remove it
                  for(var i=0;i<this.selected_widgets_for_packaging.length;i++){
                      if(this.selected_widgets_for_packaging[i].widget_id == id){
                          this.selected_widgets_for_packaging.splice(i,1)
                          return;
                      }
                  }
                  //add to selected list
                  for(var i=0;i<this.widgets_for_packaging.length;i++){
                      if(this.widgets_for_packaging[i].widget_id == id){
                          this.selected_widgets_for_packaging.push(this.widgets_for_packaging[i]);
                          return;
                      }
                  }
              },
              packageUploaded:function(reply){
                current_tree_node.reloadChildren();
              },
              packageImported:function(reply){
                current_tree_node.reloadChildren();
              },
              resourceAdded:function(reply){
                current_tree_node.reloadChildren();
              },
              bulkLoadUsers:function(){
                $('#load-users-dialog').dialog("open");
              },
              usersLoaded:function(reply){
                $("#user-table").trigger("reloadGrid");
              },
              libraryAdded:function(reply){
                current_tree_node.reloadChildren();
              },
              deleteResource:function(dtnode){
                  
                  if(confirm('Are you sure you want to delete this resource?')){
                    //$.blockUI({css:{},overlayCSS: { backgroundColor: '#666666',opacity:.2 },theme:true,message: '<h1><img src="../../img/busy.gif" />Deleting resource,please wait...</h1>'});
                    $.ajax({
                        type:'POST',
                        data:{widgetid:dtnode.data.widget_id,uuid:dtnode.data.uuid,env:'dev',relPath:dtnode.data.relPath,fileName:dtnode.data.title},
                        url:'/WidgetResourceAction.do?action=del-widget-resource',
                        success:function(data){
                            //$.unblockUI();
                            //$('#widget-resource-list').delRowData(file_name);
                            dtnode.remove();
                        }
                    });
                  }
              },
              hideResourceEditor:function(id){
              var found =false;
                for(var i=0;i<open_resources.length;i++){
                    var resource_editor = open_resources[i];
                    if(!found && resource_editor.id == "resource-editor-"+id){
                        found = true;
                        $('#resource-tabs').tabs("remove",resource_editor.tabindex);
                        open_resources.splice(i,1);
                        resource_editor.editor = null;
                        --i;continue;
                    }
                    if(found){
                        resource_editor.tabindex--;
                    }
                }
              },
            saveAppletCode:function(id,editor){
                   var resource_editor = null;
                    for(var i=0;i<open_resources.length;i++){
                        resource_editor = open_resources[i];
                        if(resource_editor.id == id)
                            break;
                    }
                $.ajax({
                    type:'POST',
                    data:{
                          widgetid:resource_editor.param.widgetid,
                          code:resource_editor.editor.getValue(),
                          env:resource_editor.param.env
                        },
                    url:'/WidgetAction.do?action=save-widget-code',
                    success:function(data){
                        editor.contentModified = false;
                    }
                });
            },
            saveAppletToxonomy:function(id,editor){
                   var resource_editor = null;
                    for(var i=0;i<open_resources.length;i++){
                        resource_editor = open_resources[i];
                        if(resource_editor.id == id)
                            break;
                    }
                    
                    $.ajax({
                        type:'POST',
                        data:{
                              data:resource_editor.editor.getValue()
                            },
                        url:'/WidgetIDEAction.do?action=set-widget-menu-structure',
                        success:function(data){
                            editor.contentModified = false;
                        }
                    });
            },
            saveSystemSettings:function(){
                    
                    var installation_name                 = $('#phyzixlabs-system-setting-installation_name').val();
                    var allow_user_account_creation       = $('#phyzixlabs-system-setting-allow_user_account_creation').attr("checked")?true:false;
                    var allow_auto_login_after_signup     = $('#phyzixlabs-system-setting-allow_auto_login_after_signup').attr("checked")?true:false;
                    var allow_auto_signup                 = $('#phyzixlabs-system-setting-allow_auto_signup').attr("checked")?true:false;

                    var default_roles = [];
                    if($('#phyzixlabs-system-setting-default_roles-developer').attr("checked"))
                            default_roles.push("developer");
                    if($('#phyzixlabs-system-setting-default_roles-educator').attr("checked"))
                            default_roles.push("educator");
                    if($('#phyzixlabs-system-setting-default_roles-room_creator').attr("checked"))
                            default_roles.push("room_creator");


                    var restrict_access_to_domains  = $('#phyzixlabs-system-setting-restrict_access_to_domains').val();
                    var enable_http_proxy           = $('#phyzixlabs-system-setting-enable_http_proxy').attr("checked")?true:false;
                    var hadron_help_url             = $('#phyzixlabs-system-setting-hadron_help_url').val();
                    var baseUrl                     = $('#phyzixlabs-system-setting-baseUrl').val();
                    var applet_deployment_policy    = $('#phyzixlabs-system-setting-applet_deployment_policy').attr("checked")?"passthrough":"check";
                    var file_serving_url_prefix     = $('#phyzixlabs-system-setting-file_serving_url_prefix').val();
                    var timezone_list               = $('#phyzixlabs-system-setting-timezone_list').val();
                    var enable_content_importing    = $('#phyzixlabs-system-setting-enable_content_importing').attr("checked")?true:false;

                    var default_binder_access       = $('#phyzixlabs-system-setting-default_binder_access-read').attr("checked")?this.ACCESS_MODE.READ:0;
                    default_binder_access           |= $('#phyzixlabs-system-setting-default_binder_access-write').attr("checked")?this.ACCESS_MODE.WRITE:0;

                    var default_page_access       = $('#phyzixlabs-system-setting-default_page_access-read').attr("checked")?this.ACCESS_MODE.READ:0;
                    default_page_access           |= $('#phyzixlabs-system-setting-default_page_access-write').attr("checked")?this.ACCESS_MODE.WRITE:0;

                    var default_element_access       = $('#phyzixlabs-system-setting-default_element_access-read').attr("checked")?this.ACCESS_MODE.READ:0;
                    default_element_access           |= $('#phyzixlabs-system-setting-default_element_access-write').attr("checked")?this.ACCESS_MODE.WRITE:0;


                    //email notfication
                    var account_create_notifier              = $('#phyzixlabs-system-setting-account_create_notifier').val();
                    var account_create_notifier_password     = $('#phyzixlabs-system-setting-account_create_notifier_password').val();

                    var invite_notifier                      = $('#phyzixlabs-system-setting-invite_notifier').val();
                    var invite_notifier_password             = $('#phyzixlabs-system-setting-invite_notifier_password').val();

                    var app_notifier                         = $('#phyzixlabs-system-setting-app_notifier').val();
                    var app_notifier_password                = $('#phyzixlabs-system-setting-app_notifier_password').val();


                    //super user access required: not really enforced in code yet
                    var installation_login_url      = $('#phyzixlabs-system-setting-installation_login_url').length?$('#phyzixlabs-system-setting-installation_login_url').val():'';
                    var system_user_limit           = $('#phyzixlabs-system-setting-system_user_limit').length?$('#phyzixlabs-system-setting-system_user_limit').val():'';
                    var explore_and_learn_url       = $('#phyzixlabs-system-setting-explore_and_learn_url').length?$('#phyzixlabs-system-setting-explore_and_learn_url').val():'';
                    var whats_new_url               = $('#phyzixlabs-system-setting-whats_new_url').length?$('#phyzixlabs-system-setting-whats_new_url').val():'';
                    var enable_applet_import        = $('#phyzixlabs-system-setting-enable_applet_import').length?($('#phyzixlabs-system-setting-enable_applet_import').attr("checked")?true:false):'';
                    var load_sample_applets         = $('#phyzixlabs-system-setting-load_sample_applets').length?($('#phyzixlabs-system-setting-load_sample_applets').attr("checked")?true:false):'';
                    var enable_applet_deployment    = $('#phyzixlabs-system-setting-enable_applet_deployment').length?($('#phyzixlabs-system-setting-enable_applet_deployment').attr("checked")?true:false):'';
                    var active_mq_rate              = $('#phyzixlabs-system-setting-mq-rate').length?$('#phyzixlabs-system-setting-mq-rate').val():'100';

                    var stripe_public_key           = $('#phyzixlabs-system-setting-stripe_public_key').length?$('#phyzixlabs-system-setting-stripe_public_key').val():'';
                    var stripe_secret_key           = $('#phyzixlabs-system-setting-stripe_secret_key').length?$('#phyzixlabs-system-setting-stripe_secret_key').val():'';
                    //log('enable_applet_import:'+enable_applet_import)
                    $.ajax({
                        type:'POST',
                        data:{
                              "installation_name":installation_name,
                              "allow_user_account_creation":allow_user_account_creation,
                              "allow_auto_login_after_signup":allow_auto_login_after_signup,
                              "allow_auto_signup":allow_auto_signup,
                              "default_roles":default_roles.join(','),
                              "restrict_access_to_domains":restrict_access_to_domains,
                              "enable_http_proxy":enable_http_proxy,
                              "installation_login_url":installation_login_url,
                              "system_user_limit":system_user_limit,
                              "explore_and_learn_url":explore_and_learn_url,
                              "whats_new_url":whats_new_url,
                              "enable_applet_import":enable_applet_import,
                              "load_sample_applets":load_sample_applets,
                              "enable_applet_deployment":enable_applet_deployment,
                              "hadron_help_url":hadron_help_url,
                              "baseUrl":baseUrl,
                              "active_mq_rate":active_mq_rate,
                              "applet_deployment_policy":applet_deployment_policy,
                              "file_serving_url_prefix":file_serving_url_prefix,
                              "timezone_list":timezone_list,
                              "enable_content_importing":enable_content_importing,
                              
                              "account_create_notifier":account_create_notifier,
                              "account_create_notifier_password":account_create_notifier_password,
                              "invite_notifier":invite_notifier,
                              "invite_notifier_password":invite_notifier_password,
                              "app_notifier":app_notifier,
                              "app_notifier_password":app_notifier_password,

                              "default_binder_access":default_binder_access,
                              "default_page_access":default_page_access,
                              "default_element_access":default_element_access,
                              "stripe_public_key":stripe_public_key,
                              "stripe_secret_key":stripe_secret_key
                          },
                        url:'/WidgetIDEAction.do?action=save-system-settings',
                        success:function(data){
                            
                        }
                    });
            },
            saveResourceItem:function(id,editor){

                   var resource_editor = null;
                    for(var i=0;i<open_resources.length;i++){
                        resource_editor = open_resources[i];
                        if(resource_editor.id == id)
                            break;
                    }

                    //$.blockUI({css:{},overlayCSS: { backgroundColor: '#666666',opacity:.2 },theme:true,message: '<h1><img src="../../img/busy.gif" />Saving resource,please wait...</h1>'});
                    $.ajax({
                        type:'POST',
                        data:{widgetid:resource_editor.param.widgetid,uuid:resource_editor.param.uuid,env:resource_editor.param.env,relPath:resource_editor.param.relPath, data:resource_editor.editor.getValue()},
                        url:'/WidgetResourceAction.do?action=save-widget-resource-item',
                        success:function(data){
                            editor.contentModified = false;
                            //$.unblockUI();
                            //alert(data)
                        }
                    });
              },

              makeEditor:function(type,editor_id,cb){
                    var basePath = "js/CodeMirror-0.92";
                    if(type == "js"){
                           return CodeMirror.fromTextArea(document.getElementById(editor_id), {
                              mode:"javascript",                              
                              lineNumbers: true,                              
                              matchBrackets: true,
                              onChange:function(editor){editor.contentModified = true;}
                            });
                        
                           /*return CodeMirror.fromTextArea($("#"+editor_id), {
                              mode:"javascript",
                              parserfile: ["tokenizejavascript.js", "parsejavascript.js"],
                              path: basePath+"/js/",
                              stylesheet: basePath+"/css/jscolors.css",
                              continuousScanning: 500,
                              /*height: "dynamic",*
                              lineNumbers: true,
                              textWrapping: false,
                              autoMatchParens: true,
                              initCallback:cb
                            });*/
                    }
                    else
                    if(type == "xml" || type == "svg"){
                          return CodeMirror.fromTextArea(document.getElementById(editor_id), {                         
                            mode:"xml",
                            lineNumbers: true,                              
                            matchBrackets: true,
                            onChange:function(editor){editor.contentModified = true;}
                          });                        
                        
                          /*
                          return CodeMirror.fromTextArea(editor_id, {                         
                          mode:"xml",
                          parserfile:"parsexml.js",
                          path: basePath+"/js/",
                          stylesheet: basePath+"/css/xmlcolors.css",
                          continuousScanning: 500,
                          lineNumbers: true,
                          textWrapping: false,
                          initCallback:cb
                          });*/
                    }
                    else
                    if(type == "html"){
                          return CodeMirror.fromTextArea(document.getElementById(editor_id), {                         
                            mode:"htmlmixed",
                            lineNumbers: true,                              
                            matchBrackets: true,
                            onChange:function(editor){editor.contentModified = true;}
                          });                         
                          /*
                          return CodeMirror.fromTextArea(editor_id, {
                          mode:"htmlmixed",
                          parserfile:["parsexml.js","parsecss.js","tokenizejavascript.js", "parsejavascript.js","parsehtmlmixed.js"],
                          path: basePath+"/js/",
                          stylesheet: basePath+"/css/xmlcolors.css",
                          continuousScanning: 500,
                          lineNumbers: true,
                          textWrapping: false,
                          initCallback:cb
                          });*/
                    }
                    else
                    if(type == "css"){
                          return CodeMirror.fromTextArea(document.getElementById(editor_id), {                         
                            mode:"css",
                            lineNumbers: true,                              
                            matchBrackets: true,
                            onChange:function(editor){editor.contentModified = true;}
                          });                         
                        
                          /*
                          return CodeMirror.fromTextArea(editor_id, {
                          mode:"css",
                          parserfile:"parsecss.js",
                          path: basePath+"/js/",
                          stylesheet: basePath+"/css/csscolors.css",
                          continuousScanning: 500,
                          lineNumbers: true,
                          textWrapping: false,
                          initCallback:cb
                          });*/
                    }
                    else
                    if(type == "txt"){
                          return CodeMirror.fromTextArea(document.getElementById(editor_id), {                         
                            mode:"html",
                            lineNumbers: true,                              
                            matchBrackets: true,
                            onChange:function(editor){editor.contentModified = true;}
                          });                         
                        
                          /*
                          return CodeMirror.fromTextArea(editor_id, {
                          mode:"htmlmixed",
                          parserfile:"parsedummy.js",
                          path: basePath+"/js/",
                          stylesheet: basePath+"/css/xmlcolors.css",
                          continuousScanning: 500,
                          lineNumbers: true,
                          textWrapping: false,
                          initCallback:cb
                          });*/
                    }
                    return null;
              },

              addResourceItemEditTab:function(widgetid,resource_name,env,path,file_name,ext,uuid){
                  //alert(path)
                   var id = replaceAll(replaceAll(path,".","-"),"/","-");
                   var resitm_tabid = 'resources-tabs-'+id;

                   if(document.getElementById(resitm_tabid) == null){
                       $('#resource-tabs').append('<div id="'+resitm_tabid+'"><textarea id="resource-editor-'+id+'" style="width:96%;height:800px; border-style:solid;border-color:gray;border-width:1px></textarea></div>');

                       var delCode = 'hideResourceEditor(\''+id+'\')';

                       var delbnt   = parseInt($('#resource-tabs').tabs('length'))>0?' <input type="image" src="img/x-tab.png" onclick="'+delCode+'"/>':'';
                       var savebnt  = '<input type="image" src="img/save-to-disk.png" onclick="saveResourceItem(\''+id+'\')"/>';
                       var tabindex = parseInt($('#resource-tabs').tabs('length'));

                       $('#resource-tabs').tabs('add','#'+resitm_tabid,savebnt+file_name+delbnt);
                       var resource_editor = {id:'resource-editor-'+id,init:false,tabindex:tabindex,args:[widgetid,resource_name,env,path,ext,uuid]};
                       open_resources.push(resource_editor);

                       //switch to new tab
                       if(parseInt($('#resource-tabs').tabs('length'))>1){
                            $('#resource-tabs').tabs('select','#'+resitm_tabid);
                            //loadResourceItemData(widgetid,resource_name,env,path,ext,editor.editor);
                       }
                   }
              },
              loadResourceItemData:function(widgetid,file_name,env,path,type,editor,uuid){
                    //see if there is a tab with this item open in it,
                    //if there is simply switch

                    $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:true,message: '<h1><img src="../../img/busy.gif" />loading resource,please wait...</h1>'});
                    $.ajax({
                        type:'POST',
                        data:{widgetid:widgetid,file_name:file_name,env:env},
                        url:get_content_url(widgetid,env, path, type,uuid),
                        success:function(data){
                            $.unblockUI();
                            //alert(data)
                            editor.setCode(data);
                        }
                    });
              },
              deleteLibrary:function(/*file_name*/dtnode){

                  if(confirm('Are you sure you want to delete this library?')){
                    //$.blockUI({css:{},overlayCSS: { backgroundColor: '#666666',opacity:.2 },theme:true,message: '<h1><img src="../../img/busy.gif" />Deleting resource,please wait...</h1>'});
                    $.ajax({
                        type:'POST',
                        data:{lib:dtnode.data.relPath},
                        url:'/WidgetIDEAction.do?action=del-from-library',
                        success:function(data){
                            //$.unblockUI();
                            //$('#package-lib-list').delRowData(file_name);
                            dtnode.remove();
                        }
                    });
                  }
              },
              deletePackage:function(/*id*/dtnode){
                  if(confirm('Are you sure you want to delete this package?')){
                    //$.blockUI({css:{},overlayCSS: { backgroundColor: '#666666',opacity:.2 },theme:true,message: '<h1><img src="../../img/busy.gif" />Deleting package,please wait...</h1>'});
                    $.ajax({
                        type:'POST',
                        data:{id:dtnode.data.id},
                        url:'/WidgetIDEAction.do?action=del-package',
                        success:function(data){
                            //$.unblockUI();
                            //$('#applet-package-list').delRowData(id);
                            dtnode.remove();
                        }
                    });
                  }
              },
              renameResource:function(fileName,dtnode){
                  
                  var param = {widgetid:dtnode.data.widget_id,
                            uuid:dtnode.data.uuid,
                          relPath:dtnode.data.relPath,
                          mimeType:dtnode.data.mime,
                          fileName:fileName,
                          oldName:dtnode.data.title
                      };
                      
                  $.ajax({
                    type:'POST',
                    data:param,
                    url:'/WidgetResourceAction.do?action=rename-applet-resource',
                    success:function(data){
                        var reply = eval('('+data+')');

                        if(reply.status == 'success'){
                            dtnode.data.relPath = reply.relPath;
                            
                            if(dtnode.data.mime != 'folder'){
                                dtnode.data.title = fileName+'.'+dtnode.data.mime;
                                dtnode.render();
                            }else{
                                dtnode.data.title = fileName;
                                dtnode.render();
                                dtnode.reloadChildren();
                            }
                        }else{
                            alert('There was a problem renaming file')
                        }
                    }
                  });
              },
              newResource:function(fileName,dtnode){
                      var param = {widgetid:dtnode.data.widget_id,
                                uuid:dtnode.data.uuid,
                              relPath:dtnode.data.relPath,
                              mimeType:'',
                              fileName:fileName
                          };

                      
                      switch( $('#new-applet-resource-dialog').data("file_type") )
                      {
                          case "new_folder":
                                param.mimeType = "folder";
                                break;
                          case "new_js_file":
                                param.mimeType = "js";
                                break;
                          case "new_html_file":
                                param.mimeType = "html";
                                break;
                          case "new_svg_file":
                                param.mimeType = "svg";
                                break;
                          case "new_xml_file":
                                param.mimeType = "xml";
                                break;
                          case "new_txt_file":
                                param.mimeType = "txt";
                                break;
                          case "new_css_file":
                                param.mimeType = "css";
                                break;
                          default:
                      }

                      //alert("file type:"+param.mimeType+",fileName:"+param.fileName+",relPath:"+param.relPath+", uuid:"+param.uuid)
                      $.ajax({
                        type:'POST',
                        data:param,
                        url:'/WidgetResourceAction.do?action=create-applet-resource',
                        success:function(data){                            
                            var reply = eval('('+data+')');
                            
                            if(reply.status == 'success'){
                                dtnode.reloadChildren();
                                //var addedNode = dtnode/*.reloadChildren();*/.addChild(reply.node);
                                //addedNode.activate();
                                appletBuilder.openEditor(dtnode);
                            }else{
                                alert('There was a problem creating file')
                            }
                        }
                      });
              },
            endsWith:function(str, suffix) {
                return str.indexOf(suffix, str.length - suffix.length) !== -1;
            },
            getFileNameSansMimeType:function(name,mime){
                if(mime == 'html' && this.endsWith(name,".html")){
                    return name.substring(0,name.lastIndexOf(".html"));
                }
                if(mime == "htm" && this.endsWith(name,".htm")){
                    return name.substring(0,name.lastIndexOf(".htm"));
                }
                if(mime == "js" && this.endsWith(name,".js")){
                    return name.substring(0,name.lastIndexOf(".js"));
                }
                if(mime == "xml" && this.endsWith(name,".xml")){
                    return name.substring(0,name.lastIndexOf(".xml"));
                }
                if(mime == "txt" && this.endsWith(name,".txt")){
                    return name.substring(0,name.lastIndexOf(".txt"));
                }
                if(mime == "css" && this.endsWith(name,".css")){
                    return name.substring(0,name.lastIndexOf(".css"));
                }
                return name;
            },
              showResourceRenameDialog:function(dtnode){
                  selected_context_menu_action="rename";
                  $('#new-applet-resource-name').attr("value",appletBuilder.getFileNameSansMimeType(dtnode.data.title,dtnode.data.mime));
                  $('#new-applet-resource-dialog').data("dtnode",dtnode).dialog("open")
              },
              deleteUser:function(userName){
                  if(confirm('Are you sure you want to delete this user?\n Deleting user would delete all the user\'s work.')){
                      $.ajax({
                        type:'POST',
                        data:{"userName":userName},
                        url:'/UserAction.do?action=delete-user',
                        success:function(data){
                            var reply = eval('('+data+')');
                            if(reply.status == 'success'){
                                $("#user-table").trigger("reloadGrid");
                            }else{
                                alert('There was a problem, '+reply.msg);
                            }
                        }
                      });
                  }
              },
              addNewUser:function(){
                     var fullname = $('#phyzixlabs-user-fullname').val();
                     var email = $('#phyzixlabs-user-email').val();
                     var roles = [];

                     $('[id |= "phyzixlabs-user-role"]').each(function(){
                         if($(this).attr("checked"))
                             roles.push($(this).val())
                     })

                     if(fullname == ''){
                         alert('Please provide name and email address for user');
                         return;
                     }
                     if(!appletBuilder.echeck(email))return;

                      $.ajax({
                        type:'POST',
                        data:{"name":fullname,
                              "emailAddress":email,
                              "roomLabel":"Lobby",
                              "roles":roles.join('\n'),
                              "user_id":$('#phyzixlabs-user-id').val()},
                        url:'/UserAction.do?action=admin-update-user-role',
                        success:function(data){
                            var reply = eval('('+data+')');
                            
                            if(reply.status == 'success'){
                                appletBuilder.cancelUserAction();
                                $("#user-table").trigger("reloadGrid");
                            }else{
                                alert('there was a problem, please contact support if problem persists');
                            }
                        }
                      });
              },
              cancelUserAction:function(){
                  $('[id |= "phyzixlabs-user-role"]').removeAttr("checked");
                  $('#phyzixlabs-user-fullname').removeAttr("disabled").val('');
                  $('#phyzixlabs-user-email').removeAttr("disabled").val('');
                  $('#phyzixlabs-user-id').removeAttr("disabled").val('');
                  $('#phyzixlabs-user-add-btn').text('Add');
              },
              loadUsers:function(){
                  
                  $("#user-table").jqGrid({url:'get-users.jsp',
                      datatype: "xml",
                      postData:{},
                      colNames:['id','Name','E-mail','Roles',''],
                      colModel:[
                                 {name:'id',index:'id', width:1,hidden:true,key:true},
                                 {name:'fullname',index:'fullname'},
                                 {name:'email',index:'email'},
                                 {name:'roles',index:'roles'},
                                 {name:'actions',index:'actions', sortable:false}],
                      rowNum:-1,
                      rowList:[],
                      pager: $('#user-table-pager'),
                      sortname: 'id',
                      viewrecords: true,
                      autowidth: true,
                      height:appletBuilder.body_height*.65,
                      sortorder: "desc",
                      onSelectRow:function(rowid){
                          var row = $(this).getRowData(rowid);
                          $('[id |= "phyzixlabs-user-role"]').removeAttr("checked");
                          $('[id |= "phyzixlabs-user"]').removeAttr("disabled");

                          $('#phyzixlabs-user-fullname').val(row.fullname).attr('disabled','disabled');
                          $('#phyzixlabs-user-email').val(row.email).attr('disabled','disabled');
                          //alert(row.roles)
                          var roles = row.roles.split("<br>");
                          for(var i=0;i<roles.length;i++){
                              $('#phyzixlabs-user-role-'+roles[i]).attr("checked","checked");
                          }
                          $('#phyzixlabs-user-add-btn').text('Update');
                          $('#phyzixlabs-user-id').val(row.id);
                      },
                      caption:"System Users"}).navGrid('#user-table-pager',{edit:false,add:false,del:false,search:true});
                      
              },
              resetIframes:function(){                   
                  $('#packageInterface').attr("src","package.jsp");                             
              },
              onPackageComplete:function(){
                  $.unblockUI();
                  this.resetIframes();
              },
              onPackageError:function(type,msg){
                    $.unblockUI();
                    if(type == 'exception'){
                        $('#back-end-error-dialog-msg').text(msg);
                        $('#back-end-error-dialog').dialog("open");
                    }                    
                    this.resetIframes();
               },
               setUpContextMenuBindings:function(){

                    appletBuilder.contextMenuBindings=
                    {
                        "phyzixlabs-applet":{
                            selector:".phyzixlabs-applet",
                            items:
                            {
                                    "edit":
                                    {
                                        name:"Edit",
                                        exec:appletBuilder.editWidget,
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "delete":
                                    {
                                        name:"Delete",
                                        exec:appletBuilder.deleteWidget,
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "submit":
                                    {
                                        name:"Submit",
                                        exec:appletBuilder.submitWidget,
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    }
                            }
                        },     
                        "phyzixlabs-resource-root":{
                            selector:".phyzixlabs-resource-root",
                            items:
                            {
                                    "add_resource":
                                    {
                                        name:"Upload",
                                        exec:function(dtnode){$('#add-resource-dialog').data("dtnode",dtnode).dialog("open");},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_folder":
                                    {
                                        name:"Folder",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_folder").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_js_file":
                                    {
                                        name:"Javascript File",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_js_file").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_html_file":
                                    {
                                        name:"HTML File",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_html_file").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_xml_file":
                                    {
                                        name:"XML File",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_xml_file").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_css_file":
                                    {
                                        name:"CSS File",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_css_file").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_txt_file":
                                    {
                                        name:"Text File",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_txt_file").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    }
                                }
                        },
                        "phyzixlabs-resource-dir":{
                            selector:".phyzixlabs-resource-dir",
                            items:
                            {
                                    "delete":
                                    {
                                        name:"Delete",
                                        exec:appletBuilder.deleteResource,
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "add_resource":
                                    {
                                        name:"Upload",
                                        exec:function(dtnode){$('#add-resource-dialog').data("dtnode",dtnode).dialog("open");},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_folder":
                                    {
                                        name:"Folder",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_folder").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_js_file":
                                    {
                                        name:"Javascript File",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_js_file").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_html_file":
                                    {
                                        name:"HTML File",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_html_file").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_xml_file":
                                    {
                                        name:"XML File",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_xml_file").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_css_file":
                                    {
                                        name:"CSS File",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_css_file").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_txt_file":
                                    {
                                        name:"Text File",
                                        exec:function(dtnode){$('#new-applet-resource-dialog').data("file_type","new_txt_file").data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "rename":
                                    {
                                        name:"Rename",
                                        exec:function(dtnode){selected_context_menu_action="rename";$('#new-applet-resource-name').attr("value",dtnode.data.title);$('#new-applet-resource-dialog').data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    }
                             }
                        },
                        "phyzixlabs-resource-file":{
                            selector:".phyzixlabs-resource-file",
                            items:
                            {
                                "delete":
                                {
                                    name:"Delete",
                                    exec:appletBuilder.deleteResource,
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                                "rename":
                                {
                                    name:"Rename",
                                    exec:appletBuilder.showResourceRenameDialog,
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }
                        },
                        "phyzixlabs-system-applet-category":{
                            selector:".phyzixlabs-system-applet-category",
                            items:
                            {
                                    "new_applet":
                                    {
                                        name:"New App",
                                        exec:appletBuilder.newApplet,
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "import_package":
                                    {
                                        name:"Import Package",
                                        exec:function(dtnode){$('#import-package-dialog').data("dtnode",dtnode).dialog("open");},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    }
                            }
                        },
                        "phyzixlabs-applet-category":{
                            selector:".phyzixlabs-applet-category",
                            items:
                            {
                                    "new_category":
                                    {
                                        name:"New Category",
                                        exec:function(dtnode){$('#new-applet-category-dialog').data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_applet":
                                    {
                                        name:"New App",
                                        exec:appletBuilder.newApplet,
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "delete":
                                    {
                                        name:"Delete",
                                        exec:appletBuilder.deleteCategory,
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "rename":
                                    {
                                        name:"Rename",
                                        exec:function(dtnode){selected_context_menu_action="rename";$('#new-applet-category-name').attr("value",dtnode.data.title);$('#new-applet-category-dialog').data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "import_package":
                                    {
                                        name:"Import Package",
                                        exec:function(dtnode){$('#import-package-dialog').data("dtnode",dtnode).dialog("open");},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    }
                            }
                        },
                        "phyzixlabs-applet-category-root":{
                            selector:".phyzixlabs-applet-category-root",
                            items:
                            {
                                    "new_category":
                                    {
                                        name:"New Category",
                                        exec:function(dtnode){$('#new-applet-category-dialog').data("dtnode",dtnode).dialog("open")},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_applet":
                                    {
                                        name:"New App",
                                        exec:appletBuilder.newApplet,
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "new_package":
                                    {
                                        name:"New Package",
                                        exec:appletBuilder.newPackage,
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "import_package":
                                    {
                                        name:"Import Package",
                                        exec:function(dtnode){$('#import-package-dialog').data("dtnode",dtnode).dialog("open");},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    }
                            }
                        },
                        "phyzixlabs-system-library-root":{
                            selector:".phyzixlabs-system-library-root",
                            items:
                            {
                                    "add":
                                    {
                                        name:"Add",
                                        exec:function(dtnode){$('#add-lib-dialog').data("dtnode",dtnode).dialog("open");},
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    }
                            }
                        },
                        "phyzixlabs-system-library-dir":{
                            selector:".phyzixlabs-system-library-dir",
                            items:
                            {
                                "delete":
                                {
                                    name:"Delete",
                                    exec:appletBuilder.deleteLibrary,
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }
                        },
                        "phyzixlabs-system-library-file":{
                            selector:".phyzixlabs-system-library-file",
                            items:
                            {
                                "delete":
                                {
                                    name:"Delete",
                                    exec:appletBuilder.deleteLibrary,
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }
                        },
                        "phyzixlabs-system-package-root":{
                            selector:".phyzixlabs-system-package-root",
                            items:
                            {
                                "add":
                                {
                                    name:"Add",
                                    exec:function(dtnode){$('#upload-package-dialog').data("dtnode",dtnode).dialog("open");},
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }               
                            }
                        },
                        "phyzixlabs-system-package":{
                            selector:".phyzixlabs-system-package",
                            items:
                            {
                                "delete":
                                {
                                    name:"Delete",
                                    exec:appletBuilder.deletePackage,
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }
                        },
                        "phyzixlabs-deployed-applet":{
                            selector:".phyzixlabs-deployed-applet",
                            items:
                            {
                                "undeploy":
                                {
                                    name:"Undeploy",
                                    exec:appletBuilder.undeployApplet,
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }
                        },
                        "phyzixlabs-applet-reviewqueue-applet":{
                            selector:".phyzixlabs-applet-reviewqueue-applet",
                            items:
                            {
                                "approve":
                                {
                                    name:"Approve",
                                    exec:appletBuilder.approveWidget,
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                                "reject":
                                {
                                    name:"Reject",
                                    exec:appletBuilder.rejectWidget,
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                             }
                        },
                        "phyzixlabs-applet-list-submitted-applet":{
                            selector:".phyzixlabs-applet-list-submitted-applet",
                            items:
                            {
                                "withdraw":
                                {
                                    name:"Withdraw",
                                    exec:appletBuilder.withdrawWidget,
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }
                        }/*,
                        "phyzixlabs-applet-list-rejected-applet":{
                            menu:"rejected-widget-menu",
                            actions:{
                                "edit":{exec:appletBuilder.editWidget},
                                "resumbit":{exec:appletBuilder.reSubmitWidget},
                                "delete":{exec:appletBuilder.deleteWidget}
                                }
                        },
                        "phyzixlabs-applet-list-prod-applet":{
                            menu:"prod-widget-menu",
                            actions:{
                                "delete":{exec:appletBuilder.undeployApplet}
                                }
                        }*/
                    };
                    
                    for(var key in this.contextMenuBindings){
                        $.contextMenu(this.contextMenuBindings[key]);
                    }                     
               }
};

