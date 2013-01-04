/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/*
 * DEV ENVIRONMENT ID:53d66824-f1ad-102c-a54b-0019b958a435
 * QUEUE ENVIRONMENT ID:47bafa4e-f466-102c-91e5-0019b958a435
 * REJECT ENVIRONMENT ID:bfcc4a7c-f503-102c-8fa4-0019b958a435
 * PROD ENVIRONMENT ID: 96ff4292-f1ad-102c-a54b-0019b958a435
 * ID PREFIX:fdd58cae-fbfa-102c-8a69-0019b958a435
 */

function Widget(env,appid,classid,name,widget){
    this.impl                = widget;
    this.impl.classid        = classid;
    this.impl.appid          = appid;
    this.impl.name           = name;
    this.impl._ready         = false;
    this.impl.sinkPad        = null;
    this.impl.svgRoot        = null;
    widget._interface        = this;
    this.impl.env            = env;
    this.impl.baseDOMid      = 'fdd58cae-fbfa-102c-8a69-0019b958a435';
    this.impl.helpfileloaded = false;
    this.impl.activeInstance = null;
    this.impl.controlPanel   = null;
    this.impl.hasfocus       = false;
    this.impl.ACCESS_MODE    = ColabopadApplication.ACCESS_MODE;
    this.impl.referencePath  = 'ColabopadApplication.getWidget("'+classid+'","'+env+'")';
    this.impl.reference      = this.impl.referencePath;
    
    if(typeof Widget._initialized == "undefined"){
        
        Widget.prototype.init=function(){
           //this is where all markup for this widget instance would go
           $('#widget-markup').append('<div id="'+this.getBaseDOMId()+'"></div>');
           //this.setSinkPad(ColabopadApplication.getSinkPad());
           if(this.onInit != undefined){
               //log('init '+this.getName())
               this.onInit();
           }
        };
        Widget.prototype.getResource=function(file_name){

        };
        Widget.prototype.getBaseDOMId=function(){
            return 'widget-'+this.baseDOMid+'-'+this.getEnv()+'-'+this.getClassId();
        }
        Widget.prototype.getResourceURL=function(file_name){
            //return 'widgets/getresource.jsp?file_name='+file_name+'&widgetid='+this.getClassId()+'&env='+this.getEnv();
            return ColabopadApplication.importer.get_resource_url(file_name, this.getClassId(), this.getEnv())
        };
        Widget.prototype.getUserResourceURL=function(uid,file_name){            
            return ColabopadApplication.getFileServiceUrl(file_name);
        };        
        Widget.prototype.getFullLocalResourceURL=function(file_name,type){
            //return 'widgets/getresource.jsp?file_name='+file_name+'&widgetid='+this.getClassId()+'&env='+this.getEnv();
            return ColabopadApplication.importer.get_full_local_content_url(file_name, this.getClassId(), this.getEnv(),type)
        };
        Widget.prototype.getFullGlobalResourceURL=function(file_name,type){
            //return 'widgets/getresource.jsp?file_name='+file_name+'&widgetid='+this.getClassId()+'&env='+this.getEnv();
            return ColabopadApplication.importer.get_full_global_content_url(file_name, this.getClassId(), this.getEnv(),type)
        };
        Widget.prototype._setSinkPad=function(pad){
          this.sinkPad = pad;
        };
        Widget.prototype._getSinkPad=function(){
          return this.sinkPad;
        };
        Widget.prototype.getName=function(){
          return this.name;
        };
        Widget.prototype.appendHtml=function(html){
            $('#'+this.getBaseDOMId()).append(html);
            //alert($('#'+this.getBaseDOMId()).html())
        };
        Widget.prototype.getClassId=function(){
            return this.classid;
        };

        Widget.prototype.getAppId=function(){
            return this.appid;
        };
        
        Widget.prototype._fnready=function(){
            //log('ready '+this.getName()+' id:'+this.getClassId())
            this._ready = true;
            ColabopadApplication.widgetReady(this);
        };
        Widget.prototype.isReady=function(){
            return this._ready;
        };
        Widget.prototype.getEnv=function(){
            /*
            if(this.env=='53d66824-f1ad-102c-a54b-0019b958a435')return 'dev';
            else
            if(this.env=='47bafa4e-f466-102c-91e5-0019b958a435')return 'queue';
            else
            if(this.env=='bfcc4a7c-f503-102c-8fa4-0019b958a435')return 'rejected';
            else
            return 'prod';
            */
           return this.env;
        };
        Widget.prototype.addInstance=function(pad,widgetInstance,access_control_list,callback){
            
            //widgetInstance.config.widget_class_id = this.getClassId();
            //widgetInstance.config.classid               = widgetInstance.config.widget_class_id;
            
            if(typeof widgetInstance.config.dbid == "undefined"){
                widgetInstance.config.widget_class_id       = this.getClassId();

                widgetInstance.config.type                  = 'widget';
                widgetInstance.config.env                   = this.getEnv();
                
                //widgetInstance.config.id                    = widgetInstance.config.widget_instance_id;
                //widgetInstance.id                           = widgetInstance.config.id;

                widgetInstance.config.classid               = widgetInstance.config.widget_class_id;
                widgetInstance.classid                      = widgetInstance.config.classid;
            }
            //make this accessible for future reference
            widgetInstance.pad                          = pad;
            widgetInstance.widget                       = this;
            widgetInstance.hasfocus                     = false; 
        
            ColabopadApplication.newWidgetInstance(widgetInstance,pad,access_control_list,callback);
        };
        Widget.prototype.updateInstance=function(pad,instance,access_control_list,callback){
            ColabopadApplication.updateElement(pad,instance,access_control_list,callback);
        };
        Widget.prototype.updateInstanceAccess=function(pad,instance,access_control_list,callback){
            ColabopadApplication.updateAppInstanceAccess(pad,instance,access_control_list,callback);
        };   
        
        Widget.prototype.getInstance=function(pad,element_id,callback){
            var page = pad;            
            ColabopadApplication.getElement(page.context.pid,page.context.id,page.id,element_id,callback);
        };        
        
        Widget.prototype.deleteInstance = function(pad,instance,callback){            
            ColabopadApplication.deleteWidgetInstance(pad,instance,callback);
        };        
        
        Widget.prototype.getSafeSelector=function(proposedSelector){
            //return '#'+this.getBaseDOMId()+' '+proposedSelector;
            return proposedSelector;
        };
        
        
        Widget.prototype.loadHelp=function(){
            var _this = this;
            if(!this.helpfileloaded){
                //$.blockUI({css:{backgroundColor: '#b7ee21', color: '#fff'},message: '<h1><img src="../../img/busy.gif" />please wait...</h1>'});
                $.ajax({type:'GET',data:{baseid:_this.getBaseDOMId()},url:ColabopadApplication.importer.get_help_url(),success:function(data){
                     //$.unblockUI();
                     _this.appendHtml(data);
                     $('#help-content-frame-'+_this.getBaseDOMId()).attr("src",_this.getResourceURL('help.html'))

                     $('#help-'+_this.getBaseDOMId()).dialog({autoOpen: true,width:500,height:500});
                     _this.helpfileloaded = true;
                }});
            }else{
                $('#help-'+_this.getBaseDOMId()).dialog("open");
            }
        };
        Widget.prototype.notifyUser=function(id,message){
            $.ajax({type:'GET',
                    data:{user_id:id,message:message,app_name:this.getName()},
                    url:'/PadUIAction.do?action=notify-user-from-app',
                    success:function(data){

                   }
            });
        };
        Widget.prototype.sendMessage=function(pad,message){
           if(pad.queue_url){                
                ColabopadApplication.MsgHandler.
                sendMessage({to:pad.queue_url,
                message:{header:{type:"widget-message",src_session:sessionId,pid:pad.context.pid,cntx_id:pad.context.id,page_id:pad.id,classId:this.getClassId(),env:this.getEnv()
                    },message:message}});
           }
        };

        Widget.prototype.getMessenger=function(){
            return ColabopadApplication.MsgHandler;
        };
        
        
        Widget.prototype.compute=function(cmd,ui,callback){
            var ui_type = typeof ui != "function"?ui:"";
            
            $.ajax({type:'GET',
                    data:{cmd:cmd,ui:ui_type},
                    url:'/jasymca',
                    success:function(data){
                        if(typeof ui != "function")
                            callback(data);
                        else
                            ui(data);
                   }
            });
        };        
        
        
        Widget.prototype.setActiveInstance=function(instance){
            //
            //    this

            this.activeInstance = instance;

            
            //****should this be initiated in a timer ?****//
           // if(instance != null && this.onGainFocus != undefined)
            //    this.onGainFocus(instance);
        };
        Widget.prototype.getActiveInstance=function(){
            return this.activeInstance;
        };
        Widget.prototype.registerControlPanel=function(controlPanel){
            $(controlPanel.panel)
            this.controlPanel = controlPanel;
        };
        Widget.prototype.getControlPanel=function(){
            return this.controlPanel;
        };
        Widget.prototype.hasFocus=function(){
            return this.hasfocus;
        };
        Widget.prototype.setFocus=function(focus){
            this.hasfocus = focus;
        };

        Widget.prototype.transformInstance=function(pad,instance,update){
            ColabopadApplication.applyTransform(pad,instance,update);
        };
        Widget.prototype.getUserId=function(){
            return ColabopadApplication.user_id;
        };
        Widget.prototype.getUser=function(pid){
            return ColabopadApplication.getUser(pid);
        };
        Widget.prototype.getCurrentUser=function(){
            return ColabopadApplication.getUser(ColabopadApplication.user_id);
        };
        Widget.prototype.getUsers=function(){
            return ColabopadApplication.room.participants;
        };
        Widget.prototype.getPad=function(){
            return ColabopadApplication.getCurrentContext().active_pad;
        };
        Widget.prototype.getInstanceBoundingBox=function(w){
            return ColabopadApplication.getWidgetBoundingBox(w);
        };
        Widget.prototype.addStrokeConfig=function(config,pad,persist_to_db,paint_only){
            config.type='stroke';
            config.element_id='grp'+(new Date()).getTime();
            
            if(config.stroke)
                config.points = config.stroke;
            
            return ColabopadApplication.addStrokeConfig(config,pad,persist_to_db,paint_only);
        };
        Widget.prototype.addLineConfig=function(config,pad,persist_to_db,paint_only){
            config.type='line-stroke';
            config.element_id='grp'+(new Date()).getTime();
            
            if(config.line)
                config.points = config.line;
            
            return ColabopadApplication.addLineConfig(config,pad,persist_to_db,paint_only);
        };
        Widget.prototype.addCircleConfig=function(config,pad,persist_to_db,paint_only){
            config.type='circle-stroke';
            config.element_id='grp'+(new Date()).getTime();
            
            if(config.circle)
                config.points = config.circle;
            
            return ColabopadApplication.addCircleConfig(config,pad,persist_to_db,paint_only);
        };
        Widget.prototype.addRectConfig=function(config,pad,persist_to_db,paint_only){
            config.type='rec-stroke';
            config.element_id='grp'+(new Date()).getTime();
            
            if(config.rect)
                config.points = config.rect;
            
            return ColabopadApplication.addRectConfig(config,pad,persist_to_db,paint_only);
        };
        Widget.prototype.addTextConfig=function(config,pad,persist_to_db,paint_only){
            config.type='text';
            config.element_id='grp'+(new Date()).getTime();
            
            return ColabopadApplication.addTextConfig(config,pad,persist_to_db,paint_only);
        };
        Widget.prototype.addImageConfig=function(config,pad,persist_to_db,paint_only){
            config.type='image';
            config.element_id='grp'+(new Date()).getTime();
            
            return ColabopadApplication.addImageConfig(config,pad,persist_to_db,paint_only);
        };
        Widget.prototype.import_global_javascript=function(/*url,cb*/){            
            ColabopadApplication.importer.import_global_javascript_file(/*url,cb*/arguments,this.getEnv(),this.getClassId());
        };
        Widget.prototype.import_local_javascript=function(/*url,cb*/){
            ColabopadApplication.importer.import_local_javascript_file(arguments,this.getEnv(),this.getClassId());
        };
        Widget.prototype.import_global_css=function(/*url,cb*/){
            ColabopadApplication.importer.import_global_css_file(/*url,cb*/arguments,this.getEnv(),this.getClassId());
        };
        Widget.prototype.import_local_css=function(/*url,cb*/){
            ColabopadApplication.importer.import_local_css_file(arguments,this.getEnv(),this.getClassId());
        };


        Widget.prototype.nextInstanceId=function(){
            return this.getPad().last_insert+1;
        };
        Widget.prototype.getReferencePath=function(){
            return 'ColabopadApplication.getWidget("'+this.getClassId()+'","'+this.getEnv()+'")';
        };
        Widget.prototype.log=function(msg){
            applet_log(msg,this.getEnv());
        };
        Widget.prototype.isEmbeded=function(){
           return ColabopadApplication.embeded;
        };
        Widget.prototype.xhtml2svg=function(params,cb_success){
            $.ajax({type:'POST',
                    data:{html:params.xhtml,width:params.width},
                    url:'util/render-html.jsp',
                    success:function(data){
                        cb_success(data);
                    }});
        };


        Widget.prototype.getBinder = function(pad){
            var page = pad.title?pad:ColabopadApplication.getContextPage(pad.participant_id,pad.context_id,pad.id);
            return page.context;
        };
        
        Widget.prototype.promptDataExport = function(data,fileName,mime,ext){            
            window.frames['saveAsDataInterface'].sendData(ColabopadApplication.room_id,data,fileName,mime,ext,phyzixlabs_host_url);
        };
        Widget.prototype.promptDataImport = function(callback){            
            ColabopadApplication.triggerUpload('yes','from-app','ms-excel',callback);
        };        
        
        Widget.prototype.navigateToPage = function(pad){
            var page = pad.title?pad:ColabopadApplication.getContextPage(pad.participant_id,pad.context_id,pad.id);
            ColabopadApplication.switchToPage(page)
        };
    
        Widget.prototype.getGroupObject = function(){
            return ColabopadApplication.participant_context_list;
        };
        
        Widget.prototype.submitTask = function(taskId,pad,binder,cb){
            ColabopadApplication.assignment_submitted_context_id = pad.context_id;
            ColabopadApplication.assignment_submitted_pad_id     = binder?0:pad.id;
            ColabopadApplication.submitAssignment(false,0,taskId,cb);
        };
        Widget.prototype.getTasks = function(cb){
            $.ajax({
                type:'POST',
                data:{
                    "room_id":room_id},
                url:'util/open-assignment-list.jsp',
                success:function(data){
                    var reply = eval('('+data+')');
                    cb(reply);
                }
            });
        };
        Widget.prototype.getPageId = function(page){
            return {"participant_id":page.pid,"context_id":page.context_id,"id":page.id};
        };
        Widget.prototype.getPageDiv = function(page){
            return page.div_dom;
        };
        Widget.prototype.getPageSVGCanvas = function(page){
            return page.svg_doc;
        };
        Widget.prototype.getActiveRoom = function(){
            return ColabopadApplication.room;
        };
        
        Widget.prototype.loadApp = function(classid,env,callback){
            return ColabopadApplication.newWidget(classid,env,callback);
        };        
        
        Widget.prototype.getComputedLeft = function(element){
            return element.config.dim.x+element.config.transforms.trslt.x;
        };
        Widget.prototype.getComputedTop = function(element){
            return element.config.dim.y+element.config.transforms.trslt.y;
        };        
        
        Widget.prototype.getComputedTopLeft = function(element){
            return {x:this.getComputedLeft(element),y:this.getComputedTop(element)};
        };         
        
        Widget.prototype.getComputedWidth = function(element){
            return Math.abs(element.config.transforms.scale.x*element.config.dim.w);
        };
        
        Widget.prototype.getComputedHeight = function(element){
            return Math.abs(element.config.transforms.scale.y*element.config.dim.h);
        };         
        
        Widget.prototype.getComputedPageWidth = function(page){
            if(typeof page == "undefined")
                return this.getPad().svg_doc.root().width.baseVal.value;
            else
                return page.svg_doc.root().width.baseVal.value;
        };
        
        Widget.prototype.getComputedPageHeight = function(page){
            if(typeof page == "undefined")
                return this.getPad().svg_doc.root().height.baseVal.value;
            else
                return page.svg_doc.root().height.baseVal.value;
        };         
        
        Widget.prototype.translateInstance = function(page,app_instance,delta,update){            
            app_instance.config.transforms.trslt.x += delta.x;
            app_instance.config.transforms.trslt.y += delta.y;            
            this.transformInstance(page,app_instance,update);
        }; 

        Widget.prototype.scaleInstance = function(page,app_instance,delta,update){
            app_instance.config.transforms.scale.x += delta.x;
            app_instance.config.transforms.scale.y += delta.y;            
            this.transformInstance(page,app_instance,update);
        }; 
        
        Widget.prototype.rotateInstance = function(page,app_instance,delta,update){
            app_instance.config.transforms.rotate.angle += delta;        
            this.transformInstance(page,app_instance,update);
        };         
        
        Widget.prototype.createHtmlView = function(page,url,options){
 	   var container = typeof options == "undefined" || typeof options.container_group == "undefined"?page.svg_doc.group():options.container_group;
           var x  = typeof options == "undefined" || typeof options.left == "undefined"?0:options.left;
           var y  = typeof options == "undefined" || typeof options.top == "undefined"?0:options.top;
           var width  = typeof options == "undefined" || typeof options.width == "undefined"?page.svg_doc.root().width.baseVal.value:options.width;
           var height  = typeof options == "undefined" || typeof options.height == "undefined"?page.svg_doc.root().height.baseVal.value:options.height;
           
           
           var fObject = page.svg_doc.other(container,"foreignObject",{x:x,y:y,width:width,height:height});
           var iframe = document.createElementNS("http://www.w3.org/1999/xhtml","iframe");
           var body = document.createElementNS("http://www.w3.org/1999/xhtml","body");
           
           var loadcount = 0;
           iframe.setAttribute("width",width);
           iframe.setAttribute("height",height);
           iframe.setAttribute("frameborder","0");
           iframe.setAttribute("scrolling","no");
                      
           //body.appendChild(iframe);
           //fObject.appendChild(body);
           
           fObject.appendChild(iframe);
           
           fObject.setAttribute("class","html-view");
           var _this = this;
           
           
           $(iframe).load(function(){
               //_this.log("onload called:"+(loadcount+1));
               if(loadcount++ == 0){/*FIREFOX HACK*/
                   //fObject.removeChild(fObject.firstChild);
                   //fObject.appendChild(iframe);
                   //return;
               }
               //mouse blocker
               container.mouseBlocker = page.svg_doc.rect(null,x, y,width,height,3,3,{"pointer-events":"visible","fill":"silver","opacity":".1","stroke":"silver", "stroke-width":"2","display":"none"});          
               
               if(typeof options != "undefined" && typeof options.callback != "undefined")
                   options.callback(iframe,fObject);
           });iframe.setAttribute("src", this.getFullLocalResourceURL(url, 'text/html')/*.getResourceURL(url)*/);
       };        
        Widget._initialized = true;
    }
    this.impl.init                              = Widget.prototype.init;
    this.impl.getName                           = Widget.prototype.getName;
    this.impl.appendHtml                        = Widget.prototype.appendHtml;
    
    this.impl.getResourceURL                    = Widget.prototype.getFullLocalResourceURL;
    this.impl.getFullLocalResourceURL           = Widget.prototype.getFullLocalResourceURL;
    this.impl.getFullGlobalResourceURL          = Widget.prototype.getFullGlobalResourceURL;
    this.impl.getUserResourceURL                = Widget.prototype.getUserResourceURL;
    
    this.impl.getClassId                        = Widget.prototype.getClassId;
    this.impl.getAppId                          = Widget.prototype.getAppId;
    this.impl.setSinkPad                        = Widget.prototype._setSinkPad;
    this.impl.getPad                            = Widget.prototype._getSinkPad;
    
    this.impl.ready                             = Widget.prototype._fnready;
    this.impl.isReady                           = Widget.prototype.isReady;
    this.impl.getEnv                            = Widget.prototype.getEnv;
    this.impl.getSafeSelector                   = Widget.prototype.getSafeSelector;
    this.impl.getBaseDOMId                      = Widget.prototype.getBaseDOMId;
    this.impl.loadHelp                          = Widget.prototype.loadHelp;
    this.impl.showHelp                          = Widget.prototype.loadHelp;
    this.impl.loadApp                           = Widget.prototype.loadApp;
    
    this.impl.sendMessage                       = Widget.prototype.sendMessage;
    this.impl.notifyUser                        = Widget.prototype.notifyUser;
    this.impl.getMessenger                      = Widget.prototype.getMessenger;
    
    this.impl.setActiveInstance                 = Widget.prototype.setActiveInstance;
    this.impl.getActiveInstance                 = Widget.prototype.getActiveInstance;
    
    this.impl.registerControlPanel              = Widget.prototype.registerControlPanel;
    this.impl.getControlPanel                   = Widget.prototype.getControlPanel;
    
    this.impl.hasFocus                          = Widget.prototype.hasFocus;
    this.impl.setFocus                          = Widget.prototype.setFocus;

    //CRUD functions
    this.impl.getInstance                       = Widget.prototype.getInstance;
    this.impl.addInstance                       = Widget.prototype.addInstance;
    this.impl.updateInstance                    = Widget.prototype.updateInstance;
    this.impl.deleteInstance                    = Widget.prototype.deleteInstance;
    
    this.impl.updateInstanceAccess              = Widget.prototype.updateInstanceAccess;
    
    
    this.impl.transformInstance                 = Widget.prototype.transformInstance;
    this.impl.translateInstance                 = Widget.prototype.translateInstance;
    this.impl.scaleInstance                     = Widget.prototype.scaleInstance;
    this.impl.rotateInstance                    = Widget.prototype.rotateInstance;
    
    this.impl.getUserId                         = Widget.prototype.getUserId;
    this.impl.getUser                           = Widget.prototype.getUser;
    this.impl.getCurrentUser                    = Widget.prototype.getCurrentUser;
    this.impl.getUsers                          = Widget.prototype.getUsers;
    
    this.impl.getBinder                         = Widget.prototype.getBinder;
    this.impl.getPad                            = Widget.prototype.getPad;
    this.impl.getInstanceBoundingBox            = Widget.prototype.getInstanceBoundingBox;
    this.impl.nextInstanceId                    = Widget.prototype.nextInstanceId;
    this.impl.getReferencePath                  = Widget.prototype.getReferencePath;
    this.impl.log                               = Widget.prototype.log;

    /*Ability to add primitive elements to page*/
    this.impl.addStroke                         = Widget.prototype.addStrokeConfig;
    this.impl.addLine                           = Widget.prototype.addLineConfig;
    this.impl.addCircle                         = Widget.prototype.addCircleConfig;
    this.impl.addRect                           = Widget.prototype.addRectConfig;
    this.impl.addText                           = Widget.prototype.addTextConfig;
    this.impl.addImage                          = Widget.prototype.addImageConfig;

    this.impl.import_local_javascript           = Widget.prototype.import_local_javascript;
    this.impl.import_global_javascript          = Widget.prototype.import_global_javascript;
    this.impl.import_local_css                  = Widget.prototype.import_local_css;
    this.impl.import_global_css                 = Widget.prototype.import_global_css;
    
    this.impl.importLocalJavascript             = Widget.prototype.import_local_javascript;
    this.impl.importGlobalJavascript            = Widget.prototype.import_global_javascript;
    this.impl.importLocalCss                    = Widget.prototype.import_local_css;
    this.impl.importGlobalCss                   = Widget.prototype.import_global_css;    

    this.impl.isEmbeded                         = Widget.prototype.isEmbeded;
    this.impl.xhtml2svg                         = Widget.prototype.xhtml2svg;

    this.impl.promptDataExport                  = Widget.prototype.promptDataExport;
    this.impl.promptDataImport                  = Widget.prototype.promptDataImport;
    
    this.impl.getGroupObject                    = Widget.prototype.getGroupObject;
    this.impl.getGroupStructure                 = Widget.prototype.getGroupObject;
    this.impl.navigateToPage                    = Widget.prototype.navigateToPage;
    this.impl.submitTask                        = Widget.prototype.submitTask;
    this.impl.getTasks                          = Widget.prototype.getTasks;
    this.impl.getTaskQueues                     = Widget.prototype.getTasks;
    this.impl.getPageId                         = Widget.prototype.getPageId;
    this.impl.getPageDiv                        = Widget.prototype.getPageDiv;
    this.impl.getPageSVGCanvas                  = Widget.prototype.getPageSVGCanvas;
    this.impl.createHtmlView                    = Widget.prototype.createHtmlView;
    
    this.impl.getComputedLeft                   = Widget.prototype.getComputedLeft;
    this.impl.getComputedTop                    = Widget.prototype.getComputedTop;
    this.impl.getComputedWidth                  = Widget.prototype.getComputedWidth;
    this.impl.getComputedHeight                 = Widget.prototype.getComputedHeight;

    this.impl.getComputedPageWidth              = Widget.prototype.getComputedPageWidth;
    this.impl.getComputedPageHeight             = Widget.prototype.getComputedPageHeight;

    this.impl.getActiveRoom                     = Widget.prototype.getActiveRoom;
    this.impl.getActiveGroup                    = Widget.prototype.getActiveRoom;
    
    this.impl.compute                           = Widget.prototype.compute;
}