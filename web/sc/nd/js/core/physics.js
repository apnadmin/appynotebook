/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
ColabopadApplication.Physics = {
  worlds:[],
  getWorld:function(id){
     for(var i=0;i<this.worlds.length;i++){
         if(this.worlds[i].id == id)
             return this.worlds[i];
     }return null;
  },
  addObjectToWorld:function(obj,worldId){
     var world = this.getWorld(worldId);
     if(world == null){
         world = {objects:[],id:worldId};
         this.worlds.push(world);
     }world.objects.push(obj);
  },
  resolveContacts:function(obj){
     //determine direction
     //north (theta = 0-deg)

     //north-east (0-deg<theta<90-deg)

     //east (theta = 90-deg)

     //south-east (90-deg<theta<180-deg)

     //south (theta = 180-deg)

     //south-west (180-deg<theta<270-deg)

     //west (theta = 270-deg)

     //north-west (270-deg<theta<360-deg)
  }
};

