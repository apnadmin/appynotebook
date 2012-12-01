/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

ColabopadApplication.ContextMenus ={
    clipboardNode:null,
    pasteMode:null,

    // --- Implement Cut/Copy/Paste --------------------------------------------
    copyPaste:function(action, dtnode) {
        switch( action ) {
        case "cut":
        case "copy":
          ColabopadApplication.ContextMenus.clipboardNode = dtnode;
          ColabopadApplication.ContextMenus.pasteMode = action;
          break;
        case "paste":
          if( !ColabopadApplication.ContextMenus.clipboardNode ) {
            alert("Clipoard is empty.");
            break;
          }
          if( ColabopadApplication.ContextMenus.pasteMode == "cut" ) {
            // Cut mode: check for recursion and remove source
            var isRecursive = false;
            var cb = ColabopadApplication.ContextMenus.clipboardNode.toDict(true, function(dict){
              // If one of the source nodes is the target, we must not move
              if( dict.key == dtnode.data.key )
                isRecursive = true;
            });
            if( isRecursive ) {
              alert("Cannot move a node to a sub node.");
              return;
            }
            dtnode.append(cb);
            ColabopadApplication.ContextMenus.clipboardNode.remove();
          } else {
            // Copy mode: prevent duplicate keys:
              cb = ColabopadApplication.ContextMenus.clipboardNode.toDict(true, function(dict){
              dict.title = "Copy of " + dict.title;
              delete dict.key; // Remove key, so a new one will be created
            });
            dtnode.append(cb);
          }
          ColabopadApplication.ContextMenus.clipboardNode = ColabopadApplication.ContextMenus.pasteMode = null;
          // Must enable context menu for new nodes
          //bindContextMenu();
          break;
        default:
          alert("Unhandled clipboard action '" + action + "'");
        }
       },
       bindOnlineParticipantContextMenu:function(){

            //menu for non-room creators for online participants other than themself
            $(".onlineperson")
              .destroyContextMenu() // unbind first, to prevent duplicates
              .contextMenu({menu: "participantMenuOnline"}, function(action, el, pos) {
                  //var dtnode = el.parent().attr("dtnode");
                  var dtnode = $.ui.dynatree.getNode(el);
                  switch( action ) {

                  /*
                  case "checkout":
                        //ColabopadApplication._subscribed_to=dtnode.data.dbid;
                        //colabMsgHandler.sendMessage({sender_id:sessionId,pid:dtnode.data.dbid,subscriber_name:myName,type:'check-out'});
                     break;
                  case "subscribe":
                        //ColabopadApplication._subscribed_to=dtnode.data.dbid;
                        //colabMsgHandler.sendMessage({sender_id:sessionId,pid:dtnode.data.dbid,subscriber_name:myName,type:'subscribe-to'});
                    break;
                   */
                  case "student_mode":
                    ColabopadApplication.follow(dtnode.data.id);
                    break;
                  case "security":
                        ColabopadApplication.manageAccess(dtnode.data.id,-1,dtnode.data.title);
                        break;
                  default:
                    alert("Todo: appply action '" + action + "' to node " + dtnode);
                  }
            });
            $(".onlineperson-nf")
              .destroyContextMenu() // unbind first, to prevent duplicates
              .contextMenu({menu: "participantMenuOnline-nf"}, function(action, el, pos) {
                  //var dtnode = el.parent().attr("dtnode");
                  var dtnode = $.ui.dynatree.getNode(el);
                  switch( action ) {
                  case "leave_student_mode":
                    ColabopadApplication.stopFollowing(dtnode.data.id);
                    break;
                  case "security":
                        ColabopadApplication.manageAccess(dtnode.data.id,-1,dtnode.data.title);
                        break;
                  default:
                    alert("Todo: appply action '" + action + "' to node " + dtnode);
                  }
            });

      },
      bindRoomRootContextMenu:function(){
        if(!isCreator)return;
        //menu for non-room creators for offline participants other than themself
        /*$(".phyzixlabs-room-root")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: "phyzixlabs-room-root-menu"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              current_tree_node = dtnode;
              switch( action ) {
              case "new":
                    $('#create-room-dialog').dialog("open");
                    break;
              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });*/
        $(/*".vroomtitle"*/".phyzixlabs-room-root")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: /*"phyzixlabs-room-menu"*/"phyzixlabs-room-root-menu"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              current_tree_node = dtnode;
              switch( action ) {
              case "new":
                    $('#new-participant-dialog').dialog("open");
                    break;
              case "load_users":
                    $('#load-users-dialog').dialog("open");
                    break;
              case "rename":
                    $('#room-title-dialog').dialog("open");
                    break;
              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });

      } ,
      bindOfflineParticipantContextMenu:function(){
        //menu for non-room creators for offline participants other than themself
        $(".offlineperson")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: "participantMenuOffline"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
              case "security":
                    ColabopadApplication.manageAccess(dtnode.data.id,-1,dtnode.data.title);
                    break;
              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });
      },
       bindCreatorSelfParticipantContextMenu:function(){
       //menu for room creators for themself
        $(".creatoronlineperson")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: "participantMenuOnlineCreator"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
              case "invite":
                    ColabopadApplication.inviteParticipant(dtnode);
                break;
              case "new-book":
                    ColabopadApplication.dialogOpenFrom = "normal";
                    $('#book-dialog').dialog('open');
                break;
              case "import-office":
                        ColabopadApplication.triggerUpload("yes","import-create-binder");
                        break;

              /*case "security":
                    ColabopadApplication.editContextGlobalAccessControl(dtnode.data.id);
                    ColabopadApplication.manageAccess(-1,dtnode.data.id,'');
                    break;*/
              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });
      },
       bindTeamSpaceContextMenu:function(){
           
        if(this.show_bindTeamSpaceContextMenu)
       //menu for room creators for themself
        $(".phyzixlabs-room-teamspace")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: "phyzixlabs-room-teamspace-menu"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
              case "new-book":
                    ColabopadApplication.dialogOpenFrom = "teamspace";
                    $('#book-dialog').dialog('open');
                break;
               case "import-office":
                        ColabopadApplication.triggerUpload("yes","import-teamspace");
                        break;

              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });
      },
       bindAssingmentMenu:function(){

        $(".phyzixlabs-room-assignment-root")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: "phyzixlabs-room-assignment-root-menu"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
              case "new-assignment":
                    ColabopadApplication.dialogOpenFrom = "new-assignment";
                    ColabopadApplication.resetAssignmentDialog();
                    $('#assignment-dialog').dialog('open');
                break;
              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });

        $(".phyzixlabs-room-assignment")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: "phyzixlabs-room-assignment-menu"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
              case "edit-assignment":
                    ColabopadApplication.dialogOpenFrom = "edit-assignment";
                    ColabopadApplication.resetAssignmentDialog();
                    ColabopadApplication.assignment_id = dtnode.data.id;
                    ColabopadApplication.editAssignment(dtnode.data.id);
                break;
              case "archive-assignment":
                    ColabopadApplication.dialogOpenFrom = "new_assignment";
                    ColabopadApplication.archiveAssignment(dtnode.data.id);
                break;
              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });

        $(".phyzixlabs-room-assignment-submission")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: "phyzixlabs-room-assignment-submission-menu"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
              case "mark-as-graded-assignment":
                    ColabopadApplication.markAssignmentAsGraded(dtnode.data.context_id,dtnode.data.user_id,dtnode.data.key);
                break;
              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });
      },
      bindCreatorControlPanelMenuContextMenu:function(){
          //menu for room creators for online participants other than themself
        $(".onlineperson-creator-cp")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: "creator-controlpanel-online-menu"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
              case "checkout":
                        //ColabopadApplication._subscribed_to=dtnode.data.dbid;
                        //colabMsgHandler.sendMessage({sender_id:sessionId,pid:dtnode.data.dbid,subscriber_name:myName,type:'check-out'});
                     break;
              case "subscribe":
                        //ColabopadApplication._subscribed_to=dtnode.data.dbid;
                        //colabMsgHandler.sendMessage({sender_id:sessionId,pid:dtnode.data.dbid,subscriber_name:myName,type:'subscribe-to'});
                    break;
              case "student_mode":
                    ColabopadApplication.follow(dtnode.data.id);
                    break;
              case "delete":
                    ColabopadApplication.deleteParticipant(dtnode);
                break;
              case "invite":
                    ColabopadApplication.inviteParticipant(dtnode);
                break;
              /*case "security":
                    ColabopadApplication.manageAccess(dtnode.data.id,-1,dtnode.data.title);
                    break;*/
              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });
        $(".onlineperson-creator-cp-nf")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: "creator-controlpanel-online-menu-nf"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
              case "checkout":
                        //ColabopadApplication._subscribed_to=dtnode.data.dbid;
                        //colabMsgHandler.sendMessage({sender_id:sessionId,pid:dtnode.data.dbid,subscriber_name:myName,type:'check-out'});
                     break;
              case "subscribe":
                        //ColabopadApplication._subscribed_to=dtnode.data.dbid;
                        //colabMsgHandler.sendMessage({sender_id:sessionId,pid:dtnode.data.dbid,subscriber_name:myName,type:'subscribe-to'});
                    break;
              case "leave_student_mode":
                    ColabopadApplication.stopFollowing(dtnode.data.id);
                    break;
              case "delete":
                    ColabopadApplication.deleteParticipant(dtnode);
                break;
              case "invite":
                    ColabopadApplication.inviteParticipant(dtnode);
                break;
              /*case "security":
                    ColabopadApplication.manageAccess(dtnode.data.id,-1,dtnode.data.title);
                    break;*/
              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });

          //menu for room creators for offline participants other than themself
        $(".offlineperson-creator-cp")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: "creator-controlpanel-offline-menu"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
              case "delete":
                    ColabopadApplication.deleteParticipant(dtnode);
                break;
              case "invite":
                    ColabopadApplication.inviteParticipant(dtnode);
                break;
              /*case "security":
                    ColabopadApplication.manageAccess(dtnode.data.id,-1,dtnode.data.title);
                    break;*/
              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });
      },
      bindParticipantSelfContextMenu:function(){
       //menu for non-room creators for themself
        $(".selfonlineperson")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: "participantMenuOnlineSelf"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
              case "invite":
                    ColabopadApplication.inviteParticipant(dtnode);
                break;
              case "new-book":
                    ColabopadApplication.dialogOpenFrom = "normal";
                    $('#book-dialog').dialog('open');
                break;
              case "import-office":
                        ColabopadApplication.triggerUpload("yes","import-create-binder");
                        break;
              /*case "security":
                    ColabopadApplication.editContextGlobalAccessControl(dtnode.data.id);
                    ColabopadApplication.manageAccess(-1,dtnode.data.id,'');
                break;*/
              /*
              case "delete":
                    deleteParticipant(dtnode);
                break;*/
              default:
                alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });
      },
      bindWorkbookContextMenu:function(menu){return;
        // Add context menu to document nodes:
        $(".docnode,.phyzixlabs-room-teamspace-binder")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu: /*menu*/"workbookMenu-me"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
                  case "import-office":
                        ColabopadApplication.selected_node.user_id      = dtnode.data.pid;
                        ColabopadApplication.selected_node.context_id   = dtnode.data.id;
                        ColabopadApplication.triggerUpload("yes","import");
                        break;
                  case "rename":
                        $('#work-book-title-context-id').attr("value",dtnode.data.id);
                        $('#work-book-title-pid').attr("value",dtnode.data.pid);
                        $('#work-book-title').attr('value',dtnode.data.title);
                        $('#book-dialog').dialog("open");
                        break;
                  case "delete":
                        if(!confirm('Are you sure you want to delete this binder?'))return;
                        ColabopadApplication.deleteContext(dtnode.data.pid,dtnode.data.id);
                        break;
                  case "savetodisk":
                        ColabopadApplication.exportBinder(dtnode);
                        break;
                  case "distribute":
                        //ColabopadApplication.distributeContext(dtnode.data.id);
                        ColabopadApplication.selected_node.context_id   = dtnode.data.id;
                        $('#distribute-content-dialog').dialog("open");
                        break;
                  case "auto-distribute":
                        ColabopadApplication.sysDistributeContext(dtnode.data.id);
                        break;
                  case "submit_assignment":
                        ColabopadApplication.showAssignmentList(dtnode.data.pid,dtnode.data.id);
                        break;
                  default:
                    alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });
      },
      bindWorkbookPageContextMenu:function(){return;
        // Add context menu to document nodes:
        $(".padnode")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu:"workbookPageMenu"}, function(action, el, pos) {
              //var dtnode = el.parent().attr("dtnode");
              var dtnode = $.ui.dynatree.getNode(el);
              switch( action ) {
                  case "rename":
                        $('#page-title-context-id').attr("value",dtnode.data.context_id);
                        $('#page-title-page-id').attr("value",dtnode.data.id);
                        $('#page-title-pid').attr("value",dtnode.data.pid);
                        $('#page-title').attr("value",dtnode.data.title);
                        $('#page-title-dialog').dialog("open");
                    break;
                  case "delete":
                        ColabopadApplication.delPage(ColabopadApplication.getContextPage(dtnode.data.pid,dtnode.data.context_id,dtnode.data.id));
                    break;
                  case "embed_code":
                        $('#embed-code-dialog').dialog("open");
                        ColabopadApplication.showEmbedCode(dtnode.data.embed_key);
                    break;
                  case "page_url":                        
                        ColabopadApplication.showPageURL(dtnode);
                    break;                    
                  case "submit_assignment":
                        ColabopadApplication.showAssignmentList(dtnode.data.pid,dtnode.data.context_id,dtnode.data.id);
                        break;
                  default:
                    alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });

        /*
        $(".padnode0")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu:"workbookPageMenu-default"}, function(action, el, pos) {
              var dtnode = el.attr("dtnode");
              switch( action ) {
                  case "rename":
                        $('#page-title-context-id').attr("value",dtnode.data.context_id);
                        $('#page-title-page-id').attr("value",dtnode.data.id);
                        $('#page-title-pid').attr("value",dtnode.data.pid);
                        $('#page-title-dialog').dialog("open");
                    break;
                  default:
                    alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        });*/
    },
    bindPadContextMenu:function(){
        /*$(".active-pad")
          .destroyContextMenu() // unbind first, to prevent duplicates
          .contextMenu({menu:"padContextMenu"}, function(action, el, pos) {
              var dtnode = el.attr("dtnode");
              switch( action ) {
                  case "cut":
                      alert('cut')
                    break;
                  case "copy":
                    break;
                  case "paste":
                    break;
                  default:
                    alert("Todo: appply action '" + action + "' to node " + dtnode);
              }
        }).disableContextMenuItems("#cut");*/

       $('.active-pad').contextMenu2('padContextMenu', {
              bindings: {
                'cut': function(t) {
                  ColabopadApplication.putElementToClipBoard('cut');
                },
                'copy': function(t) {
                  ColabopadApplication.putElementToClipBoard('copy');
                },
                'paste': function(t) {
                  ColabopadApplication.pasteClipBoard();
                }
              },
              onContextMenu:function(event){

                 //if(ColabopadApplication.pen.mode == "pointer")return false;
                 
                 ColabopadApplication.lastContextMenuPoint = {pageX:event.pageX,pageY:event.pageY};
                 if(ColabopadApplication.lastActivatedElement != null)
                 {
                    ColabopadApplication.currentClipboardElement = ColabopadApplication.lastActivatedElement;
                    return true;
                 }//return false;
                 return true;
              }
        });
    },
    bindColabopadContextMenu:function() {
        ColabopadApplication.ContextMenus.bindWorkbookContextMenu();
        ColabopadApplication.ContextMenus.bindWorkbookPageContextMenu();
        ColabopadApplication.ContextMenus.bindOnlineParticipantContextMenu();
        ColabopadApplication.ContextMenus.bindCreatorSelfParticipantContextMenu();
        ColabopadApplication.ContextMenus.bindParticipantSelfContextMenu();
        ColabopadApplication.ContextMenus.bindOfflineParticipantContextMenu();
        ColabopadApplication.ContextMenus.bindCreatorControlPanelMenuContextMenu();
        ColabopadApplication.ContextMenus.bindRoomRootContextMenu();
        ColabopadApplication.ContextMenus.bindTeamSpaceContextMenu();
        ColabopadApplication.ContextMenus.bindAssingmentMenu();
   },              
   setUpContextMenuBindings:function(){
            var _this = this;    
            this.contextMenuBindings=
            {
                "docnode":{
                    selector:".docnode,.phyzixlabs-room-teamspace-binder",
                    build:function($trigger, e){
                        var opt = 
                        {
                            items :
                            {
                            "new":{
                                name:"New Page",
                                items:{
                                    "doc":{
                                        name:"Text Document",
                                        exec:function(dtnode){
                                            $('#page-title-context-id,#page-title-page-id,#page-title').attr("value","") ;                                
                                            ColabopadApplication.newPageTemplate = "text-editor";
                                            $('#page-title-dialog').dialog("open");
                                            //ColabopadApplication.newPg(ColabopadApplication.getContext(dtnode.data.pid,dtnode.data.id),"text-editor");
                                        },
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}                                            
                                    },                                        
                                    "web":{
                                        name:"Web Page",
                                        exec:function(dtnode){
                                            $('#page-title-context-id,#page-title-page-id,#page-title').attr("value","") ;                                
                                            ColabopadApplication.newPageTemplate = "web-page";
                                            $('#page-title-dialog').dialog("open");                                            
                                            //ColabopadApplication.newPg(ColabopadApplication.getContext(dtnode.data.pid,dtnode.data.id),"web-page");
                                        },
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}                                            
                                    },                                        
                                    "notebook":{
                                        name:"Notebook",
                                        exec:function(dtnode){
                                            $('#page-title-context-id,#page-title-page-id,#page-title').attr("value","") ;                                
                                            ColabopadApplication.newPageTemplate = "default";
                                            $('#page-title-dialog').dialog("open");                                            
                                            //ColabopadApplication.newPg(ColabopadApplication.getContext(dtnode.data.pid,dtnode.data.id),"default");
                                        },
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}                                            
                                    },                                        
                                    "graph":{
                                        name:"Graph Paper",
                                        exec:function(dtnode){
                                            $('#page-title-context-id,#page-title-page-id,#page-title').attr("value","") ;                                
                                            ColabopadApplication.newPageTemplate = "graph-paper";
                                            $('#page-title-dialog').dialog("open");                                            
                                            //ColabopadApplication.newPg(ColabopadApplication.getContext(dtnode.data.pid,dtnode.data.id),"graph-paper");
                                        },
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}                                            
                                    },                                        
                                    "plain":{
                                        name:"Plain Sheet",
                                        exec:function(dtnode){
                                            $('#page-title-context-id,#page-title-page-id,#page-title').attr("value","") ;                                
                                            ColabopadApplication.newPageTemplate = "plain-sheet";
                                            $('#page-title-dialog').dialog("open");                                            
                                            //ColabopadApplication.newPg(ColabopadApplication.getContext(dtnode.data.pid,dtnode.data.id),"plain-sheet");
                                        },
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}                                            
                                    },                                        
                                    "blackboard":{
                                        name:"Blackboard",
                                        exec:function(dtnode){
                                            $('#page-title-context-id,#page-title-page-id,#page-title').attr("value","") ;                                
                                            ColabopadApplication.newPageTemplate = "black-board";
                                            $('#page-title-dialog').dialog("open");                                            
                                            //ColabopadApplication.newPg(ColabopadApplication.getContext(dtnode.data.pid,dtnode.data.id),"black-board");
                                        },
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}                                            
                                    }
                                }
                            },
                            "import-office":
                                {
                                    name:"Import Office/PDF Document",
                                    exec:function(dtnode){
                                        ColabopadApplication.selected_node.user_id      = dtnode.data.pid;
                                        ColabopadApplication.selected_node.context_id   = dtnode.data.id;
                                        ColabopadApplication.triggerUpload("yes","import");                                            
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "rename":
                                {
                                    name:"Rename...",
                                    exec:function(dtnode){
                                        $('#work-book-title-context-id').attr("value",dtnode.data.id);
                                        $('#work-book-title-pid').attr("value",dtnode.data.pid);
                                        $('#work-book-title').attr('value',dtnode.data.title);
                                        $('#book-dialog').dialog("open");                                            
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "delete":
                                {
                                    name:"Remove",
                                    exec:function(dtnode){
                                        if(!confirm('Are you sure you want to delete this binder?'))return;
                                        ColabopadApplication.deleteContext(dtnode.data.pid,dtnode.data.id);                                            
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }/*,
                            "savetodisk":
                                {
                                    name:"Export e-Book",
                                    exec:function(dtnode){
                                        ColabopadApplication.exportBinder(dtnode);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }*/  ,
                            "distribute":
                                {
                                    name:"Distribute",
                                    exec:function(dtnode){
                                        ColabopadApplication.selected_node.context_id   = dtnode.data.id;
                                        $('#distribute-content-dialog').dialog("open");                                            
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "auto-distribute":
                                {
                                    name:"Make System Welcome",
                                    exec:function(dtnode){
                                        ColabopadApplication.sysDistributeContext(dtnode.data.id);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "submit_assignment":
                                {
                                    name:"Submit",
                                    exec:function(dtnode){
                                        ColabopadApplication.showAssignmentList(dtnode.data.pid,dtnode.data.id);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }                                          
                            }                            
                        };
                        
                        
                        if(typeof phyzixlabs_database != "undefined"){
                            delete opt.items["import-office"];
                            delete opt.items["distribute"];
                            delete opt.items["auto-distribute"];
                            delete opt.items["submit_assignment"];
                        }
                        else
                        if(!isCreator){
                            delete opt.items["distribute"];
                            delete opt.items["auto-distribute"];
                                                    
                            if($.ui.dynatree.getNode($trigger).data.pid != user_id){
                                return false;
                            }                            
                        }
                        else
                        if(!isSysadmin){
                            delete opt.items["auto-distribute"];
                        }
                        return opt;
                    }
                },
                "padnode":{
                    selector:".padnode",
                    build:function($trigger, e){
                        var opt = 
                        {
                            items :
                            {
                            "rename":
                                {
                                    name:"Rename",
                                    exec:function(dtnode){
                                        $('#page-title-context-id').attr("value",dtnode.data.context_id);
                                        $('#page-title-page-id').attr("value",dtnode.data.id);
                                        $('#page-title-pid').attr("value",dtnode.data.pid);
                                        $('#page-title').attr("value",dtnode.data.title);
                                        $('#page-title-dialog').dialog("open");                                            
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "delete":
                                {
                                    name:"Delete",
                                    exec:function(dtnode){
                                        ColabopadApplication.delPage(ColabopadApplication.getContextPage(dtnode.data.pid,dtnode.data.context_id,dtnode.data.id));
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "embed_code":
                                {
                                    name:"Embed Code",
                                    exec:function(dtnode){
                                        $('#embed-code-dialog').dialog("open");
                                        ColabopadApplication.showEmbedCode(dtnode.data.embed_key);                                            
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "page_url":
                                {
                                    name:"Get Page URL",
                                    exec:function(dtnode){
                                        ColabopadApplication.showPageURL(dtnode);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "submit_assignment":
                                {
                                    name:"Submit",
                                    exec:function(dtnode){
                                        ColabopadApplication.showAssignmentList(dtnode.data.pid,dtnode.data.context_id,dtnode.data.id);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }                            
                        };
                        
                        if(typeof phyzixlabs_database != "undefined"){                            
                            delete opt.items["embed_code"];
                            delete opt.items["page_url"];
                            delete opt.items["submit_assignment"];
                        }                       
                        else
                        if($.ui.dynatree.getNode($trigger).data.pid != user_id){
                            return false;
                        }
                        
                        return opt;
                    }
                },
                "selfonlineperson":{
                    selector:".selfonlineperson",
                    build:function(){
                        var opt = 
                        {
                            items :
                            {
                            "invite":
                                {
                                    name:"Send Invite",
                                    exec:function(dtnode){
                                        ColabopadApplication.inviteParticipant(dtnode);                                         
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "new-book":
                                {
                                    name:"New Binder",
                                    exec:function(dtnode){
                                        ColabopadApplication.dialogOpenFrom = "normal";
                                        $('#book-dialog').dialog('open');
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "import-office":
                                {
                                    name:"Import Office/PDF Document",
                                    exec:function(dtnode){
                                        ColabopadApplication.triggerUpload("yes","import-create-binder");                                           
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }                            
                        };
                        
                        return opt;
                    }
                },
                "offlineperson-creator-cp":{
                    selector:".offlineperson-creator-cp",
                    build:function(){
                        var opt = 
                        {
                            items :
                            {
                            "invite":
                                {
                                    name:"Send Invite",
                                    exec:function(dtnode){
                                        ColabopadApplication.inviteParticipant(dtnode);                                       
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "delete":
                                {
                                    name:"Remove",
                                    exec:function(dtnode){
                                        ColabopadApplication.deleteParticipant(dtnode);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }                        
                        };
                        
                        return opt;
                    }
                },
                "onlineperson-creator-cp-nf":{
                    selector:".onlineperson-creator-cp-nf",
                    build : function(){
                        var opt = 
                        {
                            items :
                            {
                            "leave_student_mode":
                                {
                                    name:"Stop Following",
                                    exec:function(dtnode){
                                        ColabopadApplication.stopFollowing(dtnode.data.id);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "delete":
                                {
                                    name:"Remove",
                                    exec:function(dtnode){
                                        ColabopadApplication.deleteParticipant(dtnode);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "invite":
                                {
                                    name:"Send Invite",
                                    exec:function(dtnode){
                                        ColabopadApplication.inviteParticipant(dtnode);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "import-office":
                                {
                                    name:"Import Office/PDF Document",
                                    exec:function(dtnode){
                                        ColabopadApplication.triggerUpload("yes","import-create-binder");
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }                            
                        };
                        
                        return opt;
                    }
                },
                "onlineperson-creator-cp":{
                    selector:".onlineperson-creator-cp",
                    build : function(){
                        var opt = 
                        {
                            items :
                            {
                            "student_mode":
                                {
                                    name:"Follow",
                                    exec:function(dtnode){
                                        ColabopadApplication.follow(dtnode.data.id);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "delete":
                                {
                                    name:"Remove",
                                    exec:function(dtnode){
                                        ColabopadApplication.deleteParticipant(dtnode);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "invite":
                                {
                                    name:"Send Invite",
                                    exec:function(dtnode){
                                        ColabopadApplication.inviteParticipant(dtnode);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                            "import-office":
                                {
                                    name:"Import Office/PDF Document",
                                    exec:function(dtnode){
                                        ColabopadApplication.triggerUpload("yes","import-create-binder");
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }                            
                        };
                        return opt;                        
                    }
                },
                "phyzixlabs-room-assignment-submission":{
                    selector:".phyzixlabs-room-assignment-submission",
                    build:function(){
                        var opt =
                        {
                            items:
                            {
                                "mark-as-graded-assignment":
                                {
                                    name:"Mark as graded",
                                    exec:function(dtnode){
                                        ColabopadApplication.markAssignmentAsGraded(dtnode.data.context_id,dtnode.data.user_id,dtnode.data.key);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }                            
                            }
                        };
                        
                        if(!isCreator){
                            return false;
                        }
                        
                        return opt;
                    }
                },
                "phyzixlabs-room-assignment":{
                    selector:".phyzixlabs-room-assignment",
                    build:function(){
                        var opt =
                        {
                            items:
                            {
                                "edit-assignment":
                                    {
                                        name:"Edit",
                                        exec:function(dtnode){
                                            ColabopadApplication.dialogOpenFrom = "edit-assignment";
                                            ColabopadApplication.resetAssignmentDialog();
                                            ColabopadApplication.assignment_id = dtnode.data.id;
                                            ColabopadApplication.editAssignment(dtnode.data.id);
                                        },
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    },
                                    "archive-assignment":
                                    {
                                        name:"Archive",
                                        exec:function(dtnode){
                                            ColabopadApplication.dialogOpenFrom = "new_assignment";
                                            ColabopadApplication.archiveAssignment(dtnode.data.id);
                                        },
                                        callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                    }
                            }
                        };
                        
                        if(!isCreator){
                            return false;
                        }                        
                        
                        return opt;
                    }
                },
                "phyzixlabs-room-assignment-root":{
                    selector:".phyzixlabs-room-assignment-root",
                    build:function(){
                        var opt =
                        {
                            items:
                            {
                                "new-assignment":
                                {
                                    name:"New Task",
                                    exec:function(dtnode){
                                        ColabopadApplication.dialogOpenFrom = "new-assignment";
                                        ColabopadApplication.resetAssignmentDialog();
                                        $('#assignment-dialog').dialog('open');
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }
                            }
                        };


                        if(!isCreator){
                            return false;
                        }
                        return opt;
                    }
                },
                "phyzixlabs-room-teamspace":{
                    selector:".phyzixlabs-room-teamspace",
                    build:function(){
                        var opt =
                        {
                            items:{
                                "new-book":
                                {
                                    name:"New Binder",
                                    exec:function(dtnode){
                                        ColabopadApplication.dialogOpenFrom = "teamspace";
                                        $('#book-dialog').dialog('open');
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                                "import-office":
                                {
                                    name:"Import Office/PDF Document",
                                    exec:function(dtnode){
                                        ColabopadApplication.triggerUpload("yes","import-teamspace");
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }    
                            }
                        };
                        
                        
                        if(!isCreator){
                            return false;
                        }
                        
                        return opt;
                    }
                },
                "creatoronlineperson":{
                    selector:".creatoronlineperson",
                    build:function(){
                        var opt =
                        {
                            items:
                            {
                                "invite":
                                {
                                    name:"Send Invite",
                                    exec:function(dtnode){
                                        ColabopadApplication.inviteParticipant(dtnode);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                                "new-book":
                                {
                                    name:"New Binder",
                                    exec:function(dtnode){
                                        ColabopadApplication.dialogOpenFrom = "normal";
                                        $('#book-dialog').dialog('open');
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                                "import-office":
                                {
                                    name:"Import Office/PDF Document",
                                    exec:function(dtnode){
                                        ColabopadApplication.triggerUpload("yes","import-create-binder");
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }           
                            }
                        };
                        
                        return opt;
                    }
                },
                "offlineperson":{
                    selector:".offlineperson",
                    build:function(){
                        var opt = 
                        {
                            items :
                            {
                                "security":
                                {
                                    name:"Grant Access",
                                    exec:function(dtnode){
                                        ColabopadApplication.manageAccess(dtnode.data.id,-1,dtnode.data.title);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }                                 
                            }                            
                        };
                        return opt;
                    }
                },
                "vroomtitle":{
                    selector:".vroomtitle,.phyzixlabs-room-root",
                    build:function(){
                        var opt =
                        {
                            items:{
                                "new":
                                {
                                    name:"Add Participant",
                                    exec:function(dtnode){
                                        $('#new-participant-dialog').dialog("open");
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                                "load_users":
                                {
                                    name:"Load Participants from file",
                                    exec:function(dtnode){
                                        $('#load-users-dialog').dialog("open");
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                },
                                "rename":
                                {
                                    name:"Rename",
                                    exec:function(dtnode){
                                        $('#room-title-dialog').dialog("open");
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }  
                            }
                        };
                        
                        if(!isCreator){
                            return false;
                        }                        
                        return opt;
                    }
                },
                "onlineperson-nf":{
                    selector:".onlineperson-nf",
                    build:function(){
                        var opt = 
                        {
                            items :
                            {
                                "leave_student_mode":
                                {
                                    name:"Stop Following",
                                    exec:function(dtnode){
                                        ColabopadApplication.stopFollowing(dtnode.data.id);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }                                 
                            }                            
                        };

                        return opt;
                    }
                },
                "onlineperson":{
                    selector:".onlineperson",
                    build:function(){
                        var opt = 
                        {
                            items :
                            {
                                "student_mode":
                                {
                                    name:"Follow",
                                    exec:function(dtnode){
                                        ColabopadApplication.follow(dtnode.data.id);
                                    },
                                    callback:function(key, opt){opt.commands[key].exec($.ui.dynatree.getNode(opt.$trigger))}
                                }                                 
                            }                            
                        };

                        return opt;
                    }
                }
            };

            
            for(var key in this.contextMenuBindings){
                $.contextMenu(this.contextMenuBindings[key]);
            }
   }
}
