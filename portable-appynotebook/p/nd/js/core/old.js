/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
        if(message.sender_id !=  sessionId){//don't process messages from this client

            var sinkPad = null;
            if(message.content_update_msg != undefined && message.content_update_msg){
                if(colabopad.remoteEditor(message.sender_id)){
                    if(message.src_view == 1)
                        sinkPad = colabopad.current_context.pad;
                    else
                    if(colabopad.subscribed_to == message.sender_id||colabopad.editor_to == message.sender_id)
                        sinkPad = colabopad.current_context.foriegnPad;
                    else
                        return;
                }
                else
                if(colabopad.subscribed_to == message.sender_id){
                    if(message.src_view == 0)
                        sinkPad = colabopad.current_context.foriegnPad;
                    else
                        return;
                }
                else
                if(colabopad.editor_to == message.sender_id){
                    if(message.src_view == 0)
                        sinkPad = colabopad.current_context.foriegnPad;
                    else
                        return;
                }
            }else{
                sinkPad = colabopad.remoteEditor(message.sender_id)?colabopad.current_context.pad:colabopad.current_context.foriegnPad;
            }

            catchStrokes =
            (
              (message.src_view==0 && (colabopad.subscribed_to == message.sender_id || colabopad.editor_to == message.sender_id)) ||
              (message.src_view==1 && colabopad.remoteEditor(message.sender_id))
            );

            if(message.editor_to != null && message.editor_to != sessionId){
                if(message.editor_to == colabopad.subscribed_to && message.src_view==1){
                    //update my subscriber view
                    sinkPad = colabopad.current_context.foriegnPad;
                    catchStrokes=true;
                }
                else
                if(message.editor_to == colabopad.editor_to  && message.src_view==1){
                    //update my editor view, which is again secondary view
                    sinkPad = colabopad.current_context.foriegnPad;
                    catchStrokes=true;
                }
            }

            if(message.type=='new-element'){
                if(catchStrokes){
                    colabopad.insertContentElement(sinkPad, message.config,colabopad.remoteEditor(message.sender_id) || colabopad.editor_to == message.sender_id)
                }
            }
            else
            if(message.type=='shape-fill'){

                if(catchStrokes){
                    newNode = sinkPad.svg_doc.getElementById(message.element_id).firstChild;
                    if(newNode.colabopaddata != undefined)newNode.colabopaddata.pen.fill = message.pen.fill;
                    newNode.setAttribute("fill",message.pen.fill);
                }
            }
            else
            if(message.type=='delete-element'){
                if(catchStrokes){
                    sinkPad.svg_doc.remove(sinkPad.svg_doc.getElementById(message.element_id));
                    if(sinkPad != colabopad.current_context.foriegnPad){
                       for(i=0;i<sinkPad.content_blocks.length;i++){
                          if(sinkPad.content_blocks[i].type != 'widget' && sinkPad.content_blocks[i].element_id==message.element_id){
                              sinkPad.content_blocks.splice(i,1);break;
                          }
                       }
                    }
                }
            }
            else
            if(message.type=='insert-widget'){
                if(catchStrokes){
                    ColabopadApplication.addWidgetInstance(message.content.config,sinkPad);
                    message.content.config.incoming = true;
                }
            }
            else
            if(message.type=='translate-widget' && catchStrokes){
                colabopad.translateWidget(message.trsltcoord,message.widget_instance_id,sinkPad);
            }
            else
            if(message.type=='delete-widget'){
                if(catchStrokes){
                    colabopad.deleteWidget(message.widget_instance_id,sinkPad);

                    if(sinkPad != colabopad.current_context.foriegnPad){
                         for(j=0;j<sinkPad.content_blocks.length;j++){
                              if( (sinkPad.content_blocks[j].type == 'widget') && sinkPad.content_blocks[j].widget_instance_id==message.widget_instance_id){
                                  sinkPad.content_blocks.splice(j,1);break;
                              }
                         }
                    }
                }
            }
            else
            if(message.type=='msg-for-widget'){
                colabopad.onWidgetMessage(message.classid,message.env,message.message);
            }
            else
            if(message.type=='new-page'){
                if(catchStrokes){
                    colabopad.loadContentBlocks(message.template,message.content_blocks,colabopad.editor_to == message.sender_id);
                }
            }
            else
            if(message.type=='subscribe-to'){
                if(my_pid==message.pid){//someone wants to subscribe to your pad
                    if(confirm('User "'+message.subscriber_name+'" wants to subscribe to your pad, allow?')){
                        this.acceptSubscribeRequest();
                    }else{
                        this.amqInterface.sendMessage({sender_id:sessionId,receiver_id:message.sender_id,publisher_name:myName,type:'subscribe-to-resp',response:'rejected'});
                    }
                }
            }
            else
            if(message.type=='check-out'){
                if(my_pid==message.pid){//someone wants to checkout your pad
                    if(confirm('User "'+message.subscriber_name+'" wants to edit your pad, allow?')){
                        colabopad._subscriber_count++;
                        colabopad.remote_editor_ids.push(message.sender_id);
                        this.amqInterface.sendMessage({sender_id:sessionId,receiver_id:message.sender_id,publisher_name:myName,type:'check-out-resp',response:'accepted',template:colabopad.current_context.pad.template,content_blocks:colabopad.current_context.pad.content_blocks});
                    }else{
                        this.amqInterface.sendMessage({sender_id:sessionId,receiver_id:message.sender_id,publisher_name:myName,type:'check-out-resp',response:'rejected'});
                    }
                }
            }
            else
            if(message.type=='subscribe-to-resp'){
                if(message.receiver_id==sessionId){

                    if(message.response=='rejected'){
                        alert('User "'+message.publisher_name+'" rejected your subscription request.');
                    }
                    else
                    if(message.response=='accepted')
                    {
                       alert('request accepted:'+message.publisher_name)
                       $('#tabs').tabs('enable' , 1);
                       $('#tabs').tabs('select' , 1);
                       $('#buddy-tab-title').html(message.publisher_name)
                       colabopad.loadContentBlocks(message.template,message.content_blocks);
                       colabopad.subscribed_to = message.sender_id;
                    }
                }
            }
            else
            if(message.type=='check-out-resp'){
                if(message.receiver_id==sessionId){
                    if(message.response=='rejected'){
                        alert('User "'+message.publisher_name+'" rejected your edit request.');
                    }
                    else
                    if(message.response=='accepted')
                    {
                       $('#tabs').tabs('enable' , 1);
                       $('#tabs').tabs('select' , 1);
                       $('#buddy-tab-title').html(message.publisher_name)

                       colabopad.loadContentBlocks(message.template,message.content_blocks,true);
                       colabopad._subscriber_count++;
                       colabopad.editor_to = message.sender_id;
                    }
                }
            }
            else
            if(message.type=='add-participant'){
                rootNode = $("#participant-treecontrol").dynatree('getTree').getNodeByKey('roomHeaderNode');
                rootNode.append(message.dtNode);
                bindColabopadContextMenu();//rebind context menu
                $.ajax({type:'POST',url:'actionProcessor.jsp?action=reload-participants'});
            }
            else
            if(message.type=='del-participant'){
                $("#participant-treecontrol").dynatree('getTree').getNodeByKey(message.nodeKey).remove();
                $.ajax({type:'POST',url:'actionProcessor.jsp?action=reload-participants'});
            }
        }

