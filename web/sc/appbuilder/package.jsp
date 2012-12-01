<%-- 
    Document   : package
    Created on : Dec 19, 2010, 5:10:51 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Package</title>
        <script type="text/javascript" src="../../../js/safe-jquery-1.6.2.min.js"></script>
        <script type="text/javascript">
	    var checkCount =0;
            var _destURL = '';            
            
            function package_applets(widgets,lines,applet_package_name,
                                                   applet_package_version,
                                                   applet_package_description,
                                                   applet_package_license,
                                                   applet_package_domain,
                                                   production_use_only,
                                                   ebook_package_export){//alert('svg poster:'+svg)
                
                
                $('#widgets').attr("value",widgets);
                $('#lines').attr("value",lines);

                $('#applet_package_name').attr("value",applet_package_name);
                $('#applet_package_version').attr("value",applet_package_version);
                $('#applet_package_description').attr("value",applet_package_description);
                $('#applet_package_license').attr("value",applet_package_license);
                $('#applet_package_domain').attr("value",applet_package_domain);
                $('#production_use_only').attr("value",production_use_only);
                $('#ebook_package_export').attr("value",ebook_package_export);
                document.packager.submit();
                startProgressCheck();
            }
            
            
            function make_ebook(room_id,binder_ids,app_ids,content_only,destURL,zipFileName,zipUUID){
                
                
                
                if(destURL)
                    _destURL = destURL;
                
                $('#widgets').attr("value",app_ids); 
                $('#binders').attr("value",binder_ids);
                $('#content_only').attr("value",content_only); 
                $("#room_id").val(room_id);
                
                //alert(zipFileName)
                if(zipFileName)
                    $("#zipfile_name").val(zipFileName);
                if(zipUUID)
                    $("#zipfile_uuid").val(zipUUID);
                
                document.packager.submit();
                startProgressCheck(destURL);
            }
            
            
	    function checkStatus(){
                if(checkCount > 60){
                    if(top.ColabopadApplication)
                        top.ColabopadApplication.onPackageComplete();
                    else
                        top.appletBuilder.onPackageComplete();
                    
                    return;
                }
		
		checkCount++;
                $.ajax({
                    type:'POST',
		    dataType: 'jsonp',
		    //jsonp:"checkAbort"
                    data:{},
                    url:_destURL+'package-status.jsp',
                    success:function(data){

                    }
                });
             };

	    function checkAbort(data){
		var reply = data;
                if(reply.status == "done"){
                    if(top.ColabopadApplication)
                        top.ColabopadApplication.onPackageComplete();
                    else
                        top.appletBuilder.onPackageComplete();
                }
	        else
		if(reply.status == "error"){
                    if(top.ColabopadApplication)
                        top.ColabopadApplication.onPackageError(reply.error.type,reply.error.stack_trace);
                    else
                        top.appletBuilder.onPackageError(reply.error.type,reply.error.stack_trace);
		}
		else
		{
		    setTimeout(checkStatus,1000);
		}
	    }

            function startProgressCheck(destURL){	
                   setTimeout(checkStatus,1000);                
            }            
        </script>
    </head>
    <body>
        <form method="post" name="packager" action="package-applets.jsp">
            <input type="hidden" id="applet_package_name" name="applet_package_name">
            <input type="hidden" id="applet_package_version" name="applet_package_version">
            <input type="hidden" id="applet_package_description" name="applet_package_description">
            <input type="hidden" id="applet_package_license" name="applet_package_license">
            <input type="hidden" id="applet_package_domain" name="applet_package_domain">
            <input type="hidden" id="production_use_only" name="production_use_only">
            <input type="hidden" id="ebook_package_export" name="ebook_package_export">
            <input type="hidden" id="widgets" name="widgets">
            <input type="hidden" id="lines" name="lines">
            
            <input type="hidden" id="room_id" name="room_id">
            <input type="hidden" id="binders" name="binders">  
            <input type="hidden" id="content_only" name="content_only">  
            
            <input type="hidden" id="zipfile_name" name="zipfile_name"> 
            <input type="hidden" id="zipfile_uuid" name="zipfile_uuid"> 
        </form>
    </body>
</html>
