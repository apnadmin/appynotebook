<!--
To change this template, choose Tools | Templates
and open the template in the editor.
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>colabopad.com</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="icon" type="../image/png" href="favicon.png" />

	<link type="text/css" href="../js/jquery-ui-1.7.1.custom/css/start/jquery-ui-1.7.1.custom.css" rel="stylesheet" />
	<script type="text/javascript" src="../js/jquery-ui-1.7.1.custom/js/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="../js/jquery-ui-1.7.1.custom/js/jquery-ui-1.7.1.custom.min.js"></script>
    <script type="text/javascript" src="../js/jquery-plugins/timepicker/jquery.clock.js"></script>

    <!--JQ blockui -->
    <script type="text/javascript" src="../js/jquery-plugins/blockui/jquery.blockUI.js"></script>

    <style type="text/css">
        #bread {
            color: #ccc;
            padding: 3px;
            margin-bottom: 25px;
            margin-top:10px;
            }

        #bread ul {
            margin-left: 0;
            padding-left: 0;
            display: inline;
            border: none;
            }

        #bread ul li {
            margin-left: 0;
            padding-left: 2px;
            border: none;
            list-style: none;
            display: inline;
            }
        body {
            background-image:url(../img/header.png);
            background-repeat:repeat-x;
            font-family: Verdana, Arial, sans-serif;
            font-size: .6em;
        }


        #footer {
                margin: 40px auto 0 auto;
            text-align: center;
            border-top: dotted 1px gray;
            padding: 20px 0 20px 0;
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
        if($('#roomLabel').attr("value") != '' && $('#firstName').attr("value") != '' && $('#lastName').attr("value") != '' && $('#emailAddress').attr("value") != ''){
            return(echeck($('#emailAddress').attr("value")));
        }
        alert('Please fill-out all fields')
        return false;
    }
</script>

    <script type="text/javascript">
        $(function(){
            $("#create-room-btn")
            .hover(
                function(){
                    $(this).attr("src","../img/create-room-btn-hlt.png");
                },
                function(){

                    $(this).attr("src","../img/create-room-btn.png");
                }
            );


            /*
            $('#video-tour-frame').dialog({
                autoOpen: false,
                width: 450,
                height:400
            });



            $("#video-tour-btn")
            .hover(
                function(){
                    $(this).attr("src","img/vid-tour-neg.png");
                },
                function(){
                    $(this).attr("src","img/vid-tour.png");
                }
            );


             $("#video-tour-btn").click(function(){
                $('#video-tour-frame').dialog("open");
             });*/

             $('#create-room-dialog').dialog({
                autoOpen: false,
                width: 450,
                buttons: {
                    "Create Room": function() {
                        if(validate()){
                            $('#create-room-dialog').dialog("close");
                            $.blockUI({css:{ backgroundColor: '#b7ee21', color: '#fff'},message: '<h1><img src="../img/busy.gif" />Creating Account,please wait...</h1>' });
                            $.ajax({
                                type:'POST',
                                data:{"roomLabel":$('#roomLabel').attr("value"),
                                      "firstName":$('#firstName').attr("value"),
                                      "lastName":$('#lastName').attr("value"),
                                      "emailAddress":$('#emailAddress').attr("value"),
                                      "dev":true},
                                url:'../actionProcessor.jsp?action=create-room',
                                success:function(data){
                                    $.unblockUI();
                                    jsonobj = eval('('+data+')');

                                    if(jsonobj.status=='success'){
                                        alert('Room created, you\'ll now be redirected to room.\n Please remember to check your e-mail for access link.');
                                        window.location =jsonobj.login_url;
                                    }else{
                                        alert('There was a problem creating room,please try again.\nIf problem persist, please contact support@colabopad.com');
                                    }
                                }
                            });
                        }
                    },
                    "Cancel": function() {
                        $('#create-room-dialog').dialog("close");
                    }
                }
             });
             $("#create-room-btn").click(function(){
                $('#create-room-dialog').dialog("open");
             });
        });

        function createDevAccount(){
            $('#create-room-dialog').dialog("open");
        }
    </script>


  </head>
  <body>
      <a href="../index.jsp"><img style="border-style:none" src="../img/logo.png"></a>

      <!--
      <div style="margin-top:3em;font-size:16px">
        Colabopad now has a developer API for developing widgets that can be deployed into Colabopad. Using simple Javascript and HTML, a developer
        can create useful widgets that take advantage of the interactive and collaborative features of Colabopad. The developer need not concern themselves
        with any of the underlaying intricacies of Colabopad messaging.

        <H1><a href="#" onclick="createDevAccount()">Sign-up for Developer account</a></H1>

      </div>
      -->
      <p style="font-size:16px">
          <span style="font-size:3em">FYI</span></br>
          ColaboPad is Open Source, the code would be released soon.
      </p>

      

      <div id="create-room-dialog" title="Create Account">
            <table>
                <tr>
                    <td>Room Title:</td><td><input type="text" name="roomLabel" id="roomLabel" /></td>
                </tr>
                <tr>
                    <td>First Name:</td><td><input type="text" name="firstName" id="firstName"/></td>
                </tr>
                <tr>
                    <td>Last Name:</td><td><input type="text" name="lastName" id="lastName" /></td>
                </tr>
                <tr>
                    <td>E-mail:</td><td><input type="text" name="emailAddress" id="emailAddress" /></td>
                </tr>
            </table>
       </div>


        <div id="footer">
            <p>Copyright &copy; 2009 <a href="contact.jsp">Contact</a> <%--| <a href="">Blog</a>--%></p>
        </div>
  </body>
</html>
