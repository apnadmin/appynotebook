<div id="image-dialog" title="Add Image" style="display:none">
    <table>
        <tr>
            <td>Url:</td><td><input type="text" id="image-module-image-url"/></td>
        </tr>
        <tr class="image-dialog-hide-row">
            <td colspan="2" style="text-align:center">--OR--</td>
        </tr>
        <tr class="image-dialog-hide-row">
            <td>Upload:</td><td><iframe id="imageUploadInterface" name="imageUploadInterface" src="export-handlers/image-uploader.jsp" width="300" height="30" scrolling="no" frameborder="no"></iframe></td>
        </tr>
        <!--
        <tr>
            <td>Link:</td><td><input type="text" id="image-module-image-link"/></td>
        </tr>
        -->
        <tr>
            <td>Width:</td><td><input type="text" size="4" id="image-module-image-width"/>px</td>
        </tr>
        <tr>
            <td>Height:</td><td><input type="text" size="4" id="image-module-image-height"/>px</td>
        </tr>
    </table>
</div>

<div id="create-room-dialog" title="Add Group" style="display:none;">
    <table style="border-width:1px;border-color:#f6f6f6">
        <tr>
            <td class="signup-label">Group Title*:</td><td><input type="text" name="roomLabel" id="roomLabel" /></td>
        </tr>
    </table>
</div>

<div id="book-dialog" style="display:none" title="Binder Title">
    <table>
        <tr>
            <td>Title:</td><td><input type="text" id="work-book-title"/></td>
        </tr>
    </table>
    <input type="hidden" id="work-book-title-pid"/>
    <input type="hidden" id="work-book-title-context-id"/>
</div>

<div id="page-title-dialog" style="display:none" title="Page Title">
    <table>
        <tr>
            <td>Title:</td><td><input type="text" id="page-title"/></td>
        </tr>
        <tr>
            <td colspan="2">
                <fieldset>
                    <legend>Position</legend>
                    <table>
                        <tr>
                            <td><input type="radio" name="page_position" value="before"/></td><td>Before</td>
                        </tr>
                        <tr>
                            <td><input type="radio" name="page_position" value="append"/></td><td>Append</td>
                        </tr>
                        <tr>
                            <td><input type="radio" name="page_position" value="after"/></td><td>After</td>
                        </tr>        
                        <tr>
                            <td><input type="radio" name="page_position" value="bottom" checked/></td><td>Bottom</td>
                        </tr>    
                    </table>                    
                </fieldset>    
            </td>
        </tr>
    </table>
    <input type="hidden" id="page-title-pid"/>
    <input type="hidden" id="page-title-context-id"/>
    <input type="hidden" id="page-title-page-id"/>
</div>

<div id="room-title-dialog" style="display:none" title="Group Name">
    <table>
        <tr>
            <td><input type="text" id="room-title-textfield"/></td>
        </tr>
    </table>
</div>



<div id="about-dialog" title="About Hadron<sup>TM</sup>" style="display:none">
    <p style="text-align:center;background-image:url(../../favicon.png);background-repeat:no-repeat">
         Hadron<sup>TM</sup>, v1.2.1<br/><br/>
        Copyright © 2011. All Rights Reserved, Phyzixlabs Software
    </p>
</div>


<div id="new-participant-dialog" title="New Participant" style="display:none">
    <table>
            <tr>
                <td>Name:</td><td><input type="text" name="fullName" id="fullName"></td>
            </tr>
            <tr>
                <td>E-mail:</td><td><input type="text" name="emailAddress" id="emailAddress"></td>
            </tr>
    </table>
</div>


<div id="access-grant-dialog" title="Grant Access">
    <table>
        <tr>
            <td>
                <table id="context-access-control-list" class="scroll" cellpadding="0" cellspacing="0"></table>
                <div id="context-access-control-list-pager" class="scroll" style="text-align:center;"></div>
            </td>
            <td>
                <table id="page-access-control-list" class="scroll" cellpadding="0" cellspacing="0"></table>
                <div id="page-access-control-list-pager" class="scroll" style="text-align:center;"></div>
            </td>
        </tr>
    </table>
    <input type="hidden" id="grant-to-pid-id"/>
</div>

<div id="load-users-dialog" title="Load Users" style="display:none;">
    <iframe id="loadUsersInterface"  name="loadUsersInterface" src="../appbuilder/add-users.jsp" width="400" height="140" scrolling="no"  frameborder="no"></iframe>
</div>

