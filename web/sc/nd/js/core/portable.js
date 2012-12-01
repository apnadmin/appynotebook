/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
var GraphTS = {
  sort:function(nodes,use_sibling){
    var MAX_VERTS       = nodes.length+1;
    var vertexList      = []; // list of vertices
    var matrix          = []; //adjacency matrix
    var numVerts        = 0; // current number of vertices
    var sortedArray     = [];
    
    for (var i = 0; i < MAX_VERTS; i++){
        for (var k = 0; k < MAX_VERTS; k++){
            matrix[i] = [];
            matrix[i][k] = 0;
        }   
    }

        
    function addVertex(v) {
        vertexList.push(v);
        numVerts++;
    }

    function addEdge(start, end) {
        matrix[start][end] = 1;
    }

    function displayVertex(v) {
        //System.out.print(vertexList[v].label);
    }

    function topo() // toplogical sort
    {
        var orig_nVerts = numVerts; 

        while (numVerts > 0) // while vertices remain,
        {
            // get a vertex with no successors, or -1
            var currentVertex = noSuccessors();
            if (currentVertex == -1) // must be a cycle
            {
                //System.out.println("ERROR: Graph has cycles");
                return;
            }
            // insert vertex label in sorted array (start at end)
            sortedArray[numVerts - 1] = vertexList[currentVertex];//.label;

            deleteVertex(currentVertex); // delete vertex
        }

        // vertices all gone; display sortedArray
        //System.out.print("Topologically sorted order: ");
        //for (var j = 0; j < orig_nVerts; j++)
        //System.out.print(sortedArray[j]);
        //System.out.println("");
    }

    function noSuccessors() // returns vert with no successors (or -1 if no such verts)
    { 
        var isEdge; // edge from row to column in adjMat

        for (var row = 0; row < numVerts; row++) {
            isEdge = false; // check edges
            for (var col = 0; col < numVerts; col++) {
                if (matrix[row][col] > 0) // if edge to another,
                {
                    isEdge = true;
                    break; // this vertex has a successor try another
                }
            }
            if (!isEdge) // if no edges, has no successors
                return row;
        }
        return -1; // no
    }

    function deleteVertex(delVert) {
        if (delVert != numVerts - 1) // if not last vertex, delete from vertexList
        {
            for (var j = delVert; j < numVerts - 1; j++)
                vertexList[j] = vertexList[j + 1];

            for (var row = delVert; row < numVerts - 1; row++)
                moveRowUp(row, numVerts);

            for (var col = delVert; col < numVerts - 1; col++)
                moveColLeft(col, numVerts - 1);
        }
        numVerts--; // one less vertex
    }

    function moveRowUp(row, length) {
        for (var col = 0; col < length; col++)
            matrix[row][col] = matrix[row + 1][col];
    }

    function moveColLeft(col, length) {
        for (var row = 0; row < length; row++)
            matrix[row][col] = matrix[row][col + 1];
    }

    function getVertexIndex(id){
        for(var i=0;i<vertexList.length;i++)
            if(vertexList[i].id == id)
                return i;
        return -1;
    }

    addVertex({id:'root',children:[]});
    for(i=0;i<nodes.length;i++){
        addVertex(nodes[i]);
    }
    
    for(i=0;i<nodes.length;i++){
        addEdge(getVertexIndex(nodes[i].id),getVertexIndex(typeof use_sibling == "undefined"?nodes[i].parent:nodes[i].pre_sibling));
    }    
    topo();    
    return sortedArray;
  }
};

