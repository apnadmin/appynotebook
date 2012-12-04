/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
ColabopadApplication.PageTemplate={
   newBoardGame:function(name){
     var widget = ColabopadApplication.getSystemWidget(name);
     if(widget != null)
     ColabopadApplication.newWidget(widget.id,ColabopadApplication.getEnv());
   },
   clearBoardGame:function(){
       
   }
};