<div id="embed-code-dialog" title="Embed Code" style="display:none">
    Size:<input type="text" size="3" id="phyzixlabs-embed-code-width"/>x<input type="text" size="3" id="phyzixlabs-embed-code-height"/> (px)<br>
    Copy and past this code to your web page:
    <textarea  id="phyzixlabs-embed-code" cols="32" rows="5"></textarea>
</div>

<div id="page-url-dialog" title="Page URL" style="display:none">
    <input type="text" size="48" id="phyzixlabs-page-url" readonly/>
</div>

<div id="file-upload-dialog" title="Import" style="display:none">
    <iframe id="fileUploadInterface" name="fileUploadInterface" src="export-handlers/file-uploader.jsp" width="300" height="60" scrolling="no" frameborder="no"></iframe>
</div>

<div id="assignment-dialog" style="display:none" title="Task Definition">
    <table>
        <tr>
            <td style="text-align:right">
                Title:
            </td>
            <td>
                <input type="text" id="assignment-title"/>
            </td>
        </tr>


        <tr>
            <td colspan="2">                
                <div class="ui-widget-header ui-corner-all" style="padding:2px"> Submission Time Window</div>
            </td>
        </tr>


        <tr>
            <td style="text-align:right">
                Time Zone:
            </td>
            <td>
                <select id="assignment-timezone" style="">
                  <%= com.feezixlabs.util.ConfigUtil.timezone_list %>
                </select>
            </td>
        </tr>
        <tr>
            <td style="text-align:right">
                Open Time:
            </td>
            <td>
                <input type="text" id="assignment-open-time"/>
            </td>
        </tr>
        <tr>
            <td style="text-align:right">
                Close Time:
            </td>
            <td>
                <input type="text" id="assignment-close-time"/>
            </td>
        </tr>

        <tr>
            <td colspan="2">
               <div class="ui-widget-header ui-corner-all" style="padding:2px">Submission Versioning</div>
            </td>
        </tr>
        <tr>
            <td style="text-align:right">
                Allow Versioning:
            </td>
            <td>
                <input type="checkbox" value="yes" id="assignment-allow-versioning" size="2"/>
            </td>
        </tr>
        <tr>
            <td style="text-align:right">
                Limit:
            </td>
            <td>
                <input size="4" type="text" id="assignment-versioning-limit"/>
            </td>
        </tr>

        <tr>
            <td colspan="2">
                <div class="ui-widget-header ui-corner-all" style="padding:2px"> Submission Reminder</div>
            </td>
        </tr>
        <tr>
            <td style="text-align:right">
                First Reminder:
            </td>
            <td>
                <input type="text" id="assignment-first-reminder-time"/>
            </td>
        </tr>
        <tr>
            <td style="text-align:right">
                Repeat Interval:
            </td>
            <td>
                <input type="text" id="assignment-reminder-repeat-interval-days" size="2"/><span style="font-size:10px;color:silver;font-weight:bold">(days)</span>-<input size="4" type="text" id="assignment-reminder-repeat-interval"/><span style="font-size:10px;color:silver;font-weight:bold">(h:m)</span>
            </td>
        </tr>
        <tr>
            <td style="text-align:right">
                Repeat Count:
            </td>
            <td>
                <input type="text" size="2" id="assignment-reminder-repeat-count"/>
            </td>
        </tr>
    </table>
    <input type="hidden" id="assignment-id"/>
</div>


<div id="assignment-list-dialog" title="Select" style="display:none">
    <select id="available-assignment-list">

    </select>
</div>

<div id="assignment-submission-list-dialog" title="Overwrite" style="display:none">
    <p id="available-assignment-submission-message">

    </p>
    <select id="available-assignment-submission-list">

    </select>
</div>


<div id="distribute-content-dialog" title="Users">
    <table>
        <tr>
            <td>
                <table id="distribute-content-users-list" class="scroll" cellpadding="0" cellspacing="0"></table>
                <div id="distribute-content-users-list-pager" class="scroll" style="text-align:center;"></div>
            </td>
        </tr>
    </table>
</div>