var phyzixlabs_database = {
                version : "1",
                uuid:"",
                user_id:1,
                phyzixlabs_host_url:'http://hadron.appynotebook.com/util',
                imageURL:'http://hadron.appynotebook.com/imageImporter/?file_name=',
                defaultTreeObject:null,
                defaultWorkBench:null,
                defaultRoomObject:null,
                getUniqueKey:function(){
                  return this.uuid+"-"+this.version;  
                },
		init:function(callback){
                    user_id = this.user_id;
                    ColabopadApplication.user_id = user_id;
                    imageServiceUrl = this.imageURL;
                    ColabopadApplication.imageServiceUrl = this.imageURL;
                    
                    this.defaultRoomObject = {"id":220,"title":"My Library",creator:this.user_id,participants:[{"id":this.user_id,"name":"My Library","photo":"3a77b78e91ecd0daa159d53bc103bca5"}]};
                    var _this = this;
                    
                    $.ajax({
                            type:'POST',
                            url:'uuid.txt',
                            success:function(data){
                                _this.uuid = data;
                                
                                _this.defaultWorkBench = window.localStorage.getItem("com.phyzixlabs.workbench.v"+_this.getUniqueKey());
                                if(_this.defaultWorkBench == null){
                                    _this.defaultWorkBench = {"id":_this.user_id,"contexts":[]};
                                    _this.loadLibrary(callback);
                                }
                                else
                                {
                                    _this.defaultWorkBench = JSON.parse(_this.defaultWorkBench);
                                    callback();
                                }                                
                            }
                    });
		},
                loadLibrary:function(callback){
                    var _this = this;
                    $.ajax({
                            type:'POST',
                            dataType:'json',
                            url:'e-books/appynotebook-library.js',
                            success:function(data){
                                _this.importEbookLibrary(/*eval('('+data+')')*/data,callback);
                            }
                    });                    
                },
                importEbookLibrary:function(library,callback){
                    var _this = this;
                    if(library.length>0){
                        this.importEbookPack(library.splice(0,1),function(){
                            _this.importEbookLibrary(library,callback);
                        });
                    }else{
                        _this.updateWorkBench();
                        callback();
                    }                    
                },
                importEbookPack:function(binderPackFile,callback){
                    var _this = this;
                    $.ajax({
                            type:'POST',
                            dataType:'json',
                            url:'e-books/'+binderPackFile,
                            success:function(data){
                                var binders = data;//eval('('+data+')');
                                for(var i=0;i<binders.length;i++){
                                    _this.importEbook(binders[i]);
                                }callback();
                            }
                    });
                },
		importEbook:function(eBook){
		   
                   //ensure not a duplicate
                   for(var j=0;j<this.defaultWorkBench.contexts.length;j++){
                       if(this.defaultWorkBench.contexts[j].id == eBook.id)return;
                   }
                   
                   
		   for(var i=0;i<eBook.pads.length;i++){
		      var pad = eBook.pads[i];
		      var elements = eBook.pads[i].elements;                      
		      delete eBook.pads[i].elements;
		      window.localStorage.setItem("com.phyzixlabs.workbench.v"+this.getUniqueKey()+":page:"+eBook.id+"-"+pad.id,JSON.stringify(elements));
		   }
                   eBook.pid = this.user_id;
		   this.defaultWorkBench.contexts.push(eBook);
		},
                treeUtil:
                {
                    convertToTree:function(pads){
                        var sortedPads = GraphTS.sort(pads).reverse();                        
                        var rootPad = sortedPads.splice(0,1)[0];
                        this.convert(rootPad,sortedPads,0);
                        return rootPad;
                    },
                    convert:function(curPad,pads,startIndex){
                        for(var i=startIndex;i<pads.length;i++){
                            var pad = pads[i];
                            if(pad.parent == curPad.id){
                                curPad.children.push(pad);
                                this.convert(pad,pads,i+1);
                            }
                        }
                        var sortedPads = GraphTS.sort(curPad.children,true).reverse();
                        sortedPads.splice(0,1);
                        curPad.children = sortedPads;
                    }
                },
		buildTreeView:function(){
		   
		   var treeView = [{"title":"Library","key":"library-root", "addClass":"phyzixlabs-room-root","children":[]}];
		   var pg_cnt = 0;
		   for(var i=0;i<this.defaultWorkBench.contexts.length;i++){
			var cntx = this.defaultWorkBench.contexts[i];
		        var binderNode = {"isFolder":true,"addClass":"docnode","key":"key-"+this.user_id+"-"+cntx.id,"pid":this.user_id,"id":cntx.id,"title":cntx.meta_data.title,"type":"context","children":[]};
			treeView[0].children.push(binderNode);
			
                        var nodes = [];
			for(var j=0;j<cntx.pads.length;j++){
			    var pad = cntx.pads[j];
                            var pageNode = {parent:pad.parent_id,pre_sibling:pad.pre_sibling,"isFolder":false,"addClass":"padnode","key":"key-"+this.user_id+"-"+cntx.id+"-"+pad.id,"pid":this.user_id,"context_id":cntx.id,"id":pad.id,"embed_key":"1bb8cf4d5aa284af4b116e2b572a9fde","title":pad.meta_data.title,"type":"pad","children":[]};
                            
                            if(typeof pad.parent_id != "undefined" && pad.parent_id != 0){                                
                                //nodes.push({id:pad.id,parent:pad.parent_id,node:pageNode});
                                nodes.push(pageNode);
                            }else{
                                pageNode.parent = "root";
                                nodes.push(pageNode);
                                //nodes.push({id:pad.id,parent:"root",node:pageNode});
                            }
                           /*
			   var pageNode = {"isFolder":false,"addClass":"padnode","key":"key-"+this.user_id+"-"+cntx.id+"-"+pad.id,"pid":this.user_id,"context_id":cntx.id,"id":pad.id,"embed_key":"1bb8cf4d5aa284af4b116e2b572a9fde","title":pad.meta_data.title,"type":"pad","children":[]};
			   binderNode.children.push(pageNode);
                           */
			}
                        binderNode.children = this.treeUtil.convertToTree(nodes).children;                        
		   }
		   if(pg_cnt == 0)
			ColabopadApplication.forceReady();
		   return treeView;
		},
		updateWorkBench:function(){
		  window.localStorage.setItem("com.phyzixlabs.workbench.v"+this.getUniqueKey(),JSON.stringify(this.defaultWorkBench));
		},
		addBinder:function(binder){
		  this.defaultWorkBench.contexts.push(binder);
		  this.updateWorkBench();
		},
 		updateBinder:function(binder,meta_data){
		   for(var i=0;i<this.defaultWorkBench.contexts.length;i++){
			var cntx = this.defaultWorkBench.contexts[i];

		        if(cntx.id == binder.id){
			    cntx.meta_data = meta_data;
			    this.updateWorkBench();
			    return;
			}
		   }
		},
		deleteBinder:function(binder){
		   for(var i=0;i<this.defaultWorkBench.contexts.length;i++){
			var cntx = this.defaultWorkBench.contexts[i];

		        if(cntx.id == binder.id){
			    for(var j=0;j<cntx.pads.length;j++){
			   	var pad = cntx.pads[j];
				window.localStorage.removeItem("com.phyzixlabs.workbench.v"+this.getUniqueKey()+":page:"+cntx.id+"-"+pad.id);
			    }
			    this.defaultWorkBench.contexts.splice(i,1);
			    this.updateWorkBench();
			    return;
			}
		   }
		},
		addPage:function(binder,page){
		   for(var i=0;i<this.defaultWorkBench.contexts.length;i++){
			if(this.defaultWorkBench.contexts[i].id == binder.id)
			{
			  this.defaultWorkBench.contexts[i].pads.push(page);
		          this.updateWorkBench();
			  window.localStorage.setItem("com.phyzixlabs.workbench.v"+this.getUniqueKey()+":page:"+binder.id+"-"+page.id,"[]");
			  break;
			}	
		   }
		},
                updatePagePreSibling:function(page,new_pre_sibling){
                    for(var i=0;i<this.defaultWorkBench.contexts.length;i++){
                            var cntx = this.defaultWorkBench.contexts[i];

                            if(cntx.id == page.context_id){
                                for(var j=0;j<cntx.pads.length;j++){
                                    var pad = cntx.pads[j];

                                    if(pad.id == page.id){
                                        pad.pre_sibling = new_pre_sibling;
                                        this.updateWorkBench();
                                        return;
                                    }                                     
                                }
                            }
                    }                    
                },
                movePage:function(page,new_parent_id,new_pre_sibling,children_only){
                    if(children_only == 'yes'){
                        for(var i=0;i<this.defaultWorkBench.contexts.length;i++){
                                var cntx = this.defaultWorkBench.contexts[i];

                                if(cntx.id == page.context_id){
                                    for(var j=0;j<cntx.pads.length;j++){
                                        var pad = cntx.pads[j];
                                        
                                        /*update sibling link of first child item*/
                                        if(pad.parent_id == page.id && pad.pre_sibling == 0){
                                            pad.pre_sibling = new_pre_sibling;
                                            this.updateWorkBench();
                                        }
                                        
                                        /*update parent id*/
                                        if(pad.parent_id == page.id){
                                            pad.parent_id = new_parent_id;
                                            this.updateWorkBench();
                                        }                                        
                                    }
                                }
                        }     
                    }else{
                        for(i=0;i<this.defaultWorkBench.contexts.length;i++){
                                cntx = this.defaultWorkBench.contexts[i];

                                if(cntx.id == page.context_id){
                                    for(j=0;j<cntx.pads.length;j++){
                                        pad = cntx.pads[j];
                                        
                                        /*update sibling link and parent id of first child item*/
                                        if(pad.id == page.id){
                                            pad.pre_sibling = new_pre_sibling;
                                            pad.parent_id = new_parent_id;
                                            this.updateWorkBench();
                                            return;
                                        }                       
                                    }
                                }
                        }                          
                    }
                },
		updatePage:function(page,meta_data){
		   for(var i=0;i<this.defaultWorkBench.contexts.length;i++){
			var cntx = this.defaultWorkBench.contexts[i];

		        if(cntx.id == page.context_id){
			    for(var j=0;j<cntx.pads.length;j++){
			   	var pad = cntx.pads[j];
				if(pad.id == page.id){
				  pad.meta_data = meta_data;
				  this.updateWorkBench();
				  return;
				}
			    }
			}
		   }
		},
		deletePage:function(page){
		   window.localStorage.removeItem("com.phyzixlabs.workbench.v"+this.getUniqueKey()+":page:"+page.context_id+"-"+page.id);
		   
		   for(var i=0;i<this.defaultWorkBench.contexts.length;i++){
			var cntx = this.defaultWorkBench.contexts[i];

		        if(cntx.id == page.context_id){
			    for(var j=0;j<cntx.pads.length;j++){
			   	var pad = cntx.pads[j];
				if(pad.id == page.id){
				  cntx.pads.splice(j,1);
				  this.updateWorkBench();
				  return;
				}
			    }
			}
		   }		
		},
		getElements:function(page){		  
		  var elements =  JSON.parse(window.localStorage.getItem("com.phyzixlabs.workbench.v"+this.getUniqueKey()+":page:"+page.context_id+"-"+page.id));
		  //alert(window.localStorage.getItem("com.phyzixlabs.workbench.v"+phyzixlabs_version+":page:"+page.context_id+"-"+page.id));
		  return elements;
		},
		addElement:function(page,element){
		   var elements = JSON.parse(window.localStorage.getItem("com.phyzixlabs.workbench.v"+this.getUniqueKey()+":page:"+page.context_id+"-"+page.id));
		   elements.push({"created_by":this.user_id,"create_date":new Date().getTime(),"id":element.id,"config":element.config,"access":[3,0,35,0]});
		   window.localStorage.setItem("com.phyzixlabs.workbench.v"+this.getUniqueKey()+":page:"+page.context_id+"-"+page.id,JSON.stringify(elements));
		},
		updateElement:function(page,element){//alert(element.config.content);
		   var elements = JSON.parse(window.localStorage.getItem("com.phyzixlabs.workbench.v"+this.getUniqueKey()+":page:"+page.context_id+"-"+page.id));
		   for(var i=0;i<elements.length;i++){
			if(elements[i].id == element.config.dbid){
			  elements[i].config = element.config;
			  window.localStorage.setItem("com.phyzixlabs.workbench.v"+this.getUniqueKey()+":page:"+page.context_id+"-"+page.id,JSON.stringify(elements));
			  return;
			}
		   }
		},
		deleteElement:function(page,element){
		   var elements = JSON.parse(window.localStorage.getItem("com.phyzixlabs.workbench.v"+this.getUniqueKey()+":page:"+page.context_id+"-"+page.id));
		   for(var i=0;i<elements.length;i++){
			if(elements[i].id == element.dbid){
			   elements.splice(i,1);
			   window.localStorage.setItem("com.phyzixlabs.workbench.v"+this.getUniqueKey()+":page:"+page.context_id+"-"+page.id,JSON.stringify(elements));
			   return;
			}
		   }
		},
                getInstalledApps:function(callback){
                    var _this = this;
                    $.ajax({
                            type:'POST',
                            dataType:'json',
                            url:'apps/installed-packages.js',
                            success:function(data){
                                var packages = data;//eval('('+data+')');
                                _this.loadInstalledPackages(packages,callback,[]);
                            }
                    });                    
                },
                loadInstalledPackages:function(packages,callback,apps){
                    
                    var _this = this;
                    if(packages.length>0){
                        this.loadInstalledPackage(packages.splice(0,1),function(apps){
                            _this.loadInstalledPackages(packages,callback,apps);
                        },apps);
                    }else{
                        callback(apps);
                    }
                },
                loadInstalledPackage:function(package_name,callback,apps){
                    $.ajax({
                            type:'POST',
                            dataType:'json',
                            url:'apps/'+package_name,
                            success:function(data){
                                var _package = data;//eval('('+data+')');
                                for(var i=0;i<_package.applets.length;i++){
                                    if(_package.applets[i].showInMenu == "Yes")
                                        apps.push(_package.applets[i]);
                                }
                                callback(apps);
                            }
                    });                    
                }
	};
        
