<%-- 
    Document   : roomlogin
    Created on : Apr 12, 2009, 7:30:58 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>      
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Log-In</title>
	<link type="text/css" href="../js/jquery-ui-1.8.16.custom/css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
	<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-1.6.2.min.js"></script>
	<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-ui-1.8.16.custom.min.js"></script>



    <style type="text/css">
        body {
            font-family: Verdana, Arial, sans-serif;
            font-size:80%;
        }


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
                font-size: 75%;
        }
    </style>
<script type="text/javascript">
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
        if($('#j_password').attr("value") != '' && $('#j_username').attr("value") != ''){
            return(echeck($('#j_username').attr("value")));
        }
        alert('Please fill-out all required fields')
        return false;
    }
</script>
        <script type="text/javascript">

            $(function(){
                var t = "<%= request.getSession().getAttribute("pr")%>";
                if(<%=(request.getSession().getAttribute("oa") != null)%>){
                    $("#j_username").val("<%= ""+request.getSession().getAttribute("u") %>");
                    $("#j_password").val("<%= ""+request.getSession().getAttribute("p") %>");
                    document.authform.submit();return;
                }
                $( "#anonymous-signin-btn" ).button({
                        text: true
                }).click(function(){
                    window.location.href = '../as/';
                });                
                
             $('#login-dialog').dialog({
                autoOpen: true,
                width: 340,
                modal:true,
                buttons: {
                    "Cancel": function() {
                        $('#login-dialog').dialog("close");
                        window.location.href = '/';
                    }
                   <% if(com.feezixlabs.util.ConfigUtil.allow_user_account_creation){%>
                    ,
                    "Sign-Up":function(){
                        window.location.href = '../na';
                    }
                    <%}%>
                    ,
                    "Recover Password":function(){
                        window.location.href = '../rsp';
                    },
                    "Log-In": function() {
                        if(validate()){
                            $('#login-dialog').dialog("close");
                            document.authform.submit();
                        }
                    }
                }
             }).siblings('div.ui-dialog-titlebar').remove();
             $("#footer").css("margin-top",$(window).height()*.7);
             
            });
            
            
        </script>
    </head>
    <body style="background:url(../img/bg_dotted.png)">

        
        <div id="login-dialog" title="Log-In" style="display:none;">
            <button id="anonymous-signin-btn" style="width:100%;font-size:16px"><h2 style="padding:4px">Sign-In Anonymously</h2></button>
            <h1 style="text-align:center">-OR-</h1>
            <%if(request.getAttribute("login-error") != null){%>
            <span style="color:red;text-align: center">*Login Error</span>
            <%}%>
            <form method="post" name="authform" action="j_security_check">
            <table style="border-width:1px;border-color:#f6f6f6">
                <tr>
                    <td class="signup-label" colspan="2"  style="text-align:left;padding-left:4px;font-size:14px;font-weight:bold">Use your existing account</td>
                </tr>                
                <tr>
                    <td class="signup-label">E-mail*:</td><td><input type="text" name="j_username" id="j_username" size="32" /></td>
                </tr>
                <tr>
                    <td class="signup-label">Password*:</td><td><input type="password" name="j_password" id="j_password" size="32" /></td>
                </tr>
            </table>
            </form>
        </div>
       
        <div id="footer" style="margin-top:auto">
            <p style="color:silver;">Copyright &copy; Phyzixlabs Software. All rights reserved</p>
         </div>
    </body>
</html>
