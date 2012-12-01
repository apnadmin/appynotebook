<%@page contentType="text/html" pageEncoding="UTF-8"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <%//preserve original intent
        if(request.getSession().getAttribute("u") == null)
            request.getSession().setAttribute("u", request.getParameter("username"));
        if(request.getSession().getAttribute("p") == null)
            request.getSession().setAttribute("p", request.getParameter("password"));
        
        if(request.getSession().getAttribute("lp") == null)
            request.getSession().setAttribute("lp",request.getParameter("lp"));
        if(request.getSession().getAttribute("pr") == null)
            request.getSession().setAttribute("pr",request.getParameter("pr"));
        if(request.getSession().getAttribute("room_id") == null)
            request.getSession().setAttribute("room_id",request.getParameter("room_id"));        
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Account</title>
        <link rel="icon" type="image/png" href="favicon.png" />

	<link type="text/css" href="../js/jquery-ui-1.8.16.custom/css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
	<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-1.6.2.min.js"></script>
	<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-ui-1.8.16.custom.min.js"></script>
        <script type="text/javascript" src="../js/jquery-plugins/timepicker/jquery.clock.js"></script>

        <!--JQ blockui -->
        <script type="text/javascript" src="../js/jquery-plugins/blockui/jquery.blockUI.js"></script>
    <style type="text/css">
          #footer {
            margin: 20px auto 0 auto;
            text-align: center;
            border-top: dotted 1px gray;
            padding: 8px 0 20px 0;
            width: 70%;
        }

        #footer p {
            margin: 0px;
            padding: 0;
        }
        a {
            color: #0e62a2;
        }

        a:hover {
            text-decoration: none;
        }

        #cover{
            background-image:url(../img/header.png);
            background-repeat:repeat-x;
            background-position: 20px 0;
            padding-left:-10px;
            margin-left:15em;
            margin-right:15em;
            min-width:700px;
        }
        #mainframe {
            background-image:url(../img/half-ring.png);
            background-repeat:repeat-y;
            padding-left:2em;
        }
        #container {

            border-style:dashed;
            border-width:1px;
            border-left:0;
            border-color:silver;
        }
        .signup-label{
            text-align:right;
            background-color:#f6f6f6;
        }
        html, body {
                margin: 0;			/* Remove body margin/padding */
                padding: 0;
                overflow: hidden;	/* Remove scroll bars on browser window */
                font-size: 80%;
                font-family: Verdana, Arial, sans-serif;
        }
        
    </style>

<script language = "Javascript">
    /**
     * DHTML email validation script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
     */

   function echeck(str) {

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
	}
</script>
<script type="text/javascript">
    function validate(){
        if($('#fullName').attr("value") != '' && $('#emailAddress').attr("value") != ''){
            return(echeck($('#emailAddress').attr("value")));
        }
        alert('Please fill-out all required fields')
        return false;
    }
</script>

    <script type="text/javascript">
        $(function(){

             $('#create-room-dialog').dialog({
                autoOpen:true,
                modal:true,
                width: 300,
                zIndex:200,
                buttons: {
                    "Sign-Up": function() {
                        if(validate()){
                            //$('#create-room-dialog').dialog("close");
                            $.blockUI({css:{},overlayCSS: { backgroundColor: '#666666',opacity:.2 },theme:true,message: '<h1 style="font-size:1.8em"><img src="../img/busy.gif" />Creating account,please wait...</h1>' });

                            $.ajax({
                                type:'POST',
                                data:{
                                      "name":$('#fullName').attr("value"),
                                      "roomLabel":"Welcome",
                                      "emailAddress":$('#emailAddress').attr("value")},
                                url:'/UserAction.do?action=create-new-user',
                                success:function(data){
                                    $.unblockUI();
                                    
                                    var jsonobj = eval('('+data+')');

                                    if(jsonobj.status=='success'){
                                        $('#create-room-dialog').dialog("close");
                                        //alert(jsonobj.username+","+jsonobj.password);
                                        $("#username").val(jsonobj.username);
                                        $("#password").val(jsonobj.password);
                                        document.autoauthform.submit();
                                        //window.location = 'ou';
                                        //window.location = 'ou?u='+jsonobj.username+"&p="+jsonobj.password;
                                        
                                        //alert('Thank you for submitting a sign-up request.\n Please check your e-mail for access information.');
                                        //window.location = 'sc/nd/index.jsp';
                                    }else{
                                        if(typeof jsonobj.msg != "undefined"){
                                            alert(jsonobj.msg);
                                        }else
                                        alert('There was a problem processing your request,please try again.\nIf problem persist, please contact support.\nmessage:'+jsonobj.msg);
                                    }
                                }
                            });
                        }
                    },
                    "Cancel": function() {
                        $('#create-room-dialog').dialog("close");
                        window.location.href = '/';
                    }
                }
             }).siblings('div.ui-dialog-titlebar').remove();
             $("#footer").css("margin-top",$(window).height()*.7);
        });
    </script>
    </head>
    <body style="background:url(../img/bg_dotted.png)">
          <div id="create-room-dialog" title="Sign-Up" style="display:none;">
                <table style="border-width:1px;border-color:#f6f6f6">
                    <tr>
                        <td class="signup-label">Full Name*:</td><td><input type="text" name="fullName" id="fullName"/></td>
                    </tr>
                    <tr>
                        <td class="signup-label">E-mail*:</td><td><input type="text" name="emailAddress" id="emailAddress" /></td>
                    </tr>
                </table>
           </div>
           <form method="get" name="autoauthform" action="../ou">
             <input type="hidden" name="username" id="username"/>
             <input type="hidden" name="password" id="password"/>
           </form>
           <div id="footer" style="margin-top:auto">
            <p style="color:silver;">Copyright &copy; Phyzixlabs Software. All rights reserved</p>
           </div>        
    </body>
</html>
