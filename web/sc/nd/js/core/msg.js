/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

ColabopadApplication.MsgHandler={
   enabled:true,
   json2Txt:function(jsonobj){
        return jQuery.toJSON(jsonobj);
   },
   txt2JSON:function(jsontxt){
        return jQuery.evalJSON(jsontxt);
   },
   toJSON:function(txt){
       return this.txt2JSON(txt);
   },
   sendMessage:function(message){
        if(this.enabled){
            //message.config = "";
            //message.transform = "";
            var txtMsg = '<![CDATA['+this.json2Txt(message.message)+']]>';
            //var txtMsg = '<![CDATA[{"type":"test","sender_id"}]]>';//  '<![CDATA['+this.json2Txt(message.message)+']]>';//message.sender_id!=undefined?jQuery.toJSON(message):message;
            try{
                amq.sendMessage('topic://'+message.to,txtMsg);
            }catch(Error){
                alert('An error occured while sending message. exception:'+Error);
            }
        }
   },
   registerListener:function(listener){
       //log('registerListener enabled:'+this.enabled+' id:'+listener.id)
       if(this.enabled){
            //this.unregisterListener(listener.id);
            try{
                listener._rcvMsg=function(message){
                    //log('received :'+message.nodeValue);
                    var objMsg = jQuery.evalJSON(message.nodeValue);
                    listener.rcvMessage(objMsg);
                };
                //listener._rcvMsg.rcvMessage = listener.rcvMessage;
                amq.addListener(listener.id,'topic://'+listener.destination,listener._rcvMsg);
            }catch(error){
                alert('error registering listener, exception:'+error);
            }
       }
   },
   unregisterListener:function(listener){
        try{
            if(this.enabled)
              amq.removeHandler(listener.id?listener.id:listener);
        }catch(ex){}
   }
};

/*ColabopadApplication.MsgHandler={
   enabled:true,
   json2Txt:function(jsonobj){
        return jQuery.toJSON(jsonobj);
   },
   txt2JSON:function(jsontxt){
        return jQuery.evalJSON(jsontxt);
   },
   toJSON:function(txt){
       return this.txt2JSON(txt);
   },
   sendMessage:function(message){
        if(this.enabled){
            var txtMsg = '<![CDATA['+this.json2Txt(message.message)+']]>';//message.sender_id!=undefined?jQuery.toJSON(message):message;
            try{
                amq.sendMessage('topic://'+message.to,txtMsg);
            }catch(Error){
                alert('An error occured while sending message. exception:'+Error);
            }
        }
   },
   registerListener:function(listener){
       //log('registerListener enabled:'+this.enabled+' id:'+listener.id)
       if(this.enabled){
            //this.unregisterListener(listener.id);
            try{
                listener._rcvMsg=function(message){
                    //log('received :'+message.nodeValue);
                    var objMsg = jQuery.evalJSON(message.nodeValue);
                    listener.rcvMessage(objMsg);
                };
                //listener._rcvMsg.rcvMessage = listener.rcvMessage;
                amq.addListener(listener.id,'topic://'+listener.destination,listener._rcvMsg);
            }catch(error){
                alert('error registering listener, exception:'+error);
            }
       }

        
        var client = Stomple.create_client({
            url : "ws://localhost:61614/stomp",
            destination : "jms.topic."+listener.destination,
            login : "guest",
            passcode : "password"
        });
        
        client.subscribe({
            success: function(frame) {//called if subscribe succeeds within timeout-period
                //subscribe succeeded... do something
                alert('success');
            },
            failure: function(spec) {//called if subscribe fails or times out
                console.log('log:'+spec);
            },
            handler: function(msg) {//called when a message arrived ('this' is scope - see below)
                //this.received = msg.body;//"this" is "someObject"
                var objMsg = jQuery.evalJSON(msg.body);
                listener.rcvMessage(objMsg);
            },
            scope: listener
        });
   },
   unregisterListener:function(id){
        try{
            if(this.enabled)
              amq.removeHandler(id);
        }catch(ex){}
   }
};*/