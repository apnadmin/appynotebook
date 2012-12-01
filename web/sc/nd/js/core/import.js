/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

ColabopadApplication.importer = {
        imports:[],
        css_imports:[],
        widgets:[],
        import_queue:{queue:[],counter:0,size:0},
        embeded:ColabopadApplication.embeded,
        dom_self:null,
        find_import:function(key){
            for(var i=0;i<this.imports.length;i++)
                if(this.imports[i].key == key)
                    return this.imports[i];
            return null;
        },
        find_css_import:function(key){
            for(var i=0;i<this.css_imports.length;i++)
                if(this.css_imports[i].key == key)
                    return this.css_imports[i];
            return null;
        },
        import_ready:function(key){
            
            var impt = this.find_import(key);
            //alert(impt+","+key+","+this.imports.length+","+this.imports[0].key);
            if(impt){//this can sometimes be null because the loaded javascript is loading additional js files
                
                if(impt.cb && impt.cb.ref_count>0){
                    
                    impt.cb.ref_count--;
                    if(impt.cb.ref_count == 0){
                        impt.cb.import_ready();
                    }
                }
            }
        },
        do_import_javascript:function(files,labjs,index){

            if(index<files.length){
                var impt = files[index];
                if(this.find_import(impt.key) != null)return labjs;
                this.imports.push(impt);
                log('importing:'+impt.key)
                return this.do_import_javascript(files,labjs.script(impt.url).wait(),index+1);
            }return labjs;
        },
        createXMLHttpRequest:function () {
           try { return new XMLHttpRequest(); } catch(e) {}
           try { return new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) {}
           alert("XMLHttpRequest not supported");
           return null;
         },
        import_javascript:function(url,cb,key){

            //ensure no duplicates
            if(this.find_import(key) != null)return;
            this.imports.push({url:url,key:key,dom:"js",cb:cb});
            //TODO:Gargabe collection

            //var xhrObj = this.createXMLHttpRequest();
            // open and send a synchronous request
            //xhrObj.open('GET', url, false);
            //xhrObj.send();
            var html_head = document.getElementsByTagName('head').item(0);
            
            var js = document.createElement('script');
            js.language = "javascript";
            js.type = 'text/javascript';
            js.async = false;
            js.src = url;

            
            //js.setAttribute('language', 'javascript');
            //js.setAttribute('type', 'text/javascript');
            //js.text = xhrObj.responseText;
            //js.setAttribute('async', true);
            //js.setAttribute('src', url);

            

            //insert in front of first widget if there is any
            if(this.widgets.length>0)
                html_head.insertBefore(js,this.widgets[0]);
            else
                //html_head.appendChild(js);
               html_head.insertBefore(js,html_head.lastChild);
            
            //$('#hold-javascript').append('<script src="'+url+'" type="text/javascript"><\/script>');
        },
        import_css:function(url,cb,key){

            //ensure no duplicates
            if(this.find_css_import(key) != null)return;
            //TODO:Gargabe collection

            var link = document.createElement('link');
            link.setAttribute('rel', 'stylesheet');
            link.setAttribute('type', 'text/css');
            link.setAttribute('href', url);

            var html_head = document.getElementsByTagName('head').item(0);

            //insert in front of first widget if there is any
            if(this.widgets.length>0)
                html_head.insertBefore(link,this.widgets[0]);
            else
                html_head.appendChild(link);

                
            //callback object to notify when script is fully loaded
            //if(cb)
            //    cb.ref_count++;
            this.css_imports.push({url:url,key:key,dom:link,cb:cb});
        },
        //imports from global javascript library
        import_global_javascript_file:function (/*file*/args,env,widget_id) {
            
            var callback = null;
            var import_count = 0;
            
            
            if(args.length>0){
                if(typeof(args[args.length-1]) == "function"){                    
                    import_count = args.length-1;
                    callback = {import_ready:args[args.length-1],ref_count:import_count};
                }else{
                    import_count = args.length;
                }
            }
            


            /***
            var scripts = new Array();
            for(var i=0;i<import_count;i++){
                var key = '/importer/38f60efc-b83b-11df-9f62-0019b958a435/'+args[i];
                var url = '/importer/38f60efc-b83b-11df-9f62-0019b958a435/'+args[i]+'?ts='+(new Date().getTime()+'&mime=js'+'&widgetid='+widget_id+'&env='+env);
                scripts[i]= {url:url,key:key,dom:"js",cb:callback};
            }
            this.do_import_javascript(scripts,$LAB,0).wait(function(){
                log("imports ready")
                callback.import_ready();
            });
           ***/
            var _this = this;
            imports_requested = import_count;
            //the timeout is to ensure timestamp uniqueness
            setTimeout(function(){
                var ts = new Date().getTime();
                for(var i=0;i<import_count;i++){
                    var key = '/importer/38f60efcb83b11df9f620019b958a435-'+env+'-'+widget_id+'/'+args[i];//+'?mime=js&widgetid='+widget_id+'&env='+env;
                    var url = '/importer/38f60efcb83b11df9f620019b958a435-'+env+'-'+widget_id+'/'+args[i]+'?ts='+(ts+'&mime=js'+'&widgetid='+widget_id+'&env='+env+'&index='+i+'&callback=true');
                    _this.import_javascript(url,callback,key);
                }
            },100);
        },
        //imports from this developer's resources
        import_local_javascript_file:function (/*file,*/args,env,widget_id) {
            
            var callback = null;
            var import_count = 0;
            

            if(args.length>0){
                if(typeof(args[args.length-1]) == "function"){                    
                    import_count = args.length-1;
                    callback = {import_ready:args[args.length-1],ref_count:import_count};
                }else{
                    import_count = args.length;
                }
            }

            /***
            var scripts = new Array();
            for(var i=0;i<import_count;i++){
                var key = '/importer/'+env+'-'+widget_id+'/'+args[i];
                var url = '/importer/'+env+'-'+widget_id+'/'+args[i]+'?widgetid='+widget_id+'&env='+env+'&ts='+(new Date().getTime())+'&mime=js';
                scripts[i]={url:url,key:key,dom:"js",cb:callback};
            }
            this.do_import_javascript(scripts,$LAB,0).wait(function(){
                log("imports ready")
                callback.import_ready();
            });
            ***/

            var _this = this;
            imports_requested = import_count;
            //the timeout is to ensure timestamp uniqueness
            setTimeout(function(){
                var ts = new Date().getTime();
                for(var i=0;i<import_count;i++){
                    var key = '/importer/'+env+'-'+widget_id+'/'+args[i];//+'?widgetid='+widget_id+'&env='+env+'&mime=js';
                    var url = '/importer/'+env+'-'+widget_id+'/'+args[i]+'?widgetid='+widget_id+'&env='+env+'&ts='+(ts)+'&mime=js&index='+i+'&callback=true';
                    
                    if(typeof phyzixlabs_database != "undefined"){
                        key = '/app-'+widget_id+'/resources/'+args[i];
                        url = 'apps/app-'+widget_id+'/resources/'+args[i]+'?widgetid='+widget_id+'&env='+env+'&ts='+(ts)+'&mime=css';
                    }
                    _this.import_javascript(url,callback,key);
                }
            },100);
        },
        //imports from global css library
        import_global_css_file:function (/*file*/args,env,widget_id) { 
            var callback = null;
            var import_count = 0;
            if(args.length>0){
                if(typeof(args[args.length-1]) == "function"){
                    import_count = args.length-1;
                    callback = {import_ready:args[args.length-1],ref_count:import_count};
                }else{
                    import_count = args.length;
                }
            }

            var _this = this;
            //the timeout is to ensure timestamp uniqueness
            setTimeout(function(){
                var ts = new Date().getTime();
                for(var i=0;i<import_count;i++){
                    var key = '/importer/38f60efcb83b11df9f620019b958a435-'+env+'-'+widget_id+'/'+args[i];
                    var url = '/importer/38f60efcb83b11df9f620019b958a435-'+env+'-'+widget_id+'/'+args[i]+'?ts='+(ts+'&mime=css'+'&widgetid='+widget_id+'&env='+env);
                    _this.import_css(url,null,key);
                }
            },100);
        },
        //imports from this developer's resources
        import_local_css_file:function (/*file,*/args,env,widget_id) {
            var callback = null;
            var import_count = 0;
            var _this = this;
            if(args.length>0){
                if(typeof(args[args.length-1]) == "function"){
                    import_count = args.length-1;
                    callback = {import_ready:args[args.length-1],ref_count:import_count};
                }else{
                    import_count = args.length;
                }
            }

            //the timeout is to ensure timestamp uniqueness
            setTimeout(function(){
                var ts = new Date().getTime();
                for(var i=0;i<import_count;i++){
                    var key = '/importer/'+env+'-'+widget_id+'/'+args[i];
                    var url = '/importer/'+env+'-'+widget_id+'/'+args[i]+'?widgetid='+widget_id+'&env='+env+'&ts='+(ts)+'&mime=css';
                    
                    if(typeof phyzixlabs_database != "undefined"){
                        key = '/app-'+widget_id+'/resources/'+args[i];
                        url = 'apps/app-'+widget_id+'/resources/'+args[i]+'?widgetid='+widget_id+'&env='+env+'&ts='+(ts)+'&mime=css';
                    }
                    
                    _this.import_css(url,null,key);
                }
            },100);
        },
        get_content_url:function(widget_id,path,type){
            if(typeof phyzixlabs_database != "undefined")
                return 'apps/app-'+widget_id+'/resources/'+path+'?widgetid='+widget_id+'&env='+ColabopadApplication.getEnv()+'&ts='+(new Date().getTime())+(type?'&mime='+type:'');
            else
                return '/importer/'+path+'?widgetid='+widget_id+'&env='+ColabopadApplication.getEnv()+'&ts='+(new Date().getTime())+(type?'&mime='+type:'');
        },
        get_full_local_content_url:function(path,widget_id,env,type){
            if(typeof phyzixlabs_database != "undefined")
                return 'apps/app-'+widget_id+'/resources/'+path+'?widgetid='+widget_id+'&env='+env+'&ts='+(new Date().getTime())+'&mime='+type;
            else
                return '/importer/'+env+'-'+widget_id+'/'+path+'?widgetid='+widget_id+'&env='+env+'&ts='+(new Date().getTime())+'&mime='+type;
        },
        get_full_global_content_url:function(path,widget_id,env,type){
            return '/importer/38f60efcb83b11df9f620019b958a435-'+env+'-'+widget_id+'/'+path+'?ts='+(new Date().getTime()+'&mime='+type+'&widgetid='+widget_id+'&env='+env);
        },
        get_help_url:function(){
            var urlPrefix = this.embeded?'a1/secure_url_resource?r=':'';
           return urlPrefix+'help/index.jsp';
        },
        //uses an importer to import a library from global repository
        import_global_library:function(){

        },
        //uses an importer to import a library from global repository
        import_local_library:function(){

        },
        get_resource_url:function(file_name,classId,env){
            var urlPrefix = this.embeded?'a1/secure_url_resource?r=':'';
            return urlPrefix+'widgets/getresource.jsp?file_name='+file_name+'&widgetid='+classId+'&env='+env;
        },
        //import widgets
        import_widget:function (id, env) {
             
             
             var html_doc = document.getElementsByTagName('head').item(0);
             var js = document.createElement('script');
             js.setAttribute('language', 'javascript');
             js.setAttribute('type', 'text/javascript');


             var urlPrefix = this.embeded?'a1/secure_url_resource?r=':'';
             
             if(typeof phyzixlabs_database == "undefined"){
                if(env != undefined)
                    js.setAttribute('src', urlPrefix+'widgets/getwidget.jsp?id='+id+'&env='+env+'&ts='+(new Date().getTime()));
                else
                    js.setAttribute('src', urlPrefix+'widgets/getwidget.jsp?id='+id+'&ts='+(new Date().getTime()));
             }
             else{
                    js.setAttribute('src', 'apps/app-'+id+'/resources/app.js');
             }
             
             
             //html_doc.appendChild(js);
             //alert(html_doc.lastChild.type)
             html_doc.insertBefore(js,html_doc.lastChild);
             this.widgets.push(js);

             return false;
        }
};
