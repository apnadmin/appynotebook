<!--
To change this template, choose Tools | Templates
and open the template in the editor.
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Home</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="icon" type="image/png" href="favicon.png" />

    <link type="text/css" href="js/jquery-ui-1.8.16.custom/css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
    <script type="text/javascript" src="js/jquery-ui-1.8.16.custom/js/jquery-1.6.2.min.js"></script>
    <script type="text/javascript" src="js/jquery-ui-1.8.16.custom/js/jquery-ui-1.8.16.custom.min.js"></script>
    <script type="text/javascript" src="js/jquery-plugins/timepicker/jquery.clock.js"></script>

    <!--JQ blockui -->
    <script type="text/javascript" src="js/jquery-plugins/blockui/jquery.blockUI.js"></script>

    <script type="text/javascript" src="js/jquery-plugins/jquery.cycle/jquery.cycle.all.min.js"></script>


    <style type="text/css">
        body {
          
            font-family: Verdana, Arial, sans-serif;
            font-size: .6em;
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
            background-image:url(img/header.png);
            background-repeat:repeat-x;
            background-position: 20px 0;
            padding-left:-10px;
            margin-left:15em;
            margin-right:15em;
            min-width:700px;
        }
        #mainframe {
            background-image:url(img/half-ring.png);
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

    </style>


    <script type="text/javascript">
        $(function(){

                $( "#create-account-btn" ).button({
			text: true,
			icons: {
				primary: "ui-icon-person"
			}
		}).click(function(){
                    window.location.href = 'na';
                });
                $( "#sign-in-btn" ).button({
			text: true,
			icons: {
				primary: "ui-icon-unlocked"
			}
		}).click(function(){
                    window.location.href = 'sc/nd/';
                });

        });
    </script>


  </head>
  <body style="background:url(img/bg_dotted.png)">
      <div style="margin-top:10%;text-align: center">
          <h1><%=com.feezixlabs.util.ConfigUtil.installation_name %></h1>
          <% if(com.feezixlabs.util.ConfigUtil.allow_user_account_creation){%>
            <button id="create-account-btn">Sign Up</button>
          <%}%>
            <button id="sign-in-btn">Login</button>
      </div>
      <div style="text-align:center;margin-top:96px">
           <span style="font-weight:bold;font-size:1.3em;color:#b3b3b3;">Supported Browsers</span><br/><br/>

           <a href="http://www.mozilla.com/en-US/" title="Mozilla Firefox" target="new window"><img  src="img/Firefox-logo.png" style="border-style:none"/></a>
           <a href="http://www.google.com/chrome" title="Google Chrome" target="new window"><img  src="img/chrome.png" style="border-style:none"/></a>
           <a href="http://www.apple.com/safari/" title="Apple Safari" target="new window"><img  src="img/Apple_Safari-89.png" style="border-style:none"/></a>
           

           <!--
           <ul style="list-style:none;display:inline;">            
            <li style="display:inline"><a href="http://www.mozilla.com/en-US/" title="Mozilla Firefox" target="new window"><img  src="img/Firefox-logo-22.png" style="border-style:none"/></a></li>
            <li style="display:inline"><a href="http://www.google.com/chrome" title="Google Chrome" target="new window"><img  src="img/chrome-22.png" style="border-style:none"/></a></li>
            <li style="display:inline"><a href="http://www.apple.com/safari/" title="Apple Safari" target="new window"><img  src="img/Apple_Safari-22.png" style="border-style:none"/></a></li>
            <li style="display:inline"><a href="http://www.opera.com/" title="Opera" target="new window"><img  src="img/Opera_logo-22.png" style="border-style:none"/></a></li>
           </ul>
           -->
      </div>
      <div id="footer" style="margin-top:20px">
            <p style="color:silver;">Copyright &copy; Phyzixlabs Software. All rights reserved</p>
      </div>            
  </body>
</html>
