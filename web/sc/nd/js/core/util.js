/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

ColabopadApplication.Utility={
    /**
     * DHTML email validation script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
     */
   validate_email_address:function(str) {

		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)
		if (str.indexOf(at)==-1){
		   alert("Invalid E-mail Address")
		   return false
		}

		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		   alert("Invalid E-mail Address")
		   return false
		}

		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
		    alert("Invalid E-mail Address")
		    return false
		}

		 if (str.indexOf(at,(lat+1))!=-1){
		    alert("Invalid E-mail Address")
		    return false
		 }

		 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		    alert("Invalid E-mail Address")
		    return false
		 }

		 if (str.indexOf(dot,(lat+2))==-1){
		    alert("Invalid E-mail Address")
		    return false
		 }

		 if (str.indexOf(" ")!=-1){
		    alert("Invalid E-mail Address")
		    return false
		 }

 		 return true
	},
    cloneTransformationObject:function(trs){
        return {trslt:{x:trs.trslt.x,y:trs.trslt.y},rotate:{cx:trs.rotate.cx,cy:trs.rotate.cy,angle:trs.rotate.angle},scale:{x:trs.scale.x,y:trs.scale.y}};
    },
    getStrokeMinx:function(vals){
        var min = vals[0][0];
        for(var i=0;i<vals.length;i++){
            if(vals[i]<min)
                min = vals[i][0];
        }return min;
    },
    getStrokeMaxx:function(vals){
        var max = vals[0][0];
        for(var i=0;i<vals.length;i++){
            if(vals[i]>max)
                max = vals[i][0];
        }return max;
    },
    getStrokeMiny:function(vals){
        var min = vals[0][1];
        for(var i=0;i<vals.length;i++){
            if(vals[i]<min)
                min = vals[i][1];
        }return min;
    },
    getStrokeMaxy:function(vals){
        var max = vals[0][1];
        for(var i=0;i<vals.length;i++){
            if(vals[i]>max)
                max = vals[i][1];
        }return max;
    },
    getStrokeBound:function(points){
        return {x:this.getStrokeMinx(points),y:this.getStrokeMiny(points),w:this.getStrokeMaxx(points)-this.getStrokeMinx(points),h:this.getStrokeMaxy(points)-this.getStrokeMiny(points)};
    },
    cloneElement:function(element)
    {
        var clone = this.cloneDOMFreeJSON(element);
        clone.element_id = 'grp'+(new Date).getTime();
        clone.svgid      = (new Date()).getTime();
        delete clone.dbid;
        return clone;
    },
    cloneDOMFreeJSON:function(o) {
        //log("json:"+jQuery.toJSON(o));
        return  eval("("+jQuery.toJSON(o)+")");   //eval(uneval(o));
    }
};
