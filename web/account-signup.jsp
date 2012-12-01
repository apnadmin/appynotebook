<%-- 
    Document   : account-signup
    Created on : Apr 16, 2012, 2:40:32 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sign Up Request</title>
	<link type="text/css" href="js/jquery-ui-1.8.16.custom/css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
	<script type="text/javascript" src="js/jquery-ui-1.8.16.custom/js/jquery-1.6.2.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.8.16.custom/js/jquery-ui-1.8.16.custom.min.js"></script>
        <script type="text/javascript" src="js/jquery-plugins/blockui/jquery.blockUI.js"></script>
        
        <script type="text/javascript" src="https://js.stripe.com/v1"></script>
        <script type="text/javascript">
                Stripe.setPublishableKey("<%=com.feezixlabs.util.ConfigUtil.stripe_public_key %>");
                function validateEmail(email)
                {
                    var filter=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i ;
                    return filter.test(email) ;
                }

                function phyzixlabs_validate_domain_name(name){
                    if(name == '')return false;
                    var re = /^([a-zA-Z])$/;
                    var nre = /^([0-9])$/;

                    if(name.charAt(0) == '-' || name.charAt(name.length-1) == '-')return false;
                    for(var i=0;i<name.length;i++)
                        if( !re.test(name.charAt(i)) && name.charAt(i) != '-' && !nre.test(name.charAt(i)))return false;
                    return true;
            }
            $(function(){ 
                $("#continue-btn")
                    .hover(
                        function(){
                             $(this).attr("src","sites/default/files/continue-btn-hl.png");
                        },
                        function(){                               
                             $(this).attr("src","sites/default/files/continue-btn.png");
                        }
                    );
                     
                    $('#payment-plan-yrly').change(function(){
                        if($('input[name=payment-plan]').val() != 'payment-plan-yrly')
                            $('input[name=payment-plan]:eq(1)').click();
                        
                        if($(this).val() == 'payment-type-creditcard' /*&& $('#payment-information-form').css('display')=='none'*/){
                            $('#payment-information-form').show('slide');
                        }
                        else
                        //if($('#payment-information-form').css('display') !='none')
                        {
                            $('#payment-information-form').hide('slide');
                        }
                    });
                    
                    $('input[name=payment-plan]').click(function(){
                       if($(this).val() == 'payment-plan-yrly'){
                           if($('#payment-plan-yrly').val() == 'payment-type-creditcard' /*&& $('#payment-information-form').css('display')=='none'*/){
                               $('#payment-information-form').show('slide');
                           }
                           else
                           //if($('#payment-information-form').css('display') !='none')
                           {
                               $('#payment-information-form').hide('slide');
                           }
                       }
                       else
                       //if($('#payment-information-form').css('display') =='none')
                       {
                           $('#payment-information-form').show('slide');
                       }
                    });

                    function phyzixlabs_signup(data){
                            $.ajax({
                                type:'POST',
                                data:data,
                                url:'actionProcessor.jsp?action=account-sign-up',
                                success:function(data){
                                    $.unblockUI();
                                    var reply = eval('('+data+')');
                                    
                                    if(reply.status == 'success'){
                                        $('#signup-form').css("display","none");
                                        if(reply.to_amazon){
                                            $('#confirm-before-amazon-forward a').attr("href",reply.to_amazon);
                                            $('#confirm-before-amazon-forward').css("display","block");
                                        }else{
                                            $('#confirm-non-creditcard').css("display","block");
                                        }
                                    }else
                                    if(reply.exists){
                                            error = true;
                                            $('#subdomain-duplicate-error-msg').css("display","inline");
                                            $('#error-msg').css("display","block");
                                    }else{
                                            $('#unknown-error-msg').css("display","block");
                                            $('#unknown-error-msg span').text(reply.error_message);
                                    }
                                }
                            });
                    }
                    $('#signup-bnt').button().click(function(){

                        var error = false;
                        $('#error-msg,#credit-card-error').css("display","none");
                        $('#subdomain-error-msg').css("display","none");
                        $('#fullname-error-msg').css("display","none");
                        $('#emailaddress-error-msg').css("display","none");
                        $('#phone-error-msg').css("display","none");
                        $('#companyname-error-msg').css("display","none");
                        $('#companyaddress-error-msg').css("display","none");
                        $('#tos-error-msg').css("display","none");
                        $('#subdomain-duplicate-error-msg').css("display","none");
                        $('#unknown-error-msg').css("display","none");
                        
                        $('#creditCardNumber-error-msg').css("display","none");
                        $('#expirationDate-error-msg').css("display","none");
                        $('#securityCode-error-msg').css("display","none");

                        var subdomain = $('#subdomain').val();
                        if(!phyzixlabs_validate_domain_name(subdomain))
                        {
                            error = true;
                            $('#subdomain-error-msg').css("display","inline");
                        }

                        var fullname = $('#fullname').val();
                        if(fullname == '')
                        {
                            error = true;
                            $('#fullname-error-msg').css("display","inline");
                        }

                        var emailaddress = $('#emailaddress').val();
                        if(!validateEmail(emailaddress))
                        {
                            error = true;
                            $('#emailaddress-error-msg').css("display","inline");
                        }

                        var phone = $('#phone').val();
                        if(phone == "")
                        {
                            error = true;
                            $('#phone-error-msg').css("display","inline");
                        }

                        var companyname = $('#companyname').val();
                        if( companyname == '')
                        {
                            error = true;
                            $('#companyname-error-msg').css("display","inline");
                        }

                        var geozone     = $('#geozone').val();
                        var serviceplan = $('input[name=service-plan]:checked').val();
                        var paymentplan = $('input[name=payment-plan]:checked').val();
                        var paymentmethod = paymentplan=="payment-plan-yrly"?$('#payment-plan-yrly').val():"payment-type-creditcard";

                        var creditCardNumber = "";
                        var expirationMonth  = "";
                        var expirationYear   = "";
                        var securityCode     = "";  
                        if(paymentmethod == 'payment-type-creditcard'){
                            var creditCardNumber = $('#creditCardNumber').val();
                            if( creditCardNumber == '')
                            {
                                error = true;
                                $('#creditCardNumber-error-msg').css("display","inline");
                            }

                            var expirationMonth  = $('#expirationMonth').val();
                            var expirationYear   = $('#expirationYear').val();
                            if( expirationMonth == '' || expirationYear == '')
                            {
                                error = true;
                                $('#expirationDate-error-msg').css("display","inline");
                            }
                            var expirationYear = $('#expirationYear').val();
                            if( expirationYear == '')
                            {
                                error = true;
                                $('#expirationDate-error-msg').css("display","inline");
                            }


                            var securityCode = $('#securityCode').val();
                            if( securityCode == '')
                            {
                                error = true;
                                $('#securityCode-error-msg').css("display","inline");
                            }                            
                        }
                        
                        

                        var tos = $('#tos').attr("checked");
                        if( !tos)
                        {
                            error = true;
                            $('#tos-error-msg').css("display","inline");
                        }
                        if(error){
                            $('#error-msg').css("display","block");
                            return;
                        }
                        
                       var waitCount = 1;
                       var pdata = {
                                                "subdomain":subdomain,
                                                "fullname":fullname,
                                                "emailaddress":emailaddress,
                                                "phone":phone,
                                                "companyname":companyname,                                                
                                                "geozone":geozone,
                                                "service-plan":serviceplan,
                                                "payment-plan":paymentplan,
                                                "payment-method":paymentmethod}

                        $.blockUI();
                        if(paymentmethod == 'payment-type-creditcard'){
                            waitCount = 2;
                            Stripe.createToken({
		                   number:creditCardNumber,
		                   cvc:securityCode,
		                   exp_month:expirationMonth,
		                   exp_year:expirationYear},
		                   function(status,response){
                                     
		                     if(response.error){
                                         error = true;
                                         if(--waitCount == 0)
                                            $.unblockUI();
		                        $('#credit-card-error').css({"display":"block"}).html(response.error.message);
		                     }else{
                                         pdata.token = response['id'];
                                         if(--waitCount == 0 && !error){
                                            phyzixlabs_signup(pdata);
                                         }
		                     }
		                   }
		           );
                        }
                        $.ajax({
                            type:'POST',
                            data:{ "subdomain":subdomain},
                            url:'actionProcessor.jsp?action=check-domain-exists',
                            success:function(data){                          
                            try{
                                    var reply = eval('('+data+')');   
                                    
                                    if(reply.exists){
                                        error = true;
                                        if(--waitCount == 0)
                                            $.unblockUI();
                                        
                                        $('#subdomain-duplicate-error-msg').css("display","inline");
                                        $('#error-msg').css("display","block");
                                    }else{
                                       if(--waitCount == 0 && !error){
                                        phyzixlabs_signup(pdata);
                                       }
                                    }
                                }catch(ex){}
                            }
                        });
                    });
                });       
        </script>        
        
        <link type="text/css" href="css/account-signup.css" rel="stylesheet" />
        
        <style type="text/css">
            /*body {margin-left:auto;margin-right:auto;margin-top: 1px;width:1070px} style="background-color: #b0aca4;background-image:url(../img/bg_dotted.png);" */
            body {
                /*font-family: myriad-pro-condensed-1, myriad-pro-condensed-2, 'Helvetica Neue', Arial, 'Lucida Grande', sans-serif;*/
                text-align: left;
                font-size:16px;
                background: url("img/bg_dotted.png");
            }
       </style>
    </head>
    <body>
        <div style="margin-left: auto;margin-right: auto;width:80%;padding-top:40px" >
            <div style="width:164px;margin-bottom: 2px;padding:8px;background-color:#e06f13;" class="ui-corner-all" ><img src="../../img/appynote.png"/></div>
            <div  style="width:60%;padding:10px;margin-bottom: 8px" class="ui-widget-content ui-corner-all">
                <div class="ui-widget-header" style="margin-left: -10px;margin-right: -10px;margin-bottom:20px;border-left: 0px;border-right: 0px;padding: 15px">
                    <h3 style="font-size:28px;line-height: 22px">On Demand Sign Up</h3>
                </div>
                <div id="signup-form">
                Items marked * are required.<br/><br/>
                <div id="error-msg" style="display:none;padding:5px;margin-bottom:15px;border-style:solid;border-width:1px;border-color:#e6e6e6;background-color:#ffffb6">
                    <img src="sites/default/files/dialog-error.png"/>Form contains errors, please review all information.
                </div>
                
                <div id="unknown-error-msg" style="display:none;padding:5px;margin-bottom:15px;border-style:solid;border-width:1px;border-color:#e6e6e6;background-color:#ffffb6">
                    <img src="sites/default/files/dialog-error.png"/>An unknown error occurred. error message:<span style="font-weight:bold;font-style:italic"></span><br/>
                    If the problem persists, please email us: contact@appynote.com
                </div>

                <input type="hidden" value="sign-up" name="action_type"/>
                <button style="padding:5px;font-weight:bold;font-size:16px" disabled>1</button>&nbsp;&nbsp;<h1 style="display:inline;">Choose your URL </h1><br/><br/>
                <span id="subdomain-error-msg" style="color:red;font-weight:bold;display:none;text-decoration:blink">!</span>
                http://<input style="padding:3px" type="text" id="subdomain" name="subdomain"/>.appynote.com *<span id="subdomain-duplicate-error-msg" style="color:red;font-weight:bold;display:none;text-decoration:blink;font-size:12px">This url is taken, please choose another one.</span><br/>
                <span style="color:silver"><small>Your URL can contain letters, numbers, and hyphens ('-'), but it cannot start or end with a hyphen.</small> </span><br/><br/>

                <button style="padding:5px;font-weight:bold;font-size:16px" disabled>2</button>&nbsp;&nbsp;<h1 style="display:inline;">About you</h1><br/><br/>
                <small style="color:silver;">You'll be the administrator.</small>
                <table style="border-style:none;margin:0px;padding:0px">
                <tr>
                        <td style="border-style:none;padding-top:5px;padding-left:0px"><h5>Your full name:</h5> </td><td style="width:65%;border-style:none;padding-top:5px;">

                            <input style="padding:3px" size="48" type="text" id="fullname" name="fullname"/>* <span id="fullname-error-msg" style="color:red;font-weight:bold;display:none;text-decoration:blink">!</span></td>
                </tr>
                <tr>
                        <td style="border-style:none;padding-top:5px;padding-left:0px"><h5>Your email address:</h5> </td><td style="border-style:none;padding-top:5px;">

                            <input style="padding:3px" size="48" type="text" id="emailaddress" name="emailaddress"/>* <span id="emailaddress-error-msg" style="color:red;font-weight:bold;display:none;text-decoration:blink">!</span></td>
                </tr>

                <tr>
                        <td style="border-style:none;padding-top:5px;padding-left:0px"><h5>Your phone number:</h5> </td><td style="border-style:none;padding-top:5px;">

                            <input style="padding:3px" size="48" type="text" id="phone" name="phone"/>* <span id="phone-error-msg" style="color:red;font-weight:bold;display:none;text-decoration:blink">!</span></td>
                </tr>
                <tr>
                        <td style="border-style:none;padding-top:5px;padding-left:0px"><h5>Company / Organization:</h5> </td><td style="border-style:none;padding-top:5px;">

                            <input style="padding:3px" size="48" type="text" id="companyname" name="companyname"/>* <span id="companyname-error-msg" style="color:red;font-weight:bold;display:none;text-decoration:blink">!</span></td>
                </tr>
                <tr>
                        <td style="border-style:none;padding-top:5px;padding-left:0px"><h5>Service Area:</h5><small style="color:silver">(where would this service be primarily accessed from ?)</small> </td>
                    <td style="border-style:none;padding-top:5px;">
                        <select id="geozone" name="geozone">
                            <option value="us-east">US East</option>
                            <option value="us-west">US West</option>
                            <option value="eu">Europe</option>
                            <option value="asia">Asia</option>
                        </select> *
                    </td>
                </tr>
                </table>
                <br/>
                <br/>

                <button style="padding:5px;font-weight:bold;font-size:16px" disabled>3</button><h1 style="display:inline;">&nbsp;&nbsp;Choose your plan</h1><br/><br/>
                <small style="color:silver">Choose one</small>
                <table>
                <thead>
                    <tr>
                        <th></th><th style="padding:10px">Monthly Cost</th><th style="padding:3px;">Yearly Cost <span style="background-color:#de8787;padding:1px;border-style:solid;border-width:1px;font-weight:bold">Huge Discount!<span></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:3px"><input type="radio" name="service-plan" value="service-plan-small" checked/>Small Team (25 users)</td><td style="padding:3px">$250</td><td>$2750</td>
                    </tr>
                    <tr>
                        <td style="padding:3px"><input type="radio" name="service-plan" value="service-plan-medium"/>Medium Team (50 users)</td><td style="padding:3px">$350</td><td>$4000</td>
                    </tr>
                    <tr>
                        <td style="padding:3px"><input type="radio" name="service-plan" value="service-plan-large" checked/>Large Team (250 users)</td><td style="padding:3px">$2,000</td><td>$20,000</td>
                    </tr>
                    <tr>
                        <td style="padding:3px"><input type="radio" name="service-plan" value="service-plan-unlimited"/>Unlimited</td><td style="padding:3px">$25,000</td><td>$275,000</td>
                    </tr>                    
                </tbody>
                </table>
                <small style="color:silver">*user limit represents concurrent usage, there is no limit to actual number of active user accounts.</small>
                <br/><br/>

                <button style="padding:5px;font-weight:bold;font-size:16px" disabled>4</button><h1 style="display:inline;"> Billing information</h1> <br/><br/>
                <h3>How would you like to pay?</h3>
                <small style="color:silver">Choose one</small><br/>
                <div style="padding-left:10px">
                    <input style="margin-left:0px" type="radio" name="payment-plan" value="payment-plan-monthly" checked/>Charge my credit card automatically every month. <br/>
                    <input style="margin-left:0px" type="radio" name="payment-plan" value="payment-plan-yrly"/>Prepay one year via
                    <select id="payment-plan-yrly" name="payment-plan-yrly">
                        <option value="payment-type-creditcard">Credit Card</option>
                        <option value="payment-type-purchaseorder">Purchase Order</option>
                        <option value="payment-type-check">Check</option>
                    </select>
                </div><br/>

                <div id="payment-information-form">
                    <div id="credit-card-error" style="display:none;padding:5px;margin-bottom:15px;" class="ui-state-error ui-state-error-text"></div>
                    <h3 style="display:inline">Credit Card Information</h3><br/>
                    <table style="border:none">
                        <tr>
                                <td style="border-style:none;padding-top:5px;padding-left:0px"><h5>Card Number:</h5> </td><td style="border-style:none;padding-top:5px;">

                                    <input style="padding:3px" size="48" type="text" id="creditCardNumber" name="creditCardNumber"/>* <span id="creditCardNumber-error-msg" style="color:red;font-weight:bold;display:none;text-decoration:blink">!</span></td>
                        </tr>     
                        <tr>
                                <td style="border-style:none;padding-top:5px;padding-left:0px"><h5>Expiration Date:</h5> </td><td style="border-style:none;padding-top:5px;">

                                    <input style="padding:3px" size="2" type="text" id="expirationMonth" name="expirationMonth"/>/<input style="padding:3px" size="4" type="text" id="expirationYear" name="expirationYear"/>* <span id="expirationDate-error-msg" style="color:red;font-weight:bold;display:none;text-decoration:blink">!</span></td>
                        </tr>             
                        <tr>
                                <td style="border-style:none;padding-top:5px;padding-left:0px"><h5>Security Code:</h5> </td><td style="border-style:none;padding-top:5px;">

                                    <input style="padding:3px" size="6" type="text" id="securityCode" name="securityCode"/>* <img src="img/cvc.png"/><span id="securityCode-error-msg" style="color:red;font-weight:bold;display:none;text-decoration:blink">!</span></td>
                        </tr>             
                    </table>
                </div>

                <button style="padding:5px;font-weight:bold;font-size:16px" disabled>5</button><h1 style="display:inline;">&nbsp;&nbsp;Sign Up</h1><br/><br/>
                <span id="tos-error-msg" style="color:red;font-weight:bold;display:none;text-decoration:blink">!</span>
                <input type="checkbox" id="tos" name="tos"/>Yes, I accept the <a href="http://www.appynote.com/terms/" target="_blank">Terms of Service</a> *<br/>
                <div style="text-align:center">
                <button style="padding:5px;font-weight:bold;font-size:16px"  id="signup-bnt">Sign Up</button>
                </div>
                </div>
                <div id="confirm-before-amazon-forward" style="display:none;text-align:center">
                    <h2>Thank you. To complete sign up you'll now be forwarded to Amazon.com our payment processor to process your credit card payment information.</h2>
                    <a href=""><img id="continue-btn" src="sites/default/files/continue-btn.png" style="border-style:none"/></a>
                </div>
                <div id="confirm-non-creditcard" style="display:none;text-align:center">
                    <h2>Thank you! You'll soon receive an email from a sales person to finalize sign up.</h2>   
                </div>
            </div>
        </div>
    </body>
</html>
