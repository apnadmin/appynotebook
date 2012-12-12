<%-- 
    Document   : resendpwd
    Created on : Jan 11, 2011, 1:55:20 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Recover Password</title>
	<link type="text/css" href="../js/jquery-ui-1.8.16.custom/css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
	<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-1.6.2.min.js"></script>
	<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom/js/jquery-ui-1.8.16.custom.min.js"></script>

        <!--JQ blockui -->
        <script type="text/javascript" src="../js/jquery-plugins/blockui/jquery.blockUI.js"></script>


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
        if($('#j_password').attr("value") != '' && $('#j_username').attr("value") != ''){
            return(echeck($('#j_username').attr("value")));
        }
        alert('Please fill-out all required fields')
        return false;
    }
</script>
        <script type="text/javascript">

            $(function(){
             $('#login-dialog').dialog({
                autoOpen: true,
                modal:true,
                width: 350,
                buttons: {
                    "Recover Password": function() {
                        if(validate()){
                                $.blockUI({css:{},overlayCSS: { backgroundColor: '#666666',opacity:.2 },theme:true,message: '<h1><img src="img/busy.gif" />Recovering password,please wait...</h1>' });
                                $.ajax({
                                    type:'POST',
                                    data:{
                                          emailAddress:$('#j_username').attr("value")
                                        },
                                    url:'/UserAction.do?action=recover-password',
                                    success:function(data){
                                        $.unblockUI();
                                        var reply = eval('('+data+')');
                                        if(reply.status == 'success'){
                                            alert('Check your e-mail for password');
                                            $('#login-dialog').dialog("close");

                                            window.location.href = '../sc/nd/';
                                        }
                                        else
                                            alert('There was a problem sending password, please ensure your e-email address is correct.')
                                    }
                                });
                        }
                    },
                    "Cancel": function() {
                        $('#login-dialog').dialog("close");
                        window.location.href = '/';
                    }
                }
             }).siblings('div.ui-dialog-titlebar').remove();
             $("#footer").css("margin-top",$(window).height()*.7);
            });
        </script>
    </head>
    <body style="background:url(../img/bg_dotted.png)">

        
          <div id="login-dialog" title="Recover Password" style="display:none;">
              
                <table style="border-width:1px;border-color:#f6f6f6">
                    <tr>
                        <td class="signup-label">E-mail*:</td><td><input type="text" name="j_username" id="j_username" size="32" /></td>
                    </tr>
                </table>
              
           </div>
        
            <div id="footer" style="margin-top:auto">
            <p style="color:silver;">Copyright &copy; APPYnotebook Software. All rights reserved</p>
            </div>
    </body>
</html>
