/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

var App_CallBack_Interface = {
               async_onMessage:function(widget,pad,message){
                    setTimeout(function(){
                            widget.onMessage(pad,message);
                    },0);
               },
               async_onScreenMouseEnter:function (applet,pad,p,event){
                    setTimeout(function(){
                          applet.onScreenMouseEnter(pad,p,event);
                    },0);
               },
               async_onScreenMouseOut:function(applet,pad,p,event){
                    setTimeout(function(){
                          applet.onScreenMouseOut(pad,p,event);
                    },0);
               },
               async_onScreenMouseDown:function(applet,pad,p,event){
                    setTimeout(function(){
                          applet.onScreenMouseDown(pad,p,event);
                    },0);
               },
               async_onScreenMouseMove:function(applet,pad,p,event){
                    setTimeout(function(){
                          applet.onScreenMouseMove(pad,p,event);
                    },0);
               },
               async_onScreenMouseUp:function(applet,pad,p,event){
                    setTimeout(function(){
                          applet.onScreenMouseUp(pad,p,event);
                    },0);
               },
               async_onTranslate:function(pad,applet,applet_instance,delta,complete){
                  setTimeout(function(){
                      applet.onTranslate(pad,applet_instance,delta,complete);
                  },0);
               },
               async_onScale:function(pad,applet,applet_instance,delta,complete){
                  setTimeout(function(){
                      applet.onScale(pad,applet_instance,delta,complete);
                  },0);
               },
               async_onRotate:function(pad,applet,applet_instance,delta,complete){
                  setTimeout(function(){
                      applet.onRotate(pad,applet_instance,delta,complete);
                  },0);
               }
}
