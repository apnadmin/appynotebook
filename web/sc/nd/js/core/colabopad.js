/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

       
var colabopad =null;        
var newApplet;
function initApp(embeded,embed_key,embed_width,embed_height){

           colabopad = {
                ContextMenus:ColabopadApplication.ContextMenus,
                MsgHandler:ColabopadApplication.MsgHandler,
                Physics:ColabopadApplication.Physics,
                Utility:ColabopadApplication.Utility,
                PageTemplate:ColabopadApplication.PageTemplate,
                Box2DWrapper:ColabopadApplication.Box2DWrapper,
                cart_context:null,
                ACCESS_MODE:{NONE:0,READ:1,WRITE:2,CREATE:4,DELETE:8,EMBED:16,ALTER_SECURITY:32},
                participant_context_list:[],
                offline_root_context_list:[],
                my_catalog_context_list:[],
                participant_list:[],
                page_load_callbacks:[],
                access_index:0,
                current_participant_context:null,
                room:null,
                user_id:user_id,
                room_id:room_id,
                baseUrl:baseUrl,
                page_screen_mode:page_screen_mode,
                following:0,
                nav_msg_queue:[],
                system_widgets:[],
                clipboard:null,
                lastActivatedElement:null,
                currentClipboardItem:null,
                lastContextMenuPoint:{x:0,y:0},
                embeded:embeded,
                new_cntx_pos:0,
                PAGE_HEIGHT:400,
                WIDGET_GAP:20,
                CHARACTER:{width:12,height:12},
                tab_controls:[],
                env:env,
                app_ready:0,
                workbench_loaded:0,
                ACL_EDIT_INDEX:3,
                GLOBAL_ACL_INDEX:0,
                queued_text:'',
                selected_node:{
                    user_id:0,
                    context_id:0
                },
                ui_components:
                {
                    layout:null,
                    participant_tabcontrol:null,
                    participant_treecontrol:null
                },
                page_templates:[
                                {name:"default",url:"page-templates/defaults/notepad-notebook-clean.svg?ts="+(new Date().getTime())},
                                {name:"text-editor",url:"page-templates/defaults/notepad-texteditor.svg?ts="+(new Date().getTime())},
                                {name:"graph-paper",url:"page-templates/defaults/notepad-graphpaper-A4-clean.svg?ts="+(new Date().getTime())},
                                {name:"plain-sheet",url:"page-templates/defaults/notepad-plain-clean.svg?ts="+(new Date().getTime())},
                                {name:"black-board",url:"page-templates/defaults/notepad-blackboard-clean.svg?ts="+(new Date().getTime())},
                                {name:"web-page",url:"page-templates/defaults/notepad-webpage.svg?ts="+(new Date().getTime())},
                                {name:"mit",url:"page-templates/custom/notepad-notebook-mit.svg?ts="+(new Date().getTime())},
                                {name:"njit",url:"page-templates/custom/notepad-notebook-njit.svg?ts="+(new Date().getTime())},
                                {name:"linux",url:"page-templates/custom/notepad-notebook-linux.svg?ts="+(new Date().getTime())},
                                {name:"usa",url:"page-templates/custom/notepad-notebook-usa.svg?ts="+(new Date().getTime())},
                                {name:"checkers",url:"page-templates/custom/notepad-notebook-checkersboard.svg?ts="+(new Date().getTime())},
                                {name:"chess",url:"page-templates/custom/notepad-notebook-chessboard.svg?ts="+(new Date().getTime())}
                                ],
                undo_stack:[],
                redo_stack:[],
                widgets:[],
                loadWidgetQueue:[],
                incomingWidgets:[],
                widgetControlPanelFrame:$('#widget-instance-control-panel'),
                widgetClassControlPanelFrame:$('#widget-class-control-panel'),
                editor_toolbar:$('#main-page-toolbar-container'),
                content_view_scrollpane:$("#content-view-scrollpane"),
                page_controlpanel:$("#page-controlpanel-holder"),
                message_queues:[{destination:"",id:"",handler:null}],
                active_top_tab_id:null,
                "default_tabview_size":{
                    "width":$("#inches_to_pixel").width()*8.7,
                    "height":$("#inches_to_pixel").width()*11
                },
                getEnv:function(){
                  return this.env;
                },
                getUserName:function(pid){
                  for(var i=0;i<this.room.participants.length;i++){
                      if(this.room.participants[i].id == pid)
                          return this.room.participants[i].name;
                  }return '';
                },
                addWidget:function(wg){
                    this.widgets.push(wg);
                },
                delWidget:function(){ 

                },
                widgetReady:function(widget){
                    //log('adding  widget:'+widget.getName())
                    this.addWidget(widget);
                    $.unblockUI();
                    
                    for(var i=0;i<this.loadWidgetQueue.length;i++){
                        if(this.loadWidgetQueue[i].classid == widget.getClassId() || this.loadWidgetQueue[i].classid == widget.getAppId()){
                            if(typeof this.loadWidgetQueue[i].forhelp != "undefined"){
                                widget.loadHelp();
                            }else
                            if(typeof this.loadWidgetQueue[i].args == "undefined"){
                                try{
                                    var  element_parent_node = this.getCurrentContext().active_pad.svg_doc.group(this.getCurrentContext().active_pad.content_root_svg);
                                    element_parent_node.setAttribute("class","note-element");                                    
                                    widget.onInstantiate(this.getCurrentContext().active_pad,undefined,element_parent_node);
                                }catch(ex){}
                            }else{
                                for(var j=0;j<this.loadWidgetQueue[i].args.length;j++){
                                    try{
                                        widget.onInstantiate(this.loadWidgetQueue[i].args[j].pad,this.loadWidgetQueue[i].args[j].element,this.loadWidgetQueue[i].args[j].parent_grp);
                                    }catch(ex){

                                    }
                                }
                            }this.loadWidgetQueue.splice(i,1);break;
                        }
                    }
                },
                showWidgetHelp:function(classid,env){
                    var widget = this.getWidget(classid, env);
                    if(widget == null){
                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" />Loading,please wait...</h1>'});
                        this.loadWidgetQueue.push({
                          classid:classid,
                          forhelp:true
                        });
                        //load widget
                        ColabopadApplication.importer.import_widget(classid,env);
                    }else{
                        widget.loadHelp();
                    }
                },
                newWidget:function(classid,env,callback){
                    if(this.getCurrentContext() == null || this.getCurrentContext().active_pad== null )return;
                    var pad = this.getCurrentContext().active_pad;

                    var write_access = (pad.access[0]&this.ACCESS_MODE.WRITE)>0 /*||(pad.context.access[0]&this.ACCESS_MODE.WRITE)>0*/ || (pad.access[2]&this.ACCESS_MODE.WRITE)>0 /*|| (pad.context.access[2]&this.ACCESS_MODE.WRITE)>0*/;
                    if(!write_access){
                        alert('Please request write access to this page from the owner');
                        return;
                    }

                    
                    var  element_parent_node = pad.svg_doc.group(pad.content_root_svg);
                    element_parent_node.setAttribute("class","note-element");
                    
                    //locate this widget class if it is available
                    for(var i=0;i<this.widgets.length;i++){                        
                        if(this.widgets[i].getClassId()==classid || this.widgets[i].getAppId()==classid){                           
                            if(this.widgets[i].getEnv()==env){
                                try{
                                    this.widgets[i].onInstantiate(pad,undefined,element_parent_node);
                                }catch(ex){

                                }
                                return;
                            }
                        }
                    }

                    $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" />Loading, please wait...</h1>'});
                    this.loadWidgetQueue.push({
                      classid:classid,
                      callback:callback
                    });

                    //load widget
                    ColabopadApplication.importer.import_widget(classid,env);
                },
                newWidgetInstance:function(widgetInstance,pad,access_control_list,callback){                   
                   
                   var config             = widgetInstance.config;
                   widgetInstance.dom     = typeof widgetInstance.svg_node != "undefined"?widgetInstance.svg_node:pad.svg_doc.group();
                   widgetInstance.pad     = pad;


                   if(embeded)
                       widgetInstance.config.header.deletable = false;

                   if(typeof pad.texteditor != "undefined" && this.queued_text != ''){
                        pad.texteditor.ckeditor.config.content = this.queued_text;
                        widgetInstance.config.content =  this.queued_text;
                        pad.texteditor.ckeditor.setData(this.queued_text);
                        pad.texteditor.ckeditor.resetDirty();
                        this.queued_text = '';
                   }
                   
                   if(typeof widgetInstance.config.transforms == "undefined"){
                        widgetInstance.config.transforms = {trslt:{x:0,y:0},rotate:{angle:0,cx:0,cy:0},scale:{x:1,y:1}};
                   }
                   if(typeof widgetInstance.config.dim == "undefined"){
                       widgetInstance.config.dim = {"x":0,"y":0,"w":0,"h":0};
                   }
         
                   //add to content blocks/***Resulting in infinite loop***/
                   //***pad.elements.push({config:widgetInstance.config});***/

                   var cx = Math.abs(config.transforms.trslt.x+(config.dim.x + (config.dim.w*config.transforms.scale.x)/2));
                   var cy = Math.abs(config.transforms.trslt.y+(config.dim.y + (config.dim.h*config.transforms.scale.y)/2));

                   //config.transforms.rotate.cx = cx;
                   //config.transforms.rotate.cy = cy;
                       
                   //save to database if necessary                   
                   if(typeof widgetInstance.config.dbid == "undefined" || widgetInstance.config.dbid == -1){
                       
                       if(typeof widgetInstance.access == "undefined"){
                            widgetInstance.access = [0,0,3,0];
                       }
                       if(typeof config.transforms.rotate.immutable == "undefined" || !config.transforms.rotate.immutable){
                          config.transforms.rotate.cx = cx;
                          config.transforms.rotate.cy = cy;
                       }
                       //element = {config:widgetInstance.config,dom:widgetInstance.svg_node};

                       this.persistElement(pad,widgetInstance,access_control_list,callback);
                       pad.elements.push(widgetInstance);
                   }else{
                        var element = this.findElement(pad,widgetInstance.config.dbid);
                        widgetInstance.access = element.access;
                        element.dom = widgetInstance.dom;
                        widgetInstance.id = element.id;
                        element.widget = widgetInstance.widget;
                        element.pad = pad;
                        
                        
                        if(typeof access_control_list == "function")
                            access_control_list(widgetInstance)
                        else
                        if(typeof callback == "function")
                            callback(widgetInstance);
                        
                   }



                   //this is ok here, this list does get reset on every page reload
                   /*
                   element.widget             = widgetInstance.widget;
                   element.dom.config         = element.config;
                   element.dom.element        = element;
                   element.cp                 = widgetInstance.cp;
                   element.dom.onmousedown    = this.onMousedownElement;
                   element.dom.onmouseup      = this.onMouseupElement;
                   element.dom.setAttribute("pointer-events","visible");
                   pad.widget_instances.push(element);
                   */
                   widgetInstance.dom.config          = widgetInstance.config;
                   widgetInstance.dom.element         = widgetInstance;
                   widgetInstance.dom.onmousedown     = this.onMousedownElement;
                   widgetInstance.dom.onmouseup       = this.onMouseupElement;
                   widgetInstance.dom.applet_instance = widgetInstance;
                   //widgetInstance.dom.setAttribute("pointer-events","visible");
                   pad.widget_instances.push(widgetInstance);

                   

                   pad.widget_ref_count--;
                   
                   if(pad.widget_ref_count == 0 && !pad.loading)
                       pad.visibly_loaded = true;

                   if(pad.visibly_loaded && !pad.cb_invoked){
                        pad.cb_invoked = true;
                        this.invokePageLoadCallBacks(pad,"newWidgetInstance");
                   }

                   
                   //perform necessary transformation on this widget
                   this.applyTransform(pad,widgetInstance,false);


                   if(widgetInstance.config.type == "widget" && typeof widgetInstance.widget.onScale != "undefined")
                        App_CallBack_Interface.async_onScale(pad, widgetInstance.widget,widgetInstance, {x:0,y:0},true);                           


                   if(widgetInstance.config.type == "widget" && typeof widgetInstance.widget.onTranslate != "undefined")
                        App_CallBack_Interface.async_onTranslate(pad, widgetInstance.widget,widgetInstance, {x:0,y:0},true);


                   if(widgetInstance.config.type == "widget" && typeof widgetInstance.widget.onRotate != "undefined")
                        App_CallBack_Interface.async_onRotate(pad, widgetInstance.widget,widgetInstance, 0,true);
                    
                    
                   var htmlView = widgetInstance.dom.firstChild != null && typeof widgetInstance.dom.firstChild != "undefined" && widgetInstance.dom.firstChild.nodeName.toLowerCase() == "foreignobject" && widgetInstance.dom.firstChild.getAttribute("class") == "html-view";
                   if(htmlView &&  (this.pen.mode == "move" || this.pen.mode == "resize" || this.pen.mode == "rotate")){
                       this.showAppAnnotationLayer(widgetInstance,"show");
                   }
                   //attach event handlers
                   
                   //pad.svg_doc.change(mw.svg_node,{"pointer-events":"visible"});
                   //mw.svg_node.onmouseover=this.onMouseOverWidget;
                   //mw.svg_node.onmouseleave =this.onMouseOutWidget;
                },
                addWidgetInstance:function(element,pad,parent_grp){
                    
                    //find this widget class if it has been loaded
                    for(var i=0;i<ColabopadApplication.widgets.length;i++){
                        if(ColabopadApplication.widgets[i].getClassId()==element.config.widget_class_id || ColabopadApplication.widgets[i].getAppId()==element.config.widget_class_id){
                            
                            if(element.config.env==ColabopadApplication.widgets[i].getEnv()){
                                try{                                    
                                    ColabopadApplication.widgets[i].onInstantiate(pad,element,parent_grp);
                                }catch(ex){

                                }
                                return;
                            }
                        }
                    }

                    
                    var queuedWidget = null;
                    //check to see if this widget is already being loaded by a previous request
                    for(i=0;i<this.loadWidgetQueue.length;i++){
                        if(this.loadWidgetQueue[i].classid == element.config.widget_class_id){
                            queuedWidget = this.loadWidgetQueue[i];break;
                        }
                    }
                    

                    //if it is being loaded, then just queue the arguments for this call without making another widget-load request
                    if(queuedWidget!=null){
                        if(typeof queuedWidget.args == "undefined"){
                            queuedWidget.args = [{element:element,pad:pad,parent_grp:parent_grp}];
                        }
                        else{
                            //debug('alt step 1:'+queuedWidget)
                            queuedWidget.args.push({element:element,pad:pad,parent_grp:parent_grp});
                        }
                    }else{
                        //debug('step 1:'+config.widget_class_id)
                        //if there is no pending load request for this widget, create one and queue the arguments
                        this.loadWidgetQueue.push({
                          classid:element.config.widget_class_id,
                          args:[{element:element,pad:pad,parent_grp:parent_grp}]
                        });
                        //log('widget:'+config.widget_class_id)
                        //load widget class
                        ColabopadApplication.importer.import_widget(element.config.widget_class_id,element.config.env);
                    }
                },
                getWidget:function(classid,env){
                    for(var i=0;i<this.widgets.length;i++){
                        if((this.widgets[i].getClassId()==classid || this.widgets[i].getAppId()==classid) && this.widgets[i].getEnv()==env){
                            return this.widgets[i];
                        }
                    }return null;
                },
                onWidgetMessage:function(classid,env,message){
                    var w  = this.getWidget(classid,env);
                    if(typeof w.onMessage != "undefined")
                        w.onMessage(message);
                },
                getFileServiceUrl:function(relativeURL)
                {
                     return imageServiceUrl+relativeURL;
                },
                getUploadImgBaseUrl:function()
                {
                    //if(this.env == 'dev')
                    //    return 'util/getimage.jsp?file_name=';
                    //else
                        //return baseUrl+'/util/getimage.jsp?file_name=';
                        return baseUrl+'/imageImporter/?file_name=';
                },
                prepareImagesForComposing:function(pad){
                    var images = [];
                    for(var i=0;i<pad.elements.length;i++){
                        var element = pad.elements[i];
                        if(element.config.type == 'image')
                        {
                          //var url = element.config.image.uploaded != undefined?this.getUploadImgBaseUrl()+element.config.image.url:element.config.image.url+'?ts='+(new Date().getTime());
                          images.push(element.config.image.url+','+(element.config.image.pos.x+element.config.transforms.trslt.x)+','+(element.config.image.pos.y+element.config.transforms.trslt.y)+','+element.config.image.pos.w+','+element.config.image.pos.h+','+element.config.transforms.rotate.angle+','+(element.config.image.uploaded != "undefined"));
                        }
                    }return images.join('|');
                },
                getItemById:function(id,list){
                  for(var i=0;i<list.length;i++){
                      if(list[i].id==id || (typeof list[i].config != "undefined" && list[i].config.dbid==id))
                          return list[i];
                  }return null;
                },
                addPageLoadCallBack:function(id,fn,restrict_to){
                    this.page_load_callbacks.push({id:id,fn:fn,restrict_to:typeof restrict_to != "undefined"?restrict_to:-1});
                },
                removePageLoadCallBack:function(id){
                    
                  for(var i=0;i<this.page_load_callbacks.length;i++){
                      if(this.page_load_callbacks[i].id == id){
                          //debug('removing export callback')
                          return this.page_load_callbacks.splice(i,1)[0];
                      }
                  }return null;
                },
                invokePageLoadCallBacks:function(page,from){
                  //  if(from != undefined)
                  //debug('invoked from :'+from+" count:"+this.page_load_callbacks.length)

                  for(var j=0;j<this.page_load_callbacks.length;j++){
                      //debug('loop:'+j+' '+this.page_load_callbacks.length)
                      if(this.page_load_callbacks[j].restrict_to == -1)
                      {
                         this.page_load_callbacks[j].fn(page);
                         //ColabopadApplication.onPageReadyForExport(page);
                      }
                      else
                      if(this.page_load_callbacks[j].restrict_to == page.id){
                          //debug("restricted invocation"+j)
                          this.page_load_callbacks[j].fn(page);
                          //ColabopadApplication.onPageReadyForExport(page)
                          return;
                      }
                  }
                },
                curSinkPad:null,
                _npSettings:{
                       /*"xmlns:ns":"http://creativecommons.org/ns#",
                       "xmlns:dc":"http://purl.org/dc/elements/1.1/",
                       "xmlns:cc":"http://web.resource.org/cc/",
                       "xmlns:rdf":"http://www.w3.org/1999/02/22-rdf-syntax-ns#",*/
                       "xmlns":"http://www.w3.org/2000/svg",
                       "xmlns:ev":"http://www.w3.org/2001/xml-events",
                       "xmlns:svg":"http://www.w3.org/2000/svg",                       
                       //"xmlns:xlink":"http://www.w3.org/1999/xlink",
                       //"xmlns:sodipodi":"http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd",
                       //"xmlns:inkscape":"http://www.inkscape.org/namespaces/inkscape",
                       //"width":"8.5in",//74.25em
                       "width":$("#inches_to_pixel").width()*8.5,
                       "height":$("#inches_to_pixel").width()*11/*"11in"*/,
                       "id":"svg2342"/*,
                       "sodipodi:version":"0.32",
                       "inkscape:version":"0.45.1",
                       "sodipodi:docbase":"",
                       "sodipodi:docname":"notepad.svg",
                       "inkscape:output_extension":"org.inkscape.output.svg.inkscape"*/
                 },
                _createUILayout:function(){
                    /**
                    this.ui_components.layout =
                    $('body').layout({"applyDefaultStyles": true,
                                      "west__size":'auto',
                                      "west__minSize":300,
                                      "zIndex":0/*,
                                      "showOverflowOnHover":true*});
                    this.ui_components.layout.center = $('#layout-center'); */
                    this.ui_components.layout = {center : $(document)};
                 },
                _createParticipantTabControl:function(){
                    
                   if(typeof phyzixlabs_database != "undefined"){
                       $("#participant-tabcontrol-headers").css({"display":"none"});
                       //return;
                   }
                   
                   var _this = this;
                   this.ui_components.participant_tabcontrol=
                   $('#participant-tabcontrol').css("display","block").tabs({
                   tabTemplate:'<li><a href="#{href}">#{label}</a><span class="ui-icon ui-icon-close" style="float:left;margin: 0.4em 0.2em 0 0; cursor: pointer">Remove Tab</span></li>',
                   show:this.onShowParticipantContextTab,
                   create:function(){
                         if(typeof phyzixlabs_database == "undefined"){
                            $('#appStoreHomePage').attr("src","../../app-store/index.jsp?width="+$('#participant-tabcontrol-tabs').width());
                            $('#appStoreHomePage').attr("width",$('#participant-tabcontrol-tabs').width());
                            $('#appStoreHomePage').attr("height",$(window).height());         
                            $('#appStoreHomePage').attr("scrolling","auto");
                         }
                   }}).css({"width":this.default_tabview_size.width})/*.resizable({"handles":"e,s,se",
                   "start":function(event,ui){
                       //$("#inches_to_pixel").width()
                   },
                   "stop":function(event,ui){
                       var page = ColabopadApplication.getCurrentContext().active_pad;
                       var scaleX = ((ui.size.width-ui.originalSize.width)/ui.originalSize.width);
                       var scaleY = ((ui.size.height-ui.originalSize.height)/ui.originalSize.height);
                       var sizeScale = typeof page.size_scale != "undefined"?page.size_scale:{"x":1,"y":1};
                       sizeScale.x += scaleX;
                       sizeScale.y += scaleY;
                       
                       _this.updatePad(page, {header:page.header,title:page.title,template:page.template.name,queue_url:page.queue_url,"size_scale":sizeScale});
                       
                       
                       $(page.div_dom).width(_this._npSettings.width*sizeScale.x);
                       $(page.div_dom).height(_this._npSettings.height*sizeScale.y);
                       
                       page.svg_doc.change( page.svg_doc.root(),{"width":_this._npSettings.width*sizeScale.x,"height":_this._npSettings.height*sizeScale.y})
                       
                       log("("+scaleX+","+scaleY+") height:"+(_this._npSettings.height)+" sy:"+sizeScale.y);
                   }})*/;
                },
                _createParticipantTreeControl:function(nodes){
                    var _this = this;
                    this.ui_components.participant_treecontrol=
                    $("#participant-treecontrol").dynatree({
                              imagePath: "./",
                              rootVisible:false,
                              minExpandLevel:typeof phyzixlabs_database == "undefined"?2:2,
                              children:nodes,
                              persist:false,
                              //initAjax: {url: "tree.jsp?room_id="+room_id},
                              onPostInit:function(isReloading, isError){
                                  //log("onPostInit")
                                  if(_this.workbench_loaded++ == 1)
                                    _this.workworkbench_callback();
                                 
                                  this.reactivate();
                              },//
                              onExpand:function(){                                  
                                  ColabopadApplication.ContextMenus.bindColabopadContextMenu();
                              },
                              onActivate: function(dtnode) {
                                  
                                $("#participant-treecontrol ul").css({"overflow":"hidden"});
                                //log("activating node:"+dtnode.data.url)
                                if(dtnode.data.type == 'inactive-room'){
                                    window.location.href = dtnode.data.url;
                                }
                                else
                                if(dtnode.data.type == 'pad'){                                    
                                    ColabopadApplication.setUpView(dtnode.data.pid,dtnode.data.context_id, dtnode.data.id,"page-click");
                                }
                                else
                                if(dtnode.data.type == 'offline-pad'){                                    
                                    ColabopadApplication.setUpOfflineView(dtnode.data.rid,dtnode.data.cntx_id, dtnode.data.id,"page-click");
                                }
                                else
                                if(dtnode.data.type == 'cart-pad'){
                                    ColabopadApplication.setUpCartView(dtnode.data.rid,dtnode.data.cntx_id, dtnode.data.id,"page-click");
                                }
                                else
                                if(dtnode.data.type == 'my-catalog-pad'){
                                    ColabopadApplication.setUpMyCatalogView(dtnode.data.rid,dtnode.data.cntx_id, dtnode.data.id,"page-click");
                                }
                              },
                              onDeactivate: function(dtnode) {
                                //$("#echoActive").text("-");
                              }/*,
                              onClick: function(dtnode, event) {
                                
                                // Eat keyboard events, while a menu is open
                                if( $(".contextMenu:visible").length > 0 )
                                  return false;
                              }*/,
                              onKeydown: function(dtnode, event) {
                                // Eat keyboard events, when a menu is open
                                if( $(".contextMenu:visible").length > 0 )
                                  return false;

                                  switch( event.which ) {

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
                                  }
                              },
                            dnd:
                                {
                                onDragStart: function(node) {
                                    
                                    if(node.data.type == 'pad'){
                                        
                                        //log('draging...')
                                        return true;
                                    }
                                    return false;
                                },
                                onDragStop: function(node) {
                                // This function is optional.
                                //logMsg("tree.onDragStop(%o)", node);
                                },
                                //autoExpandMS: 1000,
                                preventVoidMoves: true, // Prevent dropping nodes 'before self', etc.
                                onDragEnter: function(node, sourceNode) {
                                    
                                    if(sourceNode.data.type == 'pad' && node.data.type == 'pad' && sourceNode.data.pid == node.data.pid && sourceNode.data.context_id == node.data.context_id){
                                        
                                        return true;
                                    }
                                    
                                    if(node.data.type == 'phyzixlabs-resource-dir'){
                                        //return (sourceNode.data.type == 'phyzixlabs-resource-dir' || sourceNode.data.type == 'phyzixlabs-resource-file')
                                        if(sourceNode.data.type == 'phyzixlabs-resource-dir' || sourceNode.data.type == 'phyzixlabs-resource-file')
                                        {                                      
                                            return ["over"];
                                        }
                                    }
                                    return false;
                                },
                                onDragOver: function(node, sourceNode, hitMode) {
                                    if(sourceNode.data.type == 'pad' && node.data.type == 'pad' && sourceNode.data.pid == node.data.pid && sourceNode.data.context_id == node.data.context_id){
                                        
                                        return true;
                                    }return false;                                    
                                },
                                onDrop: function(node, sourceNode, hitMode, ui, draggable) {
                                    if(sourceNode.data.type == 'pad' && node.data.type == 'pad' && sourceNode.data.pid == node.data.pid && sourceNode.data.context_id == node.data.context_id){
                                        var page = null
                                        var parent_id   = sourceNode.getParent().data.type == "pad"?sourceNode.getParent().data.id:0;
                                        var pre_sibling = 0;
                                        var srcPage = _this.getContextPage(sourceNode.data.pid,sourceNode.data.context_id,sourceNode.data.id);
                                        
                                        //update the pointer to this node
                                        if(sourceNode.getNextSibling() != null){
                                            page = _this.getContextPage(sourceNode.getNextSibling().data.pid,sourceNode.getNextSibling().data.context_id,sourceNode.getNextSibling().data.id);
                                            if(sourceNode.getPrevSibling() != null){
                                                _this.updatePadPreSibling(page,sourceNode.getPrevSibling().data.id);
                                            }else{
                                                _this.updatePadPreSibling(page,0);
                                            }
                                        }
                                        
                                        
                                        
                                        
                                        
                                        if(hitMode == "after"){
                                            
                                            //update pointer to this node
                                            if(node.getNextSibling() != null){
                                                page = _this.getContextPage(node.getNextSibling().data.pid,node.getNextSibling().data.context_id,node.getNextSibling().data.id);
                                                _this.updatePadPreSibling(page,sourceNode.data.id);
                                            }
                                            pre_sibling = node.data.id;
                                            
                                            
                                            //update parent id
                                            if(sourceNode.getParent().data.type != node.getParent().data.type || 
                                                sourceNode.getParent().data.id != node.getParent().data.id){
                                                
                                                
                                                if(node.getParent().data.type == "pad")
                                                    parent_id   = node.getParent().data.id;
                                                else
                                                    parent_id   = 0;
                                            }
                                        }
                                        else
                                        if(hitMode == "before"){
                                            
                                            //update pointer to this node
                                            page = _this.getContextPage(node.data.pid,node.data.context_id,node.data.id);
                                            
                                            _this.updatePadPreSibling(page,sourceNode.data.id);
                                            
                                            
                                            //update pointer to this node
                                            if(node.getPrevSibling() != null)
                                                pre_sibling = node.getPrevSibling().data.id;

                                            //update parent id
                                            if(sourceNode.getParent().data.type != node.getParent().data.type || 
                                                sourceNode.getParent().data.id != node.getParent().data.id){
                                                
                                                if(node.getParent().data.type == "pad")
                                                    parent_id   = node.getParent().data.id;
                                                else
                                                    parent_id   = 0;
                                            }                                        
                                        }
                                        else
                                        if(hitMode == "over"){
                                            parent_id = node.data.id;
                                            if(node.hasChildren()){
                                                var curLastNode = node.getChildren()[0];
                                                while(curLastNode.getNextSibling() != null)
                                                    curLastNode = curLastNode.getNextSibling(); 
                                                
                                                pre_sibling = curLastNode.data.id;
                                            }
                                        }
                                        
                                        
                                        if(sourceNode.hasChildren()){
                                           _this.confirmPageMove = function(movetype){
                                                //confirm type of move, children only or node
                                                if(movetype == "children"){
                                                    
                                                    
                                                    var siblingNode = sourceNode.getChildren()[0];
                                                    while(siblingNode != null){    
                                                        var saveNextNode = siblingNode.getNextSibling();
                                                        var lastNode = siblingNode;
                                                        siblingNode.move(node, hitMode);
                                                        siblingNode = saveNextNode;   
                                                    }
                                                    
                                                    //set last child as the preceeding node
                                                    page = _this.getContextPage(node.data.pid,node.data.context_id,node.data.id);
                                                    _this.updatePadPreSibling(page,lastNode.data.id);                                                    
                                                    
                                                    
                                                    _this.movePad(srcPage,parent_id,pre_sibling,'yes');
                                                }else{
                                                    _this.movePad(srcPage,parent_id,pre_sibling,'no');
                                                    sourceNode.move(node, hitMode);                                                    
                                                }
                                           }
                                           $("#dialog-confirm-page-move").dialog("open");
                                        }else{
                                            _this.movePad(srcPage,parent_id,pre_sibling,'no');
                                            sourceNode.move(node, hitMode);
                                        }
                                        return true;
                                    }
                                        return false;
                                    
                                    // expand the drop target
                                    //node.expand(true);
                                },
                                onDragLeave: function(node, sourceNode) {
                                    if(sourceNode.data.type == 'pad' && node.data.type == 'pad' && sourceNode.data.pid == node.data.pid && sourceNode.data.context_id == node.data.context_id){
                                        
                                        return true;
                                    }return false;                                     
                                }
                            }
                     });
                     this.ui_components.participant_treecontrol= $("#participant-treecontrol").dynatree('getTree');
                },
               _loadAssignments:function(){

               },
               _loadAllRooms:function(dtnode,cb){
                    $.ajax({
                        type:'POST',                        
                        url:'/RoomAction.do?action=get-rooms-json',
                        success:function(data){
                            var reply = eval('('+data+')');
                            for(var i=0;i<reply.rooms.length;i++){
                                if(reply.rooms[i].id != room_id){
                                    var turl = 'index.jsp?room_id='+reply.rooms[i].id+'&ts='+new Date().getTime();
                                    roomNodeData = {addClass:'phyzixlabs-room-inactive',type:'inactive-room',title:reply.rooms[i].title,url:turl};
                                    dtnode.addChild(roomNodeData);
                                }
                            }cb();
                        }
                    });
               },
                checkUserStatus:function(){
                   $.ajax({
                            type:'POST',
                            url:'/UserAction.do?action=get-user-status',
                            success:function(data){
                                var reply = eval('('+data+')');
                                if(reply.status == "active-auto-user"){
                                     $("#prev-pg-button").qtip({
                                        content: "You are using a demo account, <b><a href=\"#\" onclick=\"ColabopadApplication.createSettingsView('user-profile-tab')\">switch<a/></b> to a personal account by changing your login email.", // Set the tooltip content to the current corner
                                        position: {
                                            corner: {
                                                tooltip: 'topRight', // Use the corner...
                                                target: 'bottomLeft' // ...and opposite corner
                                            }
                                        },
                                        show: {
                                            when: false, // Don't specify a show event
                                            ready: true // Show the tooltip when ready
                                        },
                                        hide: false, // Don't specify a hide event
                                        style: {
                                            border: {
                                                width: 5,
                                                radius: 10
                                            },
                                            padding: 10, 
                                            textAlign: 'center',
                                            tip: true, // Give it a speech bubble tip with automatic corner detection
                                            name: 'cream' // Style it according to the preset 'cream' style
                                        }
                                    });
                                }
                            }
                    });
                },
               _loadData:function(callback){
                    var roomObj   = null;
                    var workBench = null;
                    var treeObj   = null;
                    if(typeof phyzixlabs_database == "undefined"){
                        $.ajax({
                            type:'POST',
                            data:{room_id:room_id},
                            url:'/PadUIAction.do?action=load-room',
                            success:function(data){

                                roomObj = eval('('+data+')');
                                if(treeObj != null && workBench != null)
                                    callback(roomObj,workBench,treeObj);
                            }
                        });
                        $.ajax({
                            type:'POST',
                            data:{participant_id:this.user_id,room_id:room_id},
                            url:'/PadUIAction.do?action=load-workbench',
                            success:function(data){

                                workBench = eval('('+data+')');
                                if(roomObj != null && treeObj != null)
                                    callback(roomObj,workBench,treeObj);
                            }
                        });                    
                        $.ajax({
                            type:'POST',
                            data:{room_id:room_id},
                            url:'tree.jsp?action=load-room',
                            success:function(data){

                                treeObj = eval('('+data+')');
                                if(workBench != null && roomObj != null)
                                    callback(roomObj,workBench,treeObj);
                            }
                        });
                    }else{
                        callback(phyzixlabs_database.defaultRoomObject,[phyzixlabs_database.defaultWorkBench],phyzixlabs_database.buildTreeView());
                    }
                },
               _loadRoom:function(reply,workBench){
                    var _this = this;
                            
                    var room = {id:reply.id,title:reply.title,creator:reply.creator,participants:[]};
                    ColabopadApplication.room = room;

                    //add room header node
                    //var roomHeaderNodeData = {isFolder:true,addClass:'phyzixlabs-room-root',key:'room_header_root', title:'Your Rooms',type:'header'};
                    //var roomHeaderNodeRoot = _this.ui_components.participant_treecontrol.getRoot().getChildren()[0]/*.addChild(roomHeaderNodeData)*/;
                    //var node = {isFolder:true,isLazy:false,children:[],addClass:'vroomtitle',key:'room_header', title:reply.title,type:'header'};
                    /***_this.room_header_node = roomHeaderNodeRoot.addChild(node);**/


                    var done = function(){
                        for(var i=0;i<reply.participants.length;i++){
                            var participant = reply.participants[i];
                            room.participants.push({id:participant.id,name:participant.name,photo:participant.photo,on_line:false});
                            _this._addParticipantToRoom('offline',participant,true);
                        }
                        ColabopadApplication.ContextMenus.bindColabopadContextMenu();

                        ColabopadApplication._loadWorkBench(workBench);

                        if(room.creator == _this.user_id && typeof phyzixlabs_database == "undefined"){
                            $('#add-participant-btn').css("display","inline");
                            $( "#add-participant-btn" ).css("display","inline").button({
                                    text: false,
                                    icons: {
                                            primary: "ui-icon-person"
                                    }
                            });
                            $('#add-participant-btn').menu({content: $('#phyzixlabs-add-participant-menu').html()});
                            $('#phyzixlabs-add-participant-menu').remove();
                        }
                        var listener = {
                                        id:'colabopad-listener'+room_id,
                                        destination:app_queue_url,
                                        rcvMessage:ColabopadApplication.appMsgHandler
                                        };
                        ColabopadApplication.MsgHandler.registerListener(listener);



                        //listen for touchscreen use as input device
                        /*listener = {
                                    id:'colabopad-mouse-listener',
                                    destination:mouse_event_queue_url,
                                    rcvMessage:ColabopadApplication.remoteMouseMsgHandler
                                    };
                        ColabopadApplication.MsgHandler.registerListener(listener);
                        */
                        setTimeout(function(){
                        ColabopadApplication.MsgHandler.sendMessage({to:app_queue_url,message:{sender_id:sessionId,pid:ColabopadApplication.user_id,type:'sign-on'}})},
                        5000);

                        ++_this.app_ready;
                        if(_this.app_ready == 2)//unblock app loading,not perfect but...
                        {
                            $.unblockUI();
                            $('#main-overlay').removeClass('ui-widget-overlay');
                            _this.checkUserStatus();
                        }
                        //sync with any remote tablet interface
                        //ColabopadApplication.MsgHandler.sendMessage({to:mouse_event_queue_url,message:{sender_id:'real',type:'sign-on'}});

                        //load premium catalog if this is an educator
                        /****
                        if(isCreator)
                            _this._loadPremiumCatalog();
                        ***/
                    };
                    done();

                    //ColabopadApplication._loadAllRooms(roomHeaderNodeRoot,done);
                },
                _addParticipantToRoom:function(online_status,participant,skipnode){
                    var nodeClass = '';
                    if(this.user_id == this.room.creator){
                        //if this user is the room creator and this is their own name being added
                        if(participant.id == this.user_id){
                            nodeClass = 'creatoronlineperson';
                        }else{
                            //creator control panel menu for the room creator
                            nodeClass = online_status=='online'?'onlineperson-creator-cp':'offlineperson-creator-cp';
                        }
                    }else{
                        if(participant.id == this.user_id){
                            nodeClass = 'selfonlineperson';
                        }else{
                            nodeClass = online_status=='online'?'onlineperson':'offlineperson';
                        }
                    }
                    var node = {isFolder:true,addClass:nodeClass,key:'key-'+participant.id,id:participant.id,title:participant.name,type:'participant'};
                    //this.room_header_node.append(node);
                    if(typeof(skipnode) == "undefined")
                        this.ui_components.participant_treecontrol.getNodeByKey('room_header_root').append(node);
                },
                total_page_count:0,
                /*current_participant_context:null,*/
                _loadWorkBench:function(reply){
                    var _this = this;
                    //debug('access('+data+')')

                    
                    for(var i=0;i<reply.length;i++){
                        var part_cntx = {id:reply[i].id,context_list:[],current_context:null,tab:null,selected:false};

                        for(var j=0;j<reply[i].contexts.length;j++){
                            var cntx = reply[i].contexts[j];
                            _this.initContext(part_cntx,cntx, true,true);
                        }

                        part_cntx.current_context = part_cntx.context_list.length>0?part_cntx.context_list[0]:null;
                        ColabopadApplication.participant_context_list.push(part_cntx);

                        if(reply[i].id == _this.user_id)
                            _this.current_participant_context = part_cntx;
                    }
                    
                    
                    if(_this.firstActivePage == null)//if there are no pages
                    {
                       _this.forceReady();      
                    }
                       
                    
                    
                    //alert('wait')
                    _this.workworkbench_callback = function(){
                    ColabopadApplication.ContextMenus.bindWorkbookPageContextMenu();
                    ColabopadApplication.ContextMenus.bindWorkbookContextMenu("workbookMenu-me");

                    ColabopadApplication.ContextMenus.setUpContextMenuBindings();

                    if(_this.current_participant_context != null){


                        //show tab for this participant
                        //_this.initParticipantContext(current_participant_context);

                        //ColabopadApplication.setCurrentParticipantContext(current_participant_context);

                        if(_this.current_participant_context.context_list.length>0 || 
                            typeof appynoteLandingPage != "undefined"|| 
                            typeof load_embeded_page != "undefined"){

                            //show tab for context
                            //_this.initContextTab(current_participant_context.context_list[0]);

                            //_this.setCurrentContext(current_participant_context.context_list[0]);


                            //load the first page of this participant's first context
                            if(typeof appynoteLandingPage != "undefined"|| 
                                typeof load_embeded_page != "undefined"||
                                _this.firstActivePage != null){

                                if(typeof load_embeded_page == "undefined"){
                                    var key =     typeof appynoteLandingPage != "undefined"?'key-'+appynoteLandingPage.participant_id+'-'+appynoteLandingPage.context_id+'-'+appynoteLandingPage.page_id:'key-'+_this.firstActivePage.context.pid+'-'+_this.firstActivePage.context_id+'-'+_this.firstActivePage.id;
                                    
                                   
                                    //if(typeof appynoteLandingPage != "undefined")
                                    //        $("#participant-treecontrol").dynatree('getTree').activateKey(key);
                                    if(typeof appynoteLandingPage == "undefined"){
                                        var binderkey =     'key-'+_this.firstActivePage.context.pid+'-'+_this.firstActivePage.context_id;
                                        var firstBinderNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(binderkey);
                                        if( !(firstBinderNode.hasChildren() === false)){
                                            firstBinderNode.getChildren()[0].activate();
                                        }
                                    }else{
                                        $("#participant-treecontrol").dynatree('getTree').activateKey(key);
                                    }
                                }
                                else{
                                    _this.setCurrentParticipantContext(_this.current_participant_context);
                                    //no contexts
                                    _this.initParticipantContextTab(_this.current_participant_context);                                            
                                    _this.loadEmbededPage(load_embeded_page);
                                    //$.unblockUI();
                                }
                                //set active pad
                                //current_participant_context.context_list[0].active_pad = current_participant_context.context_list[0].pages[0];
                            }
                            else
                            {
                                _this.setCurrentParticipantContext(_this.current_participant_context);
                                //no contexts
                                _this.initParticipantContextTab(_this.current_participant_context);

                                _this.setCurrentContext(_this.current_participant_context.context_list[0]);
                                //no pages
                                _this.initContextTab(_this.current_participant_context.context_list[0]);
                            }
                        }else{
                            _this.setCurrentParticipantContext(_this.current_participant_context);
                            //no contexts
                            _this.initParticipantContextTab(_this.current_participant_context);

                            _this.newWorkbookImpl('Binder1',false,true);                             
                        }
                    }else{
                        //no participants in this room, this should be impossible
                    }
                    };if(_this.workbench_loaded++ == 1)_this.workworkbench_callback();
                },
                _loadToolBar:function(){
                    $('#pencolorPicker').makeColorPicker();
                    //$('#clip-colors-select').colorpicker({size: 20,hide: true});
                    //$('#penColor').colorPicker();

                    this.pen.color = $('#pencolorPicker').attr("value")
                    $('#pencolorPicker').change(this.setPenColor);
                    //$("#penWidthCtrl").msDropDown();
                    $('button.toolbar-button').hover(
                        function(){
                            $(this).addClass("ui-state-hover");
                        },
                        function(){
                            $(this).removeClass("ui-state-hover");
                        }
                    );

                     $('#undo_btn,#redo_btn').attr("disabled","disabled");
                },
                _loadMainMenu:function(){
                    
                    var _this = this;
                    
                    function resetToolbox(){
                        //log('resetToolbox');
                        if(ColabopadApplication.getCurrentContext() != null && 
                           ColabopadApplication.getCurrentContext().active_pad != null &&
                           ColabopadApplication.getCurrentContext().active_pad.div_dom != null){
                            var p = ColabopadApplication.getCurrentContext().active_pad.div_dom.offset();
                            var w = ColabopadApplication.getCurrentContext().active_pad.div_dom.width();
                            var sct=ColabopadApplication.ui_components.layout.center.scrollTop();

                            $('#floating-toolbox-toolbar').css({"left":p.left+w+20});            
                        }
                    }                    
                    
                    $('#collapse-sidebar-button').removeAttr("disabled").button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-minusthick"
                            }
                    }).css("display","inline").click(function(){
                       $('#ui_center_pane').css("float","left");
                       
                       $('#left-sidebar-panel').hide('slide',function(){
                           $('#expand-sidebar-button').css("display","inline"); 
                           resetToolbox();
                       });      
                       _this.resizeView();
                    });
                    
                                   
                    $('#expand-sidebar-button').removeAttr("disabled").button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-plusthick"
                            }
                    }).click(function(){
                       $('#ui_center_pane').css("float","right");
                        
                       var r = $('#floating-toolbox-toolbar').css("display") != 'none';                       
                       $('#floating-toolbox-toolbar').css("display","none");
                       
                       $('#expand-sidebar-button').css("display","none");
                       $('#left-sidebar-panel').show('slide',function(){
                           _this.resizeView();
                           if(r){
                               resetToolbox();
                               $('#floating-toolbox-toolbar').css("display","block");
                           }
                       });
                    });                    
                    
                    
                    $("#phyzixlabs-export-pdf-button,#phyzixlabs-export-svg-button").removeAttr("disabled");
                    if(typeof phyzixlabs_database != "undefined"){
                        
                        $('#new-binder-button').removeAttr("disabled").button({
                                text: false,
                                icons: {
                                        primary: "ui-icon-folder-open"
                                }
                        }).css("display","inline").click(function(){
                            ColabopadApplication.dialogOpenFrom = "normal";
                            $('#book-dialog').dialog('open');
                        });
                        
                        $("#phyzixlabs-export-png-button").css("display","none");
                        
                        $(".image-dialog-hide-row").css("display","none");
                        
                        $('#bummy-panel-btn').attr("disabled","disabled").css("display","inline").button({text:false,icons:{primary:'ui-icon-refresh'}});                        
                        
                        this.refreshApps();
                        return;
                    }
                    /*$("#colabopadMenus").buildMenu({
                        template:"menus/file/main-menu.jsp",
                        additionalData:"pippo=1",
                        menuWidth:200,
                        openOnRight:false,
                        menuSelector: ".menuContainer",
                        iconPath:"./",
                        hasImages:true,
                        fadeInTime:100,
                        fadeOutTime:300,
                        adjustLeft:2,
                        minZindex:"auto",
                        adjustTop:10,
                        opacity:.95,
                        shadow:true,
                        closeOnMouseOut:false,
                        closeAfter:1000
                     });*/



                    $('#workspace-help-button').button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-help"
                            }
                    }).css("display","inline").click(function(){
    
                    }).removeAttr("disabled");  

                    if($('#phyzixlabs-developer-menu').length){
                        $.ajax({
                            type:'POST',
                            data:{},
                            url:'menus/developer-menu.jsp',
                            success:function(data){

                                $('#phyzixlabs-developer-menu').menu({content: data,
                                                           /*flyOut: true ,*/                                                           
                                                           directionV:true,
                                                           crumbDefaultText: ' '});

                            }
                        });
                    }
                        $.ajax({
                            type:'POST',
                            data:{},
                            url:'menus/room-list.jsp?room_id='+room_id,
                            success:function(data){
                                $('#view-rooms-btn').menu({content: data});
                            }
                        });

                    $('#user-applet-holder-header #add-new-btn').css("display","inline").button({text:false,icons:{primary:'ui-icon-plus'}}).click(function(){
                        //ColabopadApplication.app_store_url = "/app-store/?fr=t";
                        $('#app-store-dialog').dialog("open");
                        //$('#participant-tabcontrol').tabs("select",0);
                    });
                    $('#user-applet-holder-header #refresh-apps-btn').css("display","inline").button({text:false,icons:{primary:'ui-icon-refresh'}}).click(function(){
                        ColabopadApplication.refreshApps();
                    });
                    this.refreshApps();
                },
                displayAppPanel:function(apps){
                    var rowCount  = 0;
                    var rowLength = 5;
                    
                    var buf = ['<table style="table-layout:fixed;">'];
                    
                    var numCells = parseInt(Math.ceil(apps.length/rowLength))*rowLength;
                    for(var i=0;i<numCells;i++){
                        if( (i%rowLength) == 0){
                            buf.push("<tr>");
                        }
                        
                            if(i<apps.length && apps[i].showInMenu == "Yes"){
                                buf.push("<td style=\"width:20%;border-style:none;vertical-align:top;text-align:center\"><div style=\"height:64px;overflow:hidden\"><button class=\"applet-button\" title=\""+apps[i].name+"\" value=\""+apps[i].id+"\" ><img onerror=\"this.src='images/misc/application-default-icon.png';this.onerror='';\" src=\""+this.importer.get_full_local_content_url('favicon.png',apps[i].id,'prod')+"\" style=\"border:none;width:16px;height:16px\"/></button><br><span>"+apps[i].name+"</span></div></td>");
                            }
                            else
                                buf.push("<td style=\"width:20%\"></td>");
                                
                        if( (((i+1)%rowLength) == 0))
                            buf.push("</tr>");
                    }                    
                    buf.push('</table>');
                    
                    
                    $('#user-applet-holder #app-panel').empty().append(buf.join(""));
                    $('#user-applet-holder .applet-button').button({text:false}).click(function(){
                        ColabopadApplication.newWidget($(this).val(),'prod');
                    });                    
                },
                refreshApps:function(){
                    var _this = this;
                    
                    if(typeof phyzixlabs_database != "undefined"){
                        phyzixlabs_database.getInstalledApps(function(apps){
                            _this.displayAppPanel(apps);
                        });
                    }else{
                        $.ajax({
                            type:'POST',
                            data:{room_id:room_id},
                            url:'menus/user_applets.jsp',
                            success:function(data){
                                _this.displayAppPanel(eval('('+data+')'));
                            }
                        });
                    }
                },
                reloadEditorToolBar:function(panel){
                    
                    $.ajax({
                        type:'POST',
                        data:{},
                        url:'ui-component-markups/toolbar.jsp',
                        success:function(data){
                            
                            $(panel).html(data);
                            
                            /*
                            $("#main-page-toolbar").buildMenu(
                            {
                                template:"menus/toolbar-menus.jsp",
                                additionalData:"pippo=1",
                                menuWidth:200,
                                openOnRight:false,
                                menuSelector: ".menuContainer",
                                iconPath:"./",
                                hasImages:true,
                                fadeInTime:100,
                                fadeOutTime:300,
                                adjustLeft:2,
                                minZindex:"auto",
                                adjustTop:10,
                                opacity:.95,
                                shadow:true,
                                closeOnMouseOut:false,
                                closeAfter:1000
                             });
                             */
                            
                            $.ajax({
                                type:'POST',
                                data:{},
                                url:'menus/developer-menu.jsp',
                                success:function(data){

                                    $('#phyzixlabs-developer-menu').menu({content: data,
                                                               /*flyOut: true ,*/
                                                               directionV:true,
                                                               crumbDefaultText: ' '});

                                }
                            });
                        }
                    });
                },
                _loadNewPageMenu:function(){
                    /*$("#new-pg-button").buildMenu(
                    {
                        template:"menus/new-page.jsp",
                        additionalData:"pippo=1",
                        menuWidth:200,
                        openOnRight:false,
                        menuSelector: ".menuContainer",
                        iconPath:"./",
                        hasImages:true,
                        fadeInTime:100,
                        fadeOutTime:300,
                        adjustLeft:2,
                        minZindex:"auto",
                        adjustTop:10,
                        opacity:.95,
                        shadow:true,
                        closeOnMouseOut:false,
                        closeAfter:1000
                     });*/
                },
                _loadToolbarMenus:function(){
                    /*$("#main-page-toolbar").buildMenu(
                    {
                        template:"menus/toolbar-menus.jsp",
                        additionalData:"pippo=1",
                        menuWidth:200,
                        openOnRight:false,
                        menuSelector: ".menuContainer",
                        iconPath:"./",
                        hasImages:true,
                        fadeInTime:100,
                        fadeOutTime:300,
                        adjustLeft:2,
                        minZindex:"auto",
                        adjustTop:10,
                        opacity:.95,
                        shadow:true,
                        closeOnMouseOut:false,
                        closeAfter:1000
                     });*/
                },
                 dialogOpenFrom:"",
                _loadDialogs:function(){
                    var _this = this;
                    $('#book-dialog').dialog({
                        autoOpen: false,
                        width: 250,
                        height:120,
                        modal:false,
                        buttons: {
                                "Ok": function() {
                                    $(this).dialog("close");
                                    if($('#work-book-title').attr("value") == "")return;
                                    if(ColabopadApplication.dialogOpenFrom == "teamspace")
                                        ColabopadApplication.newWorkbook(true,true);
                                    else
                                        ColabopadApplication.newWorkbook(false,true);
                                },
                                "Cancel": function() {
                                    $(this).dialog("close");
                                }
                            }
                     });

                     $('#page-title-dialog').dialog({
                            autoOpen: false,
                            width: 250,
                            height:250,
                            modal:false,
                            buttons: {
                                    "Ok": function() {
                                        $(this).dialog("close");

                                        if($('#page-title').attr("value") == "")return;

                                        //ColabopadApplication.newPg(ColabopadApplication.getCurrentContext(),template);
                                        if(ColabopadApplication.newPageTemplate)
                                            ColabopadApplication.newPg(ColabopadApplication.getCurrentContext(),ColabopadApplication.newPageTemplate,$('#page-title').attr("value"));
                                        else
                                            ColabopadApplication.newPg(ColabopadApplication.getContext($('#page-title-pid').attr("value"),$('#page-title-context-id').attr("value")), "default");
                                        
                                        ColabopadApplication.newPageTemplate = null;
                                    },
                                    "Cancel": function() {
                                        $(this).dialog("close");
                                    }
                                }
                      });
                    
                    
                    
                    $( "#dialog-confirm-page-move" ).dialog({
                        resizable: false,
                        height:140,
                        modal: true,
                        autoOpen:false,
                        buttons: {
                            "Nested Pages Only": function() {
                                $( this ).dialog( "close" );
                                _this.confirmPageMove("children");
                            },
                            "All": function() {
                                $( this ).dialog( "close" );
                                _this.confirmPageMove("all");
                            }
                        }
                    });                    
                    
                    $('#back-end-error-dialog').dialog({
                            autoOpen: false,
                            width: 750,
                            modal:true
                      });                      
                      
                     $('#room-title-dialog').dialog({
                            autoOpen: false,
                            width: 250,
                            height:120,
                            modal:false,
                            open:function(){
                                $('#room-title-textfield').val(_this.room.title);
                            },
                            buttons: {
                                    "Ok": function() {
                                        if($('#room-title-textfield').attr("value") == ""){
                                            alert("Please provide a name for the room.");
                                            return;
                                        }

                                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/img/busy.gif" /> updating, please wait'});
                                        $.ajax({
                                            type:'POST',
                                            data:{room_id:room_id,room_name:$('#room-title-textfield').val()},
                                            url:'/RoomAction.do?action=update-room-name',
                                            success:function(data){
                                                $.unblockUI();
                                                var reply = eval('('+data+')');
                                                if(ColabopadApplication.needUpgrade(reply))return;
                                                
                                                
                                                if(reply.status == 'success'){                                                    
                                                     _this.room.title = $('#room-title-textfield').val();
                                                    var node = $("#participant-treecontrol").dynatree('getTree').getNodeByKey("room_header_root");
                                                    node.data.title = _this.room.title;
                                                    $("#participant-treecontrol").dynatree('getTree').redraw();
                                                    $('#room-title-dialog').dialog("close");
                                                }else{
						  alert(reply.msg);
						}
                                            }
                                        });
                                        
                                    },
                                    "Cancel": function() {
                                        $(this).dialog("close");
                                    }
                                }
                      }).siblings('div.ui-dialog-titlebar').remove();






                      $('#new-participant-dialog').dialog({
                            autoOpen: false,
                            modal:true,
                            width: 330,
                            height:180,
                            buttons: {
                                "Ok": function() {
                                    if(ColabopadApplication.validateAddParticipant()){
                                        $('#new-participant-dialog').dialog("close");
                                        var part = '<span style="font-weight:bold;font-style:italic;color:gray">'+$('#fullName').attr('value')+'</span>';

                                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" /> Adding '+part+',please wait...</h1>'});
                                        $.ajax({
                                            type:'POST',
                                            data:{room_id:room_id,name:$('#fullName').attr('value'),emailAddress:$('#emailAddress').attr('value')},
                                            url:'/UserAction.do?action=add-participant',
                                            success:function(data){
                                                $.unblockUI();
                                                var reply = eval('('+data+')');
                                                if(ColabopadApplication.needUpgrade(reply))return;

                                                if(reply.status == 'success'){
                                                    if(reply.id==-1){
                                                        alert('dubplicate entry');
                                                    }else{
                                                        var participant = {name:$('#fullName').attr('value'),id:reply.id};
                                                        ColabopadApplication.room.participants.push(participant);

                                                        ColabopadApplication._addParticipantToRoom("offline",participant);
                                                        ColabopadApplication.ContextMenus.bindColabopadContextMenu();//rebind context menu

                                                        //send message to room participants
                                                        ColabopadApplication.MsgHandler.sendMessage({sender_id:sessionId,type:'add-participant',participant:participant});
                                                    }
                                                }else{
                                                    alert('Error adding participant.'+(reply.msg?'\n'+reply.msg:''))
                                                }
                                            }
                                        });
                                    }
                                },
                                "Cancel": function() {
                                    $('#new-participant-dialog').dialog("close");
                                }
                            }
                      });


                      $('#load-users-dialog').dialog({
                            autoOpen: false,
                            modal:true,
                            width: 420,
                            height:236,
                            buttons: {
                                "Cancel": function() {
                                    $('#load-users-dialog').dialog("close");
                                },
                                "Load": function() {
                                    $('#load-users-dialog').dialog("close");
                                    
                                    $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" /> Loading ,please wait...</h1>'});
                                    $('#loadUsersInterface').contents().find('[name=room_id]').attr("value",room_id);
                                    $('#loadUsersInterface').contents().find('[name=userdataposter]').submit();
                                }
                            }
                      });




                      $('#about-dialog').dialog({
                            autoOpen: false,
                            width: 450,
                            height:100,
                            buttons: {
                                "Ok": function() {
                                    $('#about-dialog').dialog("close");
                                }
                            }
                      });


                      $('#plan-upgrade-prompt-dialog').dialog({
                            autoOpen: false,
                            width: 350,
                            height:150,
                            modal:true,
                            buttons: {                                
                                "Cancel": function() {
                                    $(this).dialog("close");
                                },
                                "Upgrade": function() {
                                    $(this).dialog("close");
                                    $('#account-upgrade-dialog').dialog("open");
                                }                                
                            }
                      }).siblings('div.ui-dialog-titlebar').remove();


                     $('#create-room-dialog').dialog({
                        autoOpen: false,
                        width: 350,
                        buttons: {
                            "Add": function() {
                                if(validate()){
                                    $('#create-room-dialog').dialog("close");
                                    $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" />Creating room,please wait...</h1>'});
                                    $.ajax({
                                        type:'POST',
                                        data:{"roomLabel":$('#roomLabel').attr("value")},
                                        url:'/RoomAction.do?action=create-room',
                                        success:function(data){
                                            $.unblockUI();
                                            var reply = eval('('+data+')');
                                            if(ColabopadApplication.needUpgrade(reply))return;

                                            if(reply.status=='success'){
                                                //$('#room-list').trigger("reloadGrid");
                                                var turl = 'index.jsp?room_id='+reply.room_id+'&ts='+new Date().getTime();
                                                window.location.href = turl;
                                                //roomNodeData = {addClass:'phyzixlabs-room-inactive',type:'inactive-room',title:$('#roomLabel').attr("value"),url:turl};
                                                //current_tree_node.addChild(roomNodeData).activate();
                                                //$('#room_list').append('<tr style="border-style:solid;border-width:1px;"><td>'+(++room_count)+'</td><td style="border-style:solid;border-width:1px;padding:5px"><a href="#" onclick="openRoom(\''+reply.p+'\','+reply.pid+','+'\''+reply.u+'\')">'+reply.title+'</td>');
                                                ///alert('Your new room has been added below');
                                            }else{
                                                alert('There was a problem processing your request,please try again.\nIf problem persist, please contact support.');
                                            }
                                        }
                                    });
                                }
                            },
                            "Cancel": function() {
                                $('#create-room-dialog').dialog("close");
                            }
                        }
                     }).siblings('div.ui-dialog-titlebar').remove();




                    $('#assignment-dialog').dialog({
                        autoOpen: false,
                        width: 460,
                        height:380,
                        modal:false,
                        buttons: {
                                "Ok": function() {
                                    $(this).dialog("close");
                                    
                                    if(ColabopadApplication.dialogOpenFrom == "new-assignment")
                                        ColabopadApplication.saveAssignment('add-assignment');
                                    else
                                        ColabopadApplication.saveAssignment('update-assignment',ColabopadApplication.assignment_id);
                                },
                                "Cancel": function() {
                                    $(this).dialog("close");
                                }
                            }
                     }).siblings('div.ui-dialog-titlebar').remove();
                     
                     $('#assignment-open-time').datetimepicker({ampm: true,dateFormat:'mm/dd/yy',
                        onClose: function(dateText, inst) {
                            var endDateTextBox = $('#assignment-close-time');
                            if (endDateTextBox.val() != '') {
                                var testStartDate = new Date(dateText);
                                var testEndDate = new Date(endDateTextBox.val());
                                if (testStartDate > testEndDate)
                                    endDateTextBox.val(dateText);
                            }
                            else {
                                endDateTextBox.val(dateText);
                            }
                        },
                        onSelect: function (selectedDateTime){
                            var start = $(this).datetimepicker('getDate');
                            $('#assignment-close-time').datetimepicker('option', 'minDate', new Date(start.getTime()));
                        }
                    });
                    $('#assignment-close-time').datetimepicker({ampm: true,dateFormat:'mm/dd/yy',
                        onClose: function(dateText, inst) {
                            var startDateTextBox = $('#assignment-open-time');
                            if (startDateTextBox.val() != '') {
                                var testStartDate = new Date(startDateTextBox.val());
                                var testEndDate = new Date(dateText);
                                if (testStartDate > testEndDate)
                                    startDateTextBox.val(dateText);
                            }
                            else {
                                startDateTextBox.val(dateText);
                            }
                        },
                        onSelect: function (selectedDateTime){
                            var end = $(this).datetimepicker('getDate');
                            $('#assignment-open-time').datetimepicker('option', 'maxDate', new Date(end.getTime()) );
                        }
                    });
                    $('#assignment-first-reminder-time').datetimepicker({
                            ampm: true,dateFormat:'mm/dd/yy'
                    });
                    $('#assignment-reminder-repeat-interval').timepicker({});


                    $('#assignment-list-dialog').dialog({
                        autoOpen: false,
                        width: 250,
                        height:120,
                        modal:false,
                        buttons: {
                                "Ok": function() {
                                    $(this).dialog("close");
                                    ColabopadApplication.submitAssignment(false,0);
                                },
                                "Cancel": function() {
                                    $(this).dialog("close");
                                }
                            }
                     });


                    $('#assignment-submission-list-dialog').dialog({
                        autoOpen: false,
                        width: 250,
                        height:200,
                        modal:false,
                        open:function(){
                            $.ajax({
                                type:'POST',
                                data:{
                                    "room_id":room_id,
                                    "context_id":_this.assignment_submitted_context_id,
                                    "pad_id":_this.assignment_submitted_pad_id
                                },
                                url:'util/open-assignment-list.jsp?submission=true',
                                success:function(data){
                                    var reply = eval('('+data+')');
                                    if(reply.length>0){                                        
                                        $('#available-assignment-submission-list').empty();
                                        for(var i=0;i<reply.length;i++){

                                            $('#available-assignment-submission-list').append('<option value="'+reply[i].id+'">'+reply[i].name+'</option>');
                                        }
                                    }else{
                                        alert('No open Assignment Submissions were found.')
                                    }
                                }
                            });
                        },
                        buttons: {
                                "Ok": function() {
                                    $(this).dialog("close");
                                    ColabopadApplication.submitAssignment(true,$('#available-assignment-submission-list').val());
                                },
                                "Cancel": function() {
                                    $(this).dialog("close");
                                }
                            }
                     });


                       $('#distribute-content-dialog').dialog({
                            autoOpen: false,
                            width: 333,
                            height:470,
                            modal:true,
			    open:function(){
				    $("#distribute-content-users-list").clearGridData();

				    var row = {apply:'<input type="checkbox" value="global" id="dacl-globaluser-checkbox" /> ',title:'<span style="cursor:pointer;font-weight:bold">Everyone</span>'};
				    $("#distribute-content-users-list").addRowData("global",row);
				    $("#dacl-globaluser-checkbox").click(function(){
					if($(this).attr("checked")){
					  $(".dacl-user-checkbox").removeAttr("checked").attr("disabled","disabled");
					}else{
					  $(".dacl-user-checkbox").removeAttr("disabled");
					}
				    });
				    for(var i =0;i<_this.room.participants.length;i++){
				        if(_this.room.participants[i].id != user_id){
				          row = {apply:'<input type="checkbox" class="dacl-user-checkbox" value="'+_this.room.participants[i].id+'" /> ',title:'<span style="cursor:pointer">'+_this.room.participants[i].name+'</span>'};
				          $("#distribute-content-users-list").addRowData(_this.room.participants[i].id,row);
				        }
				    }                                  
			    },
                            buttons: {
                                    "Distribute": function() {
                                        $(this).dialog("close");
					if($("#dacl-globaluser-checkbox").attr("checked"))
					  _this.distributeContext(_this.selected_node.context_id,-1);
					$(".dacl-user-checkbox").each(function(){
					   if($(this).attr("checked"))
						_this.distributeContext(_this.selected_node.context_id,$(this).val());
					});
                                    },
                                    "Cancel": function() {
                                        $(this).dialog("close");
                                    }
                                }
                      }).siblings('div.ui-dialog-titlebar').remove();


                      $("#distribute-content-users-list").
                      jqGrid({url:'/ContextAction.do?action=x',
                      datatype: "local",
                      postData:{room_id:room_id,participant_id:my_pid,context_id:0},
                      colNames:['To','Name'],
                      colModel:[
                          {name:'apply',index:'apply', align:"center",width:32,sortable:false},
                          {name:'title',index:'title', align:"left",width:256,sortable:false}],
                      rowNum:-1,
                      rowList:[],
                      /*imgpath: gridimgpath,*/
                      /*pager: $('#global-access-control-list-pager'),*/
                      sortname: 'id',
                      viewrecords: true,
                      autowidth: false,
                      width:300,
                      pgbuttons:false,
                      pginput:false,
                      pgtext:false,
                      recordtext:'',
                      height:375,
                      sortorder: "desc",
                      caption:''
                      });
                      
                      
                    $('#app-store-dialog').dialog({
                        open:function(){
                            $('#appStoreInterface').attr("height",$(window).height()-20);
                            $('#appStoreInterface').attr("src",ColabopadApplication.app_store_url);
                            //$('#appStoreInterface').attr("width",$(window).width()-20);
                        },
                        autoOpen: false,
                        width: $(window).width()*.85,
                        height:$(window).height()*.9,
                        modal:true
                     });
                            
                         
                            
                            
                       $("#ebook-package-tabcontrol").tabs().css({"padding":0,"border":"none"});     
                            
                       $('#ebook-package-dialog').dialog({
                            autoOpen: false,
                            width: 430,
                            height:500,
                            modal:true,
			    open:function(){
				    $("#ebook-package-binder-list").clearGridData();                                    
                                    
                                    var my_part_cntx = _this.getParticipantContext(ColabopadApplication.user_id);
                                    var context_list = my_part_cntx.context_list;
                                    for(var i=0;i<context_list.length;i++){
                                        var cntx = context_list[i];                                        
                                        var row = {check:'<input type="checkbox" class="ebook-package-binder-checkbox" value="'+cntx.id+'" /> ',binder:'<span style="cursor:pointer">'+cntx.title+'</span>'};
                                        $("#ebook-package-binder-list").addRowData(cntx.id,row);
                                    }                                      
			    },
                            buttons: {
                                    "Zip It": function() {
                                        $(this).dialog("close");
                                        
                                        var selectedBinders = [];
                                        $(".ebook-package-binder-checkbox:checked").each(function(){
                                            selectedBinders.push($(this).val());
                                        });
                                        
                                        if(selectedBinders.length == 0){
                                            alert("Please select binders to package.")
                                            return;
                                        }
                                                                                
                                        var selectedApps = [];
                                        $(".app-package-checkbox:checked").each(function(){
                                            selectedApps.push($(this).val());
                                        });


                                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},message: '<h1><img src="images/misc/busy.gif" />Packaging, please wait...</h1>'});
                                        window.frames['packageInterface'].make_ebook(_this.room_id,selectedBinders.join("#"),selectedApps.join("#"),$("#ebook-package-binder-doc-only").is(":checked") == false?"no":"yes",null,$("#ebook-package-binder-zip-name").val(),$("#ebook-package-binder-uuid").val());
                                        
                                        
                                        /*if($("#ebook-package-binder-doc-only").is(":checked") == false){
                                        }else{
                                            _this.exportBinders(selectedBinders.join("#"));
                                        }*/
                                    },
                                    "Cancel": function() {
                                        $(this).dialog("close");
                                    }
                                }
                      }).siblings('div.ui-dialog-titlebar').remove();


                      $("#ebook-package-binder-list").
                      jqGrid({url:'x',
                      datatype: "local",
                      colNames:['','name'],
                      colModel:[
                          {name:'check',index:'check', align:"center",width:32,sortable:false},
                          {name:'binder',index:'binder', align:"left",width:256,sortable:false}],
                      rowNum:-1,
                      rowList:[],
                      sortname: 'id',
                      viewrecords: true,
                      //autowidth: true,
                      width:405,
                      pgbuttons:false,
                      pginput:false,
                      pgtext:false,
                      recordtext:'',
                      height:300,
                      sortorder: "desc",
                      caption:''
                      });
                      
                      $("#ebook-package-app-list").jqGrid({url:'../appbuilder/get-widgets.jsp',
                      datatype: "xml",
                      postData:{widgetid:0,env:'dev'},
                      colNames:['','Select','name'],
                      colModel:[
                                 {name:'id',index:'id', width:1,hidden:true,key:true},
                                 {name:'del_act',index:'del_act', width:25, sortable:false,hidden:true},
                                 {name:'name',index:'name', width:246,align:'left',sortable:false}
                                 ],
                      rowNum:-1,
                      rowList:[],                      
                      sortname: 'id',
                      viewrecords: false,
                      pgbuttons:false,
                      pginput:false,
                      //autowidth: true,
                      width:405,
                      height:300,
                      sortorder: "desc",
                      loadComplete:function(data){

                      },
                      onSelectRow:function(rowid){

                      }});
                },
                _initWidgetControlPanel:function(){
                    $("#app-cp-delete-btn").css({"width":"16px","height":"16px"}).button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-close"
                            }
                    }).click(function(){
                            var m = ColabopadApplication.getCurrentContext().active_pad.activeWidgetInstance;
                            ColabopadApplication.deleteWidgetInstance(ColabopadApplication.getCurrentContext().active_pad,m);
                            $('#widget-contrl-panel').css("display","none");
                            ColabopadApplication.getCurrentContext().active_pad.activeWidgetInstance = null;                        
                    });
                    
                    $("#app-cp-help-btn").css({"width":"16px","height":"16px"}).button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-help"
                            }
                    }).click(function(){
                        ColabopadApplication.getCurrentContext().active_pad.activeWidgetInstance.widget.loadHelp();
                    });                     
                   //creat move button
                   this.moduleMoveBtn._init();
                   this.widgetScaleBtn._init();
                   this.widgetRotateBtn._init();
                   this.moduleDeleteBtn._init();
                   this.widgetHelpBtn._init();
                   this.widgetControlPanelBtn._init();
                },
                _loadUIComponents:function(){
                    var _this = this;
                   //$('#textinputer').keypress(ColabopadApplication.pen.ontext);
                   //$('#textinputer').keydown(ColabopadApplication.pen.ontextinputreturn);

                   $('#textinputer').attr("cols","32");
                   
                   $('#floating-toolbox-toolbar').scrollFollow({relativeTo:"top",offset:120});
                   $('#floating-toolbox-toolbar button').css({"margin-bottom":"2px"});/*.button({text:false}).click(function(){
                                //ColabopadApplication.newWidget($(this).val(),'prod');
                   })*/
                   /*$('#floating-toolbox-toolbar').stickySidebar({
                                                                timer: 400
                                                                , easing: "easeInOutBack"
                                                                });*/
                    
                    $('#phyzixlabs-export-menu-button').removeAttr("disabled").menu({content: $('#phyzixlabs-export-menu').html()});
                    $('#phyzixlabs-file-new-page-menu-button').menu({content: $('#phyzixlabs-file-new-page-menu').html()});
                    $('#phyzixlabs-export-menu,#phyzixlabs-file-new-page-menu').remove();
                    
                    $("#participant-treecontrol-scrollpane").height($(document).height()*.55);
                    $("#app-panel").height($(document).height()*.25);
                                   
                   $('#log-viewer-dialog').dialog({
                        autoOpen: false,
                        width: 300,
                        height:250,
                        modal:false,
                        position:{of: $(window),my: 'left bottom',at: 'left bottom',offet:'5 5'}
                    });
                                   
                                   
                   //creating ploting Dialog
                   $('#image-dialog').dialog({
                        autoOpen: false,
                        width: 400,
                        modal:true,
                        buttons: {
                                "Ok": function() {
                                    $(this).dialog("close");
                                    
                                    if(typeof phyzixlabs_database == "undefined")
                                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},message: '<h1><img src="images/misc/busy.gif" />Uploading, please wait...</h1>'});
                                    
                                    ColabopadApplication.addImage(ColabopadApplication.getCurrentContext().active_pad);
                                },
                                "Cancel": function() {
                                    $(this).dialog("close");
                                }
                            }
                    });




                       $('#user-settings-dialog').dialog({
                            autoOpen: false,
                            width: 850,
                            height:560,
                            modal:true,
                            open:function(){
                                $("#profile-user-fullname").css("display","inline").text(_this.getUser(user_id).name);
                                //log(_this.getFileServiceUrl(_this.getUser(user_id).photo==""?"defaults/ceo.png":_this.getUser(user_id).photo));
                                //alert(_this.getFileServiceUrl(_this.getUser(user_id).photo==""?"ceo.png":_this.getUser(user_id).photo));
                                $("#user-setting-profile-photo").attr("src",_this.getFileServiceUrl(_this.getUser(user_id).photo==""?"defaults/ceo.png":_this.getUser(user_id).photo));
                            },
                            buttons: {
                                    "Close": function() {
                                        $(this).dialog("close");
                                    }/*,
                                    "Save & Close": function() {
                                        if(saveAccessSettings()){
                                            $(this).dialog("close");
                                        }else{
                                            alert("Please select a person to apply access to.");
                                        }
                                    },
                                    "Save": function() {
                                        if(!saveAccessSettings())
                                            alert("Please select a person to apply access to.");
                                    }*/
                                }
                         });


                   $('#file-upload-dialog').dialog({
                        autoOpen: false,
                        width: 400,                        
                        modal:true,
                        buttons: {
                                "Ok": function() {
                                    $(this).dialog("close");
                                    $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},message: '<h1><img src="images/misc/busy.gif" />Importing,please wait...</h1>'});
                                    ColabopadApplication.uploadFile(ColabopadApplication.getCurrentContext().active_pad);
                                },
                                "Cancel": function() {
                                    $(this).dialog("close");
                                }
                            }
                    });


                    
                    if(typeof phyzixlabs_database != "undefined"){
                        $( "#powered-by-button" ).css("display","inline");
                        return;
                    }


                    $( "#applet-builder" ).css("display","inline").button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-gear"
                            }
                    })/*.click(function(){
                        launchDevIDE()
                    });*/
                    $( "#sign-out-btn" ).css("display","inline").button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-locked"
                            }
                    }).click(function(){
                        if(confirm('Are you sure you want to sign-out?'))
                        window.location.href = '?action=logout';
                    });

                    $( "#user-settings-btn" ).css("display","inline").button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-wrench"
                            }
                    }).click(function(){
                        //ColabopadApplication.manageAccess();
                        if(!_this.settingsViewOpen)
                            ColabopadApplication.createSettingsView();
                        else{
                            
                            $("#user-settings-dialog").dialog("open");
                            //$('#participant-tabcontrol').tabs('select','participant-tab-user-settings');
                        }
                            
                    });


                    $( "#package-ebook-btn" ).css("display","inline").button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-folder-collapsed"
                            }
                    }).click(function(){
                        $('#ebook-package-dialog').dialog("open");
                    });


                    $( "#view-rooms-btn" ).css("display","inline").button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-triangle-1-s"
                            }
                    });

                    
                    //$(document).keypress(this.onKeyPress);

                    $('#embed-code-dialog').dialog({
                        autoOpen: false,
                        width: 300,
                        modal:true,
                        buttons: {
                                "Ok": function() {
                                    $(this).dialog("close");
                                },
                                "Cancel": function() {
                                    $(this).dialog("close");
                                }
                            }
                     });


                    $('#page-url-dialog').dialog({
                        autoOpen: false,
                        width: 400,
                        modal:true/*,
                        buttons: {
                                "Close": function() {
                                    $(this).dialog("close");
                                },
                                "Cancel": function() {
                                    $(this).dialog("close");
                                }
                            }*/
                     });

                     $('#account-upgrade-dialog').dialog({
                        autoOpen: false,
                        width: 600,
                        modal:true,
                        open:function(){
			    $('#account-upgrade-dialog-perform-page').css({"display":"block"});
			    $('#account-upgrade-dialog-confirm-page').css({"display":"none"});
			    $('#account-upgrade-dialog-credit-card-tos').removeAttr('checked');
			    $('#account-upgrade-dialog-team-plan-size').find('option:first').attr('selected','selected').parent('select');

			    $('.error-blinkable').removeClass('error-blinkable-active');
                            $('#account-upgrade-page1').css("display","block");
                            $('#account-upgrade-page2').css("display","none");
                            $('#credit-card-error').css({"display":"none"});
			    $('#account-upgrade-breadcrumb-home,#account-upgrade-breadcrumb-home-active').css("display","inline");
			    $('#account-upgrade-breadcrumb-payment-info,#account-upgrade-breadcrumb-home-inactive').css("display","none");
                            $.ajax({
                                type:'POST',
                                url:'/UserAction.do?action=get-plan-info',
                                success:function(data){
                                    var reply = eval('('+data+')');
                                    _this.upgrade_info={"info":reply};
                                }
                            });
                        },
                        buttons: {
                                /*"Ok": function() {
                                    $(this).dialog("close");
                                },
                                "Cancel": function() {
                                    $(this).dialog("close");
                                }*/
                            }
                     });//.find('.ui-dialog-buttonpane').remove();;
                    $( "#upgrade-btn-individual,#upgrade-btn-team" ).button().click(function(){
                        $(".team-size-row").css("display","none");
			$('#account-upgrade-dialog-current-payment-information-page,#account-upgrade-dialog-new-payment-information-page').css("display","none");
				            
                        if($(this).attr("id") == "upgrade-btn-individual")
				if(typeof _this.upgrade_info == "undefined")
                            		_this.upgrade_info={"selected" : "individual"};
				else
					_this.upgrade_info.selected = "individual";
                        else
                        if($(this).attr("id") == "upgrade-btn-team"){
				if(typeof _this.upgrade_info == "undefined")
                            		_this.upgrade_info={"selected" : "team"};
				else
					_this.upgrade_info.selected = "team";
                            $(".team-size-row").css("display","table-row");
                        }


					 if(_this.upgrade_info.selected == "team"){
										_this.upgrade_info.monthly_charge = Math.floor(_this.upgrade_info.info.team_plan_price*100)*$('#account-upgrade-dialog-team-plan-size').val();
									    }else{
										_this.upgrade_info.monthly_charge = Math.floor(_this.upgrade_info.info.individual_plan_price*100);
									     }

					var dollarValue = Math.floor(_this.upgrade_info.monthly_charge/100);
					var pennyValue  = _this.upgrade_info.monthly_charge%100;
					if(pennyValue == 0)
						pennyValue = "";
					else
					if(pennyValue <10)
						pennyValue = ".0"+pennyValue;
					else
						pennyValue = "."+pennyValue;
					$('#account-upgrade-monthly-charge').text('$'+dollarValue+pennyValue);

				    if(typeof _this.upgrade_info.info.card_info != "undefined"){
					    $('#account-upgrade-dialog-display-credit-card-last4-number').text(_this.upgrade_info.info.card_info.last4);
					    $('#account-upgrade-dialog-display-credit-card-expiration-date').text(_this.upgrade_info.info.card_info.expr_month+'/'+_this.upgrade_info.info.card_info.expr_yr);
					    $('#account-upgrade-dialog-display-credit-card-type').text(_this.upgrade_info.info.card_info.type);

					    $('#account-upgrade-dialog-new-payment-information-page').css("display","none");
		                            $('#account-upgrade-dialog-current-payment-information-page').css("display","table-row");
					    $('#account-upgrade-dialog-change-credit-card-button').css("display","inline");
				    }else{
						$('#account-upgrade-dialog-current-payment-information-page').css("display","none");
						$('#account-upgrade-dialog-new-payment-information-page').css("display","table-row");
						$('#account-upgrade-dialog-dont-change-credit-card-button').css("display","inline");
					}


                        $('#account-upgrade-page1').css("display","none");
                        $('#account-upgrade-page2').css("display","block");

			$('#account-upgrade-breadcrumb-home,#account-upgrade-breadcrumb-payment-info').css("display","inline");
			$('#account-upgrade-breadcrumb-home-inactive,#account-upgrade-breadcrumb-payment-info-active').css("display","inline");
			$('#account-upgrade-breadcrumb-home-active,#account-upgrade-breadcrumb-payment-info-inactive').css("display","none");
                    });

		    $('#account-upgrade-breadcrumb-home-inactive').click(function(){
			$('#account-upgrade-breadcrumb-home-inactive,#account-upgrade-breadcrumb-payment-info-active').css("display","none");
                        $('#account-upgrade-breadcrumb-home-active,#account-upgrade-breadcrumb-payment-info-inactive').css("display","inline");
                        $('#account-upgrade-page1').css("display","block");
                        $('#account-upgrade-page2').css("display","none");
		    });

		    $('#account-upgrade-breadcrumb-payment-info-inactive').click(function(){			
			$('#account-upgrade-breadcrumb-home-active,#account-upgrade-breadcrumb-payment-info-inactive').css("display","none");
			$('#account-upgrade-breadcrumb-home-inactive,#account-upgrade-breadcrumb-payment-info-active').css("display","inline");
                        $('#account-upgrade-page1').css("display","none");
                        $('#account-upgrade-page2').css("display","block");
		    });


			$('#account-upgrade-dialog-team-plan-size').change(function(){

				_this.upgrade_info.monthly_charge = Math.floor(_this.upgrade_info.info.team_plan_price*100)*$(this).val();
			   

				var dollarValue = Math.floor(_this.upgrade_info.monthly_charge/100);
				var pennyValue  = _this.upgrade_info.monthly_charge%100;
				if(pennyValue == 0)
					pennyValue = "";
				else
				if(pennyValue <10)
					pennyValue = ".0"+pennyValue;
				else
					pennyValue = "."+pennyValue;
				$('#account-upgrade-monthly-charge').text('$'+dollarValue+pennyValue);
		      });

		    $( "#account-upgrade-dialog-confirm-page-close-button" ).button().click(function(){$('#account-upgrade-dialog').dialog('close');});
                    $( "#upgrade-signup-btn" ).button().click(function(){
			$('.error-blinkable').removeClass('error-blinkable-active');
                        $('#credit-card-error').css({"display":"none"});
                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" /> processing, please wait'});


			function sendPlanChange(request){
		                 $.ajax({
		                    type:'POST',
		                    data:request,
		                    url:'/UserAction.do?action=upgrade-account',
		                    success:function(data){
		                        $.unblockUI();
		                        var reply = eval('('+data+')');
		                        if(reply.status != "success"){
		                           $('#credit-card-error').css({"display":"block"}).html(reply.msg);
		                        }else{
					   $('#account-upgrade-dialog-perform-page').css({"display":"none"});
					   $('#account-upgrade-dialog-confirm-page').css({"display":"block"});
					   $('#account-upgrade-dialog-confirm-page-msg').text("Your account has been successfully upgraded to the '"+request.plan+"' plan");
                                           _this.resetPlanInfoSection();
					}
		                    }
		                });
			}

			function validate(tos_only){
			   var valid = true;
			   if($('#account-upgrade-dialog-credit-card-tos').attr('checked') != 'checked'){
				$('#account-upgrade-dialog-credit-card-tos-label').addClass('error-blinkable-active');valid = false;
			   }
		           if(tos_only)return valid;

			   if($('#account-upgrade-dialog-credit-card-number').val() == ''){
				$('#account-upgrade-dialog-credit-card-number-label').addClass('error-blinkable-active');valid = false;
			   }
			   if($('#account-upgrade-dialog-credit-card-expiration-month').val() == '' || $('#account-upgrade-dialog-credit-card-expiration-year').val() == ''){
				$('#account-upgrade-dialog-credit-card-expiration-month-label').addClass('error-blinkable-active');valid = false;
			   }
			   if($('#account-upgrade-dialog-credit-card-security-code').val() == ''){
				$('#account-upgrade-dialog-credit-card-security-code-label').addClass('error-blinkable-active');valid = false;
			   }return valid;
			}
			var teamSize = 1;
	                if(_this.upgrade_info.selected == "team")
	                     teamSize = $("#account-upgrade-dialog-team-plan-size").val();

			var request = null;
			if($('#account-upgrade-dialog-new-payment-information-page').css("display") != "none"){
				if(!validate()){$.unblockUI();return;}
		                Stripe.createToken({
		                   number:$('#account-upgrade-dialog-credit-card-number').val(),
		                   cvc:$('#account-upgrade-dialog-credit-card-security-code').val(),
		                   exp_month:$('#account-upgrade-dialog-credit-card-expiration-month').val(),
		                   exp_year:$('#account-upgrade-dialog-credit-card-expiration-year').val()},
		                   function(status,response){
		                     if(response.error){
		                        $('#credit-card-error').css({"display":"block"}).html(response.error.message);
		                        $.unblockUI();
		                     }else{
		                         var token = response['id'];
					 request = {"plan":_this.upgrade_info.selected,
		                          		"token":token,
		                          		"teamSize":teamSize};
					 sendPlanChange(request);
		                     }
		                   }
		                );
			}else{
					 if(!validate(true)){$.unblockUI();return;}
					 request = {"plan":_this.upgrade_info.selected,
		                          	    "teamSize":teamSize};
					 sendPlanChange(request);
			}

                    });

		    $( "#account-plan-update-dialog-confirm-page-close-button" ).button().click(function(){$('#account-plan-update-dialog').dialog('close');});
                    $( "#change-plan-submit-button" ).button().click(function(){
			$('.error-blinkable1').removeClass('error-blinkable-active');
                        $('#account-plan-update-dialog-credit-card-error').css({"display":"none"});
                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" /> processing, please wait'});

		        function sendPlanChange(request){
		                 $.ajax({
		                    type:'POST',
		                    data:request,
		                    url:'/UserAction.do?action=change-to-'+request.plan+'-plan',
		                    success:function(data){
		                        $.unblockUI();
		                        var reply = eval('('+data+')');
		                        if(reply.status != "success"){
		                           $('#account-plan-update-dialog-credit-card-error').css({"display":"block"}).html(reply.msg);
                                           
		                        }else{
					   $('#account-plan-update-dialog-perform-page').css({"display":"none"});
					   $('#account-plan-update-dialog-confirm-page').css({"display":"block"});
                                           
                                           if(request.plan == 'change-payment-info' || typeof reply.msg != "undefined")
                                               $('#account-plan-update-dialog-confirm-page-msg').text(reply.msg);
                                           else
                                               $('#account-plan-update-dialog-confirm-page-msg').text("Your account has been successfully changed to the '"+request.plan+"' plan");
                                           _this.resetPlanInfoSection();
					}
		                    }
		                });
			}
			function validate(tos_only){
			   var valid = true;
			   if($('#account-plan-update-dialog-credit-card-tos').attr('checked') != 'checked'){
				$('#account-plan-update-dialog-credit-card-tos-label').addClass('error-blinkable-active');valid = false;
			   }
			   if(tos_only)return valid;

			   if($('#account-plan-update-dialog-credit-card-number').val() == ''){
				$('#account-plan-update-dialog-credit-card-number-label').addClass('error-blinkable-active');valid = false;
			   }
			   if($('#account-plan-update-dialog-credit-card-expiration-month').val() == '' || $('#account-plan-update-dialog-credit-card-expiration-year').val() == ''){
				$('#account-plan-update-dialog-credit-card-expiration-month-label').addClass('error-blinkable-active');valid = false;
			   }
			   if($('#account-plan-update-dialog-credit-card-security-code').val() == ''){
				$('#account-plan-update-dialog-credit-card-security-code-label').addClass('error-blinkable-active');valid = false;
			   }return valid;
			}
	                var teamSize = 1;
	                if(_this.change_plan_info.selected == "team")
	                     teamSize = $("#account-plan-update-dialog-team-plan-size").val();

			var request = null;
			if($('#account-plan-update-dialog-new-payment-information-page').css("display") != "none"){
				if(!validate()){$.unblockUI();return;}

		                Stripe.createToken({
		                   number:$('#account-plan-update-dialog-credit-card-number').val(),
		                   cvc:$('#account-plan-update-dialog-credit-card-security-code').val(),
		                   exp_month:$('#account-plan-update-dialog-credit-card-expiration-month').val(),
		                   exp_year:$('#account-plan-update-dialog-credit-card-expiration-year').val()},
		                   function(status,response){
		                     if(response.error){
		                        $('#account-plan-update-dialog-credit-card-error').css({"display":"block"}).html(response.error.message);
		                        $.unblockUI();
		                     }else{
		                         var token = response['id'];
					 request = {"plan":_this.change_plan_info.selected,
		                          		"token":token,
		                          		"teamSize":teamSize};
					 sendPlanChange(request);
		                     }
		                   }
		                );
			}else{
					 if(!validate(true)){$.unblockUI();return;}
					 request = {"plan":_this.change_plan_info.selected,
		                          	    "teamSize":teamSize};
					 sendPlanChange(request);
			}
                    });
			

                      $('#change-credit-card-button').button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-pencil"
                            }}).click(function(){
                          $('#account-plan-update-dialog-current-payment-information-page').css("display","none");
                          $('#account-plan-update-dialog-new-payment-information-page').css("display","table-row");
			  $('#change-credit-card-button').css("display","none");
			  $('#dont-change-credit-card-button').css("display","inline");
                      });
                      $('#dont-change-credit-card-button').button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-cancel"
                            }}).click(function(){                          
                          $('#account-plan-update-dialog-new-payment-information-page').css("display","none");
			  $('#account-plan-update-dialog-current-payment-information-page').css("display","table-row");
			  $('#dont-change-credit-card-button').css("display","none");
			  $('#change-credit-card-button').css("display","inline");
                      });



                      $('#account-upgrade-dialog-change-credit-card-button').button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-pencil"
                            }}).click(function(){
                          $('#account-upgrade-dialog-current-payment-information-page').css("display","none");
                          $('#account-upgrade-dialog-new-payment-information-page').css("display","table-row");
			  $('#account-upgrade-dialog-change-credit-card-button').css("display","none");
			  $('#account-upgrade-dialog-dont-change-credit-card-button').css("display","inline");
                      });
                      $('#account-upgrade-dialog-dont-change-credit-card-button').button({
                            text: false,
                            icons: {
                                    primary: "ui-icon-cancel"
                            }}).click(function(){                          
                          $('#account-upgrade-dialog-new-payment-information-page').css("display","none");
			  $('#account-upgrade-dialog-current-payment-information-page').css("display","table-row");
			  $('#account-upgrade-dialog-dont-change-credit-card-button').css("display","none");
			  $('#account-upgrade-dialog-change-credit-card-button').css("display","inline");
                      });


		      $('#account-plan-update-dialog-team-plan-size').change(function(){

				_this.change_plan_info.monthly_charge = Math.floor(_this.change_plan_info.info.team_plan_price*100)*$(this).val();
			   

				var dollarValue = Math.floor(_this.change_plan_info.monthly_charge/100);
				var pennyValue  = _this.change_plan_info.monthly_charge%100;
				if(pennyValue == 0)
					pennyValue = "";
				else
				if(pennyValue <10)
					pennyValue = ".0"+pennyValue;
				else
					pennyValue = "."+pennyValue;
				$('#account-plan-update-monthly-charge').text('$'+dollarValue+pennyValue);
		      });



                  
                  
                  
                     $('#plan-cancel-dialog').dialog({
                         resizable:false,
                         height:140,
                         modal:true,
                         autoOpen:false,
                         buttons:{
                             "Yes":function(){		        
                                    $.ajax({
                                        type:'POST',                                        
                                        url:'/UserAction.do?action=cancel-plan',
                                        success:function(data){
                                            //$.unblockUI();
                                            //var reply = eval('('+data+')');
                                            _this.resetPlanInfoSection();
                                            $('#plan-cancel-dialog').dialog("close");
                                        }
                                    });			                               
                             },
                             "No":function(){
                                 $('#plan-cancel-dialog').dialog("close");
                             }
                         }
                     });
                     $('#account-plan-update-dialog').dialog({
                        autoOpen: false,
                        width: 600,
                        modal:true,
                        open:function(){
			    $('#account-plan-update-dialog-perform-page').css({"display":"block"});
			    $('#account-plan-update-dialog-confirm-page').css({"display":"none"});
			    $('#account-plan-update-dialog-credit-card-tos').removeAttr('checked');
			    $('#account-plan-update-dialog-team-plan-size').find('option:first').attr('selected','selected').parent('select');

			    $('#account-plan-update-dialog-new-payment-information-page').css("display","none");
			    $('.error-blinkable1').removeClass('error-blinkable-active');

                            
                            $('#account-plan-update-dialog-credit-card-error').css({"display":"none"});
			    if(_this.change_plan_info.selected == "individual"){
                            	$('#account-plan-update-dialog-team-size-row').css("display","none");
			    }
                            else
                            if(_this.change_plan_info.selected == "team")
                            {				
                                $('#account-plan-update-dialog-team-size-row').css("display","table-row");
			    }
                            else
                            if(_this.change_plan_info.selected == "change-payment-info")
                            {				
                                //$('#account-plan-update-dialog-team-size-row').css("display","table-row");
			    }                            
                            $.ajax({
                                type:'POST',
                                url:'/UserAction.do?action=get-plan-info',
                                success:function(data){
                                    var reply = eval('('+data+')');
                                    _this.change_plan_info.info = reply;
					

				    if(_this.change_plan_info.selected == "team"){
                                        $('#account-plan-update-dialog-team-plan-size').val(_this.change_plan_info.info.current_team_size);
					_this.change_plan_info.monthly_charge = Math.floor(_this.change_plan_info.info.team_plan_price*100)*$('#account-plan-update-dialog-team-plan-size').val();
				    }else{
					_this.change_plan_info.monthly_charge = Math.floor(_this.change_plan_info.info.individual_plan_price*100);
				     }

					var dollarValue = Math.floor(_this.change_plan_info.monthly_charge/100);
					var pennyValue  = _this.change_plan_info.monthly_charge%100;
					if(pennyValue == 0)
						pennyValue = "";
					else
					if(pennyValue <10)
						pennyValue = ".0"+pennyValue;
					else
						pennyValue = "."+pennyValue;
					$('#account-plan-update-monthly-charge').text('$'+dollarValue+pennyValue);

				    $('#display-credit-card-last4-number').text(_this.change_plan_info.info.card_info.last4);
				    $('#display-credit-card-expiration-date').text(_this.change_plan_info.info.card_info.expr_month+'/'+_this.change_plan_info.info.card_info.expr_yr);
				    $('#display-credit-card-type').text(_this.change_plan_info.info.card_info.type);
                                    $('#account-plan-update-dialog-current-payment-information-page').css("display","table-row");
				    $('#change-credit-card-button').css("display","inline");
                                }
                            });
                        },
                        buttons: {
                                /*"Ok": function() {
                                    $(this).dialog("close");
                                },
                                "Cancel": function() {
                                    $(this).dialog("close");
                                }*/
                            }
                     });//.find('.ui-dialog-buttonpane').remove();
                },
                createRoom:function(){
                    $('#roomLabel').val('');
                    $('#create-room-dialog').dialog("open");
                },
                createParticipant:function(action){
                   switch( action ) {
                      case "new":
                            $('#fullName').val('');
                            $('#emailAddress').val('');
                            $('#new-participant-dialog').dialog("open");
                            break;
                      case "load_users":
                            $('#load-users-dialog').dialog("open");
                            break;
                  }
                },
                _loadUserSettingsManagerUI:function(callback,showtab){
                       var _this = this;
                       var loadCount = 1;
                       /*$('#access-grant-dialog').dialog({
                            autoOpen: false,
                            width: 650,
                            height:400,
                            modal:true,
                            buttons: {
                                    "Ok": function() {
                                        $(this).dialog("close");
                                        if(ColabopadApplication.access_index == 1)
                                            ColabopadApplication.updateUserAccess();
                                        else
                                        if(ColabopadApplication.access_index == 0)
                                            ColabopadApplication.updateGlobalAccess();
                                    },
                                    "Cancel": function() {
                                        $(this).dialog("close");
                                    }
                                }
                      });*/

                      /*
                      $("#context-access-control-list").
                      jqGrid({url:'/ContextAction.do?action=get-context-acl',
                      datatype: "local",
                      postData:{room_id:room_id,participant_id:my_pid,context_id:0},
                      colNames:[''],
                      colModel:[{name:'title',index:'title', align:"left",width:256,sortable:false}],
                      rowNum:-1,
                      rowList:[],
                      /*imgpath: gridimgpath,*/
                      /*pager: $('#global-access-control-list-pager'),*
                      sortname: 'id',
                      viewrecords: true,
                      autowidth: false,
                      width:200,
                      pgbuttons:false,
                      pginput:false,
                      pgtext:false,
                      recordtext:'',
                      height:240,
                      sortorder: "desc",
                      caption:'<img src="images/misc/gnome-blog.png"/> Binders',
                      onSelectRow:this.onLoadContextPageAccessList
                      });//.navGrid('#global-access-control-list-pager',{edit:false,add:false,del:false,search:false,refresh:false});

                      $("#page-access-control-list").
                      jqGrid({url:'/ContextAction.do?action=get-context-acl',
                      datatype: "local",
                      postData:{room_id:room_id,participant_id:my_pid,context_id:0},
                      colNames:['','Read','Write','.','.','Embed'],
                      colModel:[{name:'title',index:'title', align:"left",width:256,sortable:false},
                                {name:'read',index:'read',  align:"center",sortable:false},
                                {name:'write',index:'write',  align:"center",sortable:false},
                                {name:'create',index:'create', align:"center",sortable:false,hidden:true},
                                {name:'del',index:'del', align:"center",sortable:false,hidden:true},
                                {name:'embed',index:'embed', align:"center",sortable:false,hidden:false}
                                ],
                      rowNum:-1,
                      rowList:[],
                      /*imgpath: gridimgpath,*/
                      /*pager: $('#global-access-control-list-pager'),*
                      sortname: 'id',
                      viewrecords: true,
                      autowidth: false,
                      width:400,
                      pgbuttons:false,
                      pginput:false,
                      pgtext:false,
                      recordtext:'',
                      height:240,
                      sortorder: "desc",
                      caption:'<img src="images/misc/alacarte.png"/>Pages',
                      gridComplete:function(){
                          if(--loadCount == 0){
                             callback();
                          }
                      }});*///.navGrid('#global-access-control-list-pager',{edit:false,add:false,del:false,search:false,refresh:false});
                            
                        $.ajax({
                            type:'POST',
                            data:{room_id:room_id},
                            url:'/RoomAction.do?action=get-room-access',
                            success:function(data){
                                
                                var reply = eval('('+data+')');
                                if(reply.status != "success"){
                                    //alert(reply.msg);
                                }else{
                                    //alert(reply.accessControl+" "+reply.accessCode);
                                    $("input[name=room-access-type]").filter("[value="+reply.accessControl+"]").prop("checked",true);
                                    $("#room-access-code").val(reply.accessCode).prop("readonly",true);
                                    $("#room-public-access-url").val(baseUrl+"/sl/?pr="+_this.room_id+"-"+reply.accessCode).prop("readonly",true);

                                    if(reply.accessControl == 1)
                                        $('#public-access-settings').css("display","block");
                                }
                            }
                        }); 
                        
                        $("input[name=room-access-type]").change(function(){
                            if($(this).val() == 0 && $('#public-access-settings').css("display") == "block"){
                                $('#public-access-settings').hide("blind",500);
                            }else
                            if($(this).val() == 1 && $('#public-access-settings').css("display") != "block")
                            {
                                $('#public-access-settings').show("blind",500);
                            }
                            
                            $.blockUI();
                            $.ajax({
                                type:'POST',
                                data:{room_id:room_id,access:$(this).val()},
                                url:'/RoomAction.do?action=update-room-access',
                                success:function(data){
                                    $.unblockUI();
                                    var reply = eval('('+data+')');
                                    if(reply.status != "success"){
                                        alert(reply.msg);
                                    }
                                }
                            });                            
                            
                        });       
                      
                      $( "#change-room-access-code-button" ).css("display","inline").button({
                                        text: false,
                                        icons: {
                                                primary: "ui-icon-refresh"
                                        }
                      }).click(function(){
                            $.blockUI();
                            $.ajax({
                                type:'POST',
                                data:{room_id:room_id},
                                url:'/RoomAction.do?action=update-room-access-code',
                                success:function(data){
                                    $.unblockUI();
                                    var reply = eval('('+data+')');
                                    if(reply.status != "success"){
                                       alert(reply.msg);
                                    }else{
                                        
                                        $("#room-access-code").val(reply.accessCode).prop("readonly",true);
                                        $("#room-public-access-url").val(baseUrl+"/sc/nd/?pr="+_this.room_id+"-"+reply.accessCode).prop("readonly",true);
                                        
                                        //$("#room-access-code").removeAttr("disabled").val(reply.accessCode).attr("disabled","disabled");
                                    }
                                }
                            });
                      });                      
                      


                      $('#upgrade-plan-button').button().click(function(){
			$('#account-upgrade-dialog').dialog("open");
                      });
                  
                      $('#change-payment-info-button').button().click(function(){
			_this.change_plan_info ={"selected":"change-payment-info"};
			$("#account-plan-update-dialog-team-size-row").css("display","none");
			$('#account-plan-update-dialog').dialog("open");                          
                      });
                      
                      $('#change-to-team-plan-button,#change-team-plan-size-payment-info-button').button().click(function(){
			_this.change_plan_info ={"selected":"team"};
			$("#account-plan-update-dialog-team-size-row").css("display","table-row");
			$('#account-plan-update-dialog').dialog("open");
                      });
                      $('#change-to-individual-plan-button').button().click(function(){
			_this.change_plan_info ={"selected":"individual"};
                        $("#account-plan-update-dialog-team-size-row").css("display","none");
			$('#account-plan-update-dialog').dialog("open");
                      });
                      $('#cancel-to-basic-plan-button').button().click(function(){
                          $('#plan-cancel-dialog').dialog("open");
                      });
                      /////////////////////////////////////////////////////////////////////////////////////////////////////////

                       function saveAccessSettings(){
                            
                            ColabopadApplication.access_index = ColabopadApplication.ACL_EDIT_INDEX;
                            var check_count = 0;
                            if($('#acl-globaluser-checkbox').attr("checked")=="checked"){
                                    check_count++;
                                    _this.updateUserAccess(0);
                            }else{

                                    $('.acl-user-checkbox').each(function(){
                                        if($(this).attr("checked")=="checked"){
                                            check_count++;
                                            _this.updateUserAccess($(this).val());
                                        }
                                    });
                            }return check_count>0;
                       }

                        $("#save-access-control-settings-button").button().click(function(){
                                if(!saveAccessSettings())
                                    alert("Please select a person to apply access to.");
                        });
                        $( "#update-profile-photo-btn" ).css("display","inline").button({
                                        text: false,
                                        icons: {
                                                primary: "ui-icon-pencil"
                                        }
                          }).click(function(){
                                    _this.triggerUpload("no","user-profile-photo","profile-pic");
                          });


                    $( "#update-user-profile-password-btn" ).css("display","inline").button({
                            text: true,
                            icons: {
                                    primary: "ui-icon-pencil"
                            }
                    }).click(function(){
                            if($("#profile-user-current-password-textfield").val() == ''){
                              alert("Please provide your current password");
                              return;
                            }
                            if($("#profile-user-new-password-textfield").val() == ''){
                              alert("Please provide an updated password");
                              return;
                            }

                            if($("#profile-user-new-password-textfield").val().length<5){
                              alert("New password must be at least 5 characters long.");
                              return;
                            }

                            if($("#profile-user-new-password-textfield").val() !=
                               $("#profile-user-confirm-new-password-textfield").val()){
                              alert("Please confirm new password, both should match.");
                              $("#profile-user-confirm-new-password-textfield").val("");
                              return;
                            }

                            $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" /> updating, please wait'});
                            $.ajax({
                                type:'POST',
                                data:{"newPassword":$("#profile-user-new-password-textfield").val(),"currentPassword":$("#profile-user-current-password-textfield").val()},
                                url:'/UserAction.do?action=update-user-profile-password',
                                success:function(data){
                                    $.unblockUI();
                                    var reply = eval('('+data+')');
                                    if(reply.status != "success"){
                                       alert(reply.msg);
                                    }
                                }
                            });
                        });
                        
                        
                        $( "#update-profile-fullname-edit-btn" ).css("display","inline")
                        .button({text: false,
                                    icons: {
                                            primary: "ui-icon-pencil"
                                    }
                           }).click(function(){
                               $( "#profile-user-fullname-textfield,#update-profile-fullname-save-btn,#update-profile-fullname-cancel-btn" ).css("display","inline");
                               $( "#profile-user-fullname-textfield").val(_this.getUser(user_id).name);
                               $("#profile-user-fullname,#update-profile-fullname-edit-btn").css("display","none");
                          });
                          $( "#update-profile-fullname-save-btn" ).button({
                                                        text: false,
                                                        icons: {
                                                                primary: "ui-icon-disk"
                                                        }
                                }).click(function(){
                                       if($("#profile-user-fullname-textfield").val() == ''){
                                         alert("Please provide your name");
                                         return;
                                       }

                                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" /> updating, please wait'});
                                        $.ajax({
                                            type:'POST',
                                            data:{"fullName":$("#profile-user-fullname-textfield").val()},
                                            url:'/UserAction.do?action=update-user-profile-fullname',
                                            success:function(data){
                                                $.unblockUI();
                                                var reply = eval('('+data+')');
                                                if(reply.status != "success"){
                                                   alert(reply.msg);
                                                }else{
                                                        $( "#update-profile-fullname-save-btn,#update-profile-fullname-cancel-btn,#profile-user-fullname-textfield" ).css("display","none");
                                                        $( "#update-profile-fullname-edit-btn" ).css("display","inline");
                                                        _this.getUser(user_id).name = $("#profile-user-fullname-textfield").val();
                                                        $("#profile-user-fullname").css("display","inline").text(_this.getUser(user_id).name);
                                                        var node = $("#participant-treecontrol").dynatree('getTree').getNodeByKey("key-"+user_id);
                                                        node.data.title = $("#profile-user-fullname-textfield").val();
                                                        $("#participant-treecontrol").dynatree('getTree').redraw();
                                                }
                                            }
                                        });
                              }).css("display","none");
                                $( "#update-profile-fullname-cancel-btn" ).button({
                                                            text: false,
                                                            icons: {
                                                                    primary: "ui-icon-close"
                                                            }
                                                    }).click(function(){
                                                        $( "#update-profile-fullname-save-btn,#update-profile-fullname-cancel-btn,#profile-user-fullname-textfield" ).css("display","none");
                                                        $( "#update-profile-fullname-edit-btn" ).css("display","inline");
                                                        $("#profile-user-fullname").css("display","inline").text(_this.getUser(user_id).name);
                                  }).css("display","none");



                        $( "#update-profile-login-email-edit-btn" ).css("display","inline")
                        .button({text: false,
                                    icons: {
                                            primary: "ui-icon-pencil"
                                    }
                           }).click(function(){
                               $( "#profile-user-login-email-textfield,#update-profile-login-email-save-btn,#update-profile-login-email-cancel-btn" ).css("display","inline");
                               $( "#profile-user-login-email-textfield").val($("#profile-user-login-email").text());
                               $("#profile-user-login-email,#update-profile-login-email-edit-btn").css("display","none");
                          });
                          $( "#update-profile-login-email-save-btn" ).button({
                                                        text: false,
                                                        icons: {
                                                                primary: "ui-icon-disk"
                                                        }
                                }).click(function(){
                                       if($("#profile-user-login-email-textfield").val() == ''){
                                         alert("Please provide your name");
                                         return;
                                       }
                                       if(!confirm("Changing your email requires logging off and logging back in. \n Do you wish to continue."))return;
                                       
                                        $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" /> updating, please wait'});
                                        $.ajax({
                                            type:'POST',
                                            data:{"emailAddress":$("#profile-user-login-email-textfield").val()},
                                            url:'/UserAction.do?action=update-user-profile-email',
                                            success:function(data){
                                                //alert(data)
                                                $.unblockUI();
                                                var reply = eval('('+data+')');
                                                if(reply.status != "success"){
                                                   alert(reply.msg);
                                                }else{
                                                        $( "#update-profile-login-email-save-btn,#update-profile-login-email-cancel-btn,#profile-user-login-email-textfield" ).css("display","none");
                                                        $( "#update-profile-login-email-edit-btn" ).css("display","inline");                                                        
                                                        $("#profile-user-login-email").css("display","inline").text($("#profile-user-login-email-textfield").val());
                                                        window.location = '../../sc/nd/';
                                                }
                                            }
                                        });
                              }).css("display","none");
                                $( "#update-profile-login-email-cancel-btn" ).button({
                                                            text: false,
                                                            icons: {
                                                                    primary: "ui-icon-close"
                                                            }
                                                    }).click(function(){
                                                        $( "#update-profile-login-email-save-btn,#update-profile-login-email-cancel-btn,#profile-user-login-email-textfield" ).css("display","none");
                                                        $( "#update-profile-login-email-edit-btn" ).css("display","inline");
                                                        $("#profile-user-login-email").css("display","inline");//.text(_this.getUser(user_id).name);
                                  }).css("display","none");
                       




                      $("#content-access-control-list").
                      jqGrid({url:'util/access-control.jsp',
                      datatype: "xml",
                      treeGrid: true,
                      treeGridModel: 'adjacency',
                      ExpandColumn : 'title',
                      postData:{room_id:room_id,participant_id:my_pid,context_id:0},
                      colNames:['', '','Read','Write','.','.','Public'],
                      colModel:[{name:'id',index:'id', width:1,hidden:true,key:true},
                                {name:'title',index:'title', align:"left",width:256,sortable:false},
                                {name:'read',index:'read',  align:"center",width:64,sortable:false},
                                {name:'write',index:'write',  align:"center",width:64,sortable:false},
                                {name:'create',index:'create', align:"center",width:64,sortable:false,hidden:true},
                                {name:'del',index:'del', align:"center",sortable:false,width:64,hidden:true},
                                {name:'embed',index:'embed', align:"center",width:64,sortable:false,hidden:false}
                                ],
                      rowNum:-1,
                      rowList:[],
                      /*imgpath: gridimgpath,*/
                      /*pager: $('#global-access-control-list-pager'),*/
                      sortname: 'id',
                      viewrecords: true,
                      autowidth: false,
                      width:500,
                      pgbuttons:false,
                      pginput:false,
                      pgtext:false,
                      recordtext:'',
                      height:375,
                      sortorder: "desc",
                      caption:'',
                      gridComplete:function(){
                          //log('gridComplete:'+loadCount);
                          if(--loadCount == 0){
                             callback();
                          }
                      }});//.navGrid('#global-access-control-list-pager',{edit:false,add:false,del:false,search:false,refresh:false});

                      
                      $("#user-settings-tabcontrol").tabs({
                       create:function(){
                        $("#profile-user-fullname").css("display","inline").text(_this.getUser(user_id).name);                                
                        $("#user-setting-profile-photo").attr("src",_this.getFileServiceUrl(_this.getUser(user_id).photo==""?"defaults/ceo.png":_this.getUser(user_id).photo));                           
                        $( "#user-settings-tabcontrol" ).css({"border-style":"none","background":"none","margin":"0","padding":"0"}).removeClass("ui-corner-all");
                        $( "#user-settings-tabcontrol > ul" )/*.removeClass("ui-corner-all")*/.css({"border-top":"0","border-left":"0","border-right":"0"});
                      },
                      show:function(event,ui){

                          if(ui.index == 1){
                              _this.resetPlanInfoSection();
                          }
                        }
                      });

                      if(typeof showtab != "undefined")
                          $("#user-settings-tabcontrol").tabs("select","#"+showtab);
                      
                      $("#user-access-control-list").
                      jqGrid({url:'/ContextAction.do?action=get-context-acl',
                      datatype: "local",
                      postData:{room_id:room_id,participant_id:my_pid,context_id:0},
                      colNames:['To','Name'],
                      colModel:[
                          {name:'apply',index:'apply', align:"center",width:32,sortable:false},
                          {name:'title',index:'title', align:"left",width:256,sortable:false}],
                      rowNum:-1,
                      rowList:[],
                      /*imgpath: gridimgpath,*/
                      /*pager: $('#global-access-control-list-pager'),*/
                      sortname: 'id',
                      viewrecords: true,
                      autowidth: false,
                      width:300,
                      pgbuttons:false,
                      pginput:false,
                      pgtext:false,
                      recordtext:'',
                      height:375,
                      sortorder: "desc",
                      caption:'',
                      gridComplete:function(){
                          //log('gridComplete:'+loadCount);
                          if(--loadCount == 0){
                             callback();
                          }
                      },
                      onSelectRow:function(row_id){
                            if(row_id != "global"){
                                $.ajax({
                                    type:'POST',
                                    data:{room_id:room_id,participant_id:my_pid,granted_to:row_id,this_pid:my_pid},
                                    url:/*'/ContextAction.do?action=get-context-access-list'*/'/PadUIAction.do?action=load-access-control-list',
                                    success:function(data){
                                        var reply = eval('('+data+')');
                                        _this.loadACLSettings(reply);
                                    }
                                });
                            }else{
                                _this.loadACLSettings();
                            }
                      }
                      });//.navGrid('#global-access-control-list-pager',{edit:false,add:false,del:false,search:false,refresh:false});
                      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
                },
                _loadSytemWidgetIds:function(){
                    /*****
                    $.ajax({
                        type:'POST',
                        data:{id:'SYSTEM-WIDGETS',room_access_code:room_access_code,this_pid:my_pid,secure_token:secure_token},
                        url:'actionProcessor.jsp?action=get-text-data',
                        success:function(data){
                            if(data != '')
                                ColabopadApplication.system_widgets = eval('('+data+')');
                        }
                    });
                    *****/
                },
                resizeView:function(){
                  $("#main-view").css({"min-width":($("#inches_to_pixel").width()*8.7)+370,"width":"100%"});
                  var totalWidth = $("#main-view").width();
                  
                  $("#left-sidebar-panel").css({"min-width":"350px","width":(0.295*totalWidth)});
                  $("#ui_center_pane").css({"min-width":($("#inches_to_pixel").width()*8.7)-1,"width":(0.7*totalWidth)-1, "background-color":"white","margin":"0px","padding":"0","margin-left":"1px"});                    
                },
                init:function(){
                   var _this = this;
                   this.resizeView();
                   $(window).resize(this.resizeView);
                   
                   if(typeof phyzixlabs_database != "undefined"){
                       $('.phyzixlabs-not-portable').css("display","none");
                       //phyzixlabs_database.init();
                   }
                   
                   this.resetIframes();
                   
                   if(this.page_screen_mode){
                       $("#application-left-navigation-panel,#participant-tabcontrol-pane,#application-footer").css("display","none");
                   }else{
                       //$("#application-left-navigation-panel").css({"overflow":"auto","height":$(window).height()});
                   }
                   //$("#accordion-usage-tips").accordion();
                   //create border layout for main application
                   this._createUILayout();

                   this._loadData(function(roomObject,workBench,treeObject){
                       
                        //create tab control for participants to whose work this participant would have access
                        _this._createParticipantTabControl();


                        //create tree control that shows participant's work beanch
                        _this._createParticipantTreeControl(treeObject);

                        _this._loadToolBar();

                        _this._loadToolbarMenus();

                        _this._loadMainMenu();

                        _this._loadDialogs();

                        _this._initWidgetControlPanel();

                        _this._loadUIComponents();

                        //this._loadAccessManagerUI();                   

                        _this._loadSytemWidgetIds();

                        //load room including participants
                        _this._loadRoom(roomObject,workBench);
                   });


                   if(typeof Stripe != "undefined")
                    Stripe.setPublishableKey(StripePublicKey);
                },
                usersLoaded:function(reply){          
                  $.unblockUI();
                  this.ui_components.participant_treecontrol.reload();
                  this._loadRoom();
                  
                  if(ColabopadApplication.needUpgrade(reply))return;
                  //current_tree_node.reloadChildren();
                },
                toolbar:{
                    undo_button:$('#undo_btn'),
                    redo_button:$('#redo_btn'),
                    next_pg_button:$('#next-pg-button'),
                    prev_pg_button:$('#prev-pg-button'),
                    del_pg_button:$('#del-pg-button')
                },
                menubar:{
                    filemenu:{
                        newWorkbookMenuItem:{
                            action:function(){
                                $('#work-book-title-context-id').attr("value","");
                                $('#book-dialog').dialog("open");
                            }
                        },
                        newPageMenuItem:{
                            action:function(template){
                                $('#page-title-context-id').attr("value","") ;
                                $('#page-title-page-id').attr("value","");
                                 $('#page-title').attr("value","");
                                
                                ColabopadApplication.newPageTemplate = template;
                                $('#page-title-dialog').dialog("open");
                                
                                //ColabopadApplication.newPg(ColabopadApplication.getCurrentContext(),template);
                            }
                        },
                        openFileItem:{                            
                            action:function(){

                            }
                        },
                        savePageItem:{
                            action:function(type){
                                var fileName = ColabopadApplication.getCurrentContext().active_pad.title;
                                if(type == 'svg'){
                                    window.frames['saveAsSVGInterface'].sendSVG(room_id,fileName,ColabopadApplication.getCurrentContext().active_pad.svg_doc.toSVG(),typeof phyzixlabs_database != "undefined"?phyzixlabs_database.phyzixlabs_host_url:'');
                                }
                                else
                                if(type == 'png'){
                                    //var images = ColabopadApplication.prepareImagesForComposing(ColabopadApplication.getCurrentContext().active_pad);
                                    //alert(images)
                                    $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},message: '<h1><img src="images/misc/busy.gif" />Exporting,please wait...</h1>'});
                                    window.frames['saveAsPNGInterface'].sendSVG(room_id,fileName,ColabopadApplication.getCurrentContext().active_pad.svg_doc.toSVG(),typeof phyzixlabs_database != "undefined"?phyzixlabs_database.phyzixlabs_host_url:'');
                                }
                                else
                                if(type == 'pdf'){
                                    $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},message: '<h1><img src="images/misc/busy.gif" />Exporting,please wait...</h1>'});
                                    //log($('.active-pad').html().length)
                                    //images = ColabopadApplication.prepareImagesForComposing(ColabopadApplication.getCurrentContext().active_pad);
                                    if(/*ColabopadApplication.getCurrentContext().active_pad.template.name !="text-editor"*/typeof ColabopadApplication.getCurrentContext().active_pad.texteditor == "undefined" /*&& typeof ColabopadApplication.getCurrentContext().active_pad.webpageeditor == "undefined"*/)
                                        window.frames['saveAsPDFInterface'].sendSVG(room_id,fileName,ColabopadApplication.getCurrentContext().active_pad.svg_doc.toSVG(),null,typeof phyzixlabs_database != "undefined"?phyzixlabs_database.phyzixlabs_host_url:'');
                                    else{
                                        window.frames['saveAsPDFInterface'].sendSVG(room_id,fileName,ColabopadApplication.getCurrentContext().active_pad.svg_doc.toSVG(),ColabopadApplication.getCurrentContext().active_pad,typeof phyzixlabs_database != "undefined"?phyzixlabs_database.phyzixlabs_host_url:'');
                                    }
                                }
                            }
                        },
                        saveBookItem:{
                            action:function(type){
                                var pages = ColabopadApplication.getCurrentContext().pages;
                                if(type == 'svg'){
                                    //window.frames['saveAsInterface'].sendSVG(ColabopadApplication.getCurrentContext().active_pad.svg_doc.toSVG());
                                }
                                else
                                if(type == 'png'){
                                      //window.frames['saveAsPNGInterface'].sendSVG(ColabopadApplication.getCurrentContext().active_pad.svg_doc.toSVG());
                                }
                                else
                                if(type == 'pdf'){
                                    var cur_page = ColabopadApplication.getCurrentContext().active_pad;
                                    var index = 0;
                                    if(cur_page == pages[0]){
                                       //post this page
                                       index = 1;
                                       window.frames['saveAsPDFInterface'].sendSVGPage(cur_page.svg_doc.toSVG(),cur_page.id,typeof phyzixlabs_database != "undefined"?phyzixlabs_database.phyzixlabs_host_url:'');
                                    }
                                    ColabopadApplication.bookExport = {pages:[],og_page:cur_page};
                                    for(index;index<pages.length;index++){
                                      ColabopadApplication.bookExport.pages.push(pages[index]);
                                    }
                                    if(ColabopadApplication.bookExport.pages.length>0){
                                      ColabopadApplication.addPageLoadCallBack("onPageReadyForExport",ColabopadApplication.onPageReadyForExport);
                                      ColabopadApplication.switchToPage(ColabopadApplication.bookExport.pages.splice(0,1)[0]);
                                    }else{
                                      window.frames['saveAsPDFInterface'].makeBook();
                                    }
                                }
                            }
                        }
                    }
                },
                dragMonitor:{
                    dragged:false,
                    st_pt:null,
                    sp_pt:null
                },
                moduleMoveBtn:{
                    btn:$('#widget-move-button'),
                    sticky:false,
                    _init:function(){
                        this.btn.mousedown(function(p){
                            ColabopadApplication.moduleMoveBtn.sticky=true;
                        });
                        this.btn.mouseup(function(p){
                            ColabopadApplication.moduleMoveBtn.sticky=false;
                        });
                        $('#widget-contrl-panel').draggable({handle:'#widget-move-button',drag:function(event, ui){
                            var p = $('#widget-contrl-panel').position();
                            var pad = ColabopadApplication.getCurrentContext().active_pad;
                            var m = pad.activeWidgetInstance;if(m==null)return;

                            var sct=ColabopadApplication.ui_components.layout.center.scrollTop();
                            var left_scroll = ColabopadApplication.ui_components.layout.center.scrollLeft();
                            //debug("right scroll:"+right_scroll)

                            var trslt = {x:p.left-ColabopadApplication.dragMonitor.st_pt.left,y:p.top-ColabopadApplication.dragMonitor.st_pt.top}
                            m.config.transforms.trslt.x += trslt.x;
                            m.config.transforms.trslt.y += trslt.y;


                            var offset=pad.div_dom.position();
                            var transformedRect = ColabopadApplication.getBoundingBox(ColabopadApplication.transformRectangle(m.config.dim,m.config.transforms));
                            var cpPos = ColabopadApplication.dimToClientCoord({x:transformedRect.tr.x+16+left_scroll,y:transformedRect.tr.y+sct,w:transformedRect.tr.x-transformedRect.tl.x,h:transformedRect.bl.y-transformedRect.tl.y},pad);
                            cpPos.x = offset.left+transformedRect.tr.x-1+left_scroll;


                            if(typeof m.config.header != "undefined" && m.config.header.cpstyle != "inline")
                                $(ColabopadApplication.widgetControlPanelFrame).css({'left':p.left+18+left_scroll,'top':p.top+sct});

                            if(typeof m.config.header != "undefined" && !m.config.header.scalable)
                              $('#widget-scale-button').css("display","none");
                            else
                              $('#widget-scale-button').css({'position':'absolute', 'display':'block','left':cpPos.x-16,'top': (cpPos.y+cpPos.h)-16});


                            if(typeof m.config.header != "undefined" && !m.config.header.rotatable)
                              $('#widget-rotate-button').css("display","none");
                            else
                              $('#widget-rotate-button').css({'position':'absolute', 'display':'block','left':cpPos.x-16,'top': (cpPos.y+cpPos.h)-32});


                            ColabopadApplication.applyTransform(ColabopadApplication.getCurrentContext().active_pad,m,false);

                            ColabopadApplication.dragMonitor.st_pt = p;
                            ColabopadApplication.dragMonitor.dragged = true;
                        },start:function(event, ui){
                            ColabopadApplication.dragMonitor.st_pt = $('#widget-contrl-panel').position();
                        },stop:function(event, ui){
                            if(ColabopadApplication.dragMonitor.dragged){
                                var m = ColabopadApplication.getCurrentContext().active_pad.activeWidgetInstance;
                                ColabopadApplication.applyTransform(ColabopadApplication.getCurrentContext().active_pad,m,true);
                            }
                            ColabopadApplication.dragMonitor.dragged = false;
                        }});
                        return true;
                    }
                },
                moduleDeleteBtn:{
                    btn:$('#widget-delete-button'),
                    sticky:false,
                    _init:function(){
                        /*this.btn.click(function(p){
                            var m = ColabopadApplication.getCurrentContext().active_pad.activeWidgetInstance;
                            ColabopadApplication.deleteWidgetInstance(ColabopadApplication.getCurrentContext().active_pad,m);

                            /*
                            ColabopadApplication.removeUndoNode(m.config.element_id);
                            ColabopadApplication.addToUndoStack({element:{config:m.config,dom:m.svg_node,m:m},type:"delete"});
                            ColabopadApplication.resetRedoStack();
                            *
                           
                            $('#widget-contrl-panel').css("display","none");
                            ColabopadApplication.getCurrentContext().active_pad.activeWidgetInstance = null;
                        });*/
                        return true;
                    }
                },
                widgetHelpBtn:{
                    btn:$('#widget-help-button'),
                    sticky:false,
                    _init:function(){
                        /*this.btn.click(function(p){
                            ColabopadApplication.getCurrentContext().active_pad.activeWidgetInstance.widget.loadHelp();
                        });*/
                        return true;
                    }
                },
                widgetControlPanelBtn:{
                    btn:$('#widget-controlpanel-button'),
                    sticky:false,
                    _init:function(){
                        this.btn.click(function(p){
                            var m = ColabopadApplication.getCurrentContext().active_pad.activeWidgetInstance;

                            if($(ColabopadApplication.widgetControlPanelFrame).css("display")=="block")
                                $(ColabopadApplication.widgetControlPanelFrame).animate({width: 'hide'});
                            else
                                $(ColabopadApplication.widgetControlPanelFrame).animate({width: 'show'});
                        });
                        return true;
                    }
                },
                widgetScaleBtn:{
                    btn:$('#widget-scale-button'),
                    sticky:false,
                    testScaleX:0,
                    _init:function(){
                        this.btn.mousedown(function(p){                            
                            ColabopadApplication.widgetScaleBtn.sticky=true;
                        });
                        this.btn.mouseup(function(p){
                            ColabopadApplication.widgetScaleBtn.sticky=false;
                        });
                        
                        $('#widget-scale-button').draggable({drag:function(event, ui){
                            var p = $('#widget-scale-button').position();
                            var m = ColabopadApplication.getCurrentContext().active_pad.activeWidgetInstance;if(m==null)return;

                            var curWidth  = ColabopadApplication.dragMonitor.st_pt.left-m.config.transforms.trslt.x;
                            var newWidth  = p.left-m.config.transforms.trslt.x;
                            var scaleX    = (newWidth-curWidth)/m.config.dim.w;
                            m.config.transforms.scale.x += scaleX;

                            var curHeight  = ColabopadApplication.dragMonitor.st_pt.top-m.config.transforms.trslt.y;
                            var newHeight  = p.top-m.config.transforms.trslt.y;
                            var scaleY    = (newHeight-curHeight)/m.config.dim.h;
                            m.config.transforms.scale.y += scaleY;


                            //debug('scaleX:'+scaleX)
                            /*
                            var sct=ColabopadApplication.ui_components.layout.center.scrollTop();

                            var trslt = {x:p.left-ColabopadApplication.dragMonitor.st_pt.left,y:p.top-ColabopadApplication.dragMonitor.st_pt.top}
                            m.config.transforms.trslt.x += trslt.x;
                            m.config.transforms.trslt.y += trslt.y;

                            //
                            */
                            ColabopadApplication.applyTransform(ColabopadApplication.getCurrentContext().active_pad,m,false);

                            ColabopadApplication.dragMonitor.st_pt = p;
                            ColabopadApplication.dragMonitor.dragged = true;
                        },start:function(event, ui){
                            ColabopadApplication.dragMonitor.st_pt = $('#widget-scale-button').position();
                            $(ColabopadApplication.widgetControlPanelFrame).css("display","none");
                            $('#widget-contrl-panel').css("display","none");
                            $('#widget-rotate-button').css("display","none");
                        },stop:function(event, ui){
                            
                            if(ColabopadApplication.dragMonitor.dragged){
                                var m = ColabopadApplication.getCurrentContext().active_pad.activeWidgetInstance;
                                ColabopadApplication.applyTransform(ColabopadApplication.getCurrentContext().active_pad,m,true);
                            }
                            ColabopadApplication.dragMonitor.dragged = false;
                        }});
                        return true;
                    }
                },
                widgetRotateBtn:{
                    btn:$('#widget-rotate-button'),
                    sticky:false,
                    lastAngle:0,
                    rotate:function(p){
                         var pad = ColabopadApplication.getCurrentContext().active_pad;
                         var m   = pad.activeWidgetInstance;if(m==null)return;

                         //var offset=pad.div_dom.position();
                         //var transformedRect = ColabopadApplication.getBoundingBox(ColabopadApplication.transformRectangle(m.config.dim,m.config.transforms));
                         //var cpPos = ColabopadApplication.dimToClientCoord({x:transformedRect.tr.x+16,y:transformedRect.tr.y+sct,w:transformedRect.tr.x-transformedRect.tl.x,h:transformedRect.bl.y-transformedRect.tl.y},pad);
                         //cpPos.x = offset.left+transformedRect.tr.x-1;

                         //determine objects center of rotation
                         //var cx = Math.abs(transformedRect.tl.x+( (transformedRect.tr.x-transformedRect.tl.x)/2 ) );
                         //var cy = Math.abs(transformedRect.tl.y+( (transformedRect.br.y-transformedRect.tr.y)/2 ));

                         //determine objects center of rotation
                         var cx = Math.abs(m.config.transforms.trslt.x+(m.config.dim.x + ((m.config.dim.w*m.config.transforms.scale.x)/2) ));
                         var cy = Math.abs(m.config.transforms.trslt.y+(m.config.dim.y + ((m.config.dim.h*m.config.transforms.scale.y)/2) ));

                         var r2d        = (180/Math.PI);
                         var curAngle   = Math.atan2(p.top-cy,p.left-cx)*r2d;                         
                         var delta      = (curAngle - this.lastAngle);

                         //this.pen.rotateElement.accum_rotate.angle += delta;

                         m.config.transforms.rotate.cx = cx;
                         m.config.transforms.rotate.cy = cy;
                         m.config.transforms.rotate.angle += delta;

                         //debug(m.config.transforms.rotate.angle+' cx:'+cx+' cy:'+cy)

                         ColabopadApplication.applyTransform(pad,m,false);
                         this.lastAngle = curAngle;
                    },
                    _init:function(){
                        this.btn.mousedown(function(p){
                            ColabopadApplication.widgetRotateBtn.sticky=true;
                        });
                        
                        this.btn.mouseup(function(p){
                            ColabopadApplication.widgetRotateBtn.sticky=false;                            
                        });
                        
                        $('#widget-rotate-button').draggable({drag:function(event, ui){
                            var p   = $('#widget-rotate-button').position();
                            ColabopadApplication.widgetRotateBtn.rotate(p);
                            ColabopadApplication.dragMonitor.st_pt = p;
                            ColabopadApplication.dragMonitor.dragged = true;
                        },start:function(event, ui){
                            ColabopadApplication.dragMonitor.st_pt = $('#widget-rotate-button').position();
                            $(ColabopadApplication.widgetControlPanelFrame).css("display","none");
                            $('#widget-contrl-panel').css("display","none");
                            $('#widget-scale-button').css("display","none");
                            ColabopadApplication.widgetRotateBtn.lastAngle = 0;
                        },stop:function(event, ui){
                            /*
                            if(ColabopadApplication.dragMonitor.dragged){
                                var m = ColabopadApplication.getCurrentContext().active_pad.activeWidgetInstance;
                                ColabopadApplication.applyTransform(ColabopadApplication.getCurrentContext().active_pad,m.svg_node,m.config,true);
                            }*/
                            ColabopadApplication.dragMonitor.dragged = false;
                        }});
                        return true;
                    }
                },
                pen:{down:false,
                       start_x:0,
                       start_y:0,
                       stroke:null,
                       color:null,
                       stroke_width:1,
                       cur_node:null,
                       moved:false,
                       cur_element_id:(new Date()).getTime(),
                       mode:'pointer',
                       cursor:'np-cursor-pointer',
                       modes:['eraser','text','richtext','freehand','rect','circle','line','move','rotate','image','pointer','fill','resize'],
                       cur_shape_node:null,
                       accumulated_points:null,
                       activeElement:null,
                       rotateElement:null,
                       shape_metric:$('#shape-metric'),
                       textinputer:$('#textinputer'),
                       erase:function(pad,ele,cf){
                               ColabopadApplication.debugRemove(pad,ele,cf);
                               var tid = ele.getAttribute('id');
                               var eleConfig = null;
                               for(var i=0;i<pad.elements.length;i++){
                                  if(pad.elements[i].config.type != 'widget' && pad.elements[i].config.element_id==tid){                                      
                                      eleConfig = pad.elements[i].config;


                                      pad.elements.splice(i,1);
                                      break;
                                  }
                               }


                               //delete from database if necessary
                                  if(eleConfig != null)
                               ColabopadApplication.deleteElement(pad, eleConfig);
                       },
                       eraserListener:function(p){
                           var pad = ColabopadApplication.getCurrentContext().active_pad;

                           if(ColabopadApplication.pen.mode == 'eraser'){
                                if(typeof this.config.header != "undefined" &&
                                  typeof this.config.header.deletable != "undefined" &&
                                  !this.config.header.deletable)
                                  return;

                               try{
                                 //debug('b4 erase')
                                 ColabopadApplication.pen.erase(pad,this,"call from eraserLister");
                                 //debug('after erase')
                                 ColabopadApplication.removeUndoNode(this.getAttribute('id'));
                                 ColabopadApplication.addToUndoStack({element:{config:this.config,dom:this},type:"delete"});
                                 ColabopadApplication.resetRedoStack();
                               }catch(ex){
                                   debug(ex)
                               }                               
                           }
                      },
                      shapeFill:function(){
                          
                            /*
                            if(this.config.config.pen.fill != "none"){
                                //this.setAttribute("fill","none");

                                this.config.config.pen.fill = "none";

                            }else{
                                this.config.config.pen.fill = ColabopadApplication.pen.color;
                                //this.setAttribute("fill",this.config.pen.fill);
                            }*/
                            if(ColabopadApplication.pen.mode == 'fill'){
                                 var undoNode = {element:{config:this.config.config,dom:this,shape_el:this},type:"fill",color:this.config.config.pen.fill};
                                 this.config.config.pen.fill = ColabopadApplication.pen.color;
                                 ColabopadApplication.fillShape(ColabopadApplication.getCurrentContext().active_pad,this.config,true);
                                 ColabopadApplication.addToUndoStack(undoNode);
                                 ColabopadApplication.resetRedoStack();
                            }
                      },
                      ontextinputreturn:function(event){
                          if(event.which==13)
                            return false;
                        else
                            return true;
                      },
                      ontext:function(){
                          var txt = $('#textinputer').attr("value")
                          $('#textinputer').attr("cols",txt.length);
                          return true;
                      }
                },
                getSystemWidget:function(name){
                    for(var i=0;i<this.system_widgets.length;i++){
                        if(this.system_widgets[i].name == name)
                            return this.system_widgets[i];
                    }return null
                },
                bindAccess:function(access_list){
                    var context_list = this.getCurrentParticipantContext().context_list;
		    if(typeof access_list != "undefined"){
		            for(var i=0;i<context_list.length;i++){
		                var cntx = context_list[i];
		                cntx.access[this.ACL_EDIT_INDEX] = 0;

		                var accessCntx = this.getItemById(cntx.id,access_list);
		                if(accessCntx != null){                                    
		                    cntx.access[this.ACL_EDIT_INDEX] = accessCntx.access[0];
                                }
		                //bind pages
		                for(var j=0;j<cntx.pages.length;j++){
		                    var page = cntx.pages[j];
		                    page.access[this.ACL_EDIT_INDEX] = 0;

		                    if(accessCntx != null){
		                        var accessPage = this.getItemById(page.id, accessCntx.pages);
		                        if(accessPage != null)
		                            page.access[this.ACL_EDIT_INDEX] = accessPage.access[0];
		                    }

                                    //bind elements
                                    for(var k=0;k<page.elements.length;k++){
                                        var element = page.elements[k];
                                        element.access[this.ACL_EDIT_INDEX] = 0;

                                        if(accessPage != null){
                                            var accessElement = this.getItemById(element.id, accessPage.elements);
                                            if(accessElement != null)
                                                element.access[this.ACL_EDIT_INDEX] = accessElement.access[0];

                                        }
                                    }
		                }
		            }
		    }else{
		            for(var i=0;i<context_list.length;i++){
		                var cntx = context_list[i];
		                cntx.access[this.ACL_EDIT_INDEX] = cntx.access[this.GLOBAL_ACL_INDEX];

		                //bind pages
		                for(var j=0;j<cntx.pages.length;j++){
		                    var page = cntx.pages[j];
		                    page.access[this.ACL_EDIT_INDEX] = page.access[this.GLOBAL_ACL_INDEX];

                                    //bind elements
                                    for(var k=0;k<page.elements.length;k++){
                                        var element = page.elements[k];
					element.access[this.ACL_EDIT_INDEX] = element.access[this.GLOBAL_ACL_INDEX];
                                    }
		                }
		            }
		    }
                },
                tempBindAccess:function(access_list){
                    var context_list = this.getCurrentParticipantContext().context_list;

                    for(var i=0;i<context_list.length;i++){
                        var cntx = context_list[i];
                        cntx.access[this.access_index] = 0;

                        var accessCntx = this.getItemById(cntx.id,access_list);
                        if(accessCntx != null)
                            cntx.access[this.access_index] = accessCntx.access;
                        
                        //bind pages
                        for(var j=0;j<cntx.pages.length;j++){
                            var page = cntx.pages[j];
                            page.access[this.access_index] = 0;

                            if(accessCntx != null){
                                var accessPage = this.getItemById(page.id, accessCntx.pads);
                                if(accessPage != null)
                                    page.access[this.access_index] = accessPage.access;
                            }
                        }
                    }
                },
                arrangePageNavButtons:function(page){
                     var count = page.context.pages.length;
                     //var index = this.findContexPageIndex(page);

                     this.toolbar.prev_pg_button.removeClass("ui-state-disabled");
                     this.toolbar.prev_pg_button.removeAttr("disabled");
                     this.toolbar.next_pg_button.removeClass("ui-state-disabled");
                     this.toolbar.next_pg_button.removeAttr("disabled");

                     if(count == 1){
                        this.toolbar.next_pg_button.addClass("ui-state-disabled");
                        this.toolbar.next_pg_button.attr("disabled","disabled");

                        this.toolbar.prev_pg_button.addClass("ui-state-disabled");
                        this.toolbar.prev_pg_button.attr("disabled","disabled");
                     }
                     else
                     if(/*index+1 == count*/this.nextPage(false) == null){

                        //disable next page button
                        this.toolbar.next_pg_button.addClass("ui-state-disabled");
                        this.toolbar.next_pg_button.attr("disabled","disabled");
                     }
                     else
                     if(/*index==0*/this.prevPage(false) == null){
                        //disable prev button
                        this.toolbar.prev_pg_button.addClass("ui-state-disabled");
                        this.toolbar.prev_pg_button.attr("disabled","disabled");
                     }

                    if(count>1){
                        //enable delete page button
                        this.toolbar.del_pg_button.removeClass("ui-state-disabled");
                        this.toolbar.del_pg_button.removeAttr("disabled");
                    }else{
                        //enable delete page button
                        this.toolbar.del_pg_button.addClass("ui-state-disabled");
                        this.toolbar.del_pg_button.attr("disabled","disabled");
                    }


                    //setup undo/redo also
                    this.toolbar.undo_button.attr("disabled","disabled");
                    this.toolbar.undo_button.addClass("ui-state-disabled");
                    this.toolbar.redo_button.attr("disabled","disabled");
                    this.toolbar.redo_button.addClass("ui-state-disabled");

                    if(this.undo_stack.length>0){
                        this.toolbar.undo_button.removeAttr("disabled");
                        this.toolbar.undo_button.removeClass("ui-state-disabled");
                    }
                    if(this.redo_stack.length>0){
                        this.toolbar.redo_button.removeAttr("disabled");
                        this.toolbar.redo_button.removeClass("ui-state-disabled");
                    }
                },
                onElementContext:{

                },
                onPageReadyForExport:function(page){
                    //debug('page ready for export:'+page.id)

                    window.frames['saveAsPDFInterface'].sendSVGPage(page.svg_doc.toSVG(),page.id,typeof phyzixlabs_database != "undefined"?phyzixlabs_database.phyzixlabs_host_url:'');

                    if(ColabopadApplication.bookExport.pages.length>0){
                      ColabopadApplication.switchToPage(ColabopadApplication.bookExport.pages.splice(0,1)[0]);
                    }else{
                      //debug('call to removePageLoadCallBack')
                      ColabopadApplication.removePageLoadCallBack("onPageReadyForExport");
                      window.frames['saveAsPDFInterface'].makeBook();

                      //switch to original page
                      ColabopadApplication.switchToPage(ColabopadApplication.bookExport.og_page);
                    }
                },
                onPageSVGTemplateLoaded:function(){

                },
                pixelCompensation:8,
                initPage:function(page,loadcb){
                    ColabopadApplication.hideWidgetControlPanel();
                    var settings = this.Utility.cloneDOMFreeJSON(this._npSettings);
                    //log('initing page, template:'+page.template.name)
                    var _this = this;

                    var divid =  page.context.pid+'-'+page.context.id+'-'+page.id;

                    var displayToolbar = (!embeded && !this.page_screen_mode)?"block":"none";
    
                    $(this.editor_toolbar).css({"display":displayToolbar,"position":"relative"});
                    //page.context.dock/*.empty()*/
                    /*append toolbar to right view */
                    //.append($(this.editor_toolbar).css({"display":displayToolbar,"position":"relative"}));
                    //page.context.dock.append(this.content_view_scrollpane);
                    
                    $("#tab-content-holder").find("div").detach();
                    //$("#tab-content-holder");//.css({"margin-top":"2px"}).append(this.content_view_scrollpane);
                    
                    
                    
                    /*create containing div for new page*/
                    $("#tab-content-holder").append('<div id="notepad-'+divid+'" class="active-pad"></div>');

                    //$('#participant-tabcontrol').css({"width":page.size_scale.x*this.default_tabview_size.width});
                    //this._loadToolBar();
                    
                    //var cpHeight = $("#participant-tabcontrol-pane").height();
                    //$("#participant-tabcontrol-pane").css({"left":"350px", "top":$(document).height()-cpHeight});

                    //$("#ui_center_pane").css({"width":$(window).width()-358,"background-color":"white","margin":"0px","padding-top":"0"});

                    if(embeded){
                        
                    }else{
                        $("#tab-content-holder").css({"overflow":"scroll"});
                        var cpHeight =  $(this.editor_toolbar).height()+3;
                        $("#tab-content-holder").height($(window).height()-cpHeight);
                    }
                    //log("cp height:"+cpHeight);
                    /*$("#participant-tabcontrol-pane").position({
                        of: /*this.content_view_scrollpane*$(document),
                        my: 'left bottom',
                        at: 'left bottom',
                        offet:'350 0'
                     });                */     
                    
                    $('#workspace-help-button,#package-ebook-btn').removeAttr("disabled"); 
                                        
                    
                    page.widget_ref_count = 0;
                    //this.reloadEditorToolBar($('#notepad-'+divid+'-toolbar'));

                        /* $('input#textinputer').autoGrowInput({
                            comfortZone: 50,
                            minWidth: 200,
                            maxWidth: 2000
                        })*/;

                    //create page div
                    page.div_dom = $('#notepad-'+divid);
                    $(page.div_dom);//.resizable();

                    

                    //set current page
                    page.context.active_pad = page;
                    $(page.div_dom).addClass("notepad");//.css({"border-style":"solid","border-width":"2px","z-index":"10","width":"300px"});
       
       
                    if(embeded){
                        $(page.div_dom).height(embed_height-10);
                        $(page.div_dom).width(embed_width-8);
                        $(page.div_dom).css({"padding":"0","margin":"0"});
                    }
                    //$(page.div_dom).css({"width":page.size_scale.x*this.default_tabview_size.width});
                    //$(page.div_dom).height(page.size_scale.y*settings.height);
                    //log("scale y:"+(page.size_scale.y*this.default_tabview_size.height)+" y:"+page.size_scale.y+" height:"+this.default_tabview_size.height);
                    if(!embeded){
                        //$(page.div_dom).height(page.size_scale.y*settings.height);
                    }
                                        //if(page.template.name=="text-editor")
                    //    $(page.div_dom).addClass("notepad-text-editor");

                    var write_access = /*(page.context.access[2]&this.ACCESS_MODE.WRITE)>0 || */ (page.access[2]&this.ACCESS_MODE.WRITE)>0 || (page.context.access[0]&this.ACCESS_MODE.WRITE)>0 || (page.access[0]&this.ACCESS_MODE.WRITE)>0;
                    
                    
                    if(write_access || embeded){
                        
                        //set cursors and other styling
                        if(page.template.name=="black-board"){
                            $(page.div_dom).addClass(this.pen.cursor+"-bb");
                        }
                        else{
                            $(page.div_dom).addClass(this.pen.cursor);
                        }
                        //attach mouse event handlers
                        page.div_dom.mousedown(this.mousedown);
                        page.div_dom.mousemove(this.mousemove);
                        page.div_dom.mouseup(this.mouseup);
                        page.div_dom.mouseleave(this.mouseout);
                        page.div_dom.mouseenter(this.mouseenter);
                    }


                    var finishPageCreation = function(){
                         if(!embeded){
                             if(write_access && !_this.page_screen_mode){
                                  var p = page.div_dom.offset();
                                  var w = page.div_dom.width()+_this.pixelCompensation/*this is a hack*/;
                                  var sct=ColabopadApplication.ui_components.layout.center.scrollTop();

                                  //log("left:"+(p.left+w+20)+",top:"+(p.top+sct+25));
                                  $('#floating-toolbox-toolbar').css({"display":"block","position":"absolute","left":p.left+w+20,"top":p.top+sct+25});
                                  $(document).scroll();
                                  _this.pixelCompensation = 0;
                                  //$(page.context.dock).append(_this.pen.textinputer);
                              }else{
                                  $('#floating-toolbox-toolbar').css({"display":"none"});
                              }
                              _this.setPageToolbarAccess(page);
                              if(page.context.isMyCatalog || typeof page.context.clientside == "undefined" || !page.context.clientside)
                                _this.ContextMenus.bindPadContextMenu();
                              else{
                                   $('#new-page-tb-btn,#delete-page-tb-btn').attr("disabled","disabled").addClass("ui-state-disabled");
                              }
                         }

                        if(page.newly_created){
                            //create ebeded text editor if necessary
                            if(page.template.name == "text-editor"){
                                _this.newWidget(embeded_text_editor_classid,'prod');
                            }
                            else
                            if(page.template.name == "web-page"){
                                _this.newWidget(embeded_web_page_classid,'prod');
                            }
                        }

                         //attach this page to all widget operations
                         _this.setSinkPad(page);
                         if(typeof loadcb!="undefined")
                            loadcb(page);

                          page.newly_created = false;

                          ++_this.app_ready;
                          if(_this.app_ready == 2)//unblock app loading,not perfect but...
                          {
                                $.unblockUI();
                                $('#main-overlay').removeClass('ui-widget-overlay');
                                _this.checkUserStatus();
                          }
                    }

                    
                    //settings.width  = page.size_scale.x*settings.width;
                    //settings.height = page.size_scale.y*settings.height;
                    
                    //log("page dimensions("+settings.width+","+settings.height+")");
                    //load page template
                    $(page.div_dom).svg({onLoad: function(svg){
                         if(page.div_dom == null)return;

                         page.svg_doc=svg;
                         page.content_root_svg = svg.group();
                         
                         //create annotation layer
                         var width              = page.svg_doc.root().width.baseVal.value;
                         var height             = page.svg_doc.root().height.baseVal.value;
                         //log("page dimensions 2("+width+","+height+")");
                         
                         if(!embeded){
                            $(page.div_dom).width(settings.width);
                            $(page.div_dom).height(settings.height);
                       
                            page.svg_doc.change( page.svg_doc.root(),{/*"fill":"#579aec","opacity":".1","stroke":"#579aec","stroke-width":"3",*/"width":settings.width,"height":settings.height})
                         }
                         
                         //log("annotation layer dimensions:("+width+","+height+")")
                         page.annotation_layer  = page.svg_doc.rect(page.content_root_svg.parentNode,0,0,settings.width,settings.height,{"pointer-events":"visible","fill":"none","display":"none"});
                         //page.svg_doc.remove(layer);
                         //page.content_root_svg.parentNode.insertBefore(layer,page.content_root_svg);
                         
                         page.snap_handle_tl = page.svg_doc.circle(0,0,10,{id:'handle-tl',display:'none',fill:'yellow',stroke:'gray',strokeWidth:2});
                         page.snap_handle_tr = page.svg_doc.circle(0,0,10,{id:'handle-tr',display:'none',fill:'yellow',stroke:'gray',strokeWidth:2});
                         page.snap_handle_bl = page.svg_doc.circle(0,0,10,{id:'handle-bl',display:'none',fill:'yellow',stroke:'gray',strokeWidth:2});
                         page.snap_handle_br = page.svg_doc.circle(0,0,10,{id:'handle-br',display:'none',fill:'yellow',stroke:'gray',strokeWidth:2});
                         finishPageCreation();
                         _this.showAnnotationLayer();
                         
                    },loadURL:embeded?'a1/secure_url_resource?r='+page.template.url:page.template.url,settings:settings});
                
                    
                    if(!embeded){
                        var sct=ColabopadApplication.ui_components.layout.center.scrollTop();
                        var p = page.div_dom.parent().parent().position();

                        this.undo_stack = page.undo_stack;
                        this.redo_stack = page.redo_stack;
                        this.arrangePageNavButtons(page);
                    }
                },
                forceReady:function(){            
                   
                   $.unblockUI();
                   $('#main-overlay').removeClass('ui-widget-overlay');
                   this.checkUserStatus();  
                },
                showContextTabImpl:function(cntx){
                    
                    if(cntx.selected)
                        this.setUpView(cntx.pid, cntx.id,cntx.active_pad!=null?cntx.active_pad.id:-1,"context-tab-clicked");
                    else
                        cntx.selected = true;
                },
                selectedCntx:0,
                onShowContextTab:function(event, ui){
                    var cntx = ColabopadApplication.getContextByTabId(ui.panel.id);
                    ColabopadApplication.selectedCntx = ui.index;

                    if(cntx != null){
                        ColabopadApplication.showContextTabImpl(cntx);
                    }
                },
                showParticipantContextTabImpl:function(part_cntx){
                   if(part_cntx.selected)
                        this.setUpView(part_cntx.id,part_cntx.current_context!=null?part_cntx.current_context.id:-1,part_cntx.current_context.active_pad!=null?part_cntx.current_context.active_pad.id:-1,"participant-context-tab-clicked");
                    else
                        part_cntx.selected = true;
                },
                selectedParticipantCntx:0,
                onShowParticipantContextTab:function(event,ui){
                    ColabopadApplication.active_top_tab_id = ui.panel.id;
                    if(ui.panel.id == "main-home-tab" || ui.panel.id == "participant-tab-user-settings"){
                        $('#floating-toolbox-toolbar').css({"display":"none"});
                        //unload current page if necessary
                        if(ColabopadApplication.getCurrentParticipantContext()!=null){
                            if(ColabopadApplication.getCurrentContext() != null){
                                ColabopadApplication.unloadPage(ColabopadApplication.getCurrentContext().active_pad);
                            }
                        }
                        return;
                    }
                    
                    var part_cntx = ColabopadApplication.getParticipantContextByTabId(ui.panel.id);
                    ColabopadApplication.selectedParticipantCntx = ui.index;

                    if(part_cntx.id == ColabopadApplication.user_id){
                        var sct=ColabopadApplication.ui_components.layout.center.scrollTop();
                        var p = $('#'+part_cntx.tabid).position();
                        if(ColabopadApplication.new_cntx_pos == 0)
                        {
                            var w = $('#'+part_cntx.tabid).width()-20;
                            ColabopadApplication.new_cntx_pos = p.left+w;
                        }
                        //$('#new-workbook-btn').css({"display":"block","position":"absolute","left":ColabopadApplication.new_cntx_pos,"top":p.top+sct+20,"width":22,"height":20}).removeAttr("disabled");
                    }else{
                        //$('#new-workbook-btn').css({"display":"none"});
                    }

                    if(part_cntx != null)
                        ColabopadApplication.showParticipantContextTabImpl(part_cntx);
                },
                switchToPage:function(page){
                     //hide current page
                     //$(page.context.active_pad.div_dom).css("display","none");

                     //trigger switch from same location
                     var key = 'key-'+page.context.pid+'-'+page.context.id+'-'+page.id;
                     
                     $("#participant-treecontrol").dynatree('getTree').activateKey(key);


                     /*
                     //switch to new page
                     page.context.active_pad = page;
                     
                     $(page.context.active_pad.div_dom).css("display","block");

                     this.arrangePageNavButtons(page);
                     
                     //reset widget sinks
                     this.setSinkPad(page);

                     //sendMessage({sender_id:sessionId,type:'new-page',template:page.template,elements:this.current_context.active_pad.elements,src_view:this.curView,editor_to:this.editor_to});
                    */
                },
                addBinder:function(bookName,teamspace,createdefaultpage,cb,queue_url,reply){
                    var _this = this;
                    if(ColabopadApplication.needUpgrade(reply))return;


                    if(reply.status == 'success'){
                        var cntx = {id:reply.id,meta_data:{title:bookName,queue_url:queue_url,teamspace:teamspace},access:[3,0,15],pads:[]};
                        if(typeof phyzixlabs_database != "undefined"){
                            phyzixlabs_database.addBinder(cntx);
                        }
                        
                        var context = _this.initContext(_this.getCurrentParticipantContext(),cntx,true);

                        ColabopadApplication.ContextMenus.bindWorkbookContextMenu("workbookMenu-me");

                        if(createdefaultpage){
                            _this.setCurrentContext(context);
                            ColabopadApplication.newPg(context,"text-editor");
                        }

                        if(typeof cb != "undefined")cb(context);
                    }                    
                },
                newWorkbookImpl:function(bookName,teamspace,createdefaultpage,cb){
                    var _this = this;
                    var queue_url =   'dest.'+(new Date().getTime());
                    
                    if(typeof phyzixlabs_database == "undefined"){
                        $.ajax({
                            type:'POST',
                            data:{room_id:room_id,grantor:_this.getCurrentParticipantContext().id,config:"{title:'"+bookName+"',queue_url:'"+queue_url+"',teamspace:"+teamspace+"}"},
                            url:'/ContextAction.do?action=add-context&teamspace='+teamspace,
                            success:function(data){                            
                                var reply = eval('('+data+')');
                                _this.addBinder(bookName,teamspace,createdefaultpage,cb,queue_url,reply);
                            }
                        });
                    }else{
                        var reply = {id:new Date().getTime(),status:'success'};
                        _this.addBinder(bookName,teamspace,createdefaultpage,cb,queue_url,reply);
                    }
                },
                newWorkbook:function(teamspace,createdefaultpage,cb){
                    var _this = this;

                    if($('#work-book-title-context-id').attr("value") != ""){
                        //update
                        var cntx = this.getContext($('#work-book-title-pid').attr("value"),$('#work-book-title-context-id').attr("value"));
                        var key  = 'key-'+$('#work-book-title-pid').attr("value")+'-'+$('#work-book-title-context-id').attr("value");

                        var node = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(key);
                        var newTitle = $('#work-book-title').attr("value");
                        this.updateContext(cntx,{title:newTitle,queue_url:cntx.queue_url});
                        
                        cntx.title =  newTitle;
                        node.data.title = newTitle;
                        $("#participant-treecontrol").dynatree('getTree').redraw();

                        $('#work-book-title-pid,#work-book-title-context-id').attr("value","");
                        return;
                    }
                    var bookName = $('#work-book-title').attr("value")==''?'New Binder':$('#work-book-title').attr("value");
                    this.newWorkbookImpl(bookName,teamspace,createdefaultpage,cb);
                },
                addNewPage:function(context,tmplt,title,cb,index,static_references,queue_url,page_config,reply){
                    var _this = this;
                    if(ColabopadApplication.needUpgrade(reply))return;


                    var contextNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey('key-'+context.pid+'-'+context.id);

                    //enable remove menu option for this node since it isn't the only one anymore
                    /*
                    if(context.pages.length==1){
                            var key = 'key-'+context.pid+'-'+context.id+'-'+context.active_pad.id;
                            var node = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(key);
                            node.data.addClass = 'padnode';
                            $("#participant-treecontrol").dynatree('getTree').redraw();
                    }*/

                    var nodeclass = /*context.pages.length==0*/false?'padnode0':'padnode';
                    var page = {
                                room_id:room_id,
                                participant_id:context.pid,
                                pid:context.pid,
                                context_id:reply.context_id,
                                id:reply.id,
                                title:page_config.title,
                                template:_this.getPageTemplate(tmplt),
                                header:page_config.header,
                                svg_doc:null,
                                context:context,
                                widget_instances:[],
                                elements:[],
                                activeWidgetInstance:null,
                                div_dom:null,
                                loaded:false,
                                access:[0,0,3,0],
                                access_index:0,
                                queue_url:queue_url,
                                loaded_from_db:true,
                                last_insert:0,
                                clicked:true,
                                load_callbacks:[],
                                newly_created:true,
                                undo_stack:[],
                                redo_stack:[]};
                    var remote_page = {
                                        room_id:room_id,
                                        participant_id:context.pid,
                                        pid:context.pid,
                                        context_id:reply.context_id,
                                        id:reply.id,
                                        title:page_config.title,
                                        template:_this.getPageTemplate(tmplt),
                                        header:page_config.header,
                                        svg_doc:null,
                                        context:null,
                                        widget_instances:[],
                                        elements:[],
                                        activeWidgetInstance:null,
                                        div_dom:null,
                                        loaded:false,
                                        access:[0,0,0,0],
                                        access_index:0,
                                        queue_url:queue_url,
                                        loaded_from_db:false,
                                        last_insert:0,
                                        clicked:true,
                                        newly_created:true,
                                        undo_stack:[],
                                        redo_stack:[]};
                    context.pages.push(page);
                    //alert(reply.context_id)
                    var padNode = {isFolder:false,addClass:nodeclass,key:'key-'+context.pid+'-'+reply.context_id+'-'+reply.id,pid:context.pid,context_id:reply.context_id,id:reply.id, title:page_config.title,type:'pad'};
                    
                    var curPage     = ColabopadApplication.getCurrentContext().active_pad;
                    var curPageKey  = '';
                    var curPageNode = null;                    
                    

                    
                    if(reply.pre_sibling != 0 && reply.parent_id != 0){
                        curPageKey  = 'key-'+context.pid+'-'+context.id+'-'+reply.pre_sibling;
                        curPageNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(curPageKey);
                        
                        curPageNode.getParent().addChild(padNode,curPageNode.getNextSibling());
                    }
                    else
                    if(reply.pre_sibling == 0 && reply.parent_id != 0){
                        curPageKey  = 'key-'+context.pid+'-'+context.id+'-'+reply.parent_id;
                        curPageNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(curPageKey);
                        
                        curPageNode.addChild(padNode,curPageNode.getChildren() != null && curPageNode.getChildren().length>0?curPageNode.getChildren()[0]:null);                        
                    }
                    else
                    if(reply.pre_sibling != 0 && reply.parent_id == 0){                        
                        curPageKey  = 'key-'+context.pid+'-'+context.id+'-'+reply.pre_sibling;
                        curPageNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(curPageKey);
                        
                        contextNode.addChild(padNode,curPageNode.getNextSibling());
                    }      
                    else
                    if(reply.pre_sibling == 0 && reply.parent_id == 0){
                        contextNode.addChild(padNode,contextNode.getChildren() != null &&contextNode.getChildren().lenght>0?contextNode.getChildren()[0]:null);
                    }             
                    else{
                        contextNode.addChild(padNode);
                    }

                    ColabopadApplication.ContextMenus.bindWorkbookPageContextMenu();

                    if(typeof cb != "undefined")cb(page,index);

                    //load the first page of first context
                    if(typeof index == "undefined" || index==-1)
                        $("#participant-treecontrol").dynatree('getTree').activateKey(padNode.key) ;

                    //propagate to queue
                    if(context.queue_url){                                    
                        ColabopadApplication.MsgHandler.sendMessage({to:context.queue_url,message:{header:{type:"new-page",src_session:sessionId,pid:context.pid,cntx_id:context.id},config:remote_page}});
                    }                    
                },             
                newPg:function(context,tmplt,title,cb,index,static_references){
                    var _this = this;                    
                    if(typeof context.local != "undefined"){
                        
                        if($('#page-title-context-id').attr("value") != "" && $('#page-title-page-id').attr("value") != ""){
                            //update
                            var page = this.getContextPage(context.pid,$('#page-title-context-id').attr("value"), $('#page-title-page-id').attr("value"));
                            var key  = 'key-'+context.pid+'-'+$('#page-title-context-id').attr("value")+'-'+$('#page-title-page-id').attr("value");

                            var node = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(key);
                            var newTitle = $('#page-title').attr("value");
                            node.data.title = newTitle;
                            $("#participant-treecontrol").dynatree('getTree').redraw();

                            page.title =  newTitle;

                            this.updatePad(page, {header:page.header,title:newTitle,template:page.template.name,queue_url:page.queue_url,"size_scale":typeof page.size_scale != "undefined"?page.size_scale:{"x":1,"y":1}});

                            $('#page-title-pid,#page-title-context-id,#page-title-page-id').attr("value","");

                            //propagate to queue
                            if(context.queue_url){
                                ColabopadApplication.MsgHandler.sendMessage({to:context.queue_url,message:{header:{type:"rename-page",src_session:sessionId,pid:context.pid,cntx_id:context.id,page_id:page.id},title:newTitle}});
                            }
                            return;
                        }
                        else
                        if($('#page-title-context-id').attr("value") != ''){
                            //context = this.getContext($('#page-title-context-id').attr("value"));
                        }

                        var parent_id   = 0;
                        var pre_sibling = 0;

                        if(context.pages.length>0 && context.active_pad != null){
                            
                            var curPage     = context.active_pad;
                            var curPageKey  = 'key-'+context.pid+'-'+curPage.context_id+'-'+curPage.id;
                            var curPageNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(curPageKey);


                            var insertPos = $('input:radio[name=page_position]:checked').val();
                            if(insertPos == "before"){
                                pre_sibling = curPageNode.getPrevSibling() != null?curPageNode.getPrevSibling().data.id:0;
                                parent_id   = curPageNode.getParent().data.type != "context"?curPageNode.getParent().data.id:0;
                            }
                            else
                            if(insertPos == "append"){
                                parent_id = curPageNode.data.id;
                            }
                            else
                            if(insertPos == "after"){
                                pre_sibling = curPageNode.data.id;
                                parent_id   = curPageNode.getParent().data.type != "context"?curPageNode.getParent().data.id:0;
                            }
                            else
                            if(insertPos == "bottom" && curPageNode != null){
                                var curLastNode = curPageNode;
                                while(curLastNode.getNextSibling()){
                                    if(curLastNode.getNextSibling().data.type == "pad")//avoid assignment submission node
                                        curLastNode = curLastNode.getNextSibling();
                                    else
                                        break;
                                }

                                pre_sibling = curLastNode.data.id;
                                parent_id   = curPageNode.getParent().data.type != "context"?curPageNode.getParent().data.id:0;
                            }
                        }
                        else
                        if(context.pages.length>0){
                            pre_sibling = context.pages[context.pages.length-1].id;
                        }
                        
                        var queue_url = 'dest.'+(new Date().getTime());
                        var page_config = {
                           header:{static_references: typeof static_references != "undefined"?static_references:[]},
                           title:typeof title != "undefined"?title:"new-page",
                           template:tmplt,
                           queue_url:queue_url
                        };

                        
                        if(typeof phyzixlabs_database == "undefined"){ //alert(pre_sibling+"/"+curPageNode+"/"+insertPos)
                            //load work bench
                            $.ajax({
                                type:'POST',
                                data:{room_id:room_id,grantor:context.pid,context_id:context.id,parent_id:parent_id,pre_sibling:pre_sibling,config:ColabopadApplication.MsgHandler.json2Txt(page_config)},
                                url:'/PadAction.do?action=add-pad',
                                success:function(data){
                                    //alert(parent_id+"/"+pre_sibling)
                                    var reply = eval('('+data+')');
                                    reply.parent_id = parent_id;
                                    reply.pre_sibling = pre_sibling;
                                    _this.addNewPage(context,tmplt,title,cb,index,static_references,queue_url,page_config,reply);
                                }
                            });
                        }else{
                            var id = new Date().getTime();                            
                            _this.addNewPage(context,tmplt,title,cb,index,static_references,queue_url,page_config,{context_id:context.id,id:id,parent_id:parent_id,pre_sibling:pre_sibling});
                            phyzixlabs_database.addPage(context,{"created_by":user_id,"create_date":new Date().getTime(),id:id,"meta_data":page_config,"access":[3,0,3,0],"embed_key":"1bb8cf4d5aa284af4b116e2b572a9fde",parent_id:parent_id,pre_sibling:pre_sibling});
                        }
                    }else{

                    }
                },
                delPage:function(page,dont_prompt,onlyCleanup){

                    if(typeof(dont_prompt) == "undefined" && !confirm("Are you sure you want to delete this page?"))return;
                    
                    var pad = typeof(page)=="undefined"?ColabopadApplication.getCurrentContext().active_pad:page;

                    //clean applets
                    for(var i=0;i<pad.widget_instances.length;i++){
                        var m = pad.widget_instances[i];
                        
                        pad.widget_instances.splice(i,1);
                        if(typeof(m.widget.onDeleteInstance) != "undefined"){
                          //log('deleting widget:'+m.widget.onDeleteInstance)
                          m.widget.onDeleteInstance(pad,m);
                        }
                        if(typeof(m.widget.onClosePad) != "undefined"){
                          //log('deleting widget:'+m.widget.onDeleteInstance)
                          m.widget.onClosePad(pad,m);
                        }
                    }

                    var index = this.findPageIndex(pad);

                    this.unloadPage(pad,true);

                    //remove page from treeview
                    var key = 'key-'+pad.context.pid+'-'+pad.context.id+'-'+pad.id;
                    //alert(key)
                    $("#participant-treecontrol").dynatree('getTree').getNodeByKey(key).remove();


                    //switch to new page
                    if(pad.context.pages.length>1){
                        if(index+1==pad.context.pages.length)
                          pad.context.active_pad = pad.context.pages[index-1];
                        else
                          pad.context.active_pad = pad.context.pages[index+1];
                    }else{
                          pad.context.active_pad = null;
                    }

                     //remove page from list
                     pad.context.pages.splice(index,1);

                     if(onlyCleanup)return;

                     //delete from database
                     this.deletePage(pad);


                     //always ensure there is at least one page in a book
                     if(typeof(dont_prompt) == "undefined"){
                         if(pad.context.active_pad==null)
                            this.newPg(pad.context, 'text-editor');
                         else
                            this.switchToPage(pad.context.active_pad);
                     
                         //disable remove option if there's only one page left
                         /*
                         if(pad.context.pages.length==1){
                             key = pad.context.id+'-pad-'+pad.context.active_pad.id;
                             var node = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(key);
                             node.data.addClass = 'padnode0';
                             $("#participant-treecontrol").dynatree('getTree').redraw();
                         }
                         */
                         ColabopadApplication.ContextMenus.bindWorkbookPageContextMenu();

                        //propagate to queue
                        if(pad.context.queue_url){
                            ColabopadApplication.MsgHandler.sendMessage({to:pad.context.queue_url,message:{header:{type:"del-page",src_session:sessionId,pid:pad.context.pid,cntx_id:pad.context.id,page_id:pad.id}}});
                        }
                     }
                },
                getFirstChildNode:function(children){
                    if(children == null) return null;
                    
                    for(var i=0;i<children.length;i++){
                        if(children[i].isFirstSibling())return children[i];
                    }return null;
                },
                getLastChildNode:function(children){
                    if(children == null) return null;
                    
                    for(var i=children.length-1;i>=0;i--){
                        if(children[i].isLastSibling())return children[i];
                    }return null;
                },
                getNextPageNode:function(node){
                    if(node.hasChildren()){
                        return this.getFirstChildNode(node.getChildren());
                    }
                    else
                    if(node.getNextSibling() != null)
                        return node.getNextSibling();
                    else
                    if(node.getParent().data.type == "pad")
                    {
                        return node.getParent().getNextSibling();
                    }return null;
                },
                nextPage:function(activate){
                     var key = 'key-'+this.getCurrentContext().active_pad.context.pid+'-'+this.getCurrentContext().active_pad.context.id+'-'+this.getCurrentContext().active_pad.id;
                     var nextNode = this.getNextPageNode($("#participant-treecontrol").dynatree('getTree').getNodeByKey(key));
                     if(nextNode != null && (typeof activate == "undefined" || activate != false))
                         nextNode.activate();
                     return nextNode;
                    // var index = this.findPageIndex(this.getCurrentContext().active_pad);                     
                    // this.switchToPage(this.getCurrentContext().pages[index+1])
                },
                getPrevPageNode:function(node){
                    if(node.getPrevSibling() != null){
                        if(node.getPrevSibling().hasChildren()){
                            return this.getLastChildNode(node.getPrevSibling().getChildren());
                        }
                        else
                        return node.getPrevSibling();
                    }
                    else
                    if(node.getParent().data.type == "pad")                    
                        return node.getParent();
                    return null;
                },
                prevPage: function(activate){
                     var key = 'key-'+this.getCurrentContext().active_pad.context.pid+'-'+this.getCurrentContext().active_pad.context.id+'-'+this.getCurrentContext().active_pad.id;
                     var prevNode = this.getPrevPageNode($("#participant-treecontrol").dynatree('getTree').getNodeByKey(key));
                     if(prevNode != null && (typeof activate == "undefined" || activate != false))
                         prevNode.activate();                    
                    return prevNode;
                     //var index = this.findPageIndex(this.getCurrentContext().active_pad);
                     //this.switchToPage(this.getCurrentContext().pages[index-1])
                },
                findContexPageIndex:function(pad){
                    for(var i =0;i<pad.context.pages.length;i++){
                        if(pad.id==pad.context.pages[i].id)
                            return i;
                    }return 0;
                },
                findPageIndex:function(p){
                    for(var i =0;i<p.context.pages.length;i++){
                        if(p.id==p.context.pages[i].id){
                            
                            return i;
                        }

                    }
                    
                    return 0;
                },
                getWidgetInstance:function(id,pad){
                    for(var i=0;i<pad.widget_instances.length;i++){
                        var m = pad.widget_instances[i];
                        if(id==m.config.dbid){
                            return m;
                        }
                    }return null;
                },
                rotatePoint:function(point,beta,center){
                    //translate so it is relative to origin
                    var normX = point.x-center.x;
                    var normY = point.y-center.y;
                    var rad2deg = Math.PI/180;
                    var beta_rad = rad2deg*beta;
                    
                    //rotate about origin
                    var x1 = (Math.cos(beta_rad)*normX)-(Math.sin(beta_rad)*normY);
                    var x2 = (Math.cos(beta_rad)*normY)+(Math.sin(beta_rad)*normX);


                    //translate back to center
                    x1 += center.x;
                    x2 += center.y;
                    /**
                    var x1 = origin.x+(Math.cos(beta)*p.x)+(Math.sin(beta)*p.y);
                    var x2 = origin.y+(Math.cos(beta)*p.y)-(Math.sin(beta)*p.x);
                    **/
                    //if(beta != 0)
                    //   debug('original point: ('+point.x+','+point.y+') transformed:('+x1+','+x2+') angle:'+beta+' org:('+center.x+','+center.y+')' );
                    return {x:x1,y:x2};
                },
                vertizeRectangle:function(rect){
                    var tl = {x:rect.x,y:rect.y};
                    var tr = {x:rect.x+rect.w,y:rect.y};
                    var bl = {x:rect.x,y:rect.y+rect.h};
                    var br = {x:rect.x+rect.w,y:rect.y+rect.h};
                    return {tl:tl,tr:tr,bl:bl,br:br};
                },
                translateRectangle:function(rect,transforms){
                    var tl     = {x:rect.tl.x+transforms.trslt.x,y:rect.tl.y+transforms.trslt.y};
                    var tr     = {x:rect.tr.x+transforms.trslt.x,y:rect.tr.y+transforms.trslt.y};
                    var bl     = {x:rect.bl.x+transforms.trslt.x,y:rect.bl.y+transforms.trslt.y};
                    var br     = {x:rect.br.x+transforms.trslt.x,y:rect.br.y+transforms.trslt.y};
                    return {tl:tl,tr:tr,bl:bl,br:br};
                },
                rotateRectangle:function(rect,transforms){
                    var center = null;
                    
                    if(isNaN(transforms.rotate.cx)){
                        center = {x:rect.tr.x-((rect.tr.x-rect.tl.x)/2),y:rect.br.y-((rect.br.y-rect.tr.y)/2)};
                        transforms.rotate.cx = center.x;
                        transforms.rotate.cy = center.y;
                    }else{
                        center = {x:transforms.rotate.cx-transforms.trslt.x,y:transforms.rotate.cy-transforms.trslt.y};
                    }
                    //debug('c1('+center.x+','+center.y+')');
                    //debug('c2('+center2.x+','+center2.y+')');

                    var beta   = transforms.rotate.angle;
                    var tl     = this.rotatePoint(rect.tl, beta,center);
                    var tr     = this.rotatePoint(rect.tr, beta,center);
                    var bl     = this.rotatePoint(rect.bl, beta,center);
                    var br     = this.rotatePoint(rect.br, beta,center);
                    return {tl:tl,tr:tr,bl:bl,br:br};
                },
                scaleRectangle:function(rect,transforms){                    
                    var tl     = {x:rect.tl.x,y:rect.tl.y};
                    var tr     = {x:rect.tl.x+((rect.tr.x-rect.tl.x)*transforms.scale.x),y:rect.tr.y};
                    var bl     = {x:rect.bl.x,y:rect.tl.y+((rect.bl.y-rect.tl.y)*transforms.scale.y)};
                    var br     = {x:rect.tl.x+((rect.tr.x-rect.tl.x)*transforms.scale.x),y:rect.tl.y+((rect.bl.y-rect.tl.y)*transforms.scale.y)};
                    return {tl:tl,tr:tr,bl:bl,br:br};
                },
                transformRectangle:function(dim,transforms){
                    var rect = this.vertizeRectangle(dim);
                    return this.translateRectangle(this.rotateRectangle(this.scaleRectangle(rect,transforms),transforms),transforms);
                },
                getMin:function(vals){
                    var min = vals[0];
                    for(var i=0;i<vals.length;i++){
                        if(vals[i]<min)
                            min = vals[i];
                    }return min;
                },
                getMax:function(vals){
                    var max = vals[0];
                    for(var i=0;i<vals.length;i++){
                        if(vals[i]>max)
                            max = vals[i];
                    }return max;
                },
                getBoundingBox:function(v){
                    var min_x =  this.getMin([v.tl.x,v.tr.x,v.bl.x,v.br.x]);
                    var max_x =  this.getMax([v.tl.x,v.tr.x,v.bl.x,v.br.x]);
                    var min_y =  this.getMin([v.tl.y,v.tr.y,v.bl.y,v.br.y]);
                    var max_y =  this.getMax([v.tl.y,v.tr.y,v.bl.y,v.br.y]);
                    return {tl:{x:min_x,y:min_y},tr:{x:max_x,y:min_y},bl:{x:min_x,y:max_y},br:{x:max_x,y:max_y}};
                },
                getWidgetBoundingBox:function(w){
                    return this.getBoundingBox(this.transformRectangle(w.config.dim, w.config.transforms));
                },
                printRectangle:function(rect){
                  debug('('+rect.tl.x+','+rect.tl.y+')('+rect.tr.x+','+rect.tr.y+')('+rect.bl.x+','+rect.bl.y+')('+rect.br.x+','+rect.br.y+')');
                },
                findWidget:function(p,pad){
                    for(var i=0;i<pad.widget_instances.length;i++){
                        var m = pad.widget_instances[i];
                        var v = this.getBoundingBox(this.transformRectangle(m.config.dim, m.config.transforms));
                        var rp =  p;//this.rotatePoint(p,m.config.transforms.rotate.angle,{x:m.config.transforms.rotate.cx,y:m.config.transforms.rotate.cy});

                        if( ((rp.x>v.tl.x &&rp.x<v.br.x) || (rp.x<v.tl.x && rp.x>v.br.x))   && ((rp.y<v.bl.y && rp.y>v.tr.y) || (rp.y>v.bl.y && rp.y<v.tr.y))  ){
                             //this.printRectangle(this.transformRectangle(m.config.dim, m.config.transforms));
                             //this.printRectangle(v);
                             return m;
                        }
                    }return null;
                },
                hasActiveInstance:function(classId){
                    var arr = this.getCurrentContext().active_pad.widget_instances;
                    for(var i=0;i<arr.length;i++){
                        if(arr[i].widget.getClassId() == classId || arr[i].widget.getAppId() == classId)return true;
                    }return false;
                },
                notifyAppletInstancesTranslated:function(pad,applet,applet_instance,delta,complete){
                  setTimeout(function(){
                      applet.onTranslate(pad,applet_instance,delta,complete);
                  },1);
                },
                notifyAppletInstancesScaled:function(pad,applet,applet_instance,delta,complete){
                  setTimeout(function(){
                      applet.onScale(pad,applet_instance,delta,complete);
                  },1);
                },
                notifyAppletInstancesRotated:function(pad,applet,applet_instance,delta,complete){
                  setTimeout(function(){
                      applet.onRotate(pad,applet_instance,delta,complete);
                  },1);
                },
                notifyAppletsMouseEnterScreen:function(pad,p,event){
    
                    for(var i=0;i<this.widgets.length;i++){
                        if(typeof this.widgets[i].onScreenMouseEnter != "undefined" && this.hasActiveInstance(this.widgets[i].getClassId())){
                          App_CallBack_Interface.async_onScreenMouseEnter(this.widgets[i],pad,p,event);
                      }
                    }
                },
                notifyAppletsMouseOutScreen:function(pad,p,event){
  
                    for(var i=0;i<this.widgets.length;i++){
                        if(typeof this.widgets[i].onScreenMouseOut != "undefined" && this.hasActiveInstance(this.widgets[i].getClassId())){
                          App_CallBack_Interface.async_onScreenMouseOut(this.widgets[i],pad,p,event);
                      }
                    }
                },
                notifyAppletsMouseDownScreen:function(pad,p,event){

                    for(var i=0;i<this.widgets.length;i++){
                        if(typeof this.widgets[i].onScreenMouseDown != "undefined" && this.hasActiveInstance(this.widgets[i].getClassId())){
                          App_CallBack_Interface.async_onScreenMouseDown(this.widgets[i],pad,p,event);
                      }
                    }
                },
                notifyAppletsMouseMoveScreen:function(pad,p,event){

                    for(var i=0;i<this.widgets.length;i++){
                        if(typeof this.widgets[i].onScreenMouseMove != "undefined" && this.hasActiveInstance(this.widgets[i].getClassId())){
                          App_CallBack_Interface.async_onScreenMouseMove(this.widgets[i],pad,p,event);
                      }
                    }
                },
                notifyAppletsMouseUpScreen:function(pad,p,event){

                    for(var i=0;i<this.widgets.length;i++){
                        if(typeof this.widgets[i].onScreenMouseUp != "undefined" && this.hasActiveInstance(this.widgets[i].getClassId())){
                          App_CallBack_Interface.async_onScreenMouseUp(this.widgets[i],pad,p,event);
                      }
                    }
                },
                findAndRemoveWidget:function(p,pad){
                    for(var i=0;i<pad.widget_instances.length;i++){
                        var m = pad.widget_instances[i];
                        if(p.config.dbid==m.config.dbid){
                            pad.widget_instances.splice(i,1);
                            if(typeof m.widget.onDeleteInstance != "undefined")
                              m.widget.onDeleteInstance(pad,m);

                            this.removeElement(pad, p.config.dbid);
                            break;
                        }
                    }                    
                }/*,
                deleteWidget:function(widget_instance_id,pad){
                    for(var i=0;i<pad.widget_instances.length;i++){
                        var m = pad.widget_instances[i];
                        if(widget_instance_id==m.config.widget_instance_id){
                            pad.widget_instances.splice(i,1);
                            /***
                            pad.svg_doc.remove(m.svg_node);
                            ***
                            ColabopadApplication.debugRemove(pad,m.svg_node,'deleteWidget');

                            if(m.widget.onDeleteInstance != undefined)
                                 m.widget.onDeleteInstance(m.config);
                            
                            return;
                        }
                    }
                }*/,
                removeUndoNode:function(id){
                  for(var i =0;i<this.undo_stack.length;i++){
                      if(this.undo_stack[i].element.config.element_id == id && this.undo_stack[i].type == "insert"){
                          //debug('removing undo node')
                          return this.undo_stack.splice(i,1)[0];
                      }
                  }return null;
                },
                addToUndoStack:function(node){
                    
                    this.undo_stack.push(node);
                    this.toolbar.undo_button.removeAttr("disabled");
                    this.toolbar.undo_button.removeClass("ui-state-disabled");

                    this.toolbar.redo_button.attr("disabled","disabled");
                    this.toolbar.redo_button.addClass("ui-state-disabled");
                },
                updateUndoNodes:function(element){
                  for(var i =0;i<this.undo_stack.length;i++){
                      if(this.undo_stack[i].element.config.element_id == element.config.element_id){
                          //debug('removing undo node')
                          this.undo_stack[i].element = element;                          
                      }
                  }
                },
                undo:function(){
                    
                  var undoNode = this.undo_stack.pop();

                  if(undoNode.type == "insert")
                  {
                      if(undoNode.element.config.type == "widget")
                         ColabopadApplication.deleteWidgetInstance(ColabopadApplication.getCurrentContext().active_pad,undoNode.m);
                      else
                         this.pen.erase(this.getCurrentContext().active_pad,undoNode.element.dom);
                  }
                  else
                  if(undoNode.type == "delete"){
                    undoNode.element = this.insertContentElement(this.getCurrentContext().active_pad,{config:undoNode.element.config,dom:null},true,false);
                    //if there is another undo action for this element, update
                    this.updateUndoNodes(undoNode.element);
                  }
                  else
                  if(undoNode.type == "transform"){
                    var savetransform = this.Utility.cloneTransformationObject(undoNode.element.config.transforms);
                    undoNode.element.config.transforms = this.Utility.cloneTransformationObject(undoNode.transforms);
                    this.applyTransform(this.getCurrentContext().active_pad,undoNode.element,true);
                    undoNode.transforms = savetransform;
                  }
                  else
                  if(undoNode.type == "fill")
                  {                    
                    var savefill = undoNode.element.config.pen.fill;
                    undoNode.element.config.pen.fill = undoNode.color;
                    ColabopadApplication.fillShape(ColabopadApplication.getCurrentContext().active_pad,undoNode.element,true);
                    undoNode.color = savefill;
                  }

                  this.redo_stack.push(undoNode);

                  this.toolbar.redo_button.removeClass("ui-state-disabled");
                  this.toolbar.redo_button.removeAttr("disabled");
                  
                  if(this.undo_stack.length==0){
                    this.toolbar.undo_button.addClass("ui-state-disabled");
                    this.toolbar.undo_button.attr("disabled","disabled")
                  }
                },
                resetRedoStack:function(){
                    this.toolbar.redo_button.addClass("ui-state-disabled");
                    this.toolbar.redo_button.attr("disabled","disabled");
                    this.redo_stack = [];
                },
                redo:function(){
                   
                   var redoNode = this.redo_stack.pop();

                   if(redoNode.type == "insert")
                    redoNode.element = this.insertContentElement(this.getCurrentContext().active_pad,{config:redoNode.element.config,access:redoNode.element.access,dom:null},true,false);
                   else
                   if(redoNode.type == "delete")
                    this.pen.erase(this.getCurrentContext().active_pad,redoNode.element.dom);
                   else
                   if(redoNode.type == "transform"){
                      var savetransform = this.Utility.cloneTransformationObject(redoNode.element.config.transforms);
                      redoNode.element.config.transforms = this.Utility.cloneTransformationObject(redoNode.transforms);
                      this.applyTransform(this.getCurrentContext().active_pad,redoNode.element,true);
                      redoNode.transforms = savetransform;
                   }
                   else
                   if(redoNode.type == "fill")
                   {
                      var savefill = redoNode.element.config.pen.fill;
                      redoNode.element.config.pen.fill = redoNode.color;
                      ColabopadApplication.fillShape(ColabopadApplication.getCurrentContext().active_pad,redoNode.element,true);
                      redoNode.color = savefill;
                   }

                   this.undo_stack.push(redoNode);

                   if(this.redo_stack.length==0){
                       this.toolbar.redo_button.addClass("ui-state-disabled");
                       this.toolbar.redo_button.attr("disabled","disabled");
                   }
                  this.toolbar.undo_button.removeClass("ui-state-disabled");
                  this.toolbar.undo_button.removeAttr("disabled");
                },
               setPenMode:function(mode){
                   if(this.pen.mode=='text')
                       this.addText(ColabopadApplication.getCurrentContext().active_pad);
                   
                   this.pen.mode=mode;
                   
                   for(i=0;i<ColabopadApplication.getCurrentContext().pages.length;i++){
                       for(j=0;j<ColabopadApplication.pen.modes.length;j++){
                           $(ColabopadApplication.getCurrentContext().pages[i].div_dom).removeClass('np-cursor-'+ColabopadApplication.pen.modes[j]);
                       }
                   }
                   for(i=0;i<ColabopadApplication.getCurrentContext().pages.length;i++){
                       $(ColabopadApplication.getCurrentContext().pages[i].div_dom).addClass('np-cursor-'+mode);
                   }
                   ColabopadApplication.pen.cursor = 'np-cursor-'+mode;
                   this.showAnnotationLayer();
               },
               showAppAnnotationLayerForAllApps:function(display){
                   var pad = ColabopadApplication.getCurrentContext().active_pad;
                   for(var i=0;i<pad.widget_instances.length;i++){
                        var element = pad.widget_instances[i];
                        if(element.dom.firstChild != null && typeof element.dom.firstChild != "undefined" && element.dom.firstChild.nodeName.toLowerCase() == "foreignobject" && element.dom.firstChild.getAttribute("class") == "html-view"){
                            this.showAppAnnotationLayer(element,display);
                        }
                   }
                },
               showAppAnnotationLayer:function(element,display){
                    var pad = ColabopadApplication.getCurrentContext().active_pad;
                    
                    if(display == "show"){
                        //computed dimension
                        var x = element.config.dim.x+element.config.transforms.trslt.x;
                        var y = element.config.dim.y+element.config.transforms.trslt.y;

                        var width  = Math.abs(element.config.transforms.scale.x*element.config.dim.w);
                        var height = Math.abs(element.config.transforms.scale.y*element.config.dim.h);

                        pad.svg_doc.change(element.dom.mouseBlocker,{
                            "x":x,"y":y,"width":width,"height":height,"display":"block"                 
                        });
                        element.dom.mouseBlocker.style.display = "block"
                    }
                    else
                    if(display == "resize" && element.dom.mouseBlocker.style.display == "block"){
                        var widthx  = Math.abs(element.config.transforms.scale.x*element.config.dim.w);
                        var heightx = Math.abs(element.config.transforms.scale.y*element.config.dim.h);

                        pad.svg_doc.change(element.dom.mouseBlocker,{
                            "width":widthx,"height":heightx
                        });                        
                    }
                    else
                    if(display == "translate" && element.dom.mouseBlocker.style.display == "block"){
                        var xx = element.config.dim.x+element.config.transforms.trslt.x;
                        var yx = element.config.dim.y+element.config.transforms.trslt.y;

                        pad.svg_doc.change(element.dom.mouseBlocker,{
                            "x":xx,"y":yx
                        });                        
                    }                    
                    else
                    if(display == "hide")
                    {
                        pad.svg_doc.change(element.dom.mouseBlocker,{
                            "x":0,"y":0,"width":0,"height":0,"display":"none"                        
                        });                        
                        element.dom.mouseBlocker.style.display = "none"
                    }
               },
               showAnnotationLayer:function(force){
                   //log("showing annotation layer:"+force)
                   var page = ColabopadApplication.getCurrentContext().active_pad;
                   
                   if(typeof force != "undefined"){
                       if(force == "show"){
                           page.annotation_layer.style.display = "block";
                       }else{
                           page.annotation_layer.style.display = "none";
                       }return;
                   }
                   
                   
                   if(this.pen.mode=='pointer' || 
                      this.pen.mode == 'move' ||
                      this.pen.mode=='fill' || 
                      this.pen.mode=='eraser' || 
                      this.pen.mode=='resize' || 
                      this.pen.mode=='rotate'){
                       page.annotation_layer.style.display = "none";
                       //page.svg_doc.change(page.annotation_layer,{"display":"none"}); 
                       //page.annotation_layer.setAttribute("display","none");
                       
                       //log("hiding main annotation layer");
                       
                       if(this.pen.mode == 'move' ||this.pen.mode=='resize' || this.pen.mode=='rotate'){
                            this.showAppAnnotationLayerForAllApps("show");
                       }else{
                           this.showAppAnnotationLayerForAllApps("hide");
                       }
                   }
                   else
                   if(this.pen.mode=='text' ||                       
                      this.pen.mode=='freehand' ||
                      this.pen.mode=='image' ||
                      this.pen.mode=='rect' || 
                      this.pen.mode=='circle' || 
                      this.pen.mode=='line' || this.pen.mode=='text'){
                       page.annotation_layer.style.display = "block";
                       //log("showing main annotation layer")
                       this.showAppAnnotationLayerForAllApps("hide");
                   }
               },
               setPenWidth:function(w){
                   this.pen.stroke_width=parseInt(w);
               },
               setPenColor:function(){
                   ColabopadApplication.pen.color = $(this).attr("value");
               },
               alignCoordinates:function(d,pad){
                    var offset=pad.div_dom.offset();
                    return {x:d.pageX-offset.left,y:d.pageY-offset.top};
               },
               svgToScreenCoord:function(p,pad){
                    var offset=pad.div_dom.offset();
                    return {x:p.x+offset.left,y:p.y+offset.top};
               },
               dimToClientCoord:function(d,pad){
                   var offset = pad.div_dom.offset();
                   return {x:d.x+offset.left,y:d.y+offset.top,w:d.w,h:d.h};
               },
               normalizeRect:function(x,y,w,h){
                  return {x:(w<0?x+w:x),y:(h<0?y+h:y),w:Math.abs(w),h:Math.abs(h)};
               },
               topolyline:function(data){
                    return eval('('+data+')');
               },
               applyTransformEx:function(pad,element,transformation_stack,update){
                   
                   /*THIS IS PRIMARILY A WORKAROUND FOR CHROME*
                   if( (typeof element.config.header == "undefined") ||  (element.config.header.movable && ((typeof element.config.header.scalable == "undefined" || !element.config.header.scalable) && (typeof element.config.header.rotatable == "undefined" || !element.config.header.rotatable)))){
                       pad.svg_doc.change(element.dom.firstChild,{
                           x:element.config.dim.x+element.config.transforms.trslt.x,
                           y:element.config.dim.y+element.config.transforms.trslt.y
                       });
                   }else{
                       pad.svg_doc.change(element.dom,{transform:transformation_stack});
                   }
                   //pad.svg_doc.change(element,{transform:'rotate('+config.transforms.rotate.angle+','+config.transforms.rotate.cx+','+config.transforms.rotate.cy+') '+'translate('+config.transforms.trslt.x+','+config.transforms.trslt.y+') scale('+config.transforms.scale.x+','+config.transforms.scale.y+')'});
                   //pad.svg_doc.change(element,{transform:'scale('+config.transforms.scale.x+','+config.transforms.scale.y+') rotate('+config.transforms.rotate.angle+','+config.transforms.rotate.cx+','+config.transforms.rotate.cy+') translate('+config.transforms.trslt.x+','+config.transforms.trslt.y+')'});

                   if(embeded)return;
                   if(update){
                        //propagate to queue
                        if(pad.queue_url){
                            ColabopadApplication.MsgHandler.sendMessage({to:pad.queue_url,message:{header:{type:"transform",src_session:sessionId,pid:pad.context.pid,cntx_id:pad.context.id,page_id:pad.id,id:element.config.dbid},transforms:element.config.transforms}});
                        }
                        this.updateElement(pad,element.config);
                   }*/
                   this.applyTransform(pad,element,update);
               },
               applyTransform:function(pad,element,update){

                   if(typeof(element.config.transforms) != "undefined"){
                        /*THIS IS PRIMARILY A WORKAROUND FOR CHROME*/
                        if(element.dom.firstChild != null && typeof element.dom.firstChild != "undefined" && element.dom.firstChild.nodeName.toLowerCase() == "foreignobject" && element.dom.firstChild.getAttribute("class") == "html-view"){
                           pad.svg_doc.change(element.dom.firstChild,{
                                "x":element.config.dim.x+element.config.transforms.trslt.x,
                                "y":element.config.dim.y+element.config.transforms.trslt.y
                           });
                           this.showAppAnnotationLayer(element,"translate");
                           
                           //resize
                           var width  = Math.abs(element.config.transforms.scale.x*element.config.dim.w);
                           var height = Math.abs(element.config.transforms.scale.y*element.config.dim.h);
                           pad.svg_doc.change(element.dom.firstChild,{
                                "width":width,
                                "height":height
                           });                           
                           this.showAppAnnotationLayer(element,"resize");
                            
                            
                           //log("width:"+width+" height:"+height+"  scale("+element.config.transforms.scale.x+","+element.config.transforms.scale.y+")");
                           
                           var iframe = element.dom.firstChild.firstChild;
                           while(iframe != null){
                               if(iframe.nodeName.toLowerCase() == "iframe"){
                                   iframe.setAttribute("width",width);
                                   iframe.setAttribute("height",height);
                                   //iframe.contentDocument.location.reload(true);
                                   //log("setting iframe size");
                                   break;
                               }
                               //log("nodeName:"+iframe.nodeName);
                               iframe = iframe.nextSibling;
                           }
                           
                           pad.svg_doc.change(element.dom,{transform:' rotate('+element.config.transforms.rotate.angle+','+element.config.transforms.rotate.cx+','+element.config.transforms.rotate.cy+')'}); 
                           
                           //pad.svg_doc.change(element.dom,{transform:' rotate('+element.config.transforms.rotate.angle+','+element.config.transforms.rotate.cx+','+element.config.transforms.rotate.cy+') scale('+element.config.transforms.scale.x+','+element.config.transforms.scale.y+')'}); 
                        }
                        
                        /*if( (typeof element.config.header == "undefined") ||  (element.config.header.movable && ((typeof element.config.header.scalable == "undefined" || !element.config.header.scalable) && (typeof element.config.header.rotatable == "undefined" || !element.config.header.rotatable)))){
                            pad.svg_doc.change(element.dom.firstChild,{
                                x:element.config.dim.x+element.config.transforms.trslt.x,
                                y:element.config.dim.y+element.config.transforms.trslt.y
                            });
                        }*/else{
                            pad.svg_doc.change(element.dom,{transform:' rotate('+element.config.transforms.rotate.angle+','+element.config.transforms.rotate.cx+','+element.config.transforms.rotate.cy+') '+'translate('+element.config.transforms.trslt.x+','+element.config.transforms.trslt.y+') scale('+element.config.transforms.scale.x+','+element.config.transforms.scale.y+')'});
                        }
                   }
                   //pad.svg_doc.change(element,{transform:'scale('+config.transforms.scale.x+','+config.transforms.scale.y+') rotate('+config.transforms.rotate.angle+','+config.transforms.rotate.cx+','+config.transforms.rotate.cy+') translate('+config.transforms.trslt.x+','+config.transforms.trslt.y+')'});

                   if(embeded)return;
                   if(update){
                        //propagate to queue
                        if(pad.queue_url && typeof(element.config.transforms) != "undefined"){
                            //log("messaging")
                            ColabopadApplication.MsgHandler.sendMessage({to:pad.queue_url,message:{header:{type:"transform",src_session:sessionId,pid:pad.context.pid,cntx_id:pad.context.id,page_id:pad.id,id:element.config.dbid},transforms:element.config.transforms}});
                        }else{
                            //log("messaging failed:"+pad.queue_url)
                        }
                        this.updateElement(pad,element);
                   }
               },
               mousedownImpl:function(event,pad){
                  this.pen.down = true;
                  if(this.pen.mode=='text'){
                      this.addText(pad);
                  }

                  var p = this.alignCoordinates(event,pad);
                  if(this.pen.mode != 'eraser' && this.pen.mode != 'move' && this.pen.mode != 'rotate' && this.pen.mode != 'pointer' && this.pen.mode != 'fill'){

                      this.pen.start_x = p.x;
                      this.pen.start_y = p.y;
                      
                      this.pen.moved = false;

                      this.pen.color = $('#pencolorPicker').attr("value");

                      var gid = 'grp'+(new Date()).getTime();
                      this.pen.cur_element_parent_node = pad.svg_doc.group(pad./*svg_root,*/content_root_svg,gid,
                      {fill: 'none',stroke:this.pen.color, 'stroke-width': this.pen.stroke_width});

                      this.pen.cur_element_id = gid;
                      this.pen.cur_shape_node = null;

                      if(this.pen.mode=='freehand'){
                        this.pen.accumulated_points = '[['+p.x+','+p.y+']';
                        this.pen.cur_shape_node = pad.svg_doc.polyline(this.pen.cur_element_parent_node,this.topolyline(this.pen.accumulated_points+']'));
                      }
                      else
                      if(this.pen.mode=='text'){
                        this.debugRemove(pad,this.pen.cur_element_parent_node,'mousedownImpl');

                        this.pen.down = false;
                        var pos         = pad.div_dom.offset();
                        var sct         = ColabopadApplication.ui_components.layout.center.scrollTop();
                        var left_scroll = ColabopadApplication.ui_components.layout.center.scrollLeft();
                        //var offset=pad.div_dom.offset();
                        //var pp = {x:d.pageX-offset.left,y:d.pageY-offset.top};

                        //$('#textinputer').css({"display":"block","position":"absolute","left":p.x+20,"top":( p.y+pos.top-10+sct)});
                        this.pen.textinputer.css({"display":"block","position":"absolute","left":p.x+pos.left/*-10+left_scroll*/,"top":( p.y+pos.top/*-10+sct*/)});
                        this.pen.textinputer.focus();
                      }
                      else
                      if(this.pen.mode=='image'){
                        this.debugRemove(pad,this.pen.cur_element_parent_node,'mousedownImpl');
                        $('#image-dialog').dialog("open");
                      }
                      else
                      if(this.pen.mode == 'richtext'){
                        this.debugRemove(pad,this.pen.cur_element_parent_node,'mousedownImpl');
                        pad.svg_doc.rect(null,this.pen.start_x, this.pen.start_y,this.CHARACTER.width,this.CHARACTER.height,{"pointer-events":"visible","fill":'none',stroke:"black","stroke-miterlimit":4,"stroke-linejoin":"round","stroke-dasharray":"8, 8"});
                      }
                  }
                  else
                  if(this.pen.mode == 'pointer'||this.pen.mode == 'move'){
                      
                    //notify all applets of mousedown event
                    this.notifyAppletsMouseDownScreen(pad, p, event);
                  }
                  /*else
                  if(this.pen.mode == 'rotate'){
                      if(this.pen.rotateElement != null){
                            var m = this.pen.rotateElement;
                            var trslt = m.config.transforms.trslt;
                            var cx = Math.abs(trslt.x+(m.config.dim.x + (m.config.dim.w*m.config.transforms.scale.x)/2));
                            var cy = Math.abs(trslt.y+(m.config.dim.y + (m.config.dim.h*m.config.transforms.scale.y)/2));
                            m.config.transforms.rotate.cx = cx;
                            m.config.transforms.rotate.cy = cy;
                            //debug('center('+cx+','+cy+')')
                      }
                  }*/
               },
               mousemoveImpl:function(event,pad){
               
                 var p   = this.alignCoordinates(event,pad);
                 var mtrad = 32;
                 if(this.pen.mode != 'eraser' && this.pen.mode != 'move' && this.pen.mode != 'rotate' && this.pen.mode != 'pointer' && this.pen.mode != 'fill' && this.pen.mode != 'resize'){

                     if(this.pen.down){
                         if(this.pen.cur_shape_node != null){
                               this.debugRemove(pad,this.pen.cur_shape_node,'mousemoveImpl');
                               this.pen.cur_shape_node = null;
                         }

                         this.pen.moved = true;
                         if(this.pen.mode=='freehand'){
                             this.pen.accumulated_points += ',['+p.x+','+p.y+']';
                             this.pen.cur_shape_node = pad.svg_doc.polyline(this.pen.cur_element_parent_node,this.topolyline(this.pen.accumulated_points+']'));
                             this.pen.start_x = p.x;
                             this.pen.start_y = p.y;
                             this.pen.moved = true;
                         }
                         else
                         if(this.pen.mode=='line'){

                            var lnlen   =  Math.floor(Math.sqrt(Math.pow(p.x-this.pen.start_x, 2)+Math.pow(p.y-this.pen.start_y, 2)));
                            var lnslope =  -Math.round( ((p.y-this.pen.start_y)/(p.x-this.pen.start_x))*100 )/100;
                            var lnstart =  {x:Math.floor(this.pen.start_x),y:Math.floor(this.pen.start_y)};

                            this.pen.shape_metric.html("[O:("+lnstart.x+","+lnstart.y+") L:"+lnlen+" S:"+lnslope+"]");
                            $(this.pen.shape_metric).css({"display":"inline","left":(p.x+mtrad)+"px","top":p.y+"px"});

                            this.pen.cur_shape_node =  pad.svg_doc.line(this.pen.cur_element_parent_node,this.pen.start_x, this.pen.start_y, p.x, p.y);
                            this.pen.moved = true;
                            this.pen.end_x = p.x;
                            this.pen.end_y = p.y;
                         }
                         else
                         if(this.pen.mode=='circle'){
                             var ops = Math.abs(p.y-this.pen.start_y);
                             var adj = Math.abs(p.x-this.pen.start_x);
                             var rad = Math.sqrt(Math.pow(ops,2)+Math.pow(adj,2));

                             this.pen.shape_metric.html("[C:("+Math.floor(this.pen.start_x)+","+Math.floor(this.pen.start_y)+") R:("+Math.floor(rad)+") r:("+adj+","+ops+"))]");
                             $(this.pen.shape_metric).css({"display":"inline","left":(p.x+mtrad)+"px","top":p.y+"px"});

                             /*
                             this.pen.cur_shape_node = pad.svg_doc.circle(this.pen.cur_element_parent_node,this.pen.start_x, this.pen.start_y,rad,{"pointer-events":"visible",fill:"none"});
                             */
                             this.pen.cur_shape_node = pad.svg_doc.ellipse(this.pen.cur_element_parent_node,this.pen.start_x, this.pen.start_y,adj,ops,{"pointer-events":"visible",fill:"none"});

                             this.pen.moved = true;
                             this.pen.rad   = rad;
                             this.pen.adj   = adj;
                             this.pen.ops   = ops;
                         }
                         else
                         if(this.pen.mode=='rect'){

                             var normRect = this.normalizeRect(this.pen.start_x, this.pen.start_y,p.x-this.pen.start_x,p.y-this.pen.start_y);
                             this.pen.shape_metric.html("(W:"+normRect.w+", H:"+normRect.h+")");
                             $(this.pen.shape_metric).css({"display":"inline","left":(p.x+mtrad)+"px","top":p.y+"px"});

                             this.pen.cur_shape_node = pad.svg_doc.rect(this.pen.cur_element_parent_node,normRect.x,normRect.y,normRect.w,normRect.h,{"pointer-events":"visible",fill:"none"});

                             this.pen.moved = true;
                             this.pen.end_x = p.x;
                             this.pen.end_y = p.y;
                          }
                       }
                  }
                  else
                  if( (this.pen.mode=='move' || this.pen.mode == 'pointer')  && this.pen.down){
                      
                     this.pen.moved = true;
                     if(this.pen.activeElement != null){

                         var m = this.pen.activeElement;
                         this.hideWidgetControlPanel();
                         //dynmically check
                         if(m.config.type == "widget" && typeof m.element.widget.isMovable != "undefined" && !m.element.widget.isMovable(m)){
                                this.pen.moved = false;

                                //notify all applets of mouse move event
                                if(this.pen.mode == 'pointer' || this.pen.mode == 'move')
                                    this.notifyAppletsMouseMoveScreen(pad, p, event);
                                return;
                         }
                         else
                         if(typeof m.config.header != "undefined")
                         {
                            if(typeof m.config.header.movable != "undefined" && !m.config.header.movable)
                            {
                                this.pen.moved = false;
                                
                                //notify all applets of mouse move event
                                if(this.pen.mode == 'pointer' || this.pen.mode == 'move')
                                    this.notifyAppletsMouseMoveScreen(pad, p, event);
                                return;
                            }
                         }
                         
                         if(m.mousedrop_pt == null){                             
                             m.mousedrop_pt = p;
                             m.accum_trslt  = {x:0,y:0};
                             m.undoNode =  {element:m.element,
                                            type:"transform",
                                            transforms:ColabopadApplication.Utility.cloneTransformationObject(m.config.transforms)
                                           };     
                             //log("mouse down not set");
                         }
                         
                         var trslt_delta = {x:(p.x-m.mousedrop_pt.x),y:(p.y-m.mousedrop_pt.y)};
                         var trslt = {x:m.config.transforms.trslt.x+trslt_delta.x,y:m.config.transforms.trslt.y+trslt_delta.y};

                         m.accum_trslt.x += trslt_delta.x;
                         m.accum_trslt.y += trslt_delta.y;
                         //log("translate delta("+m.accum_trslt.x+","+m.accum_trslt.y+")");

                         //determine objects center of rotation
                         var cx = Math.abs(trslt.x+(m.config.dim.x + (m.config.dim.w*m.config.transforms.scale.x)/2));
                         var cy = Math.abs(trslt.y+(m.config.dim.y + (m.config.dim.h*m.config.transforms.scale.y)/2));

                         
                         m.mousedrop_pt = p;
                         m.config.transforms.trslt = trslt;
                         m.config.transforms.rotate.cx = cx;
                         m.config.transforms.rotate.cy = cy;


                         var transformation_stack = 'rotate('+m.config.transforms.rotate.angle+','+m.config.transforms.rotate.cx+','+m.config.transforms.rotate.cy+') translate('+m.config.transforms.trslt.x+','+m.config.transforms.trslt.y+') scale('+m.config.transforms.scale.x+','+m.config.transforms.scale.y+')';
                         ColabopadApplication.applyTransformEx(pad,m.element,transformation_stack,false);

                         //widget callback
                         if(m.config.type == "widget" && typeof m.element.widget.onTranslate != "undefined"){
                             App_CallBack_Interface.async_onTranslate(pad, m.element.widget,m.applet_instance, trslt_delta,false);
                             //m.element.widget.onTranslate(m.element,trslt_delta);
                         }

                         //this.applyTransform(pad,this.pen.activeElement, this.pen.activeElement.config,false);
                         $(this.pen.shape_metric).html('('+Math.floor(p.x)+','+Math.floor(p.y)+'), moved:('+m.accum_trslt.x+','+m.accum_trslt.y+')').css({"display":"inline","left":(p.x+mtrad)+"px","top":p.y+"px"});
                     }
                     else
                     if(this.pen.mode == 'pointer' || this.pen.mode == 'move')
                     {
                            //notify all applets of mouse move event
                            this.notifyAppletsMouseMoveScreen(pad, p, event);
                     }
                  }
                  else
                  if(this.pen.mode=='rotate' && this.pen.down){
                    this.pen.moved = true;

                     if(this.pen.rotateElement != null){
                         m = this.pen.rotateElement;

                         //dynmically check
                         if(m.config.type == "widget" && typeof m.element.widget.isRotatable != "undefined" && m.element.widget.isRotatable(m)){
                                this.pen.moved = false;
                                return;
                         }else
                         if(typeof m.config.header != "undefined")
                         {
                            if(typeof m.config.header.rotatable != "undefined" && !m.config.header.rotatable){
                                this.pen.moved = false;
                                return;
                            }
                         }

                         trslt = this.pen.rotateElement.config.transforms.trslt;

                         //determine objects center of rotation
                         cx = m.config.transforms.rotate.cx;//Math.abs(trslt.x+(m.config.dim.x + (m.config.dim.w*m.config.transforms.scale.x)/2));
                         cy = m.config.transforms.rotate.cy;//Math.abs(trslt.y+(m.config.dim.y + (m.config.dim.h*m.config.transforms.scale.y)/2));
                         //m.config.transforms.rotate.cx = cx;
                         //m.config.transforms.rotate.cy = cy;

                         var r2d = (180/Math.PI);
                         var curAngle   = Math.atan2(p.y-cy,p.x-cx)*r2d;
                         var lastAngle  = Math.atan2(m.mousedrop_pt.y-cy,m.mousedrop_pt.x-cx)*r2d;
                         var delta      = (curAngle - lastAngle);


                         m.accum_rotate.angle += delta;

                         /*
                         //form an Oblique triangle and use the angle formed with the center (cx,cy) as our delta
                         var a = Math.sqrt(Math.pow(this.pen.rotateElement.mousedrop_pt.x-cx,2) + Math.pow(this.pen.rotateElement.mousedrop_pt.y-cy,2));
                         var b = Math.sqrt(Math.pow(p.x-cx,2) + Math.pow(p.y-cy,2));
                         var c = Math.sqrt(Math.pow(p.x-this.pen.rotateElement.mousedrop_pt.x,2) + Math.pow(p.y-this.pen.rotateElement.mousedrop_pt.y,2));
                         
                         var delta = (Math.acos((Math.pow(a, 2)+Math.pow(b, 2)-Math.pow(c, 2))/(2*a*b))*(180/Math.PI));
                         */
                         //this.pen.rotateElement.config.transforms.rotate.cx = cx;
                         //this.pen.rotateElement.config.transforms.rotate.cy = cy;
                         m.config.transforms.rotate.angle += delta;

                         
                         //debug(beta+' cx:'+cx+' cy:'+cy)
                         transformation_stack = 'rotate('+m.config.transforms.rotate.angle+','+m.config.transforms.rotate.cx+','+m.config.transforms.rotate.cy+') translate('+m.config.transforms.trslt.x+','+m.config.transforms.trslt.y+') scale('+m.config.transforms.scale.x+','+m.config.transforms.scale.y+')';
                         ColabopadApplication.applyTransformEx(pad,m.element,transformation_stack,false);

                         if(m.config.type == "widget" && typeof m.element.widget.onRotate != "undefined"){
                             App_CallBack_Interface.async_onRotate(pad, m.element.widget,m.applet_instance, delta,false);
                             //m.element.widget.onRotate(m.element,delta);
                         }
                         //this.applyTransform(pad,this.pen.rotateElement, this.pen.rotateElement.config,false);
                         
                         m.mousedrop_pt = p;
                         $(this.pen.shape_metric).html('('+Math.floor(p.x)+','+Math.floor(p.y)+'), rotated:('+Math.round(this.pen.activeElement.accum_rotate.angle)+' deg)').css({"display":"inline","left":(p.x+mtrad)+"px","top":p.y+"px"});
                     }
                  }
                  else
                  if(this.pen.mode=='resize' && this.pen.down){

                       this.pen.moved = true;
                       m = this.pen.activeElement;
                       if(m != null){

                            //dynmically check
                            if(m.config.type == "widget" && typeof m.element.widget.isScalable != "undefined" && m.element.widget.isScalable(m)){
                                 this.pen.moved = false;
                                 return;
                            }else
                            if(typeof m.config.header != "undefined")
                            {
                              if(typeof m.config.header.scalable != "undefined" && !m.config.header.scalable){
                                 this.pen.moved = false;
                                 return;
                              }
                            }
                            var pt = p;
                            
                            var scaleX    = (pt.x-m.mousedrop_pt.x)/m.config.dim.w;
                            m.config.transforms.scale.x += scaleX;

                            var scaleY    = (pt.y-m.mousedrop_pt.y)/m.config.dim.h;
                            m.config.transforms.scale.y += scaleY;


                            trslt = m.config.transforms.trslt;

                            //determine objects center of rotation
                            //cx = Math.abs(trslt.x+(m.config.dim.x + (m.config.dim.w*m.config.transforms.scale.x)/2));
                            //cy = Math.abs(trslt.y+(m.config.dim.y + (m.config.dim.h*m.config.transforms.scale.y)/2));
                            //m.config.transforms.rotate.cx = cx;
                            //m.config.transforms.rotate.cy = cy;
                            //debug('scale:('+m.config.transforms.scale.x+','+m.config.transforms.scale.y+') c('+cx+','+cy+')')

                            //if(m.config.transforms.rotate.angle == 0)
                            transformation_stack = 'rotate('+m.config.transforms.rotate.angle+','+m.config.transforms.rotate.cx+','+m.config.transforms.rotate.cy+') translate('+m.config.transforms.trslt.x+','+m.config.transforms.trslt.y+') scale('+m.config.transforms.scale.x+','+m.config.transforms.scale.y+')';
                            //else
                            //    transformation_stack = 'rotate('+m.config.transforms.rotate.angle+','+m.config.transforms.rotate.cx+','+m.config.transforms.rotate.cy+') translate('+m.config.transforms.trslt.x+','+m.config.transforms.trslt.y+') scale('+m.config.transforms.scale.x+','+m.config.transforms.scale.y+')';
                            ColabopadApplication.applyTransformEx(pad,m.element,transformation_stack,false);
                            if(m.config.type == "widget" && typeof m.element.widget.onScale != "undefined"){
                                App_CallBack_Interface.async_onScale(pad, m.element.widget,m.applet_instance, {x:scaleX,y:scaleY},false);
                                //m.element.widget.onScale(m.element,{x:scaleX,y:scaleY});
                            }
                            //ColabopadApplication.applyTransform(ColabopadApplication.getCurrentContext().active_pad,m.element.dom,m.config,false);
                            m.mousedrop_pt = pt;
                       }
                  }
                  else
                  if(this.pen.mode!='freehand'/*this.pen.mode=='pointer' || this.pen.mode=='rotate' || this.pen.mode=='move'*/ )
                  {
                      if(this.pen.down){//selection
                        this.pen.moved = true;
                        //notify all applets of mouse move event
                        if(this.pen.mode == 'pointer' || this.pen.mode == 'move')
                        this.notifyAppletsMouseMoveScreen(pad, p, event);
                      }else{
                          
                        var enableWidgetTracking = this.pen.activeElement == null || this.pen.activeElement.element.config.type == "widget"
                        $(this.pen.shape_metric).html('('+Math.floor(p.x)+','+Math.floor(p.y)+')').css({"display":"inline","left":(p.x+mtrad)+"px","top":p.y+"px"});
                        if(enableWidgetTracking && this.trackWidgets(p,event,pad) == null && (this.pen.mode == 'pointer' || this.pen.mode == 'move'))
                            this.notifyAppletsMouseMoveScreen(pad, p, event);//notify all applets of mouse move event
                      }
                  }
               },
               addWidgetConfig:function(config,pad,persist_to_db,paint_only){
                   return this.insertContentElement(pad,{config:config,access:[0,0,3,0],dom:null},persist_to_db,paint_only);
               },
               addStrokeConfig:function(config,pad,persist_to_db,paint_only){
                   return this.insertContentElement(pad,{config:config,access:[0,0,3,0],dom:null},persist_to_db,paint_only);
               },
               addStroke:function(p,pad){                    
                    this.pen.accumulated_points += ',['+p.x+','+p.y+']]';
                    var config = {
                        type:'stroke',
                        points:this.topolyline(this.pen.accumulated_points),
                        transforms:{trslt:{x:0,y:0},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}},
                        element_id:this.pen.cur_element_id,
                        pen:{color:this.pen.color,width:this.pen.stroke_width,fill:"none"}
                    };
                    var element = this.addStrokeConfig(config,pad,true);
                    this.addToUndoStack({element:element,type:"insert"});
                    this.resetRedoStack();
                    return element;
               },
               addLineConfig:function(config,pad,persist_to_db,paint_only){
                   return this.insertContentElement(pad,{config:config,access:[0,0,3,0],dom:null},persist_to_db,paint_only);
               },
               addLine:function(p,pad){
                    var config = {
                        type:'line-stroke',
                        points:{start:{x:this.pen.start_x,y:this.pen.start_y},end:{x:this.pen.end_x,y:this.pen.end_y}},
                        dim:{x:this.pen.end_x<this.pen.start_x?this.pen.end_x:this.pen.start_x,y:this.pen.end_y<this.pen.start_y?this.pen.end_y:this.pen.start_y,w:Math.abs(this.pen.end_x-this.pen.start_x),h:Math.abs(this.pen.end_y-this.pen.start_y)},
                        transforms:{trslt:{x:0,y:0},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}},
                        element_id:this.pen.cur_element_id,
                        pen:{color:this.pen.color,width:this.pen.stroke_width,fill:"none"}
                    };
                     var cx = Math.abs((config.dim.x + config.dim.w/2));
                     var cy = Math.abs((config.dim.y + config.dim.h/2));
                     config.transforms.rotate.cx = cx;
                     config.transforms.rotate.cy = cy;
                     var element = this.addLineConfig(config,pad,true);
                     this.addToUndoStack({element:element,type:"insert"});
                     this.resetRedoStack();
                     return element;
               },
               addCircleConfig:function(config,pad,persist_to_db,paint_only){
                   return this.insertContentElement(pad,{config:config,access:[0,0,3,0],dom:null},persist_to_db,paint_only);
               },
               addCircle:function(p,pad){
                    /*var config = {
                          type:'circle-stroke',
                          points:{x:this.pen.start_x,y:this.pen.start_y,rad:this.pen.rad,adj:this.pen.adj,ops:this.pen.ops},
                          dim:{x:this.pen.start_x-this.pen.adj,y:this.pen.start_y-this.pen.ops,cx:this.pen.start_x,cy:this.pen.start_y,rad:this.pen.rad,adj:this.pen.adj,ops:this.pen.ops,w:this.pen.adj*2,h:this.pen.ops*2},
                          transforms:{trslt:{x:0,y:0},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}},
                          element_id:this.pen.cur_element_id,
                          pen:{color:this.pen.color,width:this.pen.stroke_width,fill:"none"}
                     };*/
                      var config = {
                          type:'circle-stroke',
                          points:{x:0,y:0,rad:this.pen.rad,adj:this.pen.adj,ops:this.pen.ops},
                          dim:{x:-this.pen.adj,y:-this.pen.ops,cx:this.pen.start_x,cy:this.pen.start_y,rad:this.pen.rad,adj:this.pen.adj,ops:this.pen.ops,w:this.pen.adj*2,h:this.pen.ops*2},
                          transforms:{trslt:{x:this.pen.start_x,y:this.pen.start_y},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}},
                          element_id:this.pen.cur_element_id,
                          pen:{color:this.pen.color,width:this.pen.stroke_width,fill:"none"}
                     };

                     var cx = Math.abs(config.transforms.trslt.x+config.dim.x+(config.dim.w/2));
                     var cy = Math.abs(config.transforms.trslt.y+config.dim.y+(config.dim.h/2));
                     config.transforms.rotate.cx = cx;
                     config.transforms.rotate.cy = cy;

                     var element = this.addCircleConfig(config,pad,true);
                     this.addToUndoStack({element:element,type:"insert"});
                     this.resetRedoStack();
                     return element;
               },
               addRectConfig:function(config,pad,persist_to_db,paint_only){
                   return this.insertContentElement(pad,{config:config,access:[0,0,3,0],dom:null},persist_to_db,paint_only);
               },
               addRect:function(p,pad){

                     var config ={
                          type:'rec-stroke',
                          points:{x:0,y:0,w:Math.abs(this.pen.end_x-this.pen.start_x),h:Math.abs(this.pen.end_y-this.pen.start_y)},
                          dim:{x:0,y:0,w:Math.abs(this.pen.end_x-this.pen.start_x),h:Math.abs(this.pen.end_y-this.pen.start_y)},
                          transforms:{trslt:{x:(this.pen.end_x-this.pen.start_x)<0?this.pen.start_x+(this.pen.end_x-this.pen.start_x):this.pen.start_x,y:(this.pen.end_y-this.pen.start_y)<0?this.pen.start_y+(this.pen.end_y-this.pen.start_y):this.pen.start_y},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}},
                          element_id:this.pen.cur_element_id,
                          pen:{color:this.pen.color,width:this.pen.stroke_width,fill:"none"}
                     };
                     var cx = Math.abs(config.transforms.trslt.x+(config.dim.x + config.dim.w/2));
                     var cy = Math.abs(config.transforms.trslt.y+(config.dim.y + config.dim.h/2));
                     config.transforms.rotate.cx = cx;
                     config.transforms.rotate.cy = cy;

                     var element = this.addRectConfig(config,pad,true);
                     this.addToUndoStack({element:element,type:"insert"});
                     this.resetRedoStack();
                     return element;  
               },
               addTextConfig:function(config,pad,persist_to_db,paint_only){
                   return this.insertContentElement(pad,{config:config,access:[0,0,3,0],dom:null},persist_to_db,paint_only);
               },
               addText:function(pad){
                   var val = null;
                    if(this.pen.textinputer.css("display")=='block'){
                        var txt = this.pen.textinputer.attr("value");
                        if(txt.length>0){
                            /*
                            var config = {
                                type:'text',
                                text:{data:txt,pos:{x:this.pen.start_x,y:this.pen.start_y}},
                                dim:{x:this.pen.start_x,y:this.pen.start_y,w:txt.length*12,h:12},
                                element_id:this.pen.cur_element_id,
                                pen:{color:this.pen.color,width:this.pen.stroke_width,fill:this.pen.color,extra_settings:{"font-family":"Times New Roman","font-size":"12pt"}},
                                transforms:{trslt:{x:0,y:0},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}}
                            };*/
                            var config = {
                                type:'text',
                                text:{data:txt,pos:{x:0,y:0}},
                                dim:{x:0,y:0,w:txt.length*12,h:12},
                                element_id:this.pen.cur_element_id,
                                pen:{color:this.pen.color,width:this.pen.stroke_width,fill:this.pen.color,extra_settings:{"font-family":"Arial","font-size":"12pt","text-decoration":"blink"}},
                                transforms:{trslt:{x:this.pen.start_x,y:this.pen.start_y},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}}
                            };
                            var cx = Math.abs(config.transforms.trslt.x+(config.dim.x + config.dim.w/2));
                            var cy = Math.abs(config.transforms.trslt.y+(config.dim.y + config.dim.h/2));
                            config.transforms.rotate.cx = cx;
                            config.transforms.rotate.cy = cy;
                            val = this.addTextConfig(config,pad,true);
                        }
                    }
                    this.pen.textinputer.attr("value","");
                    this.pen.textinputer.css({"display":"none"});
                    //this.pen.textinputer.attr("cols","1");
                    if(val){
                      this.addToUndoStack({element:val,type:"insert"});
                      this.resetRedoStack();
                    }
                    return val;
               },
               addImageConfig:function(config,pad,persist_to_db,paint_only){
                   return this.insertContentElement(pad,{config:config,access:[0,0,3,0],dom:null},persist_to_db,paint_only);
               },
               uploadFile:function(pad){
                    if($('#fileUploadInterface').contents().find('[name=uploaded_file]').attr("value") != '')
                    {
                        /*imgUrl = 'img-'+room_id+'-'+pad.context.pid+'-'+pad.context.id+'-'+pad.id+'-'+(parseInt(pad.last_insert)+1);
                        $('#imageUploadInterface').contents().find('[name=file-name]').attr("value",imgUrl);
                        this.queueAddedImage = {pad:pad,config:{
                            type:'image',
                            image:{uploaded:true,url:imgUrl,link:imgSrcPage,pos:{x:this.pen.start_x,y:this.pen.start_y,w:imgWidth,h:imgHeight}},
                            dim:{x:this.pen.start_x,y:this.pen.start_y,w:imgWidth,h:imgHeight,link:imgSrcPage},
                            element_id:this.pen.cur_element_id,
                            pen:{color:this.pen.color,width:this.pen.stroke_width,fill:"none"},
                            transforms:{trslt:{x:0,y:0},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}}
                        }};
                        config = this.queueAddedImage.config;
                        cx = Math.abs((config.dim.x + config.dim.w/2));
                        cy = Math.abs((config.dim.y + config.dim.h/2));
                        config.transforms.rotate.cx = cx;
                        config.transforms.rotate.cy = cy;*/
                       $('#fileUploadInterface').contents().find('[name=room_id]').attr("value",room_id);
                       $('#fileUploadInterface').contents().find('[name=fileposter]').submit();
                    }
               },
               addImage:function(pad){
                    var val = null;
                    var imgUrl     = $('#image-module-image-url').attr("value");
                    var imgSrcPage = $('#image-module-image-link').attr("value");
                    var imgWidth   = $('#image-module-image-width').attr("value")!=''?parseInt($('#image-module-image-width').attr("value")):256;
                    var imgHeight  = $('#image-module-image-height').attr("value")!=''?parseInt($('#image-module-image-height').attr("value")):256;

                    if(imgUrl != ''){
                        /*
                        var config = {
                            type:'image',
                            image:{url:imgUrl,link:imgSrcPage,pos:{x:this.pen.start_x,y:this.pen.start_y,w:imgWidth,h:imgHeight}},
                            dim:{x:this.pen.start_x,y:this.pen.start_y,w:imgWidth,h:imgHeight,link:imgSrcPage},
                            element_id:this.pen.cur_element_id,
                            pen:{color:this.pen.color,width:this.pen.stroke_width,fill:"none"},
                            transforms:{trslt:{x:0,y:0},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}}
                        };
                       */
                        var config = {
                            type:'image',
                            image:{url:imgUrl,link:imgSrcPage,pos:{x:0,y:0,w:imgWidth,h:imgHeight}},
                            dim:{x:0,y:0,w:imgWidth,h:imgHeight,link:imgSrcPage},
                            element_id:this.pen.cur_element_id,
                            pen:{color:this.pen.color,width:this.pen.stroke_width,fill:"none"},
                            transforms:{trslt:{x:this.pen.start_x,y:this.pen.start_y},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}}
                        };
                        var cx = Math.abs(config.transforms.trslt.x+(config.dim.x + config.dim.w/2));
                        var cy = Math.abs(config.transforms.trslt.y+(config.dim.y + config.dim.h/2));
                        config.transforms.rotate.cx = cx;
                        config.transforms.rotate.cy = cy;

                        val = this.addImageConfig(config,pad,true);

                        if(val){
                          this.addToUndoStack({element:val,type:"insert"});
                          this.resetRedoStack();
                        }
                    }
                    else
                    if($('#imageUploadInterface').contents().find('[name=uploaded_image]').attr("value") != '')
                    {
                        imgUrl = 'img-'+room_id+'-'+pad.context.pid+'-'+pad.context.id+'-'+pad.id+'-'+(parseInt(pad.last_insert)+1);
                        $('#imageUploadInterface').contents().find('[name=file-name]').attr("value",imgUrl);
                        $('#imageUploadInterface').contents().find('[name=room_id]').attr("value",room_id);
                        this.queueAddedImage = {pad:pad,config:{
                            type:'image',
                            image:{uploaded:true,url:imgUrl,link:imgSrcPage,pos:{x:this.pen.start_x,y:this.pen.start_y,w:imgWidth,h:imgHeight}},
                            dim:{x:this.pen.start_x,y:this.pen.start_y,w:imgWidth,h:imgHeight,link:imgSrcPage},
                            element_id:this.pen.cur_element_id,
                            pen:{color:this.pen.color,width:this.pen.stroke_width,fill:"none"},
                            transforms:{trslt:{x:0,y:0},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}}
                        }};
                        config = this.queueAddedImage.config;
                        cx = Math.abs((config.dim.x + config.dim.w/2));
                        cy = Math.abs((config.dim.y + config.dim.h/2));
                        config.transforms.rotate.cx = cx;
                        config.transforms.rotate.cy = cy;
                        $('#imageUploadInterface').contents().find('[name=imgposter]').submit();                        
                    }

                    $('#image-module-image-url').attr("value","");
                    $('#image-module-image-link').attr("value","");
                    $('#image-module-image-width').attr("value","");
                    $('#image-module-image-height').attr("value","");

                    return val;
               },
               loadImportedDocument:function(docType,displayName,fsFileName,pageCount,imgWidth,imgHeight,doc_text,static_references,new_context){
                    var context = typeof new_context != "undefined"?new_context:ColabopadApplication.getContext(this.selected_node.user_id,this.selected_node.context_id);
                    if(docType == "powerpoint" || docType == "pdf"){
                        var bcontinue = true;
                        var index = 0;
                        var firstPage = 1;
                        var tm = setInterval(function(){
                           if(!bcontinue)return;bcontinue = false;
                           if(index+1 == pageCount){
                               $("#participant-treecontrol").dynatree('getTree').activateKey('key-'+context.pid+'-'+context.id+'-'+firstPage) ;
                               clearInterval(tm);$.unblockUI();
                           }

                           ColabopadApplication.newPg(context,"plain-sheet",""+(index+1), function(page,index){
                                //var imgWidth = 800;
                                //var imgHeight = 800;
                                var realFileName = fsFileName+'-'+(index)+".png";
                                var config = {
                                    header:{movable:false,rotatable:false,deletable:false,scalable:false,
                                    static_references:[{"fileName":realFileName}]},
                                    type:'image',
                                    image:{uploaded:true,url:realFileName,link:'',pos:{x:0,y:0,w:imgWidth,h:imgHeight}},
                                    dim:{x:0,y:10,w:imgWidth,h:imgHeight,link:''},
                                    element_id:ColabopadApplication.pen.cur_element_id,
                                    pen:{color:ColabopadApplication.pen.color,width:ColabopadApplication.pen.stroke_width,fill:"none"},
                                    transforms:{trslt:{x:0,y:0},rotate:{cx:0,cy:0,angle:0},scale:{x:1,y:1}}
                                };
                                ColabopadApplication.persistElement(page,{config:config,access:[0,0,3,0],dom:null});
                                page.elements.push({config:config,access:[0,0,3,0],dom:null});
                                //ColabopadApplication.insertContentElement(page,{config:config,access:[0,0,3,0],dom:null},true);
                                if(index == 0)firstPage = page.id;
                                bcontinue = true;
                           },index++);
                        },100);
                    }
                    else
                    if(docType == "ms-word"){
                         ColabopadApplication.queued_text = doc_text;
                         ColabopadApplication.newPg(context,"text-editor",displayName,function(){
                             $.unblockUI();
                         },0,static_references);
                    }
               },
               showUserProfilePhoto:function(docType,displayName,fsFileName,pageCount,imgWidth,imgHeight,doc_text,static_references){
                    $.unblockUI();
                    this.getUser(user_id).photo = fsFileName;
                    $("#user-setting-profile-photo").attr("src",this.getFileServiceUrl(this.getUser(user_id).photo));
               },
               resetIframes:function(){
                    if(typeof phyzixlabs_database == "undefined"){
                        
                            $('#saveAsSVGInterface').attr("src","export-handlers/svg-processor.jsp");
                        
                            $('#saveAsPNGInterface').attr("src","export-handlers/png-processor.jsp");
                        
                            $('#saveAsPDFInterface').attr("src","export-handlers/pdf-processor.jsp");  
                        
                            $('#saveAsDataInterface').attr("src","export-handlers/data-processor.jsp");
                            
                            $('#packageInterface').attr("src","../appbuilder/package.jsp"); 
                    }else{
                        
                            $('#saveAsSVGInterface').attr("src","exports/svg.html");
                        
                            $('#saveAsPNGInterface').attr("src","exports/png.html");
                        
                            $('#saveAsPDFInterface').attr("src","exports/pdf.html");  
                        
                            $('#saveAsDataInterface').attr("src","exports/data.html"); 
                            $('#packageInterface').attr("src","package/package.html");
                    }          
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
               onExportComplete:function(){
                   $.unblockUI();                   
                   this.resetIframes();                 
               },
               onExportError:function(from,type,msg){
                    $.unblockUI();
                    if(type=='limit'){
                        $('#plan-upgrade-prompt-dialog-msg').text("You have exceeded the maximum number of exports on your account, Please upgrade your account for unlimited imports.");
                        $('#plan-upgrade-prompt-dialog').dialog('open');
                    }
                    else
                    if(type == 'exception'){
                        $('#back-end-error-dialog-msg').text(msg);
                        $('#back-end-error-dialog').dialog("open");
                    }
                    this.resetIframes()
               },
               onUploadDone:function(param/*from,docType,displayName,fsFileName,pageCount,imgWidth,imgHeight,doc_text,static_references,upgradeNeeded*/){
                    if(param.upgradeNeeded){
                        $.unblockUI();
                        $('#plan-upgrade-prompt-dialog-msg').text("You have exceeded the maximum number of imports on your account, Please upgrade your account for unlimited imports.");
                        $('#plan-upgrade-prompt-dialog').dialog('open');
                        return;
                    }
                    
                    
                    var _this = this;
                    if(param.from == "import"){
                        this.loadImportedDocument(param.docType,param.displayName,param.fsFileName,param.pageCount,param.imgWidth,param.imgHeight,param.doc_text,param.static_references);
                    }
                    else
                    if(param.from == "import-create-binder"){
                        this.newWorkbookImpl(param.displayName,false,false,function(context){
                            _this.selected_node.user_id    = user_id;
                            _this.selected_node.context_id = context.id;
                            _this.loadImportedDocument(param.docType,param.displayName,param.fsFileName,param.pageCount,param.imgWidth,param.imgHeight,param.doc_text,param.static_references,context);
                        });
                    }
                    else
                    if(param.from == "import-teamspace"){
                        this.newWorkbookImpl(param.displayName,true,false,function(context){
                            _this.selected_node.user_id    = user_id;
                            _this.selected_node.context_id = context.id;
                            _this.loadImportedDocument(param.docType,param.displayName,param.fsFileName,param.pageCount,param.imgWidth,param.imgHeight,param.doc_text,param.static_references,context);
                        });
                    }
                    else
                    if(param.from == "user-profile-photo"){
                        this.showUserProfilePhoto(param.docType,param.displayName,param.fsFileName,param.pageCount,param.imgWidth,param.imgHeight,param.doc_text,param.static_references);
                    }
                    else
                    if(param.from == "from-app"){
                        $.unblockUI();
                        if(typeof this.importCallBack != "undefined"){
                            this.importCallBack(param.fsFileName,param.displayName,param.docType,param.doc_text);
                        }
                    }
               },
               addUploadedImage:function(fsFileName,upgradeNeeded){
                    if(upgradeNeeded){
                        $.unblockUI();
                        $('#plan-upgrade-prompt-dialog-msg').text("You don't have access to the image upload feature, Please upgrade your account for unlimited image uploads.");
                        $('#plan-upgrade-prompt-dialog').dialog('open');
                        return;
                    }                   
                   
                    this.queueAddedImage.config.header={static_references:[{"fileName":fsFileName}]};
                    this.queueAddedImage.config.image.url=fsFileName;
                    var val = ColabopadApplication.addImageConfig(ColabopadApplication.queueAddedImage.config,ColabopadApplication.queueAddedImage.pad,true);

                    if(val){
                      ColabopadApplication.addToUndoStack({element:val,type:"insert"});
                      ColabopadApplication.resetRedoStack();
                    }
                    $.unblockUI();
               },
               fillShape:function(pad,element,update){
                   
                   element.shape_el.setAttribute("fill",element.config.pen.fill);
                   if(update){
                        ColabopadApplication.updateElement(pad,element);
                         if(pad.queue_url){
                            //log("shape fill message")
                            ColabopadApplication.MsgHandler.sendMessage({to:pad.queue_url,message:{header:{type:"fill-shape",src_session:sessionId,pid:pad.context.pid,cntx_id:pad.context.id,page_id:pad.id,id:element.config.dbid},color:element.config.pen.fill}});
                        }
                   }
               },
               mouseupImpl:function(event,pad){

                  var p = this.alignCoordinates(event,pad);
                  $(this.pen.shape_metric).css({"display":"none"});
                  
                  if(this.pen.mode!='eraser'&&this.pen.mode!='move'&&this.pen.mode!='rotate' && this.pen.mode != 'resize' && this.pen.mode != 'pointer' && this.pen.mode != 'fill'){

                      if(this.pen.down && this.pen.moved){

                              if(this.pen.cur_element_parent_node != null){
                                this.debugRemove(pad,this.pen.cur_element_parent_node,'mouseupImpl');
                                this.pen.cur_element_parent_node = null;
                              }

                              
                              if(this.pen.mode=='freehand'){
                                  this.addStroke(p,pad);
                              }
                              else
                              if(this.pen.mode=='line'){
                                  this.addLine(p, pad);
                              }
                              else
                              if(this.pen.mode=='circle'){
                                  this.addCircle(p, pad);
                              }
                              else
                              if(this.pen.mode=='rect'){
                                  this.addRect(p, pad);
                              }                             
                        }
                  }
                  else
                  if( (this.pen.mode =='move' || this.pen.mode == 'pointer' || this.pen.mode =='resize')  && this.pen.down){
                      
                      if(this.pen.activeElement != null && this.pen.moved){

                             var m = this.pen.activeElement;
                             var btransform = true;

                             //dynmically check
                             if(m.config.type == "widget" && typeof m.element.widget.isMovable != "undefined" && !m.element.widget.isMovable(m)){
                                    if(this.pen.mode == 'pointer' || this.pen.mode == 'move')
                                    {
                                        this.pen.down = false;
                                        btransform = false;
                                        //notify all applets of mouse up event
                                        this.notifyAppletsMouseUpScreen(pad, p, event);
                                    }
                             }
                             else
                             if(typeof m.config.header != "undefined")
                             {
                                if(  (this.pen.mode == 'pointer' || this.pen.mode == 'move')&&(typeof m.config.header.movable != "undefined" && !m.config.header.movable))
                                {
                                    this.pen.down = false;
                                    btransform = false;
                                    //notify all applets of mouse up event
                                    this.notifyAppletsMouseUpScreen(pad, p, event);
                                }
                             }

                            if(btransform){
                                
                                if(m.config.type == "widget"){
                                    if(this.pen.mode == 'resize' && typeof m.element.widget.onScale != "undefined"){                                    
                                            App_CallBack_Interface.async_onScale(pad, m.element.widget,m.applet_instance, {x:0,y:0},true);
                                    }
                                    else
                                    if((this.pen.mode == 'move' || this.pen.mode == 'pointer') && typeof m.element.widget.onTranslate != "undefined"){                                    
                                            App_CallBack_Interface.async_onTranslate(pad, m.element.widget,m.applet_instance, {x:0,y:0},true);
                                    }                       
                                }                                
                                
                                var trslt = m.config.transforms.trslt;
                                var cx = Math.abs(trslt.x+(m.config.dim.x + (m.config.dim.w*m.config.transforms.scale.x)/2));
                                var cy = Math.abs(trslt.y+(m.config.dim.y + (m.config.dim.h*m.config.transforms.scale.y)/2));
                                m.config.transforms.rotate.cx = cx;
                                m.config.transforms.rotate.cy = cy;

                                //var rect = this.getBoundingBox(this.transformRectangle(m.config.dim, m.config.transforms));
                                //var center = {x:rect.tr.x-((rect.tr.x-rect.tl.x)/2),y:rect.br.y-((rect.br.y-rect.tr.y)/2)};
                                //m.config.transforms.rotate.cx = center.x;
                                //m.config.transforms.rotate.cy = center.y;
                                //debug('center1('+m.config.transforms.rotate.cx+','+m.config.transforms.rotate.cy+')')
                                //debug('center2('+center.x+','+center.y+')')
                                var transformation_stack = 'rotate('+m.config.transforms.rotate.angle+','+m.config.transforms.rotate.cx+','+m.config.transforms.rotate.cy+') translate('+m.config.transforms.trslt.x+','+m.config.transforms.trslt.y+') scale('+m.config.transforms.scale.x+','+m.config.transforms.scale.y+')';
                                ColabopadApplication.applyTransformEx(pad,m.element,transformation_stack,true);

                                //this.applyTransform(pad,this.pen.activeElement, this.pen.activeElement.config,true);
                                ColabopadApplication.addToUndoStack(this.pen.activeElement.undoNode);
                                ColabopadApplication.resetRedoStack();
                            }
                            m.mousedrop_pt = null;
                      }
                      else
                      if(this.pen.activeElement == null && (this.pen.mode == 'pointer' || this.pen.mode == 'move')){
                        //notify all applets of mouse up event
                        this.notifyAppletsMouseUpScreen(pad, p, event);
                      }
                  }
                  else
                  if(this.pen.mode =='rotate'){
                      if(this.pen.rotateElement != null && this.pen.down && this.pen.moved){
                            m  = this.pen.rotateElement;
                            
                                                        
                            btransform = true;

                             //dynmically check
                             if(m.config.type == "widget" && typeof m.element.widget.isRotatable != "undefined" && m.element.widget.isRotatable(m)){
                                    btransform = false;
                             }else
                             if(typeof m.config.header != "undefined")
                             {
                                if(typeof m.config.header.rotatable != "undefined" && !m.config.header.rotatable)
                                {
                                    btransform = false;
                                    //notify all applets of mouse up event
                                    //this.notifyAppletsMouseUpScreen(pad, p, event);
                                }
                             }

                            if(btransform){
                                if(m.config.type == "widget"){
                                    if(typeof m.element.widget.onRotate != "undefined"){                                    
                                            App_CallBack_Interface.async_onRotate(pad, m.element.widget,m.applet_instance,0,true);
                                    }                            
                                }                                
                                
                                transformation_stack = 'rotate('+m.config.transforms.rotate.angle+','+m.config.transforms.rotate.cx+','+m.config.transforms.rotate.cy+') translate('+m.config.transforms.trslt.x+','+m.config.transforms.trslt.y+') scale('+m.config.transforms.scale.x+','+m.config.transforms.scale.y+')';
                                ColabopadApplication.applyTransformEx(pad,m.element,transformation_stack,true);

                                ///this.applyTransform(pad,this.pen.rotateElement, this.pen.rotateElement.config,true);
                                ColabopadApplication.addToUndoStack(this.pen.rotateElement.undoNode);
                                ColabopadApplication.resetRedoStack();
                            }
                      }
                  }
                  else
                  if(this.pen.mode == 'pointer' || this.pen.mode == 'move'){
                    //notify all applets of mouse up event
                    this.notifyAppletsMouseUpScreen(pad, p, event);
                  }
                  //
                  if(this.pen.rotateElement != this.pen.activeElement)
                      this.pen.rotateElement = this.pen.activeElement;

                  this.pen.cur_element_parent_node = null;
                  this.pen.down = false;
               },
               mouseoutImpl:function(event,pad){
                 //ColabopadApplication.hideWidgetControlPanel();
                 var p = this.alignCoordinates(event,pad);
                  // debug('mouse leave fired')
                 $(this.pen.shape_metric).css({"display":"none"});
                 //ColabopadApplication.hideWidgetControlPanel();
                 if(this.pen.down){
                    this.mouseupImpl(event,pad);
                 }

                 
                 if(this.pen.mode=='text' && event.target != this.pen.textinputer){
                    this.addText(pad);
                 }
                 this.notifyAppletsMouseOutScreen(pad,p,event);
               },
               mouseenterImpl:function(event,pad){
                 var p = this.alignCoordinates(event,pad);
                 this.notifyAppletsMouseEnterScreen(pad,p,event)
               },
               mousedown:function(event){
                 //debug('mousedown x:'+event.pageX+',y:'+event.pageY+' offset: x'+ColabopadApplication.getCurrentContext().active_pad.div_dom.offset().left+' y:'+ColabopadApplication.getCurrentContext().active_pad.div_dom.offset().top)
                if(event.preventDefault)
                 {
                  event.preventDefault();                  
                 }ColabopadApplication.mousedownImpl(event,ColabopadApplication.getCurrentContext().active_pad);
               },
               mousemove:function(d){
                ColabopadApplication.mousemoveImpl(d,ColabopadApplication.getCurrentContext().active_pad);
               },
               mouseup:function(d){
                ColabopadApplication.mouseupImpl(d,ColabopadApplication.getCurrentContext().active_pad);
               },
               mouseout:function(d){
                   ColabopadApplication.mouseoutImpl(d,ColabopadApplication.getCurrentContext().active_pad);
               },
               mouseenter:function(d){
                   ColabopadApplication.mouseenterImpl(d,ColabopadApplication.getCurrentContext().active_pad);
               },
               deleteContext:function(pid,id){
                   
                   
                   var _this = this;
                   var context = this.removeContext(pid,id);
                   
                    if(typeof phyzixlabs_database != "undefined"){
                        phyzixlabs_database.deleteBinder(context);
                        
                        var key = 'key-'+pid+'-'+id;
                        $("#participant-treecontrol").dynatree('getTree').getNodeByKey(key).remove();                        
                        return;
                    }                   
                   
                   
                   if(typeof context.local != "undefined"){




                        $.ajax({
                            type:'POST',
                            data:{room_id:room_id,grantor:pid,context_id:id},
                            url:'/ContextAction.do?action=del-context',
                            success:function(data){
                               //delete pages
                                for(var i =0;i<context.pages.length;i++){
                                    _this.delPage(context.pages[i],true,true);
                                }
                                                        //else
                                //    bindWorkbookContextMenu("workbookMenu-default");

                                //remove from UI
                                var key = 'key-'+pid+'-'+id;
                                $("#participant-treecontrol").dynatree('getTree').getNodeByKey(key).remove();
                                _this.resetContext();
                                _this.switchToPage(_this.getCurrentContext().active_pad);

                                $('#context-tabcontrol'+context.pid).tabs('remove','#'+context.tabid);

                                //if there are no other binders create one
                                if($('#context-tabcontrol'+context.pid).tabs('length')==0){
                                    //_this.newWorkbook();
                                }
                                else
                                {
                                    //$('#context-tabcontrol'+context.pid).tabs('select',$('#context-tabcontrol'+context.pid).tabs('length'));
                                }
                                //if(context == this.getCurrentContext()){
                                    //switch context
                                //    $('#context-tabcontrol'+context.pid).tabs('select','#'+context.tabid);
                                //}
                                //if(this.context_list.length>1)
                                ColabopadApplication.ContextMenus.bindWorkbookContextMenu("workbookMenu");
                            }
                        });
                   }
               },
               deletePage:function(page){
                    if(typeof phyzixlabs_database != "undefined"){
                        phyzixlabs_database.deletePage(page);
                        return;
                    }                   
                   
                   if(typeof page.context.local != "undefined"){

                        $.ajax({
                            type:'POST',
                            data:{room_id:room_id,grantor:page.context.pid,context_id:page.context.id,pad_id:page.id,room_access_code:room_access_code},
                            url:'/PadAction.do?action=del-pad',
                            success:function(data){
                                //var reply = eval('('+data+')');
                                //config.dbid = reply.id;
                                //alert(data)
                            }
                        });
                   }
               },
               updateAppInstanceAccess:function(page,element,access,callback){
                    var element_access = -1;
                    if(typeof access == "number")
                        element_access = access;
                    else
                    if(typeof access != "undefined" && typeof access != "function")
                        element_access = ColabopadApplication.MsgHandler.json2Txt(access);
                
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,grantor:page.context.pid,context_id:page.context.id,pad_id:page.id,element_id:element.config.dbid,access:element_access},
                        url:'/ElementAction.do?action=update-instance-access',
                        success:function(data){
                            //var reply = eval('('+data+')');
                            if(typeof access == "function")
                                access(config)
                            else
                            if(typeof callback == "function")
                                callback();                            
                        }
                    });
               },
               updatePadAccess:function(page,granted_to){
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,grantor:page.context.pid,context_id:page.context.id,pad_id:page.id,granted_to:granted_to,access:page.access[ColabopadApplication.access_index]},
                        url:'/PadAction.do?action=update-pad-access',
                        success:function(data){
                            //var reply = eval('('+data+')');
                        }
                    });
               },
               updateElementAccess:function(page,element,granted_to){//alert(element.access);
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,grantor:page.context.pid,context_id:page.context.id,pad_id:page.id,element_id:element.config.dbid,granted_to:granted_to,access:element.access[ColabopadApplication.access_index]},
                        url:'/ElementAction.do?action=update-element-access',
                        success:function(data){
                            //var reply = eval('('+data+')');
                        }
                    });
               },
               updateContextAccess:function(cntx,granted_to){//alert("user_id:"+user_id+"\n room_id:"+room_id+"\n granted_to:"+granted_to+"\n context_id:"+cntx.id+"\n access:"+cntx.access[ColabopadApplication.access_index]+"\n access_index:"+ColabopadApplication.access_index);
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,grantor:cntx.pid,context_id:cntx.id,granted_to:granted_to,access:cntx.access[ColabopadApplication.access_index]},
                        url:'/ContextAction.do?action=update-context-access',
                        success:function(data){
                            //var reply = eval('('+data+')');
                            //config.dbid = reply.id;
                            //alert(data)
                        }
                    });
               },
               updateContext:function(cntx,config){
                   
                    if(typeof phyzixlabs_database != "undefined"){
                        phyzixlabs_database.updateBinder(cntx,config);
                        return;
                    }
                    
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,grantor:cntx.pid,context_id:cntx.id,config:ColabopadApplication.MsgHandler.json2Txt(config),access_control:cntx.access[0]},
                        url:'/ContextAction.do?action=update-context',
                        success:function(data){
                            //var reply = eval('('+data+')');
                            //config.dbid = reply.id;
                            //alert(data)
                        }
                    });
               },
               movePad:function(page,parent_id,pre_sibling,children_only){
                    if(typeof phyzixlabs_database != "undefined"){
                        phyzixlabs_database.movePage(page,parent_id,pre_sibling,children_only);
                        return;
                    }
                    if(typeof page.clientside!="undefined" && page.clientside)return;
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,grantor:page.context.pid,context_id:page.context.id,pad_id:page.id,parent_id:parent_id,pre_sibling:pre_sibling,children_only:children_only},
                        url:'/PadAction.do?action=move-pad',
                        success:function(data){
                            //var reply = eval('('+data+')');
                        }
                    });                    
               },
               updatePadPreSibling:function(page,pre_sibling){
                    if(typeof phyzixlabs_database != "undefined"){
                        phyzixlabs_database.updatePagePreSibling(page,pre_sibling);
                        return;
                    }
                    if(typeof page.clientside!="undefined" && page.clientside)return;
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,grantor:page.context.pid,context_id:page.context.id,pad_id:page.id,pre_sibling:pre_sibling},
                        url:'/PadAction.do?action=update-pad-pre-sibling',
                        success:function(data){
                            //var reply = eval('('+data+')');
                        }
                    });                    
               },
               updatePad:function(page,config){
                    if(typeof phyzixlabs_database != "undefined"){
                        phyzixlabs_database.updatePage(page,config);
                        return;
                    }
                    if(typeof page.clientside!="undefined" && page.clientside)return;
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,grantor:page.context.pid,context_id:page.context.id,pad_id:page.id,config:ColabopadApplication.MsgHandler.json2Txt(config),access_control:page.access[0]},
                        url:'/PadAction.do?action=update-pad',
                        success:function(data){
                            //var reply = eval('('+data+')');
                        }
                    });
               },
               updateElement:function(page,element,access,callback){
                   
                    if(typeof phyzixlabs_database != "undefined"){
                        phyzixlabs_database.updateElement(page,element);
                        
                        if(typeof access == "function")
                            access(element)
                        else
                        if(typeof callback == "function")
                            callback(element);                        
                        return;
                    }                   
                   
                    var element_access = -1;
                    if(typeof access == "number")
                        element_access = access;
                    else
                    if(typeof access != "undefined" && typeof access != "function")
                        element_access = ColabopadApplication.MsgHandler.json2Txt(access);


                   if(typeof page.clientside!="undefined" && page.clientside)return;
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,grantor:page.context.pid,context_id:page.context.id,pad_id:page.id,id:element.config.dbid,config:ColabopadApplication.MsgHandler.json2Txt(element.config),access:element_access},
                        url:'/ElementAction.do?action=update-element',
                        success:function(data){
                            if(typeof access == "function")
                                access(element)
                            else
                            if(typeof callback == "function")
                                callback(element);
                            //var reply = eval('('+data+')');
                            //config.dbid = reply.id;
                            //alert(data)
                        }
                    });
               },
               deleteElement:function(page,config,callback){

                    if(typeof phyzixlabs_database != "undefined"){
                        phyzixlabs_database.deleteElement(page,config);
                        
                        if(typeof callback == "function")
                            callback(config);                        
                        return;
                    }

                    if(typeof page.clientside!="undefined" && page.clientside)return;
                    
                    if(this.findElement(page,config.dbid) != null){
                        if(page.elements.length>0){
                            page.last_insert = page.elements[page.elements.length-1].config.dbid;
                        }
                        else{
                            page.last_insert = 0;
                        }
                    }

                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,grantor:page.context.pid,context_id:page.context.id,pad_id:page.id,id:config.dbid},
                        url:'/ElementAction.do?action=delete-element',
                        success:function(data){
                            var reply = eval('('+data+')');
                            if(typeof callback == "function")
                                callback(config);
                            /*
                            try{
                                page.last_insert = parseInt(reply.last_insert);
                                if(isNaN(page.last_insert))
                                    page.last_insert = 0;
                            }catch(ex){
                                page.last_insert = 0;
                                debug('error parsing last_insert. exception:'+ex);
                            }*/
                            
                        }
                    });

                    //debug('last_insert:'+page.last_insert);
                    //propagate to queue
                    if(page.queue_url){
                        ColabopadApplication.MsgHandler.sendMessage({to:page.queue_url,message:{header:{type:"delete",src_session:sessionId,pid:page.context.pid,cntx_id:page.context.id,page_id:page.id,id:config.dbid}}});
                    }
               },
               getElement:function(grantor,context_id,pad_id,id,cb){
                        $.ajax({
                            type:'POST',
                            data:{room_id:this.room_id,grantor:grantor,context_id:context_id,pad_id:pad_id,element_id:id},
                            url:'/ElementAction.do?action=get-element',
                            success:function(data){
                                var reply = eval('('+data+')');
                                cb(reply);
                            }
                        });                   
               },
               persistElement:function(page,element,access,callback){
                if(typeof phyzixlabs_database != "undefined"){
                    element.id = new Date().getTime();    
                    element.config.dbid = element.id;
                    
                    phyzixlabs_database.addElement(page,element);
                    if(typeof access == "function"){
                        access(element);
                    }
                    else
                    if(typeof callback == "function"){
                        callback(element);
                    }return;
                }else{
                
                var element_access = -1;
                if(typeof access == "number")
                   element_access = access;
                else
                if(typeof access != "undefined" && typeof access != "function")
                   element_access = ColabopadApplication.MsgHandler.json2Txt(access);

                if(typeof page.clientside!="undefined" && page.clientside)return;
                    
                    element.config.dbid = ++page.last_insert;
                    element.id = page.last_insert;
                    
                   
                    data={room_id:this.room_id,
                          grantor:page.context.pid,
                          context_id:page.context.id,
                          pad_id:page.id,
                          config:ColabopadApplication.MsgHandler.json2Txt(element.config),
                          access:element_access};
                    
                    $.ajax({
                        type:'POST',
                        data:data,
                        url:'/ElementAction.do?action=add-element',
                        success:function(data){
                            var reply = eval('('+data+')');
                            
                            element.id = parseInt(reply.id);
                            if(typeof access == "function"){
                                access(element);
                            }
                            else
                            if(typeof callback == "function"){
                                callback(element);
                            }
                            //config.dbid = parseInt(reply.id);
                            //page.last_insert = config.dbid;
                            //debug('new insert:'+config.dbid)
                        }
                    });
                }
                    //propagate to queue
                    if(page.queue_url && element_access==-1){
                        ColabopadApplication.MsgHandler.sendMessage({to:page.queue_url,message:{header:{type:"insert",src_session:sessionId,pid:page.context.pid,cntx_id:page.context.id,page_id:page.id},config:element.config}});
                    }
               },
               showOutlines:function(){
                   for(var i=0;i<pad.elements.length;i++){
                       
                   }
               },
               insertContentElement:function(pad,element,persist_to_db,paint_only){
                     
                     //only add non-widgets, since widgets would be added after they're initialized
                     /****Adding widget later causes infinite loop because of multiple access to array of elements****/
                     var element_parent_node = null;
                     var pad_root = pad.content_root_svg;

                     if(typeof paint_only == "undefined" || !paint_only)
                        pad.elements.push(element);           

                     var write_access = (pad.access[0]&this.ACCESS_MODE.WRITE)>0 /*||(pad.context.access[0]&this.ACCESS_MODE.WRITE)>0*/ || (pad.access[2]&this.ACCESS_MODE.WRITE)>0 /*|| (pad.context.access[2]&this.ACCESS_MODE.WRITE)>0*/;
                     
                     if(element.config.type=='widget'){
                         
                        element_parent_node = pad.svg_doc.group(pad_root);
                        element_parent_node.setAttribute("class","note-element");
                        element.dom = element_parent_node;
                        element_parent_node.config  = element.config;
                        element_parent_node.element = element;
                        
                        element.config.incoming = true;
                        this.addWidgetInstance(element,pad,element_parent_node);
                     }
                     else
                     {
                         element_parent_node = element.config.type!='text'?pad.svg_doc.group(pad_root,element.config.element_id,{fill: element.config.pen.fill,stroke:element.config.pen.color,'stroke-width': element.config.pen.width}):pad.svg_doc.group(pad_root,element.config.element_id,{fill: element.config.pen.fill,stroke:element.config.pen.color});
                         element_parent_node.setAttribute("class","note-element");
                         element.dom = element_parent_node;
                         
                         if(write_access){
                            element_parent_node.onclick            = this.pen.eraserListener;
                            element_parent_node.onmouseover        = this.onMouseoverElement;
                            element_parent_node.onmouseout         = this.onMouseoutElement;

                            if(element.config.type!='stroke'){
                                element_parent_node.onmousedown    = this.onMousedownElement;
                                element_parent_node.onmouseup      = this.onMouseupElement;
                            }
                            //save the configuration information for this element, makes it easy to alter both together
                         }
                         element_parent_node.config  = element.config;
                         element_parent_node.element = element;

                         var element_shape_node = null;
                         if(element.config.type=='text'){
                             if(typeof element.config.pen.extra_settings != "undefined"){
                                //var tspan = pad.svg_doc.other()
                                element_shape_node = pad.svg_doc.text(element_parent_node,element.config.text.pos.x, element.config.text.pos.y,element.config.text.data,element.config.pen.extra_settings);
                             }
                             else
                            element_shape_node = pad.svg_doc.text(element_parent_node,element.config.text.pos.x, element.config.text.pos.y,element.config.text.data);
                         }
                         else
                         if(element.config.type=='image'){

                            var linkNode = null;
                            if(/*config.image.link != ""*/false){
                                linkNode = pad.svg_doc.link(element_parent_node,element.config.image.link);
                            }
                            var parent = linkNode!=null?linkNode:element_parent_node;

                            //this is a fix for when the element might be copied when distributed.
                            //var imgUrl = element.config.dbid?'img-'+pad.room_id+'-'+pad.context.pid+'-'+pad.context.id+'-'+pad.id+'-'+element.config.dbid:element.config.image.url;
                            //element.config.image.url = imgUrl;
                            
                            var url = typeof element.config.image.uploaded != "undefined"?this.getFileServiceUrl(element.config.image.url):element.config.image.url+'?ts='+(new Date().getTime());

                            element_shape_node = pad.svg_doc.image(parent,element.config.image.pos.x, element.config.image.pos.y,element.config.image.pos.w,element.config.image.pos.h,url);
                         } 
                         else
                         if(element.config.type=='stroke'){
                            // alert("handle"+element.config.points)
                            element_shape_node = pad.svg_doc.polyline(element_parent_node,(element.config.points));
                         }
                         else
                         if(element.config.type=='line-stroke'){
                            if(typeof element.config.pen.extra_settings != "undefined")
                                element_shape_node = pad.svg_doc.line(element_parent_node,element.config.points.start.x, element.config.points.start.y, element.config.points.end.x,element.config.points.end.y,element.config.pen.extra_settings);
                            else
                                element_shape_node = pad.svg_doc.line(element_parent_node,element.config.points.start.x, element.config.points.start.y, element.config.points.end.x,element.config.points.end.y);
                         }
                         else
                         if(element.config.type=='circle-stroke'){
                            /**
                            cur_shape = svg_doc.circle(cur_node,element.points.x,element.points.y,element.points.rad,{"pointer-events":"visible",fill:element.pen.fill});
                            ***/
                            element_shape_node = pad.svg_doc.ellipse(element_parent_node,element.config.points.x,element.config.points.y,element.config.points.adj,element.config.points.ops,{"pointer-events":"visible",fill:element.config.pen.fill});

                            element.shape_el              = element_shape_node;
                            element_shape_node.config     = element;
                            if(write_access){
                                /*element_shape_node.ondblclick = this.pen.shapeFill;*/
                                element_shape_node.onclick = this.pen.shapeFill;
                            }
                         }
                         else
                         if(element.config.type=='rec-stroke'){
                            var normRect = this.normalizeRect(element.config.points.x, element.config.points.y,element.config.points.w,element.config.points.h);
                            element_shape_node = pad.svg_doc.rect(element_parent_node,normRect.x, normRect.y,normRect.w,normRect.h,{"pointer-events":"visible",fill:element.config.pen.fill});


                            element.shape_el                = element_shape_node;
                            element_shape_node.config       = element;
                            if(write_access){
                                /*element_shape_node.ondblclick   = this.pen.shapeFill;*/
                                element_shape_node.onclick = this.pen.shapeFill;
                            }
                             
                         }
                         else
                         if(element.config.type == "svg-markup"){
                             
                         }

                         //save to database if necessary
                         if(write_access && persist_to_db){
                            this.persistElement(pad, element);
                         }

                         if(/*element.config.type!='stroke'*/true){
                            this.applyTransform(pad,element,false);
                         }
                     }
                     return element;
               },
               deleteWidgetInstance:function(pad,m,callback){
                    if(typeof m.dom != "undefined")
                    ColabopadApplication.debugRemove(pad,m.dom,'deleteWidgetInstance');
                
                    ColabopadApplication.findAndRemoveWidget(m,pad);
                    ColabopadApplication.deleteElement(pad, m.config,callback);
               },
               loadPage:function(page){
                    var _this = this;
                    this.newPage(page.template,function(pad){
                        for(var i=0;i<page.elements.length;i++){
                            _this.insertContentElement(pad,page.elements[i],true);
                        }
                    });
               },
               firstActivePage:null,
               initOffLineContext:function(parent,cntx){
                    var parentNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(parent.key);
                    var contextNode = {isFolder:false,addClass:cntx.nodeclass,rid:cntx.rid,pid:cntx.pid,id:cntx.id,key:cntx.key, title:cntx.title,type:cntx.type};
                    parentNode.append(contextNode);

                    var context = {
                        pid:cntx.pid,
                        rid:cntx.rid,
                        id:cntx.id,
                        access:[this.ACCESS_MODE.WRITE,this.ACCESS_MODE.WRITE],
                        title:cntx.title,
                        active_pad:null,
                        pages:[],
                        tab:null,
                        dock:null,
                        category:cntx.category,
                        selected:false,
                        clientside:true,
                        isCatalog:true
                    }
                    
                    contextNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(contextNode.key);


                    for(var j=0;j<cntx.pads.length;j++){

                        var pad = cntx.pads[j];
                        var page = {pid:cntx.pid,
                                    context_id:cntx.id,
                                    id:pad.id,
                                    access:[this.ACCESS_MODE.WRITE,this.ACCESS_MODE.WRITE],
                                    title:pad.title,
                                    template:this.getPageTemplate(pad.template),
                                    svg_doc:null,
                                    context:context,
                                    widget_instances:[],
                                    elements:[],
                                    activeWidgetInstance:null,
                                    div_dom:null,
                                    loaded:false,
                                    loaded_from_db:false,
                                    clicked:true,
                                    load_callbacks:[],
                                    clientside:true,
                                    index:pad.index,
                                    isCatalogPage:pad.isCatalogPage,
                                    category:cntx.category,
                                    undo_stack:[],
                                    redo_stack:[]};
                        if(this.firstActivePage == null)
                            this.firstActivePage = page;
                        
                        var padNode = {isFolder:false,addClass:pad.nodeclass,key:pad.key,rid:pad.rid,pid:pad.pid,cntx_id:pad.cntx_id,id:pad.id,title:pad.title,type:pad.type};
                        contextNode.append(padNode);
                        context.pages.push(page);
                    }
                    //part_cntx.context_list.push(context);
                    return context;
               },
               initContext:function(part_cntx,cntx,local,skipnode){
                    var pid = part_cntx.id;
                    //alert(pid)
                    var participantNode = null;
                    if(typeof phyzixlabs_database == "undefined")
                        participantNode = cntx.meta_data.teamspace?$("#participant-treecontrol").dynatree('getTree').getNodeByKey('key-teamspace'):$("#participant-treecontrol").dynatree('getTree').getNodeByKey('key-'+pid);
                    else{
                        participantNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey('library-root');
                    }
                    //alert(participantNode)
                    var firstNode = null;
                    var nodeclass = part_cntx.id==this.user_id?'docnode':'fdocnode';
                    var contextNode = {isFolder:true,addClass:nodeclass,key:'key-'+pid+'-'+cntx.id,pid:pid,id:cntx.id, title:cntx.meta_data.title,type:'context'};
                    if(typeof(skipnode) == "undefined"){
                        participantNode.append(contextNode);
                    }

                        
                    cntx.access[0] = parseInt(cntx.access[0]);
                    cntx.access[1] = parseInt(cntx.access[1]);


                    var context = {
                        room_id:room_id,
                        participant_id:pid,
                        id:cntx.id,
                        local:local,
                        pid:pid,
                        title:cntx.meta_data.title,
                        active_pad:null,
                        pages:[],
                        tab:null,
                        dock:null,
                        access_index:0,
                        access:cntx.access,
                        selected:false,
                        queue_url:cntx.meta_data.queue_url
                    }

                    contextNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(contextNode.key);

                    this.total_page_count += cntx.pads.length;
                    for(var j=0;j<cntx.pads.length;j++){

                        var pad = cntx.pads[j];
                        var page = {room_id:this.room_id,
                                    participant_id:pid,
                                    context_id:cntx.id,
                                    id:pad.id,
                                    title:pad.meta_data.title,
                                    size_scale:typeof pad.meta_data.size_scale != "undefined"?pad.meta_data.size_scale:{"x":1,"y":1},
                                    template:this.getPageTemplate(pad.meta_data.template),
                                    header:pad.header,
                                    svg_doc:null,
                                    context:context,
                                    widget_instances:[],
                                    elements:/*(typeof phyzixlabs_database != "undefined" && typeof getPageContent == "function")?getPageContent():*/[],
                                    activeWidgetInstance:null,
                                    embed_key:pad.embed_key,
                                    div_dom:null,
                                    loaded:false,
                                    access:pad.access,
                                    access_index:0,
                                    queue_url:pad.meta_data.queue_url,
                                    loaded_from_db:/*(typeof phyzixlabs_database != "undefined")*/false,
                                    last_insert:0,                                    
                                    clicked:true,
                                    load_callbacks:[],
                                    undo_stack:[],
                                    redo_stack:[]};
                                
                        if(this.firstActivePage == null)
                            this.firstActivePage = page;
                        
                        var write_access = /*(page.context.access[2]&this.ACCESS_MODE.WRITE)>0 ||*/(page.access[2]&this.ACCESS_MODE.WRITE)>0 /*|| (page.context.access[0]&this.ACCESS_MODE.WRITE)>0*/ || (page.access[0]&this.ACCESS_MODE.WRITE)>0;

                        nodeclass = write_access?'padnode':'padnode0';

                        var padNode = {isFolder:false,addClass:nodeclass,key:'key-'+pid+'-'+cntx.id+'-'+pad.id,pid:pid,context_id:cntx.id,id:pad.id,embed_key:pad.embed_key, title:pad.meta_data.title,type:'pad'};
                        if(typeof(skipnode) == "undefined")
                            contextNode.append(padNode);
                        if(firstNode==null)
                            firstNode = padNode;

                        pad.access[0] = parseInt(pad.access[0]);
                        pad.access[1] = parseInt(pad.access[1]);
                        //var queue_url = null;

                        context.pages.push(page);
                    }
                    part_cntx.context_list.push(context);

                    //setup listener for context level messages
                    if(context.queue_url){
                        var listener = {
                                        id:'listener-'+ColabopadApplication.room.id+'-'+context.pid+'-'+context.id,
                                        destination:context.queue_url,
                                        rcvMessage:ColabopadApplication.receiveContextMsg
                                       };
                       ColabopadApplication.MsgHandler.registerListener(listener);
                    }
                    return context;
               },
                showWidgetControlPanel:function(pad,m){                      
                       
                       
                       if(!embeded && this.page_screen_mode)return;
                        
                       //set defocus notification
                       if(pad.activeWidgetInstance != null && pad.activeWidgetInstance.hasfocus){
                           if(typeof pad.activeWidgetInstance.widget.onLossFocus != "undefined")
                                pad.activeWidgetInstance.widget.onLossFocus(pad,pad.activeWidgetInstance);
                           pad.activeWidgetInstance.hasfocus=false;
                       }

                       //$(ColabopadApplication.widgetControlPanelFrame).find('div').detach();

                       //call focus notification
                       m.widget.setActiveInstance(m);
                       m.hasfocus = true;

                       var reloadcp = false;
                       if(m != pad.activeWidgetInstance){
                           //hide control panel if visible since new instance has taken focus
                           $(ColabopadApplication.widgetControlPanelFrame).css({'display':'none'}).find('div').detach();
                           reloadcp = true;
                       }
                       pad.activeWidgetInstance = m;

                       var offset=pad.div_dom.offset();
                       //alert(offset.left)

                       var transformedRect = ColabopadApplication.getBoundingBox(ColabopadApplication.transformRectangle(m.config.dim,m.config.transforms));

                       var sct         = 0;//!embeded?this.ui_components.layout.center.scrollTop():0;
                       var left_scroll = 0;//!embeded?this.ui_components.layout.center.scrollLeft():0;

                       

                       var cpPos = this.dimToClientCoord({x:transformedRect.tr.x+16+left_scroll,y:transformedRect.tr.y+sct,w:transformedRect.tr.x-transformedRect.tl.x,h:transformedRect.bl.y-transformedRect.tl.y},pad);
                       cpPos.x = offset.left+transformedRect.tr.x-1+left_scroll;


                       var widget_pos = this.getBoundingBox(transformedRect);
                       //debug("scroll top:"+sct+" scroll left:"+left_scroll+" cp.x:"+cpPos.x)

                       //reset button states
                       $('.widget-app-cp-button').css("display","block");
                       $('#widget-move-button,#widget-rotate-button,#widget-scale-button').css("display","none");



                        //show widget control panel, if any.
                       if(m.widget.getControlPanel() != null){
                           var cp_x = typeof m.widget.getControlPanel().size.x != "undefined"?m.widget.getControlPanel().size.x+widget_pos.tl.x+left_scroll+offset.left:widget_pos.tl.x+left_scroll+offset.left;
                           var cp_y = typeof m.widget.getControlPanel().size.y != "undefined"?m.widget.getControlPanel().size.y+widget_pos.tl.y+sct+offset.top:widget_pos.tl.y+sct+offset.top;

                           //debug("cp_x:"+cp_x+",cp_y:"+cp_y)
                           $(ColabopadApplication.widgetClassControlPanelFrame).find('div').detach();
                           $(ColabopadApplication.widgetClassControlPanelFrame).append(m.widget.getControlPanel().panel).css({'position':'absolute', 'display':'block','left':cp_x,'top':cp_y,width:m.widget.getControlPanel().size.width,height:m.widget.getControlPanel().size.height});
                           //call widget reload control panel

                           if(typeof m.widget.resetControlPanel != "undefined")
                               m.widget.resetControlPanel(m); 
                       }else{
                           $('#widget-controlpanel-button').css("display","none");
                       }
                       
                       //now exmine this instances header for additional information
                       if(typeof m.config.header != "undefined")
                       {
                          //dynmically check
                          if(typeof m.widget.isDeletable != "undefined" && m.widget.isDeletable(m)){
                              $('#widget-delete-button').css("display","none");
                          }else
                          if(!m.config.header.deletable)
                              $('#widget-delete-button').css("display","none");

                          /*
                          if(!m.config.header.movable)
                              $('#widget-move-button').css("display","none");
                          if(!m.config.header.rotatable)
                              $('#widget-rotate-button').css("display","none");
                          else
                              $('#widget-rotate-button').css({'position':'absolute', 'display':'block','left':cpPos.x-16,'top': (cpPos.y+cpPos.h)-32});
                          */

                          if(!m.config.header.showhelp)
                              $('#widget-help-button').css("display","none");


                          /*
                          if(!m.config.header.scalable)
                              $('#widget-scale-button').css("display","none");
                          else
                              $('#widget-scale-button').css({'position':'absolute', 'display':'block','left':cpPos.x-16,'top': (cpPos.y+cpPos.h)-16});
                          */

                           
                          if(m.config.header.showcp && m.cp != null && typeof m.cp != "undefined")
                          {
                              $(ColabopadApplication.widgetControlPanelFrame).find('div').detach();
                              
                              if(typeof m.config.header.cpstyle == "undefined" || m.config.header.cpstyle=="inline")
                              {
                                  $('#widget-controlpanel-button').css("display","none");
                                  if(m.cp.size)
                                      $(ColabopadApplication.widgetControlPanelFrame).append(m.cp.html).css({'position':'relative', 'display':'block','left':0,'top':0,width:m.cp.size.width,height:m.cp.size.height});
                                  else
                                      $(ColabopadApplication.widgetControlPanelFrame).append(m.cp.html).css({'position':'relative', 'display':'block','left':0,'top':0});
                              }
                              else
                              if(m.config.header.cpstyle=="floating")
                              {
                                  $('#widget-controlpanel-button').css("display","none");
                                  if(m.cp.size)
                                    $(ColabopadApplication.widgetControlPanelFrame).append(m.cp.html).css({'position':'absolute', 'display':'none','left':cpPos.x+18+left_scroll,'top':cpPos.y,width:m.cp.size.width,height:m.cp.size.height});
                                  else
                                    $(ColabopadApplication.widgetControlPanelFrame).append(m.cp.html).css({'position':'absolute', 'display':'none','left':cpPos.x+18+left_scroll,'top':cpPos.y});
                              }
                          }
                          else
                          {
                              $('#widget-controlpanel-button').css("display","none");
                          }
                       }
                       $('#widget-contrl-panel').css({'position':'absolute', 'display':'block','left':cpPos.x,'top':cpPos.y});
                       
                       /*log("show annotation")
                       if(this.pen.mode != "pointer"){
                           this.showAppAnnotationLayer(m,"show");
                       }else{
                           this.showAppAnnotationLayer(m,"hide");
                       }*/
                },
                hideWidgetControlPanel:function(){
                    $('#widget-contrl-panel').css({'display':'none'});
                    $(ColabopadApplication.widgetClassControlPanelFrame).css({'display':'none'});

                    if(!ColabopadApplication.widgetScaleBtn.sticky)
                        $('#widget-scale-button').css("display","none");

                   if(!ColabopadApplication.widgetRotateBtn.sticky)
                        $('#widget-rotate-button').css("display","none");
                },
                onMouseOverWidget:function(){
                    if(ColabopadApplication.moduleMoveBtn.sticky)return;
                    ColabopadApplication.showWidgetControlPanel(ColabopadApplication.getCurrentContext().active_pad,this.widgetInstance);
                },
                onMouseOutWidget:function(){
                    if(ColabopadApplication.moduleMoveBtn.sticky)return;
                    //ColabopadApplication.hideWidgetControlPanel();
                },
                hideSnapHandles:function(page){
                        page.snap_handle_tl.setAttribute("display","none");
                        page.snap_handle_tr.setAttribute("display","none");
                        page.snap_handle_bl.setAttribute("display","none");
                        page.snap_handle_br.setAttribute("display","none");
                },
                showSnapHandles:function(page,m){
                    var v = this.getBoundingBox(this.transformRectangle(m.config.dim, m.config.transforms));

                    page.snap_handle_tl.setAttribute("cx",v.tl.x);
                    page.snap_handle_tl.setAttribute("cy",v.tl.y);

                    page.snap_handle_tr.setAttribute("cx",v.tr.x);
                    page.snap_handle_tr.setAttribute("cy",v.tr.y);

                    page.snap_handle_bl.setAttribute("cx",v.bl.x);
                    page.snap_handle_bl.setAttribute("cy",v.bl.y);

                    page.snap_handle_br.setAttribute("cx",v.br.x);
                    page.snap_handle_br.setAttribute("cy",v.br.y);

                    page.snap_handle_tl.setAttribute("display","block");
                    page.snap_handle_tr.setAttribute("display","block");
                    page.snap_handle_bl.setAttribute("display","block");
                    page.snap_handle_br.setAttribute("display","block");
                },
                trackWidgets:function(p,d,pad){
                       var m = null;
                       if(!this.moduleMoveBtn.sticky){
                           m = this.findWidget(p,pad);

                           //remove focus if necessary
                           if(pad.activeWidgetInstance != null && pad.activeWidgetInstance.hasfocus && ((m != null && m != pad.activeWidgetInstance) || (m == null))){
                                if(typeof pad.activeWidgetInstance.widget.onLossFocus != "undefined")//maybe this should be call in a timer to prevent blocking
                                    pad.activeWidgetInstance.widget.onLossFocus(pad.activeWidgetInstance);
                                pad.activeWidgetInstance.hasfocus=false
                           }
                           
                          //add focus if necessary
                           if(m != null /*&& pad.activeWidgetInstance != null*/ && m != pad.activeWidgetInstance){
                                if(typeof m.widget.onGainFocus != "undefined")//maybe this should be call in a timer to prevent blocking
                                    m.widget.onGainFocus(pad,m);
                                m.hasfocus=true
                           }

 

                           if(m){
                               ColabopadApplication.lastActivatedElement = m.dom;
                               ColabopadApplication.pen.activeElement = m.dom;
                               this.showWidgetControlPanel(pad, m);
                               //this.showSnapHandles(pad,m);
                           }else{
                               this.hideWidgetControlPanel();
                               //this.hideSnapHandles(pad);
                               
                               if(pad.activeWidgetInstance != null && pad.activeWidgetInstance.hasfocus){
                                   /****
                                   if(pad.activeWidgetInstance.widget.onLossFocus != undefined)
                                        pad.activeWidgetInstance.widget.onLossFocus(pad.activeWidgetInstance);
                                   pad.activeWidgetInstance.hasfocus=false;
                                ***/
                               }
                               if(pad.activeWidgetInstance != null){
                                   ColabopadApplication.pen.activeElement = null;
                                   pad.activeWidgetInstance = null;
                               }
                           }
                       }return m;
               },
               setSinkPad:function(pad){
                    for(i=0;i<this.widgets.length;i++){
                        this.widgets[i].setSinkPad(pad);
                    }
               },
               getSinkPad:function(){
                   return ColabopadApplication.getCurrentContext().active_pad;
               },
               pasteClipBoard:function()
               {
                  var element = null;
                  if(this.clipboard != null)
                  {
                     var p = this.alignCoordinates(ColabopadApplication.lastContextMenuPoint,this.getCurrentContext().active_pad);
                     var config = this.clipboard.config;

                     var trslt_delta = {x:(p.x-config.transforms.rotate.cx),y:(p.y-config.transforms.rotate.cy)};
                     var trslt = {x:config.transforms.trslt.x+trslt_delta.x,y:config.transforms.trslt.y+trslt_delta.y};

                     config.transforms.trslt.x = trslt.x;
                     config.transforms.trslt.y = trslt.y;
                     //debug('trslt ('+trslt.x+','+trslt.y+')')

                     var cx = Math.abs(trslt.x+(config.dim.x + config.dim.w/2));
                     var cy = Math.abs(trslt.y+(config.dim.y + config.dim.h/2));
                     config.transforms.rotate.cx = cx;
                     config.transforms.rotate.cy = cy;
                     
                     //debug('rotate ('+this.clipboard.config.dim.x+','+cy+')')
                     
                     
                     switch(config.type){

                        case "line-stroke":
                          {
                            element = this.addLineConfig(config,this.getCurrentContext().active_pad,true);
                            break;
                          }
                        case "circle-stroke":
                          {
                            element = this.addCircleConfig(config,this.getCurrentContext().active_pad,true);
                            break;
                          }
                        case "rec-stroke":
                          {
                            element = this.addRectConfig(config,this.getCurrentContext().active_pad,true);
                            break;
                          }
                        case "image":
                          {
                            element = this.addImageConfig(config,this.getCurrentContext().active_pad,true);
                            break;
                          }
                        case "text":
                          {
                            element = this.addTextConfig(config,this.getCurrentContext().active_pad,true);
                            break;
                          }
                        case "widget":
                          {
                            element = this.addWidgetConfig(config,this.getCurrentContext().active_pad,true);
                            break;
                          }
                     }
                     if(element != null && config.type != "widget"){
                        this.addToUndoStack({element:element,type:"insert"});
                        this.resetRedoStack();
                     }
                     this.clipboard.config = this.Utility.cloneElement(this.clipboard.config);
                  }
               },
               putElementToClipBoard:function(what)
               {
                  if(this.currentClipboardElement != null)
                  {                     
                     //determine if this element is copyable, for instances a chess piece shouldn't be
                     if(typeof this.currentClipboardElement.config.header != "undefined")
                     {
                        if(typeof this.currentClipboardElement.config.header.copy != "undefined")
                            if(!this.currentClipboardElement.config.header.copy)return;
                     }

                      this.clipboard = {action:what,config:this.Utility.cloneElement(this.currentClipboardElement.config)};
                  
                      if(what == 'cut')//add to undo stack
                      {
                         if(this.clipboard.config.type != "widget"){
                             ColabopadApplication.pen.erase(this.getCurrentContext().active_pad,this.currentClipboardElement,"call from putElementToClipBoard");
                             ColabopadApplication.removeUndoNode(this.currentClipboardElement.getAttribute('id'));
                             ColabopadApplication.addToUndoStack({element:{config:this.currentClipboardElement.config,dom:this.currentClipboardElement},type:"delete"});
                             ColabopadApplication.resetRedoStack();
                           }
                      }
                      this.currentClipboardElement = null;
                  }
               },
               onKeyPress:function(){
                alert('key1')
               },
               onMousedownElement:function(p){
                   
                   var pad = ColabopadApplication.getCurrentContext().active_pad;
                   ColabopadApplication.hideWidgetControlPanel();
                   if( (ColabopadApplication.pen.mode == 'move' || ColabopadApplication.pen.mode == 'pointer') && ColabopadApplication.pen.activeElement != null)
                   {
                       ColabopadApplication.pen.activeElement.mousedrop_pt = ColabopadApplication.alignCoordinates(p,pad);
                       ColabopadApplication.pen.activeElement.accum_trslt  = {x:0,y:0};
                       ColabopadApplication.pen.activeElement.undoNode =  {element:this.element,
                        type:"transform",
                        transforms:ColabopadApplication.Utility.cloneTransformationObject(this.element.config.transforms)
                       };
                   }
                   else
                   if(ColabopadApplication.pen.mode == 'rotate'  && ColabopadApplication.pen.activeElement != null){
                       ColabopadApplication.pen.rotateElement = ColabopadApplication.pen.activeElement;
                       ColabopadApplication.pen.rotateElement.mousedrop_pt = ColabopadApplication.alignCoordinates(p,pad);
                       ColabopadApplication.pen.rotateElement.accum_rotate = {angle:0};
                       ColabopadApplication.pen.rotateElement.undoNode =  {element:this.element,
                        type:"transform",
                        transforms:ColabopadApplication.Utility.cloneTransformationObject(this.element.config.transforms)
                       };
                   }
                   else
                   if(ColabopadApplication.pen.mode == 'resize' && ColabopadApplication.pen.activeElement != null){
                       ColabopadApplication.pen.activeElement = ColabopadApplication.pen.activeElement;
                       ColabopadApplication.pen.activeElement.mousedrop_pt = ColabopadApplication.alignCoordinates(p,pad);
                       ColabopadApplication.pen.activeElement.accum_rotate = {angle:0};
                       ColabopadApplication.pen.activeElement.undoNode =  {element:this.element,
                        type:"transform",
                        transforms:ColabopadApplication.Utility.cloneTransformationObject(this.element.config.transforms)
                       };
                   }
              },
              onMouseupElement:function(p){
                   var pad = ColabopadApplication.getCurrentContext().active_pad;

                   if(ColabopadApplication.pen.mode == 'move' || ColabopadApplication.pen.mode == 'pointer')
                   {
                       //ColabopadApplication.pen.activeElement.config.transforms.trslt = ColabopadApplication.pen.activeElement.trslt;
                   }
                   else
                   if(ColabopadApplication.pen.mode == 'rotate'){
                       //ColabopadApplication.pen.rotateElement.config.transforms.rotate.angle = ColabopadApplication.pen.rotateElement.rotate.angle;
                       //ColabopadApplication.pen.rotateElement = null;
                   }
              },
              onMouseoverElement:function(){
                  var pad = ColabopadApplication.getCurrentContext().active_pad;
                  
                  if(ColabopadApplication.pen.mode == 'eraser'){
                       if(typeof this.config.header != "undefined" &&
                          typeof this.config.header.deletable != "undefined" &&
                          !this.config.header.deletable)
                          return;
                          
                       if(ColabopadApplication.pen.down){
                           ColabopadApplication.pen.erase(pad,this);
                           ColabopadApplication.removeUndoNode(this.getAttribute('id'));
                           ColabopadApplication.addToUndoStack({element:{config:this.config,dom:this},type:"delete"});
                           ColabopadApplication.resetRedoStack();
                       }else{
                           /*if(this.config.type=='image'){
                              this.setAttribute("stroke","blue");
                           }*/
                           pad.svg_doc.change(this, {'stroke-width':this.config.pen.width+2});
                       }
                  }
                  else
                  if((ColabopadApplication.pen.mode == 'move' || ColabopadApplication.pen.mode == 'rotate' || ColabopadApplication.pen.mode == 'pointer' || ColabopadApplication.pen.mode == 'fill' || ColabopadApplication.pen.mode == 'resize') && this.config.type != 'stroke')
                  {
                     pad.svg_doc.change(this, {'stroke-width':this.config.pen.width+2});
                  }
                  if(typeof this.config != "undefined" && this.config.type != 'stroke' && !ColabopadApplication.pen.down){
                    ColabopadApplication.pen.activeElement = this;
                    ColabopadApplication.lastActivatedElement = this;
                  }
              },
              onMouseoutElement:function(){
                  var pad = ColabopadApplication.getCurrentContext().active_pad;
                  if(ColabopadApplication.pen.mode == 'eraser'){
                      pad.svg_doc.change(this, {'stroke-width':this.config.pen.width});
                  }
                  else
                  if(ColabopadApplication.pen.mode == 'move' || ColabopadApplication.pen.mode == 'rotate' || ColabopadApplication.pen.mode == 'pointer' || ColabopadApplication.pen.mode == 'fill' || ColabopadApplication.pen.mode == 'resize'){
                      if(this.config.type != 'stroke')
                        pad.svg_doc.change(this, {'stroke-width':this.config.pen.width});
                  }
                  if(!ColabopadApplication.pen.down){
                      ColabopadApplication.pen.activeElement = null;
                      ColabopadApplication.pen.rotateElement = null;
                  }
              },
              debugRemove:function(pad,ele,callfrom){
                   //debug('remove..'+callfrom)
                   try{
                       if(ele == null || ele.parentNode == null){
                           //alert('An unexpected error occured, cannot delete null object. Call from:'+callfrom)
                       }else{
                            //debug('remove..')

                       }
                       pad.svg_doc.remove(ele);
                   }catch(Error){
                       log('error deleting element. exception:'+Error+' callfrom:'+callfrom);
                   }
               },
               getCurrentPadConfig:function(){
                    var config = {title:'',template:this.getCurrentContext().active_pad.template,elements:[]};
                    for(var i=0;i<this.current_context.active_pad.elements.length;i++){
                        config.elements.push(this.current_context.active_pad.elements[i].config);
                    }return config;
               },
               getCurrentContextConfig:function(){

               },
               addContext:function(context){
                   this.current_participant_context.context_list.push(context);
               },
               getCurrentContext:function(){
                   return this.current_participant_context.current_context;
               },
               setCurrentContext:function(context){
                   this.current_participant_context.current_context = context;
               },
               setCurrentParticipantContext:function(participant_context){
                 this.current_participant_context  = participant_context;
               },
               getCurrentParticipantContext:function(){
                 return this.current_participant_context;
               },
               resetContext:function(){
                   for(var i=0;i<this.participant_context_list.length;i++){
                       var participant_context = this.participant_context_list[i];
                       if(participant_context.id==user_id){
			   this.current_participant_context  = participant_context;
                           for(var j=0;j<participant_context.context_list.length;j++){
                                   var cntx = participant_context.context_list[j];
                                   if(cntx.pages.length>0){
                                       this.current_participant_context.current_context = cntx;
				       cntx.active_pad = cntx.pages[0];
				       return;
                                   }
                            }
                            break;
                       }
                   }
               },
               getPageTemplate:function(name){
                   for(var i=0;i<this.page_templates.length;i++){
                       if(this.page_templates[i].name==name){
                           return this.page_templates[i];
                       }
                   }return '';
               },
               removeContext:function(pid,context_id){

                   for(var i=0;i<this.participant_context_list.length;i++){
                       var participant_context = this.participant_context_list[i];
                       if(participant_context.id==pid){

                           for(var j=0;j<participant_context.context_list.length;j++){
                                   var cntx = participant_context.context_list[j];
                                   if(cntx.id==context_id){
                                       participant_context.context_list.splice(j,1);
                                       return cntx;
                                   }
                            }
                            return null;
                       }
                   }
                   return null;
               },
               getRootOffLineContext:function(rid){
                   for(var i=0;i<this.offline_root_context_list.length;i++){
                       var context = this.offline_root_context_list[i];
                       if(context.id==rid){
                            return context;
                       }
                   }return null;
               },
               getOffLineContext:function(rid,context_id){
                   var offline_root_context = this.getRootOffLineContext(rid);

                   for(var j=0;j<offline_root_context.context_list.length;j++){
                           var cntx = offline_root_context.context_list[j];
                           if(cntx.id==context_id){
                               return cntx;
                           }
                    }return null;
               },
               getOfflineContextPage:function(rid,context_id,pad_id){
                   var offline_context = this.getOffLineContext(rid, context_id);
                   for(var k=0;k<offline_context.pages.length;k++){
                       if(offline_context.pages[k].id == pad_id){
                            return offline_context.pages[k];
                       }
                   }return null;
               },
               getParticipantContext:function(pid){
                   for(var i=0;i<this.participant_context_list.length;i++){
                       var participant_context = this.participant_context_list[i];
                       if(participant_context.id==pid){
                            return participant_context;
                       }
                   }
                   return null;
               },
               getContext:function(pid,context_id){
                   for(var i=0;i<this.participant_context_list.length;i++){
                       var participant_context = this.participant_context_list[i];
                       if(participant_context.id==pid){

                           for(var j=0;j<participant_context.context_list.length;j++){
                                   var cntx = participant_context.context_list[j];
                                   if(cntx.id==context_id){
                                       return cntx;
                                   }
                            }
                            break;
                       }
                   }
                   return null;
               },
               getContextByTabId:function(tabid){
                   for(var i=0;i<this.participant_context_list.length;i++){
                       var participant_context = this.participant_context_list[i];
                       for(var j=0;j<participant_context.context_list.length;j++){
                               var cntx = participant_context.context_list[j];
                               if(cntx.tabid==tabid){
                                   return cntx;
                               }
                       }
                   }return null;
               },
               getParticipantContextByTabId:function(tabid){
                   for(var i=0;i<this.participant_context_list.length;i++){
                       var participant_context = this.participant_context_list[i];
                       if(participant_context.tabid==tabid)return participant_context;
                   }return null;
               },
               getContextPage:function(pid,context_id,pad_id){
                   for(var i=0;i<this.participant_context_list.length;i++){
                       var participant_context = this.participant_context_list[i];
                       if(participant_context.id==pid){
                           
                           for(var j=0;j<participant_context.context_list.length;j++){
                                   var cntx = participant_context.context_list[j];
                                   if(cntx.id==context_id){
                                       
                                       for(var k=0;k<cntx.pages.length;k++){
                                           if(cntx.pages[k].id == pad_id){                                               
                                                return cntx.pages[k];
                                           }
                                       }
                                       break;
                                   }
                            }                            
                            break;
                       }
                   }
                   return null;
               },
               loadElements:function(reply,page){
                    //first determine number of widgets that need to be laoded, so we can tell
                    //when page is fully loaded
                    for(var k=0;k<reply.length;k++){
                        if(reply[k].config.type == "widget")
                            page.widget_ref_count++;
                    }

                    for(k=0;k<reply.length;k++){
                        reply[k].config.dbid = parseInt(reply[k].id);
                        //log('el id:'+reply[k].config.dbid)
                        reply[k].dom = null;
                        ColabopadApplication.insertContentElement(page,/*{id:reply[k].config.dbid,config:reply[k].config,access:reply[k].access,dom:null}*/reply[k],false);
                    }
                    page.loading = false;

                    if(page.widget_ref_count == 0)
                        page.visibly_loaded = true;

                    //debug("visibly_loaded:"+page.visibly_loaded+' cb_invoked:'+page.cb_invoked)
                    if(page.visibly_loaded && !page.cb_invoked){
                        page.cb_invoked = true;
                        ColabopadApplication.invokePageLoadCallBacks(page,"loadPageContent");
                    }

                    if(page.elements.length>0)
                        page.last_insert = page.elements[page.elements.length-1].config.dbid;
                    else
                        page.last_insert = 0;

                    page.loaded_from_db = true;


                    //connect to message queue for this page
                    if(page.queue_url){
                        //debug('joining page queue')
                        var listener = {
                                        id:'listener-'+ColabopadApplication.room.id+'-'+page.context.pid+'-'+page.id,
                                        destination:page.queue_url,
                                        rcvMessage:ColabopadApplication.receivePageMsg
                                        };
                        ColabopadApplication.MsgHandler.registerListener(listener);
                    }
                    //propagate to queue

                    if(page.context.queue_url && ColabopadApplication.nav_msg_queue.length==0){
                        //debug('sending nav-to-page message')
                        ColabopadApplication.MsgHandler.sendMessage({to:page.context.queue_url,message:{header:{type:"nav-to-page",src_session:sessionId,pid:page.context.pid,cntx_id:page.context.id,page_id:page.id}}});
                    }
                    ColabopadApplication.nav_msg_queue.pop();                   
               },
               loadPageContent:function(page){                  
                   
                   //load elements from database                   
                   page.widget_instances = [];//reset this
                   page.visibly_loaded   = false;
                   page.loading          = true;
                   page.cb_invoked       = false;
                   page.widget_ref_count = 0;


                   if(page.loaded_from_db){
                        //first determine number of widgets that need to be laoded, so we can tell
                        //when page is fully loaded
                        for(var i=0;i<page.elements.length;i++){
                            if(page.elements[i].config.type == "widget")
                                page.widget_ref_count++;
                        }
                        
                        for(i=0;i<page.elements.length;i++){
                            ColabopadApplication.insertContentElement(page,page.elements[i],false,true);
                            
                        }
                        
                        page.loading = false;
                        
                        if(page.widget_ref_count == 0)
                            page.visibly_loaded = true;

                        if(page.visibly_loaded && !page.cb_invoked){
                            page.cb_invoked = true;
                            ColabopadApplication.invokePageLoadCallBacks(page,"loadPageContent reload");
                        }

                        if(typeof page.clientside!="undefined" && page.clientside)return;

                        //propagate to queue
                        if(page.context.queue_url && ColabopadApplication.nav_msg_queue.length==0){
                            //debug('sending nav-to-page message')
                            ColabopadApplication.MsgHandler.sendMessage({to:page.context.queue_url,message:{header:{type:"nav-to-page",src_session:sessionId,pid:page.context.pid,cntx_id:page.context.id,page_id:page.id}}});
                        }
                        ColabopadApplication.nav_msg_queue.pop();
                   }else{

                        if(typeof phyzixlabs_database == "undefined"){
                            $.ajax({
                                type:'POST',
                                data:{room_id:room_id,grantor:page.context.pid,context_id:page.context.id,pad_id:page.id},
                                url:'/ElementAction.do?action=get-elements',
                                success:function(data){
                                    var reply = eval('('+data+')');
                                    ColabopadApplication.loadElements(reply,page);
                                }
                            });
                        }else{
                            
                                ColabopadApplication.loadElements(phyzixlabs_database.getElements(page),page);                             
                            
                        }
                   }
               },
               unloadPage:function(page){
                   try{
                        if(page.div_dom == null)return;

                       //if(page.template.name == 'text-editor'){
                       //    page.texteditor.ckeditor.destroy();
                       //    log('destroyed text editor instance')
                       //}

                       //cleanup applets
                       if(typeof(dont_notify) == "undefined"){
                            for(var i=0;i<page.widget_instances.length;i++){
                                var m = page.widget_instances[i];

                                if(typeof(m.widget.onClosePad) != "undefined"){
                                  m.widget.onClosePad(page,m);
                                }
                            }
                       }
                       page.svg_doc.clear();
                       page.div_dom.remove();
                       page.div_dom=null;
                       /******PERFORMANCE ENHANCERS FOR LATER USE
                       page.loaded_from_db = false;
                       page.elements = [];
                       page.widget_instances = [];
                       ***/
                       page.loaded = false;
                   }catch(Error){

                   }
               },
               hidePartCntx:function(id){

                   var part_cntx = this.getParticipantContext(id);
                   //if this tab is visible quickly move the toolbar to a different parent so it doesn't get destroyed along with this tab
                   if(ColabopadApplication.selectedParticipantCntx == part_cntx.tabindex){
                       //$('#toolbar-hider').append(ColabopadApplication.editor_toolbar);
                   }

                   for(var i=0;i<part_cntx.context_list.length;i++){
                       var cntx = part_cntx.context_list[i];
                       cntx.tab=null;

                       for(var j=0;j<cntx.pages.length;j++){
                           var page = cntx.pages[j];
                           this.unloadPage(page);
                           page.loaded_from_db = false;
                           page.elements=[];

                           //remove message queue handler for this page if it has been activated
                           var listenerId  = 'listener-'+ColabopadApplication.room.id+'-'+page.context.pid+'-'+page.id;
                           ColabopadApplication.MsgHandler.unregisterListener(listenerId);
                       }
                   }
                   $('#participant-tabcontrol').tabs('remove',part_cntx.tabindex);
                   part_cntx.tab = null;
               },
               initParticipantContextTab:function(partCntx){
                   var tabid = 'participant-tab-'+partCntx.id;
                   var participant = this.getItemById(partCntx.id,this.room.participants);
                   var title = '<span style="float:left" class="ui-icon ui-icon-person"></span>'+participant.name;


                   var delbnt   = '';//partCntx.id==ColabopadApplication.user_id?'':' <input type="image" src="images/misc/x-tab.png" onclick="ColabopadApplication.hidePartCntx('+partCntx.id+')"/>';

                   $('#participant-tabcontrol-tabs').append('<div id="'+tabid+'"><div id="toolbar-holder-'+partCntx.id+'"></div>  </div>');
                   partCntx.tabid = tabid;
                   partCntx.tabindex = parseInt($('#participant-tabcontrol').tabs('length'));
                   partCntx.tab = $('#participant-tabcontrol').tabs('add','#'+tabid,title+delbnt);

                   $('a[href=#'+tabid+']').next().click(function(){
                       ColabopadApplication.hidePartCntx(partCntx.id);
                   });

                   $('#'+tabid).css({"padding":"0px"})
                   $('#'+tabid).append('<div id="context-tabcontrol'+partCntx.id+'" ><ul id="context-tabcontrol-headers'+partCntx.id+'"></ul> <div id="context-tabcontrol-tabs'+partCntx.id+'"></div></div>');

                   $('#participant-tabcontrol-tabs').removeClass("ui-corner-all ui-corner-bottom").addClass("ui-corner-top");

                   $('#context-tabcontrol'+partCntx.id).tabs({
                       tabTemplate:'<li><a href="#{href}">#{label}</a><span class="ui-icon ui-icon-close" style="float:left;margin: 0.4em 0.2em 0 0; cursor: pointer">Remove Tab</span></li>',
                       show:ColabopadApplication.onShowContextTab,
                       //collapsible: true,
                       create:function(event,ui){                          
                           
                           $('#context-tabcontrol'+partCntx.id).css({"border-style":"none"})
                       },
                       activate:function(event,ui){
                           //alert("created:"+ui.newTab.binderContext);
                           //alert("created:"+$(ui.newTab).data("binderContext"));
                           //$("#tab-content-holder").append($(ui.newTab).data("binderContext").dock);
                       }
                   }).removeClass("ui-corner-all").addClass("ui-corner-top");

                    //select new tab
                    if(parseInt(partCntx.tab.tabs('length'))>1){
                        partCntx.selected = false;
                        $('#participant-tabcontrol').tabs('select','#'+partCntx.tabid);
                    }
               },
               hideCntx:function(pid,id){
                   var cntx = this.getContext(pid, id);
                   //if this tab is visible quickly move the toolbar to a different parent so it doesn't get destroyed along with this tab
                   if(ColabopadApplication.selectedCntx == cntx.tabindex){
                       //$('#toolbar-hider').append(ColabopadApplication.editor_toolbar);
                   }

                   for(var i=0;i<cntx.pages.length;i++){
                       var page = cntx.pages[i];
                       this.unloadPage(page);
                       page.loaded_from_db = false;
                       page.elements=[];

                       //remove message queue handler for this page if it has been activated
                       var listenerId  = 'listener-'+ColabopadApplication.room.id+'-'+page.context.pid+'-'+page.id;
                       ColabopadApplication.MsgHandler.unregisterListener(listenerId);
                   }

                   $('#context-tabcontrol'+pid).tabs('remove',cntx.tabindex);
                   cntx.tab=null;
                   cntx.tabindex = -1;
                   if($('#context-tabcontrol'+pid).tabs('length') == 0){
                       this.hidePartCntx(pid);
                   }
               },
               initContextTab:function(cntx){  
                   var cntx_tabid = 'context-tab'+cntx.pid+'-'+cntx.id;
                   cntx.tabid =  cntx_tabid;
                   
                   $('#context-tabcontrol-tabs'+cntx.pid).append('<div id="'+cntx_tabid+'" style="padding:0px;"><div id="tb-'+cntx_tabid+'"></div></div>');

                   //create div for svg pad
                   $('#'+cntx_tabid).append('<div id="context-page-dock'+cntx.pid+'-'+cntx.id+'"></div>');

                   
                   cntx.dock = !this.page_screen_mode?$('#context-page-dock'+cntx.pid+'-'+cntx.id):$("#application-page-screen");
                   cntx.dock.addClass("dock");
                   var delCode = 'ColabopadApplication.hideCntx('+cntx.pid+','+cntx.id+')';
                   
                   if(typeof cntx.isCatalog!="undefined" && cntx.isCatalog)
                       delCode = 'ColabopadApplication.hideCatalog('+cntx.rid+','+cntx.id+')';
                   else
                   if(typeof cntx.isMyCatalog!="undefined"&&cntx.isMyCatalog)
                       delCode = 'ColabopadApplication.hideMyCatalog('+cntx.rid+','+cntx.id+')';
                   else
                   if(typeof cntx.isCart!="undefined"&&cntx.isCart)
                       delCode = 'ColabopadApplication.hideCart('+cntx.rid+','+cntx.id+')';
               

                   var delbtn_style   = parseInt($('#context-tabcontrol'+cntx.pid).tabs('length'))>0?'':'display:none';
                   var delbtn = '';// '<input type="image" style="'+delbtn_style+'" src="images/misc/x-tab.png" onclick="'+delCode+'"/>';

                   cntx.tabindex = parseInt($('#context-tabcontrol'+cntx.pid).tabs('length'));
                   
                   
                   var tabMarkup = '<li id="tab-obj-'+cntx_tabid+'"><a href="#'+cntx_tabid+'"><span style="float:left;" class="ui-icon ui-icon-folder-open"></span>'+cntx.title+delbtn+'</a><span class="ui-icon ui-icon-close" style="float:left;margin: 0.4em 0.2em 0 0; cursor: pointer">Remove Tab</span></li>';
                   $(tabMarkup).appendTo('#context-tabcontrol'+cntx.pid+' .ui-tabs-nav');
                   //var addedTab = $("#tab-obj-"+cntx_tabid);
                   $("#tab-obj-"+cntx_tabid).data("binderContext",cntx);
                   //addedTab.binderContext = cntx;
                   
                   cntx.tab = $('#context-tabcontrol'+cntx.pid);
                   $('#context-tabcontrol'+cntx.pid).tabs("refresh");
                   
                   
                   //cntx.tab = $('#context-tabcontrol'+cntx.pid).tabs('add','#'+cntx_tabid,'<span style="float:left" class="ui-icon ui-icon-folder-open"></span>'+cntx.title+delbtn);
                   
                   
                   $('a[href=#'+cntx_tabid+']').next().click(function(){
                       ColabopadApplication.hideCntx(cntx.pid,cntx.id);
                   });
                   
                   //alert(parseInt(cntx.tab.tabs('length')))
                   //switch to new tab
                   if(/*parseInt(cntx.tab.tabs('length'))>1*/true){
                        cntx.selected = false;
                        //$('#context-tabcontrol'+cntx.pid).tabs('select','#'+cntx_tabid);
                        
                        $('#context-tabcontrol'+cntx.pid).tabs('option', 'active',parseInt(cntx.tab.tabs('length'))-1);
                   }
               },
               _setUpViewImpl:function(part_cntx,cntx,page,how){
                  if(how=="page-click"){
                      if(page != null && typeof page.clicked!="undefined" && !page.clicked){
                          page.clicked = true;
                          return;
                      }
                  }

                  //unload current page if necessary
                  if(this.getCurrentParticipantContext()!=null){
                       if(this.getCurrentContext() != null){
                           this.unloadPage(this.getCurrentContext().active_pad);
                       }
                  }

                  if(how=="page-click"){
                      
                      //create participant tab if necessary
                      if(part_cntx.tab==null){
                          part_cntx.selected = false;//prevents a recursive call to this function
                          this.initParticipantContextTab(part_cntx);
                      }
                      else //switch participant tabs if necessary
                      if(this.getCurrentParticipantContext() != null && part_cntx != this.getCurrentParticipantContext()){
                         part_cntx.selected = false;//prevents a recursive call to this function
                         $('#participant-tabcontrol').tabs('select','#'+part_cntx.tabid);
                      }

                      //create this context tab if necessary
                      if(cntx != null && cntx.tab==null){
                          cntx.selected=false;//prevents a recursive call to this function
                          this.initContextTab(cntx);
                      }
                      else
                      if(this.getCurrentContext() != null && this.getCurrentContext() != cntx){
                          cntx.selected=false;//prevent recursive call to this function
                          $('#context-tabcontrol'+cntx.pid).tabs('select','#'+cntx.tabid);
                      }

                      this.setCurrentParticipantContext(part_cntx);
                      this.setCurrentContext(cntx);

                      //initialize the page that was click
                      this.initPage(page,this.loadPageContent);
                  }
                  else
                  if(how=="context-tab-clicked"){
                      this.setCurrentContext(cntx);

                      //initialize the page if necessary
                      if(cntx.active_pad != null){

                          this.initPage(cntx.active_pad,this.loadPageContent);
                          //alert('tabed')
                          cntx.active_pad.clicked=false;
                          var key = 'key-'+cntx.pid+'-'+cntx.id+'-'+cntx.active_pad.id;
                          $("#participant-treecontrol").dynatree('getTree').activateKey(key) ;
                      }
                  }
                  else
                  if(how=="participant-context-tab-clicked"){
                      this.setCurrentParticipantContext(part_cntx);
                      //this.setCurrentContext(cntx);

                      //initialize the page if necessary
                      if(cntx!=null&&cntx.active_pad != null){
                          this.initPage(cntx.active_pad,this.loadPageContent);

                          cntx.active_pad.clicked=false;
                          key = 'key-'+cntx.pid+'-'+cntx.id+'-'+cntx.active_pad.id;
                          $("#participant-treecontrol").dynatree('getTree').activateKey(key) ;
                      }
                  }
               },
               setUpOfflineView:function(rid,cntx_id,pad_id,how){
                  //locate page
                  var part_cntx    = this.getParticipantContext(this.user_id);
                  var cntx         = this.getOffLineContext(rid, cntx_id);
                  var page         = this.getOfflineContextPage(rid,cntx_id, pad_id);
                  
                  this._setUpViewImpl(part_cntx, cntx, page, how);
               },
               setUpView:function(pid,context_id,pad_id,how){
                  
                  //locate page
                  var part_cntx    = this.getParticipantContext(pid);
                  var cntx         = this.getContext(pid,context_id);
                  var page         = this.getContextPage(pid,context_id, pad_id);


                  if(how=="page-click"){
                      if(page != null && typeof page.clicked!="undefined" && !page.clicked){
                          page.clicked = true;
                          return;
                      }
                  }
                  

                  //unload current page if necessary
                  if(this.getCurrentParticipantContext()!=null){
                       if(this.getCurrentContext() != null){
                           this.unloadPage(this.getCurrentContext().active_pad);
                       }
                  }

                  if(how=="page-click"){
                      
                      //create participant tab if necessary
                      if(part_cntx.tab==null){
                          part_cntx.selected = false;//prevents a recursive call to this function
                          this.initParticipantContextTab(part_cntx);
                      }
                      else //switch participant tabs if necessary
                      if( (this.getCurrentParticipantContext() != null && part_cntx != this.getCurrentParticipantContext()) || (part_cntx.tabid != this.active_top_tab_id)){
                         part_cntx.selected = false;//prevents a recursive call to this function
                         $('#participant-tabcontrol').tabs('select','#'+part_cntx.tabid);
                      }                      
                      
                      //create this context tab if necessary
                      if(cntx != null && cntx.tab==null){
                          
                          cntx.selected=false;//prevents a recursive call to this function
                          this.initContextTab(cntx);
                      }
                      else
                      if(this.getCurrentContext() != null && this.getCurrentContext() != cntx){
                          cntx.selected=false;//prevent recursive call to this function                          
                          $('#context-tabcontrol'+cntx.pid).tabs('select','#'+cntx.tabid);                          
                      }

                      
                      this.setCurrentParticipantContext(part_cntx);
                      this.setCurrentContext(cntx);

                      //initialize the page that was click
                      this.initPage(page,this.loadPageContent);                      
                  }
                  else
                  if(how=="context-tab-clicked"){
                      this.setCurrentContext(cntx);                      
                      
                      //initialize the page if necessary
                      if(cntx.active_pad != null){
                          
                          this.initPage(cntx.active_pad,this.loadPageContent);
                          //alert('tabed')
                          cntx.active_pad.clicked=false;
                          var key = 'key-'+cntx.pid+'-'+cntx.id+'-'+cntx.active_pad.id;
                          $("#participant-treecontrol").dynatree('getTree').activateKey(key) ;
                      }
                  }
                  else
                  if(how=="participant-context-tab-clicked"){
                      this.setCurrentParticipantContext(part_cntx);
                      //this.setCurrentContext(cntx);

                      //initialize the page if necessary
                      if(cntx!=null&&cntx.active_pad != null){
                          this.initPage(cntx.active_pad,this.loadPageContent);
                          
                          cntx.active_pad.clicked=false;
                          key = 'key-'+cntx.pid+'-'+cntx.id+'-'+cntx.active_pad.id;
                          $("#participant-treecontrol").dynatree('getTree').activateKey(key) ;
                      }
                  }
               },
               updateGlobalAccess:function(){                   
                   var context_list = this.getParticipantContext(ColabopadApplication.user_id).context_list;
                   for(var i=0;i<context_list.length;i++){
                       var cntx = context_list[i];
                       cntx.access[this.GLOBAL_ACL_INDEX] = cntx.access[this.ACL_EDIT_INDEX];

                       this.updateContext(cntx, {title:cntx.title,queue_url:cntx.queue_url});
                       for(var j=0;j<cntx.pages.length;j++){
                           var page = cntx.pages[j];
                           page.access[this.GLOBAL_ACL_INDEX] = page.access[this.ACL_EDIT_INDEX];
                           
                           this.updatePad(page, {header:page.header,title:page.title,template:page.template.name,queue_url:page.queue_url});
                           for(var k=0;k<page.elements.length;k++){
                               var element = page.elements[j];
                               element.access[this.GLOBAL_ACL_INDEX] = element.access[this.ACL_EDIT_INDEX];
                               this.updateElement(page,element);
                           }
                       }
                   }
               },
               updateUserAccess:function(granted_to){
                    var context_list = this.getParticipantContext(ColabopadApplication.user_id).context_list;

                    for(var i=0;i<context_list.length;i++){
                       var cntx = context_list[i];
                       if(granted_to == 0) cntx.access[this.GLOBAL_ACL_INDEX] = cntx.access[this.ACL_EDIT_INDEX];
                       
                       this.updateContextAccess(cntx, granted_to);
                       for(var j=0;j<cntx.pages.length;j++){
                           var page = cntx.pages[j];
                           if(granted_to == 0) page.access[this.GLOBAL_ACL_INDEX] = page.access[this.ACL_EDIT_INDEX];

                           this.updatePadAccess(page, granted_to);
                           for(var k=0;k<page.elements.length;k++){
                               var element = page.elements[k];
                               if(granted_to == 0) element.access[this.GLOBAL_ACL_INDEX] = element.access[this.ACL_EDIT_INDEX];

                               this.updateElementAccess(page,element, granted_to);
                           }
                       }
                    }
               },
               setUserAccessControls:function(pid,context_id,which,global,set,page_id){
                    var cntx = this.getContext(pid,context_id);
                    if(which=='create'){
                        if(set)
                            cntx.access[ColabopadApplication.access_index]  |= ColabopadApplication.ACCESS_MODE.CREATE;
                        else
                            cntx.access[ColabopadApplication.access_index]  &= ~ColabopadApplication.ACCESS_MODE.CREATE;
                    }
                    else
                    if(which == 'delete'){
                        if(set)
                            cntx.access[ColabopadApplication.access_index]  |= ColabopadApplication.ACCESS_MODE.DELETE;
                        else
                            cntx.access[ColabopadApplication.access_index]  &= ~ColabopadApplication.ACCESS_MODE.DELETE;
                    }
                    else
                    if(global){

                        if(which == 'read'){

                            if(set){
                                $('.user-context-page-read-acl').attr('checked',true).attr('disabled','disabled');
                                cntx.access[ColabopadApplication.access_index]  |= ColabopadApplication.ACCESS_MODE.READ;
                            }
                            else{
                                cntx.access[ColabopadApplication.access_index]  &= ~ColabopadApplication.ACCESS_MODE.READ;

                                $('.user-context-page-read-acl').attr('checked',false).removeAttr('disabled');
                                 //restore existing page level access
                                 for(var i=0;i<cntx.pages.length;i++){
                                    $('#user-context-page-read-acl'+cntx.pages[i].id).attr('checked', (cntx.pages[i].access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.READ)>0 );
                                 }
                            }
                        }else
                        if(which == 'write'){

                            if(set){
                                $('.user-context-page-write-acl').attr('checked',true).attr('disabled','disabled');
                                cntx.access[ColabopadApplication.access_index]  |= ColabopadApplication.ACCESS_MODE.WRITE;
                            }
                            else{
                                cntx.access[ColabopadApplication.access_index]  &= ~ColabopadApplication.ACCESS_MODE.WRITE;
                                $('.user-context-page-write-acl').attr('checked',false).removeAttr('disabled');
                                 //restore existing access
                                 
                                 for(i=0;i<cntx.pages.length;i++){
                                    $('#user-context-page-write-acl'+cntx.pages[i].id).attr('checked',(cntx.pages[i].access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.WRITE)>0);
                                 }
                            }
                        }else
                        if(which == 'embed'){

                            if(set){
                                $('.user-context-page-embed-acl').attr('checked',true).attr('disabled','disabled');
                                cntx.access[ColabopadApplication.access_index]  |= ColabopadApplication.ACCESS_MODE.EMBED;
                            }
                            else{
                                cntx.access[ColabopadApplication.access_index]  &= ~ColabopadApplication.ACCESS_MODE.EMBED;
                                $('.user-context-page-embed-acl').attr('checked',false).removeAttr('disabled');
                                 //restore existing access

                                 for(i=0;i<cntx.pages.length;i++){
                                    $('#user-context-page-embed-acl'+cntx.pages[i].id).attr('checked',(cntx.pages[i].access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.EMBED)>0);
                                 }
                            }
                        }
                    }else{
                        var page = ColabopadApplication.getItemById(page_id, cntx.pages);
                        if(which == 'read'){
                            //alert('check')
                            if(set)
                                page.access[ColabopadApplication.access_index]  |= ColabopadApplication.ACCESS_MODE.READ;
                            else
                                page.access[ColabopadApplication.access_index]  &= ~ColabopadApplication.ACCESS_MODE.READ;
                        }else
                        if(which == 'write'){
                            if(set)
                                page.access[ColabopadApplication.access_index]  |= ColabopadApplication.ACCESS_MODE.WRITE;
                            else
                                page.access[ColabopadApplication.access_index]  &= ~ColabopadApplication.ACCESS_MODE.WRITE;
                        }else
                        if(which == 'embed'){
                            if(set)
                                page.access[ColabopadApplication.access_index]  |= ColabopadApplication.ACCESS_MODE.EMBED;
                            else
                                page.access[ColabopadApplication.access_index]  &= ~ColabopadApplication.ACCESS_MODE.EMBED;
                        }
                    }return true;
               },
               onLoadContextPageAccessList:function(context_id){

                    $("#page-access-control-list").clearGridData();
                    
                    var pid =  ColabopadApplication.user_id;//ColabopadApplication.getCurrentParticipantContext().id;
                    var cntx = ColabopadApplication.getContext(pid,context_id);
                    var readcheck   = "";
                    var writecheck  = "";
                    var createcheck = "";
                    var deletecheck = "";
                    var embedcheck  = "";



                    //these are global settings for all pages
                    if( (cntx.access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.READ)>0)
                        readcheck = "checked";

                    if( (cntx.access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.WRITE)>0)
                        writecheck = "checked";


                    if( (cntx.access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.CREATE)>0)
                        createcheck = "checked";

                    if( (cntx.access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.DELETE)>0)
                        deletecheck = "checked";

                    if( (cntx.access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.EMBED)>0)
                        embedcheck = "checked";



                    var row = {
                        title:'<span style="font-weight:bold"></span>',
                        read:'<input type="checkbox" onchange="ColabopadApplication.setUserAccessControls('+pid+','+context_id+',\'read\',true,$(this).attr(\'checked\'))" '+readcheck+'/>',
                        write:'<input type="checkbox" onchange="ColabopadApplication.setUserAccessControls('+pid+','+context_id+',\'write\',true,$(this).attr(\'checked\'))" '+writecheck+'/>',
                        create:'',
                        del:'',
                        embed:'<input type="checkbox" onchange="ColabopadApplication.setUserAccessControls('+pid+','+context_id+',\'embed\',true,$(this).attr(\'checked\'))" '+embedcheck+'/>'
                    }
                    $("#page-access-control-list").addRowData(cntx.id,row);

                    
                    for(var i=0;i<cntx.pages.length;i++){
                        var page = cntx.pages[i];
                        
                        if( (cntx.access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.READ)>0)
                            readcheck = "checked disabled";
                        else
                        if((page.access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.READ)>0)
                            readcheck = "checked";


                        if( (cntx.access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.WRITE)>0)
                            writecheck = "checked disabled";
                        else
                        if((page.access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.WRITE)>0){
                            writecheck = "checked";
                        }


                        if( (cntx.access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.EMBED)>0)
                            embedcheck = "checked disabled";
                        else
                        if((page.access[ColabopadApplication.access_index]&ColabopadApplication.ACCESS_MODE.EMBED)>0){
                            embedcheck = "checked";
                        }


                        row = {title:page.title,
                               read:'<input type="checkbox" id="user-context-page-read-acl'+page.id+'" class="user-context-page-read-acl" onchange="ColabopadApplication.setUserAccessControls('+pid+','+context_id+',\'read\',false,$(this).attr(\'checked\'),'+page.id+')" '+readcheck+'/>',
                               write:'<input type="checkbox" id="user-context-page-write-acl'+page.id+'" class="user-context-page-write-acl" onchange="ColabopadApplication.setUserAccessControls('+pid+','+context_id+',\'write\',false,$(this).attr(\'checked\'),'+page.id+')" '+writecheck+'/>',
                               create:'',
                               del:'',
                               embed:'<input type="checkbox" id="user-context-page-embed-acl'+page.id+'" class="user-context-page-embed-acl" onchange="ColabopadApplication.setUserAccessControls('+pid+','+context_id+',\'embed\',false,$(this).attr(\'checked\'),'+page.id+')" '+embedcheck+'/>'};
                        $("#page-access-control-list").addRowData(parseInt(cntx.id)+parseInt(page.id),row);
                        readcheck  = "";
                        writecheck = "";
                        embedcheck = "";
                    }
               },
                setAccess:function(row,type,set){                    
                   if(type == "read"){
                        if(set)
                          row.access[this.ACL_EDIT_INDEX]  |= ColabopadApplication.ACCESS_MODE.READ;
                        else
                          row.access[this.ACL_EDIT_INDEX]  &= ~ColabopadApplication.ACCESS_MODE.READ;
                   }
                   else
                   if(type == "write"){
                        if(set)
                          row.access[this.ACL_EDIT_INDEX]  |= ColabopadApplication.ACCESS_MODE.WRITE;
                        else
                          row.access[this.ACL_EDIT_INDEX]  &= ~ColabopadApplication.ACCESS_MODE.WRITE;
                   }
                   else
                   if(type == 'embed'){
                        if(set)
                            row.access[this.ACL_EDIT_INDEX]  |= ColabopadApplication.ACCESS_MODE.EMBED;
                        else
                            row.access[this.ACL_EDIT_INDEX]  &= ~ColabopadApplication.ACCESS_MODE.EMBED;
                    }
                },
                setContextAccess:function(context_id,type,set){
                   var context = this.getItemById(context_id,this.getCurrentParticipantContext().context_list);
                   this.setAccess(context,type,set);
                },
                setPadAccess:function(context_id,pad_id,type,set){
                   var context = this.getItemById(context_id,this.getCurrentParticipantContext().context_list);
                   var page = this.getItemById(pad_id,context.pages);
                   this.setAccess(page,type,set);
                },
                setElementAccess:function(context_id,pad_id,element_id,type,set){
                   var context = this.getItemById(context_id,this.getCurrentParticipantContext().context_list);
                   var page    = this.getItemById(pad_id,context.pages);
                   var element = this.getItemById(element_id,page.elements);//alert(page.elements.length+":"+page.title+":"+element+":"+element_id+":"+page.elements[0].config.dbid);
                   this.setAccess(element,type,set);
                },
               loadACLSettings:function(access_list){
                    this.bindAccess(access_list);
                    var context_list = this.getCurrentParticipantContext().context_list;

                    $('.acl-checkbox').removeAttr("checked");
                    var read_all = true;
                    var write_all = true;
                    for(var i=0;i<context_list.length;i++){
                      var context = context_list[i];
                      var context_read_all = true;
                      var context_write_all = true;

                      for(var j=0;j<context.pages.length;j++){
                        var pad = context.pages[j];
                        var pad_read_all = true;
                        var pad_write_all = true;

                        for(var k=0;k<pad.elements.length;k++){//alert(element.type);
                           var element = pad.elements[k];
                           pad_read_all  = pad_read_all && ((element.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.READ)>0);
                           pad_write_all = pad_write_all && ((element.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.WRITE)>0);

                           //log("Read:"+((element.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.READ)>0))
                           if((element.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.READ)>0)
                             $('#acl-read-checkbox-'+context.id+'-'+pad.id+'-'+element.id).attr("checked","checked");
                           if((element.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.WRITE)>0)
                             $('#acl-write-checkbox-'+context.id+'-'+pad.id+'-'+element.id).attr("checked","checked");
                        }
                        //set the all checkbox
                        if(pad_read_all && $('#acl-read-all-checkbox-'+context.id+'-'+pad.id).length>0)
                            $('#acl-read-all-checkbox-'+context.id+'-'+pad.id).attr("checked","checked");
                        if(pad_write_all && $('#acl-write-all-checkbox-'+context.id+'-'+pad.id).length>0)
                            $('#acl-write-all-checkbox-'+context.id+'-'+pad.id).attr("checked","checked");

                        //propagate up
                        context_read_all  = context_read_all && pad_read_all && ((pad.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.READ)>0);
                        context_write_all = context_write_all && pad_write_all && ((pad.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.WRITE)>0);

                        if((pad.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.READ)>0)
                          $('#acl-read-checkbox-'+context.id+'-'+pad.id).attr("checked","checked");
                        if((pad.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.WRITE)>0)
                          $('#acl-write-checkbox-'+context.id+'-'+pad.id).attr("checked","checked");
                        if((pad.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.EMBED)>0)
                          $('#acl-embed-checkbox-'+context.id+'-'+pad.id).attr("checked","checked");
                      }

                      //set the all checkbox
                      if(context_read_all && $('#acl-read-all-checkbox-'+context.id).length>0)
                         $('#acl-read-all-checkbox-'+context.id).attr("checked","checked");
                      if(context_write_all && $('#acl-write-all-checkbox-'+context.id).length>0)
                         $('#acl-write-all-checkbox-'+context.id).attr("checked","checked");

                      //propagate up
                      read_all  = context_read_all && read_all && ((context.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.READ)>0);
                      write_all = context_write_all && write_all && ((context.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.WRITE)>0);

                      if((context.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.READ)>0)
                        $('#acl-read-checkbox-'+context.id).attr("checked","checked");
                      if((context.access[this.ACL_EDIT_INDEX] & this.ACCESS_MODE.WRITE)>0){
                        $('#acl-write-checkbox-'+context.id).attr("checked","checked");
                      }
                    }
                      //set the all checkbox
                      if(read_all && $('#acl-read-all-checkbox').length>0)
                         $('#acl-read-all-checkbox').attr("checked","checked");
                      if(write_all && $('#acl-write-all-checkbox').length>0)
                         $('#acl-write-all-checkbox').attr("checked","checked");
               },
               setGrantGlobalAccess:function(set){
                  if(set){
                     $('.acl-user-checkbox').removeAttr("checked").attr("disabled","disabled");
                  }else{
                     $('.acl-user-checkbox').removeAttr("checked").removeAttr("disabled","disabled");
                  }
               },
               manageAccess:function(to_pid,context_id,user){

                    $("#user-access-control-list").clearGridData();

                    var row = {apply:'<input type="checkbox" id="acl-globaluser-checkbox" onchange="ColabopadApplication.setGrantGlobalAccess($(this).attr(\'checked\'))" /> ',title:'<span style="cursor:pointer;font-weight:bold">Everyone</span>'};
                    $("#user-access-control-list").addRowData("global",row);
                    
                    for(var i =0;i<this.room.participants.length;i++){
                        if(this.room.participants[i].id != user_id){
                          row = {apply:'<input type="checkbox" class="acl-user-checkbox" value="'+this.room.participants[i].id+'" /> ',title:'<span style="cursor:pointer">'+this.room.participants[i].name+'</span>'};
                          $("#user-access-control-list").addRowData(this.room.participants[i].id,row);
                        }
                    }
                    $("#content-access-control-list").setGridParam({"url":"util/access-control.jsp?pad_id="+ColabopadApplication.getCurrentContext().active_pad.id+"&context_id="+ColabopadApplication.getCurrentContext().active_pad.context.id});
                    $("#content-access-control-list").trigger("reloadGrid");
                    $('#user-settings-dialog').dialog("open");return;

                    
                    $("#context-access-control-list").clearGridData();
                    $("#page-access-control-list").clearGridData();

                    
                    var my_part_cntx = this.getParticipantContext(ColabopadApplication.user_id);
                    if(to_pid==-1){//grant access to all users
                          
                          ColabopadApplication.access_index = 0;

                          var context_list = my_part_cntx.context_list;
                          for(i=0;i<context_list.length;i++){
                              var cntx = context_list[i];
                              row = {title:cntx.title}
                              $("#context-access-control-list").addRowData(cntx.id,row);
                          }
                          $('#access-grant-dialog').dialog("open");
                          if(context_list.length>0)
                              $("#context-access-control-list").setSelection(context_id==-1?context_list[0].id:context_id);
                    }else{
                        //grant access to a particular participant
                        ColabopadApplication.access_index = 1;
                        $('#grant-to-pid-id').attr("value",to_pid);
                        $.ajax({
                            type:'POST',
                            data:{room_id:room_id,participant_id:my_pid,granted_to:to_pid,this_pid:my_pid},
                            url:'/ContextAction.do?action=get-context-access-list',
                            success:function(data){
                                  var reply = eval('('+data+')');
                                  //temprorarily bind access info
                                  ColabopadApplication.tempBindAccess(reply);

                                  $("#context-access-control-list").clearGridData();
                                  $("#page-access-control-list").clearGridData();

                                  var context_list = my_part_cntx.context_list;
                                  for(var i=0;i<context_list.length;i++){
                                      var cntx = context_list[i];
                                      var row = {title:cntx.title}
                                      $("#context-access-control-list").addRowData(cntx.id,row);
                                  }
                                  $('#access-grant-dialog').dialog("open");
                                  if(context_list.length>0)
                                      $("#context-access-control-list").setSelection(context_list[0].id);
                            }
                        });
                    }
               },
               switchUserContext:function(){

               },
               setPageToolbarAccess:function(page){
                   var write_access = /*(page.context.access[2]&this.ACCESS_MODE.WRITE)>0 ||*/ (page.access[2]&this.ACCESS_MODE.WRITE)>0 /*|| (page.context.access[0]&this.ACCESS_MODE.WRITE)>0*/ || (page.access[0]&this.ACCESS_MODE.WRITE)>0;
                   if(write_access){
                        $('.writeonly').removeAttr("disabled");
                        $('.writeonly').removeClass("ui-state-disabled");
                   }else{
                        $('.writeonly').attr("disabled","disabled");
                        $('.writeonly').addClass("ui-state-disabled");
                   }
               },
               findElement:function(page,id){
                   for(var i=0;i<page.elements.length;i++){
                       if(page.elements[i].config.dbid == id)
                           return page.elements[i];
                   }return null;
               },
               removeElement:function(page,id){
                   for(var i=0;i<page.elements.length;i++){
                       if(page.elements[i].config.dbid == id){
                           page.elements.splice(i,1);
                           break;
                       }
                   }
                    if(page.elements.length>0)
                        page.last_insert = page.elements[page.elements.length-1].config.dbid;
                    else
                        page.last_insert = 0;
               }, 
               pageVisible:function(pid,cntx_id,page_id){
                   if(ColabopadApplication.getCurrentParticipantContext() != null && ColabopadApplication.getCurrentParticipantContext().id==pid){
                       if(ColabopadApplication.getCurrentContext() != null && ColabopadApplication.getCurrentContext().id==cntx_id){
                           if(ColabopadApplication.getCurrentContext().active_pad != null && ColabopadApplication.getCurrentContext().active_pad.id==page_id){
                               return true;
                           }
                       }
                   }return false;
               },
               follow:function(pid){
                    var tree=$("#participant-treecontrol").dynatree('getTree')
                    var node = tree.getNodeByKey('key-'+pid);
                    node.data.addClass = ColabopadApplication.user_id==ColabopadApplication.room.creator?'onlineperson-creator-cp-nf':'onlineperson-nf';
                    tree.redraw();
                    ColabopadApplication.ContextMenus.bindColabopadContextMenu();
                    this.following = pid;
               },
               stopFollowing:function(pid){
                    var tree=$("#participant-treecontrol").dynatree('getTree')
                    var node = tree.getNodeByKey('key-'+pid);
                    node.data.addClass = ColabopadApplication.user_id==ColabopadApplication.room.creator?'onlineperson-creator-cp':'onlineperson';
                    tree.redraw();
                    ColabopadApplication.ContextMenus.bindColabopadContextMenu();
                    this.following = 0;
               },
               receiveContextMsg:function(message){                   
                   var msg = message;//ColabopadApplication.MsgHandler.toJSON(message.nodeValue);
                   if(msg.header.src_session == sessionId)return;

                    log('receiveContextMsg:'+message.header.type)
                    //return
                   
                   if(msg.header.type == 'new-page'){

                        var context = ColabopadApplication.getContext(msg.header.pid,msg.header.cntx_id);

                        if(context != null){
                            var write_access = (context.access[2]&ColabopadApplication.ACCESS_MODE.WRITE)>0 || (context.access[0]&ColabopadApplication.ACCESS_MODE.WRITE)>0;
                            var read_access  = (context.access[2]&ColabopadApplication.ACCESS_MODE.READ)>0 || (context.access[0]&ColabopadApplication.ACCESS_MODE.READ)>0;
                            
                            if(read_access || write_access){
                                var nodeclass = write_access?'padnode':'padnode0';
                                var page = msg.config;
                                page.context = context;

                                var contextNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey('key-'+context.pid+'-'+context.id);

                                context.pages.push(page);
                                var padNode = {isFolder:false,addClass:nodeclass,key:'key-'+context.pid+'-'+context.id+'-'+page.id,pid:context.pid,context_id:page.context_id,id:page.id, title:'new-page',type:'pad'};
                                contextNode.append(padNode);

                                ColabopadApplication.ContextMenus.bindWorkbookPageContextMenu();
                            }
                        }
                   }
                   else
                   if(msg.header.type == 'del-page'){

                        page = ColabopadApplication.getContextPage(msg.header.pid,msg.header.cntx_id,msg.header.page_id);

                        if(page != null){
                            var index = ColabopadApplication.findPageIndex(page);

                            if(page == ColabopadApplication.getCurrentContext().active_pad)
                                ColabopadApplication.unloadPage(page);

                            //remove page from treeview
                            var key = 'key-'+page.context.pid+'-'+page.context.id+'-'+page.id;
                            $("#participant-treecontrol").dynatree('getTree').getNodeByKey(key).remove();

                            //switch to new page
                            if(page.context.pages.length>1){
                                if(index+1==page.context.pages.length)
                                  page.context.active_pad = page.context.pages[index-1];
                                else
                                  page.context.active_pad = page.context.pages[index+1];
                            }else{
                                  page.context.active_pad = null;
                            }
                             //remove page from list
                             page.context.pages.splice(index,1);

                            if(page.context.active_pad !=null)
                                ColabopadApplication.switchToPage(page.context.active_pad);
                             else
                             {
                                //switch to this user's context
                             }
                             ColabopadApplication.ContextMenus.bindWorkbookPageContextMenu();
                        }
                   }
                   else
                   if(msg.header.type == 'rename-page'){
                            page = ColabopadApplication.getContextPage(msg.header.pid,msg.header.cntx_id,msg.header.page_id);
                            if(page != null){
                                write_access = (page.context.access[2]&ColabopadApplication.ACCESS_MODE.WRITE)>0 || (page.context.access[0]&ColabopadApplication.ACCESS_MODE.WRITE)>0;
                                read_access  = (page.context.access[2]&ColabopadApplication.ACCESS_MODE.READ)>0 || (page.context.access[0]&ColabopadApplication.ACCESS_MODE.READ)>0;

                                if(read_access || write_access){
                                    key  = 'key-'+page.context.pid+'-'+page.context.id+'-'+page.id;
                                    var node = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(key);
                                    var newTitle = msg.title;
                                    node.data.title = newTitle;
                                    $("#participant-treecontrol").dynatree('getTree').redraw();
                                    page.title =  newTitle;
                                }
                            }
                   }
                   else
                   if(msg.header.type == 'nav-to-page'){
                       if(ColabopadApplication.following == msg.header.pid){
                           page = ColabopadApplication.getContextPage(msg.header.pid,msg.header.cntx_id,msg.header.page_id);
                           if(page != null){
                                write_access = (page.context.access[2]&ColabopadApplication.ACCESS_MODE.WRITE)>0 || (page.context.access[0]&ColabopadApplication.ACCESS_MODE.WRITE)>0;
                                read_access  = (page.context.access[2]&ColabopadApplication.ACCESS_MODE.READ)>0 || (page.context.access[0]&ColabopadApplication.ACCESS_MODE.READ)>0;

                                if(read_access || write_access){
                                    ColabopadApplication.nav_msg_queue.push('nav');
                                    key = 'key-'+page.context.pid+'-'+page.context.id+'-'+page.id;
                                    $("#participant-treecontrol").dynatree('getTree').activateKey(key);
                                }
                           }
                       }
                   }
               },
               receivePageMsg:function(message){

                   var msg = message;//ColabopadApplication.MsgHandler.toJSON(message.nodeValue);
                   if(msg.header.src_session == sessionId)return;

                    log('receivePageMsg:'+message.header.type)
                    

                   if(msg.header.type == 'insert'){

                       debug('inserting: '+msg.config.dbid)
                       if(ColabopadApplication.pageVisible(msg.header.pid,msg.header.cntx_id,msg.header.page_id)){
                            ColabopadApplication.getCurrentContext().active_pad.last_insert = parseInt(msg.config.dbid);

                            ColabopadApplication.insertContentElement(ColabopadApplication.getCurrentContext().active_pad,{config:msg.config,dom:null},false,false);
                       }else{
                           var page = ColabopadApplication.getContextPage(msg.header.pid,msg.header.cntx_id,msg.header.page_id);
                           if(page != null && page.loaded_from_db){
                                page.last_insert = parseInt(msg.config.dbid);
                                page.elements.push({config:msg.config,dom:null});
                           }
                       }
                   }
                   else
                   if(msg.header.type == 'delete'){
                       
                       if(ColabopadApplication.pageVisible(msg.header.pid,msg.header.cntx_id,msg.header.page_id)){
                           
                           page = ColabopadApplication.getCurrentContext().active_pad;
                           var ele = ColabopadApplication.findElement(page,msg.header.id);
                           if(ele != null)
                                ColabopadApplication.debugRemove(ColabopadApplication.getCurrentContext().active_pad,ele.dom,'receivePageMsg');
                       }else{                           
                           page = ColabopadApplication.getContextPage(msg.header.pid,msg.header.cntx_id,msg.header.page_id);
                           ele = ColabopadApplication.findElement(page,msg.header.id);
                       }
                       if(ele != null){
                            if(ele.config.type == "widget")
                               ColabopadApplication.findAndRemoveWidget({config:ele.config},page);
                            else
                               ColabopadApplication.removeElement(page,msg.header.id);
                       }
                   }
                   else
                   if(msg.header.type == 'transform'){

                       //debug('transform message received...')
                       if(ColabopadApplication.pageVisible(msg.header.pid,msg.header.cntx_id,msg.header.page_id)){
                           ele = ColabopadApplication.findElement(ColabopadApplication.getCurrentContext().active_pad,msg.header.id);
                           if(ele != null){
                               //ele.config.transforms = msg.transforms;
                               //apply incrementally
                               ele.config.transforms.trslt.x += (msg.transforms.trslt.x-ele.config.transforms.trslt.x);
                               ele.config.transforms.trslt.y += (msg.transforms.trslt.y-ele.config.transforms.trslt.y);
                               ele.config.transforms.scale.x += (msg.transforms.scale.x-ele.config.transforms.scale.x);
                               ele.config.transforms.scale.y += (msg.transforms.scale.y-ele.config.transforms.scale.y);
                               
                               if(typeof ele.config.transforms.rotate.immutable == "undefined" || !ele.config.transforms.rotate.immutable){
                                    ele.config.transforms.rotate.angle += (msg.transforms.rotate.angle-ele.config.transforms.rotate.angle);
                                    ele.config.transforms.rotate.cx = (msg.transforms.rotate.cx);
                                    ele.config.transforms.rotate.cy = (msg.transforms.rotate.cy);
                               }
                               ColabopadApplication.applyTransform(ColabopadApplication.getCurrentContext().active_pad,ele,false);
                           }
                       }else{
                           page = ColabopadApplication.getContextPage(msg.header.pid,msg.header.cntx_id,msg.header.page_id);
                           ele = ColabopadApplication.findElement(page,msg.header.id);
                           if(ele != null){
                               //debug('processing...2')
                               ele.config.transforms = msg.transforms;
                           }
                       }
                   }
                   else
                   if(msg.header.type == 'fill-shape'){
                       if(ColabopadApplication.pageVisible(msg.header.pid,msg.header.cntx_id,msg.header.page_id)){
                           ele = ColabopadApplication.findElement(ColabopadApplication.getCurrentContext().active_pad,msg.header.id);
                           
                           if(ele != null){
                                ele.config.pen.fill = msg.color;
                                ColabopadApplication.fillShape(ColabopadApplication.getCurrentContext().active_pad,ele,false);
                           }
                       }else{
                           page = ColabopadApplication.getContextPage(msg.header.pid,msg.header.cntx_id,msg.header.page_id);
                           ele = ColabopadApplication.findElement(page,msg.header.id);
                           if(ele != null){
                               //debug('processing...2')
                               ele.config.pen.fill = msg.color;
                           }
                       }
                   }
                   else
                   if(msg.header.type == 'widget-message'){
                       page = ColabopadApplication.getContextPage(msg.header.pid,msg.header.cntx_id,msg.header.page_id);
                       var widget = ColabopadApplication.getWidget(msg.header.classId,msg.header.env);
                       if(page != null && widget != null){

                           widget.onMessage(page,msg.message);
                       }
                   }
               },
               deleteParticipant:function(dtnode){

                    if(!confirm('Are you sure you want to remove participant '+dtnode.data.title+' ?'))return;
                    
                    var part = '<span style="font-weight:bold;font-style:italic;color:gray">'+dtnode.data.title+'</span>';
                    $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" /> Removing '+part+',please wait...</h1>'});
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,participant_id:dtnode.data.id,pid:dtnode.data.id,room_access_code:room_access_code,this_pid:my_pid,secure_token:secure_token},
                        url:'/UserAction.do?action=del-participant',
                        success:function(data){
                            $.unblockUI();
                            var reply = eval('('+data+')');

                            if(reply.status=='success'){
                               dtnode.remove();
                               ColabopadApplication.removeParticipant(dtnode.data.id);
                               ColabopadApplication.ContextMenus.bindColabopadContextMenu();
                               ColabopadApplication.MsgHandler.sendMessage({sender_id:sessionId,type:'del-participant',id:dtnode.data.id});
                            }else{
                                alert('There was a problem removing participant,please try again.\nIf problem persist, please contact support@appynotebook.com');
                            }
                        }
                    });
              },
              inviteParticipant:function(dtnode){
                    var part = '<span style="font-weight:bold;font-style:italic;color:gray">'+dtnode.data.title+'</span>';
                    $.blockUI({css:{},overlayCSS: {backgroundColor: '#666666',opacity:.2},theme:false,message: '<h1><img src="images/misc/busy.gif" /> Sending invite to '+part+',please wait...</h1>'});
                    $.ajax({
                        type:'POST',
                        data:{participant_id:dtnode.data.id,room_id:room_id},
                        url:'/RoomAction.do?action=invite-participant',
                        success:function(data){
                            $.unblockUI();
                            var reply = eval('('+data+')');

                            if(reply.status=='success'){
                                alert('Invite sent.')
                            }else{
                                alert('There was a problem sending invite,please try again.\nIf problem persist, please contact support.');
                            }
                        }
                    });
                },
                validateAddParticipant:function(){
                    if(/*$('#roomLabel').attr("value") != '' &&*/ $('#fullName').attr("value") != '' && $('#emailAddress').attr("value") != ''){
                        return(ColabopadApplication.Utility.validate_email_address($('#emailAddress').attr("value")));
                    }
                    alert('Please fill-out all fields')
                    return false;
                },
                removeParticipant:function(id){
                    for(var i=0;i<this.room.participants.length;i++){
                        if(this.room.participants[i].id == id)
                        {
                            this.room.participants.splice(i,1);
                            return;
                        }
                    }
                },
                remoteMouseMsgHandler:function(message){
                    if(message.sender_id == 'real')return;

                    log('remoteMouseMsgHandler:'+message.type)
                    

                    var pad = ColabopadApplication.getCurrentContext().active_pad;
                    if(message.type=='sign-on-ack'){

                    }
                    else
                    if(message.type=='mouse-down'){
                        var p = {pageX:message.p.pageX+pad.div_dom.offset().left,pageY:message.p.pageY+pad.div_dom.offset().top};
                        debug('mouse down (x:'+p.pageX+',y:'+p.pageY+')');
                        ColabopadApplication.mousedownImpl(p,pad);
                    }
                    else
                    if(message.type=='mouse-up'){
                        p = {pageX:message.p.pageX+pad.div_dom.offset().left,pageY:message.p.pageY+pad.div_dom.offset().top};
                        debug('mouse up (x:'+p.pageX+',y:'+p.pageY+')');
                        ColabopadApplication.mouseupImpl(p,pad);
                    }
                    else
                    if(message.type=='mouse-move'){
                        p = {pageX:message.p.pageX+pad.div_dom.offset().left,pageY:message.p.pageY+pad.div_dom.offset().top};
                        debug('mouse move (x:'+p.pageX+',y:'+p.pageY+')');
                        ColabopadApplication.mousemoveImpl(p,pad);
                    }
                },
                getUser:function(id){
                    for(var i=0;i<this.room.participants.length;i++)
                       if(parseInt(this.room.participants[i].id) == id)return this.room.participants[i];
                    return null;
                },
                appMsgHandler:function(message){

                    if(message.sender_id == sessionId)return;//prevent message echo from being processed
                    
                    log('appMsgHandler:'+message.type)
                    
                    
                    if(message.type=='sign-on'){
                        var tree=$("#participant-treecontrol").dynatree('getTree')
                        var node = tree.getNodeByKey('key-'+message.pid);
                        node.data.addClass = ColabopadApplication.user_id==ColabopadApplication.room.creator?'onlineperson-creator-cp':'onlineperson';
                        tree.redraw();
                        ColabopadApplication.ContextMenus.bindColabopadContextMenu();
                        ColabopadApplication.getUser(message.pid).on_line = true;
                        ColabopadApplication.MsgHandler.sendMessage({to:app_queue_url,message:{sender_id:sessionId,pid:ColabopadApplication.user_id,type:'sign-on-ack'}});
                    }
                    else
                    if(message.type=='sign-on-ack'){                        
                        tree=$("#participant-treecontrol").dynatree('getTree')
                        node = tree.getNodeByKey('key-'+message.pid);
                        node.data.addClass = ColabopadApplication.user_id==ColabopadApplication.room.creator?'onlineperson-creator-cp':'onlineperson';
                        tree.redraw();
                        ColabopadApplication.ContextMenus.bindColabopadContextMenu();
                        ColabopadApplication.getUser(message.pid).on_line = true;
                    }
                    else
                    if(message.type=='add-participant'){
                        ColabopadApplication._addParticipantToRoom("offline",message.participant);
                        ColabopadApplication.room.participants.push(message.participant);
                        ColabopadApplication.ContextMenus.bindColabopadContextMenu();//rebind context menu
                    }
                    else
                    if(message.type=='del-participant'){
                        $("#participant-treecontrol").dynatree('getTree').getNodeByKey('key-'+message.id).remove();
                        ColabopadApplication.removeParticipant(message.id);
                    }
                },
                distributeContext:function(id,toUser){
                    $.ajax({
                        type:'POST',
                        data:{context_id:id,room_id:room_id,toUser:toUser},
                        url:'/ContextAction.do?action=distribute-context',
                        success:function(data){
                            var reply = eval('('+data+')');
                            //debug('context distribute')

                            //in future we'll propagate this to queue
                            if(reply.status == "success")
                                alert('A copy of this binder has been distributed to selected participants.')
                            else{
                                alert(reply.msg);
                            }
                        }
                    });
                },
                sysDistributeContext:function(id){
                    $.ajax({
                        type:'POST',
                        data:{context_id:id,room_id:room_id},
                        url:'/ContextAction.do?action=sys-distribute-context',
                        success:function(data){
                            //var reply = eval('('+data+')');
                            //debug('context distribute')

                            //in future we'll propagate this to queue
                            alert('All new users will now have a copy of this binder on first login.');
                        }
                    });
                },
                showEmbedCode:function(embed_key){
                    $('#phyzixlabs-embed-code').val('<div id="dock-'+embed_key+'"></div><script type="text/javascript" src="'+baseUrl+'/embed/'+embed_key+'?width=866&height=380"></script>');
                    $('#phyzixlabs-embed-code-width').val('866');
                    $('#phyzixlabs-embed-code-height').val('380');

                    $('#phyzixlabs-embed-code-width,#phyzixlabs-embed-code-height').change(function(){
                        $('#phyzixlabs-embed-code').val('<div id="dock-'+embed_key+'"></div><script type="text/javascript" src="'+baseUrl+'/embed/'+embed_key+'?width='+$('#phyzixlabs-embed-code-width').val()+'&height='+$('#phyzixlabs-embed-code-height').val()+'"></script>')
                    });
                },
                showPageURL:function(dtnode){
                    var _this = this;
                    var lp = this.room_id+'x'+dtnode.data.pid+'x'+dtnode.data.context_id+'x'+dtnode.data.id
                    
                    $.blockUI();
                    $.ajax({
                        type:'POST',
                        data:{room_id:this.room_id},
                        url:'/RoomAction.do?action=get-room-access',
                        success:function(data){
                             $.unblockUI();
                            var reply = eval('('+data+')');
                            if(reply.status != "success"){
                                //alert(reply.msg);
                            }else{
                                if(reply.accessControl == 1)
                                    lp += 'x'+reply.accessCode;
                                $('#phyzixlabs-page-url').val(_this.baseUrl+'/sl/?lp='+lp);
                                $('#page-url-dialog').dialog("open");
                            }
                        }
                    });                     
                },                
                loadEmbeded:function(embed_key){
                    var _this = this;
                    this._initWidgetControlPanel();
                    //this._npSettings.width  = width+'px';
                    //this._npSettings.height = height+'px';

                    $.ajax({
                        type:'POST',
                        data:{"embed_key":embed_key},
                        url:'/actionProcessor.jsp?action=load-embed-pad',
                        success:function(data){
                            
                            var reply = eval('('+data+')');
                            
                            if(reply.status == 'failed')return;



                            var part_cntx = {id:reply.participant_id,context_list:[],current_context:null,tab:null,selected:false};

                            var context = {
                                room_id:reply.room_id,
                                participant_id:reply.participant_id,
                                id:reply.context_id,
                                local:false,
                                pid:reply.participant_id,
                                title:reply.meta_data.title,
                                active_pad:null,
                                pages:[],
                                tab:null,
                                dock:$('#embed-frame'),
                                access_index:0,
                                access:[_this.ACCESS_MODE.READ,_this.ACCESS_MODE.READ],
                                selected:false,
                                queue_url:''
                            }
                            part_cntx.current_context = context;
                            part_cntx.context_list.push(context);
                            _this.setCurrentParticipantContext(part_cntx);


                            var page = {room_id:reply.room_id,
                                        participant_id:reply.participant_id,
                                        context_id:reply.context_id,
                                        id:reply.pad_id,
                                        title:'page',
                                        template:_this.getPageTemplate(reply.meta_data.template),
                                        svg_doc:null,
                                        context:context,
                                        widget_instances:[],
                                        elements:reply.elements,
                                        activeWidgetInstance:null,
                                        div_dom:null,
                                        loaded:false,
                                        access:[_this.ACCESS_MODE.WRITE,_this.ACCESS_MODE.WRITE],
                                        access_index:0,
                                        queue_url:reply.meta_data.queue_url,
                                        loaded_from_db:true,
                                        last_insert:0,
                                        clicked:true,
                                        load_callbacks:[],
                                        undo_stack:[],
                                        redo_stack:[]};
                              context.pages.push(page);

                              
                              //initialize the page that was click
                              _this.initPage(page,_this.loadPageContent);
                        }
                    });
                 },
                loadEmbededPage:function(embed_key){
                    var _this = this;
                    $.ajax({
                        type:'POST',
                        data:{"embed_key":embed_key},
                        url:'/actionProcessor.jsp?action=load-embed-pad',
                        success:function(data){

                            var reply = eval('('+data+')');
                            
                            if(reply.status == 'failed')return;

                            var context = {
                                room_id:reply.room_id,
                                participant_id:_this.current_participant_context.id,
                                id:new Date().getTime(),
                                local:false,
                                pid:_this.current_participant_context.id,
                                title:reply.meta_data.title,
                                active_pad:null,
                                pages:[],
                                tab:null,
                                dock:null,
                                access_index:0,
                                access:[_this.ACCESS_MODE.READ,_this.ACCESS_MODE.READ],
                                selected:false,
                                queue_url:''
                            }
                            //part_cntx.current_context = context;
                            _this.current_participant_context.context_list.push(context);
                            //_this.participant_context_list.push(part_cntx);
                            
                            var page = {room_id:reply.room_id,
                                        participant_id:_this.current_participant_context.id,
                                        context_id:context.id,
                                        id:reply.pad_id,
                                        title:'embeded-page',
                                        template:_this.getPageTemplate(reply.meta_data.template),
                                        svg_doc:null,
                                        context:context,
                                        widget_instances:[],
                                        elements:reply.elements,
                                        activeWidgetInstance:null,
                                        div_dom:null,
                                        loaded:false,
                                        access:[_this.ACCESS_MODE.WRITE,_this.ACCESS_MODE.WRITE],
                                        access_index:0,
                                        queue_url:reply.meta_data.queue_url,
                                        loaded_from_db:true,
                                        last_insert:0,
                                        clicked:true,
                                        clientside:true,
                                        load_callbacks:[],
                                        undo_stack:[],
                                        redo_stack:[]};
                              context.pages.push(page);

                              //initialize the page that was click
                              //_this.initPage(page,_this.loadPageContent);
                              _this.setUpView(_this.current_participant_context.id,context.id,reply.pad_id,'page-click');
                              ColabopadApplication.ContextMenus.bindColabopadContextMenu();
                        }
                    });
                 },                 
                 resetPlanInfoSection:function (){

                        $('#upgrade-plan-button,#change-to-individual-plan-button,#change-to-team-plan-button,#change-team-plan-size-payment-info-button,#change-payment-info-button').css({"display":"none"});
                        $.ajax({
                        type:'POST',
                        url:'/UserAction.do?action=get-plan-info',
                        success:function(data){
                                var reply = eval('('+data+')');
                                var msg = '';
                                var tmMsg = '';
                                if(reply.current_plan == "team")
                                    tmMsg = ' with capacity for '+reply.current_team_size+' members';

                                if(reply.current_plan == "basic")
                                    $('#cancel-to-basic-plan-button').css("display","none");
                                else
                                    $('#cancel-to-basic-plan-button').css("display","inline");

                                if(reply.current_plan_status == 'pending-downgrade-to-basic'){
                                    $('#cancel-to-basic-plan-button').css("display","none");
                                    msg = 'You currently have the \''+reply.current_plan+'\' plan'+tmMsg+', <br/> however this plan is due to be cancelled on '+reply.next_billing_cycle+'.';
                                    $('#current-plan-info-display').html(msg);
                                }
                                else
                                if(reply.current_plan_status == 'pending-downgrade-to-individual'){
                                    msg = 'You currently have the \''+reply.current_plan+'\' plan'+tmMsg+', <br/> however this plan is due to be downgraded to the \'individual\' on '+reply.next_billing_cycle+'.';
                                    $('#current-plan-info-display').html(msg);                                            
                                }
                                else
                                if(reply.current_plan_status.indexOf('pending-downgrade-to-team') != -1){
                                    var newTeamsize = reply.current_plan_status.split('(')[1].split(')')[0];
                                    msg = 'You currently have the \'team\' plan'+tmMsg+', <br/> however team size is due to be reduced to '+(parseInt(reply.current_team_size)+parseInt(newTeamsize))+' members on '+reply.next_billing_cycle+'.';
                                    $('#current-plan-info-display').html(msg);                                            
                                }
                                else
                                if(reply.current_plan == "team"){
                                    msg = 'You currently have the \'team\' plan'+tmMsg+'.';
                                    $('#current-plan-info-display').html(msg);                                              
                                }
                                else
                                {
                                    msg = 'You currently have the \''+reply.current_plan+'\' plan';
                                    $('#current-plan-info-display').html(msg);                                            
                                }

                                if(reply.current_plan == "team"){
                                        $('#change-to-individual-plan-button,#change-team-plan-size-payment-info-button').css({"display":"inline"});
                                }
                                else
                                if(reply.current_plan == "individual"){
                                        $('#change-to-team-plan-button,#change-payment-info-button').css({"display":"inline"});
                                }
                                else
                                if(reply.current_plan == "basic")
                                        $('#upgrade-plan-button').css({"display":"inline"});
                        }
                    });                          
                 },                 
                 showTextEditor:function(){
                    if(/*this.getCurrentContext().active_pad.template.name != 'text-editor'*/ typeof ColabopadApplication.getCurrentContext().active_pad.texteditor == "undefined"){
                        this.newWidget(text_editor_classid,'prod');
                    }
                 },
                saveAssignment:function(action,assignment_id){
                    var _this = this;

                    var title 			= $('#assignment-title').val();//only required
                    if(title == ""){
                        alert("Please provide a name for this task.");return;
                    }

		    var timeZone  		= $('#assignment-timezone').val();
		    var openTime  		= $('#assignment-open-time').val();
		    var closeTime 		= $('#assignment-close-time').val();
                    
		    var firstReminder 		= $('#assignment-first-reminder-time').val();
                    var repeatIntervalDays	= $('#assignment-reminder-repeat-interval-days').val();
		    var repeatInterval 		= $('#assignment-reminder-repeat-interval').val();
		    var repeatIntervalCount     = $('#assignment-reminder-repeat-count').val();
		    var allowVersioning         = $('#assignment-allow-versioning').attr("checked")?"yes":"no";
		    var versioningLimit         = $('#assignment-versioning-limit').val();
                    
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,
                            "assignment_id":assignment_id,
                            "title":title,
                            "timeZone":timeZone,
                            "openTime":openTime,
                            "closeTime":closeTime,
                            "firstReminder":firstReminder,
                            "repeatInterval":repeatInterval,
                            "repeatIntervalDays":repeatIntervalDays,
                            "repeatIntervalCount":repeatIntervalCount.length==0?0:repeatIntervalCount,
                            "allowVersioning":allowVersioning,
                            "versioningLimit":versioningLimit},
                        url:'/PadUIAction.do?action='+action,
                        success:function(data){

                            

                            if(action == "add-assignment"){
                                var reply = eval('('+data+')');
                                if(ColabopadApplication.needUpgrade(reply))return;
                                
                                var participantNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey('key-assignment-root');
                                var assignmentNode = {"isFolder":true,
                                                      "addClass":"phyzixlabs-room-assignment",
                                                      "key":"key-assignment-"+reply.id,
                                                      "id":reply.id,
                                                      "title":title,
                                                      "type":"assignment",
                                                      "children":[]};

                                participantNode.append(assignmentNode);
                            }
                            else
                            {
                                var node = $("#participant-treecontrol").dynatree('getTree').getNodeByKey('key-assignment-'+assignment_id);
                                node.data.title = title;
                                $("#participant-treecontrol").dynatree('getTree').redraw();
                            }
                            ColabopadApplication.ContextMenus.bindAssingmentMenu();
                        }
                    });
                },
                editAssignment:function(assignment_id){
                    $.ajax({
                        type:'POST',
                        data:{
                            "room_id":room_id,
                            "assignment_id":assignment_id},
                        url:'/PadUIAction.do?action=get-assignment',
                        success:function(data){

                            var reply = eval('('+data+')');
                            $('#assignment-title').val(reply.title);
                            $('#assignment-timezone').val(reply.timeZone);
                            $('#assignment-open-time').val(reply.openTime);
                            $('#assignment-close-time').val(reply.closeTime);
                            $('#assignment-first-reminder-time').val(reply.firstReminder);
                            if(reply.repeatIntervalDays>0)$('#assignment-reminder-repeat-interval-days').val(reply.repeatIntervalDays);
                            $('#assignment-reminder-repeat-interval').val(reply.repeatInterval);
                            if(reply.repeatIntervalCount>0)$('#assignment-reminder-repeat-count').val(reply.repeatIntervalCount);
                            if(reply.allowVersioning=="yes")$('#assignment-allow-versioning').attr('checked','checked');
                            if(reply.versioningLimit>=0)$('#assignment-versioning-limit').val(reply.versioningLimit);
                            $('#assignment-dialog').dialog('open');
                        }
                    });
                },
                archiveAssignment:function(assignment_id){
                    if(confirm('Are you sure you want to archive this Assignment?\n This would make this assignment inaccessible.'))
                    $.ajax({
                        type:'POST',
                        data:{
                            "room_id":room_id,
                            "assignment_id":assignment_id},
                        url:'/PadUIAction.do?action=archive-assignment',
                        success:function(data){

                            //var reply = eval('('+data+')');
                            $("#participant-treecontrol").dynatree('getTree').getNodeByKey('key-assignment-'+assignment_id).remove();
                        }
                    });
                },
                resetAssignmentDialog:function(){
                    $('#assignment-title').val('');
                    $('#assignment-timezone').val('');
                    $('#assignment-open-time').val('');
                    $('#assignment-close-time').val('');
                    $('#assignment-first-reminder-time').val('');
                    $('#assignment-reminder-repeat-interval-days').val('');
                    $('#assignment-reminder-repeat-interval').val('');
                    $('#assignment-reminder-repeat-count').val('');
                    $('#assignment-allow-versioning').removeAttr('checked');
                    $('#assignment-versioning-limit').val('');
                },
                showAssignmentList:function(pid,context_id,pad_id){
                    this.assignment_submitted_pid        = pid;
                    this.assignment_submitted_context_id = context_id;
                    this.assignment_submitted_pad_id     = typeof pad_id != "undefined"?pad_id:0;
                    $.ajax({
                        type:'POST',
                        data:{
                            "room_id":room_id},
                        url:'util/open-assignment-list.jsp',
                        success:function(data){
                            
                            var reply = eval('('+data+')');
                            if(reply.length>0){
                                $('#assignment-list-dialog').dialog("open");
                                $('#available-assignment-list').empty();
                                for(var i=0;i<reply.length;i++){
                                    
                                    $('#available-assignment-list').append('<option value="'+reply[i].id+'">'+reply[i].name+'</option>');
                                }
                            }else{
                                alert('No open Assignments were found.')
                            }
                        }
                    });
                },
                submitAssignment:function(overrideExisting,overrideContextId,taskId,callBack){
                    var submitted_assignment = typeof taskId == "undefined"?$('#available-assignment-list').val():taskId;
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,
                            "context_id":this.assignment_submitted_context_id,
                            "pad_id":this.assignment_submitted_pad_id,
                            "assignment_id":submitted_assignment,
                            "overrideExisting":overrideExisting,
                            "overrideContextId":overrideContextId},
                        url:'/ContextAction.do?action=submit-assignment',
                        success:function(data){
                            var reply = eval('('+data+')');
                            if(reply.status == "success"){
                                alert("Your submission was successful.");
                            }else{

                                if(reply.versioning_not_allowed || reply.versioning_limit_reached){
                                    $("#available-assignment-submission-message").text(reply.msg);
                                    $('#assignment-submission-list-dialog').dialog("open");
                                }else{
                                    alert("Your submission failed.");
                                }
                            }

                            if(typeof callBack != "undefined")callBack(reply);

                            /*if(action == "add-assignment"){
                                var reply = eval('('+data+')');
                                var participantNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey('key-assignment-root');
                                var assignmentNode = {"isFolder":true,
                                                      "addClass":"phyzixlabs-room-assignment",
                                                      "key":"key-assignment-"+reply.id,
                                                      "id":reply.id,
                                                      "title":title,
                                                      "type":"assignment",
                                                      "children":[]};

                                participantNode.append(assignmentNode);
                            }
                            else
                            {
                                var node = $("#participant-treecontrol").dynatree('getTree').getNodeByKey('key-assignment-'+assignment_id);
                                node.data.title = title;
                                $("#participant-treecontrol").dynatree('getTree').redraw();
                            }
                            ColabopadApplication.ContextMenus.bindAssingmentMenu();*/
                        }
                    });
                    
                    //$("#participant-treecontrol").dynatree('getTree').getNodeByKey('key-assignment-'+assignment_id).remove();
                },
                triggerUpload:function(convert,from,fileType,importCallBack){
                    this.importCallBack = importCallBack;
                    
                    $('#fileUploadInterface').contents().find('.file-type-options').css("display","none");
                    $('#fileUploadInterface').contents().find('[name=from]').attr("value",from);
                    $('#fileUploadInterface').contents().find('[name=room_id]').attr("value",this.room_id);
                    
                    var width  = Math.floor(this.getCurrentContext().active_pad.svg_doc.root().width.baseVal.value);
                    var height = Math.floor(this.getCurrentContext().active_pad.svg_doc.root().height.baseVal.value);
                    $('#fileUploadInterface').contents().find('[name=page_dimensions]').attr("value",width+'x'+height);
   
                    $('#fileUploadInterface').contents().find('[name=do_conversion]').attr("value",convert);
   
                    if(typeof fileType == "undefined" || fileType == null)
                       $('#fileUploadInterface').contents().find('.file-type-options').css("display","block");
                    else
                       $('#fileUploadInterface').contents().find('[name=file_type]').attr("value",fileType);
                    
                    $('#file-upload-dialog').dialog("open");
                },
                markAssignmentAsGraded:function(context_id,granted_to,key){
                    $.ajax({
                        type:'POST',
                        data:{room_id:room_id,context_id:context_id,granted_to:granted_to,access:ColabopadApplication.ACCESS_MODE.READ},
                        url:'/ContextAction.do?action=mark-assignment-as-graded',
                        success:function(data){
                            //var reply = eval('('+data+')');                           
                            var node = $("#participant-treecontrol").dynatree('getTree').getNodeByKey(key);
                            node.data.type     = "phyzixlabs-room-assignment-submission-graded";
                            node.data.addClass = "phyzixlabs-room-assignment-submission-graded";
                            $("#participant-treecontrol").dynatree('getTree').redraw();
                            ColabopadApplication.ContextMenus.bindAssingmentMenu();
                        }
                    });
                },
                needUpgrade:function(reply){
                    if(reply.status != "success" && reply.limit){
                        $.unblockUI();
                        $('#plan-upgrade-prompt-dialog-msg').text(reply.msg);
                        $('#plan-upgrade-prompt-dialog').dialog('open');
                        return true;
                    }return false;
                },
                settingsViewOpen:false,
                createSettingsView:function(showtab){
                   $("#user-settings-dialog").dialog("open");
                   if(this.settingsViewOpen)return;
                   
                   this.settingsViewOpen = true;
                   var _this = this;
                   
                   /*
                   var tabid = 'participant-tab-user-settings';                   
                   var title = '<span style="float:left" class="ui-icon ui-icon-wrench"></span>Your Settings';
                   
                   $('#participant-tabcontrol-tabs').append('<div id="'+tabid+'"></div>');                   
                   $('#participant-tabcontrol').tabs('add','#'+tabid,title);
                   
                   $('a[href=#'+tabid+']').next().click(function(){
                       $('#participant-tabcontrol').tabs('remove',tabid);
                       _this.settingsViewOpen = false;
                   });

                   $('#'+tabid).css({"padding":"0px","padding-top":"10px"});                   
                    */
                    
                    _this._loadUserSettingsManagerUI(function(){
                            //log('all loaded');
                            $("#user-access-control-list").clearGridData();

                            var row = {apply:'<input type="checkbox" id="acl-globaluser-checkbox" onchange="ColabopadApplication.setGrantGlobalAccess($(this).attr(\'checked\'))" /> ',title:'<span style="cursor:pointer;font-weight:bold">Everyone</span>'};
                            $("#user-access-control-list").addRowData("global",row);

                            for(var i =0;i<_this.room.participants.length;i++){
                                if(_this.room.participants[i].id != user_id){
                                row = {apply:'<input type="checkbox" class="acl-user-checkbox" value="'+_this.room.participants[i].id+'" /> ',title:'<span style="cursor:pointer">'+_this.room.participants[i].name+'</span>'};
                                $("#user-access-control-list").addRowData(_this.room.participants[i].id,row);
                                }
                            }
                            $("#content-access-control-list").setGridParam({"url":"util/access-control.jsp"});
                            //$("#content-access-control-list").setGridParam({"url":"util/access-control.jsp?pad_id="+ColabopadApplication.getCurrentContext().active_pad.id+"&context_id="+ColabopadApplication.getCurrentContext().active_pad.context.id});
                            $("#content-access-control-list").trigger("reloadGrid");
                            //$('#user-settings-dialog').dialog("open");                            
                    },showtab);
                   /*
                   $.ajax({
                        type:'POST',                        
                        url:'ui-component-markups/user-settings.jsp',
                        success:function(data){
                            //$('#'+tabid).append(data);
                            //$("#user-settings-dialog .view").html(data);
                            $("#user-settings-dialog").dialog("open");
                            
                            _this._loadUserSettingsManagerUI(function(){
                                    //log('all loaded');
                                    $("#user-access-control-list").clearGridData();

                                    var row = {apply:'<input type="checkbox" id="acl-globaluser-checkbox" onchange="ColabopadApplication.setGrantGlobalAccess($(this).attr(\'checked\'))" /> ',title:'<span style="cursor:pointer;font-weight:bold">Everyone</span>'};
                                    $("#user-access-control-list").addRowData("global",row);

                                    for(var i =0;i<_this.room.participants.length;i++){
                                        if(_this.room.participants[i].id != user_id){
                                        row = {apply:'<input type="checkbox" class="acl-user-checkbox" value="'+_this.room.participants[i].id+'" /> ',title:'<span style="cursor:pointer">'+_this.room.participants[i].name+'</span>'};
                                        $("#user-access-control-list").addRowData(_this.room.participants[i].id,row);
                                        }
                                    }
                                    $("#content-access-control-list").setGridParam({"url":"util/access-control.jsp"});
                                    //$("#content-access-control-list").setGridParam({"url":"util/access-control.jsp?pad_id="+ColabopadApplication.getCurrentContext().active_pad.id+"&context_id="+ColabopadApplication.getCurrentContext().active_pad.context.id});
                                    $("#content-access-control-list").trigger("reloadGrid");
                                    //$('#user-settings-dialog').dialog("open");                            
                            },showtab);
                        }
                    });
                                    
                    //select new tab
                    $('#participant-tabcontrol').tabs('select','#'+tabid);
                   */
                },
                exportBinder:function(dtnode){
                    var _this = this;
                    
                    $.blockUI();
                    $.ajax({
                        type:'POST',
                        data:
                        {
                            "room_id":this.room_id,
                            "context_id":dtnode.data.id,
                            "grantor":dtnode.data.pid
                        },
                        url:'/PadUIAction.do?action=get-binder',
                        success:function(data){
                           $.unblockUI(); 
                           window.frames['saveAsDataInterface'].sendData(ColabopadApplication.room_id,data,"book","application/json","js",typeof phyzixlabs_database != "undefined"?phyzixlabs_database.phyzixlabs_host_url:'');
                        }
                    });                    
                },
                exportBinders:function(binders){
                    var _this = this;
                    
                    $.blockUI();
                    $.ajax({
                        type:'POST',
                        data:
                        {
                            "room_id":this.room_id,
                            "binders":binders
                        },
                        url:'/PadUIAction.do?action=get-binders',
                        success:function(data){
                           $.unblockUI(); 
                           window.frames['saveAsDataInterface'].sendData(ColabopadApplication.room_id,data,"book","application/json","js",typeof phyzixlabs_database != "undefined"?phyzixlabs_database.phyzixlabs_host_url:'');
                        }
                    });                    
                },
                startMQ:function(){
                    amq = org.activemq.Amq;                    
                    
                    //uncomment this line to disable MQ
                    //return;
                    
                    if(typeof phyzixlabs_database == "undefined"){
                        amq.init({
                            uri: '/amq',
                            logging: false,
                            timeout: 45,
                            clientId:(new Date()).getTime().toString()
                        });
                    }
                }
            };
            
             var importer = ColabopadApplication.importer;
             ColabopadApplication=colabopad;
             ColabopadApplication.importer = importer;
             ColabopadApplication.importer.embeded = embeded;

             function ColabopadApplication_load(){
                ColabopadApplication.startMQ();
                if(!embeded)
                    ColabopadApplication.init();
                else
                    ColabopadApplication.loadEmbeded(embed_key);                 
             }


             if(typeof phyzixlabs_database != "undefined"){
                phyzixlabs_database.init(ColabopadApplication_load);                 
             }else{
                 ColabopadApplication_load();
             }





             /**
             var html_doc = document.getElementsByTagName('head').item(0);
             var js = document.createElement('script');
             js.setAttribute('language', 'javascript');
             js.setAttribute('type', 'text/javascript');
             js.setAttribute('src', embeded?'a1/secure_resource?r=js/import.js':'js/import.js');
             html_doc.appendChild(js);
             ColabopadApplication.importer_dom = js;
             **/
        }