<div id="account-upgrade-dialog" title="Upgrade" style="display:none">
    <h3 style="text-align:center">No contracts <span style="color:#6299c5">*</span> <span style="color:#FECA40">No setup fees</span> <span style="color:#6299c5">*</span> Cancel anytime</h3>

    <div id="account-upgrade-dialog-perform-page">
        <div id="account-upgrade-breadcrumb" class="ui-corner-all ui-widget-header" style="padding:8px">
            <span id="account-upgrade-breadcrumb-home"><span style="float:left" class="ui-icon ui-icon-home"></span><span id="account-upgrade-breadcrumb-home-active">Available Plans</span><a id="account-upgrade-breadcrumb-home-inactive" href="#">Available Plans</a></span>
            <span id="account-upgrade-breadcrumb-payment-info"> >> <span id="account-upgrade-breadcrumb-payment-info-active">Payment information</span><a id="account-upgrade-breadcrumb-payment-info-inactive" href="#">Payment information</a></span>
        </div>


        <div id="account-upgrade-page1">
            <%--
                com.feezixlabs.bean.Feature priceFeature = null;
                java.util.List<com.feezixlabs.bean.Feature> features = com.feezixlabs.db.dao.MiscDAO.getFeatureMatrix();
                for(com.feezixlabs.bean.Feature feature:features){
                    if(feature.getName().compareToIgnoreCase("price") == 0){
                        priceFeature = feature;break;
                    }
                }
            %>
            <table>
                <tr>
                    <th></th>
                    <th style="text-align:center">Individual <br/><span>(<%=priceFeature.getIndividualPlanLimitDisplayText() %>)</span></th>
                    <th style="text-align:center">Team <br/><span>(<%=priceFeature.getTeamPlanLimitDisplayText() %>)</span></th>
                </tr>
                <%
                    int color = 0;
                    for(com.feezixlabs.bean.Feature feature:features){
                        if(feature.getDisplay().compareToIgnoreCase("no") == 0)continue;
                        String individual = feature.getIndividualPlanLimitDisplayText();
                        String team = feature.getTeamPlanLimitDisplayText();

                        if(feature.getIndividualPlanLimit().compareToIgnoreCase("Yes") == 0)
                            individual = "<img src=\"../../img/check.png\"/>";
                        else
                        if(feature.getIndividualPlanLimit().compareToIgnoreCase("N/A") == 0)
                            individual = "<img src=\"../../img/button_cancel.png\"/>";

                        if(feature.getTeamPlanLimit().compareToIgnoreCase("Yes") == 0)
                            team = "<img src=\"../../img/check.png\"/>";
                        else
                        if(feature.getTeamPlanLimit().compareToIgnoreCase("N/A") == 0)
                            team = "<img src=\"../../img/button_cancel.png\"/>";
                %>
                <tr class="<%= color++%2==0?"ui-state-highlight":"" %>">
                    <td style="padding:8px;text-align:right;font-weight: bold"><%=feature.getDisplayText() %></td><td style="text-align:center"><%= individual %></td><td style="text-align:center"><%=team %></td>
                </tr>
                <%}%>
                <tr>
                    <td></td><td style="text-align:center"><button id="upgrade-btn-individual">Upgrade</button></td><td style="text-align:center"><button id="upgrade-btn-team">Upgrade</button></td>
                </tr>
            </table>
                --%>
        </div>

        <div id="account-upgrade-page2" style="display:none">
            <div id="credit-card-error" style="display:none;padding:4px;margin-bottom: 2px;margin-top: 2px;" class="ui-state-error ui-corner-all"></div>
            <table>
                <tr>
                    <td style="width:200px;font-weight: bold;vertical-align: top;padding:8px;border: none;text-align: right" class="ui-state-highlight">
                        Monthly charge
                    </td>
                    <td>
                        <span id="account-upgrade-monthly-charge" style="font-weight:bold"></span>
                    </td>
                </tr>
                <tr class="team-size-row">
                    <td style="font-weight: bold;vertical-align: top;padding:8px;border: none;text-align: right" class="ui-state-highlight">
                        Team Size <span style="color:red">*</span>
                    </td>
                    <td>
                        <select id="account-upgrade-dialog-team-plan-size">
                            <%
                                for(int i=2;i<150;i++){
                            %><%= "<option value=\""+i+"\">"+i+"</option>"%><%}%>
                        </select>
                    </td>
                </tr>
                <tr id="account-upgrade-dialog-current-payment-information-page" style="display:none">
                    <td class="ui-state-highlight" style="font-weight: bold;vertical-align: top;padding:8px;border: none;text-align: right">
                        Current Payment Information
                    </td>
                    <td>
                        <table>
                            <tr>
                                <td>Number:</td><td><span id="account-upgrade-dialog-display-credit-card-last4-number"></span></td><td><button id="account-upgrade-dialog-change-credit-card-button" style="float:right">Change</button></td>
                            </tr>
                            <tr>
                                <td>Expires:</td><td><span id="account-upgrade-dialog-display-credit-card-expiration-date"></span></td><td></td>
                            </tr>
                            <tr>
                                <td>Type:</td><td><span id="account-upgrade-dialog-display-credit-card-type"></span></td><td></td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr id="account-upgrade-dialog-new-payment-information-page" style="display:none">
                    <td class="ui-state-highlight" style="font-weight: bold;vertical-align: top;padding:8px;border: none;text-align: right">
                        Credit Card <span style="color:red">*</span><br/>
                        <img src="../../img/tinylock.png"/> <span style="font-size:8px;font-weight: bold;color: grey">Secure</span>
                    </td>
                    <td>
                        <table>
                            <%--
                            <tr>
                                <td colspan="2">
                                    Cardholder Name
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <input type="text" id="credit-card-cardholder-name"/>
                                </td>
                            </tr>
                            --%>
                            <tr>
                                <td>
                                    <span class="error-blinkable" id="account-upgrade-dialog-credit-card-number-label">Credit Card Number</span>
                                </td>
                                <td>
                                    <button id="account-upgrade-dialog-dont-change-credit-card-button" style="display:none">Use current payment information</button>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <input size="16" type="text" id="account-upgrade-dialog-credit-card-number"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="error-blinkable" id="account-upgrade-dialog-credit-card-expiration-month-label">Expiration (Month/Year)</span>
                                </td>
                                <td>
                                    <span class="error-blinkable" id="account-upgrade-dialog-credit-card-security-code-label">Security Code</span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <select id="account-upgrade-dialog-credit-card-expiration-month">
                                        <option value=""></option>
                                        <option value="01" >01 &middot; Jan</option>

                                        <option value="02" >02 &middot; Feb</option>
                                        <option value="03" >03 &middot; Mar</option>
                                        <option value="04" >04 &middot; Apr</option>
                                        <option value="05" >05 &middot; May</option>
                                        <option value="06" >06 &middot; Jun</option>

                                        <option value="07" >07 &middot; Jul</option>
                                        <option value="08" >08 &middot; Aug</option>
                                        <option value="09" >09 &middot; Sep</option>
                                        <option value="10" >10 &middot; Oct</option>
                                        <option value="11" >11 &middot; Nov</option>

                                        <option value="12" >12 &middot; Dec</option>
                                    </select> /
                                    <select id="account-upgrade-dialog-credit-card-expiration-year">
                                        <option></option>
                                        <option value="2012">2012</option>
                                        <option value="2013">2013</option>
                                        <option value="2014">2014</option>

                                        <option value="2015">2015</option>
                                        <option value="2016">2016</option>
                                        <option value="2017">2017</option>
                                        <option value="2018">2018</option>
                                        <option value="2019">2019</option>
                                        <option value="2020">2020</option>
                                        <option value="2021">2021</option>
                                        <option value="2022">2022</option>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" size="6" id="account-upgrade-dialog-credit-card-security-code"/> <img src="../../img/cvc.png"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <%--
                <tr>
                    <td>
                        Billing Address *
                    </td>
                    <td>
                        <table>
                            <tr>
                                <td colspan="2">
                                    Street Address
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <input type="text" id="credit-card-street-address"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    City
                                </td>
                                <td>
                                    Postal / Zip Code
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="text" id="credit-card-city-address"/>
                                </td>
                                <td>
                                    <input type="text" id="credit-card-zipcode-address"/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    Country
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <select id="credit-card-country-address">
                                        <%@include  file="countries.jsp" %>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                --%>
                <tr>
                    <td class="ui-state-highlight" style="font-weight: bold;vertical-align: top;padding:8px;border: none;text-align: right">
                        Read & Agree <span style="color:red">*</span>
                    </td>
                    <td>
                        <input type="checkbox" id="account-upgrade-dialog-credit-card-tos"/> <span class="error-blinkable" id="account-upgrade-dialog-credit-card-tos-label">I agree to APPYnote's <a href="http://www.appynote.com/terms/" target="_blank">Terms of Service</a>.</span>
                    </td>
                </tr>
                <tr>
                    <td  colspan="2" style="text-align:center"><button id="upgrade-signup-btn">Sign-Up</button></td>
                </tr>
            </table>
        </div>
    </div>
    <div id="account-upgrade-dialog-confirm-page" style="display:none">
        <h1>Thank you!</h1>
        <span id="account-upgrade-dialog-confirm-page-msg"></span>
        <div style="text-align:center">
            <button id="account-upgrade-dialog-confirm-page-close-button">Close</button>
        </div>
    </div>
</div>



<div id="account-plan-update-dialog" title="Plan Update" style="display:none">
    <h3 style="text-align:center">No contracts <span style="color:#6299c5">*</span> <span style="color:#FECA40">No setup fees</span> <span style="color:#6299c5">*</span> Cancel anytime</h3>   
    <div id="account-plan-update-dialog-perform-page">
        <div id="account-plan-update-dialog-credit-card-error" style="display:none;padding:4px" class="ui-state-error ui-corner-all"></div>
        <table>
            <tr>
                <td style="width:200px;font-weight: bold;vertical-align: top;padding:8px;border: none;text-align: right" class="ui-state-highlight">
                    Monthly charge
                </td>
                <td>
                    <span id="account-plan-update-monthly-charge" style="font-weight:bold"></span>
                </td>
            </tr>
            <tr id="account-plan-update-dialog-team-size-row">
                <td style="font-weight: bold;vertical-align: top;padding:8px;border: none;text-align: right" class="ui-state-highlight">
                    Team Size <span style="color:red">*</span>
                </td>
                <td>
                    <select id="account-plan-update-dialog-team-plan-size">
                        <%
                            for(int i=2;i<150;i++){
                        %><%= "<option value=\""+i+"\">"+i+"</option>"%><%}%>
                    </select>
                </td>
            </tr>
            <tr id="account-plan-update-dialog-current-payment-information-page" style="display:none">
                <td style="font-weight: bold;vertical-align: top;padding:8px;border: none;text-align: right" class="ui-state-highlight">
                    Current Payment Information
                </td>
                <td>
                    <table>
                        <tr>
                            <td>Number:</td><td><span id="display-credit-card-last4-number"></span></td><td><button id="change-credit-card-button" style="float:right">Change</button></td>
                        </tr>
                        <tr>
                            <td>Expires:</td><td><span id="display-credit-card-expiration-date"></span></td><td></td>
                        </tr>
                        <tr>
                            <td>Type:</td><td><span id="display-credit-card-type"></span></td><td></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr id="account-plan-update-dialog-new-payment-information-page" style="display:none;">
                <td style="font-weight: bold;vertical-align: top;padding:8px;border: none;text-align: right" class="ui-state-highlight">
                    Credit Card <span style="color:red">*</span><br/>
                    <img src="../../img/tinylock.png"/> <span style="font-size:8px;font-weight: bold;color: grey">Secure</span>
                </td>
                <td>
                    <table>
                        <%--
                        <tr>
                            <td>
                                Cardholder Name
                            </td>
                            <td>
                                <button id="dont-change-credit-card-button" style="float:right;display:none">Use current payment information</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="text" id="account-plan-update-dialog-credit-card-cardholder-name"/>
                            </td>
                        </tr>
                        --%>
                        <tr>
                            <td colspan="2">
                                <span class="error-blinkable1" id="account-plan-update-dialog-credit-card-number-label">Credit Card Number</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input size="16" type="text" id="account-plan-update-dialog-credit-card-number"/>
                            </td>
                            <td>
                                <button id="dont-change-credit-card-button" style="display:none">Use current payment information</button>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="error-blinkable1" id="account-plan-update-dialog-credit-card-expiration-month-label">Expiration (Month/Year)</span>
                            </td>
                            <td>
                                <span class="error-blinkable1" id="account-plan-update-dialog-credit-card-security-code-label">Security Code</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <select id="account-plan-update-dialog-credit-card-expiration-month">
                                    <option value=""></option>
                                    <option value="01" >01 &middot; Jan</option>

                                    <option value="02" >02 &middot; Feb</option>
                                    <option value="03" >03 &middot; Mar</option>
                                    <option value="04" >04 &middot; Apr</option>
                                    <option value="05" >05 &middot; May</option>
                                    <option value="06" >06 &middot; Jun</option>

                                    <option value="07" >07 &middot; Jul</option>
                                    <option value="08" >08 &middot; Aug</option>
                                    <option value="09" >09 &middot; Sep</option>
                                    <option value="10" >10 &middot; Oct</option>
                                    <option value="11" >11 &middot; Nov</option>

                                    <option value="12" >12 &middot; Dec</option>
                                </select> /
                                <select id="account-plan-update-dialog-credit-card-expiration-year">
                                    <option></option>
                                    <option value="2012">2012</option>
                                    <option value="2013">2013</option>
                                    <option value="2014">2014</option>

                                    <option value="2015">2015</option>
                                    <option value="2016">2016</option>
                                    <option value="2017">2017</option>
                                    <option value="2018">2018</option>
                                    <option value="2019">2019</option>
                                    <option value="2020">2020</option>
                                    <option value="2021">2021</option>
                                    <option value="2022">2022</option>
                                </select>
                            </td>
                            <td>
                                <input type="text" size="6" id="account-plan-update-dialog-credit-card-security-code"/> <img src="../../img/cvc.png"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%--
            <tr>
                <td>
                    Billing Address *
                </td>
                <td>
                    <table>
                        <tr>
                            <td colspan="2">
                                Street Address
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="text" id="credit-card-street-address"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                City
                            </td>
                            <td>
                                Postal / Zip Code
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="text" id="credit-card-city-address"/>
                            </td>
                            <td>
                                <input type="text" id="credit-card-zipcode-address"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                Country
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <select id="credit-card-country-address">
                                    <%@include  file="countries.jsp" %>
                                </select>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            --%>
            <tr>
                <td style="font-weight: bold;vertical-align: top;padding:8px;border: none;text-align: right" class="ui-state-highlight">
                    Read & Agree <span style="color:red">*</span>
                </td>
                <td>
                    <input type="checkbox" id="account-plan-update-dialog-credit-card-tos"/> <span class="error-blinkable1" id="account-plan-update-dialog-credit-card-tos-label">I agree to APPYnote's <a href="http://www.appynote.com/terms/" target="_blank">Terms of Service</a>.</span>
                </td>
            </tr>
        </table>
        <div style="text-align:center">
            <button id="change-plan-submit-button">Submit</button>
        </div>
    </div>
    <div id="account-plan-update-dialog-confirm-page" style="display:none">
        <h1>Thank you!</h1>
        <span id="account-plan-update-dialog-confirm-page-msg"></span>
        <div id="text-align:center">
            <button id="account-plan-update-dialog-confirm-page-close-button">Close</button>
        </div>
    </div>
</div>
            
<div id="dialog-confirm-page-move" style="display:none">
    Select type of move.
</div>            
            
            
<div id="ebook-package-dialog" style="display:none">
    <table>
        <tr>
            <td style="text-align: right">Document Content Only:</td>
            <td> <input type="checkbox" id="ebook-package-binder-doc-only"/></td>
        </tr>
        <tr>
            <td style="text-align: right">Zip file name:</td>
            <td>
                <input type="text" id="ebook-package-binder-zip-name"/>
            </td>
        </tr>
        <tr>
            <td style="text-align: right">UUID:</td>
            <td>
                <input type="text" id="ebook-package-binder-uuid"/>
            </td>
        </tr>        
    </table>
    <div id="ebook-package-tabcontrol">
        <ul>
            <li>
                <a href="#ebook-package-binder-tab">Binders</a>
            </li>
            <li>
                <a href="#ebook-package-app-tab">Include Apps</a>
            </li>
        </ul>
        <div id="ebook-package-binder-tab" style="padding:0px;padding-top:2px">            
            <table id="ebook-package-binder-list"></table>
        </div>
        <div id="ebook-package-app-tab" style="padding:0px;padding-top:2px">
            <table id="ebook-package-app-list"></table>
        </div>
    </div>
</div>            
            
<div id="plan-cancel-dialog" title="Confirm Plan Cancellation" style="display:none">
    Are you sure you want to cancel your plan?
</div>
            
<div id="plan-upgrade-prompt-dialog" title="Upgrade" style="display:none">
    <span id="plan-upgrade-prompt-dialog-msg"></span>
</div>
            
<div id="back-end-error-dialog" title="Error" style="display:none">
    <h1 class="ui-state-error ui-state-error-text"><span style="float:left" class="ui-icon ui-icon-alert"></span>Opps! Something bad happened...Please give it another shot</h1>
    <span id="back-end-error-dialog-msg"></span>
</div>

<div id="app-store-dialog" title="App Store" style="display:none">
    <iframe id="appStoreInterface"  name="appStoreInterface" src="../../app-store/index.jsp" width="100%" height="140" scrolling="no"  frameborder="no"></iframe>
</div>

<div id="user-settings-dialog" title="Settings" style="display:none">
    <%@include  file="user-settings.jsp"%>
</div>